;;; ~/.doom.d/custom-config.el -*- lexical-binding: t; -*-

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two4
(setq doom-font (font-spec :family "Hack" :size 22))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
;; (if window-system
;;     (setq doom-theme 'doom-spacegrey)
;;   (setq doom-theme 'doom-challenger-deep))
(setq doom-theme 'doom-spacegrey)
;;(setq doom-theme 'doom-dracula)

(doom/set-frame-opacity 80)

(toggle-frame-fullscreen)

;; 先保留，防止以后有特殊需求
;; (defun loki/frame-helper ()
;;   ;; (setq line-spacing 0.66)
;;   (doom/set-frame-opacity 80))
;; (loki/frame-helper)
;; (add-hook 'after-make-frame-functions
;;           (lambda (frame)
;;             (select-frame frame)
;;             (loki/frame-helper)))

(with-eval-after-load 'treemacs
  (defun treemacs-custom-filter (file _)
    (or (s-ends-with? ".o" file)
        (s-ends-with? ".log" file)))
  (treemacs-follow-mode)
  (setq treemacs-width 28)
  (push #'treemacs-custom-filter treemacs-ignored-file-predicates))

;; (unless window-system
;;   (setq fcitx-remote-command (concat doom-private-dir "osx-fcitx.sh")))

(setq url-proxy-services '(("http" . "127.0.0.1:12333")
                           ("https" . "127.0.0.1:12333")))
;; (setq url-gateway-method 'socks)
;; (setq socks-server '("Default server" "127.0.0.1" 1080 5))
