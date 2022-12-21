(add-hook 'savehist-mode-hook '(lambda ()
                                 (defvar generated-history '())
                                 (add-to-list 'savehist-additional-variables 'generated-history)))
