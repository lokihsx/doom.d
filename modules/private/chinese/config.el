;;; input/chinese/config.el -*- lexical-binding: t; -*-



;; (use-package! pyim
;;   :after-call after-find-file pre-command-hook
;;   :init
;;   (setq pyim-dcache-directory (concat doom-cache-dir "pyim/"))
;;   :config
;;   (setq pyim-page-tooltip t
;;         default-input-method "pyim"))


;; (use-package! pangu-spacing
;;   :hook (text-mode . pangu-spacing-mode)
;;   :config
;;   ;; Always insert `real' space in org-mode.
;;   (setq-hook! 'org-mode-hook pangu-spacing-real-insert-separtor t))


(use-package! fcitx
  :after evil
  :config
  (when (setq fcitx-remote-command
              (or (executable-find "fcitx5-remote")
                  (executable-find "fcitx-remote")))
    (fcitx-evil-turn-on)))

(use-package! rime
  :after-call after-find-file pre-command-hook
  :init
  (when IS-MAC
    (setq rime-librime-root "~/.emacs.d/librime/dist"))
  :custom
  (default-input-method "rime")
  (rime-show-candidate 'posframe)
  ;; :init
  ;; (setq rime-user-data-dir (format "%smodules/private/chinese/rime-config" doom-private-dir))
  :config
  ;; 临时英文状态提示
  (setq mode-line-mule-info '((:eval (rime-lighter))))

  (defun +rime--posframe-display-content-a (args)
    "给 `rime--posframe-display-content' 传入的字符串加一个全角空格，以解决 `posframe' 偶尔吃字的问题。"
    (cl-destructuring-bind (content) args
      (let ((newresult (if (string-blank-p content)
                           content
                         (concat content "　"))))
        (list newresult))))

  (if (fboundp 'rime--posframe-display-content)
      (advice-add 'rime--posframe-display-content
                  :filter-args
                  #'+rime--posframe-display-content-a)
    (error "Function `rime--posframe-display-content' is not available.")))

(use-package! youdao-dictionary
  :config
  ;; (global-set-key (kbd "s-y") 'youdao-dictionary-search-at-point+)
  (global-set-key (kbd "C-c y") 'youdao-dictionary-search-at-point+))

;;; Hacks
(defadvice! +chinese--org-html-paragraph-a (args)
  "Join consecutive Chinese lines into a single long line without unwanted space
when exporting org-mode to html."
  :filter-args #'org-html-paragraph
  (cl-destructuring-bind (paragraph contents info) args
    (let* ((fix-regexp "[[:multibyte:]]")
           (fixed-contents
            (replace-regexp-in-string
             (concat "\\(" fix-regexp "\\) *\n *\\(" fix-regexp "\\)")
             "\\1\\2"
             contents)))
      (list paragraph fixed-contents info))))

(use-package sis
  :config
  (sis-ism-lazyman-config nil "rime" 'native)
  (sis-global-respect-mode)
  (sis-global-context-mode)
  (sis-global-cursor-color-mode)
  (sis-global-inline-mode))
