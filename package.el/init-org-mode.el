(require 'ox)
(require 'ob)
(require 'ob-table)
(require 'org)

(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
(setq org-log-done 'time)
(setq org-log-done 'note)

;;(org-indent-mode 1)

(setq org-use-fast-todo-selection t)
;;(setq org-agenda-include-diary t)
;;(setq org-treat-S-cursor-todo-selection-as-state-change nil)

(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "NOTE(o)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" ))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("NOTE" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold))))

;;Fast Todo Selection
(setq org-use-fast-todo-selection t)
(setq org-treat-S-cursor-todo-selection-as-state-change nil)

(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t))
              ("WAITING" ("WAITING" . t))
              ("HOLD" ("WAITING" . t) ("HOLD" . t))
              (done ("WAITING") ("HOLD"))
              ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
              ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
              ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

;;Capture Templates

;;=======================================================================================
;;org-mode setup refile
;;=======================================================================================

(if (boundp 'org-directory)
    (message "Set org-directory to G:/ogers/orgs")
  (setq org-directory "G:/ogers/orgs"))

;;(setq org-default-notes-file (concat org-directory "/note.org"))
;;(setq org-agenda-files (list (concat org-directory "/jobs.org")
;;                             (concat org-directory "/note.org")))

;; I use C-c r to start capture mode when using SSH from my Android phone
(global-set-key (kbd "C-c r") 'org-capture)

;; Capture templates for: TODO tasks, Notes, appointments, phone calls, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file (concat org-directory "/jobs.org"))
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("n" "note" entry (file (concat org-directory "/note.org"))
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t))))

; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9) (org-agenda-files :maxlevel . 9))))

; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)

; Targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)

; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

