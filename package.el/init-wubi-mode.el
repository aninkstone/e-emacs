(add-to-list 'load-path "~/.emacs.d/el-get/wubi")

(register-input-method
 "chinese-wubi" "Chinese-GB" 'quail-use-package
 "WuBi" "WuBi"
 "wubi")
