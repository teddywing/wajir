(in-package :wajir)

(defun main ()
  ;; Query page of issues
  ;; [Check not in database?] <- no
  ;; Start watching issue
  ;; Send email to ^maildir^program^ containing message with issue metadata
  ;; Continue to next page

  (let ((config (make-instance 'config
                                :login "name@example.com"
                                :token "atlassian-token"
                                :endpoint "example.atlassian.net"
                                :jql "project = \"FAKE\" AND watcher != currentUser() AND key > \"FAKE-100\" ORDER BY created DESC")))

    (run config)))

(defun run (config)
  (let ((basic-auth-token (cl-base64:string-to-base64-string
                            (format nil
                                    "~A:~A"
                                    (login config)
                                    (token config)))))

    (loop
      (let* ((response (fetch-issues
                         (endpoint config)
                         (jql config)
                         :basic-auth-token basic-auth-token))

             (start-at (gethash "startAt" response))
             (max-results (gethash "maxResults" response))
             (total (gethash "total" response)))

        (watch-issues (gethash "issues" response))

        ;; Stop looping if we're on the last page of results.
        (when (> start-at
                 (- total max-results))
          (return))))))

(defun fetch-issues (endpoint jql &key basic-auth-token)
  (jzon:parse
    (dex:post (format nil "https://~A/rest/api/3/search" endpoint)
              :content
              (jzon:stringify
                `((:jql . ,jql)
                  (fields . ("id" "key" "self"))))
              :headers `((:content-type . "application/json")
                         (:authorization
                          . ,(format nil "Basic ~A" basic-auth-token))))))

(defun watch-issues (issues)
  (loop for issue across issues do
    (format t "Watching issue ~A~%" (gethash "key" issue))))
