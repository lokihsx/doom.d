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
  :init
  (global-set-key (kbd "C-c k") 'windmove-up)
  (global-set-key (kbd "C-c j") 'windmove-down)
  (global-set-key (kbd "C-c h") 'windmove-left)
  (global-set-key (kbd "C-c l") 'windmove-right)

  (global-set-key (kbd "s-k") 'windmove-up)
  (global-set-key (kbd "s-j") 'windmove-down)
  (global-set-key (kbd "s-h") 'windmove-left)
  (global-set-key (kbd "s-l") 'windmove-right)

  :config
  (setq framemove-hook-into-windmove t))
