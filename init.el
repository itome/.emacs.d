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
            (frame-title-format . '("%f"))
            (create-lockfiles . nil)
            (truncate-lines . t)
            (truncate-partial-width-windows . t)
            (debug-on-error . nil)
            (init-file-debug . t)
            (inhibit-splash-screen . t)
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

(leaf font
  :config
  (add-to-list 'default-frame-alist '(font . "JetBrains Mono")))

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
    :hook (after-init-hook doom-modeline-mode)
    :custom
    (doom-modeline-lsp . t))

  (leaf all-the-icons
    :ensure t))

(leaf ivy
  :ensure t
  :leaf-defer nil
  :custom
  (ivy-initial-inputs-alist . nil)
  (ivy-use-selectable-prompt . t)
  (ivy-re-builders-alist . '((swiper     . ivy--regex-plus)
                             (counsel-rg . ivy--regex-plus)
                             (t          . ivy--regex-fuzzy)))
  :global-minor-mode t
  :config
  (define-key ivy-minibuffer-map [escape] 'minibuffer-keyboard-quit)
  (leaf swiper
    :ensure t)
  (leaf counsel
    :ensure t
    :global-minor-mode t)
  (leaf all-the-icons-ivy-rich
    :ensure t
    :init (all-the-icons-ivy-rich-mode 1))
  (leaf ivy-rich
    :ensure t
    :init (ivy-rich-mode 1))
  (leaf prescient
    :ensure t
    :custom ((prescient-aggressive-file-save . t))
    :global-minor-mode prescient-persist-mode)
  (leaf ivy-prescient
    :ensure t
    :after prescient ivy
    :custom ((ivy-prescient-retain-classic-highlighting . t))
    :global-minor-mode t)
  (leaf ivy-posframe
    :ensure t
    :custom
    (ivy-posframe-parameters . '((left-fringe . 8) (right-fringe . 8)))
    (ivy-posframe-display-functions-alist . '((swiper          . ivy-display-function-fallback)
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
  :ensure t
  :after evil
  :config
  (global-undo-tree-mode)
  (evil-define-key 'normal 'global (kbd "SPC a u") #'undo-tree-redo))

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
  (treemacs-follow-mode -1)
  (treemacs-git-mode -1)
  (treemacs-fringe-indicator-mode 'always)
  (treemacs-resize-icons 44)
  (add-hook 'treemacs-mode-hook (lambda() (display-line-numbers-mode -1)))
  (evil-define-key 'treemacs treemacs-mode-map (kbd "pd") #'treemacs-remove-project-from-workspace)
  (evil-define-key 'treemacs treemacs-mode-map (kbd "pa") #'treemacs-add-project-to-workspace)
  (evil-define-key 'treemacs treemacs-mode-map (kbd "cf") #'treemacs-create-file)
  (evil-define-key 'treemacs treemacs-mode-map (kbd "cd") #'treemacs-create-dir)
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

(leaf flycheck
  :ensure t
  :after evil
  :config
  (defun toggle-flycheck-error-list ()
    "Toggle flycheck's error list window.
    If the error list is visible, hide it.  Otherwise, show it."
    (interactive)
    (-if-let (window (flycheck-get-error-list-window))
        (quit-window nil window)
      (flycheck-list-errors)))
  (evil-define-key '(normal) 'global
    (kbd "SPC e l") 'toggle-flycheck-error-list))

(leaf *evil
  :config
  (leaf evil
    :ensure t
    :preface
    (setq evil-want-integration t)
    (setq evil-want-keybinding nil)
    :config
    (evil-mode 1)
    (evil-set-undo-system 'undo-tree)
    (evil-define-key 'motion 'global
      (kbd "SPC") nil
      (kbd ",") nil)
    (defun alternate-buffer ()
      (interactive)
      (switch-to-buffer (car (evil-alternate-buffer))))
    (evil-define-key '(normal motion) 'global
      (kbd "SPC p f") 'projectile-find-file
      (kbd "SPC SPC") 'counsel-M-x
      (kbd "/")       'swiper
      (kbd "SPC /")   'counsel-rg
      (kbd "SPC f s") 'save-buffer
      (kbd "SPC f f") 'find-file
      (kbd "SPC f t") 'treemacs-select-window
      (kbd "SPC b b") 'counsel-ibuffer
      (kbd "SPC TAB") 'alternate-buffer
      (kbd "SPC w w") 'evil-window-next
      (kbd "SPC w b") 'evil-window-prev
      (kbd "SPC w l") 'evil-window-right
      (kbd "SPC w h") 'evil-window-left
      (kbd "SPC w j") 'evil-window-down
      (kbd "SPC w k") 'evil-window-up
      (kbd "SPC w d") 'evil-window-delete
      (kbd "SPC w /") 'split-window-horizontally
      (kbd "SPC w -") 'split-window-vertically
      (kbd ", g g")   'xref-find-definitions
      (kbd ", g r")   'xref-find-references
      (kbd ", g b")   'xref-pop-marker-stack))
  (leaf evil-surround
    :ensure t
    :config (global-evil-surround-mode 1)))

(leaf *git
  :config
  (leaf fringe-helper
    :ensure t
    :commands fringe-helper-define)
  (leaf git-gutter
    :ensure t
    :config (global-git-gutter-mode +1)
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
    ((
      go-mode-hook
      typescript-tsx-mode-hook
      dart-mode-hook
      rust-mode-hook
      c++-mode-hook
      swift-mode-hook
      ) . lsp)
    ((
      go-mode-hook
      dart-mode-hook
      ) . (lambda () (add-hook 'before-save-hook #'lsp-format-buffer t t)))
    :custom
    (lsp-headerline-breadcrumb-enable . nil)
    (lsp-eldoc-hook . nil)
    :config
    (evil-define-key 'normal 'lsp-mode-map
      (kbd ", a a") 'lsp-execute-code-action
      (kbd ", g t") 'lsp-find-type-definition
      (kbd ", g i") 'lsp-ui-peek-find-implementation
      (kbd ", r r") 'lsp-rename
      (kbd ", r o") 'lsp-organize-imports)
    (leaf lsp-ui
      :ensure t
      :hook ((lsp-mode-hook . lsp-ui-mode))
      :custom
      ((lsp-ui-doc-enable            . t)
       (lsp-ui-doc-include-signature . t)
       (lsp-ui-flycheck-enable       . t)
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
      :ensure t))
  (leaf :rust
    :config
    (leaf rust-mode
      :ensure t
      :custom (rust-format-on-save . t)))
  (leaf *dart
    :config
    (leaf dart-mode
      :ensure t
      :config
      (leaf lsp-dart :ensure t)))
  (leaf *swift
    :config
    (leaf swift-mode
      :ensure t
      :config
      (leaf lsp-sourcekit
        :ensure t
        :config
        (setq
         lsp-sourcekit-executable  (string-trim (shell-command-to-string "xcrun --find sourcekit-lsp"))
         lsp-sourcekit-extra-args  '(
                                     "-Xswiftc"
                                     "-sdk"
                                     "-Xswiftc"
                                     "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk"
                                     "-Xswiftc"
                                     "-target"
                                     "-Xswiftc"
                                     "x86_64-apple-ios13.6-simulator")))))
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
      :after web-mode
      :hook ((typescript-tsx-mode-hook . prettier-js-mode)))))
