;; Package for reviewing gerrit comment inside emacs

;; Author: Sebastian Nirvin

(message "Loading gerrit.el...")

(defun get-gerrit-comments ()
  "Main entry point"
  (interactive)
  "Function for fetching gerrit comments from the latest log"
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

      (message (alist-get 'project returned-json))
      (message "The number is %s"
               (alist-get 'number
                          (elt
                           (reverse
                            (alist-get 'patchSets returned-json)) 0 )))
      ;; (message (alist-get 'comments (alist-get 'patchSets)))
      )
    )
  )

(message "Done!")