; Use IDO for both buffer and file completion and ido-everywhere to t
;;(setq org-completion-use-ido t)
;;(setq ido-everywhere t)
;;(setq ido-max-directory-size 100000)
;;(ido-mode (quote both))
; Use the current window when visiting files and buffers with ido
;;(setq ido-default-file-method 'selected-window)
;;(setq ido-default-buffer-method 'selected-window)

;;;; Refile settings
; Exclude DONE state tasks from refile targets
(defun bh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'bh/verify-refile-target)

(setq org-publish-project-alist
      '(
        ("org-htmls1"                             ;Used to export .org file
         :base-directory "G:/Ogers/"                    ;directory holds .org files 
         :publishing-directory "G:/Ogers/publish-html/" ;export destination
         :base-extension "org"                   ;process .org file only    
         :recursive t
         :publishing-function org-html-publish-to-html
         :html-preamble '(with-temp-buffer (insert-file-contents "./html-preamble.html") (buffer-string))
         :table-of-contents nil
         :html-postamble ""          ; your personal postamble
         )
        ("org-static1"                ;Used to publish static files
         :publishing-directory "G:/Ogers/publish-html/"
         :base-directory "G:/Ogers/publish-html/static"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :recursive t
         :publishing-function org-publish-attachment
         )
        ("org-htmls2"                             ;Used to export .org file
         :base-directory "G:/Ogers/"                    ;directory holds .org files 
         :publishing-directory "G:/Ogers/publish-html/" ;export destination
         :base-extension "org"                   ;process .org file only    
         :recursive t
         :publishing-function org-html-publish-to-html
         :html-preamble '(with-temp-buffer (insert-file-contents "./html-preamble.html") (buffer-string))
         :table-of-contents nil
         :html-postamble ""          ; your personal postamble
         )
        ("org-static2"                ;Used to publish static files
         :publishing-directory "G:/Ogers/publish-html/"
         :base-directory "G:/Ogers/publish-html/static"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :recursive t
         :publishing-function org-publish-attachment
         )

        ("path1" :components ("org-htmls1" "org-static1")) ;combine "org-htmls" and "org-static" into one function call
        ("path2" :components ("org-htmls2" "org-static2")) ;combine "org-htmls" and "org-static" into one function call
        ))

(defun org-html-template (contents info)
  "Return complete document string after HTML conversion.
CONTENTS is the transcoded contents string.  INFO is a plist
holding export options."
  (concat
   (when (and (not (org-html-html5-p info)) (org-html-xhtml-p info))
     (let ((decl (or (and (stringp org-html-xml-declaration)
			      org-html-xml-declaration)
			 (cdr (assoc (plist-get info :html-extension)
				     org-html-xml-declaration))
			 (cdr (assoc "html" org-html-xml-declaration))

			 "")))
       (when (not (or (eq nil decl) (string= "" decl)))
	 (format "%s\n"
		 (format decl
		  (or (and org-html-coding-system
			   (fboundp 'coding-system-get)
			   (coding-system-get org-html-coding-system 'mime-charset))
		      "iso-8859-1"))))))
   (org-html-doctype info)
   "\n"
   (concat "<html"
	   (when (org-html-xhtml-p info)
	     (format
	      " xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"%s\" xml:lang=\"%s\""
	      (plist-get info :language) (plist-get info :language)))
	   ">\n")
   "<head>\n"
   (org-html--build-meta-info info)
   (org-html--build-head info)
   (org-html--build-mathjax-config info)
   "</head>\n"
   "<body>\n"
   "
<nav class=\"navbar navbar-default\">
<div class=\"container-fluid\">
<!-- Brand and toggle get grouped for better mobile display -->
<div class=\"navbar-header\">
    <button type=\"button\" class=\"navbar-toggle collapsed\" data-toggle=\"collapse\" data-target=\"#bs-example-navbar-collapse-1\" aria-expanded=\"false\">
    <span class=\"sr-only\">Toggle navigation</span>
    <span class=\"icon-bar\"></span>
    <span class=\"icon-bar\"></span>
    <span class=\"icon-bar\"></span>
    </button>
    <a class=\"navbar-brand\" href=\"/index.html\">Home</a>
</div>
<!-- Collect the nav links, forms, and other content for toggling -->
<!--
<div class=\"collapse navbar-collapse\" id=\"bs-example-navbar-collapse-1\">
    <ul class=\"nav navbar-nav\">
    <li class=\"active\"><a href=\"#\">Link <span class=\"sr-only\">(current)</span></a></li>
    <li><a href=\"#\">Link</a></li>
    <li class=\"dropdown\">
        <a href=\"#\" class=\"dropdown-toggle\" data-toggle=\"dropdown\" role=\"button\" aria-haspopup=\"true\" aria-expanded=\"false\">Dropdown <span class=\"caret\"></span></a>
        <ul class=\"dropdown-menu\">
        <li><a href=\"#\">Action</a></li>
        <li><a href=\"#\">Another action</a></li>
        <li><a href=\"#\">Something else here</a></li>
        <li role=\"separator\" class=\"divider\"></li>
        <li><a href=\"#\">Separated link</a></li>
        <li role=\"separator\" class=\"divider\"></li>
        <li><a href=\"#\">One more separated link</a></li>
        </ul>
    </li>
    </ul>
    <ul class=\"nav navbar-nav navbar-right\">
    <li><a href=\"#\">Link</a></li>
    <li class=\"dropdown\">
        <a href=\"#\" class=\"dropdown-toggle\" data-toggle=\"dropdown\" role=\"button\" aria-haspopup=\"true\" aria-expanded=\"false\">Dropdown <span class=\"caret\"></span></a>
        <ul class=\"dropdown-menu\">
        <li><a href=\"#\">Action</a></li>
        <li><a href=\"#\">Another action</a></li>
        <li><a href=\"#\">Something else here</a></li>
        <li role=\"separator\" class=\"divider\"></li>
        <li><a href=\"#\">Separated link</a></li>
        </ul>
    </li>
    </ul>
-->
    <form class=\"navbar-form navbar-right\" role=\"search\">
    <div class=\"form-group\">
        <input type=\"text\" class=\"form-control\" placeholder=\"Search\">
    </div>
    <button type=\"submit\" class=\"btn btn-default\">Submit</button>
    </form>
</div><!-- /.navbar-collapse -->
</div><!-- /.container-fluid -->
</nav>"

   ;; Document container <bootstrap>
   "<div class=\"container\">"
   (let ((link-up (org-trim (plist-get info :html-link-up)))
	 (link-home (org-trim (plist-get info :html-link-home))))
     (unless (and (string= link-up "") (string= link-home ""))
       (format org-html-home/up-format
	       (or link-up link-home)
	       (or link-home link-up))))
   ;; Preamble.
   (org-html--build-pre/postamble 'preamble info)
   ;; Big head
   "<div class=\"jumbotron\">"
   "<h1>Coding, world!</h1>"
   "<p>...</p>"
   "<p><a class=\"btn btn-primary btn-lg\" href=\"mailto:thatways.c@aliyu.com\" role=\"button\">Contect me</a></p>"
   "</div>"
   ;; Document contents.
   (format "<%s id=\"%s\">\n"
	   (nth 1 (assq 'content org-html-divs))
	   (nth 2 (assq 'content org-html-divs)))
   ;; Document title.
   (let ((title (plist-get info :title)))
     (format "<h1 class=\"title\">%s</h1>\n" (org-export-data (or title "") info)))
   contents
   (format "</%s>\n"
	   (nth 1 (assq 'content org-html-divs)))
   ;; Postamble.
   (org-html--build-pre/postamble 'postamble info)
   ;; Closing document.
   "</div></body>\n</html>"))
