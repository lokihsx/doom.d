;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
:PROPERTIES:
:CREATED: 20211018
:END:

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


;; These are used for a number of things, particularly for GPG configuration,
;; some email clients, file templates and snippets.
(setq user-full-name "Loki Huang"
      user-mail-address "lokihsx@gmail.com")

(when (window-system)
  (load! "font"))

(setq doom-theme 'doom-vibrant
      doom-vibrant-brighter-modeline t
      doom-vibrant-brighter-comments t)

;; (doom/set-frame-opacity 88)

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/Documents/")

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
;;

;; remember frame status

(when-let (dims (doom-store-get 'last-frame-size))
  (cl-destructuring-bind ((left . top) width height fullscreen) dims
    (setq initial-frame-alist
          (append initial-frame-alist
                  `((left . ,left)
                    (top . ,top)
                    (width . ,width)
                    (height . ,height)
                    (fullscreen . ,fullscreen))))))

(defun save-frame-dimensions ()
  (doom-store-put 'last-frame-size
                  (list (frame-position)
                        (frame-width)
                        (frame-height)
                        (frame-parameter nil 'fullscreen))))

(add-hook 'kill-emacs-hook #'save-frame-dimensions)

;; (when (eq window-system 'x)
;;   (let* ((sw (float (x-display-pixel-width)))
;;          (sh (x-display-pixel-height))
;;          (toggle-condition (> (/ sw sh) (/ 16 9.0)))
;;          (ratio (if toggle-condition (/ 1.6 (/ sw sh)) 0.618))
;;          (ww (round (* sw ratio)))
;;          (lm (round (* (/ sw 2) (- 1 ratio)))))
;;     (if toggle-condition
;;         (setq initial-frame-alist
;;               (append initial-frame-alist
;;                       `((left . ,lm)
;;                         (top . 0)
;;                         (width . (text-pixels . ,ww))
;;                         (height . (text-pixels . ,sh))
;;                         (fullscreen . nil)
;;                         ;; enable mouse to drag
;;                         ;;(drag-internal-border . 1)
;;                         ;;(internal-border-width . 5)
;;                         ;; drop title bar
;;                         (undecorated . t))))
;;       (toggle-frame-fullscreen))))

(use-package! evil-terminal-cursor-changer
  :when (not window-system)
  :hook (tty-setup . evil-terminal-cursor-changer-activate))

(after! lsp-mode
  (setq lsp-ui-doc-enable nil))

(after! web-mode
  (setq web-mode-style-padding 0
        web-mode-script-padding 0
        web-mode-part-padding 2
        web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-enable-current-element-highlight t)

  (after! lsp-mode
    (when (featurep! :lang web +lsp)
      (setf (alist-get 'web-mode lsp--formatting-indent-alist) 'web-mode-code-indent-offset))))

(after! typescript-mode
  (setq typescript-indent-level 2))
;; (when (featurep! :lang javascript +lsp)
;;   (setf (alist-get 'javascript-mode lsp--formatting-indent-alist) 'typescript-indent-level)))


;; (after! js2-mode
;;   (setq js2-basic-offset 2))

(setq-default company-idle-delay 0)

(after! treemacs
  (defun treemacs-custom-filter (file _)
    (or (s-ends-with? ".o" file)
        (s-ends-with? ".log" file)))
  (setq +treemacs-git-mode 'deferred
        treemacs-collapse-dirs 5
        treemacs-width 55
        treemacs-recenter-after-file-follow 'always
        treemacs-position 'left)
  (treemacs-follow-mode)
  (push #'treemacs-custom-filter treemacs-ignored-file-predicates))

(after! warnings
  (add-to-list 'warning-suppress-types '(yasnippet backquote-change)))
;; fix mac vterm chinese wrong code
(when IS-MAC
  (add-hook 'vterm-mode-hook (lambda () (setenv "LANG" "en_US.UTF-8"))))

(add-hook 'eshell-mode-hook (lambda () (company-mode -1)))

(load! "proxy")

(after! projectile
  (defun workspace-tramp-project-name (project-root)
    (setq pname (file-name-nondirectory (directory-file-name project-root)))
    (when (and (featurep 'tramp)
               (tramp-tramp-file-p project-root)
               (string-match "\\(ssh:[A-Z0-9a-z-_]+\\)@\\([A-Za-z0-9-\\.]+\\)" project-root))
      (setq pname (concat (match-string 2 project-root) ":" pname)))
    pname)
  ;; add to projectile project name function replace default action
  (setq projectile-project-name-function 'workspace-tramp-project-name))


(after! vterm
  (add-hook! 'vterm-mode-hook (define-key vterm-mode-map (kbd "C-\\") #'toggle-input-method)))

(after! lsp-java
  (setq lsp-java-vmargs `(
                          ;;"-noverify"
                          "-Xmx4G"
                          "-XX:+UseG1GC"
                          "-XX:+UseStringDeduplication"
                          ,(format
                            "-javaagent:%s/.m2/repository/org/projectlombok/lombok/1.18.20/lombok-1.18.20.jar"
                            (getenv "HOME")))

        lsp-java-format-settings-url (concat "file:" (file-truename (concat doom-private-dir "googleJavaStyle.xml")))
        lsp-java-format-settings-profile "GoogleStyle"
        lsp-java-format-on-type-enabled t
        lsp-java-save-actions-organize-imports t))


(after! eshell
  (set-eshell-alias! "cpr" "eshell/cd-to-project"))

;; (use-package zoom
;;   :hook (doom-first-input . zoom-mode)
;;   :config
;;   (setq zoom-size '(0.382 . 0.618)
;;         zoom-ignored-major-modes '(dired-mode help-mode helpful-mode rxt-help-mode help-mode-menu org-mode)
;;         zoom-ignored-buffer-names '("*doom:scratch*" "*info*" "*helpful variable: argv*")
;;         zoom-ignored-buffer-name-regexps '("^\\*calc" "\\*helpful variable: .*\\*")))
;; zoom-ignore-predicates (list (lambda () (< (count-lines (point-min) (point-max)) 20)))))

(use-package! beacon
  :custom
  (beacon-blink-when-focused t)
  :config
  (beacon-mode t))

;;(use-package! prettier
;;   :config
;;   (add-hook 'js2-mode-hook 'prettier-mode)
;;   (add-hook 'typescript-mode-hook 'prettier-mode)
;;   (add-hook 'web-mode-hook 'prettier-mode))


(when (featurep! :editor format)
  (setq +format-on-save-enabled-modes '(not emacs-lisp-mode sql-mode tex-mode latex-mode org-msg-edit-mode protobuf-mode))
  (setq-hook! 'web-mode-hook +format-with-lsp nil)
  (setq-hook! 'c-mode-hook +format-with-lsp nil))

;; (defadvice org-capture
;;     (before make-full-window-frame activate)
;;   "Advise capture to be the only window when used as a popup"
;;   (when (featurep! :completion ivy +childframe)
;;     (ivy-posframe-mode -1)))

(defadvice org-capture
    (after make-full-window-frame activate)
  "Advise capture to be the only window when used as a popup"
  (if (equal "emacs-capture" (frame-parameter nil 'name))
      (delete-other-windows)))

;; (defadvice org-capture-finalize
;;     (after delete-capture-frame activate)
;;   "Advise capture-finalize to close the frame"
;;   (when (featurep! :completion ivy +childframe)
;;     (ivy-posframe-mode 1))
;;   (if (equal "emacs-capture" (frame-parameter nil 'name))
;;       (delete-frame)))

(add-hook 'org-capture-after-finalize-hook (lambda () (delete-frame (selected-frame))))

(defun transform-square-brackets-to-round-ones(string-to-transform)
  "Transforms [ into ( and ] into ), other chars left unchanged."
  (concat
   (mapcar #'(lambda (c) (if (equal c ?\[) ?\( (if (equal c ?\]) ?\) c))) string-to-transform)))

(defun pm-get-doc-buffer ()
  (let ((dev-doc (concat (doom-project-root) "dev_doc.org"))
        (todo-doc "~/org/TODO.org"))
    (if (file-exists-p dev-doc)
        (find-file-noselect dev-doc)
      (find-file-noselect todo-doc))))

(defun +pm/toggle (&optional arg)
  (interactive "P")
  (require 'treemacs)
  (require 'vterm)
  (if (persp-parameter 'on-pm)
      (progn
        (setq kill-buffer-query-functions (delq 'process-kill-buffer-query-function kill-buffer-query-functions))
        (dolist (win (window-list))
          (when (window-dedicated-p win)
            (select-window win)
            (cond ((eq win (treemacs-get-local-window))
                   (treemacs-quit))
                  ((get-buffer-process (buffer-name))
                   (kill-buffer-and-window))
                  ((window-dedicated-p win)
                   (save-buffer)
                   (kill-buffer-and-window)))))
        (add-to-list 'kill-buffer-query-functions 'process-kill-buffer-query-function)
        (set-persp-parameter 'on-pm nil)
        (balance-windows))
    (let ((proot (doom-project-root))
          (doc-win (display-buffer-in-side-window (pm-get-doc-buffer) '((side . right))))
          (pre-vt-win (split-window-right))
          (vt-win))

      (select-window pre-vt-win)
      (setq vt-win (display-buffer-in-side-window (+vterm/here arg) '((side . right) (slot . 1))))
      (delete-window pre-vt-win)

      (set-persp-parameter 'on-pm t)

      (set-window-dedicated-p doc-win t)
      (set-window-dedicated-p vt-win t)

      (window-preserve-size doc-win t t)
      (window-preserve-size vt-win t t)

      (set-window-parameter doc-win'no-delete-other-windows t)
      (set-window-parameter vt-win 'no-delete-other-windows t)

      (select-window vt-win))))
(global-set-key (kbd "C-x 2") 'evil-window-split)
(global-set-key (kbd "C-x 3") 'evil-window-vsplit)


(defun alist-recursive (alist &rest keys)
  (while keys
    (setq alist (cdr (assoc (pop keys) alist))))
  alist)

(defun get-frame ()
  (let ((frames (delq (selected-frame) (visible-frame-list)))
        (selected))
    (cond ((> (length frames) 1)
           (completing-read "Here!"
                            (mapcar (lambda(frame)
                                      (cons (frame-parameter frame 'name) frame)) frames)
                            (lambda (frame)
                              (setq selected (cdr frame)))))
          ((eq (length frames) 1)
           (setq selected (car frames)))
          (t
           (setq selected (make-frame))))
    (modify-frame-parameters selected '((is-follow-frame . t)))
    (when (< (length (window-list selected)) 2)
      (select-frame selected)
      (split-window-right))
    selected))

(defun other-frame-follow (arg)
  (interactive "P")
  (let ((frame (get-frame))
        (buffer (if arg (progn (call-interactively #'projectile-find-file) (current-buffer))
                  (current-buffer))))
    (previous-buffer)
    (select-frame-set-input-focus frame)
    (switch-to-buffer buffer)
    (other-window 1)
    (switch-to-buffer buffer)
    (follow-mode 1)))


;; (advice-add 'find-file
;;             :around
;;             (lambda (origin filename &optional wildcards)
;;               (if (interactive-p)
;;                   (call-interactively origin filename wildcards)
;;                 (funcall origin filename wildcards))
;;               (when (frame-parameter (selected-frame) 'is-follow-frame)
;;                 (setq buf (current-buffer))
;;                 (follow-mode 1)
;;                 (other-window 1)
;;                 (switch-to-buffer buf))))


(map! :map web-mode-map
      :nv "[m" #'web-mode-tag-match
      :nv "]m" #'web-mode-tag-match)



(after! org
  (setq org-todo-keywords
      '((sequence
         "TODO(t)"  ; A task that needs doing & is ready to do
         "PROJ(p)"  ; A project, which usually contains other tasks
         "LOOP(r)"  ; A recurring task
         "STRT(s)"  ; A task that is in progress
         "WAIT(w)"  ; Something external is holding up this task
         "HOLD(h)"  ; This task is paused/on hold because of me
         "IDEA(i)"  ; An unconfirmed and unapproved task or notion
         "NOTE(n)"  ; An note from capture or input
         "|"
         "DONE(d)"  ; Task successfully completed
         "KILL(k)") ; Task was cancelled, aborted or is no longer applicable
        (sequence
         "[ ](T)"   ; A task that needs doing
         "[-](S)"   ; Task is in progress
         "[?](W)"   ; Task is being held up or paused
         "|"
         "[X](D)")  ; Task was completed
        (sequence
         "|"
         "OKAY(o)"
         "YES(y)"
         "NO(n)"))
      org-todo-keyword-faces
      '(("[-]"  . +org-todo-active)
        ("STRT" . +org-todo-active)
        ("[?]"  . +org-todo-onhold)
        ("WAIT" . +org-todo-onhold)
        ("HOLD" . +org-todo-onhold)
        ("PROJ" . +org-todo-project)
        ("NO"   . +org-todo-cancel)
        ("KILL" . +org-todo-cancel))))

;;;###autoload
(defun +org-journal/frame-goto (&rest args)
  (let* ((filename (format-time-string (format "%sjournal/%s" (file-truename org-directory) org-journal-file-format)))
         (buf-pos (cl-position filename (mapcar (lambda (win) (buffer-file-name (window-buffer win))) (window-list-1 nil nil t))
                               :test #'equal))
         (tar-win (and buf-pos (nth buf-pos (window-list-1 nil nil t))))
         (tar-frame (window-frame tar-win))
         (journal-frame (car (delete nil (mapcar (lambda (frame) (when (frame-parameter frame 'journal-frame) frame)) (frame-list))))))
    (if (and buf-pos (frame-parameter tar-frame 'journal-frame))
            (select-frame-set-input-focus tar-frame)
      (progn
        (when buf-pos
          (select-window tar-win)
            (save-buffer)
            (kill-buffer-and-window))

        (if journal-frame
            (progn
              (select-frame-set-input-focus journal-frame)
              (find-file filename))
          (progn
            (find-file-other-frame filename)
            (modify-frame-parameters (selected-frame) (list (cons 'journal-frame t)))
            (when
              (start-process-shell-command "Journal" nil
                                           (format "i3-msg \"[id=%s]\" resize shrink width 600px"
                                                   (frame-parameter (selected-frame) 'outer-window-id))))))))))

;;;###autoload
(defun +org-journal/window-goto (&rest args)
  (let* ((filename (format-time-string (format "%sjournal/%s" (file-truename org-directory) org-journal-file-format)))
         (buf-pos (cl-position filename (mapcar (lambda (win) (buffer-file-name (window-buffer win))) (window-list-1 nil nil t))
                               :test #'equal))
         (tar-win (and buf-pos (nth buf-pos (window-list-1 nil nil t)))))
    (if buf-pos
        (select-window tar-win)
      (progn
        (find-file-other-window filename)
        (shrink-window-horizontally 60)))))

;;;###autoload
(defun +org-journal/toggle (&rest args)
  (interactive)
  (let* ((filename (format-time-string (format "%sjournal/%s" (file-truename org-directory) org-journal-file-format)))
         (bufname (buffer-file-name (current-buffer))))
    (if (featurep! :private i3wm)
        (if (and (string= filename bufname) (frame-parameter (selected-frame) 'journal-frame))
            (delete-frame)
          (+org-journal/frame-goto) args)
      (progn
          (if (string= filename (buffer-file-name (current-buffer)))
            (progn
              (save-buffer)
              (kill-buffer-and-window))
            (+org-journal/window-goto))))))

(after! org-journal
  (setq org-journal-date-format "%F %A"
        org-journal-carryover-items "TODO=\"TODO\"|TODO=\"PROJ\"|TODO=\"STRT\"|TODO=\"WAIT\"|TODO=\"HOLD\"|TODO=\"IDEA\""
        org-capture-templates `(("p" "Protocol" entry (file+headline ,(format-time-string "journal/%Y-%m.org") "")
                                 "* CAPTURE %^{Title}\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?")
                                ;; ("m" "Temp Minds" entry
                                ;;  (file+headline ,(format-time-string "journal/%Y-%m-%d.org") "")
                                ;;  "* IDEA %?\nEntered on %U\n \%i\n %a")
                                ("m" "Temp Minds" entry
                                 (file+headline ,(format-time-string (format "journal/%s" org-journal-file-format)) ,(format-time-string "%F %A"))
                                 ,(format-time-string "* IDEA %R %?"))
                                ("L" "Protocol Link" entry (file+headline ,(format-time-string "journal/%Y-%m.org") ,(format-time-string "%F %A"))
                                 "* CAPTURE %? [[%:link][%(transform-square-brackets-to-round-ones \"%:description\")]]\n")))
  (if (featurep! :private i3wm)
        (setq org-journal-find-file '+org-journal/frame-goto)
    (setq org-journal-find-file '+org-journal/window-goto)))
