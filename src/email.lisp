(in-package :wajir)

(defun deliver-email (config issue)
  (let ((message (with-output-to-string (message-stream)
                   (build-email config issue message-stream))))

    (with-open-stream (sendmail-input (make-string-input-stream message))
      (uiop:run-program (sendmail config)
                        :input sendmail-input))))

(defun build-email (config issue output-stream)
  (cl-smtp:write-rfc8822-message
    output-stream
    (format nil "wajir@~A" (uiop:hostname))
    `(,(email-to config))
    (format-subject issue)
    (format-body issue (endpoint config))))

(defun format-subject (issue)
  (format nil
          "[JIRA] (~A) ~A"
          (gethash "key" issue)
          (gethash "summary"
                   (gethash "fields" issue))))

(defun format-body (issue endpoint)
  (let ((fields (gethash "fields" issue)))
    (format nil
            "~A created ~A:~%~%Summary: ~A~%Key: ~A~%URL: ~A~%Project: ~A~%Issue Type: ~A~%Reporter: ~A~%~%~%~A"
            (gethash "displayName"
                     (gethash "creator" fields))
            (gethash "key" issue)
            (gethash "summary" fields)
            (gethash "key" issue)
            (format nil
                    "https://~A/browse/~A"
                    endpoint
                    (gethash "key" issue))
            (gethash "name"
                     (gethash "project" fields))
            (gethash "name"
                     (gethash "issuetype" fields))
            (gethash "displayName"
                     (gethash "reporter" fields))
            (gethash "description" fields))))
