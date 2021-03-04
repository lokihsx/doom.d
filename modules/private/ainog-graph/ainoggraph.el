;;; private/ainoggraph/ainoggraph.el -*- lexical-binding: t; -*-

(defvar ainog-graph-ws nil
  "is server connect")

(defun init-ainog-graph ()
  (interactive)
  (setq ainog-graph-ws (websocket-open
            "ws://localhost:18889"
            :on-open (lambda (ws)
                       (websocket-send-text
                        ws
                        "{\"header\": \"register-editor\"}"))
            :on-message (lambda (_websocket frame)
                          (message (websocket-frame-text frame))
                          (msg-handler (websocket-frame-text frame))))))

(defun msg-handler(msg)
  (let* ((htable (json-parse-string msg))
         (header (gethash "header" htable)))
    (cond
     ((string= header "sss")
      (message (gethash "msg" htable)))
     )))


(json-encode '((header . add-nodes)
               (nodes . (
              ((Label . "emacs 添加1")
                (description . "emacs 添加1"))
              ((label . "emacs 添加2")
                (description . "emacs 添加2"))
              ))))

(defun ainog-graph/send-request (request)
  (websocket-send-text ainog-graph-ws (json-encode request)))

(defun set-background ()
  (interactive)
  (ainog-graph/send-request
   `((header . set-background)
     (background . ,(face-attribute 'default :background)))))

(defun add-nodes ()
  (interactive)
  (ainog-graph/send-request
   '((header . add-nodes)
     (nodes . (
               ((id . add1)
                (label . emacs添加1)
                (description . emacs添加1)
                (type . set))
               ((id . add2)
                (label . emacs添加2)
                (description . emacs添加2)
                (type . set))
              )))))

'((a . 1))
(json-encode
 '((header . add-links)
   (links . (
             ((label . "emacs 添加1")
              (description . "emacs 添加1")
              (source . add1)
              (target . add2))
             ((label . "emacs 添加2")
              (description . "emacs 添加2")
              (source . add2)
              (target . add1))
          ))))
(defun add-links ()
  (interactive)
  (ainog-graph/send-request
   '((header . add-links)
     (links . (
              ((label . "emacs 添加1")
               (description . "emacs 添加1")
               (source . add1)
               (target . add2))
              ((label . "emacs 添加2")
               (description . "emacs 添加2")
               (source . add2)
               (target . add1))
              )))))
