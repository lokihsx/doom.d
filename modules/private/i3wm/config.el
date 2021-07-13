;;; private/i3wm/config.el -*- lexical-binding: t; -*-

(use-package! i3
  :load-path "./")

(use-package! i3-integration
  :load-path "./")

(defun i3wm/follow-focus (&optional win)
  (interactive (i3-tar-window-choice))
  (unless (get-buffer "*FollowFocus*")
    (let* ((cur-workspace (i3-field 'name (car (i3-get-current-visible-workspaces))))
           (tar-workspace (i3-field 'name (car (i3-get-other-visible-workspaces))))
           (next-workspace (i3-get-next-workspace))
           (tar-win-ids (i3-get-windows-ids-by-workspaces (list tar-workspace)))
           (choice-win-id (car (i3-get-window-id-by-name win)))
           (unchoice-win-ids (delq choice-win-id (-difference tar-win-ids (list choice-win-id))))
           (move-cmd "\"[id=%s]\" move to workspace %s")
           (frame (make-frame))
           (cur-frame-id (frame-parameter (selected-frame) 'outer-window-id))
           (new-frame-id (frame-parameter frame 'outer-window-id))
           ;; (on-pm-win (persp-parameter 'on-pm-win))
           (need-delete '()))
      ;; for origin frame
      (modify-frame-parameters (selected-frame) (list (cons 'follow-focus-window-origin-config (current-window-configuration))))
      ;; (mapcar (lambda (win) (when win (delete-window win)))
      ;;         on-pm-win)
      (dolist (win (window-list))
        (when (window-dedicated-p win)
          (cond ((eq win (treemacs-get-local-window))
                 (treemacs-quit))
                ((get-buffer-process (buffer-name))
                 (vterm-send-C-d)))
          (delete-window win)))

      (if (> (length (window-list (selected-frame))) 1)
          (progn
            (setq need-delete
                  (mapcar (lambda (win) (when (eq (get-buffer-window) win) win)) (window-list)))
            (mapcar (lambda (win) (when win (delete-window win))) need-delete))
        (switch-to-prev-buffer))

      ;; for new frame
      (select-frame frame)
      (modify-frame-parameters frame (list (cons 'follow-focus-origin-window cur-frame-id)))
      (modify-frame-parameters frame (list (cons 'follow-focus-windows tar-win-ids)))
      (modify-frame-parameters frame (list (cons 'follow-focus-workspace tar-workspace)))
      (follow-mode t)
      (split-window-right)
      (beginning-of-line)
      (recenter-top-bottom)

      ;; window move
      (start-process-shell-command "Yeah" "*FollowFocus*"
                                   (concat
                                    "i3-msg "
                                    (format move-cmd choice-win-id cur-workspace)
                                    ", resize grow width 350px"
                                    ","
                                    (mapconcat 'identity (mapcar (lambda (x) (format move-cmd x next-workspace)) unchoice-win-ids) ",")
                                    ","
                                    (format move-cmd new-frame-id tar-workspace)
                                    ","
                                    (format "\"[id=%s]\" focus" cur-frame-id)
                                    ","
                                    (format "\"[id=%s]\" focus" new-frame-id))))))

(defun i3wm/undo-follow-focus ()
  (interactive)

  (let ((win-ids (frame-parameter (selected-frame) 'follow-focus-windows))
        (origin-id (frame-parameter (selected-frame) 'follow-focus-origin-window))
        (move-cmd (concat "\"[id=%s]\" move to workspace "
                          (frame-parameter (selected-frame) 'follow-focus-workspace))))
    (if (> (length win-ids) 0)
        (progn
          (follow-mode 0)
          (delete-frame)
          (set-process-sentinel
           (start-process-shell-command "Oh" "*FollowFocus*"
                                        (format "i3-msg %s, %s"
                                                (mapconcat 'identity (mapcar (lambda (x) (format move-cmd x)) win-ids) ",")
                                                "\"[class=Emacs]\" focus"))
           (lambda (p e)
             (when (= 0 (process-exit-status p))
               (set-window-configuration (frame-parameter (selected-frame) 'follow-focus-window-origin-config))
               (kill-buffer "*FollowFocus*")))))
      (message "Can't close main Frame!"))))

(defun move-integration-i3 (direct)
  (condition-case ex
      (progn
        (eval (list (intern (format "evil-window-%s" direct)) 1))
        (beacon-blink))
    ('error
     (start-process-shell-command "i3" nil (format "i3-msg focus %s" direct)))))
       ;; (when (and (eq cur-id (car (i3-get-current-window-id)))
       ;;            (string= direct "right"))
       ;;   (start-process-shell-command "i3" nil (format "xdotool key ctrl+alt+2" direct)))
