(in-package :wajir)

(defun main ()
  ;; Query page of issues
  ;; [Check not in database?] <- no
  ;; Start watching issue
  ;; Send email to ^maildir^program^ containing message with issue metadata
  ;; Continue to next page

  (fetch-issues
    "project = \\\"FAKE\\\" AND watcher != currentUser() AND key > \\\"FAKE-100\\\" ORDER BY created DESC"
    :basic-auth-token "TOKEN"))

(defun fetch-issues (jql &key basic-auth-token)
  (multiple-value-bind (body code)
    (dex:post "https://example.atlassian.net/rest/api/3/search"
              :content
              (format nil "{
                      \"jql\": \"~A\",
                      \"fields\": [\"id\", \"key\", \"self\"]
                      }"
                      jql)
              :headers `((:content-type . "application/json")
                         (:authorization
                          . ,(format nil "Basic ~A" basic-auth-token))))

    body))
