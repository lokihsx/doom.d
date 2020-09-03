;;; private/loki-window-helper/config.el -*- lexical-binding: t; -*-

(use-package! switch-window
  :init
  (global-set-key [remap other-window] #'switch-window)
  :config
  (setq switch-window-multiple-frames t
   switch-window-shortcut-style 'qwerty
   switch-window-qwerty-shortcuts '("a" "s" "d" "f" "g" "h" "j" "k" "l" ";" "'" "z" "x" "c" "v" "b" "n" "m")))

(use-package! framemove
  :load-path "./"
  :config
  (setq framemove-hook-into-windmove t))
