;;; font.el -*- lexical-binding: t; -*-

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two4
;; (setq doom-font (font-spec :family "Hack" :size 22))
;; (setq doom-font (font-spec :family "Hack" :size 22))
;; (use-package! cnfonts
;;   :config
;;   (cnfonts-enable))

(setq-default line-spacing 0.3)

;; treemacs font
(setq doom-variable-pitch-font (font-spec :family "Noto Sans" :size 14))
(setq doom-themes-treemacs-line-spacing 13)

;; Auto generated by cnfonts
;; <https://github.com/tumashu/cnfonts>
;;(set-face-attribute
;; 'default nil
;; :font (font-spec :name "-JB-JetBrains Mono-bold-italic-normal-*-*-*-*-*-m-0-iso10646-1"
;;                  :weight 'normal
;;                  :slant 'normal
;;                  :size 10.0))
;;(dolist (charset '(kana han symbol cjk-misc bopomofo))
;;  (set-fontset-font
;;   (frame-parameter nil 'font)
;;   charset
;;   (font-spec :name "-MS  -Microsoft YaHei-bold-normal-normal-*-*-*-*-*-*-0-iso10646-1"
;;              :weight 'normal
;;              :slant 'normal
;;              :size 12.0)))
