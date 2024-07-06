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
   '(counsel smex terminal-here all-the-icons sideline-eglot company-quickhelp dashboard yasnippet-classic-snippets flycheck-cython flycheck-pycheckers flycheck-clang-tidy flycheck-clang-analyzer flycheck-clangcheck flycheck-rust sideline-flycheck flymake-flycheck sideline-flymake ligature aggressive-indent neotree doom-modeline swiper yasnippet-snippets yasnippet gruvbox-theme company which-key ##)))
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

(add-to-list 'default-frame-alist '(font . "Fira Code 10"))

(require 'counsel)

(setq-default fancy-splash-image '"~/Pictures/emacs_logo.png")
(defconst fancy-startup-text
  `((:face variable-pitch
	   "Добро пожаловать :)\n"
	   :link ("Мой Github"
		  ,(lambda (_button)
		     (browse-url "https://github.com/Swomp2/DE-dotfiles")))
	   
	   :link ("\nФайл конфигурации"
		  ,(lambda (_button)
		     (find-file "~/.emacs")))
	   
	   :link ("\nПоследние файлы"
		  ,(lambda (_button)
		     (counsel-recentf)))
	   )))


(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
(tool-bar-mode -1)
(menu-bar-mode -1)
(electric-pair-mode 1)
(electric-indent-mode 1)
(setq-default auto-save-no-message t)
(setq-default auto-save-timer 500)
(setq gc-cons-threshold 100000000)

(use-package rust-mode
  :init
  (setq rust-mode-treesitter-derive t))

(add-hook 'rust-mode-hook
          (lambda () (setq indent-tabs-mode nil)))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("jcs-elpa" . "https://jcs-emacs.github.io/jcs-elpa/packages/") t)
(package-initialize)

(ivy-mode)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)

(use-package flycheck
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-flycheck-mode))

(use-package sideline-flycheck
  :hook (flycheck-mode . sideline-mode))

(use-package sideline-flycheck :hook (flycheck-mode . sideline-flycheck-setup))

(use-package eglot
  :ensure t
  :defer t
  :config (add-to-list 'eglot-server-programs '(python-mode . ("pylsp")))
  (add-to-list 'eglot-server-programs '(rust-mode . ("rust-analyzer")))
  (add-to-list 'eglot-server-programs '(c++-mode . ("clangd")))
  :hook ((python-mode . eglot-ensure)
	 (rust-mode   . eglot-ensure)
	 (c++-mode    . eglot-ensure)
	 (eglot-mode  . sideline-mode)))

(use-package sideline
  :init (setq sideline-backends-left-skip-current-line t
	      sideline-priority 100
	      sideline-display-backend-name t
	      sideline-format-right "%s"
	      sideline-order-right 'up
	      sideline-backends-right '((sideline-eglot    . up)
					(sideline-flycheck . down))))


(use-package company
  :after eglot
  :hook (eglot-managed-mode . company-mode)
  :config (setq company-idle-delay 0.01
		company-minimum-prefix-length 1))

(add-hook 'after-init-hook 'global-company-mode)

(use-package which-key
  :config
  (which-key-mode))
(which-key-setup-minibuffer)
(setq which-key-popup-type 'minibuffer)

;;snippets
(use-package yasnippet
  :ensure t
  :hook ((eglot-mode . yas-minor-mode)))
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

;;ligatures
(use-package ligature
  :load-path "path-to-ligature-repo"
  :config
  (ligature-set-ligatures 't '("www"))
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  (ligature-set-ligatures 'prog-mode
                          '(;; == === ==== => =| =>>=>=|=>==>> ==< =/=//=// =~
                            ;; =:= =!=
                            ("=" (rx (+ (or ">" "<" "|" "/" "~" ":" "!" "="))))
                            ;; ;; ;;;
                            (";" (rx (+ ";")))
                            ;; && &&&
                            ("&" (rx (+ "&")))
                            ;; !! !!! !. !: !!. != !== !~
                            ("!" (rx (+ (or "=" "!" "\." ":" "~"))))
                            ;; ?? ??? ?:  ?=  ?.
                            ("?" (rx (or ":" "=" "\." (+ "?"))))
                            ;; %% %%%
                            ("%" (rx (+ "%")))
                            ;; |> ||> |||> ||||> |] |} || ||| |-> ||-||
                            ;; |->>-||-<<-| |- |== ||=||
                            ;; |==>>==<<==<=>==//==/=!==:===>
                            ("|" (rx (+ (or ">" "<" "|" "/" ":" "!" "}" "\]"
                                            "-" "=" ))))
                            ;; \\ \\\ \/
                            ("\\" (rx (or "/" (+ "\\"))))
                            ;; ++ +++ ++++ +>
                            ("+" (rx (or ">" (+ "+"))))
                            ;; :: ::: :::: :> :< := :// ::=
                            (":" (rx (or ">" "<" "=" "//" ":=" (+ ":"))))
                            ;; // /// //// /\ /* /> /===:===!=//===>>==>==/
                            ("/" (rx (+ (or ">"  "<" "|" "/" "\\" "\*" ":" "!"
                                            "="))))
                            ;; .. ... .... .= .- .? ..= ..<
                            ("\." (rx (or "=" "-" "\?" "\.=" "\.<" (+ "\."))))
                            ;; -- --- ---- -~ -> ->> -| -|->-->>->--<<-|
                            ("-" (rx (+ (or ">" "<" "|" "~" "-"))))
                            ;; *> */ *)  ** *** ****
                            ("*" (rx (or ">" "/" ")" (+ "*"))))
                            ;; www wwww
                            ("w" (rx (+ "w")))
                            ;; <> <!-- <|> <: <~ <~> <~~ <+ <* <$ </  <+> <*>
                            ;; <$> </> <|  <||  <||| <|||| <- <-| <-<<-|-> <->>
                            ;; <<-> <= <=> <<==<<==>=|=>==/==//=!==:=>
                            ;; << <<< <<<<
                            ("<" (rx (+ (or "\+" "\*" "\$" "<" ">" ":" "~"  "!"
                                            "-"  "/" "|" "="))))
                            ;; >: >- >>- >--|-> >>-|-> >= >== >>== >=|=:=>>
                            ;; >> >>> >>>>
                            (">" (rx (+ (or ">" "<" "|" "/" ":" "=" "-"))))
                            ;; #: #= #! #( #? #[ #{ #_ #_( ## ### #####
                            ("#" (rx (or ":" "=" "!" "(" "\?" "\[" "{" "_(" "_"
					 (+ "#"))))
                            ;; ~~ ~~~ ~=  ~-  ~@ ~> ~~>
                            ("~" (rx (or ">" "=" "-" "@" "~>" (+ "~"))))
                            ;; __ ___ ____ _|_ __|____|_
                            ("_" (rx (+ (or "_" "|"))))
                            ;; Fira code: 0xFF 0x12
                            ("0" (rx (and "x" (+ (in "A-F" "a-f" "0-9")))))
                            ;; Fira code:
                            "Fl"  "Tl"  "fi"  "fj"  "fl"  "ft"
                            ;; The few not covered by the regexps.
                            "{|"  "[|"  "]#"  "(*"  "}#"  "$>"  "^="))	   
  (global-ligature-mode t))

(require 'terminal-here)
(setq terminal-here-linux-terminal-command 'kitty)

(global-set-key (kbd "C-y") 'terminal-here-launch)
(global-set-key (kbd "C-f") 'find-file)
(global-set-key (kbd "C-x C-c") 'kill-ring-save)
(global-set-key (kbd "C-x C-v") 'yank)
(global-set-key (kbd "C-x C-x") 'kill-region)
(global-set-key (kbd "C-b") 'undo)
(global-set-key (kbd "C-h") 'scroll-down-command)
(global-set-key (kbd "C-t") 'scroll-up-command)
(global-set-key (kbd "C-g") 'goto-line)
(global-set-key (kbd "C-r") 'goto-char)
(global-set-key (kbd "C-s") 'forward-page)
(global-set-key (kbd "C-n") 'backward-page)
(global-set-key (kbd "C-'") 'isearch-forward)
(global-set-key (kbd "C-,") 'isearch-backward)
(global-set-key (kbd "C-k") 'kill-buffer)
(global-set-key (kbd "C-l") 'list-buffers)
(global-set-key (kbd "C-p") 'other-window)
(global-set-key (kbd "C-;") 'comment-dwim)
(global-set-key (kbd "C-j") 'delete-other-windows)
(global-set-key (kbd "C-w") 'split-window-horizontally)
(global-set-key (kbd "C-v") 'split-window-vertically)
(global-set-key (kbd "C-o") 'move-end-of-line)
(global-set-key (kbd "C-a") 'move-beginning-of-line)
(global-set-key (kbd "M-r") 'counsel-recentf)
(global-set-key (kbd "M-v") 'counsel-command-history)
