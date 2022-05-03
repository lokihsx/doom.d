;;; keybindings.el -*- lexical-binding: t; -*-

(map! :leader
      ;;; global map
      :i "C-h" #'delete-backward-char

      ;;; <leader> o --- open
      (:prefix-map ("o" . "open")
       :desc "Org agenda"       "A"  #'org-agenda
       (:prefix ("a" . "org agenda")
        :desc "Agenda"         "a"  #'org-agenda
        :desc "Todo list"      "t"  #'org-todo-list
        :desc "Tags search"    "m"  #'org-tags-view
        :desc "View search"    "v"  #'org-search-view)
       :desc "Default browser"    "b"  #'browse-url-of-file
       :desc "Start debugger"     "d"  #'+debugger/start
       ;; :desc "New frame"          "f"  #'make-frame
       :desc "REPL"               "r"  #'+eval/open-repl-other-window
       :desc "REPL (same window)" "R"  #'+eval/open-repl-same-window
       :desc "Dired"              "-"  #'dired-jump
       (:when (featurep! :ui neotree)
        :desc "Project sidebar"              "p" #'+neotree/open
        :desc "Find file in project sidebar" "P" #'+neotree/find-this-file)
       (:when (featurep! :ui treemacs)
        :desc "Project sidebar" "p" #'+treemacs/goto
        :desc "Find file in project sidebar" "P" #'treemacs-find-file)
       (:when (featurep! :term shell)
        :desc "Toggle shell popup"    "t" #'+shell/toggle
        :desc "Open shell here"       "T" #'+shell/here)
       (:when (featurep! :term term)
        :desc "Toggle terminal popup" "t" #'+term/toggle
        :desc "Open terminal here"    "T" #'+term/here)
       (:when (featurep! :term vterm)
        :desc "Toggle vterm popup"    "t" #'+vterm/toggle
        :desc "Open vterm here"       "T" #'+vterm/here)
       (:when (featurep! :private i3wm)
        :desc "Toggle new frame"      "w" #'i3/open-new-frame
        :desc "Follow Focus"          "f" #'i3/follow-focus
        :desc "close generate frame"  "F" #'i3/close-frame
        :desc "close generate frame"  "W" #'i3/close-frame)
       (:when (featurep! :lang org +journal)
        :desc "Toggle org journal" "j" #'+org-journal/toggle)
       (:when (or (featurep! :term eshell)
                  (featurep! :private myterm))
        :desc "Toggle eshell popup"   "e" #'+eshell/toggle
        :desc "Open eshell here"      "E" #'+eshell/here)
       (:when (featurep! :os macos)
        :desc "Reveal in Finder"           "o" #'+macos/reveal-in-finder
        :desc "Reveal project in Finder"   "O" #'+macos/reveal-project-in-finder
        :desc "Send to Transmit"           "u" #'+macos/send-to-transmit
        :desc "Send project to Transmit"   "U" #'+macos/send-project-to-transmit
        :desc "Send to Launchbar"          "l" #'+macos/send-to-launchbar
        :desc "Send project to Launchbar"  "L" #'+macos/send-project-to-launchbar
        :desc "Open in iTerm"              "i" #'+macos/open-in-iterm)
       (:when (featurep! :tools docker)
        :desc "Docker" "D" #'docker)
       (:when (featurep! :email mu4e)
        :desc "mu4e" "m" #'=mu4e)
       (:when (featurep! :email notmuch)
        :desc "notmuch" "m" #'=notmuch)
       (:when (featurep! :email wanderlust)
        :desc "wanderlust" "m" #'=wanderlust)))
