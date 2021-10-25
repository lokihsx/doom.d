;;; ~/.doom.d/custom-config.el -*- lexical-binding: t; -*-

(setq url-proxy-services '(("http" . "loki-workstation:8118")
                           ("https" . "loki-workstation:8118")))

(setq url-gateway-method 'socks)
(setq socks-server '("Default server" "loki-workstation" 1080 5))
