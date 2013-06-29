;; / Objective-C
;;------------------------------------------------------------------------------

(add-to-list 'ac-modes 'objc-mode)

;; objcインデント適用
(add-hook 'c-mode-common-hook
         '(lambda()
             (c-set-style "cc-mode")))

;; .m と .h で対応するファイルを C-c o で開く
(setq ff-other-file-alist
     '(("\\.mm?$" (".h"))
       ("\\.cc$"  (".hh" ".h"))
       ("\\.hh$"  (".cc" ".C"))

       ("\\.c$"   (".h"))
       ("\\.h$"   (".c" ".cc" ".C" ".CC" ".cxx" ".cpp" ".m" ".mm"))

       ("\\.C$"   (".H"  ".hh" ".h"))
       ("\\.H$"   (".C"  ".CC"))

       ("\\.CC$"  (".HH" ".H"  ".hh" ".h"))
       ("\\.HH$"  (".CC"))

       ("\\.cxx$" (".hh" ".h"))
       ("\\.cpp$" (".hpp" ".hh" ".h"))

       ("\\.hpp$" (".cpp" ".c"))))
(add-hook 'objc-mode-hook
         (lambda ()
           (define-key c-mode-base-map (kbd "C-c o") 'ff-find-other-file)
         ))

;; flymake
(require 'flymake)

(defvar flymake-compiler "gcc")
(defvar flymake-compile-options nil)
(defvar flymake-compile-default-options (list "-Wall" "-Wextra" "-fsyntax-only"))

(defun flymake-objc-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name)))
	 (options flymake-compile-default-options))
    (list flymake-compiler (append options (list local-file)))))

(push '("\\.m$" flymake-objc-init) flymake-allowed-file-name-masks)
(push '("\\.h$" flymake-objc-init) flymake-allowed-file-name-masks)

(add-hook 'objc-mode-hook
          '(lambda ()
	     (flymake-mode t)))

(provide 'flymake-objc)

;; smartchr.el
(defun smartchr-custom-keybindings-objc ()
  (local-set-key (kbd "@") (smartchr '("@\"`!!'\"" "@")))
  )

(add-hook 'objc-mode-hook 'smartchr-custom-keybindings-objc)