;; Package for reviewing gerrit comment inside emacs

;; Author: Sebastian Nirvin

;; (setq explicit-shell-file-name "c:/Program Files/Git/bin/bash.exe")
;; (setq shell-file-name "bash")

(let ((process-name "gerrit-get")
      (process-connection-type nil)
      (buf-name "*gerrit log*"))

  (kill-buffer buf-name)
  (get-buffer-create buf-name)

  ;; (start-process process-name buf-name "ssh"
  ;;                "-p" "29418"
  ;;                "review.hms.se"
  ;;                "gerrit"
  ;;                "query"
  ;;                "--patch-sets"
  ;;                "--format=JSON"
  ;;                "--comments"
  ;;                "change:Idb19e485226a80fcca730d9b1b80b84be20a77bd")

  (call-process "ssh" nil buf-name nil
                "-p 29418"
                "review.hms.se"
                "gerrit"
                "query"
                "--patch-sets"
                "--format=JSON"
                "--comments"
                "change:I2be2a5c392830a1d3ddd84aa8ac592ed0c4101e1"
                )

  (with-current-buffer buf-name
    ;; TODO
    ;; - Figure out what values to pick out
    ;; - Figure out how to put them in a buffer, take insperation from somewhere?
    ;; (json-pretty-print-buffer)
    (goto-char (point-max))
    (delete-region (+ (search-backward "}") 1) (point-max))
    (goto-char (point-min))
    (let ((returned-json (json-parse-buffer :object-type 'alist)))
      (message (alist-get 'project returned-json))
      )
    )
  )
