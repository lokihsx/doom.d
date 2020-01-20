;;; private/loki-org-helper/config.el -*- lexical-binding: t; -*-


(defmacro +loki/org-document-comment-select (comp prompt complist)
  `(defun loki/org-document-comment-select (comp)
    (interactive (list (completing-read ,prompt ,complist)))
    comp))

(defun loki/org-document-comment-person ()
  (interactive)
  (+loki/org-document-comment-select nil "[负责人]：" (list "刘忠雨" "黄诗雄" "王宗清" "王洪斌" "黄埔" "李彦霖" "周兵" "宋博" "曹佳豪" "洪晓龙" "周兵" "侯磊" "刘思乡" "张聘"))
  (call-interactively 'loki/org-document-comment-select))

(defun loki/org-document-comment-deadline (days)
  (interactive
   (list (read-string "任务工期（天）[default 0]：")))

  (setq days (if (string-empty-p days) 0 (string-to-number days)))
  (format-time-string
   "%Y-%m-%d %a"
   (time-add (current-time) (days-to-time days))))
