(in-package :wajir)

(defun main ()
  ;; Query page of issues
  ;; [Check not in database?] <- no
  ;; Start watching issue
  ;; Send email to ^maildir^program^ containing message with issue metadata
  ;; Continue to next page

  (dex:post "https://example.atlassian.net/rest/api/3/search"
            :content
            "{
            \"jql\": \"project = \\\"FAKE\\\" AND watcher != currentUser() AND key > \\\"FAKE-100\\\" ORDER BY created DESC\",
            \"fields\": [\"id\", \"key\", \"self\"]
            }"
            :headers '((:content-type . "application/json")
                       (:authorization . "Basic TOKEN"))))
