(require 'cedet)
(require 'semantic/ia)
(require 'semantic/bovine/gcc)

(global-ede-mode t)
;;(semantic-mode t)
;;(global-semantic-idle-summary-mode)

(setq qt5-base-dir "/usr/include/qt5")
(semantic-add-system-include qt5-base-dir 'c++-mode)
(add-to-list 'auto-mode-alist (cons qt5-base-dir 'c++-mode))
