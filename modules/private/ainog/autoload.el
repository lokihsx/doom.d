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


;;;###autoload
(defun ainog-graphql/models-to-graphqls ()
  (interactive)
  (shell-command "~/ainog/models-to-graphql-type")
  (with-temp-buffer
    (insert-file-contents "~/sss")
    (goto-char (point-min))
    (while (search-forward-regexp "#.+\ntype \\([A-Za-z]+\\) {" nil t)
      (setq module-name (match-string 1))
      (setq condition (format "# 筛选条件集合
type %sCondition {
    # 通过Id筛选
    id: Int
    # 通过Id列表筛选
    idList: [Int]
    # Id列表筛选方式（和条件，或条件）
    idListMethod: String
    # 本次请求筛选方式（和条件，或条件）
    conditionMethod: String
}\n" module-name))

      (setq queries (format "# 扩展查询结构
extend type Query {
    # 获取列表
    %sList(condition: %sCondition): [%s]
    # 获取对象
    %sObject(condition: %sObject): %s
}

# 扩展输入结构
extend type Mutation {
    # 创建对象
    create%s(%s: %sInput): %s
    # 通过ID修改
    update%s(id: Int, %s: %sInput): %s
    # 删除
    delete%s(condition: %sCondition): Int
}" module-name module-name module-name
module-name module-name module-name
module-name module-name module-name module-name
module-name module-name module-name module-name
module-name module-name))


      (setq export-file-name (format "/tmp/Generate/%s.graphqls" module-name))
      (previous-line)
      (setq origin-position (line-beginning-position))
      (search-forward "}")
      (setq end-position (line-end-position))
      (setq origin-obj (buffer-substring origin-position end-position))

      (setq input-statement (replace-regexp-in-string " {" "Input {" origin-obj))
      (setq input-statement (replace-regexp-in-string ".*# 主键自增ID\n.*\n" "" input-statement))
      (setq input-statement (replace-regexp-in-string ".*\n.*adminId.*\n" "" input-statement))
      (setq input-statement (replace-regexp-in-string ".*\n.*memberId.*\n" "" input-statement))
      (setq input-statement (replace-regexp-in-string ".*# 最后修改时间\n.*\n" "" input-statement))
      (setq input-statement (replace-regexp-in-string ".*# 创建时间\n.*\n" "" input-statement))
      ;; (setq input-statement (replace-regexp-in-string ".*}" "}" input-statement))


      (setq origin-obj (replace-regexp-in-string "adminId: Int" "admin: Admin" origin-obj))
      (setq origin-obj (replace-regexp-in-string "typeId: Int" "type: DataDictionary" origin-obj))
      (setq origin-obj (replace-regexp-in-string "memberId: Int" "member: Member" origin-obj))
      (setq content (format "%s\n\n%s\n%s\n\n%s" origin-obj condition input-statement queries))
      (write-region content t export-file-name))))
