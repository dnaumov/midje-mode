(require 'clojure-mode)
(require 'clojure-test-mode)

(defvar midje-root nil)
(defvar midje-filename-stash '())
(global-set-key "\^hj" 'midje-visit-source)    

(defun midje-root (here)
  "Set the root directory that."
  (interactive "DProject Root Directory: ")
  ;; This wants to work in all buffers (or all shell buffers)?
  (setq midje-root (expand-file-name here))
  (setq midje-filename-stash '()))

(defun clojure-midje-test-for (namespace)
  "Returns the path of the test file for the given namespace."
  (let* ((namespace (clojure-underscores-for-hyphens namespace))
         (path (butlast (split-string "tdd_practice.core" "\\.")))
         (filename (concat "t_" (car (last (split-string namespace "\\."))))))
    (format "%stest/%s.clj"
            (file-name-as-directory
             (locate-dominating-file buffer-file-name "src/"))
            (mapconcat 'identity (append path (list filename)) "/"))))

(defun clojure-midje-implementation-for (namespace)
  "Returns the path of the src file for the given test namespace."
  (let* ((namespace (clojure-underscores-for-hyphens namespace))
         (segments (split-string namespace "\\."))
         (namespace-end (split-string (car (last segments)) "_"))
         (filename (mapconcat 'identity (cdr namespace-end) "_"))
         (impl-segments (append (butlast segments 1) (list filename))))
    (format "%s/src/%s.clj"
            (locate-dominating-file buffer-file-name "src/")
            (mapconcat 'identity impl-segments "/"))))

(setq clojure-test-implementation-for-fn 'clojure-midje-implementation-for)

(setq clojure-test-for-fn 'clojure-midje-test-for)

(defun midje-visit-source ()
  "If the current line contains text like '../src/program.clj:34', visit 
that file in the other window and position point on that line."
  (interactive)
  (unless midje-root (call-interactively #'midje-root))
  (let* ((start-boundary (save-excursion (beginning-of-line) (point)))
         (regexp (concat "\\([ \t\n\r\"'([<{]\\|^\\)" ; non file chars or
                                                      ; effective
                                                      ; beginning of file  
                         "\\(.+\\.clj\\):\\([0-9]+\\)" ; file.rb:NNN
			 "\\(\\+[0-9]\\)?"
			 )) 
         (matchp (save-excursion
                  (end-of-line)
                  ;; if two matches on line, the second is most likely
                  ;; to be useful, so search backward.
                  (re-search-backward regexp start-boundary t))))

    (if matchp
	(let ((file (midje-match-part 2))
	      (line (midje-match-part 3))
	      (increment (midje-match-part 4)))
	  (midje-goto file line increment))
      (error "No Clojure location on line."))))



(defun midje-reload-filename-stash (dir)
  (setq midje-filename-stash
	(split-string
	 (shell-command-to-string
	  (concat "find "
		  (shell-quote-argument dir)
		  " -name "
		  (shell-quote-argument "*.clj")
		  " -print "))))
  nil)

(defun midje-matching-file (file)
  (message (concat "Looking for this file: " file))
  (let* ((regexp (concat "/" file "$")))
    (find-if (lambda (fullpath) (string-match regexp fullpath))
	     midje-filename-stash))
)

(defun midje-goto (file line increment)
  (let ((relevant-file (or (midje-matching-file file)
			   (midje-reload-filename-stash midje-root)
			   (midje-matching-file file))))
    (message (concat "relevant file is " relevant-file))
    (message increment)
    (if (not relevant-file) 
	(error (concat "No Clojure file matches " file))
      (find-file-other-window relevant-file)
      (goto-line (string-to-int line))
      (if increment 
	  (search-forward "=>" nil nil (string-to-int increment)))))
)

(defun midje-match-part (n)
  (if (match-beginning n)
      (buffer-substring (match-beginning n) (match-end n))
    nil))

(provide 'clojure-jump-to-file)
