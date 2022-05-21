(in-package :wajir)

(defun main ()
  ;; Query page of issues
  ;; Start watching issue
  ;; Send email to program containing message with issue metadata
  ;; Continue to next page

  ;; Disable interactive debugger.
  (setf *debugger-hook* #'debug-ignore)

  (handler-case
      (interrupt:with-user-abort
        (handler-bind ((error #'(lambda (e)
                                  (exit-with-error e sysexits:+unavailable+))))

          (let ((config (parse-options)))
            (run config))))

    ;; Control-c
    (interrupt:user-abort ()
      (opts:exit 130))))

(defun debug-ignore (condition hook)
  (declare (ignore hook))
  (princ condition)
  (abort))

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

          (when (verbose config)
            (format t "start-at: ~A max-results: ~A total: ~A~%"
                    start-at
                    max-results
                    total))

          ;; Watch each issue.
          (loop for issue
                across (gethash "issues" response)
                do (watch-issue
                     config
                     issue
                     :basic-auth-token basic-auth-token))

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

(defun watch-issue (config issue &key basic-auth-token)
  ;; 1. Watch issue in Jira
  ;; 2. Send email
  (when (verbose config)
    (format t "Watching issue ~A~%" (gethash "key" issue)))

  (add-watcher
    (endpoint config)
    issue
    :basic-auth-token basic-auth-token)

  (if (sendmail config)
      (deliver-email config issue)))

(defun add-watcher (endpoint issue &key basic-auth-token)
  "Add the authenticated user as a watcher to issue."
  (dex:post
    (format nil
            "https://~A/rest/api/2/issue/~A/watchers"
            endpoint
            (gethash "id" issue))
    :headers `((:authorization . ,(format nil "Basic ~A" basic-auth-token)))))
