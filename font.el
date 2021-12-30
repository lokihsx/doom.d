;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two4
(setq doom-font (font-spec :family "Monaco" :size 20))
(setq doom-font (font-spec :family "Monaco" :size 20))


(setq-default line-spacing 0.3)

;; treemacs font
(setq doom-variable-pitch-font (font-spec :family "Noto Sans" :size 16))
(setq doom-themes-treemacs-line-spacing 6)

;; (custom-set-faces!
;;   '(mode-line :family "Noto Sans" :height 1.0)
;;   '(mode-line-inactive :family "Noto Sans" :height 1.0))
