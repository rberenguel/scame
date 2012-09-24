; For now, "magic" does all the magic. Which is not a lot, currently.
; If we are in a TeX buffer, checks for file at point or region and
; tries to open it as is or by appending .tex (in this order.) If we
; are in a TeX output file, we look for the previous instance of .tex,
; which points to the last problematic file... in a multifile
; document, at least. This is a hack: may not work with single file
; LaTeXs. Caveat emptor

(defun magic ()
  (interactive)
  (if (string-match "output" (buffer-name))
      (undefy)
    (progn 
      (if (not (region-active-p))
	  (file-at-point))
      (setq atpoint.filename (buffer-substring-no-properties (region-beginning) (region-end)))
      (if (file-exists-p atpoint.filename)
	  (open-it atpoint.filename)
	(if (string= (substring buffer-file-name -4) ".tex")
	    (progn (setq atpoint.filename (concat atpoint.filename ".tex"))
		   (if (file-exists-p atpoint.filename)
		       (open-it atpoint.filename)
		     ))))
      )))
  


(defun open-it (filename)
  (interactive)
  (progn
    (find-file filename)
    )
  )
; ls file

(defun to-execute ()
  (interactive)
  (if (not (region-active-p))
      (file-at-point))
  (setq atpoint.filename (buffer-substring-no-properties (region-beginning) (region-end)))
  (message "%s" (to-execute-p atpoint.filename)))

(defun to-execute-p (arg)
  ; region->space?->executable
  
  (if (string-match " " arg)
      t
    nil))

; Usant sexp com a boundary agafa filenames amb punt i coses a includes de .tex

(defun exec-at-point (arg)
  (interactive "p")
  (progn
    (if (not (region-active-p))
	(file-at-point))
    (setq atpoint.filename (buffer-substring-no-properties (region-beginning) (region-end)))
    (message "%s" atpoint.filename)
    (shell-command atpoint.filename)
    )
  )


(defun file-at-point ()
  (interactive)
  (setq default (thing-at-point 'sexp))
  (setq bds (bounds-of-thing-at-point 'sexp))
  (setq p1 (car bds))
  (setq p2 (cdr bds))
  (set-mark p1)
  (goto-char p2)
)

(defun number-at-point ()
  (interactive)
  (setq default (thing-at-point 'word))
  (setq bds (bounds-of-thing-at-point 'word))
  (setq p1 (car bds))
  (setq p2 (cdr bds))
  (set-mark p1)
  (goto-char p2)
)

(defun undefy ()
  (interactive)
  (progn
    (if (not (region-active-p))
	(number-at-point))
    (setq atpoint.linenum (buffer-substring-no-properties (region-beginning) (region-end)))
    (message "Hey! %s" atpoint.linenum)
    (message "Hey! %s" (region-beginning))
    (message "Hey! %s" (region-end))
    (re-search-backward "\\.tex")
    (file-at-point)
    (setq atpoint.filename (buffer-substring-no-properties (region-beginning) (region-end)))
    (setq atpoint.filename (concat default-directory atpoint.filename ".tex"))
    (setq atpoint.filename (replace-regexp-in-string "//" "/" atpoint.filename))
    (message "%s" atpoint.filename)
    (if (file-exists-p atpoint.filename)
	(progn (open-it atpoint.filename)
	       (jumpy (string-to-number atpoint.linenum))))))
  
(defun jumpy (linenum)
  (goto-line linenum)
)
