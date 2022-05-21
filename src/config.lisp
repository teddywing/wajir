;;; Copyright (c) 2022  Teddy Wing
;;;
;;; This file is part of Wajir.
;;;
;;; Wajir is free software: you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation, either version 3 of the License, or
;;; (at your option) any later version.
;;;
;;; Wajir is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with Wajir. If not, see <https://www.gnu.org/licenses/>.


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
