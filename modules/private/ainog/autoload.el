;;; private/ainog/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun ainog-graphql/package-name ()
  (let* ((name-list (reverse (split-string default-directory "/")))
         (is-template (string= (nth 2 name-list) "template"))
         (package-name (nth 1 name-list)))
    (if is-template
        (concat "template." package-name)
      package-name)))

;;;###autoload
(defun ainog-graphql/module-name ()
  (let ((str (buffer-name)))
    (string-match "\\(.+\\)Provider\\|DataFetchers" str)
    (match-string 1 str)))

;;;###autoload
(defun ainog-graphql/module-name-camel ()
  (let* ((module-name (ainog-graphql/module-name))
         (first-letter (substring module-name 0 1))
         (rest-letter (substring module-name 1)))
    (concat (downcase first-letter) rest-letter)))

;;;###autoload
(defun ainog-graphql/create-condition-file ()
  (let ((package-name (ainog-graphql/package-name))
        (module-name (ainog-graphql/module-name)))
    (with-temp-file (format "%s%sCondition.java" default-directory module-name)
      (insert (format "package com.ainog.backend.web.admin.%s;

public class %sCondition
{

}" package-name module-name))
      (write-file (format "%s%sCondition.java" default-directory module-name)))))

;;;###autoload
(defun ainog-graphql/type-name ()
  (let ((name-list (split-string (file-name-sans-extension (buffer-name)) "_")))
    (mapconcat 'capitalize name-list "")))

;;;###autoload
(defun ainog-graphql/type-name-camel ()
  (let* ((type-name (ainog-graphql/type-name))
         (first-letter (substring type-name 0 1))
         (rest-letter (substring type-name 1)))
    (concat (downcase first-letter) rest-letter)))
