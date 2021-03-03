;;; private/ainog/config.el -*- lexical-binding: t; -*-

(custom-set-variables
 '(sql-connection-alist
   '(("ainog-pg"
      (sql-product 'postgres)
      (sql-user "ainog")
      (sql-database "ainog")
      (sql-server "localhost")
      (sql-password "123456")))))
