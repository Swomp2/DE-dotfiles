(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(gruvbox-dark-soft))
 '(custom-safe-themes
   '("c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "871b064b53235facde040f6bdfa28d03d9f4b966d8ce28fb1725313731a2bcc8" "2ff9ac386eac4dffd77a33e93b0c8236bb376c5a5df62e36d4bfa821d56e4e20" "72ed8b6bffe0bfa8d097810649fd57d2b598deef47c992920aef8b5d9599eefe" default))
 '(minimap-window-location 'right)
 '(package-selected-packages
   '(minimap sublimity aggressive-indent neon-mode neotree dashboard projectile doom-modeline sideline-flycheck swiper sideline-eglot eglot flycheck-eglot yasnippet-snippets yasnippet gruvbox-theme company which-key flycheck-rust flycheck-clang-tidy flycheck-pycheckers flycheck ##)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.

(global-display-line-numbers-mode 1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(electric-pair-mode 1)
(electric-indent-mode 1)
(setq-default auto-save-no-message t)
(setq-default auto-save-timer 500)

(add-to-list 'default-frame-alist '(font . "Hack-9"))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("jcs-elpa" . "https://jcs-emacs.github.io/jcs-elpa/packages/") t)
(package-initialize)

(ivy-mode)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)

(use-package sideline
  :init
  :hook (flycheck-mode . sideline-mode))

(use-package sideline-eglot
  :init
  (setq sideline-backends-right '(sideline-eglot)))

(use-package eglot
  :ensure t
  :defer t
  :config (add-to-list 'eglot-server-programs '(python-mode . ("pylsp")))
  (add-to-list 'eglot-server-programs '(rust-mode . ("rust-analyzer")))
  (add-to-list 'eglot-server-programs '(c++-mode . ("clangd")))
  :hook ((python-mode . eglot-ensure)
	 (rust-mode . eglot-ensure)
	 (c++-mode . eglot-ensure)
	 (eglot-mode . sideline-mode)))

(use-package flycheck-eglot
  :ensure t
  :after (flycheck eglot)
  :config
  (global-flycheck-eglot-mode 1))

(use-package which-key
  :config
  (which-key-mode))
(which-key-setup-minibuffer)
(setq which-key-popup-type 'minibuffer)

(add-hook 'after-init-hook 'global-company-mode)

(use-package flycheck
  :ensure t
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

;;snippets
(use-package yasnippet
  :ensure t
  :hook ((lsp-mode . yas-minor-mode)))
(yas-global-mode 1)

;;modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(setq doom-modeline-icon t)
(setq doom-modeline-major-mode-icon t)
(setq doom-modeline-major-mode-color-icon t)
(setq doom-modeline-buffer-state-icon t)
(setq doom-modeline-buffer-file-name t)
(setq doom-modeline-buffer-file-name-style 'auto)
(setq doom-modeline-buffer-file-state-icon t)
(setq doom-modeline-env-version t)

;;dashboard
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

(setq dashboard-startupify-list '((dashboard-insert-banner)
				  (dashboard-insert-newline)
				  (dashboard-insert-banner-title)
				  (dashboard-insert-newline)
				  (dashboard-insert-items)
				  (dashboard-insert-newline)))
(setq dashboard-banner-logo-title "Welcome to Emacs!!")
(setq dashboard-startup-banner 'logo)
(setq dashboard-center-content t)
(setq dashboard-vertically-center-content t)
(setq dashboard-items '((recents   . 10)
			(projects  . 5)
			(bookmarks . 5)))
(setq dashboard-navigation-cycle t)
(setq dashboard-item-shortcuts '((recents   . "r")
				 (projects  . "p")
				 (bookmarks . "b")))
(setq dashboard-icon-type 'nerd-icons)

(setq initial-buffer-choice (lambda () (get-buffer-create *Dashboard*)))

;;neotree
(require 'neotree)
(global-set-key (kbd "C-u") 'neotree-toggle)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))

;;clipboard on wayland
(setq wl-copy-process nil)
(defun wl-copy (text)
  (setq wl-copy-process (make-process :name "wl-copy"
				      :buffer nil
				      :command '("wl-copy" "-f" "-n")
				      :connection-type 'pipe
				      :noquery t))
  (process-send-string wl-copy-process text)
  (process-send-eof wl-copy-process))
(defun wl-paste ()
  (if (and wl-copy-process (process-live-p wl-copy-process))
      nil
    (shell-command-to-string "wl-paste -n")))
(setq interprogram-cut-function 'wl-copy)
(setq interprogram-paste-function 'wl-paste)

(global-aggressive-indent-mode 1)
(sublimity-mode 1)
