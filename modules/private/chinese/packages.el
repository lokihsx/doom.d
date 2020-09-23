;; -*- no-byte-compile: t; -*-
;;; input/chinese/packages.el

(package! youdao-dictionary)

(if (featurep! +rime)
    (package! rime)
  (package! fcitx))
