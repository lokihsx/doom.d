;;; private/i3wm/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun i3-get-next-workspace ()
  (let* ((ws-nums (mapcar (apply-partially #'i3-field 'num) (i3-get-workspaces)))
         (ws-range (number-sequence 1 (seq-max ws-nums)))
         (gap (car (-difference ws-range ws-nums))))
    (if gap
        gap
      (1+ (length ws-nums)))))

;;;###autoload
(defun i3-get-visible-workspaces ()
  (i3-map-and-filter (lambda(w) (when (i3-field-is 'visible #'eq t w) w))

                     (i3-get-workspaces)))

;;;###autoload
(defun i3-get-current-visible-workspaces ()
  (i3-map-and-filter (lambda(w)
                       (when (i3-field-is 'focused #'eq t w) w))
                     (i3-get-visible-workspaces)))

;;;###autoload
(defun i3-get-other-visible-workspaces ()
  (i3-map-and-filter (lambda(w)
                       (when (i3-field-is 'focused #'eq :json-false w) w))
                     (i3-get-visible-workspaces)))

;;;###autoload
(defun i3-get-visible-windows-by-workspaces (&optional workspaces)
  (let ((visible-workspace-names (if workspaces workspaces (i3-get-visible-workspace-names))))
    (i3-flatten
     (mapcar i3-collect-windows-function
             (i3-flatten (i3-map-and-filter (lambda(w)
                                              (when (i3-field-is 'name #'member visible-workspace-names w)
                                                (append (i3-field 'nodes w) nil)));convert vector to list
                                            (i3-collect-workspaces (i3-get-tree-layout))))))))

;;;###autoload
(defun i3-get-windows-ids-by-workspaces (workspaces)
  (mapcar (apply-partially #'i3-field 'window)
          (i3-get-visible-windows-by-workspaces workspaces)))

;;;###autoload
(defun i3-get-current-window-id ()
  (i3-map-and-filter (lambda(w)
                       (when (i3-field-is 'focused #'eq t w) (i3-field 'id w)))
                     (i3-get-visible-windows)))

;;;###autoload
(defun i3-get-visible-windows-names-by-workspaces (workspaces)
  (mapcar (apply-partially #'i3-field 'name) (i3-get-visible-windows-by-workspaces workspaces)))

;;;###autoload
(defun i3-get-window-id-by-name (name)
  (i3-map-and-filter (lambda(x) (when (string= (i3-field 'name x) name) (i3-field 'window x)))
                     (i3-get-visible-windows)))

;;;###autoload
(defun i3-tar-window-choice (&optional output)
  (let* ((wins (i3-get-visible-windows))
         (tar-output (i3-field 'output (car (i3-get-other-visible-workspaces))))
         (tar-wins (i3-map-and-filter (lambda (win) (when (i3-field-is 'output  #'string= tar-output win) win)) wins)))
    (list (if (> (length tar-wins) 1)
              (completing-read "Move to Main Window:" (mapcar (apply-partially #'i3-field 'name) tar-wins))
            (i3-field 'name (car tar-wins))))))
