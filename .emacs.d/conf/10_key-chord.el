;; / key-chord.el config
;;------------------------------------------------------------------------------
;; 「小指痛い」
;; http://d.hatena.ne.jp/oh_cannot_angel/20110510/1304999061
;; install http://www.emacswiki.org/emacs/key-chord.el

(require 'key-chord)
(setq key-chord-two-keys-delay 0.04)
(key-chord-mode 1)

;; jk同時押しでview-mode
(key-chord-define-global "jk" 'view-mode)

;; tw同時押しでtwittering-mode
(key-chord-define-global "tw" 'twittering-mode)

;; qr同時押しでコンパイル
;; smart-compile.el使う
(key-chord-define-global "qr" 'smart-compile)