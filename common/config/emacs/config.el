(setq user-full-name "Dustin Lyons"
  user-mail-address "dustin@dlyons.dev")

;; Turn off the splash screen
(setq inhibit-startup-screen t)
;; Turn off the splash screen
(setq initial-scratch-message nil)
;; Confirm before exiting Emacs
(setq confirm-kill-emacs #'yes-or-no-p)

(unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))
(unless (assoc-default "nongnu" package-archives)
  (add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/") t))

(defun system-is-mac ()
  "Return true if system is darwin-based (Mac OS X)"
  (string-equal system-type "darwin"))

(defun system-is-linux ()
  "Return true if system is GNU/Linux-based"
  (string-equal system-type "gnu/linux"))

;; Set path for darwin
(when (system-is-mac)
  (setenv "PATH" (concat (getenv "PATH") ":/Users/dustin/.nix-profile/bin:/usr/bin"))
  (setq exec-path (append '("/Users/dustin/bin" "/profile/bin" "/Users/dustin/.npm-packages/bin" "/Users/dustin/.nix-profile/bin" "/nix/var/nix/profiles/default/bin" "/usr/local/bin" "/usr/bin") exec-path)))

(use-package counsel
  :demand t
  :bind (("M-x" . counsel-M-x)
    ("C-x b" . counsel-ibuffer)
    ("C-x C-f" . counsel-find-file)
    ("C-M-j" . counsel-switch-buffer)
  :map minibuffer-local-map
    ("C-r" . 'counsel-minibuffer-history))
  :custom
    (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
    (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with ^

(use-package prescient
  :config
    (prescient-persist-mode 1))

(use-package ivy
  :bind (("C-s" . swiper-all)
  :map ivy-minibuffer-map
    ("TAB" . ivy-partial-or-done)
    ("C-f" . ivy-alt-done)
    ("C-l" . ivy-alt-done)
    ("C-j" . ivy-next-line)
    ("C-k" . ivy-previous-line)
  :map ivy-switch-buffer-map
    ("C-k" . ivy-previous-line)
    ("C-l" . ivy-done)
    ("C-d" . ivy-switch-buffer-kill)
  :map ivy-reverse-i-search-map
    ("C-k" . ivy-previous-line)
    ("C-d" . ivy-reverse-i-search-kill))
  :init
    (ivy-mode 1)
  :config
    (setq ivy-use-virtual-buffers t)
    (setq ivy-wrap t)
    (setq ivy-count-format "(%d/%d) ")
    (setq enable-recursive-minibuffers t))

(use-package ivy-rich
  :init (ivy-rich-mode 1))

(use-package ivy-prescient
  :after ivy
  :custom
    (prescient-save-file "~/.emacs.d/prescient-data")
    (prescient-filter-method 'fuzzy)
  :config
    (ivy-prescient-mode t))

(use-package all-the-icons-ivy
  :init (add-hook 'after-init-hook 'all-the-icons-ivy-setup))

;; ESC will also cancel/quit/etc.
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(use-package general
  :init
    (setq evil-want-keybinding nil)
  :config
    (general-evil-setup t)
    (general-create-definer dl/leader-keys
      :keymaps '(normal visual emacs)
      :prefix ","))

(dl/leader-keys
  "k"  '(:ignore k :which-key "cleanup")
  "kk" '(kill-some-buffers :which-key "cleanup buffers"))

(dl/leader-keys
  "t"  '(:ignore t :which-key "toggles")
  "tt" '(treemacs :which-key "toggle treemacs")
  "ty" '(term :which-key "toggle term")
  "to" '(treemacs-select-window :which-key "select treemacs")
  "tw" '(treemacs-toggle-fixed-width :which-key "size treemacs")
  "th" '(counsel-load-theme :which-key "choose theme")
  "tl" '(flymake-show-buffer-diagnostics :which-key "lsp buffer"))

;; Rotates windows and layouts
(use-package rotate
  :config)

(dl/leader-keys
  "r"  '(:ignore t :which-key "rotate")
  "rw"  '(rotate-window :which-key "rotate window")
  "rl"  '(rotate-layout :which-key "rotate layout"))

;; Turn off UI junk
;; Note to future self: If you have problems with these later,
;; move these into custom file and set variable custom-file
(column-number-mode)
(scroll-bar-mode 0)
(menu-bar-mode -1)
(tool-bar-mode 0)
(winner-mode 1) ;; ctrl-c left, ctrl-c right for window undo/redo

(defun dl/org-mode-visual-fill ()
  (setq visual-fill-column-width 110
        visual-fill-column-center-text t))

(use-package visual-fill-column
  :defer t
  :hook (org-mode . dl/org-mode-visual-fill))

(blink-cursor-mode -1)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(defvar dl/black-color "#1F2528")
(defvar dl/red-color "#EC5F67")
(defvar dl/yellow-color "#FAC863")
(defvar dl/blue-color "#6699CC")
(defvar dl/green-color "#99C794")
(defvar dl/purple-color "#C594C5")
(defvar dl/teal-color "#5FB3B3")
(defvar dl/light-grey-color "#C0C5CE")
(defvar dl/dark-grey-color "#65737E")

;; Run M-x all-the-icons-install-fonts to install
(use-package all-the-icons)
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package treemacs
  :config
    (setq treemacs-is-never-other-window 1)
  :bind
    ("C-c t" . treemacs-find-file)
    ("C-c b" . treemacs-bookmark))

(use-package treemacs-icons-dired)
(use-package treemacs-all-the-icons)
(use-package treemacs-projectile)
(use-package treemacs-magit)
(use-package treemacs-evil)

;; Remove binding for facemap-menu, use for ace-window instead
(global-unset-key (kbd "M-o"))

(use-package ace-window
  :bind (("M-o" . ace-window))
  :custom
    (aw-scope 'frame)
    (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
    (aw-minibuffer-flag t)
  :config
    (ace-window-display-mode 1))

;;  (when window-system (set-frame-size (selected-frame) 120 60))
;;    (setq use-dialog-box nil
;;        use-file-dialog nil
;;        cursor-type 'bar)
;;    (add-to-list 'default-frame-alist '(height . 80))
;;    (add-to-list 'default-frame-alist '(width . 160))
;;
;;  (setq default-background (face-attribute 'default :background))
;;
;;  (defun set-window-padding ()
;;    (setq-default left-margin-width 2 right-margin-width 2) ; Define new widths.
;;    (set-window-buffer nil (current-buffer)) ; Use them now
;;    (set-face-background 'header-line default-background))
;;    (when (system-is-linux)
;;      (setq header-line-format " "))
;;    (set-face-attribute 'header-line nil :height 1.0)
;;
;;  (add-hook 'org-mode-hook 'set-window-padding)
;;  (add-hook 'conf-mode-hook 'set-window-padding)
;;  (add-hook 'prog-mode-hook 'set-window-padding)
;;  (add-hook 'flymake-buffer-diagnostic-mode-hook 'set-window-padding)
;;  (add-hook 'text-mode-hook 'set-window-padding)
;;  (add-hook 'treemacs-mode-hook 'set-window-padding)

;; Set the default pitch face
(when (system-is-linux)
  (set-face-attribute 'default nil :font "JetBrainsMono" :height 100))
(when (system-is-mac)
  (set-face-attribute 'default nil :font "JetBrains Mono" :height 130))

;; Set the fixed pitch face
(when (system-is-linux)
  (set-face-attribute 'fixed-pitch nil :font "JetBrainsMono" :weight 'normal :height 100))
(when (system-is-mac)
  (set-face-attribute 'fixed-pitch nil :font "JetBrains Mono" :weight 'normal :height 140))

;; Set the variable pitch face
(when (system-is-linux)
  (set-face-attribute 'variable-pitch nil :font "Helvetica LT Std Condensed" :weight 'normal :height 140))
(when (system-is-mac)
  (set-face-attribute 'variable-pitch nil :font "Helvetica" :weight 'normal :height 170))

(setq-default indent-tabs-mode nil
             js-indent-level 2
             tab-width 2)

(global-set-key (kbd "<C-tab>") 'next-buffer)

(use-package doom-themes
  :ensure t
  :config
    (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
          doom-themes-enable-italic t) ; if nil, italics is universally disabled
    (load-theme 'doom-material-dark t)
    (doom-themes-visual-bell-config)
    (doom-themes-org-config))

(defalias 'yes-or-no-p 'y-or-n-p) ;; Use Y or N in prompts, instead of full Yes or No

(global-visual-line-mode t) ;; Wraps lines everywhere
(global-auto-revert-mode t) ;; Auto refresh buffers from disk
(line-number-mode t) ;; Line numbers in the gutter
(show-paren-mode t) ;; Highlights parans for me

(setq warning-minimum-level :error)

(setq org-agenda-files "~/.config/emacs/agenda.txt" )

(defun org-global-props (&optional property buffer)
  "Helper function to grab org properties"
  (unless property (setq property "PROPERTY"))
  (with-current-buffer (or buffer (current-buffer))
    (org-element-map (org-element-parse-buffer) 'keyword
    (lambda (el) (when (string-match property (org-element-property :key el)) el)))))

(defun dl/refile-and-transclude ()
  "Move file and add transclude link with header"
(interactive)
  (org-roam-refile)
  (insert "#+transclude: [[file:~/State/Areas/Writing/Notebook/20220419121404-todo.org::*" (org-element-property :value (car (org-global-props "TITLE"))) "][Transclude]]"))

(dl/leader-keys
  "a"  '(:ignore t :which-key "manage org-agenda")
  "aa"  '(dl/define-agenda-files :which-key "refresh agenda db")
  "ar"  '(dl/refile-and-transclude :which-key "move buffer to TODO.org and insert transclude link"))

;; Fast access to tag common contexts I use
(setq org-tag-persistent-alist
  '(("home" . ?h) ("batch" . ?b) ("bn" . ?n) ("usf" . ?u) ("agency" . ?a)))

(setq org-todo-keyword-faces
  `(("NEXT" . ,dl/yellow-color)
   ("WAITING" . ,dl/light-grey-color)
   ("SOMEDAY" . ,dl/dark-grey-color)))

(setq org-tag-faces
  `(("batch" . ,dl/yellow-color)
   ("bn" . ,dl/purple-color)
   ("home" . ,dl/blue-color)
   ("usf" . ,dl/teal-color)
   ("agency" . ,dl/blue-color)))

(defun dl/buffer-prop-get (name)
  "Get a buffer property called NAME as a string."
  (org-with-point-at 1
    (when (re-search-forward (concat "^#\\+" name ": \\(.*\\)")
                             (point-max) t)
      (buffer-substring-no-properties
       (match-beginning 1)
       (match-end 1)))))

(defun dl/agenda-category (&optional len)
  "Get category of item at point for agenda."
  (let* ((file-name (when buffer-file-name
                      (file-name-sans-extension
                       (file-name-nondirectory buffer-file-name))))
         (title (dl/buffer-prop-get "title"))
         (category (org-get-category))
         (result
          (or (if (and
                   title
                   (string-equal category file-name))
                  title
                category)
              )))
    (if (numberp len)
        (s-truncate len (s-pad-right len " " result))
      result)))
(setq org-agenda-hide-tags-regexp (regexp-opt '("Todo" "agency" "home" "braeview" "bn" "batch")))
(setq org-agenda-prefix-format
      '((agenda . " %i %(dl/agenda-category 12)%?-32t% s")
        (todo . " %i %(dl/agenda-category 32) ")
        (tags . " %i %(dl/agenda-category 32) ")
        (search . " %i %(dl/agenda-category 32) ")))

(use-package org-transclusion
  :after org
  :hook (org-mode . org-transclusion-mode))

(use-package org-super-agenda
   :after org-agenda
   :init
     (setq org-agenda-dim-blocked-tasks nil))

 ;; Dashboard View
 (setq org-super-agenda-groups
      '((:name "Batch"
               :tag "batch")
        (:name "Now"
               :todo "NEXT")
        (:name "Waiting"
               :todo "WAITING")
        (:name "Bitcoin Noobs"
               :tag "bn")
        (:name "Agency"
               :tag "agency")
        (:name "Student Capstone Projects"
               :tag "usf")
        (:name "Home"
               :tag "home")
        (:name "Someday"
               :todo "SOMEDAY")))

 (org-super-agenda-mode)

(defvar current-time-format "%H:%M:%S"
  "Format of date to insert with `insert-current-time' func.
Note the weekly scope of the command's precision.")

(defun dl/load-buffer-with-emacs-config ()
  "Open the emacs configuration"
  (interactive)
  (find-file "~/State/Projects/Code/nixos-config/common/config/emacs/config.org"))

(defun dl/load-buffer-with-todo ()
  "Open the emacs configuration"
  (interactive)
  (find-file "~/State/Areas/Writing/Notebook/20220419121404-todo.org"))

(defun dl/load-buffer-with-nix-config ()
  "Open the emacs configuration"
  (interactive)
  (find-file "~/State/Projects/Code/nixos-config/common/home-manager.nix"))

(defun dl/reload-emacs ()
  "Reload the emacs configuration"
  (interactive)
  (load "~/.emacs"))

(defun dl/insert-current-time ()
  "Insert the current time (1-week scope) into the current buffer."
       (interactive)
       (insert "** ")
       (insert (format-time-string current-time-format (current-time)))
       (insert "\n"))

  "A few of my own personal shortcuts"
 (dl/leader-keys
  ","  '(dl/insert-current-time :which-key "current time")
  "e"  '(dl/load-buffer-with-emacs-config :which-key "open emacs config")
  "n"  '(dl/load-buffer-with-nix-config :which-key "open nix config")
  "d"  '(dl/load-buffer-with-todo :which-key "open todo"))

(use-package yasnippet)
(yas-global-mode 1)

(setq org-roam-capture-templates
 '(("d" "default" plain
    "%?"
    :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n\n")
    :unnarrowed t)
   ("p" "people" plain
    "#+filetags: People CRM\n\n* Contacts\n\nRelationship: %^{Relationship}\n\n* Notes\n\n %?"
    :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}")
    :unnarrowed t)
   ("i" "institution" plain
    "#+filetags: Institution CRM\n\n* Contacts\n\nRelationship: %^{Relationship}\n\n %?"
    :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}")
    :unnarrowed t)))

(require 'ucs-normalize)
(use-package org-roam
  :straight (:host github :repo "dustinlyons/org-roam"
             :branch "master"
             :files (:defaults "extensions/*")
  :build (:not compile))
  :init
    (setq org-roam-v2-ack t) ;; Turn off v2 warning
    (setq org-roam-mode-section-functions
      (list #'org-roam-backlinks-section
            #'org-roam-reflinks-section
            #'org-roam-unlinked-references-section))
      (add-to-list 'display-buffer-alist
           '("\\*org-roam\\*"
             (display-buffer-in-direction)
             (direction . right)
             (window-width . 0.33)
             (window-height . fit-window-to-buffer)))
  :custom
    (org-roam-directory (file-truename "~/State/Areas/Writing/Notebook"))
    (org-roam-dailies-directory "daily/")
    (org-roam-completion-everywhere t)
  :bind
    (("C-c r b" . org-roam-buffer-toggle)
     ("C-c r t" . org-roam-dailies-goto-today)
     ("C-c r y" . org-roam-dailies-goto-yesterday)
     ("C-M-n" . org-roam-node-insert)
       :map org-mode-map
     ("C-M-i"   . completion-at-point)
     ("C-M-f" . org-roam-node-find)
     ("C-M-c" . dl/org-roam-create-id)
     ("C-<left>" . org-roam-dailies-goto-previous-note)
     ("C-`" . org-roam-buffer-toggle)
     ("C-<right>" . org-roam-dailies-goto-next-note)))
(org-roam-db-autosync-mode)

(setq org-roam-dailies-capture-templates
  '(("d" "default" entry
     "* %?"
     :if-new (file+head "%<%Y-%m-%d>.org"
                        "#+TITLE: %<%Y-%m-%d>\n#+filetags: Daily\n\n* %<%Y-%m-%d>\n\n* Log\n\n* Import"))))

(defvar dl/org-created-property-name "CREATED")

(defun dl/org-set-created-property (&optional active name)
  (interactive)
  (let* ((created (or name dl/org-created-property-name))
         (fmt (if active "<%s>" "[%s]"))
         (now (format fmt (format-time-string "%Y-%m-%d %a %H:%M"))))
    (unless (org-entry-get (point) created nil)
      (org-set-property created now)
      now)))

(defun dl/org-find-time-file-property (property &optional anywhere)
  (save-excursion
    (goto-char (point-min))
    (let ((first-heading
           (save-excursion
             (re-search-forward org-outline-regexp-bol nil t))))
      (when (re-search-forward (format "^#\\+%s:" property)
                               (if anywhere nil first-heading) t)
        (point)))))

(defun dl/org-has-time-file-property-p (property &optional anywhere)
  (when-let ((pos (dl/org-find-time-file-property property anywhere)))
    (save-excursion
      (goto-char pos)
      (if (and (looking-at-p " ")
               (progn (forward-char)
                      (org-at-timestamp-p 'lax)))
          pos -1))))

(defun dl/org-set-time-file-property (property &optional anywhere pos)
  (when-let ((pos (or pos
                      (dl/org-find-time-file-property property))))
    (save-excursion
      (goto-char pos)
      (if (looking-at-p " ")
          (forward-char)
        (insert " "))
      (delete-region (point) (line-end-position))
      (let* ((now (format-time-string "[%Y-%m-%d %a %H:%M]")))
        (insert now)))))

(defun dl/org-set-last-modified ()
  "Update the LAST_MODIFIED file property in the preamble."
  (when (derived-mode-p 'org-mode)
    (dl/org-set-time-file-property "LAST_MODIFIED")))

(defun dl/org-roam-create-id ()
"Add created date to org-roam node."
  (interactive)
  (org-id-get-create)
  (dl/org-set-created-property))

(set-face-attribute 'ivy-current-match nil :foreground "#3d434d" :background "#ffcc66")

(use-package org-superstar
  :after org
  :hook (org-mode . org-superstar-mode)
  :custom
    (org-superstar-remove-leading-stars t)
    (org-superstar-headline-bullets-list '("•" "•" "•" "◦" "◦" "◦" "◦")))

(add-hook 'org-mode-hook 'variable-pitch-mode)
 (require 'org-indent)
 (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
 (set-face-attribute 'org-table nil  :inherit 'fixed-pitch)
 (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
 (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
 (set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
 (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
 (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
 (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
 (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
 (when (system-is-linux)
   (set-face-attribute 'org-document-title nil :font "Helvetica LT Std Condensed" :weight 'bold :height 1.2))
 (when (system-is-mac)
   (set-face-attribute 'variable-pitch nil :font "Helvetica" :height 120))
 (dolist (face '((org-level-1 . 1.2)
                 (org-level-2 . 1.15)
                 (org-level-3 . 1.1)
                 (org-level-4 . 1.05)
                 (org-level-5 . 1.05)
                 (org-level-6 . 1.0)
                 (org-level-7 . 1.0)
                 (org-level-8 . 1.0)))
(when (system-is-linux)
  (set-face-attribute (car face) nil :font "Helvetica LT Std Condensed" :weight 'medium :height (cdr face)))
(when (system-is-mac)
  (set-face-attribute 'variable-pitch nil :font "Helvetica" :weight 'medium :height 170)))

(defun dl/evil-hook ()
  (dolist (mode '(eshell-mode
                  git-rebase-mode
                  term-mode))
  (add-to-list 'evil-emacs-state-modes mode))) ;; no evil mode for these modes

(use-package evil
  :init
    (setq evil-want-integration t) ;; TODO: research what this does
    (setq evil-want-fine-undo 'fine) ;; undo/redo each motion
    (setq evil-want-Y-yank-to-eol t) ;; Y copies to end of line like vim
    (setq evil-want-C-u-scroll t) ;; vim like scroll up
    (evil-mode 1)
    :hook (evil-mode . dl/evil-hook)
  :config
    ;; Emacs "cancel" == vim "cancel"
    (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)

    ;; Ctrl-h deletes in vim insert mode
    (define-key evil-insert-state-map (kbd "C-h")
      'evil-delete-backward-char-and-join)

    ;; When we wrap lines, jump visually, not to the "actual" next line
    (evil-global-set-key 'motion "j" 'evil-next-visual-line)
    (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

    (evil-set-initial-state 'message-buffer-mode 'normal)
    (evil-set-initial-state 'dashboard-mode 'normal))

;; Gives me vim bindings elsewhere in emacs
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; Keybindings in org mode
(use-package evil-org
  :after evil
  :hook
    (org-mode . (lambda () evil-org-mode))
  :config
    (require 'evil-org-agenda)
    (evil-org-agenda-set-keys))

;; Branching undo system
(use-package undo-tree
  :after evil
  :diminish
  :config
  (evil-set-undo-system 'undo-tree)
  (global-undo-tree-mode 1))

;; Keep undo files from littering directories
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))

(use-package vterm
  :commands vterm
  :config
    (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")
    (setq vterm-shell "zsh")
    (setq vterm-max-scrollback 10000))

(use-package all-the-icons-dired)

(use-package dired
  :ensure nil
  :straight nil
  :defer 1
  :commands (dired dired-jump)
  :config
    (setq dired-listing-switches "-agho --group-directories-first")
    (setq dired-omit-files "^\\.[^.].*")
    (setq dired-omit-verbose nil)
    (setq dired-hide-details-hide-symlink-targets nil)
    (setq delete-by-moving-to-trash t)
    (autoload 'dired-omit-mode "dired-x")
    (add-hook 'dired-load-hook
          (lambda ()
            (interactive)
            (dired-collapse)))
    (add-hook 'dired-mode-hook
          (lambda ()
            (interactive)
            (dired-omit-mode 1)
            (dired-hide-details-mode 1)
            (all-the-icons-dired-mode 1))
            (hl-line-mode 1)))

(use-package dired-single)
(use-package dired-ranger)
(use-package dired-collapse)

(evil-collection-define-key 'normal 'dired-mode-map
  "h" 'dired-single-up-directory
  "c" 'find-file
  "H" 'dired-omit-mode
  "l" 'dired-single-buffer
  "y" 'dired-ranger-copy
  "X" 'dired-ranger-move
  "p" 'dired-ranger-paste)

;; Darwin needs ls from coreutils for dired to work
(when (system-is-mac)
  (setq insert-directory-program
    (expand-file-name ".nix-profile/bin/ls" (getenv "HOME"))))

(defun er-delete-file-and-buffer ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (when filename
      (if (vc-backend filename)
          (vc-delete-file filename)
        (progn
          (delete-file filename)
          (message "Deleted file %s" filename)
          (kill-buffer))))))

(global-set-key (kbd "C-c D")  #'er-delete-file-and-buffer)

(use-package org-download)
;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)

(setq backup-directory-alist
      `((".*" . "~/State/.emacs/"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      delete-old-versions t) ; Automatically delete excess backups

(setq auto-save-file-name-transforms
      `((".*" "~/State/.emacs/" t)))
(setq lock-file-name-transforms
      `((".*" "~/State/.emacs/lock-files/" t)))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom
    ((projectile-completion-system 'ivy))
  :bind-keymap
	  ("C-c p" . projectile-command-map)
  :init
    (setq projectile-enable-caching t)
    (setq projectile-switch-project-action #'projectile-dired))
    (when (system-is-linux)
      (setq projectile-project-search-path "/mnt/state/Projects/Code"))
    (when (system-is-mac)
      (setq projectile-project-search-path "/Users/dustin/State/Projects/Code"))

;; Gives me Ivy options in the Projectile menus
(use-package counsel-projectile :after projectile)

(when (system-is-mac)
  (with-eval-after-load "ispell"
    (setq ispell-program-name
      (expand-file-name ".nix-profile/bin/hunspell" (getenv "HOME")))
    (setq ispell-dictionary "en_US")))

(use-package flyspell-correct
  :after flyspell
  :bind (:map flyspell-mode-map ("C-;" . flyspell-correct-wrapper)))

(use-package flyspell-correct-ivy
  :after flyspell-correct)

(add-hook 'git-commit-mode-hook 'turn-on-flyspell)
(add-hook 'text-mode-hook 'flyspell-mode)
;; Disable this for now, doesn't play well with long literate configuration
;; (add-hook 'org-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

(defun spell() (interactive) (flyspell-mode 1))

;; Auto scroll the buffer as we compile
(setq compilation-scroll-output t)

;; By default, eshell doesn't support ANSI colors. Enable them for compilation.
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region (point-min) (point-max))))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

(use-package lsp-mode
  :commands lsp lsp-deferred
  :init
    (setq lsp-keymap-prefix "C-c l")
    (setq lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
    (lsp-ui-doc-position 'bottom))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
        ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
        ("<tab>" . company-indent-or-complete-common))
   :custom
     (company-minimum-prefix-length 1)
     (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

;; bug in emacs https://github.com/emacs-lsp/lsp-mode/issues/2525
;; (setq lsp-headerline-breadcrumb-enable nil)
;; (add-hook 'lsp-mode-hook #'lsp-headerline-breadcrumb-mode)

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
    (require 'lsp-pyright)
    (lsp-deferred))))  ; or lsp-deferred

(add-to-list 'auto-mode-alist '("\\.env" . shell-script-mode))

(use-package yaml-mode
  :commands (markdown-mode gfm-mode)
  :mode (("\\.yml\\'" . yaml-mode)))

;; This uses Github Flavored Markdown for README files
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
    ("\\.md\\'" . markdown-mode)
    ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc"))

(use-package emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook  'emmet-mode)
(define-key emmet-mode-keymap [tab] 'emmet-expand-line)
(add-to-list 'emmet-jsx-major-modes 'jsx-mode)

(use-package rainbow-mode)

(use-package lsp-grammarly)

(use-package go-mode)
(use-package company-go)

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)
(add-hook 'go-mode-hook #'lsp-deferred)

(defun dl/go-mode-hook ()
  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump)
  ;; pop-tag-mark moves back before jump, to undo M-,
  (local-set-key (kbd "M-*") 'pop-tag-mark))
(add-hook 'go-mode-hook 'dl/go-mode-hook)

(use-package pnpm-mode)
(use-package web-mode
  :hook (web-mode . lsp-deferred))

(add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode)) ;; auto-enable for .ts
(add-to-list 'auto-mode-alist '("\\.ts$" . web-mode)) ;; auto-enable for .js/.jsx files
(add-to-list 'auto-mode-alist '("\\.vue\\'" . web-mode))

(defun web-mode-init-hook ()
  "Hooks for Web mode.  Adjust indent."
  (setq web-mode-markup-indent-offset 2))
(add-hook 'web-mode-hook  'web-mode-init-hook)

;; Vue.js / Nuxt.js Language Server
(straight-use-package
 '(lsp-volar :type git :host github :repo "jadestrong/lsp-volar"))
(use-package lsp-volar
  :straight t)

;; React snippets
(load "~/State/Projects/Code/nixos-config/common/snippets/react-snippets/react-snippets.el")

;; Keeps indentation organized across these modes
(use-package prettier-js)
(add-hook 'js2-mode-hook 'prettier-js-mode)
(add-hook 'web-mode-hook 'prettier-js-mode)
(add-hook 'css-mode-hook 'prettier-js-mode)

(use-package magit
  :commands (magit-status magit-get-current-branch))
(define-key magit-hunk-section-map (kbd "RET") 'magit-diff-visit-file-other-window)

(use-package nix-mode
  :mode "\\.nix\\'")

;; This uses dockerfile-mode for Docker files
(use-package dockerfile-mode)
(put 'dockerfile-image-name 'safe-local-variable #'stringp)
(add-to-list 'auto-mode-alist '("\\Dockerfile?$" . dockerfile-mode)) ;; auto-enable for Dockerfiles

(use-package terraform-mode
  :hook (terraform-mode . lsp-deferred))
(add-to-list 'auto-mode-alist '("\\.tf?$'" . terraform-mode))
(add-to-list 'auto-mode-alist '("\\.tf?$'" . terraform-format-on-save-mode))

(with-eval-after-load 'org
  (org-babel-do-load-languages
  'org-babel-load-languages
  '(
    (emacs-lisp . t)
    (python . t)
    (sql . t)
    (shell . t)))
 )

;; (setq org-src-tab-acts-natively nil)
;; (setq org-table-convert-region-max-lines 9999)

(defun dl/babel-ansi ()
  (when-let ((beg (org-babel-where-is-src-block-result nil nil)))
    (save-excursion
      (goto-char beg)
      (when (looking-at org-babel-result-regexp)
        (let ((end (org-babel-result-end))
              (ansi-color-context-region nil))
          (ansi-color-apply-on-region beg end))))))
(add-hook 'org-babel-after-execute-hook 'dl/babel-ansi)

;; Gives me a fancy list of commands I run
(use-package command-log-mode)
(setq global-command-log-mode t)

;; Gives me a fancy list of commands I run
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package helpful
  :custom
    ;; Remap Counsel help functions
    (counsel-describe-function-function #'helpful-callable)
    (counsel-describe-variable-function #'helpful-variable)
  :bind
    ;; Remap default help functions
    ([remap describe-function] . helpful-function)
    ([remap describe-symbol] . helpful-symbol)
    ([remap describe-variable] . helpful-variable)
    ([remap describe-command] . helpful-command)
    ([remap describe-key] . helpful-key))