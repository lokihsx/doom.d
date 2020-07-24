;;; input/chinese/config.el -*- lexical-binding: t; -*-


;; (use-package! fcitx
;;   :after evil
;;   :config
;;   (when (executable-find "fcitx-remote")
;;     (fcitx-evil-turn-on)))

(use-package! fcitx
  :after evil
  :config
  (let ((is-fcitx4 (executable-find "fcitx-remote"))
        (is-fcitx5 (executable-find "fcitx5-remote")))
    (when (or is-fcitx4 is-fcitx5)
      (if is-fcitx4
          (setq fcitx-remote-command "fcitx-remote")
        (setq fcitx-remote-command "fcitx5-remote"))
      (fcitx-evil-turn-on))))

(use-package! youdao-dictionary
  :config
  (global-set-key (kbd "s-q") 'youdao-dictionary-search-at-point+)
  (global-set-key (kbd "s-Q") 'youdao-dictionary-search-at-point))

;;
;;; Hacks

(defadvice! +chinese--org-html-paragraph-a (args)
  "Join consecutive Chinese lines into a single long line without unwanted space
when exporting org-mode to html."
  :filter-args #'org-html-paragraph
  (cl-destructuring-bind (paragraph contents info) args
    (let* ((fix-regexp "[[:multibyte:]]")
           (origin-contents
            (replace-regexp-in-string
             "<[Bb][Rr] */>"
             ""
             contents))
           (fixed-contents
            (replace-regexp-in-string
             (concat "\\(" fix-regexp "\\) *\n *\\(" fix-regexp "\\)")
             "\\1\\2"
             origin-contents)))
      (list paragraph fixed-contents info))))
