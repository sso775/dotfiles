;; / TeX
;;------------------------------------------------------------------------------

(add-to-list 'load-path "~/.emacs.d/site-lisp/yatex")
(setq auto-mode-alist
      (cons (cons "€€.tex$" 'yatex-mode) auto-mode-alist))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(setq tex-command "platex"
      dvi2-command "dviout -1 -Set=!m"
      YaTeX-kanji-code 3 ;
      YaTeX-latex-message-code 'sjis
      section-name "documentclass"
      makeindex-command "mendex"
      YaTeX-use-AMS-LaTeX t
      YaTeX-use-LaTeX2e t
      YaTeX-use-font-lock t
      )
(add-hook 'yatex-mode-hook'
          (lambda ()(setq auto-fill-function nil)))

;; use texshop.app for preview
(setq tex-command "~/Library/TeXShop/bin/platex2pdf-euc"
      dvi2-command "open -a TeXShop")
