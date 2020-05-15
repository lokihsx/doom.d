(defun loki-postgres-debug ()
  (interactive)
 ;; (setq gud-gdb-history (format "gdb -i=mi -p %d" (string-to-number (shell-command-to-string "ps -ef | awk '/postgres/&&/idle$/{print $2}'"))))
  (call-interactively 'gdb))

(defun loki-postgres-compile ()
  (interactive)
  (async-shell-command (format "cd $HOME/work_station/postgres && bear --append make -j9 install > /dev/null")))
