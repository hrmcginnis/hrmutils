;;; init-use-package.el --- Emacs Init File - use-package declarations

;;; Commentary:
;;    Emacs Initialization with use-package

;;; Code:

(require 'package)

(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))
(package-initialize)


;; Add paths
;;
(let ((default-directory "~/.emacs.d/elpa"))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))


;; Enable use-package
;;
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(require 'bind-key)


;; Package Install ---------------------------------------------------------- ;;

;; Diminish
;;
(use-package diminish
  :ensure t)


;; Automatically update packages
;;
(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t
        auto-package-update-hide-results t
        auto-package-update-interval 7
        auto-package-update-prompt-before-update nil)
  (auto-package-update-maybe))


;; Helm
;;
(use-package helm
  :ensure t
  :bind (("M-x" . helm-M-x)
         ("C-x M-r" . helm-all-the-things)
         ("C-x C-r" . helm-for-files))
  :init (require 'helm-config)
  :config
  (setq helm-lisp-fuzzy-completion t)
  (defun helm-all-the-things ()
    (interactive)
    (helm :sources '(helm-source-locate
                     helm-source-buffers-list
                     helm-source-recentf)
	  :fuzzy-match t
          :buffer "*helm all the things*")))


;; Speedbar
;;
(use-package sr-speedbar
  :ensure t
  :bind ("<f10>" . sr-speedbar-toggle))


;; Adaptive Wrap
;;
(use-package adaptive-wrap
  :ensure t)


;; Neotree mode
;;
(use-package neotree
  :ensure t
  ;; :bind ("<f8>" . neotree-toggle)
  :hook (neo-after-create . text-scale-decrease)
  :config
  (setq neo-smart-open t)
  (setq neo-theme 'ascii))


;; Transpose frame
;;
(use-package transpose-frame
  :ensure t
  :bind ("C-x t" . transpose-frame))


;; Flyspell mode
;;
(use-package flyspell
  :ensure t
  :bind (("C-<f9>" . flyspell-check-next-highlighted-word)
         ("M-<f9>" . flyspell-check-previous-highlighted-word))
  :hook ((c++-mode . flyspell-prog)
         (text-mode . flyspell-mode)
         (org-mode . flyspell-mode))
  :config
  (defun flyspell-check-next-highlighted-word ()
    "Custom function to spell check next highlighted word"
    (interactive)
    (flyspell-goto-next-error)
    (ispell-word)))


;; Company mode
;;
(use-package company
  :ensure t
  :diminish company-mode
  :bind ("C-<tab>" . company-complete)
  :hook (;(after-init . global-company-mode)
         (c++-mode . company-mode)
         (c-mode . company-mode)
         (emacs-lisp-mode . company-mode)))
;; :config
;; (defvaralias 'c-basic-offset 'tab-width)
;; (defvaralias 'cperl-indent-level 'tab-width)

;; Company Irony
(use-package company-irony
  :ensure t
  :config
  (eval-after-load 'company
    '(add-to-list 'company-backends 'company-irony)))
;; Company C Headers

(use-package company-c-headers
  :ensure t
  :config
  (eval-after-load 'company
    '(add-to-list 'company-backends 'company-c-headers)))


;; Irony mode
;;
(use-package irony
  :ensure t
  :hook ((c-mode . irony-mode)
         (c++-mode . irony-mode)
         (objc-mode . irony-mode)
         (irony-mode . irony-cdb-autosetup-compile-options)))


;; Flycheck Irony mode
;;
(use-package flycheck-irony
  :ensure t
  :requires irony)


;; Flycheck mode
;;
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :hook (flycheck-mode . flycheck-irony-setup)
  :bind (("C-<f9>" . flycheck-next-error)
         ("M-<f9>" . flycheck-previous-error)))
  ;; :config
  ;; (eval-after-load 'flycheck
  ;;   '(require 'flycheck-matlab-mlint)))


;; Smooth scrolling mode
;;
(use-package smooth-scrolling
  :ensure t
  :config
  (smooth-scrolling-mode 1)
  (setq smooth-scroll-margin 15)
  (setq scroll-preserve-screen-position 1))


;; Org mode
;;
(use-package org
  :ensure t
  :bind (("C-c c" . org-capture)
         ("C-c a" . org-agenda)
         ("C-c m" . (lambda () (interactive) (org-capture nil "m")))
         ("C-c g" . (lambda () (interactive) (org-capture nil "g")))
         ("C-c t" . (lambda () (interactive) (org-capture nil "t"))))
  :hook ((org-mode . turn-on-visual-line-mode))
  :init
  (setq org-todos-file "~/org/todos.org"
        org-mitg-file "~/org/mitg.org"
        org-gl-file "~/org/gl.org"
        org-log-done 'time
        org-agenda-files '("~/org"))
  (setq org-capture-templates
        '(("m" "Meeting" entry (file+olp+datetree org-mitg-file)
           "* %?\n \n" :kill-buffer t)
          ("g" "GL Meeting" entry (file+olp+datetree org-gl-file)
           "* %?\n \n" :kill-buffer t)
          ("t" "todo" entry (file+headline org-todos-file)
           "* TODO %u%? [/]\n" :kill-buffer t)))
  (setq org-todo-keywords
        '((sequence "TODO" "IN PROGRESS" "?" "|" "DONE" "CANCELED")
          (sequence "QUESTION" "DEFECT" "|" "FILED" "RESOLVED")))
  (setq org-agenda-custom-commands
        '(("w" "Completed TODOs this week" agenda ""
           ((org-agenda-span 7)
            (org-agenda-start-with-log-mode t)
            (org-agenda-skip-function
             '(org-agenda-skip-entry-if 'notregexp ".*DONE.*:mdt:")))
           ("~/status/done.txt"))))
  :config
  ;; Org mode JIRA export
  ;;
  (use-package ox-jira
    :ensure t
    :requires org)
  
  ;; Org-bullets mode
  ;;
  (use-package org-bullets
    :ensure t
    :requires org
    :diminish))


;; Systemd Unit mode
;;
(use-package systemd
  :ensure t)


;; JSON mode
;;
(use-package js
  :mode "\\.json$"
  :interpreter "js"
  :ensure t)


;; MATLAB mode
;;
(use-package matlab
  :mode ("\\.m$" . matlab-mode)
  :hook ((matlab-mode . (lambda () (matlab-cedet-setup)))
         (matlab-mode . (lambda () (mlint-minor-mode t))))
  :init
  ;; (add-to-list 'load-path "~/.emacs.d/elpa/manual_install/")
  ;; (load "flycheck-matlab-mlint")
  :config
  (setq matlab-indent-function t
        matlab-show-mlint-warnings t
        matlab-shell-command "matlab"
        matlab-shell-command-switches
        (list "-nosplash" "-nodesktop"))
  (autoload 'mlint-minor-mode "mlint" nil t))


;; Sudo edit mode
;;
(use-package sudo-edit
  :ensure t
  :bind ("C-c C-r" . sudo-edit))


;; CMake modes
;;
(use-package cmake-font-lock
  :ensure t
  :hook (cmake-mode . cmake-font-lock-activate)
  :config (autoload 'cmake-font-lock-activate "cmake-font-lock" nil t))

(use-package cmake-mode
  :ensure t)

(use-package cmake-ide
  :ensure t
  :config (cmake-ide-setup))


(provide 'my-use-package)
;;; my-use-package ends here
