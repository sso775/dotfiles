;; / scratch-log.el
;;------------------------------------------------------------------------------
;; http://d.hatena.ne.jp/kitokitoki/20100612/p1
;; install https://github.com/wakaran/scratch-log

(require 'scratch-log)

;; スクラッチバッファログファイル
;; 指定しなければ"~/.emacs.d/.scratch-log"
(setq sl-scratch-log-file "~/.emacs.d/scratch-log")

;; 直前のスクラッチバッファの内容を保存するファイル
;; 初期値は"~/.emacs.d/.scratch-log-prev"
(setq sl-prev-scratch-string-file "~/.emacs.d/scratch-log-prev")

;; nillで起動時に最後のスクラッチバッファ内容を非表示(初期値t)
;; (setq sl-restore-scratch-p nil)

;; nillでスクラッチバッファ削除できるままに(初期値t)
;; (setq sl-prohibit-kill-scratch-buffer-p nil)

;; scratchバッファをすぐ呼び出せるように
;; http://my.opera.com/ymirlin/blog/2011/01/26/scratch-buffer-call
(defvar swap-scratch-last-buffers nil)
(defun swap-scratch-and-other-buffer ()
  (interactive)
  (if (equal (buffer-name) "*scratch*")
      (when swap-scratch-last-buffers
        (switch-to-buffer (pop swap-scratch-last-buffers)))
    (progn
      (add-to-list 'swap-scratch-last-buffers (buffer-name))
      (switch-to-buffer "*scratch*"))))