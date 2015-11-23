;;Always execute dired-k when dired buffer is opened
(eval-after-load "dired"
  '(progn
     (define-key dired-mode-map "g" 'dired-k)))

(add-hook 'dired-initial-position-hook 'dired-k)

