;;Always execute dired-k when dired buffer is opened
(eval-after-load "dired"
  '(progn
     (define-key dired-mode-map "g" 'dired-k)))

(add-hook 'dired-initial-position-hook 'dired-k)

(require 'dired-x)
(setq-default dired-omit-files-p t) ; Buffer-local variable
(setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))

