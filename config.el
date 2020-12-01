;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


;; These are used for a number of things, particularly for GPG configuration,
;; some email clients, file templates and snippets.
(setq user-full-name "Loki Huang"
      user-mail-address "lokihsx@gmail.com")

(when (window-system)
  (load! "font"))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
;; (if window-system
;; (setq doom-theme 'doom-spacegrey)
;;   (setq doom-theme 'doom-challenger-deep))
(setq doom-theme 'doom-one)

;; (if IS-MAC
;;     (doom/set-frame-opacity 80)
;;   (doom/set-frame-opacity 90))

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/org/")

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
  ;; (doom-store-put 'last-frame-size
  ;;                 (list (frame-position)
  ;;                       (frame-width)
  ;;                       (frame-height)
  ;;                       (frame-parameter nil 'fullscreen)))
  )

(add-hook 'kill-emacs-hook #'save-frame-dimensions)

(use-package! evil-terminal-cursor-changer
  :hook (tty-setup . evil-terminal-cursor-changer-activate))

(setq-default line-spacing 0.38)

(after! web-mode
  (setq web-mode-style-padding 0
        web-mode-script-padding 0
        web-mode-part-padding 2
        web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-enable-current-element-highlight t))

(after! js2-mode
  (setq js2-basic-offset 2))

(setq-default company-idle-delay 0)

(after! treemacs
  (defun treemacs-custom-filter (file _)
    (or (s-ends-with? ".o" file)
        (s-ends-with? ".log" file)))
  (setq +treemacs-git-mode 'deferred
        treemacs-collapse-dirs 5
        treemacs-width 45)
  (treemacs-follow-mode)
  (push #'treemacs-custom-filter treemacs-ignored-file-predicates))

(after! warnings
  (add-to-list 'warning-suppress-types '(yasnippet backquote-change)))
;; fix mac vterm chinese wrong code
(when IS-MAC
  (add-hook 'vterm-mode-hook (lambda () (setenv "LANG" "en_US.UTF-8"))))

(add-hook 'eshell-mode-hook '(lambda () (company-mode -1)))

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
  (setq projectile-project-name-function 'workspace-tramp-project-name)
  (add-to-list 'projectile-globally-ignored-directories "*target/")
  (add-to-list 'projectile-globally-ignored-directories "*node_modules/"))


(after! vterm
  (add-hook! 'vterm-mode-hook
             ;; (when (doom-project-p)
             ;;   (setq vterm-buffer-name-string (format "%s-console" (doom-project-name))))
             (define-key vterm-mode-map (kbd "C-\\") #'toggle-input-method)))

;; mac 下可以不闪了！
;; (when IS-MAC
;;   (with-eval-after-load 'ivy-posframe
;;     (defvar ivy-posframe--first-show t)
;;     (defun ivy-posframe-cleanup ()
;;       "Cleanup ivy's posframe."
;;       (setq ivy-posframe--first-show t)
;;       (when (posframe-workable-p)
;;         (posframe-hide ivy-posframe-buffer)))
;;     (defun ivy-posframe--display (str &optional poshandler)
;;       "Show STR in ivy's posframe with POSHANDLER."
;;       (if (not (posframe-workable-p))
;;           (ivy-display-function-fallback str)
;;         (with-ivy-window
;;           (if (not ivy-posframe--first-show)
;;               (with-current-buffer ivy-posframe-buffer
;;                 (erase-buffer)
;;                 (insert str))
;;             (setq ivy-posframe--first-show nil)
;;             (apply #'posframe-show
;;                    ivy-posframe-buffer
;;                    :font ivy-posframe-font
;;                    :string str
;;                    :position (point)
;;                    :poshandler poshandler
;;                    :background-color (face-attribute 'ivy-posframe :background nil t)
;;                    :foreground-color (face-attribute 'ivy-posframe :foreground nil t)
;;                    :internal-border-width ivy-posframe-border-width
;;                    :internal-border-color (face-attribute 'ivy-posframe-border :background nil t)
;;                    :override-parameters ivy-posframe-parameters
;;                    (funcall ivy-posframe-size-function)))
;;           (ivy-posframe--add-prompt 'ignore)))
;;       (with-current-buffer ivy-posframe-buffer
;;         (setq-local truncate-lines ivy-truncate-lines)))))
