;; /auto-complete.el
;; ---------------------------------------------------------
;;ref http://d.hatena.ne.jp/Watson/20100315/1268632079

;; auto-complete有効
(require 'auto-complete)
(global-auto-complete-mode t)

;; 辞書設定
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/site-lisp/ac-dict")