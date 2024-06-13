(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-osc-for-compilation-buffer t)
 '(custom-enabled-themes '(ef-night))
 '(custom-safe-themes
    '("515ebca406da3e759f073bf2e4c8a88f8e8979ad0fdaba65ebde2edafc3f928c" "f943bbe619c11a066be5ed60111f3846e7e31af7a376a3fbc02596387f92cae7" "cd191949417eafc21b1cb9f3c03f0af6f75f404a7fcd83e886556a0ce7c157af" "c7a926ad0e1ca4272c90fce2e1ffa7760494083356f6bb6d72481b879afce1f2" "2628939b8881388a9251b1bb71bc9dd7c6cffd5252104f9ef236ddfd8dbbf74a" default))
 '(modus-themes-bold-constructs t)
 '(package-selected-packages
    '(zig-mode eglot eat php-mode avy-window elpher spacious-padding-mode dired mindstream popwin shackle treemacs-all-the-icons treemacs-tab-bar cargo-mode polymode origami restclient svg-lib dotenv-mode terraform-mode ws-butler yaml-mode which-key vertico vc-use-package unicode-fonts typescript-mode tui treesit-parser-manager treesit-auto treemacs-magit treemacs-icons-dired treemacs-evil spacious-padding solaire-mode simple-modeline selected-window-accent-mode robe project-tab-groups poly-nginx-lua-mode poly-markdown poly-erb paren-face org-pretty-table org-gtd orderless olivetti no-littering nix-mode nginx-mode moonscript modus-themes minions mermaid-ts-mode marginalia lua-mode lsp-mode ligature jtsx janet-mode highlight-parentheses graphql-ts-mode geiser-racket geiser-guile geiser-chibi fennel-mode feebleline exec-path-from-shell evil-surround evil-lisp-state evil-leader evil-commentary envrc el-easydraw eglot-booster ef-themes edraw editorconfig edit-indirect dune dockerfile-mode csv-mode corfu consult company breadcrumb bespoke-themes bespoke-modeline base16-theme astro-ts-mode all-the-icons afternoon-theme))
 '(package-vc-selected-packages
    '((mindstream :vc-backend Git :url "https://github.com/emacsmirror/mindstream")))
 '(safe-local-variable-values
    '((eval let
        ((root
           (expand-file-name
             (project-root
               (project-current)))))
        (setq fennel-program
          (concat "love " root)
          fennel-proto-repl-fennel-module-name "lib.fennel"))))
 '(switch-to-buffer-in-dedicated-window 'pop)
 '(switch-to-buffer-obey-display-actions t)
 '(treemacs-collapse-dirs 3)
 '(treemacs-filewatch-mode t)
 '(treemacs-follow-after-init t)
 '(treemacs-follow-mode t)
 '(treemacs-fringe-indicator-mode nil)
 '(treemacs-git-mode t)
 '(treemacs-project-follow-cleanup t)
 '(treemacs-project-follow-into-home nil)
 '(treemacs-project-follow-mode t)
 '(treemacs-select-when-already-in-treemacs 'next-or-back)
 '(treemacs-text-scale -1))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#000e17" :foreground "#afbcbf" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 150 :width normal :foundry "nil" :family "MonoLisa Script"))))
 '(tab-line-tab-active ((t)))
 '(treemacs-window-background-face ((((class color) (min-colors 256)) :background "#1d202f")))
 '(variable-pitch ((t (:family "SF Compact ")))))
