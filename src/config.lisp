(in-package :wajir)

(defclass config ()
  ((login
    :initarg :login
    :reader login
    :documentation "Jira login email address")
  (token
    :initarg :token
    :reader token
    :documentation "Jira authentication token")
  (endpoint
    :initarg :endpoint
    :reader endpoint
    :documentation "Jira site URL (e.g. example.atlassian.net)")
  (jql
    :initarg :jql
    :reader jql
    :documentation "JQL querying issues to watch")))