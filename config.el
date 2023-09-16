(add-hook! org-mode 'rainbow-mode)
(add-hook! prog-mode 'rainbow-mode)

(map! :leader
      (:prefix ("e" . "emms")
       :desc "create new playlist" "n" #'emms-metaplaylist-mode-new-buffer
       :desc "kill current playlist and switch to next one"     "k" #'emms-playlist-current-kill
       :desc "set current playlist as active"         "b" #'emms
       :desc "mode to the current playlist"     "m" #'emms-metaplaylist-mode-go
       :desc "pop up current playlist"  "r" #'emms-playlist-mode-go-popup))

(after! emms
  (setq emms-browser-covers 'emms-browser-cache-thumbnail-async
        emms-browser-thumbnail-large-size 512)
  (add-hook 'emms-browser-mode-hook #'emms-browser-display-playlist))

(add-to-list 'display-buffer-alist
             '((lambda (buffer _)
                 (with-current-buffer buffer
                   (seq-some (lambda (mode) (derived-mode-p mode)) '(emms-playlist-mode))))
               (display-buffer-reuse-window display-buffer-below-selected)
               (reusable-frames . visible) (window-height . 0.20)))

(map! :leader
      (:prefix ("k" . "kill-clip")
       :desc "select from clipboard" "V" #'cliphist-paste-item
       :desc "kill to clipboard"     "x" #'clipboard-kill-ring-save
       :desc "select fromm kill ring"         "P" #'+default/yank-pop
       :desc "paste from  to node"     "p" #'evil-paste-after
       :desc "Toggle roam buffer"  "r" #'org-roam-buffer-toggle))

(global-set-key (kbd "M-p") #'yank-from-kill-ring)

(map! :leader
      :desc "open calendar" "o c" #'cfw:open-org-calendar)

(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

(defcustom aj8/buffer-skip-regexp
  (rx bos (or (or "*Backtrace*" "*Compile-Log*" "*Completions*"
                  "*Messages*" "*package*" "*Warnings*"
                  "*Async-native-compile-log*" "irc.libera.chat:6697")
              (seq "magit-diff" (zero-or-more anything))
              (seq "magit-process" (zero-or-more anything))
              (seq "magit-revision" (zero-or-more anything))
              (seq "magit-stash" (zero-or-more anything)))
      eos)
  "Regular expression matching buffers ignored by `next-buffer' and
`previous-buffer'."
  :type 'regexp)

(defun aj8/buffer-skip-p (window buffer bury-or-kill)
  "Return t if BUFFER name matches `aj8/buffer-skip-regexp'."
  (string-match-p aj8/buffer-skip-regexp (buffer-name buffer)))

(setq switch-to-prev-buffer-skip 'aj8/buffer-skip-p)

;; Might try to use 'relative. Relative refers to actual line numbers, visual to those seen on screen.
(setq display-line-numbers-type 'visual)

(after! hl-todo
  (setq hl-todo-keyword-faces '(("TODO" warning bold)
                                ("FIXME" error bold)
                                ("REVIEW" font-lock-keyword-face bold)
                                ("HACK" font-lock-constant-face bold)
                                ("DEPRECATED" font-lock-doc-face bold)
                                ("NOTE" success bold) ("BUG" error bold)
                                ("XXX" font-lock-constant-face bold)
                                ;; CUSTOM
                                ("IDEA" font-lock-doc-face bold)
                                ("KILL" font-lock-keyword-face bold)
                                ("DELETE" font-lock-keyword-face bold)
                                ("!!!" font-lock-keyword-face bold)
                                ("TEMP" font-lock-constant-face bold)
                                ("NEXT" . (:foreground  "RoyalBlue" :weight bold :underline nil) )
                                ("TODOC" warning bold)
                                ("???" warning bold)
                                ("LEARN" warning bold))))

;; By setting an attribute to unspecefied, I can inherit it. Otherwise only unspecified attributes will be overwritten. Could be useful in the future
(after! blamer
  (set-face-attribute 'blamer-face nil :foreground 'unspecified :inherit 'lsp-face-semhl-variable)
  (setq blamer-idle-time 0.3)
  (setq blamer-min-offset 70)
  (setq blamer-show-avatar-p nil)
  (setq blamer-max-commit-message-length 50))


(map! :leader
      :desc "blamer show commit info" "c b" #'blamer-show-commit-info
      :desc "toggle global blamer mode" "c B" #'global-blamer-mode)

(setq doom-font (font-spec :family "Terminus" :size 18 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 18))
;; (setq doom-font (font-spec :family "MonteCarlo Fixed 18" :size 18 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "Fira Sans" :size 18))
;; (setq doom-font (font-spec :family "Fira Code" :size 16 :weight 'semi-light)

;;       doom-variable-pitch-font (font-spec :family "Fira Sans" :size 16 :weight 'light))
;; doom-variable-pitch-font (font-spec :family "Fira Sans" :size 16)

(after! magit-todos
  (setq magit-todos-keywords-list '(;; Custom
                                    "NEXT"
                                    "LEARN"
                                    ;; Doom Default
                                    "KILL"
                                    "DELETE"
                                    "!!!"
                                    "???"
                                    "TODO"
                                    "TODOC"
                                    "FIXME"
                                    "REVIEW"
                                    "HACK"
                                    "TEMP"
                                    "IDEA"
                                    "DEPRECATED"
                                    "BUG"
                                    "XXX")))


(add-hook! prog-mode 'magit-todos-mode)

(after! magit
  (setq magit-log-section-commit-count 30))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org-roam/")
(add-hook 'org-mode-hook  '+org-pretty-mode)

(after! org
  (require 'org-inlinetask)
  (require 'org-habit)
  (add-hook 'org-mode-hook 'toc-org-mode)
  (add-hook 'org-mode-hook 'mixed-pitch-mode)
  (setq org-roam-directory "~/org-roam/"

        org-agenda-files (list "~/org-roam/agenda/"
                               "~/org-roam/work/"
                               "~/org-roam/daily/"
                               "~/org-roam/daily/writing/"
                               "~/org-roam/daily/private/"
                               "~/org-roam/daily/work/"
                               "~/org-roam/personal"
                               "~/org-roam/gtd/inbox.org"
                               "~/org-roam/gtd/gtd.org"
                               "~/org-roam/gtd/someday.org"
                               "~/org-roam/gtd/scheduled.org" )

        org-image-actual-width '(500)
        ;; TODO check if this includes or excluded .gpg files

        org-agenda-file-regexp "\\`[^.].*\\.org\\\(\\.gpg\\\)?\\'"

        org-emphasis-alist '(("*" (bold :inherit 'git-commit-comment-detached ))
                             ("/" (italic :inherit 'git-commit-summary :underline nil ))
                             ("_" underline)
                             ("=" (:inherit 'diff-refine-changed))
                             ("~" (:inherit 'diff-refine-added))
                             ;; ("~" (:background "#83a598" :foreground "MidnightBlue"))
                             ("+" (:strike-through t)))

        org-priority-lowest 68
        org-default-priority 68))

(map!
 :after org-noter
 :map org-noter-doc-mode-map
 "M-i"  'org-noter-insert-precise-note
 "C-M-i" 'org-noter-insert-note)

(after! org-super-agenda
  (setq org-super-agenda-header-properties '(face +org-todo-active org-agenda-structural-header t)
        org-super-agenda-header-separator ""))

;; TODO Learn ORG-QL, remove org-superagenda in the future (posibly)
(add-hook 'org-agenda-mode-hook 'org-super-agenda-mode)

;;(setq org-agenda-files "~/org-roam/")
;;(setq org-agenda-skip-function-global
;;        '(org-agenda-skip-entry-if 'nottodo '("TODO")))

(setq org-habit-show-habits-only-for-today 'nil)
(setq org-agenda-show-future-repeats 'next)

(setq org-agenda-dim-blocked-tasks nil)
(setq org-agenda-skip-function-global
      '(org-agenda-skip-entry-if 'todo '("FIN")))

(setq org-agenda-prefix-format
        '((agenda . "  %i%-15:c%?-12t%-8s")
          (todo . "%s  %i%-15:c % s t: %-5e s: %-5(let ((schedule (org-get-scheduled-time (point)))) (if schedule (format-time-string \"%m-%d\" schedule) \"\")) d: %-5(let ((deadline (org-get-deadline-time (point)))) (if deadline (format-time-string \"%m-%d\" deadline) \"\")) h: %-12t")
          (tags . "  %i%-15:c%?-12t% s")
          (search . "  %i%-15:c%-6e %s")))
  ;; Might need to Adjust in the future

(setq org-agenda-custom-commands
      ;; Create Somdeay view
      ;; Add Email section
      '(("v" "A better agenda view"
         ((tags-todo "inbox"
                     ((org-agenda-overriding-header "\n0. INBOX:\n⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛")
                      (org-agenda-sorting-strategy '(deadline-up))
                      (org-super-agenda-groups '((:auto-parent t)))))
          ;; Skip if Tag Someday
          (todo "NEXT"
                ;;(org-agenda-compact-blocks t)
                ;; Skip if Tag Someday
                (agenda "" ((org-agenda-span 14)
                            (org-agenda-overriding-header "4. CALENDAR:\n⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛\n")
                            ))
                (todo "" (
                          (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottimestamp 'regexp ":habit:" 'todo '("PROJ")))
                          (org-agenda-sorting-strategy '(deadline-up) )
                          (org-agenda-overriding-header "")
                          (org-super-agenda-groups '((:name "All scheduled tasks" :todo t)))))
                ;;(org-agenda-compact-blocks t)
                (todo "" ((org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp ":habit:"))
                          (org-agenda-overriding-header "")
                          (org-agenda-sorting-strategy '(deadline-up))
                          (org-super-agenda-groups '((:habit t)))))
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'regexp ":finished"))
                 (org-agenda-overriding-header "1. NEXT:\n⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛")
                 (org-agenda-sorting-strategy '(deadline-up priority-up) )
                 (org-super-agenda-groups '((:discard (:tag ("someday")))(:auto-group t)))))
          (todo "MAIL" ((org-agenda-skip-function '(org-agenda-skip-entry-if 'regexp ":finished"))
                        (org-agenda-overriding-header "2. Mail:\n⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛")
                        (org-agenda-sorting-strategy '(deadline-up priority-up) )
                        (org-super-agenda-groups '((:discard (:tag ("someday")))(:auto-group t)))))
          ;; Skip if Tag Someday
          (todo "WAIT|MAYB|CLAR|HOLD" ((org-agenda-skip-function '(org-agenda-skip-entry-if 'regexp ":finished"))
                                       (org-agenda-overriding-header "3. WAIT:\n⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛")
                                       (org-agenda-sorting-strategy '(deadline-up priority-up) )
                                       (org-super-agenda-groups '((:discard (:tag ("someday")))(:auto-group t)))))
          (tags-todo "-someday" ((org-agenda-sorting-strategy '((agenda habit-down time-up priority-down category-keep)
                                                                (todo category-up priority-down category-keep)
                                                                (tags category-up tag-up todo-state-up priority-down category-keep)
                                                                (search category-keep)))
                                 (org-agenda-overriding-header "\n3. Group View VIEW:\n⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛⃛")
                                 (org-super-agenda-groups '((:auto-group t)))))))
          ;; (org-ql-block '(todo "PROJ"))
        ("s" "someday" ((todo "" ((org-agenda-overriding-header "My Projetcs:")
                                  (org-super-agenda-groups '((:name "All someday entries") (:discard (:not (:tag ("someday")))) (:auto-group t)))))))
        ("p" "projects" ((todo "PROJ" ((org-agenda-overriding-header "My Projetcs:")))))))

(setq org-todo-keywords '((sequence
                            "PROJ(p)" "TODO(t)" "LOOP(r)"
                            "STRT(s)" "WAIT(w)" "HOLD(h)"
                            "IDEA(i)" "CLAR(c)" "MAYB(m)"
                            "NEXT(n)" "MAIL(e)" "|"
                            "DONE(d)" "KILL(k)" "FIN(f)")
                            (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[X](D)")
                            (sequence "|" "OKAY(o)" "YES(y)" "NO(n)")
                            (sequence "READING(R)" "PAUSED(P)" "|"))
    org-todo-keyword-faces '(("[-]" . +org-todo-active) ("STRT" . +org-todo-active)
                             ("[?]" . +org-todo-onhold) ("WAIT" . +org-todo-onhold)
                             ("MAYB" . +org-todo-onhold) ("CLAR" . +org-todo-onhold)
                             ("HOLD" . +org-todo-onhold) ("PROJ" . +org-todo-project)
                             ("NO" . +org-todo-cancel) ("KILL" . +org-todo-cancel)
                             ;; ("SPRJ" . +org-todo-project)
                             ("NEXT" . (:foreground  "RoyalBlue" :weight bold :underline t))
                             ("MAIL" . (:foreground  "RoyalBlue" :weight bold :underline t))))

(after! deft
  (setq deft-directory "~/org-roam/"
        deft-recursive t
        deft-extensions '("tex" "txt" "text" "md" "markdown" "org" "gpg"))
  (defun cf/deft-parse-title (file contents)
      "Parse the given FILE and CONTENTS and determine the title.
    If `deft-use-filename-as-title' is nil, the title is taken to
    be the first non-empty line of the FILE.  Else the base name of the FILE is
    used as title."
      (let ((begin (string-match "^#\\+[tT][iI][tT][lL][eE]: .*$" contents)))
        (if begin (string-trim (substring contents begin (match-end 0)) "#\\+[tT][iI][tT][lL][eE]: *" "[\n\t ]+")
          (deft-base-filename file))))
        (advice-add 'deft-parse-title :override #'cf/deft-parse-title)
        (setq deft-strip-summary-regexp
          (concat "\\("
                  "[\n\t]" ;; blank
                  "\\|^#\\+[[:alpha:]_]+:.*$" ;; org-mode metadata
                  "\\|^:PROPERTIES:\n\\(.+\n\\)+:END:\n" ;; org-roam ID
                  "\\|\\[\\[\\(.*\\]\\)" ;; any link
                  "\\)")))

(setq org-capture-templates '(("t" "Todo [inbox]" entry
                                 (file+headline "~/org-roam/gtd/inbox.org" "Tasks")
                                 "* TODO %i%?")
                                ("T" "Scheduled Entries" entry
                                 (file+headline "~/org-roam/gtd/scheduled.org" "Scheduled Tasks")
                                 "* %i%? \n %U"))
      org-refile-targets '(("~/org-roam/gtd/inbox.org" :level . 1)
                             ("~/org-roam/gtd/gtd.org" :maxlevel . 3)
                             ("~/org-roam/gtd/someday.org" :maxlevel . 3)
                             ("~/org-roam/gtd/scheduled.org" :maxlevel . 2)))

(setq org-roam-capture-templates
      '(("a" "agenda" plain "%?"
         :target (file+head "agenda/${slug}.org"
                            "#+title: ${title}\n#+category: ${title}\n") :unnarrowed t)
        ("d" "default" plain "%?"
         :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n#+category: default\n") :unnarrowed t)
        ("l" "learning")
        ("ll" "languages")
        ("llk" "korean" plain "%?"
         :target (file+head "learning/languages/korean/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+filetags: :korean:\n#+title: ${title}\n#+category: korean\n") :unnarrowed t)
        ("llr" "russian" plain "%?"
         :target (file+head "learning/languages/russian/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+filetags: :russian:\n#+title: ${title}\n#+category: russian\n") :unnarrowed t)
        ("llr" "english" plain "%?"
         :target (file+head "learning/languages/english/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+filetags: :english:\n#+title: ${title}\n#+category: english\n") :unnarrowed t)
        ("llg" "german" plain "%?"
         :target (file+head "learning/languages/german/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+filetags: :german:\n#+title: ${title}\n#+category: german\n") :unnarrowed t)
        ("lm" "math & logic" plain "%?"
         :target (file+head "learning/math/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+filetags: :math:\n#+title: ${title}\n#+category: math\n") :unnarrowed t)
        ("lp" "philosophy" plain "%?"
         :target (file+head "learning/philosophy/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+filetags: :philosophy:\n#+title: ${title}\n#+category: philosophy\n") :unnarrowed t)
        ("p" "programming")
        ("pc" "clojure" plain "%?"
         :target (file+head "programming/clojure/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+filetags: :clojure:\n#+title: ${title}\n#+category: programming\n") :unnarrowed t)
        ("pe" "elixir" plain "%?"
         :target (file+head "programming/elixir/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+filetags: :elixir:\n#+title: ${title}\n#+category: programming\n") :unnarrowed t)
        ("pg" "general" plain "%?"
         :target (file+head "programming/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n#+category: programming\n") :unnarrowed t)
        ("pp" "python" plain "%?"
         :target (file+head "programming/python/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+filetags: :python:\n#+title: ${title}\n#+category: programming\n") :unnarrowed t)
        ("pr" "rust" plain "%?"
         :target (file+head "programming/rust/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+filetags: :rust:\n#+title: ${title}\n#+category: programming\n") :unnarrowed t)
        ("w" "work" plain "%?"
         :target (file+head "work/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n#+category: work\n") :unnarrowed t)
        ("P" "personal")
        ("Pp" "personal notes" plain "%?"
         :target (file+head "personal/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n#+category: personal\n") :unnarrowed t)
        ("Pm" "movies" plain "%?"
         :target (file+head "personal/movies/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+filetags: :movies:\n#+title: ${title}\n#+category: movies\n") :unnarrowed t)
        ("Pr" "reading" plain "%?"
         :target (file+head "personal/reading/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+filetags: :reading:\n#+title: ${title}\n#+category: reading\n") :unnarrowed t)
        ("A" "aws" plain "%?"
         :target (file+head "aws/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n#+category: aws\n") :unnarrowed t)))

(after! org-roam-dailies
  (setq org-roam-dailies-capture-templates
        '(("p" "private")
          ("pp" "private notes" entry
           "* %?"
           :target (file+datetree "private/journal.org" week))
          ("pw" "writing" entry
           "* %?"
           :target (file+datetree "writing/writing.org" months))
          ("w" "work" entry
           "* %?"
           :target (file+datetree "work/%<%Y>work.org"  week )))))
;;           :target (file+datetree "journal.org.gpg" week)))))

(defun my/org-pomodoro-restart ()
  (interactive)
  (let ((use-dialog-box nil))
    (when (y-or-n-p "Start a new pomodoro?")
      (save-window-excursion
        (org-clock-goto)
        (org-pomodoro)))))

(add-hook 'org-pomodoro-break-finished-hook 'my/org-pomodoro-restart)


(after! org-pomodoro
  (setq org-pomodoro-finished-sound "~/.config/doom/sounds/pomodoro1.wav"
   org-pomodoro-short-break-sound "~/.config/doom/sounds/pomodoro1.wav"
   org-pomodoro-long-break-sound "~/.config/doom/sounds/pomodoro1.wav"
   org-pomodoro-start-sound "~/.config/doom/sounds/pomodoro1.wav"))

(use-package! org-media-note
  :hook (org-mode .  org-media-note-mode)
  :bind (("H-v" . org-media-note-hydra/body)) ;; Main entrance
  :config
  ;; Folder to save screenshot
  (setq org-media-note-screenshot-image-dir "~/org-roam/imgs/"))

(map! :leader
      :desc "open org-media-note" "e v" #'org-media-note-hydra/body)

(after! org-superstar
  (set-face-attribute 'org-superstar-header-bullet nil :font "DejaVu Sans Mono"))

(after! org-download
  (setq org-download-screenshot-method "flameshot gui --raw > %s" ))

(add-hook 'org-mode-hook  'org-appear-mode)
(setq org-appear-autolinks t
      org-appear-autoentities t
      org-appear-autosubmarkers t
      org-appear-autoemphasis t
      org-appear-delay 0.7)

(after! org-fancy-priorities
 (setq
  org-fancy-priorities-list '("[A]" "[B]" "[C]" "[D]")
  ;; org-fancy-priorities-list '("❗" "[B]" "[C]")
  ;;org-fancy-priorities-list '("🟥" "🟧" "🟨")
  org-priority-faces '((?A :foreground "#ff6c6b" :weight bold)
                       (?B :foreground "#98be65" :weight bold)
                       (?C :foreground "#c678dd" :weight bold)
                       (?D :foreground "#78ddc6" :weight bold))
  org-agenda-block-separator 8411))

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking org-roam-ui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

;; (setq projectile-ignored-projects '("/home/user/"))

(setq doom-modeline-persp-name t )
        (after! persp-mode
          (setq persp-emacsclient-init-frame-behaviour-override "main"))

;; Associate file extension with a mode
 (add-to-list 'auto-mode-alist '("\\.razor\\'" . web-mode))

;; (use-package! copilot
;;   ;; :hook (prog-mode . copilot-mode)
;;   :bind (:map copilot-completion-map
;;               ("<tab>" . 'copilot-accept-completion)
;;               ("TAB" . 'copilot-accept-completion)
;;               ("C-TAB" . 'copilot-accept-completion-by-word)
;;               ("C-<tab>" . 'copilot-accept-completion-by-word)))

(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)

(map! :after lispy
      :map lispy-mode-map
      :leader
      :prefix ("ml" . "lispy")
      :desc "sp wrap round" "(" #'sp-wrap-round
      :desc "sp wrap square " "[" #'sp-wrap-square
      :desc "sp wrap curly" "{" #'sp-wrap-curly
      :desc "lispy-down" "j" #'lispy-down
      :desc "lispy-up" "k" #'lispy-up)

(map!
 :after lispy
 :map lispy-mode-map
 :desc "lispy-kill-setence" "ð" #'lispy-kill-sentence
 ;; Alt-GR d us.int keyboard layout
                )

(after! dap-mode
  (setq dap-python-debugger 'debugpy))

(map! :map dap-mode-map
      :leader
      :prefix ("d" . "dap")
      ;; basics
      :desc "dap next"          "n" #'dap-next
      :desc "dap step in"       "i" #'dap-step-in
      :desc "dap step out"      "o" #'dap-step-out
      :desc "dap continue"      "c" #'dap-continue
      :desc "dap hydra"         "h" #'dap-hydra
      :desc "dap debug restart" "r" #'dap-debug-restart
      :desc "dap debug"         "s" #'dap-debug

      ;; debug
      :prefix ("dd" . "Debug")
      :desc "dap debug recent"  "r" #'dap-debug-recent
      :desc "dap debug last"    "l" #'dap-debug-last

      ;; eval
      :prefix ("de" . "Eval")
      :desc "eval"                "e" #'dap-eval
      :desc "eval region"         "r" #'dap-eval-region
      :desc "eval thing at point" "s" #'dap-eval-thing-at-point
      :desc "add expression"      "a" #'dap-ui-expressions-add
      :desc "remove expression"   "d" #'dap-ui-expressions-remove

      :prefix ("db" . "Breakpoint")
      :desc "dap breakpoint toggle"      "b" #'dap-breakpoint-toggle
      :desc "dap breakpoint condition"   "c" #'dap-breakpoint-condition
      :desc "dap breakpoint hit count"   "h" #'dap-breakpoint-hit-condition
      :desc "dap breakpoint log message" "l" #'dap-breakpoint-log-message)

;; Not sure if needed
(evil-set-initial-state 'rustic-popup-mode 'emacs)

(setq doom-theme 'modus-vivendi)

(after! heaven-and-hell
  (setq heaven-and-hell-themes
        '((light . doom-gruvbox)
          ;; (dark . doom-tokyo-night)
          (dark . modus-vivendi)
          ))
  ;; Optionall, load themes without asking for confirmation.
  (setq heaven-and-hell-load-theme-no-confirm t)
  (map!
   :g "<f6>" 'heaven-and-hell-toggle-theme
   ;; Sometimes loading default theme is broken. I couldn't figured that out yet.
   :leader "<f6>" 'heaven-and-hell-load-default-theme))

(add-hook 'after-init-hook 'heaven-and-hell-init-hook)

(map!
 :map sqlite-mode-map
 :localleader
 ;; <localleader> x will invoke the dosomething command
 "d" #'sqlite-mode-list-data
 "t" #'sqlite-mode-list-tables
 "c" #'sqlite-mode-list-columns
 "D" #'sqlite-mode-delete)

(map! :leader
      ;; :desc "Toggle tabs globally" "t C" #'centaur-tabs-mode
      :desc "Toggle tabs local display" "t c" #'centaur-tabs-local-mode
      :desc "Toggle tab-bar globally"   "t C" #'tab-bar-mode)

(map!
 :after evil
 :map global-map
 "<C-next>" 'centaur-tabs-forward-tab
 "<C-M-next>" 'centaur-tabs-forward-group
 "<C-prior>" 'centaur-tabs-backward-tab
 "<C-M-prior>" 'centaur-tabs-backward-group
 "<C-S-prior>" 'centaur-tabs-move-current-tab-to-left
 "<C-S-next>" 'centaur-tabs-move-current-tab-to-right
 "<C-S-M-prior>" 'tab-bar-switch-to-prev-tab
 "<C-S-M-next>" 'tab-bar-switch-to-next-tab)

(after! centaur-tabs
  (setq
   centaur-tabs-cycle-scope 'tabs
   centaur-tabs-set-bar 'over
   centaur-tabs-set-icons t
   centaur-tabs-set-icons 'nil
   centaur-tabs-gray-out-icons 'buffer
   ;; centaur-tabs-height 10
   ;; centaur-tabs-bar-height 10
   centaur-tabs-set-modified-marker t
   centaur-tabs-style "wave"
   centaur-tabs-modified-marker "•"
   centaur-tabs-excluded-prefixes '(
    "*Messages*""*scratch" "*doom"
    "*epc" "*helm" "*Helm"
    " *which" "*Compile-Log*" "*lsp"
    "*LSP" "*company" "*Flycheck"
    "*Ediff" "*ediff" "*tramp"
    " *Mini" "*help" "*straight"
    " *temp" "*Help" "irc.libera.chat:6697"))
  (centaur-tabs-change-fonts "Terminus" 50)
  (centaur-tabs-group-by-projectile-project))

;; (setq-default indent-tabs-mode nil)
(setq backward-delete-char-untabify-method nil)
(setq-default tab-width 4)
(setq-default tab-stop-list (list 4 8 12))

(after! pdf-view
  (setq pdf-view-resize-factor 1.05))

(after! ranger
  (setq ranger-show-hidden 'format))

(after! evil
  (evil-ex-define-cmd "q" 'kill-this-buffer)
  (evil-ex-define-cmd "wq" 'save-and-kill-this-buffer)
  ;; Need to type out :quit to close emacs
  (evil-ex-define-cmd "quit" 'kill-buffer-and-window))

(map!
 :after evil
 :map evil-window-map
 "C-h" 'which-key-show-next-page-cycle)

;; (setq undo-fu-session-global-mode nil)
;; g u to lowercase, let's see if this works for me.
(map! :after evil
      :map evil-visual-state-map
      "u" #'evil-undo)
(after! evil
  (setq evil-undo-system 'undo-redo
        evil-undo-function 'undo-only
        evil-redo-function 'undo-redo))

(add-hook 'treemacs-mode-hook (lambda () (text-scale-decrease 1)))
(setq doom-themes-treemacs-enable-variable-pitch nil
 treemacs-width 30
 treemacs--width-is-locked nil
 treemacs-width-is-initially-locked nil)

(after! lsp-ui
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-show-with-mouse t)
  (setq lsp-ui-doc-max-height 500)
  (setq lsp-ui-doc-max-width 500))
