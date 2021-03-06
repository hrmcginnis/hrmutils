#!/usr/bin/emacs --script
;;
;; ELISP_EXPORT_TODOS - Export last week's completed todos to file
;;

(setq org-agenda-files '("~/org" "~/Dropbox/org"))
(setq org-agenda-custom-commands
      '(("w" agenda ""
	 ((org-agenda-span 14)
      (org-agenda-start-on-weekday -7)
	  (org-agenda-start-with-log-mode t)
	  (org-agenda-skip-function
	   '(org-agenda-skip-entry-if 'notregexp ".*DONE.*:mdt:")))
	 ("~/status/done.txt"))))

(org-store-agenda-views)

