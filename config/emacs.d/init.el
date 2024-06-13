(tool-bar-mode -1)
(tab-bar-mode -1)
(tab-line-mode -1)
(scroll-bar-mode -1)

(defmacro xx (&rest body) nil)

(defun emacsd (&optional path)
  "Return a path to a file in emacs.d"
  (expand-file-name (or path "") user-emacs-directory))

(defun emacsd-var (&optional path)
  (emacsd (concat "var/" path)))

(defun emacsd-etc (&optional path)
  (emacsd (concat "etc/" path)))

(defun homed (&optional path)
  "Return a path to a file/directory in the code directory"
  (expand-file-name (or path "") "~/"))

(defun jump-to-config/init ()
  (interactive)
  (find-file (emacsd "init.el")))

(defun jump-to-config/notes ()
  (interactive)
  (find-file org-default-notes-file))

(defun what-face (pos)
  (interactive "d")
  (let ((face (or (get-char-property pos 'read-face-name)
                  (get-char-property pos 'face))))
    (if face (message "Face: %s" face) (message "No face at %d" pos))))

;; get setup
(add-to-list 'load-path (emacsd "init.d"))
(add-to-list 'load-path (emacsd "site-lisp"))

;;;; initialize package.el and use-package

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("elpa-devel" . "https://elpa.gnu.org/devel/"))

(setq use-package-always-ensure t)

;; this adds the :vc handling for use-package
(unless (package-installed-p 'vc-use-package)
  (package-vc-install "https://github.com/slotThe/vc-use-package"))

(require 'vc-use-package)

;;;; detach and be a server

(server-mode)

;;;; a bunch of defaults

;; reflect reality please
(global-auto-revert-mode t)

;; this is rediculous
(defalias 'yes-or-no-p 'y-or-n-p)

;; emacs.d gets really messy, this forces cleanup
(use-package no-littering
  :init
  (setq no-littering-etc-directory (emacsd-etc)
        no-littering-var-directory (emacsd-var)))

(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(setq backup-directory-alist
      `(("." . ,(no-littering-expand-var-file-name "backups/"))))

;; explicitly loaded at the end of this file
(setq custom-file (emacsd "custom.el"))

(require 'recentf)
(add-to-list 'recentf-exclude (emacsd-var))
(add-to-list 'recentf-exclude (emacsd-etc))

;; make sure tramp actually uses a path
(use-package tramp
  :config
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

;; compilation buffers should get ansi color chars
(use-package ansi-color
  :hook (compilation-filter-hook . ansi-color-compilation-filter))

;;;; editor stuff

(repeat-mode)

;; load editor configuration from project path
(use-package editorconfig
  :config
  (editorconfig-mode 1))

;; clean up whitespace in changed lines
(use-package ws-butler
  :hook (prog-mode . ws-butler-mode))

(use-package which-key
  :config (which-key-mode))

(use-package consult
  :bind (("C-x b"   . consult-buffer)
         ("C-x p b" . consult-project-buffer)
         ("M-g" . consult-imenu))
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :config
  (setq xref-show-xrefs-function #'consult-xref)
  (setq xref-show-definitions-function #'consult-xref))

;; completion engine
;; orderless is spaced groups of chars

(use-package orderless
  :custom
  (completion-styles '(orderless initials basic)))

;; editor completion

(use-package corfu
  :config
  (require 'corfu-popupinfo)
  (global-corfu-mode)
  (corfu-popupinfo-mode))

(setq tab-always-indent 'complete)

;; minibuffer

(use-package vertico
  :config
  (vertico-mode)

  ;; hide commands in M-x which don't work in the current mode
  (setq read-extended-command-predicate
        #'command-completion-default-include-p))

(use-package marginalia
  :config (marginalia-mode))

;; modeline

(use-package minions
  :config
  (minions-mode))

;; visuals

(use-package ef-themes)
(use-package modus-themes)

;; fade out most parens, but highlight scope

(use-package paren-face
  :hook (prog-mode . paren-face-mode))

(use-package highlight-parentheses
  :vc (:fetcher sourcehut :repo tsdh/highlight-parentheses.el)
  :hook
  ((prog-mode . highlight-parentheses-mode)
   (minibuffer-setup-mode . highlight-parentheses-minibuffer-setup)))

(use-package ligature
  :config
  (ligature-set-ligatures
   'prog-mode
   ;; more or less setup for monolisa
   '(;; coding ligatures
    "<!---" "--->" "|||>" "<!--" "<|||" "<==>" "-->" "->>" "-<<" "..=" "!=="
    "#_(" "/==" "||>" "||=" "|->" "===" "==>" "=>>" "=<<" "=/=" ">->" ">=>"
    ">>-" ">>=" "<--" "<->" "<-<" "<||" "<|>" "<=" "<==" "<=>" "<=<" "<<-"
    "<<=" "<~>" "<~~" "~~>" ">&-" "<&-" "&>>" "&>" "->" "-<" "-~" ".=" "!="
    "#_" "/=" "|=" "|>" "==" "=>" ">-" ">=" "<-" "<|" "<~" "~-" "~@" "~="
    "~>" "~~"

    ;; whitespace ligatures
    "---" "'''" "\"\"\"" "..." "..<" "{|" "[|" ".?" "::" ":::" "::=" ":="
    ":>" ":<" "!!" "!!." "!!!"  "?." "?:" "??" "?=" "**" "***" "*>" ;; "\;\;"
    "*/" "--" "#:" "#!" "#?" "##" "###" "####" "#=" "/*" "/>" "//" "/**"
    "///" "$(" ">&" "<&" "&&" "|}" "|]" "$>" ".." "++" "+++" "+>" "=:="
    "=!=" ">:" ">>" ">>>" "<:" "<*" "<*>" "<$" "<$>" "<+" "<+>" "<>" "<<"
    "<<<" "</" "</>" "^=" "%%"))
  (global-ligature-mode))

;;;; ide/editor

(use-package emacs
  :config
  (setq dired-vc-rename-file t))

(use-package spacious-padding
  :init
  (setq spacious-padding-subtle-mode-line t)
  (spacious-padding-mode t))

(use-package project
  :config
  (setq project-vc-extra-root-markers '("Gemfile" "package.json")))

(defun treemacs/my/faces-customization ()
  (ef-themes-with-colors
    (custom-set-faces
     `(treemacs-window-background-face ((,c :background ,bg-dim))))))

(use-package treemacs
  :bind (("<f8>" . treemacs))
  :init
  (add-hook 'ef-themes-post-load-hook #'treemacs/my/faces-customization))

(defun eshell/my/faces-customization ()
  (ef-themes-with-colors
    (setq buffer-face-mode-face `(:background ,bg-alt :height 120)))
  (buffer-face-mode 1))

(use-package eshell
  :bind (("<f9>" . project-eshell))
  :init
  (add-hook 'eshell-mode-hook #'eshell/my/faces-customization))

(use-package evil
  :hook ((prog-mode . evil-local-mode)
         (text-mode . evil-local-mode)
	 (diff-mode . evil-local-mode)
	 (wdired-mode . evil-local-mode))
  :init
  (setq evil-move-beyond-eol t)
  :config
  ;; :x should leave the window alone
  (evil-define-command evil-save-modified-and-kill-buffer (file &optional bang)
    "Save the current buffer and kill the buffer."
    :repeat nil
    (interactive "<f><!>")
    (when (buffer-modified-p)
      (evil-write nil nil nil file bang))
    (kill-current-buffer))
  (evil-ex-define-cmd "x" #'evil-save-modified-and-kill-buffer))

(use-package evil-commentary
  :config (evil-commentary-mode 1))

(use-package evil-surround
  :config (global-evil-surround-mode 1))

;; g; goes to previous change

(use-package goto-chg
  :after evil)

;;;; apps

(use-package magit
  :hook
  (magit-process-mode . goto-address-mode)
  :bind
  (("C-c g g" . magit-status)
   ("C-c p m" . magit-project-status))
  :config
  (setq magit-clone-default-directory (homed "local/temp")))

;;

(use-package edraw
  :vc (:fetcher github :repo misohena/el-easydraw)
  :config
  (with-eval-after-load 'nnrg
    (require 'edraw-org)
    (edraw-org-setup-default)))

;;

(use-package org
  :demand t
  :bind
  (("C-c o o" . org-capture)
   ("C-c o a" . org-agenda)
   ("C-c o n" . jump-to-config/notes)
   ("C-c o e" . jump-to-config/init))
  :config
  (setq org-default-notes-file "~/local/capture.org")

  (require 'org-capture)
  (require 'org-protocol)

  (setq org-capture-templates ())

  (add-to-list 'org-capture-templates
               '("t" "Task" entry (file+headline "" "tasks")
        	 "* TODO %? %a"))

  (add-to-list 'org-capture-templates
               '("c" "Clocked" item (clock)))

  (add-to-list 'org-capture-templates
               '("j" "Journal" item (file+datetree "")
        	 "- %? %a"))

  (add-to-list 'org-capture-templates
               '("p" "Protocol" item (file+datetree "")
                 "- [[%:link][%:description]] %U\n%i\n%?" :prepend t))

  (add-to-list 'org-capture-templates
               '("L" "Protocol Link" item (file+datetree "")
                 "- [[%:link][%:description]] %U\n%?" :prepend t)))

;;;; languages

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package eglot
  :bind
  (:map eglot-mode-map
	("s-," . xref-go-back)
	("s-." . xref-find-definitions))
  :config
  (setq eglot-autoshutdown t)

  ;; custom servers
  (add-to-list
   'eglot-server-programs
   '((ruby-mode ruby-ts-mode)
     "bundle" "exec" "solargraph" "stdio")))

(use-package eglot-booster
  :vc (:fetcher github :repo jdtsmith/eglot-booster)
  :after eglot
  :config
  (eglot-booster-mode))

;;

(use-package rust-mode)

;;

(use-package sly
  :init
  (setq inferior-lisp-program "sbcl")
  (require 'sly-autoloads))

;;

(use-package geiser-guile)

(defun fennel-repl/my/faces-customization ()
  (ef-themes-with-colors
    (setq buffer-face-mode-face `(:height 120)))
  (buffer-face-mode 1))

(use-package fennel-mode
  :init
  (add-hook 'fennel-mode-hook #'fennel-proto-repl-minor-mode)
  (add-hook 'fennel-repl-mode-hook #'fennel-repl/my/faces-customization)
  (add-hook 'fennel-proto-repl-mode-hook #'fennel-repl/my/faces-customization)
  :config
  (add-to-list 'fennel-builtin-functions "if-not")
  (add-to-list 'fennel-builtin-functions "when-not")
  (add-to-list 'fennel-builtin-functions "if-let")
  (add-to-list 'fennel-builtin-functions "when-let")
  (add-to-list 'fennel-builtin-functions "nil?")

  (put 'if-let 'fennel-indent-function 1)
  (put 'when-not 'fennel-indent-function 1)
  (put 'when-let 'fennel-indent-function 1)

  (put 'local 'fennel-indent-function 1)
  (put 'global 'fennel-indent-function 1))

;;

(use-package graphql-ts-mode
  :mode ("\\.graphql\\'" "\\.gql\\'")
  :init (with-eval-after-load 'treesit
          (add-to-list 'treesit-language-source-alist
                       '(graphql "https://github.com/bkegley/tree-sitter-graphql"))))

;;

(use-package nginx-mode)
(use-package poly-nginx-lua-mode
  :vc (:fetcher github :repo harsman/poly-nginx-lua-mode))

;;; late comers, because hooks are a stack

(use-package envrc
  :init   (setq envrc-debug nil)
  :config (envrc-global-mode))

;;; done, basically

(load custom-file) ;; :NOERROR :NOMESSAGE)

(put 'dired-find-alternate-file 'disabled nil)
(put 'narrow-to-region 'disabled nil)
