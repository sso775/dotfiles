;; /twittering-mode.el
;; ---------------------------------------------------------
;; ref
;; http://mitukiii.jp/2010/11/01/twittering-mode/
;; http://d.hatena.ne.jp/taki168/20110602/1307047465

; (setq load-path (cons "~/.emacs.d/" load-path))
(add-to-list 'load-path "~/.emacs.d/site-lisp")
(add-to-list 'load-path "~/.emacs.d/auto-install")

;; twittering-mode.el 呼び出し
(require 'twittering-mode)
(setq twittering-username "dita_69")
;; (setq twittering-password "twidi0tMAN")

;; 表示形式
(setq twittering-status-format "%i @%s / %S %p: \n %T\n [%@]%r %R %f%L\n")
(setq twittering-retweet-format " RT @%s: %t")
;; GUIの時はアイコン表示
(if window-system (progn
                    (setq twittering-icon-mode t)
                    ))
(setq twittering-convert-fix-size 48)

;; 設定
(setq twittering-timer-interval 60)
(setq twittering-scroll-mode nil)
(setq twittering-use-ssl nil)

;; OAuth認証
;; dev.twitter.comで自分のアプリケーションを登録している場合は設定できる
;; (setq twittering-auth-method 'oauth)
;; (setq twittering-account-authorization 'authorized)
;; (setq twittering-oauth-consumer-key "*** consumer key ***")
;; (setq twittering-oauth-consumer-secret "*** consumer secret ***")
;; (setq twittering-oauth-access-token-alist
;;       '(("screen_name" . "dita_69")
;;         ("user_id" . "8891102")
;;         ("oauth_token" . "*** oauth token ***")
;;         ("oauth_token_secret" . "*** oauth token secret ***")))

;; twittering-modeでログインした状態で [F1]-v
;; Describe variable:twittering-oauth-access-token-alist で oauth token, oauth token secret 取得
(setq twittering-account-authorization 'authorized)
(setq twittering-oauth-access-token-alist
      '(("oauth_token" . "8891102-M2kLICqxfX0PJzdzcvf04i67RqoeXsYz3tAVVUB37Y")
        ("oauth_token_secret" . "jk5l6wp3Nh6dFXFEqsoeZFn68OgSztBY9psqyvV8")
        ("user_id" . "dita_69")
        ("screen_name" . "dita_69")))

;; ツイート時にミニバッファでなく通常のバッファでポップアップさせる
(setq twittering-update-status-function 'twittering-update-status-from-pop-up-buffer)

;; 起動時に読み込むTL
;; 順に読み込み最後のTLが表示される
(setq twittering-initial-timeline-spec-string
      '("dita_69/interest"
        "dita_69/friends"
        ":replies"
        ":home"))

;; URLをbit.lyで短縮
(add-to-list 'twittering-tinyurl-services-map
              '(bitly . "http://api.bit.ly/shorten?version=2.0.1&login=*** User ID ***&apiKey=*** API key ***&format=text&longUrl="))
(setq twittering-tinyurl-service 'bitly)

;; キーバインド
(add-hook 'twittering-mode-hook
          '(lambda ()
            (define-key twittering-mode-map (kbd "F") 'twittering-favorite)
            (define-key twittering-mode-map (kbd "R") 'twittering-reply-to-user)
            (define-key twittering-mode-map (kbd "Q") 'twittering-organic-retweet)
            (define-key twittering-mode-map (kbd "T") 'twittering-native-retweet)
            (define-key twittering-mode-map (kbd "M") 'twittering-direct-message)
            (define-key twittering-mode-map (kbd "N") 'twittering-update-status-interactive)
            (define-key twittering-mode-map (kbd "C-c C-f") 'twittering-home-timeline)))