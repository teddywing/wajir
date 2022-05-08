(in-package :wajir)

(defun deliver-email (recipient issue)
  (cl-smtp:write-rfc8822-message
    *standard-output*
    (format nil "wajir@~A" (uiop:hostname))
    `(,recipient)
    (format-subject issue)
    (format-description issue)))

(defun format-subject (issue)
  (format nil
          "[JIRA] (~A) ~A"
          (gethash "key" issue)
          (gethash "summary"
                   (gethash "fields" issue))))

(defun format-description (issue)
  (gethash "description"
           (gethash "fields" issue)))
