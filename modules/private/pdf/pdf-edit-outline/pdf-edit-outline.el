;;; private/pdf/pdf-edit-outline/edit-outline.el -*- lexical-binding: t; -*-

(define-derived-mode pdf-edit-outline-buffer-mode text-mode "PDF Edit Outline"
  "View and traverse the outline of a PDF file.

Press \\[pdf-outline-display-link] to display the PDF document,
\\[pdf-outline-select-pdf-window] to select it's window,
\\[pdf-outline-move-to-current-page] to move to the outline item
of the current page, \\[pdf-outline-follow-link] to goto the
corresponding page or \\[pdf-outline-follow-link-and-quit] to
additionally quit the Outline.

\\[pdf-outline-follow-mode] enters a variant of
`next-error-follow-mode'.  Most `outline-mode' commands are
rebound to their respective last character.

\\{pdf-outline-buffer-mode-map}")

;;;###autoload
(defun pdf-edit-outline-buffer-name (&optional pdf-buffer)
  (unless pdf-buffer (setq pdf-buffer (current-buffer)))
  (let ((buf (format "%s_outlines.toc" (file-name-sans-extension (buffer-name pdf-buffer)))))
    ;; (when (buffer-live-p (get-buffer buf))
    ;;   (kill-buffer buf))
    buf))

;;;###autoload
(defun pdf-edit-outline (&optional buffer no-select-window-p)
  "Display an PDF outline of BUFFER.

BUFFER defaults to the current buffer.  Select the outline
buffer, unless NO-SELECT-WINDOW-P is non-nil."
  (interactive (list nil (or current-prefix-arg
                             (consp last-nonmenu-event))))
  (let ((win
         (display-buffer
          (pdf-edit-outline-noselect buffer)
          pdf-outline-display-buffer-action)))
    (unless no-select-window-p
      (select-window win))))

;;;###autoload
(defun pdf-edit-outline-toc-process ()
 (goto-char (point-min))
 (search-forward-regexp " +(\\([0-9]+\\)\)$" nil t)
 (setq origin-start (string-to-number (match-string 1)))

 (if (eq origin-start 1)
     (setq origin-start 0)
   (setq origin-start (- origin-start 1)))
 (goto-char (point-min))
 (while (search-forward-regexp " +(\\([0-9]+\\)\)$" nil t)
   (replace-match (format " %d" (- (string-to-number (match-string 1)) origin-start)) t nil))
 origin-start)

;;;###autoload
(defun pdf-edit-outline-noselect (&optional buffer)
  "Create an PDF outline of BUFFER, but don't display it."
  (save-current-buffer
    (and buffer (set-buffer buffer))
    (pdf-util-assert-pdf-buffer)
    (let* ((pdf-buffer (current-buffer))
           (pdf-file (pdf-view-buffer-file-name))
           (pdf-window (and (eq pdf-buffer (window-buffer))
                            (selected-window)))
           (bname (pdf-edit-outline-buffer-name))
           (buffer-exists-p (get-buffer bname))
           (buffer (get-buffer-create bname)))
      (with-current-buffer buffer
        (unless buffer-exists-p
          (pdf-outline-insert-outline pdf-buffer)
          ;; (replace-regexp " +(\\([0-9]+\\)\)$" " \\1" nil (point-min) (point-max))
          (pdf-edit-outline-buffer-mode)
          (set (make-local-variable 'pdf-outline-start-page)
               (pdf-edit-outline-toc-process)))
        (set (make-local-variable 'pdf-buffer)
             (buffer-name pdf-buffer))
        (set (make-local-variable 'pdf-directory)
             (file-name-directory (buffer-file-name pdf-buffer)))
        (set (make-local-variable 'pdf-filename)
             (buffer-file-name pdf-buffer))
        (current-buffer)))))

(defun pdf-edit-outline-edited (&optional start)
  (interactive
   (list (read-number "Start Page At: " (1+ pdf-outline-start-page))))
  (let* ((filename (format "/tmp/%s" (buffer-name)))
         (gen-pdf-file (format "/tmp/%s_outlined.pdf" (file-name-sans-extension pdf-buffer)))
         (cmd (format "pdfoutliner %s --inpdf %s --outpdf %s -d \\s\\s -s %d"
                      filename pdf-filename gen-pdf-file start))
         (errbuf "*pdfoutliner process*")
         (pdf-filename pdf-filename)
         (pdf-buffer pdf-buffer))

    (message cmd)
    (with-current-buffer (current-buffer)
      (write-file filename))
    (shell-command cmd nil (get-buffer-create errbuf))

    (with-current-buffer errbuf
      (if (eq (length (buffer-string)) 0)
          (progn
            (delete-file pdf-filename)
            (delete-file filename)
            (rename-file gen-pdf-file pdf-filename)
            (kill-buffer errbuf))
        (pop-to-buffer errbuf)))

    (unless (get-buffer errbuf)
      (kill-buffer (current-buffer)))

    ;; (message pdf-buffer)
    ;; (message (buffer-name (current-buffer)))

    (when (or (string-equal (buffer-name (current-buffer)) pdf-buffer)
              (string-equal (buffer-name (current-buffer)) "*scratch*"))
      (+workspace/close-window-or-workspace)
      (pdf-outline))))


(provide 'pdf-edit-outline)
