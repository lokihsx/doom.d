;;; private/eaf/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun +eaf/open-url-on-right (url)
  "Open a url right on current buffer"
  (interactive "MOpen URL: ")
  (split-window-right)
  (windmove-right)
  (eaf-open-browser url))
