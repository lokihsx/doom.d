;;; private/protobuf/config.el -*- lexical-binding: t; -*-

(use-package! protobuf-mode
  :mode
  ("\\.proto$" . protobuf-mode)
  :config
  (add-hook 'protobuf-mode-hook #'display-line-numbers-mode))
