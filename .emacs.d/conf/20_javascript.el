;; / JavaScript
;;------------------------------------------------------------------------------

;; install-elisp http://js2-mode.googlecode.com/files/js2-20090723b.el
;; cf. http://www.croisforce.com/archives/1066
;; (defun indent-and-back-to-indentation()
;;   (interactive)
;;   (indent-for-tab-command)
;;   (let (( point-of-indentation (save-excursion (back-to-indentation) (point) ) ) )
;;     (skip-chars-forward "/s " point-of-indentation)))
;; (add-hook 'js2-mode-hook
;; 	  (lambda ()
;; 	    (setq indent-tabs-mode nil)
;; 	    (setq tab-width 4)
;; 	    (setq c-basic-offset 4)
;; 	    )
;; 	  )
;; (setq js2-mirror-mode nil
;;       js2-auto-indent-p t
;;       js2-mode-show-parse-errors nil
;;       js2-mode-show-strict-warnings nil
;;       js2-strict-trailing-comma-warning nil
;;       js2-strict-missing-semi-warning nil
;;       js2-strict-inconsistent-return-warning nil
;;       js2-missing-semi-one-line-override t
;;       js2-highlight-external-variables nil
;;       js2-highlight-level 3 
;; )
;; (autoload 'js2-mode "js2-mode" nil t)
;; (add-to-list 'auto-mode-alist '("\\.js" . js2-mode))
;; (require 'js2-mode)
;; (define-key js2-mode-map [tab] 'indent-and-back-to-indentation)

;; http://8-p.info/emacs-javascript.html
(setq-default c-basic-offset 4)

(when (load "js2" t)
  (setq js2-cleanup-whitespace nil
        js2-mirror-mode nil
        js2-bounce-indent-flag nil)

  (defun indent-and-back-to-indentation ()
    (interactive)
    (indent-for-tab-command)
    (let ((point-of-indentation
           (save-excursion
             (back-to-indentation)
             (point))))
      (skip-chars-forward "\s " point-of-indentation)))
  (define-key js2-mode-map "\C-i" 'indent-and-back-to-indentation)

  (define-key js2-mode-map "\C-m" nil)

  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode)))