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
(defun ainog-graphql/module-name (&optional module-name)
  (let ((str (or module-name (buffer-name))))
    (string-match "\\(.+\\)\\(Provider\\|DataFetchers\\)" str)
    (match-string 1 str)))

;;;###autoload
(defun ainog-graphql/module-name-camel (&optional module-name)
  (let* ((module-name (or module-name (ainog-graphql/module-name)))
         (first-letter (substring module-name 0 1))
         (rest-letter (substring module-name 1)))
    (concat (downcase first-letter) rest-letter)))

;;;###autoload
(defun ainog-graphql/create-condition-file ()
  (let ((package-name (ainog-graphql/package-name))
        (module-name (ainog-graphql/module-name)))
    (with-temp-file (format "%s%sCondition.java" default-directory module-name)
      (insert (format "package com.ainog.backend.web.admin.%s;
import java.util.List;

public class %sCondition
{
    // 通过ID筛选
    private Integer id;

    // 通过ID列表筛选
    private List<Integer> idList;

    // Id列表筛选方式（和条件，或条件）
    private String idListMethod;

    // 根据创建时间排序(负数为降序，正数为升序，一次请求中的绝对值越大，相对排序条件越靠前)
    private Integer orderByCreateTime;

    // 根据最后修改时间排序(负数为降序，正数为升序，一次请求中的绝对值越大，相对排序条件越靠前)
    private Integer orderByLastModifyTime;

    // 本次请求筛选方式（和条件，或条件）
    private String conditionMethod;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public List<Integer> getIdList() {
        return idList;
    }

    public void setIdList(List<Integer> idList) {
        this.idList = idList;
    }

    public String getIdListMethod() {
        return idListMethod;
    }

    public void setIdListMethod(String idListMethod) {
        this.idListMethod = idListMethod;
    }

    public String getConditionMethod() {
        return conditionMethod;
    }

    public void setConditionMethod(String conditionMethod) {
        this.conditionMethod = conditionMethod;
    }

    public int getOrderByCreateTime() {
        return orderByCreateTime;
    }

    public void setOrderByCreateTime(int orderByCreateTime) {
        this.orderByCreateTime = orderByCreateTime;
    }

    public int getOrderByLastModifyTime() {
        return orderByLastModifyTime;
    }

    public void setOrderByLastModifyTime(int orderByLastModifyTime) {
        this.orderByLastModifyTime = orderByLastModifyTime;
    }

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
(defun ainog-graphql/module-generator-alist (module-name)
  (cond ((string= module-name "AdminAccount")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "管理员账户")
           (conditions . "\n    # 通过管理员类型筛选\n    roleId: Int\n    # 通过管理员类型排序（负数为降序，正数为升序，一次请求中的绝对值越大，相对排序条件越靠前）\n    orderByRoleId: Int")
           (inputs . "")
           (types . "")))
        ((string= module-name "AdminAttachment")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "管理员上传附件")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "AdminRole")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "管理员权限类型")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "AdminPermission")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "管理员权限")
           (conditions . "")
           (inputs . "")
           (types . "")))

        ((string= module-name "Member")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "用户总结构")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "MemberAccount")
         `((module-name . ,module-name) (module-name-camel . ,(ainog-graphql/module-name-camel module-name)) (queries . "") (mutations . "") (comment . "用户账户")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "MemberRole")
         `((module-name . ,module-name) (module-name-camel . ,(ainog-graphql/module-name-camel module-name)) (queries . "") (mutations . "") (comment . "用户类型")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "MemberPermission")
         `((module-name . ,module-name) (module-name-camel . ,(ainog-graphql/module-name-camel module-name)) (queries . "") (mutations . "") (comment . "用户权限")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "MemberAttachment")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "用户上传附件")
           (conditions . "")
           (inputs . "")
           (types . "")))

        ((string= module-name "TemplateMemberRole")
         `((module-name . ,module-name) (module-name-camel . ,(ainog-graphql/module-name-camel module-name)) (queries . "") (mutations . "") (comment . "用户类型模板")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "TemplateMemberPermission")
         `((module-name . ,module-name) (module-name-camel . ,(ainog-graphql/module-name-camel module-name)) (queries . "") (mutations . "") (comment . "用户权限模板")
           (conditions . "")
           (inputs . "")
           (types . "")))

        ((string= module-name "Diagram")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "图表")
           (conditions . "\n    # 通过图表分类筛选\n    diagramTypeId: Int\n    #通过多个图表分类筛选\n    diagramTypeIdList: [Int]")
           (inputs . "")
           (types . "")))
        ((string= module-name "DiagramColumn")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "图表中展示的字段")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "TemplateDiagramGroup")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "图表模板分组")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "TemplateDiagram")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "图表模板")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "TemplateDiagramType")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "图表类型模板")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "TemplateDiagramColumn")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "图表模板中展示的字段")
           (conditions . "")
           (inputs . "")
           (types . "")))


        ((string= module-name "Article")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "站点文章")
           (conditions . "\n    # 通过文章分类筛选
    typeId: Int
    # 通过多个文章分类筛选
    typeIdList: [Int]
    # 通过文章标题模糊筛选
    title: String
    # 通过多个文章标题模糊筛选
    titleList: [String]
    # 多个文章标题筛选方式（和条件，或条件）
    titleListMethod: String
    # 根据文章分类排序(负数为降序，正数为升序，一次请求中的绝对值越大，相对排序条件越靠前)
    orderByTypeId: Int")
           (inputs . "")
           (types . "")))
        ((string= module-name "Orderform")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "订单")
           (conditions . "\n    # 通过套餐类型筛选
    comboId: Int
    # 通过多个套餐类型筛选
    comboIdList: [Int]
    # 多个套餐类型筛选方式（和条件，或条件）
    comboIdListMethod: String")
           (inputs . "")
           (types . "")))
        ((string= module-name "Banner")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "首页Banner图")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "DataDictionary")
         `((module-name . ,module-name) (module-name-camel . ,(ainog-graphql/module-name-camel module-name)) (queries . "") (mutations . "") (comment . "数据字典")
           (conditions . "\n    # 通过分类名称筛选
    groupName: String
    # 通过多个分类名称筛选
    groupNameList: [String]")
           (inputs . "")
           (types . "")))
        ((string= module-name "Service")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "SaaS服务")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "Combo")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "销售套餐")
           (conditions . "\n    # 按包含的SaaS服务筛选
    serviceId: Int
    # 按多个包含的SaaS服务筛选
    serviceIdList: [Int]
    # 多个SaaS服务的筛选方式
    serviceIdListMethod: String")
           (inputs . "\n    # 包含的SaaS服务列表
serviceIdList: [Int]")
           (types . "\n    # 包含的SaaS服务列表
    ServiceList: [Service]")))
        ((string= module-name "Activity")
         `((module-name . ,module-name) (module-name-camel . ,(ainog-graphql/module-name-camel module-name)) (queries . "") (mutations . "") (comment . "活动")
           (conditions . "")
           (inputs . "\n    # 活动中包含的套餐列表
    activityComboInputList: [ActivityComboInput]")
           (types . "\n    # 活动中包含的套餐列表
    activityCombo: [ActivityCombo]")))
        ((string= module-name "ActivityCombo")
         `((module-name . ,module-name) (module-name-camel . ,(ainog-graphql/module-name-camel module-name)) (queries . "") (mutations . "") (comment . "活动中包含的套餐")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "Workorder")
         `((module-name . ,module-name) (module-name-camel . ,(ainog-graphql/module-name-camel module-name)) (queries . "") (mutations . "") (comment . "工单")
           (conditions . "")
           (inputs . "")
           (types . "\n    # 工单中包含的附件
    attachmentList: [memberList]")))

        ((string= module-name "MessageGroup")
         `((module-name . ,module-name) (module-name-camel . ,(ainog-graphql/module-name-camel module-name)) (queries . "") (mutations . "") (comment . "消息分组")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "MessageEvent")
         `((module-name . ,module-name) (module-name-camel . ,(ainog-graphql/module-name-camel module-name)) (queries . "") (mutations . "") (comment . "消息事件")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "MessageAttribute")
         `((module-name . ,module-name) (module-name-camel . ,(ainog-graphql/module-name-camel module-name)) (queries . "") (mutations . "") (comment . "消息事件中包含的属性")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "TemplateMessageGroup")
         `((module-name . ,module-name) (module-name-camel . ,(ainog-graphql/module-name-camel module-name)) (queries . "") (mutations . "") (comment . "消息分组模板")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "TemplateMessageEvent")
         `((module-name . ,module-name) (module-name-camel . ,(ainog-graphql/module-name-camel module-name)) (queries . "") (mutations . "") (comment . "消息事件模板")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "TemplateMessageAttribute")
         `((module-name . ,module-name) (module-name-camel . ,(ainog-graphql/module-name-camel module-name)) (queries . "") (mutations . "") (comment . "消息事件中包含的属性模板")
           (conditions . "")
           (inputs . "")
           (types . "")))

        ((string= module-name "Statement")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "报表")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "StatementColumn")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "报表中展示的字段")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "TemplateStatementGroup")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "报表模板分组")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "TemplateStatement")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "报表模板")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "TemplateStatementColumn")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "报表模板中展示的字段")
           (conditions . "")
           (inputs . "")
           (types . "")))

        ((string= module-name "Graph")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "图")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "GraphLink")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "图中包含的边")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "GraphNode")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "") (mutations . "")
           (comment . "图中包含的顶点")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "TemplateGraphGroup")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "图模板分组")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "TemplateGraph")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "图模板")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "TemplateGraphLink")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "图模板中包含的边")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "TemplateGraphNode")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "图模板中包含的顶点")
           (conditions . "")
           (inputs . "")
           (types . "")))


        ((string= module-name "TemplateSolution")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "解决方案模板")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "TemplateSolutionGraph")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "解决方案模板中的图模板")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "TemplateSolutionStatement")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "解决方案模板中的报表模板")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "TemplateSolutionDiagram")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "解决方案模板中的图表模板")
           (conditions . "")
           (inputs . "")
           (types . "")))
        ((string= module-name "TemplateSolutionMessage")
         `((module-name . ,module-name)
           (module-name-camel . ,(ainog-graphql/module-name-camel module-name))
           (queries . "")
           (mutations . "")
           (comment . "解决方案模板中的消息模板")
           (conditions . "")
           (inputs . "")
           (types . "")))
        (t (error module-name))))

;;;###autoload
(defun ainog-graphql/models-to-graphqls-condition (module-obj-alist)
  (let* ((module-name (alist-get 'module-name module-obj-alist))
        (module-name-camel (alist-get 'module-name-camel module-obj-alist))
        (comment (alist-get 'comment module-obj-alist))
        (conditions (alist-get 'conditions module-obj-alist))
        (method "\n    # 根据创建时间排序(负数为降序，正数为升序，一次请求中的绝对值越大，相对排序条件越靠前)
    orderByCreateTime: Int
    # 根据最后修改时间排序(负数为降序，正数为升序，一次请求中的绝对值越大，相对排序条件越靠前)
    orderByLastModifyTime: Int
    # 本次请求筛选方式（和条件，或条件）
    conditionMethod: String
}\n")
        (condition (format "# %s筛选条件对象集合
input %sCondition {
    # 通过Id筛选
    id: Int
    # 通过Id列表筛选
    idList: [Int]
    # Id列表筛选方式（和条件，或条件）
    idListMethod: String" comment module-name))
        (condition (if (string-empty-p conditions)
                       (format "%s%s" condition method)
                     (format "%s%s%s" condition conditions method))))
    condition))

;;;###autoload
(defun ainog-graphql/models-to-graphqls-query (module-obj-alist)
  (let* ((module-name (alist-get 'module-name module-obj-alist))
        (module-name-camel (alist-get 'module-name-camel module-obj-alist))
        (comment (alist-get 'comment module-obj-alist))
        (queries (alist-get 'queries module-obj-alist))
        (mutations (alist-get 'mutations module-obj-alist))
        (queries-statement (format "# 扩展基本查询结构，用于%s查询
extend type Query {
    # 获取%s列表
    %sList(condition: %sCondition): [%s]
    # 获取单个%s对象，根据条件筛选若有多个，则只返回第一个
    %sObject(condition: %sCondition): %s" comment comment
    module-name-camel module-name module-name
    comment
    module-name-camel module-name module-name))
        (queries-statement (if (string-empty-p queries)
                               (format "%s\n}\n\n" queries-statement)
                             (format "%s\n    %s\n}\n\n" queries-statement queries)))
        (mutation-statement (format "# 扩展输入结构，用于%s增，删，改
extend type Mutation {
    # 创建%s对象，通过列表新增
    %sCreate(%sList: [%sInput]): [%s]
    # 通过ID修改%s对象
    %sUpdate(id: Int, %s: %sInput): %s
    # 根据查询条件，删除%s对象
    %sDelete(condition: %sCondition): Int" comment comment
module-name-camel module-name-camel module-name module-name
comment
module-name-camel module-name-camel module-name module-name
comment
module-name-camel module-name))
        (mutation-statement (if (string-empty-p mutations)
                                (format "%s\n}\n\n\n" mutation-statement)
                              (format "%s\n    %s\n}\n\n\n" mutation-statement mutations))))
    (concat queries-statement mutation-statement)))

;;;###autoload
(defun ainog-graphql/models-to-graphqls-type (origin-obj module-obj-alist)
  (let* ((type (alist-get 'types module-obj-alist))
         (comment (alist-get 'comment module-obj-alist))
         (origin-obj (replace-regexp-in-string "^type" (format "# %s查询结构\ntype" comment) origin-obj))
         (origin-obj (replace-regexp-in-string "添加者ID" "添加的管理员" origin-obj))
         (origin-obj (if (string-match "Member" module-name)
                         (replace-regexp-in-string "roleId: Int" "memberRole: MemberRole" origin-obj)
                       (replace-regexp-in-string "roleId: Int" "adminRole: AdminRole" origin-obj)))
         (origin-obj (replace-regexp-in-string "adminId: Int" "admin: AdminAccount" origin-obj))
         (origin-obj (replace-regexp-in-string "adminId: Int" "admin: AdminAccount" origin-obj))
         (origin-obj (replace-regexp-in-string "[ ]+typeId: Int" "    type: DataDictionary" origin-obj))
         (origin-obj (replace-regexp-in-string ".+\n[ ]+memberId: Int\n.+\n[ ]+memberAccountId: Int" "    # 创建对象的用户账户\n    memberAccount: MemberAccount" origin-obj))
         (origin-obj (replace-regexp-in-string "memberId: Int" "member: Member" origin-obj))
         (origin-obj (replace-regexp-in-string "memberAccountId: Int" "memberAccount: MemberAccount" origin-obj))
         (origin-obj (replace-regexp-in-string "fileTypeId: Int" "fileType: DataDictionary" origin-obj))
         (origin-obj (replace-regexp-in-string "belongTypeId: Int" "belongType: DataDictionary" origin-obj))
         (origin-obj (replace-regexp-in-string "diagramTypeId: Int" "diagramType: TemplateDiagramType" origin-obj))
         (origin-obj (if (string-empty-p type)
                         origin-obj
                       (replace-regexp-in-string "}" (format "    %s\n}" type) origin-obj))))
    origin-obj))

;;;###autoload
(defun ainog-graphql/models-to-graphqls-input (origin-obj module-obj-alist)
  (let* ((module-name (alist-get 'module-name module-obj-alist))
        (module-name-camel (alist-get 'module-name-camel module-obj-alist))
        (comment (alist-get 'comment module-obj-alist))
        (inputs (alist-get 'inputs module-obj-alist))
        (input-statement (replace-regexp-in-string "^type" "input" origin-obj))
        (input-statement (replace-regexp-in-string " {" "Input {" input-statement))
        (input-statement (replace-regexp-in-string ".*# 主键自增ID\n.*\n" "" input-statement))
        (input-statement (replace-regexp-in-string ".*\n.*adminId.*\n" "" input-statement))
        (input-statement (replace-regexp-in-string ".*\n.*memberId.*\n" "" input-statement))
        (input-statement (replace-regexp-in-string ".*\n.*memberAccountId.*\n" "" input-statement))
        (input-statement (replace-regexp-in-string ".*# 最后修改时间\n.*\n" "" input-statement))
        (input-statement (replace-regexp-in-string ".*# 创建时间\n.*\n" "" input-statement))
        (input-statement (if (string-empty-p inputs)
                         input-statement
                       (replace-regexp-in-string "}" (format "%s\n}" inputs) input-statement))))
    input-statement))

;;;###autoload
(defun ainog-graphql/models-to-graphqls ()
  (shell-command "~/ainog/models-to-graphql-type")
  (with-temp-buffer
    (insert-file-contents "/tmp/generate_tmp")
    (goto-char (point-min))
    (while (search-forward-regexp "#.+\ntype \\([A-Za-z]+\\) {" nil t)
      (catch 'next
        (setq module-name (match-string 1))
        (toggle-case-fold-search)
        (cond ((string= "DataDictionary" module-name)
               (setq export-file-name "data_dictionary"))

              ((or (string-match "[A-Za-z]+RolePermission" module-name)
                   (string= "MemberAccountPermission" module-name)
                   (string= "ComboService" module-name)
                   (string= "OrderformService" module-name))
               (toggle-case-fold-search)
               (throw 'next nil))

              ((string-match "Template\\([A-Z]\?[a-z]+\\)" module-name)
               (setq export-file-name (format "template_%s" (downcase (match-string 1 module-name)))))

              ((string-match "[A-Z]\?[a-z]+" module-name)
               (setq export-file-name (downcase (match-string 0 module-name)))))
        (toggle-case-fold-search)

      (setq export-file-name (format "~/ainog/ainog-graphql/admin/%s.graphqls" export-file-name))

      (setq module-obj-alist (ainog-graphql/module-generator-alist module-name))

      (setq origin-position (line-beginning-position))
      (search-forward "}")
      (setq end-position (line-end-position))
      (setq origin-statement (buffer-substring origin-position end-position))

      (write-region (format "%s\n\n%s\n%s\n\n%s"
                            (ainog-graphql/models-to-graphqls-type origin-statement module-obj-alist)
                            (ainog-graphql/models-to-graphqls-condition module-obj-alist)
                            (ainog-graphql/models-to-graphqls-input origin-statement module-obj-alist)
                            (ainog-graphql/models-to-graphqls-query module-obj-alist))
                    nil export-file-name 'append))))
  (shell-command "~/ainog/delete-truncate-lines-end-of-file"))
