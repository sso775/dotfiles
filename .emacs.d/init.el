;;------------------------------------------------------------------------------
;;
;; init.el for Emacs 23 on Mac OS and Ubuntu Server
;;
;;------------------------------------------------------------------------------


;;------------------------------------------------------------------------------
;; 基本設定 general config
;;------------------------------------------------------------------------------

;; 言語設定
(set-language-environment 'japanese)

;; ロードパス
(setq load-path (cons "~/.emacs.d/" load-path))
(add-to-list 'load-path "~/.emacs.d/site-lisp")

;; init-loader
;; 分割された設定ファイルを読み込み
;; install - http://coderepos.org/share/browser/lang/elisp/init-loader/init-loader.el
(require 'init-loader)
(init-loader-load "~/.emacs.d/conf")

;; どのファイルでエラーが出たかわかるように
;; http://d.hatena.ne.jp/kitokitoki/20101205/p1
(defun init-loader-re-load (re dir &optional sort)
  (let ((load-path (cons dir load-path)))
    (dolist (el (init-loader--re-load-files re dir sort))
      (condition-case e
          (let ((time (car (benchmark-run (load (file-name-sans-extension el))))))
            (init-loader-log (format "loaded %s. %s" (locate-library el) time)))
        (error
         ;; (init-loader-error-log (error-message-string e)) ；削除
         (init-loader-error-log (format "%s. %s" (locate-library el) (error-message-string e))) ;追加
         )))))

;; auto-install.el
(add-to-list 'load-path "~/.emacs.d/auto-install")
(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/auto-install/")
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)

;; スタートアップ画面非表示
(setq inhibit-startup-message t)

;; バックアップファイル*.~作成無効化
(setq make-backup-files nil)

;; バックアップファイル.#*無効化
(setq auto-save-default nil)

;; バックアップファイル作成無効
(setq backup-inhibited t)

;;ウィンドウタイトルをファイルパスに
(setq frame-title-format (format "%%f - Emacs @%s" (system-name)))


;;------------------------------------------------------------------------------
;; 文字コード text encoding
;;------------------------------------------------------------------------------

;; 文字コード指定
(prefer-coding-system 'utf-8)
(setq default-coding-systems 'utf-8)
(setq file-name-coding-system 'utf-8)


;;------------------------------------------------------------------------------
;; アピアランス apperance
;;------------------------------------------------------------------------------

(when window-system
  (progn

    ;; あたしって、フォントばか。
    (set-face-attribute 'default nil
                        :family "Ricty"
                        :height 180)
    (set-fontset-font
     nil 'japanese-jisx0208
     (font-spec :family "Ricty"))

    ;; ウィンドウ設定
    (custom-set-faces
     '(default ((t
                 (:background "black" :foreground "white")
                 ))))
    '(cursor ((((clas color)
                (background dark)
                (:background "gray"))
               (((clas color)
                 (background light))
                (:background "white"))
               (t ())
               )))
    (setq initial-frame-alist '((width . 50) (height . 60)))
    (add-to-list 'default-frame-alist '(alpha . (0.75 0.45)))

))

;; 行番号表示
(global-linum-mode t)

;; ソースコードカラー表示
(global-font-lock-mode t)

;; コメント色
(set-face-foreground 'font-lock-comment-face "blue")

;; 対応する括弧をハイライト
(show-paren-mode 1)

;; 編集行ハイライト
(require 'hl-line)
(custom-set-faces
 '(hl-line
   ((((class color)
      (background dark))
     (:background "#222244"))
    (((class color)
      (background light))
     (:background "color-235")))))
(global-hl-line-mode)

;; 選択行ハイライト
(transient-mark-mode t)

;; モードライン
(set-face-background 'modeline "purple")
(set-face-foreground 'modeline "white")

;;時間表示
(setq display-time-day-and-date t
      display-time-24hr-format t)
(setq display-time-format "%m/%d(%a) %H:%M")
(display-time)

;;------------------------------------------------------------------------------
;; 補完機能 completing
;;------------------------------------------------------------------------------

;; 補完機能有効
(setq partial-completion-mode 1)

;; file名補完で大文字小文字を区別しない
(setq completion-ignore-case t)


;;------------------------------------------------------------------------------
;; インデント indent
;;------------------------------------------------------------------------------

;; インデント設定
(setq c-tab-always-indent t)
(setq-default indent-tabs-mode nil)
(setq default-tab-width 4)
(setq indent-line-function 'indent-relative-maybe)

;; 選択範囲をインデント
(global-set-key "\C-x\C-i" 'indent-region)

;; returnで改行とインデント
(global-set-key "\C-m" 'newline-and-indent)


;;------------------------------------------------------------------------------
;; キーバインド  key bind
;;------------------------------------------------------------------------------

;; shift + 矢印で範囲選択
(setq pc-select-selection-keys-only t)
(pc-selection-mode 1)

;; ウィンドウ分割時の操作ウィンドウ移動
;; 移動で折り返し可能に
(setq windmove-wrap-around t)
;; Ctrl + Meta + hjkl で移動できるように
(define-key global-map (kbd "C-M-k") 'windmove-up)
(define-key global-map (kbd "C-M-j") 'windmove-down)
(define-key global-map (kbd "C-M-l") 'windmove-right)
(define-key global-map (kbd "C-M-h") 'windmove-left)

;; 分割ウィンドウのサイズ調整
;; http://d.hatena.ne.jp/mooz/20100119/p1
;; 関数 window-resizer を定義
(defun window-resizer ()
  "Control window size and position."
  (interactive)
  (let ((window-obj (selected-window))
        (current-width (window-width))
        (current-height (window-height))
        (dx (if (= (nth 0 (window-edges)) 0) 1
              -1))
        (dy (if (= (nth 1 (window-edges)) 0) 1
              -1))
        c)
    (catch 'end-flag
      (while t
        (message "size[%dx%d]"
                 (window-width) (window-height))
        (setq c (read-char))
        (cond ((= c ?l)
               (enlarge-window-horizontally dx))
              ((= c ?h)
               (shrink-window-horizontally dx))
              ((= c ?j)
               (enlarge-window dy))
              ((= c ?k)
               (shrink-window dy))
              ;; otherwise
              (t
               (message "Quit")
               (throw 'end-flag t)))))))

;; Ctrl-c R でウィンドウリサイズモード・hjklでリサイズ
(global-set-key "\C-cR" 'window-resizer)

;; リージョン内大文字変換を有効
(put 'upcase-region 'dkisabled nil)

;; C-c c で選択範囲コメントアウト
(global-set-key "\C-cc" 'comment-region)

;; C-c u で選択範囲コメント解除
(global-set-key "\C-cu" 'uncomment-region)

;; C-c C-b でカーソル位置のURLを開く
(global-set-key "\C-c\C-b" 'browse-url-at-point)

;; ポインタ位置記録
;; install http://www.emacswiki.org/cgi-bin/wiki/download/point-undo.el
(require 'point-undo)

;; redo可能
;; install http://www.emacswiki.org/emacs/download/redo+.el
(require 'redo+)

;; undo・redoを便利に
;; install http://www.dr-qubit.org/undo-tree/undo-tree.el
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))

;; OSごとの設定
(cond
  ((string-match "apple-darwin" system-configuration)
    ;; Macの設定
    ;; Mac固有の設定
    ;(setq mac-allow-anti-aliasing nil)
    ;; Macのキーバインドを使う
    ;; (mac-key-mode 1)
    ;; Mac用メタキー設定
    (setq mac-option-modifier 'meta)
    ;; システムクリップボードと連携
    (defun copy-from-osx ()
      (shell-command-to-string "pbpaste"))
    (defun paste-to-osx (text &optional push)
      (let ((process-connection-type nil))
        (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
          (process-send-string proc text)
          (process-send-eof proc))))
    (setq interprogram-cut-function 'paste-to-osx)
    (setq interprogram-paste-function 'copy-from-osx)
  )
  ((string-match "linux" system-configuration)
    ;; Linuxの設定
    )
  ((string-match "mingw" system-configuration)
    ;; Windowsの設定
  )
)

;;------------------------------------------------------------------------------
;; 編集・操作  edit utility
;;------------------------------------------------------------------------------

;; 対応する括弧の自動挿入、=の前後に空白挿入等
;; install https://github.com/imakado/emacs-smartchr
(require 'smartchr)
(defun smartchr-custom-keybindings ()
  (local-set-key (kbd "=") (smartchr '(" = " " == "  "=")))
  ;; !! がカーソルの位置
  (local-set-key (kbd "(") (smartchr '("(`!!')" "(")))
  (local-set-key (kbd "[") (smartchr '("[`!!']" "[ [`!!'] ]" "[")))
  (local-set-key (kbd "{") (smartchr '("{\n`!!'\n}" "{`!!'}" "{")))
  (local-set-key (kbd "`") (smartchr '("\``!!''" "\`")))
  (local-set-key (kbd "\"") (smartchr '("\"`!!'\"" "\"")))
  (local-set-key (kbd ">") (smartchr '(">" " => " " => '`!!''" " => \"`!!'\"")))
  )

(add-hook 'c-mode-common-hook 'smartchr-custom-keybindings)


;; バッファ切り替えをインクリメンタルに
(iswitchb-mode 1)
(add-hook 'iswitchb-define-mode-map-hook
      (lambda ()
        (define-key iswitchb-mode-map "\C-n" 'iswitchb-next-match)
        (define-key iswitchb-mode-map "\C-p" 'iswitchb-prev-match)
        (define-key iswitchb-mode-map "\C-f" 'iswitchb-next-match)
        (define-key iswitchb-mode-map "\C-b" 'iswitchb-prev-match)))
;; iswitchbで補完対象に含めないバッファ
(setq iswitchb-buffer-ignore
      '(
        "*twittering-wget-buffer*"
        "*twittering-http-buffer*"
        "*WoMan-Log*"
        "*SKK annotation*"
        "*Completions*"
        ))



;; flymake (Emacs22から標準搭載)
;; http://moimoitei.blogspot.com/2010/05/flymake-in-emacs.html

(require 'flymake)

;; GUIの警告は表示しない
(setq flymake-gui-warnings-enabled nil)

;; 全てのファイルで flymakeを有効化
(add-hook 'find-file-hook 'flymake-find-file-hook)

;; M-p/M-n で警告/エラー行の移動
(global-set-key "\M-p" 'flymake-goto-prev-error)
(global-set-key "\M-n" 'flymake-goto-next-error)

;; 警告エラー行の表示
(global-set-key "\C-cd" 'flymake-display-err-menu-for-current-line)

;; Minibuf に出力
(defun my-flymake-display-err-minibuf-for-current-line ()
  "Displays the error/warning for the current line in the minibuffer"
  (interactive)
  (let* ((line-no            (flymake-current-line-no))
         (line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (count              (length line-err-info-list)))
    (while (> count 0)
      (when line-err-info-list
        (let* ((text       (flymake-ler-text (nth (1- count) line-err-info-list)))
               (line       (flymake-ler-line (nth (1- count) line-err-info-list))))
          (message "[%s] %s" line text)))
      (setq count (1- count)))))

;; popup.el を使って tip として表示
(defun my-flymake-display-err-popup.el-for-current-line ()
  "Display a menu with errors/warnings for current line if it has errors and/or warnings."
  (interactive)
  (let* ((line-no            (flymake-current-line-no))
         (line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (menu-data          (flymake-make-err-menu-data line-no line-err-info-list)))
    (if menu-data
      (popup-tip (mapconcat '(lambda (e) (nth 0 e))
                            (nth 1 menu-data)
                            "\n")))
    ))


;; zen-coding
;; install from https://github.com/rooney/zencoding
;; cf http://www.goodpic.com/mt/archives2/2010/02/emacs_zencoding.html

(require 'zencoding-mode)
(require 'zencoding-mode)
(add-hook 'sgml-mode-hook 'zencoding-mode)
(add-hook 'html-mode-hook 'zencoding-mode)
(add-hook 'text-mode-hook 'zencoding-mode)
(define-key zencoding-mode-keymap "\C-z" 'zencoding-expand-line)

;; http://d.hatena.ne.jp/m2ym/20110120/1295524932
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)

;; http://d.hatena.ne.jp/syohex/20111201/1322665378
(require 'quickrun)
;; 結果の出力バッファと元のバッファを行き来したい場合は
;; ':stick t'の設定をするとよいでしょう
(push '("*quickrun*") popwin:special-display-config)
;; よく使うならキーを割り当てるとよいでしょう
;; (global-set-key (kbd "<f5>") 'quickrun)

;;------------------------------------------------------------------------------
;; その他ユーティリティ  Utility
;;------------------------------------------------------------------------------

;; shell-pop.el
;; install from emacswiki http://www.emacswiki.org/emacs-en/ShellPop
(require 'shell-pop)
(shell-pop-set-internal-mode "ansi-term")
(shell-pop-set-internal-mode-shell "/bin/zsh")
(shell-pop-set-window-height 30)
(defvar ansi-term-after-hook nil)
(add-hook 'ansi-term-after-hook
          (function
           (lambda ()
             (define-key term-raw-map "\M-t" 'shell-pop))))
(defadvice ansi-term (after ansi-term-after-advice (arg))
  "run hook as after advice"
  (run-hooks 'ansi-term-after-hook))
(ad-activate 'ansi-term)

(global-set-key "\M-t" 'shell-pop)


;;------------------------------------------------------------------------------
;; ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ...
;; ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ...
;; ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ...
;; ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ...
;; ﾊｧﾊｧ... ﾊｧﾊｧ... 　　　　　　　　　　　　　　　　　　　　　　　　ﾊｧﾊｧ... ﾊｧﾊｧ...
;; ﾊｧﾊｧ... 　　　　　　　##　　　　　　　　　　　　　　##　　　　　　　　　ﾊｧﾊｧ...
;; 　　　　　　　　　　##　　　　　　　　　　　　　　　　##　　　　　　　　　　　
;; 　　　　　##　　　##　　　　　　　　　　　　　　　　　　##　　　　　##　　　　
;; 　　　　##　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　##　　　
;; 　　　　##　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　##　　　
;; 　　　##　　　　　　　　　　　　　　########　　　　　　　　####　　　　##　　
;; 　　　##　　　　　　　　　　　　　　##　　##　　　　　　　　####　　　　##　　
;; 　　　##　　　　　　　　　　　　　##　　　##　　　　　　　　　　　　　　##　　
;; 　　　##　　　　　　　　　　　　　##　　　##　　　　　　　　　　　　　　##　　
;; 　　　##　　　　　　　　　　　　##　　　　##　　　　　　　　　　　　　　##　　
;; 　　　##　　　　　　　　　　　　##　　　　##　　　　　　　　####　　　　##　　
;; 　　　　##　　　　　　　　　　　##　　　　##　　　　　　　　　##　　　##　　　
;; 　　　　##　　　　　　　　　　　##############　　　　　　　　##　　　##　　　
;; ﾊｧﾊｧ... 　##　　　　　　　　　　##　　　　　##　　　　　　　##　　　##　ﾊｧﾊｧ...
;; ﾊｧﾊｧ... 　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　ﾊｧﾊｧ...
;; ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ...
;; ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ... ﾊｧﾊｧ...

;; (require 'hahhah)
;; (hahhah-mode t)