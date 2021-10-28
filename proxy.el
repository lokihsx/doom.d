;;; ~/.doom.d/custom-config.el -*- lexical-binding: t; -*-

(setq url-proxy-services '(("http" . "loki-workstation:12333")
                           ("https" . "loki-workstation:12333")))

;; NOTE: Don't enable this unless you know what you do!
;; (setq url-gateway-method 'socks)
;; (setq socks-server '("Default server" "loki-workstation" 1080 5))
