(in-package :wajir)

(defun main ()
  ;; Query page of issues
  ;; [Check not in database?] <- no
  ;; Start watching issue
  ;; Send email to ^maildir^program^ containing message with issue metadata
  ;; Continue to next page

  (let ((basic-auth-token (cl-base64:string-to-base64-string
                            (format nil "~A:~A" "name@example.com" "atlassian-token"))))

    (fetch-issues
      "https://example.atlassian.net"
      "project = \\\"FAKE\\\" AND watcher != currentUser() AND key > \\\"FAKE-100\\\" ORDER BY created DESC"
      :basic-auth-token basic-auth-token)))

(defun fetch-issues (endpoint jql &key basic-auth-token)
  (jzon:parse
    (dex:post (format nil "~A/rest/api/3/search" endpoint)
              :content
              (jzon:stringify
                `((:jql . ,jql)
                  (fields . ("id" "key" "self"))))
              :headers `((:content-type . "application/json")
                         (:authorization
                          . ,(format nil "Basic ~A" basic-auth-token))))))
