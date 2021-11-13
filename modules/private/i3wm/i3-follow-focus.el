;;; private/i3wm/follow-focus.el -*- lexical-binding: t; -*-

(require 'i3)
(require 'i3-integration)

(defcustom output-screens
  `("HDMI-0" "DP-0" "DP-2")
  "target frame outpue screens"
  :type 'list)

(defcustom primary-screen
  2
  "primary screen"
  :type 'integer)

(defcustom workspaces-count-per-output 10
  "workspaces-count"
  :type 'integer)

(defvar move-cmd "\"[id=%s]\" move to workspace %s")

(defun i3/get-current-workspace-by-output (output)
  (car
   (i3-map-and-filter
    (lambda (x)
      (when (string= (i3-field 'name x) output)
        (i3-field 'current_workspace x)))
    (i3-get-outputs))))

(defun i3/get-available-workspaces-by-output (output)
  (let* ((current-workspace (string-to-number
                             (i3/get-current-workspace-by-output output)))
         (range-base (* (/ current-workspace workspaces-count-per-output)
                        workspaces-count-per-output))
         (range-start (if (eq (% current-workspace workspaces-count-per-output) 0)
                          (1+ (- range-base workspaces-count-per-output))
                        (1+ range-base)))
         (range-end (if (eq (% current-workspace workspaces-count-per-output) 0)
                        range-base
                      (* (1+ (/ current-workspace workspaces-count-per-output))
                         workspaces-count-per-output))))
    (mapcar #'number-to-string (number-sequence range-start range-end))))

(defun i3/get-empty-workspaces-by-output (output)
  (let* ((current-workspace (i3/get-current-workspace-by-output output))
         (candidate-workspaces (delq current-workspace
                                     (i3/get-available-workspaces-by-output output)))
         (current-windows-length
          (length
           (i3-get-visible-windows-by-workspaces (list current-workspace)))))

    (if (eq current-windows-length 0)
        current-windows-length
      (delq nil (mapcar
                 (lambda (ws)
                   (when (eq (length
                              (i3-get-visible-windows-names-by-workspaces (list ws)))
                             0)
                     ws)) candidate-workspaces)))))

(defun i3/get-empty-workspaces-by-output (output)
  (let ((candidate-workspaces (i3/get-available-workspaces-by-output output)))
    (delq nil (mapcar
               (lambda (ws)
                 (when (eq (length (i3-get-visible-windows-names-by-workspaces (list ws))) 0)
                   ws)) candidate-workspaces))))

(defun i3/get-focused-workspace ()
  (car
   (i3-map-and-filter
    (lambda (ws)
      (when (i3-field-is 'focused #'eq t ws) ws))
    (i3-get-workspaces))))

(defun i3/open-new-frame (&optional arg sentinel)
  (interactive "P")
  (let* ((target-screen (if arg arg primary-screen))
         (target-output (nth (1- target-screen) output-screens))
         (target-currnet-workspace (i3/get-current-workspace-by-output target-output))
         (target-workspace (car (i3/get-empty-workspaces-by-output target-output)))
         (target-frame (make-frame))
         (target-frame-id (frame-parameter target-frame 'outer-window-id)))

    (modify-frame-parameters target-frame
                             (list
                              (cons 'i3-generate-frame t)
                              (cons 'i3-previous-workspace target-currnet-workspace)
                              (cons 'i3-previous-frame (frame-parameter (selected-frame) 'outer-window-id))))

    (set-process-sentinel
     (start-process-shell-command "close" "*i3-generate*"
                                  (format "i3-msg %s, workspace number %s focus, \"[id=%s]\" focus"
                                          (format move-cmd target-frame-id target-workspace) target-workspace target-frame-id))
     (lambda (p e)
       (when (functionp sentinel)
         (funcall sentinel target-frame))))))

(defun i3/follow-focus (&optional arg)
  (interactive "P")
  (let ((pos (point)))
    (i3/open-new-frame arg (lambda (target-frame)
       (setq split-count (/ (frame-width target-frame) 88))
       (follow-mode t)
       (dotimes (i (1- split-count))
         (split-window-right))
       (balance-windows)
       (follow-end-of-buffer)
       (goto-char pos)))))

(defun i3/close-frame ()
  (interactive)
  (let ((current-frame (selected-frame)))
    (when (frame-parameter current-frame 'i3-generate-frame)
      (set-process-sentinel
       (start-process-shell-command "close" "*i3-generate*"
                                    (format "i3-msg workspace number %s focus, \"[id=%s]\" focus"
                                            (frame-parameter current-frame 'i3-previous-workspace)
                                            (frame-parameter current-frame 'i3-previous-frame)))
       (lambda (p e)
         (when (= 0 (process-exit-status p))
           (delete-frame current-frame)
           (kill-buffer "*i3-generate*")
           (follow-mode 0)))))))

(provide 'i3-follow-focus)
