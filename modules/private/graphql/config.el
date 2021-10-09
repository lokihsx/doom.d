;;; private/protobuf/config.el -*- lexical-binding: t; -*-

(use-package! graphql-mode
  :mode ("\\.graphqls$" . graphql-mode)
  :config
  (setq graphql-indent-level 2))
