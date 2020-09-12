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

;; Auto generated by cnfonts
;; <https://github.com/tumashu/cnfonts>
;; (set-face-attribute
;;  'default nil
;;  :font (font-spec :name "-SRC-Hack-bold-normal-normal-*-*-*-*-*-m-0-iso10646-1"
;;                   :weight 'normal
;;                   :slant 'normal
;;                   :size 10.0))
;; (dolist (charset '(kana han symbol cjk-misc bopomofo))
;;   (set-fontset-font
;;    (frame-parameter nil 'font)
;;    charset
;;    (font-spec :name "-ADBO-Source Han Serif CN-semibold-normal-normal-*-*-*-*-*-*-0-iso10646-1"
;;               :weight 'normal
;;               :slant 'normal
;;               :size 12.0)))

;; Auto generated by cnfonts
;; <https://github.com/tumashu/cnfonts>
(set-face-attribute
 'default nil
 :font (font-spec :name "-*-Hack-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1"
                  :weight 'normal
                  :slant 'normal
                  :size 14.0))
(dolist (charset '(kana han symbol cjk-misc bopomofo))
  (set-fontset-font
   (frame-parameter nil 'font)
   charset
   (font-spec :name "-*-Hiragino Sans GB-normal-normal-normal-*-*-*-*-*-p-0-iso10646-1"
              :weight 'normal
              :slant 'normal
              :size 16.5)))