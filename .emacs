;local stuff
(defalias 'yes-or-no-p 'y-or-n-p)
(defalias 'sniff 'buffer-substring-no-properties)
(tool-bar-mode -1)
(show-paren-mode 1)
(line-number-mode 1)
(column-number-mode 1)
(scroll-bar-mode -1)
(global-hl-line-mode)

(defun copy-whole-buffer ()
  "Copy the whole buffer to the kill ring."
  (interactive)
  (kill-new (buffer-string)))

(global-set-key (kbd "C-c a") 'copy-whole-buffer)

;; ediff from command line
(defun command-line-diff (switch)
  (let ((file1 (pop command-line-args-left))
        (file2 (pop command-line-args-left)))
    (ediff file1 file2)))
(add-to-list 'command-switch-alist '("-diff" . command-line-diff))
;; saner defaults
(setq ediff-diff-options "-w")
(setq ediff-split-window-function 'split-window-horizontally)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; marmalade
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; evil mode
(global-evil-leader-mode) ;; leader mode
(evil-leader/set-leader ",")
(evil-leader/set-key
  "e" 'find-file
  "f" 'find-file
  "b" 'switch-to-buffer
  "k" 'kill-buffer)
(require 'evil)
(evil-mode 1)
(require 'evil-matchit)
(global-evil-matchit-mode 1) ;; matchit mode
(require 'evil-numbers) ;; number increment/decrement mode
(global-set-key (kbd "C-c +") 'evil-numbers/inc-at-pt)
(global-set-key (kbd "C-c -") 'evil-numbers/dec-at-pt)
(require 'evil-visualstar) ;; v text and search with * and #
;; better default states for some modes
(require 'cl)
(loop for (mode . state) in '((inferior-emacs-lisp-mode . emacs)
                              (nrepl-mode . insert)
                              (pylookup-mode . emacs)
                              (comint-mode . normal)
                              (shell-mode . insert)
                              (git-commit-mode . insert)
                              (git-rebase-mode . emacs)
                              (term-mode . emacs)
                              (help-mode . emacs)
                              (helm-grep-mode . emacs)
                              (grep-mode . emacs)
                              (bc-menu-mode . emacs)
                              (magit-branch-manager-mode . emacs)
                              (rdictcc-buffer-mode . emacs)
                              (dired-mode . emacs)
                              (wdired-mode . normal))
      do (evil-set-initial-state mode state))

;; expand region
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
(define-key evil-normal-state-map (kbd "+") 'er/expand-region)

;; ace jump mode
(autoload 'ace-jump-mode "ace-jump-mode" "Emacs quick move minor mode" t)
(global-set-key (kbd "C-c SPC") 'ace-jump-mode)
(define-key evil-normal-state-map (kbd "SPC") 'ace-jump-mode)

;; auto-complete
(require 'auto-complete-config)
(ac-config-default)

;; ido, not helm pleae
(require 'ido)
(ido-mode)
(ido-everywhere 1)
(setq ido-enable-flex-matching t) ;; fuzzy matching
(setq ido-case-fold t) ;; ignore case
(setq ido-auto-merge-work-directories-length -1) ;; search only current dir

;; sbcl + slime
(load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "sbcl")
(setq slime-contribs '(slime-fancy))
;; slime auto complete
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))

;; using zenburn
(load-theme 'zenburn t)

;; magit
(require 'magit)

;; smartparens
(require 'smartparens-config)
(smartparens-global-mode t)
(smartparens-global-strict-mode t) ;; strict as paredit
(setq sp-autoskip-closing-pair 'always) ;; skip to end as paredit
(global-set-key (kbd "C-;") 'sp-up-sexp) ;; move around in a smart way

;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;; smex
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-commands)

;; switch-window
(require 'switch-window)
(evil-leader/set-key "o" 'switch-window)

;; cc mode
(require 'cc-mode)
(setq c-default-style "linux"
      c-basic-offset 4) ;; good indentation defaults
;; one delete will actually delete all whitespace (i.e. hungry)
(add-hook 'c-mode-common-hook '(lambda () (c-toggle-hungry-state 1)))

;; octave mode
;;(autoload 'octave-mode "octave-mode" nil t)
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))

(add-hook 'octave-mode-hook
          (lambda ()
            (abbrev-mode 1)
            (auto-fill-mode 1)
            (if (eq window-system 'x)
                (font-lock-mode 1))))

;; powershell
(add-to-list 'load-path "c:/home/.emacs.d/elpa/powershell")
(autoload 'powershell "powershell" "Run powershell as a shell within emacs" t)

;; python mode
(autoload 'python-mode "python-mode" "Python Mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))

;; spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; VBA
(defun vba-error-test-p (line)
  (string-match "Error\(" line))

(defun vba-handle-line (line)
  (unless (string= line "")
   (goto-char (line-beginning-position))
   (kill-line)
   (let ((error-spot (vba-error-test-p line)))
     (if error-spot
	 (progn
	   (insert "On Error Resume Next\n")
	   (insert "Debug.Print " (substring line 0 (- error-spot 3)) ?\n)
	   (insert "Debug.Assert Err.Number = " (substring line error-spot) ?\n)
	   (insert "On Error GoTo 0"))
       (insert "Debug.Assert " line)))))

(defun vba-build-tests ()
  (interactive)
  (goto-char (point-min))
  (dotimes (i (count-lines (point-min) (point-max)))
    (let ((s (sniff (point) (goto-char (line-end-position)))))
      (vba-handle-line s)
      (forward-char)))
  (goto-char (point-min)))

(defun vba-cleanup ()
  (interactive)
  (goto-char (point-max))
  (insert ?\n)
  (save-excursion
   (let ((to-clean (buffer-string))
	 (start 0))
     (while (string-match "\\(\\w+\\) As \\(\\w+\\)" to-clean start)
       (let ((vba-var (match-string-no-properties 1 to-clean))
	     (vba-type (match-string-no-properties 2 to-clean)))
	 (cond
	  ((string= vba-type "Variant")
	   (insert vba-var " = Empty\n"))
	  ((notany (lambda (x) (string= x vba-type))
		   '("Boolean" "Byte" "Integer" "Long" "Currency"
		     "Single" "Double" "Date" "String"))
	   (insert "Set " vba-var " = Nothing\n")))
	 (setq start (match-end 0))))))
  (kill-backward-chars (1- (point))))

(global-set-key (kbd "C-c t") 'vba-build-tests)
(global-set-key (kbd "C-c c") 'vba-cleanup)
(global-set-key (kbd "C-c e") 'edebug-eval-print-last-sexp)


(defun split-by-5000 ()
  (interactive)
  (goto-char (point-min))
  (let ((file-number 0)
	(base-buf (current-buffer)))
    (while (= 0 (forward-line 5000))
      (incf file-number)
      (with-temp-file (expand-file-name (concat (number-to-string file-number) ".txt"))
	(save-excursion
	  (set-buffer base-buf)
	  (kill-backward-chars (1- (point))))
	(yank)))
    (incf file-number)
    (write-file (expand-file-name (concat (number-to-string file-number) ".txt")))))

; IBM Sites
(defun search-replace (search-regex replacement-string)
  "Searches for regex and replaces it with replacement-string"
  (goto-char (point-min))
  (while (re-search-forward search-regex nil 'noerror)
    (replace-match replacement-string)))


(defun ibm-sites ()
  "Clean-up the CSV export from the ROOM RESERVATION"
  (interactive)
  (goto-char (point-min))
  (search-forward "03-Bratislava - Tower 115")
  (goto-char (line-beginning-position 2))
  (delete-backward-char (- (point) (point-min)))
  (search-forward "04-Bratislava - Apollo Business Center II")
  (goto-char (line-beginning-position))
  (delete-char (- (point-max) (point)))
  (search-replace "\"+" "")
  (search-replace ",\\{2,\\}" ",")
  (search-replace "^,\\|,$" "")
  (goto-char (point-min))
  (let ((room-no (thing-at-point 'word)))
    (delete-region (point) (search-forward "\n"))))

(defun ibm-sites ()
  "Create a normal csv file from the room reservation export"
  (interactive)
  (goto-char (point-min))
  (search-forward "03-Bratislava - Tower 115")
  (let ((new-buf (get-buffer-create "sites.csv"))
	(tower-end
	 (save-excursion (search-forward "04-Bratislava - Apollo Business Center II"))))
    (while (re-search-forward "\\([0-9]+\\).+?\\([0-9]+\\).*(Room)" tower-end t)
      (let ((room-no (match-string 1))
	    (seats (match-string 2))
	    (room-end (save-excursion (re-search-forward "\\([0-9]+\\).+?\\([0-9]+\\).*(Room)"
							 nil t))))
	(while (re-search-forward "\\([0-9]+/[0-9]+/[0-9]+\\)$" room-end t)
	  (let ((saved-date (match-string 1))
		(date-end (save-excursion (re-search-forward "[0-9]+/[0-9]+/[0-9]+" nil t))))
	    (while (re-search-forward
		    "\\([0-9]+?:[0-9]+ \\w+\\)\\W+\\([0-9]+?:[0-9]+ \\w+\\)\\W+\\([- /A-z0-9]+\\)"
		    date-end t)
	      (let ((start-time (save-match-data (normalize-time (match-string 1))))
		    (end-time (save-match-data (normalize-time (match-string 2))))
		    (person (match-string 3)))
		(with-current-buffer new-buf
		  (insert room-no ?, seats ?, saved-date ?,
			  start-time ?, end-time ?, person ?\n))))))))))

(defun normalize-time (time-string)
  "Change AM and PM time to 24h style"
  (interactive)
  (string-match "\\([0-9]+\\):\\([0-9]+\\) \\(\\w+\\)" time-string)
  (let ((hours (match-string 1 time-string))
	(minutes (match-string 2 time-string))
	(am-pm (match-string 3 time-string)))
    (cond
     ((and (string= "12" hours) (string= "AM" am-pm))
      (concat "0:" minutes))
     ((and (not (string= "12" hours)) (string= "PM" am-pm))
      (concat (number-to-string (+ 12 (string-to-number hours))) ":" minutes))
     (t
      (concat hours ":" minutes)))))
