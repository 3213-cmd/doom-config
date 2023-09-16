;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/radian-software/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;(package! builtin-package :recipe (:nonrecursive t))
;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see radian-software/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)
;;
(package! org :pin "17608670a4f4e8edb91efe04d86fe80ff9d01b69")
(package! rainbow-mode)
;; (package! centaur-tabs)
(package! cliphist)
(package! org-journal :disable t)
(package! org-appear)
(package! pretty-hydra)  ;; dependency
(package! org-media-note :recipe (:host github :repo "yuchen-lea/org-media-note"))
(package! solo-jazz-theme :disable t)
(package! heaven-and-hell)
(package! org-super-agenda)
(package! org-ql)
(package! origami)
(package! copilot
  :recipe (:host github :repo "zerolfx/copilot.el" :files ("*.el" "dist")))
(package! org-contacts)
;; Unpin for org-roam-ui
(unpin! org-roam)
(package! org-roam-ui)
(package! kaolin-themes)
(package! nano-theme)
(package! anki-editor
  :recipe (:host github :repo "orgtre/anki-editor" :files ("*.el")))
(package! blamer)
(package! ef-themes)
(package! standard-themes)
(package! vundo)
;; (package! magit-todos :disable t)
