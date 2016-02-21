(add-to-list 'load-path "~/.emacs.d/el-get/php-mode") ;
;;(add-to-list 'load-path "~/.emacs.d/el-get/ac-php") ;

;;(require 'php-mode)
;;根据文件扩展名自动php-mode
(add-to-list 'auto-mode-alist '("\\.php[34]?\\'\\|\\.phtml\\'" . php-mode))
;;开发项目时，php源文件使用其他扩展名
(add-to-list 'auto-mode-alist '("\\.module\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc\\'" . php-mode))

;;(add-hook 'php-mode-hook
;;          (lambda ()
;;            (require 'php-completion)
;;            (php-completion-mode t)
;;            (define-key php-mode-map (kbd "C-o") 'phpcmp-complete)))

;;(add-hook  'php-mode-hook
;;           (lambda ()
;;             (when (require 'auto-complete nil t)
;;               (make-variable-buffer-local 'ac-sources)
;;               (add-to-list 'ac-sources 'ac-source-php-completion)
;;               ;; if you like patial match,
;;               ;; use `ac-source-php-completion-patial' instead of `ac-source-php-completion'.
;;               (add-to-list 'ac-sources 'ac-source-php-completion-patial)
;;               (auto-complete-mode t))))
