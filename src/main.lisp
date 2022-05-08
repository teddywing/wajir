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
                                :email-to "name@example.com"
                                :jql "project = \"FAKE\" AND watcher != currentUser() AND key > \"FAKE-100\" ORDER BY created DESC")))

    (run config)))

(defun run (config)
  (let ((basic-auth-token (cl-base64:string-to-base64-string
                            (format nil
                                    "~A:~A"
                                    (login config)
                                    (token config)))))

    (loop
      with start-at = 0
      with max-results = 0
      do
      (progn
        (let* ((response (fetch-issues
                           (endpoint config)
                           (jql config)
                           start-at
                           :basic-auth-token basic-auth-token))

               (total (gethash "total" response)))

          (format t "start-at: ~A max-results: ~A total: ~A~%"
                  start-at
                  max-results
                  total)

          ;; Watch each issue.
          ; (loop for issue
          ;       across (gethash "issues" response)
          ;       do (watch-issue config issue))
          (let ((issue (aref (gethash "issues" response) 0)))
            (watch-issue config issue)

            (return))

          ;; Stop looping if we're on the last page of results.
          (when (> start-at
                   (- total max-results))
            (return))

          ;; Step `start-at` for next page.
          (setf max-results (gethash "maxResults" response))
          (setf start-at (+ (gethash "startAt" response)
                            max-results)))))))

(defun fetch-issues (endpoint jql start-at &key basic-auth-token)
  (jzon:parse
    (dex:post (format nil "https://~A/rest/api/2/search" endpoint)
              :content
              (jzon:stringify
                `((:jql . ,jql)
                  (:fields . #("id"
                               "key"
                               "project"
                               "summary"
                               "description"
                               "issuetype"
                               "creator"
                               "reporter"))
                  (:|startAt| . ,start-at)))
              :headers `((:content-type . "application/json")
                         (:authorization
                          . ,(format nil "Basic ~A" basic-auth-token))))))

(defun watch-issue (config issue)
  ;; 1. Watch issue in Jira
  ;; 2. Send email
  (format t "Watching issue ~A~%" (gethash "key" issue))

  (if (sendmail config)
      (deliver-email config issue)))
