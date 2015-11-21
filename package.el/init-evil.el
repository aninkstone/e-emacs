;;evil setting
(add-to-list 'load-path "~/.emacs.d/el-get/evil") ;
(add-to-list 'load-path "~/.emacs.d/el-get/goto-chg")
(add-to-list 'load-path "~/.emacs.d/el-get/undo-tree")
(require 'evil)

(setq evil-find-skip-newlines t)
(setq evil-move-cursor-back nil evil-cross-lines t)
(setq evil-mode-line-format nil)

(setq evil-normal-state-tag   (propertize "N" 'face '((:background "green" :foreground "black")))
      evil-emacs-state-tag    (propertize "E" 'face '((:background "orange" :foreground "black")))
      evil-insert-state-tag   (propertize "I" 'face '((:background "red")))
      evil-motion-state-tag   (propertize "M" 'face '((:background "blue")))
      evil-visual-state-tag   (propertize "V" 'face '((:background "grey80" :foreground "black")))
      evil-operator-state-tag (propertize "O" 'face '((:background "purple"))))

;;disable evil mode in list
(loop for (mode . state) in '((inferior-emacs-lisp-mode     . emacs)
                              (gtags-select-mode            . emacs)
                              (shell-mode                   . emacs)
                              (eshell-mode                  . emacs)
                              (term-mode                    . emacs)
                              (rdictcc-buffer-mode          . emacs)
                              ;;(org-mode                     . emacs)
                              (cscope-list-entry-mode       . emacs) ;;FIMXE: doesn't work
                              (erc-mode                     . emacs))
      do (evil-set-initial-state mode state))

                              ;;(magit-branch-manager-mode    . emacs)
                              ;;(semantic-symref-results-mode . emacs)
                              ;;(bs-mode                      . emacs)
                              ;;(erc-mode                     . normal)


(evil-add-hjkl-bindings magit-branch-manager-mode-map 'emacs
  "K" 'magit-discard-item
  "L" 'magit-key-mode-popup-logging
  (kbd "C-f") 'evil-scroll-page-down
  (kbd "C-b") 'evil-scroll-page-up)

(evil-add-hjkl-bindings magit-status-mode-map 'emacs
  "K" 'magit-discard-item
  "l" 'magit-key-mode-popup-logging
  "h" 'magit-toggle-diff-refine-hunk
  (kbd "C-d") 'evil-scroll-page-down
  (kbd "C-u") 'evil-scroll-page-up)

(evil-add-hjkl-bindings magit-log-mode-map 'emacs
  "K" 'magit-discard-item
  "l" 'magit-key-mode-popup-logging
  "h" 'magit-toggle-diff-refine-hunk)

(define-key evil-normal-state-map  (kbd "C-u") 'evil-scroll-page-up)
(define-key evil-visual-state-map  (kbd "C-u") 'evil-scroll-page-up)
(define-key evil-insert-state-map  (kbd "C-u") 'evil-scroll-page-up)
(define-key evil-replace-state-map (kbd "C-u") 'evil-scroll-page-up)

;;; define esc equal to C-G
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)

(define-key minibuffer-local-map [escape] 'abort-recursive-edit)
(define-key minibuffer-local-ns-map [escape] 'abort-recursive-edit)
(define-key minibuffer-local-completion-map [escape] 'abort-recursive-edit)
(define-key minibuffer-local-must-match-map [escape] 'abort-recursive-edit)
(define-key minibuffer-local-isearch-map [escape] 'abort-recursive-edit)

;;; remap on dired mode
(eval-after-load 'dired
  '(progn
     ;; use the standard Dired bindings as a base
     (evil-make-overriding-map dired-mode-map 'normal t)
     (evil-define-key 'normal dired-mode-map
       "h" 'evil-backward-char
       "j" 'evil-next-line
       "k" 'evil-previous-line
       "l" 'evil-forward-char
       "J" 'dired-goto-file       ; "j"
       "K" 'dired-do-kill-lines   ; "k"
       "r" 'dired-do-redisplay))) ; "l"


;;; Auto-complete
(eval-after-load 'auto-complete
  '(progn
     (evil-set-command-properties 'ac-complete :repeat 'evil-ac-repeat)
     (evil-set-command-properties 'ac-expand :repeat 'evil-ac-repeat)
     (evil-set-command-properties 'ac-next :repeat 'ignore)
     (evil-set-command-properties 'ac-previous :repeat 'ignore)

     (defvar evil-ac-prefix-len nil
       "The length of the prefix of the current item to be completed.")

     (defun evil-ac-repeat (flag)
       "Record the changes for auto-completion."
       (cond ((eq flag 'pre)
              (setq evil-ac-prefix-len (length ac-prefix))
              (evil-repeat-start-record-changes))
             ((eq flag 'post)
              ;; Add change to remove the prefix
              (evil-repeat-record-change (- evil-ac-prefix-len) "" evil-ac-prefix-len)
              ;; Add change to insert the full completed text
              (evil-repeat-record-change (- evil-ac-prefix-len) (buffer-substring-no-properties (- evil-repeat-pos evil-ac-prefix-len) (point)) 0)
              ;; Finish repeation
              (evil-repeat-finish-record-changes))))))

;;;;disable evil default leader map
(define-key evil-motion-state-map "\\" nil)
(define-key evil-motion-state-map "\\bb" 'buffer-menu)
(define-key evil-motion-state-map (kbd "C-6") 'evil-buffer)

;;helm key binding
(define-key evil-motion-state-map "\\be" 'helm-buffers-list)
(define-key evil-motion-state-map "\\gg" 'helm-gtags-find-tag)
(define-key evil-motion-state-map "\\gr" 'helm-gtags-find-rtag)

;;magit key binding
(define-key evil-motion-state-map "\\gs" 'magit-status)
(define-key evil-motion-state-map "\\gl" 'magit-log)
(define-key evil-motion-state-map "\\gb" 'magit-branch-manager)
(define-key evil-motion-state-map "\\gf" 'magit-pull)
(define-key evil-motion-state-map "\\gp" 'magit-push)

(define-key evil-motion-state-map "\\m" 'highlight-symbol)
(define-key evil-motion-state-map "\\n" 'highlight-symbol-remove-all)

(evil-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(require 'evil-search)

(evil-define-motion evil-search-forward ()
  (format "Search forward for user-entered text. Searches for regular expression if `evil-regexp-search' is t.%s"
          (if (and (fboundp 'isearch-forward)
                   (documentation 'isearch-forward))
              (format "\n\nBelow is the documentation string for `isearch-forward',\nwhich lists available keys:\n\n%s"
                      (documentation 'isearch-forward)) ""))
  :type exclusive
  (evil-search-incrementally t evil-regexp-search))

(evil-define-motion evil-search-backward ()
  (format "Search backward for user-entered text. Searches for regular expression if `evil-regexp-search' is t.%s"
          (if (and (fboundp 'isearch-forward)
                   (documentation 'isearch-forward))
              (format "\n\nBelow is the documentation string for `isearch-forward',\nwhich lists available keys:\n\n%s"
                      (documentation 'isearch-forward)) ""))
  :jump t
  :type exclusive
  (evil-search-incrementally nil evil-regexp-search))

(evil-define-motion evil-search-symbol-backward (count)
  "Search backward for symbol under point."
  :jump t
  :type exclusive
  (dotimes (var (or count 1))
    (evil-search-symbol nil)))

(evil-define-motion evil-search-symbol-forward (count)
  "Search forward for symbol under point."
  :jump t
  :type exclusive
  (dotimes (var (or count 1))
    (evil-search-symbol t)))


(defun evil-search-symbol (forward)
  "Search for symbol near point. If FORWARD is nil, search backward, otherwise forward."
  (let ((string (car-safe regexp-search-ring))
        (move (if forward 'forward-char 'backward-char))
        (end (if forward 'eobp 'bobp)))
    (setq isearch-forward forward)
    (cond
     ((and (memq last-command
                 '(evil-search-symbol-forward
                   evil-search-symbol-backward))
           (stringp string)
           (not (string= string "")))
      (evil-search string forward t))
     (t
      (setq string (evil-find-symbol forward))
      (if (null string)
          (error "No symbol under point")
        (setq string (format "\\_<%s\\_>" (regexp-quote string))))
      (evil-search string forward t)))))

(define-key evil-motion-state-map "*" 'evil-search-symbol-forward)
