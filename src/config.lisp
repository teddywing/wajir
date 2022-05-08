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

   (sendmail
     :initarg :sendmail
     :reader sendmail
     :documentation "Email sending client command")
   (email-to
     :initarg :email-to
     :reader email-to
     :documentation "Email recipient")

   (verbose
     :initarg :verbose
     :initform nil
     :reader verbose
     :documentation "Turn on verbose output")

   (jql
     :initarg :jql
     :reader jql
     :documentation "JQL querying issues to watch")))

(defmethod print-object ((object config) stream)
  (with-slots (login token endpoint sendmail email-to verbose jql) object
    (print-unreadable-object (object stream :type t)
      (format stream
              ":login ~S :token ~S :endpoint ~S :sendmail ~S :email-to ~S :verbose ~S :jql ~S"
              login token endpoint sendmail email-to verbose jql))))
