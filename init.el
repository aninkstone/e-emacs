;;this is the emacs config file
;;el-get config
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)

(setq el-get-user-package-directory "~/.emacs.d/package.el/")
;;set our own packages 
(setq
 emitX:el-get-packages
 '(el-get                ; el-get is self-hosting
   linum+                ; improve linum mode
   dired-k               ; dired-k
   evil                  ; vi emulator
   auto-complete         ; complete as you type with overlays
   ;;moe-theme             ; 
   helm                  ; helm
   helm-gtags            ; helm-gtags
   powerline             ; powerline
   spacemacs-theme       ; spacemacs theme
   spaceline             ; spaceline
   switch-window         ; switch window
   ido-vertical-mode     ; ido vertical
   projectile            ; projectile
   highlight-symbol      ; highlight-symbol
   yasnippet             ; yasnippet
   yasnippet-snippets    ; yasnippet templates
   ;;emacs-window-manager  ; 
   ;color-theme-tangotango-improve ; check out color-theme-solarized
   magit))                ; emacs git client

;; Some recipes require extra tools to be installed
;;
;; Note: el-get-install requires git, so we know we have at least that.
;;
(setq emitX:el-get-packages
      (append emitX:el-get-packages
              (mapcar #'el-get-source-name el-get-sources)))

;; Install packages and init already installed packages
(el-get 'sync emitX:el-get-packages)

;;default key rebindind
(define-prefix-command 'master-sense-map)
(global-set-key (kbd "C-\\") 'master-sense-map)
(define-key master-sense-map (kbd "C-\\") 'helm-M-x)
(define-key master-sense-map (kbd "r") 'rgrep)
(define-key master-sense-map (kbd "gg") 'helm-gtags-find-tag)
(define-key master-sense-map (kbd "gr") 'helm-gtags-find-rtag)
(define-key master-sense-map (kbd "t") 'helm-imenu)
(define-key master-sense-map (kbd "ww") 'e2wm:start-management)
(define-key master-sense-map (kbd "wc") 'e2wm:stop-management)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq auto-save-default nil)

(setq-default c-basic-offset 4
              tab-width 4)
(setq indent-line-function 'insert-tab)

(setq tab-stop-list 
      '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80
      84 88 92 96 100 104 108 112 116 120 124))

(funcall (lambda ()
  ;;this function will call at end of this file
  (setq make-backup-files nil)
  (setq make-backup-files nil)
  ;;(setq-default tab-width nil)
  (global-auto-revert-mode nil)))

(if (eq system-type "darwin")
    ;;append brew path
    (setq PATH (format "%s:%s" "/usr/local/bin" (getenv "PATH")))
    (setq exec-path (append exec-path '("/usr/local/bin"))))

(setq auto-mode-alist
   (append
    '(("\\.cc$"                . c++-mode)
     ("\\.cpp$"                . c++-mode)
     ("\\.ipp$"                . c++-mode)
     ("\\.hpp$"                . c++-mode)
     ("\\.h[r]?[0-9]*[a-z]?$"  . c++-mode))
    auto-mode-alist))

;;for good for window manager
;;(global-hl-line-mode t)

;; Put this one at the front of the list to override the default
;; c-mode association.
(setq auto-mode-alist (cons (cons "\\.h$" 'c++-mode) auto-mode-alist))

(setq nxml-child-indent 4)  ;; work convention is 4 spaces for HTML, etc
(setq nxml-outline-child-indent 4)
(setq mumamo-submode-indent-offset 4)
(setq sgml-basic-offset 4)

;;show current time
(display-time-mode 1)
;; set font on linux (ubuntu) 等宽字体设置
;;(if (eq system-type 'gnu/linux)
;;    (if (display-graphic-p)
;;        (progn (set-default-font "Ubuntu Mono:pixelsize=16") 
;;               (dolist (charset '(kana han symbol cjk-misc bopomofo)) 
;;                 (set-fontset-font (frame-parameter nil 'font) 
;;                                   charset 
;;                                   (font-spec :family "WenQuanYi Micro Hei" :size 16))))))

(defalias 'make 'compile)
(defalias 'fd   'find-name-dired)
(defalias 'nu   'linum-mode)

;;(setq user-full-name "Daniel C")
;;set default email address
;;(setq user-mail-address "thatways.c@gmail.com") 

;;;Intent setup
(defun long-arguments-indent-setup () (c-set-offset 'arglist-intro '+))
(add-hook 'c-mode-hook 'long-arguments-indent-setup)
(add-hook 'c++-mode-hook 'long-arguments-indent-setup)

;;;force vertical split
(setq split-height-threshold 0)
(setq split-width-threshold nil)

;;(set-face-attribute 'default nil :family "Inconsolata" :height 192 :weight 'normal)

;;default code page setting
(prefer-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8-unix)
(setq default-file-name-coding-system 'utf-8-unix)
;;(setq default-keyboard-coding-system 'utf-8-unix)
;;(setq default-process-coding-system '(utf-8-unix . utf-8-unix))
;;(setq default-sendmail-coding-system 'utf-8-unix)
;;(setq default-terminal-coding-system 'utf-8-unix)

;;scrolling setup
(setq scroll-step 1 scroll-conservatively 10000)

;;org-mode init
(load-file "~/.emacs.d/package.el/init-org-mode.el")
;;ede-mode init
(load-file "~/.emacs.d/package.el/init-ede-mode.el")
