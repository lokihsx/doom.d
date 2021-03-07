;;; private/ainoggraph/ainoggraph.el -*- lexical-binding: t; -*-

(defvar ainog-graph-ws nil
  "is server connect")

(defun ainog-graph/init-editor ()
  (interactive)
  (setq ainog-graph-ws (websocket-open
            "ws://localhost:18889"
            :on-open (lambda (ws)
                       (websocket-send-text
                        ws
                        "{\"header\": \"register-editor\"}"))
            :on-message (lambda (_websocket frame)
                          (message (websocket-frame-text frame))
                          (ainog-graph/message-handler (websocket-frame-text frame)))
            )))

(defun ainog-graph/message-handler(msg)
  (let* ((htable (json-parse-string msg))
         (header (gethash "header" htable)))
    (cond
     ((string= header "new-node")
      (message (gethash "msg" htable)))
     ((string= header "new-link")
      (message (gethash "msg" htable)))
     ((string= header "navigate-to-graph")
      (message (gethash "msg" htable)))
     ((string= header "navigate-to-node")
      (message (gethash "msg" htable)))
     ((string= header "navigate-to-link")
      (message (gethash "msg" htable)))
     ((string= header "delete-graph")
      (message (gethash "msg" htable)))
     ((string= header "delete-node")
      (message (gethash "msg" htable)))
     ((string= header "delete-link")
      (message (gethash "msg" htable)))
     )))

(defun ainog-graph/send-request (request)
  (websocket-send-text ainog-graph-ws (json-encode request)))

(defun ainog-graph/set-background ()
  (interactive)
  (ainog-graph/send-request
   `((header . set-background)
     (background . ,(face-attribute 'default :background)))))

(defun ainog-graph/new-graph ()
  (interactive))

(defun ainog-graph/new-node ()
  (interactive)
  (ainog-graph/send-request
   '((header . new-node)
     (node . ((id . newNode)
              (label . 新节点)
              (description . 新节点)
              (type . set))))))

(defun ainog-graph/node-changed ()
  (interactive))

(defun ainog-graph/add-nodes ()
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

(defun ainog-graph/new-link ()
  (interactive)
  (ainog-graph/send-request
   '((header . new-link)
     (link . ((id . newLink)
              (label . 新边)
              (description . 新边)
              (source . add1)
              (target . add2))))))

(defun ainog-graph/link-changed ()
  (interactive))

(defun ainog-graph/add-links ()
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
               (target . add1)))))))

(defun ainog-graph/navigate-to-graph ()
  (interactive)
  (ainog-graph/send-request
   `((header . ,(which-function))
     (graphId . graph1))))

(defun ainog-graph/navigate-to-node ()
  (interactive)
    (ainog-graph/send-request
     `((header . ,(which-function))
       (nodeId . add1))))

(defun ainog-graph/navigate-to-link ()
  (interactive)
    (ainog-graph/send-request
     `((header . ,(which-function))
       (nodeId . newLink))))

(defun ainog-graph/delete-graph ()
  (interactive))

(defun ainog-graph/delete-node ()
  (interactive))

(defun ainog-graph/delete-link ()
  (interactive)
    (ainog-graph/send-request
     `((header . ,(which-function))
       (nodeId . newLink))))

(provide 'ainog-graph)
