;; Package for reviewing gerrit comment inside emacs

;; Author: Sebastian Nirvin

(message "Loading gerrit.el...")

(defun get-gerrit-comments ()
  "Function for fetching gerrit comments from the latest log

Main entry point"
  (interactive)
  (gerrit-getter--request-comments "I2be2a5c392830a1d3ddd84aa8ac592ed0c4101e1")
  (gerrit-getter--parse-comment-positions)
  )

(setq gerrit-getter-response-buffer-name "*gerrit log*")

(defun gerrit-getter--request-comments (change)
  "Fetch the comments from Gerrit with an SSH command"

  (let ((process-name "gerrit-get")
        (process-connection-type nil))

    (ignore-error error (kill-buffer gerrit-getter-response-buffer-name))
    (get-buffer-create gerrit-getter-response-buffer-name)
    (call-process "ssh" nil gerrit-getter-response-buffer-name nil
                  "-p 29418"
                  "review.hms.se"
                  "gerrit"
                  "query"
                  "--patch-sets"
                  "--format=JSON"
                  "--comments"
                  (format "change: %s" change)
                  )
    )
  )

(defun gerrit-getter--parse-json ()
  "Function for getting the json data into an Emacs data type

Not yet used but should probably conatin these lines"
  (goto-char (point-max))
  (delete-region (+ (search-backward "}") 1) (point-max))
    (goto-char (point-min))
    (returned-json (json-parse-buffer :object-type 'alist))
    )

(defun gerrit-getter--parse-comments ()
  "Function for getting the comments from the parsed json"

  )


(defun gerrit-getter--parse-comment-positions ()
  "Function for extracting the position of the comments"

  (with-current-buffer gerrit-getter-response-buffer-name
    ;; TODO
    ;; - Figure out what values to pick out
    ;; - Figure out how to put them in a buffer, take insperation from somewhere?
    ;; (json-pretty-print-buffer)
    (goto-char (point-max))
    (delete-region (+ (search-backward "}") 1) (point-max))
    (goto-char (point-min))
    (let ((returned-json (json-parse-buffer :object-type 'alist)))

      ;; loopable values              x                        x
      ;;                             |                        |
      (message (alist-get 'message (elt (alist-get 'comments (elt (alist-get 'patchSets returned-json) 0)) 0)))
      (message (alist-get 'project returned-json))
      (let ((gerrit_comments . (alist-get 'comments returned-json)))

        )
      (dolist VAR (alist-get 'comments (elt (reverse (alist-get 'patchSets returned-json)) 0))

        (car VAR) ;; <--- This body needs fixing. Find out what the value of msg really is!
        (car VAR) ;; <--- This body needs fixing. Find out what the value of msg really is!
        ;; (message "The number is %s" (alist-get 'message VAR)) ;; <--- This body needs fixing. Find out what the value of msg really is!
        ;; (message "The number is %s" (alist-get 'message VAR)) ;; <--- This body needs fixing. Find out what the value of msg really is!
        ))
    )
  )

(message "Done!")

;; DEBUG HELP
;; (setq a [((number . "1") (revision . "5584b74a570ee78a3fada737dfb8e768b9260cbc") (parents . ["a0adcae383470fc118b0379d5d6a72b39cdcdc45"]) (ref . "refs/changes/92/72392/1") (uploader (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (createdOn . 1668177084) (author (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (isDraft . :false) (kind . "REWORK") (comments . [...]) (sizeInsertions . 87) (sizeDeletions . -62)) ((number . "2") (revision . "11d414015e2bbbe5cdbe9fd989857bd2d00a7d35") (parents . ["a0adcae383470fc118b0379d5d6a72b39cdcdc45"]) (ref . "refs/changes/92/72392/2") (uploader (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (createdOn . 1668428517) (author (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (isDraft . :false) (kind . "REWORK") (comments . [...]) (sizeInsertions . 88) (sizeDeletions . -62)) ((number . "3") (revision . "44aa754965ad73383961f4dd1b0b43603a7f1b57") (parents . ["a0adcae383470fc118b0379d5d6a72b39cdcdc45"]) (ref . "refs/changes/92/72392/3") (uploader (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (createdOn . 1668432401) (author (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (isDraft . :false) (kind . "REWORK") (sizeInsertions . 89) (sizeDeletions . -62)) ((number . "4") (revision . "7ee20347fec829a67693feaaa99906a024ecca4a") (parents . ["a0adcae383470fc118b0379d5d6a72b39cdcdc45"]) (ref . "refs/changes/92/72392/4") (uploader (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (createdOn . 1668435708) (author (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (isDraft . :false) (kind . "REWORK") (sizeInsertions . 90) (sizeDeletions . -62)) ((number . "5") (revision . "89c9e1ca06d2965e2a21238de7712ed6f37a5dba") (parents . ["a0adcae383470fc118b0379d5d6a72b39cdcdc45"]) (ref . "refs/changes/92/72392/5") (uploader (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (createdOn . 1668523478) (author (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (isDraft . :false) (kind . "REWORK") (sizeInsertions . 87) (sizeDeletions . -66)) ((number . "6") (revision . "bf42cab1607661986308ea8a38f078617aafeb5c") (parents . ["53079eef8f61e03356e23c29d5bb841684f9fc70"]) (ref . "refs/changes/92/72392/6") (uploader (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (createdOn . 1668525162) (author (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (isDraft . :false) (kind . "REWORK") (sizeInsertions . 88) (sizeDeletions . -67)) ((number . "7") (revision . "5382020f51b9b7d9119e98dfa1cf0216e712ce67") (parents . ["53079eef8f61e03356e23c29d5bb841684f9fc70"]) (ref . "refs/changes/92/72392/7") (uploader (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (createdOn . 1668528014) (author (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (isDraft . :false) (kind . "REWORK") (sizeInsertions . 93) (sizeDeletions . -69)) ((number . "8") (revision . "8a015960e5b97b58ae35c3ae008ecbaa898240c6") (parents . ["53079eef8f61e03356e23c29d5bb841684f9fc70"]) (ref . "refs/changes/92/72392/8") (uploader (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (createdOn . 1668529394) (author (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (isDraft . :false) (kind . "REWORK") (sizeInsertions . 96) (sizeDeletions . -72)) ((number . "9") (revision . "7e338df0bd53449de09afcfac9d71511b54fec7b") (parents . ["53079eef8f61e03356e23c29d5bb841684f9fc70"]) (ref . "refs/changes/92/72392/9") (uploader (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (createdOn . 1668587181) (author (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (isDraft . :false) (kind . "REWORK") (comments . [... ... ... ...]) (sizeInsertions . 96) (sizeDeletions . -72)) ((number . "10") (revision . "823f5c760404fcb5411b13e7d3a4b27b51638dc5") (parents . ["53079eef8f61e03356e23c29d5bb841684f9fc70"]) (ref . "refs/changes/92/72392/10") (uploader (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (createdOn . 1668593877) (author (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (isDraft . :false) (kind . "REWORK") (comments . [... ...]) (sizeInsertions . 101) (sizeDeletions . -72)) ((number . "11") (revision . "42ac8885f24cab15e2785284fed68da8c2404296") (parents . ["53079eef8f61e03356e23c29d5bb841684f9fc70"]) (ref . "refs/changes/92/72392/11") (uploader (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (createdOn . 1668602790) (author (name . "Anton Olsson") (email . "ano@hms.se") (username . "ano")) (isDraft . :false) (kind . "REWORK") (sizeInsertions . 102) (sizeDeletions . -72))])
;; (nth 0 (map-keys a))
;; (plist-get a '3)
;; (plist-member a 10)
;; (plist-put a 'hej 1337)
;; (alist-get 'number (elt (reverse a) 1))

;; This function is used to apply the lambda function to all elements in the list. FINALLY!
;; (seq-map #'(lambda (x) (alist-get 'number x)) a)
