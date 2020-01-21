;;; private/loki-org-helper/config.el -*- lexical-binding: t; -*-


(defcustom loki/persons-in-charge-prompt "[负责人]："
  "person prompt"
  :type 'string)

(defcustom loki/task-deadline-prompt "任务工期（天）[default 0]："
  "task_deadline prompt"
  :type 'string)

(defcustom loki/persons-in-charge-list
  (list "刘忠雨" "黄诗雄" "王宗清" "王洪斌" "黄埔" "李彦霖" "周兵" "宋博" "曹佳豪" "洪晓龙" "周兵" "侯磊" "刘思乡" "张聘")
  "perple list"
  :type 'list)

(defcustom loki/persons-in-charge-list3
  '(
    (刘忠雨 . ((name . "刘忠雨")
     (hit-times . 0)
     (last-hit-time "2010-01-01")))

    (黄诗雄 . ((name . "黄诗雄")
     (hit-times . 0)
     (last-hit-time "2010-01-01")))

  "perple list"
  :type 'list))

   (mapcar
     #'(lambda (x)
         (message (format "(%s . ((name . \"%s\")
(hit-times . 0)
(last-hit-time . \"2020-01-01\"))\n" x x)))
     (list "刘忠雨" "黄诗雄" "王宗清" "王洪斌" "黄埔" "李彦霖" "周兵" "宋博" "曹佳豪" "洪晓龙" "周兵" "侯磊" "刘思乡" "张聘")
    )

(defcustom loki/task-date-format "%Y-%m-%d %a"
  "date format"
  :type 'string)

(defmacro +loki/org-document-comment-select (prompt complist &rest func)
  `(let ((res (completing-read ,prompt ,complist)))
     (if (and ',func (functionp ',@func))
         (,@func res)
      res)))

(defun loki/org-document-select-charge-person ()
  (let* ((person (+loki/org-document-comment-select
                 loki/persons-in-charge-prompt
                 (mapcar #'(lambda (x) (symbol-name (car x)))
                         loki/persons-in-charge-list2)))
         (sperson (intern person))
         (hitkey (assoc 'hit-times (cdr (assoc sperson loki/persons-in-charge-list2))))
         (hitvalue (1+ (cdr hitkey))))

    (setcdr hitkey hitvalue)))
