;;; private/myterm/autoload/common.el -*- lexical-binding: t; -*-

;;;###autoload
 (defun myterm-kill-window (&optional process event)
   (let* ((wind (get-buffer-window))
           (sym (window-parameter wind 'create-for-myterm)))
      (when sym
        (delete-window wind))))
