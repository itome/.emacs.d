(setq byte-compile-warnings  '(not cl-functions obsolete))

;; <leaf-install-code>
(eval-and-compile
  (customize-set-variable
   'package-archives '(("org" . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))
;; </leaf-install-code>

(leaf custom-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

(leaf custom-start
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :custom '((user-full-name . "Takeshi Tsukamoto")
            (user-mail-address . "dev@itome.team")
            (user-login-name . "itome")
            (create-lockfiles . nil)
            (debug-on-error . t)
            (init-file-debug . t)
            (frame-resize-pixelwise . t)
            (enable-recursive-minibuffers . t)
            (history-length . 1000)
            (history-delete-duplicates . t)
            (scroll-preserve-screen-position . t)
            (scroll-conservatively . 100)
            (mouse-wheel-scroll-amount . '(1 ((control) . 5)))
            (ring-bell-function . 'ignore)
            (text-quoting-style . 'straight)
            (truncate-lines . nil)
            (use-dialog-box . nil)
            (use-file-dialog . nil)
            (blink-cursor-mode . nil) 
            (menu-bar-mode . nil)
            (tool-bar-mode . nil)
            (scroll-bar-mode . nil)
            (indent-tabs-mode . nil)
            (tab-width . 2))
  :config
  (defalias 'yes-or-no-p 'y-or-n-p)
  (keyboard-translate ?\C-h ?\C-?)
  (keyboard-translate ?\C-j ?\C-n)
  (keyboard-translate ?\C-k ?\C-p))

(leaf maximize-screen
  :config (add-to-list 'initial-frame-alist '(fullscreen . maximized)))

(leaf electric
  :config (electric-pair-mode 1))

(leaf linum
  :config (global-display-line-numbers-mode))

(leaf backup-files
  :custom `((auto-save-timeout . 15)
            (auto-save-interval . 60)
            (auto-save-file-name-transforms . '((".*" ,(locate-user-emacs-file "backup/") t)))
            (backup-directory-alist . '((".*" . ,(locate-user-emacs-file "backup"))
                                        (,tramp-file-name-regexp . nil)))
            (version-control . t)
            (delete-old-versions . t)))

(leaf autorevert
  :custom ((auto-revert-interval . 0.1))
  :global-minor-mode global-auto-revert-mode)

(leaf *theme
  :config
  (leaf doom-themes
    :ensure t
    :custom
    (doom-themes-enable-bold . t)
    (doom-themes-enable-italic . t)
    (doom-themes-treemacs-theme . "doom-colors")
    :config
    (load-theme 'doom-nord t)
    (doom-themes-treemacs-config))

  (leaf doom-modeline
    :ensure t
    :hook (after-init-hook doom-modeline-mode))

  (leaf all-the-icons
    :ensure t))

(leaf ivy
  :ensure t
  :leaf-defer nil
  :custom ((ivy-initial-inputs-alist . nil)
           (ivy-use-selectable-prompt . t))
  :global-minor-mode t
  :config
  (define-key ivy-minibuffer-map [escape] 'minibuffer-keyboard-quit)
  (leaf swiper
    :ensure t)
  (leaf counsel
    :ensure t
    :global-minor-mode t)
  (leaf ivy-posframe
    :ensure t
    :custom
    (ivy-posframe-parameters . '((left-fringe . 8) (right-fringe . 8)))
    (ivy-posframe-display-functions-alist . '(
                                              (swiper          . ivy-display-function-fallback)
                                              (counsel-rg      . ivy-display-function-fallback)
                                              (t               . ivy-posframe-display)))
    :config
    (ivy-posframe-mode 1)))

(leaf exec-path-from-shell
  :ensure t
  :init
  (when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize)))

(leaf undo-tree
  :ensure t)

(leaf projectile
  :ensure t)

(leaf yasnippet
  :ensure t
  :init (yas-global-mode 1)
  :custom
  (yas-snippet-dirs . '("~/.emacs.d/yasnippets")))

(leaf treemacs
  :ensure t
  :defer-config
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode 'always)
  (treemacs-resize-icons 44)
  (add-hook 'treemacs-mode-hook (lambda() (display-line-numbers-mode -1)))
  (pcase (cons (not (null (executable-find "git")))
             (not (null treemacs-python-executable)))
  (`(t . t)
   (treemacs-git-mode 'deferred))
  (`(t . _)
   (treemacs-git-mode 'simple)))
  :config
  (leaf treemacs-evil
    :after evil
    :ensure t
    :require t))

(leaf company
  :ensure t
  :leaf-defer nil
  :global-minor-mode global-company-mode
  :custom ((company-idle-delay . 0)
           (company-minimum-prefix-length . 2)
           (company-transformers . '(company-sort-by-backend-importance))
           (company-auto-expand . t)
           (company-format-margin-function . #'company-text-icons-margin))
  :config
  (define-key company-active-map (kbd "C-j") 'company-select-next)
  (define-key company-active-map (kbd "C-k") 'company-select-previous)
  (define-key company-active-map [return] 'company-complete-selection)
  (define-key company-active-map (kbd "RET") 'company-complete-selection))

(leaf evil
  :ensure t
  :preface
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  (evil-define-key 'motion 'global
    (kbd "SPC") nil
    (kbd ",") nil)
  (evil-define-key '(normal motion) 'global
    (kbd "SPC SPC") 'counsel-M-x
    (kbd "/")       'swiper
    (kbd "SPC /")   'counsel-rg
    (kbd "SPC f s") 'save-buffer
    (kbd "SPC f f") 'find-file
    (kbd "SPC f t") 'treemacs-select-window
    (kbd "SPC b b") 'counsel-buffer-or-recentf
    (kbd "SPC TAB") 'previous-buffer
    (kbd "SPC w l") 'windmove-right
    (kbd "SPC w h") 'windmove-left
    (kbd "SPC w j") 'windmove-down
    (kbd "SPC w k") 'windmove-up
    (kbd "SPC w /") 'split-window-horizontally
    (kbd "SPC w -") 'split-window-vertically
    (kbd ", g g")   'xref-find-definitions
    (kbd ", g r")   'xref-find-references
    (kbd ", g b")   'xref-pop-marker-stack))

(leaf *git
  :config
  (leaf fringe-helper
    :ensure t
    :commands fringe-helper-define)
  (leaf git-gutter
    :ensure t
    :config
    (global-git-gutter-mode +1)
    (leaf git-gutter-fringe
      :ensure t
      :require t
      :config
      (fringe-helper-define 'git-gutter-fr:added '(center repeated)
        "XXXX....")
      (fringe-helper-define 'git-gutter-fr:modified '(center repeated)
        "XXXX....")
      (fringe-helper-define 'git-gutter-fr:deleted '(center repeated)
        "XXXX...."))))

(leaf *lang
  :config
  (leaf lsp-mode
    :ensure t
    :init
    (setq gc-cons-threshold 100000000
          lsp-idle-delay 0.500
          read-process-output-max (* 3 1024 1024))
    :commands lsp
    :hook
    (go-mode-hook . lsp)
    (typescript-tsx-mode-hook . lsp)
    (dart-mode-hook . lsp)
    :custom
    (lsp-headerline-breadcrumb-enable . nil)
    :config
    (leaf lsp-ui
      :ensure t
      :hook ((lsp-mode-hook . lsp-ui-mode))
      :custom
      ((lsp-ui-doc-enable            . t)
       (lsp-ui-doc-include-signature . t)
       (lsp-ui-flycheck-enable       . nil)
       (lsp-ui-peek-enable           . t)
       (lsp-ui-sideline-show-diagnostics . t)
       (lsp-ui-sideline-show-hover . t)
       (lsp-ui-sideline-show-code-actions . t)
       (lsp-ui-sideline-delay . 1))
      :config
      (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
      (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
      (evil-define-key 'normal 'lsp-mode-map (kbd ", g b") #'lsp-ui-peek-jump-backward)))

  (leaf *go
    :config
    (leaf go-mode
      :ensure t
      :leaf-defer t))
  (leaf *dart
    :config
    (leaf lsp-dart
      :ensure t))
  (leaf *typescript
    :config
    (leaf web-mode
      :ensure t
      :custom
      (web-mode-code-indent-offset . 2)
      (web-mode-enable-auto-quoting . nil)
      (web-mode-css-indent-offset . 2)
      (web-mode-markup-indent-offset . 2)
      :config
      (define-derived-mode typescript-tsx-mode web-mode "TypeScript")
      (add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-tsx-mode))
      (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-tsx-mode))
      (add-to-list 'auto-mode-alist '("\\.js\\'" . typescript-tsx-mode))
      (add-to-list 'auto-mode-alist '("\\.jsx\\'" . typescript-tsx-mode)))
    (leaf prettier-js
      :ensure t
      :hook
      (typescript-tsx-mode . prettier-js-mode)
      :config
      (evil-define-key 'normal 'typescript-tsx-mode (kbd ", = =") #'prettier-js))))
