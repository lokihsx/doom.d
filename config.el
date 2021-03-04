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
;; (setq doom-theme 'doom-spacegrey
;;       doom-spacegrey-brighter-modeline t
;;       doom-spacegrey-brighter-comments t
;;       doom-spacegrey-padded-modeline t)
;;   (setq doom-theme 'doom-challenger-deep))
(setq doom-theme 'doom-one
      doom-one-brighter-modeline t
      doom-one-brighter-comments t)

;; (setq doom-theme 'doom-sourcerer
;;       doom-sourcerer-brighter-modeline t
;;       doom-sourcerer-brighter-comments t)

;;(doom/set-frame-opacity 88)

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

(setq-default line-spacing 0.66)

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
        treemacs-collapse-dirs 5)
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
  (setq projectile-project-name-function 'workspace-tramp-project-name))
;; (add-to-list 'projectile-globally-ignored-directories "*target/")
;; (add-to-list 'projectile-globally-ignored-directories "*node_modules/"))


(after! vterm
  (add-hook! 'vterm-mode-hook
             ;; (when (doom-project-p)
             ;;   (setq vterm-buffer-name-string (format "%s-console" (doom-project-name))))
             (define-key vterm-mode-map (kbd "C-\\") #'toggle-input-method)))

(after! lsp-java
  (if IS-MAC
      (setq lsp-java-vmargs '(
                              ;;"-noverify"
                              "-Xmx8G"
                              "-XX:+UseG1GC"
                              "-XX:+UseStringDeduplication"
                              "-javaagent:/Users/loki/.m2/repository/org/projectlombok/lombok/1.18.12/lombok-1.18.12.jar"))
      (setq lsp-java-vmargs `(
                              ;;"-noverify"
                              "-Xmx8G"
                              "-XX:+UseG1GC"
                              "-XX:+UseStringDeduplication"
                              ,(format "-javaagent:%s/.m2/repository/org/projectlombok/lombok/1.18.12/lombok-1.18.12.jar" (getenv "HOME")))))
                                        ;"-Xbootclasspath/a:/home/loki/.m2/repository/org/projectlombok/lombok/1.18.12/lombok-1.18.12.jar")))

    (setq lsp-java-format-settings-url (concat "file:" (file-truename (concat doom-private-dir "googleJavaStyle.xml")))
          lsp-java-format-settings-profile "GoogleStyle"
          lsp-java-format-on-type-enabled t
          lsp-java-save-actions-organize-imports t))



  (after! eshell
    (set-eshell-alias! "cpr" "eshell/cd-to-project"))

  ;; ;; add to ~/.doom.d/config.el
  ;; (use-package! golden-ratio
  ;;   :after-call pre-command-hook
  ;;   :config
  ;;   (golden-ratio-mode +1)
  ;;   (setq golden-ratio-auto-scale t)
  ;;   ;; Using this hook for resizing windows is less precise than
  ;;   ;; `doom-switch-window-hook'.
  ;;   (remove-hook 'window-configuration-change-hook #'golden-ratio)
  ;;   (add-hook 'doom-switch-window-hook #'golden-ratio))

  ;; in ~/.doom.d/config.el
  (use-package zoom
    :hook (doom-first-input . zoom-mode)
    :config
    (setq zoom-size '(0.382 . 0.618)
          zoom-ignored-major-modes '(dired-mode help-mode helpful-mode rxt-help-mode help-mode-menu org-mode)
          zoom-ignored-buffer-names '("*doom:scratch*" "*info*" "*helpful variable: argv*")
          zoom-ignored-buffer-name-regexps '("^\\*calc" "\\*helpful variable: .*\\*")))
  ;; zoom-ignore-predicates (list (lambda () (< (count-lines (point-min) (point-max)) 20)))))


  ;; (when IS-LINUX
  ;;  (setq browse-url-browser-function 'browse-url-generic
  ;;       browse-url-generic-program "google-chrome-stable"
  ;;       browse-url-generic-args '("--new-window")))

  ;;(setenv "JAVA_HOME" "/usr/lib/jvm/java-11-openjdk/")
