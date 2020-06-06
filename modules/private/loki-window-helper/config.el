;;; private/loki-window-helper/config.el -*- lexical-binding: t; -*-

(use-package! framemove
  :load-path "./"
  :config
  (setq framemove-hook-into-windmove t)
  (setq switch-window-multiple-frames t)
  (global-set-key (kbd "s-k") 'windmove-up)
  (global-set-key (kbd "s-j") 'windmove-down)
  (global-set-key (kbd "s-h") 'windmove-left)
  (global-set-key (kbd "s-l") 'windmove-right))
