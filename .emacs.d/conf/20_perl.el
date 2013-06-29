;; / perl
;;------------------------------------------------------------------------------

;; perl mode
(autoload 'perl-mode "cperl-mode" "alternate mode for editing Perl programs" t)
(setq cperl-indent-level 4)
(setq cperl-continued-statement-offset 4)
(setq cperl-comment-column 40)

;; perl-completion.el and auto-complete.el
; http://d.hatena.ne.jp/a666666/20100524/1274634774
(add-hook 'cperl-mode-hook
           (lambda()
            (require 'perl-completion)
            (perl-completion-mode t)))

(add-hook  'cperl-mode-hook
           (lambda ()
            (when (require 'auto-complete nil t) ; no error whatever auto-complete.el is not installed.
             (auto-complete-mode t)
             (make-variable-buffer-local 'ac-sources)
             (setq ac-sources
              '(ac-source-perl-completion)))))

;; perl-completion
;; http://d.hatena.ne.jp/hakutoitoi/20090208/1234069614
(add-hook 'cperl-mode-hook (lambda ()
                             (setq plcmp-use-keymap nil) ; requireより前の段階で設定する
                             (require 'perl-completion)
                             (add-to-list 'ac-sources 'ac-source-perl-completion)
                             (perl-completion-mode t)
                             ;; plcmp-mode-mapにコマンドを割り当てていく
                             (define-key plcmp-mode-map (kbd "C-c m") 'plcmp-cmd-menu)
                             (define-key plcmp-mode-map (kbd "C-c s") 'plcmp-cmd-smart-complete)
                             (define-key plcmp-mode-map (kbd "C-c d") 'plcmp-cmd-show-doc)
                             (define-key plcmp-mode-map (kbd "C-c p") 'plcmp-cmd-show-doc-at-point)
                             (define-key plcmp-mode-map (kbd "C-c c") 'plcmp-cmd-clear-all-cashes)))

;; flymake.el config for perl
;; http://unknownplace.org/memo/2007/12/21#e001
(defvar flymake-perl-err-line-patterns
  '(("\\(.*\\) at \\([^ \n]+\\) line \\([0-9]+\\)[,.\n]" 2 3 nil 1)))

(defconst flymake-allowed-perl-file-name-masks
  '(("\\.pl$" flymake-perl-init)
    ("\\.pm$" flymake-perl-init)
    ("\\.t$" flymake-perl-init)))

(defun flymake-perl-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "perl" (list "-wc" local-file))))

(defun flymake-perl-load ()
  (interactive)
  (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
    (setq flymake-check-was-interrupted t))
  (ad-activate 'flymake-post-syntax-check)
  (setq flymake-allowed-file-name-masks (append flymake-allowed-file-name-masks flymake-allowed-perl-file-name-masks))
  (setq flymake-err-line-patterns flymake-perl-err-line-patterns)
  (set-perl5lib)
  (flymake-mode t))

(add-hook 'cperl-mode-hook 'flymake-perl-load)