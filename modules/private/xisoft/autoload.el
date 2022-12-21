
;;;###autoload
(defun xisoft/random-alnum ()
  (let* ((alnum "abcdefghijklmnopqrstuvwxyz0123456789")
         (i (% (abs (random)) (length alnum))))
    (substring alnum i (1+ i))))

;;;###autoload
(defun random-8-letter-string ()
  (concat
    (xisoft/random-alnum)
    (xisoft/random-alnum)
    (xisoft/random-alnum)
    (xisoft/random-alnum)
    (xisoft/random-alnum)
    (xisoft/random-alnum)
    (xisoft/random-alnum)
    (xisoft/random-alnum)))

;;;###autoload
(defun xisoft/found-not-exists ()
  (let ((str (random-8-letter-string)))
    (when (member str generated-history)
      (setq str (xisoft/found-not-exists)))
    (add-to-list 'generated-history str)
    str))

;;;###autoload
(defun xisoft/random-product-id ()
  (interactive)
  (insert (xisoft/found-not-exists)))

