;;; lang/web/+html.el -*- lexical-binding: t; -*-

(use-package! web-mode
  :mode "\\.[px]?html?\\'"
  :mode "\\.\\(?:tpl\\|blade\\)\\(?:\\.php\\)?\\'"
  :mode "\\.erb\\'"
  :mode "\\.l?eex\\'"
  :mode "\\.jsp\\'"
  :mode "\\.as[cp]x\\'"
  :mode "\\.hbs\\'"
  :mode "\\.mustache\\'"
  :mode "\\.svelte\\'"
  :mode "\\.twig\\'"
  :mode "\\.jinja2?\\'"
  :mode "wp-content/themes/.+/.+\\.php\\'"
  :mode "templates/.+\\.php\\'"
  :init
  ;; If the user has installed `vue-mode' then, by appending this to
  ;; `auto-mode-alist' rather than prepending it, its autoload will have
  ;; priority over this one.
  (add-to-list 'auto-mode-alist '("\\.vue\\'" . web-mode) 'append)
  :mode "\\.vue\\'"
  :config
  (set-docsets! 'web-mode "HTML" "CSS" "Twig" "WordPress")
  (setq web-mode-style-padding 0
        web-mode-script-padding 0
        web-mode-part-padding 0
        web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-enable-current-element-highlight t)

  ;; tidy is already defined by the format-all package. We redefine it to add
  ;; more sensible arguments to the tidy command.
  (set-formatter! 'html-tidy
                  '("tidy" "-q" "-indent"
                    "--tidy-mark" "no"
                    "--drop-empty-elements" "no"
                    ("--show-body-only" "%s" (if +format-region-p "true" "auto"))
                    ("--indent-spaces" "%d" tab-width)
                    ("--indent-with-tabs" "%s" (if indent-tabs-mode "yes" "no"))
                    ("-xml" (memq major-mode '(nxml-mode xml-mode))))
                  :ok-statuses '(0 1))

  (setq web-mode-enable-html-entities-fontification t
        web-mode-auto-close-style 1)

  (after! smartparens
    (defun +web-is-auto-close-style-3 (_id action _context)
      (and (eq action 'insert)
           (eq web-mode-auto-close-style 3)))
    (sp-local-pair 'web-mode "<" ">" :unless '(:add +web-is-auto-close-style-3))

    ;; let smartparens handle these
    (setq web-mode-enable-auto-quoting nil
          web-mode-enable-auto-pairing t)

    ;; 1. Remove web-mode auto pairs whose end pair starts with a latter
    ;;    (truncated autopairs like <?p and hp ?>). Smartparens handles these
    ;;    better.
    ;; 2. Strips out extra closing pairs to prevent redundant characters
    ;;    inserted by smartparens.
    (dolist (alist web-mode-engines-auto-pairs)
      (setcdr alist
              (cl-loop for pair in (cdr alist)
                       unless (string-match-p "^[a-z-]" (cdr pair))
                       collect (cons (car pair)
                                     (string-trim-right (cdr pair)
                                                        "\\(?:>\\|]\\|}\\)+\\'")))))
    (delq! nil web-mode-engines-auto-pairs))

  (add-to-list 'web-mode-engines-alist '("elixir" . "\\.eex\\'"))

  (let ((types '("javascript" "jsx")))
    (setq web-mode-comment-formats
          (cl-remove-if (lambda (item) (member (car item) types))
                        web-mode-comment-formats))
    (dolist (type types)
      (push (cons type "//") web-mode-comment-formats)))

  (add-hook! 'web-mode-hook
    (defun +web--fix-js-comments-h ()
      "Fix comment handling in `web-mode' for JavaScript."
      (when (member web-mode-content-type '("javascript" "jsx"))
        ;; For some reason the default is to insert HTML comments even
        ;; in JavaScript.
        (setq-local comment-start "//")
        (setq-local comment-end "")
        ;; Needed since otherwise the default value generated by
        ;; `comment-normalize-vars' will key off the syntax and think
        ;; that a single "/" starts a comment, which completely borks
        ;; auto-fill.
        (setq-local comment-start-skip "// *"))))

  (map! :map web-mode-map
        (:localleader
         :desc "Rehighlight buffer" "h" #'web-mode-buffer-highlight
         :desc "Indent buffer"      "i" #'web-mode-buffer-indent
         (:prefix ("a" . "attribute")
          "b" #'web-mode-attribute-beginning
          "e" #'web-mode-attribute-end
          "i" #'web-mode-attribute-insert
          "n" #'web-mode-attribute-next
          "s" #'web-mode-attribute-select
          "k" #'web-mode-attribute-kill
          "p" #'web-mode-attribute-previous
          "p" #'web-mode-attribute-transpose)
         (:prefix ("b" . "block")
          "b" #'web-mode-block-beginning
          "c" #'web-mode-block-close
          "e" #'web-mode-block-end
          "k" #'web-mode-block-kill
          "n" #'web-mode-block-next
          "p" #'web-mode-block-previous
          "s" #'web-mode-block-select)
         (:prefix ("d" . "dom")
          "a" #'web-mode-dom-apostrophes-replace
          "d" #'web-mode-dom-errors-show
          "e" #'web-mode-dom-entities-encode
          "n" #'web-mode-dom-normalize
          "q" #'web-mode-dom-quotes-replace
          "t" #'web-mode-dom-traverse
          "x" #'web-mode-dom-xpath)
         (:prefix ("e" . "element")
          "/" #'web-mode-element-close
          "a" #'web-mode-element-content-select
          "b" #'web-mode-element-beginning
          "c" #'web-mode-element-clone
          "d" #'web-mode-element-child
          "e" #'web-mode-element-end
          "f" #'web-mode-element-children-fold-or-unfold
          "i" #'web-mode-element-insert
          "k" #'web-mode-element-kill
          "m" #'web-mode-element-mute-blanks
          "n" #'web-mode-element-next
          "p" #'web-mode-element-previous
          "r" #'web-mode-element-rename
          "s" #'web-mode-element-select
          "t" #'web-mode-element-transpose
          "u" #'web-mode-element-parent
          "v" #'web-mode-element-vanish
          "w" #'web-mode-element-wrap)
         (:prefix ("t" . "tag")
          "a" #'web-mode-tag-attributes-sort
          "b" #'web-mode-tag-beginning
          "e" #'web-mode-tag-end
          "m" #'web-mode-tag-match
          "n" #'web-mode-tag-next
          "p" #'web-mode-tag-previous
          "s" #'web-mode-tag-select))

        :g  "M-/" #'web-mode-comment-or-uncomment
        :i  "SPC" #'self-insert-command
        :n  "za"  #'web-mode-fold-or-unfold
        :nv "]a"  #'web-mode-attribute-next
        :nv "[a"  #'web-mode-attribute-previous
        :nv "]t"  #'web-mode-tag-next
        :nv "[t"  #'web-mode-tag-previous
        :nv "]T"  #'web-mode-element-child
        :nv "[T"  #'web-mode-element-parent))


;;
(after! pug-mode
  (set-company-backend! 'pug-mode 'company-web-jade))
(after! web-mode
  (set-company-backend! 'web-mode 'company-css 'company-web-html))
(after! slim-mode
  (set-company-backend! 'slim-mode 'company-web-slim))


(when (featurep! +lsp)
  (add-hook! '(html-mode-local-vars-hook
               web-mode-local-vars-hook)
             #'lsp!))
