(in-package :wajir)

(opts:define-opts
  (:name :login
   :description "Jira login email address"
   :long "login"
   :arg-parser #'identity
   :meta-var "<login>")
  (:name :token
   :description "Jira API token"
   :long "token"
   :arg-parser #'identity
   :meta-var "<token>")
  (:name :endpoint
   :description "Jira site URL host (e.g. example.atlassian.net)"
   :long "endpoint"
   :meta-var "<endpoint>")

  (:name :sendmail
   :description "send email command"
   :long "sendmail"
   :meta-var "<command>")
  (:name :email-to
   :description "recipient email address"
   :long "email-to"
   :meta-var "<address>")

  (:name :verbose
   :description "print verbose output"
   :short #\v
   :long "verbose")

  (:name :help
   :description "print this help menu"
   :short #\h
   :long "help")
  (:name :version
   :description "show the program version"
   :short #\V
   :long "version"))

(defmacro when-option ((options option) &body body)
  "When `option` is present in `options`, run `body`."
  `(let ((value (getf ,options ,option)))
     (when value
       ,@body)))

(defun exit-with-error (condition exit-code)
  "Print the error associated with `condition` on standard error, then exit
with code `exit-code`."
  (format *error-output* "error: ~a~%" condition)

  (opts:exit exit-code))

(defun handle-option-error (condition)
  "Handle errors related to command line options. Prints the error specified by
`condition` and exits with EX_USAGE."
  (exit-with-error condition sysexits:+usage+))

(defun parse-options ()
  "Parse command line options."
  (multiple-value-bind (options free-args)
    (handler-bind
      ((opts:unknown-option #'handle-option-error)
       (opts:missing-arg #'handle-option-error)
       (opts:arg-parser-failed #'handle-option-error)
       (opts:missing-required-option #'handle-option-error))

      (opts:get-opts))

    ;; Help
    (when-option (options :help)
      (opts:describe
        :usage-of "wajir"
        :args "<JQL>")

      (opts:exit sysexits:+usage+))

    ;; Version
    (when-option (options :version)
      (format t "~a~%" (asdf:component-version (asdf:find-system :extreload)))

      (opts:exit sysexits:+ok+))

    ;; Check required arguments
    ; (dolist (opt '(:login :token :endpoint))
    ;   ())
    ; (when (null (getf options :login))
    ;   (format *error-output* "~S" 
    ;           (loop
    ;             for opt in '(:login :token :endpoint)
    ;             with  '(opt (null (getf options opt)))
                ; collect result))
    ; (when (null (getf options :login))
    ;   (let ((required-opts
    ;           (mapcar
    ;             #'(lambda (opt) `(,opt ,(not (null (getf options opt)))))
    ;             '(:login :token :endpoint))))
    ;        (format *error-output* "opts: ~S" required-opts)
    ;        (opts:exit sysexits:+usage+)))
    ; (when (or (null (getf options :login))
    ;           (null (getf options :token))
    ;           (null (getf options :endpoint)))
    ;  (format *error-output* "error: missing required options: ~A"))

    ; (let* ((required-opts '(:login :token :endpoint))
    ;        (opts-missing-p (mapcar
    ;                          #'(lambda (opt) (null (getf options opt)))
    ;                          required-opts)))
    ;        ; (opts-missing-p (mapcar
    ;        ;                   #'(lambda (opt)
    ;        ;                       (cons (null (getf options opt))
    ;        ;                             opt))
    ;        ;                   required-opts))
    ;        ; (missing-opts (mapcar
    ;        ;                 #'second
    ;        ;                 (remove-if-not
    ;        ;                   #'(lambda (missing-and-opt) (first missing-and-opt))
    ;        ;                       opts-missing-p))))
    ;
    ;   (format *error-output* "miss: ~S~%" opts-missing-p)
    ;   (when (or (values opts-missing-p))
    ;     (let* ((opt-and-presence
    ;              (mapcar #'cons opts-missing-p required-opts))
    ;            (missing-opts
    ;              (remove-if
    ;                #'(lambda (presence-pair) (null (first presence-pair)))
    ;                opt-and-presence)))
    ;
    ;       (format *error-output* "opts: ~S~%" missing-opts)
    ;       (opts:exit sysexits:+usage+))))
    ;
    ;   ; (format *error-output* "v2: ~S~%" missing-opts))

    (let* ((required-opts '(:login :token :endpoint))

           ;; (nil nil t)
           ; (opts-missing-p (mapcar
           ;                   #'(lambda (opt) (null (getf options opt)))
           ;                   required-opts))

           ;; ((t . :login) (t . :token) (nil . :endpoint))
           (opts-missing-p (mapcar
                             #'(lambda (opt)
                                 (cons (null (getf options opt))
                                       opt))
                             required-opts))

           ;; (:endpoint)
           (missing-opts (mapcar
                           #'cdr
                           (remove-if-not
                             #'(lambda (missing-and-opt) (first missing-and-opt))
                             opts-missing-p))))

      (format
        *error-output*
        "error: missing required options: ~{`~(--~A~)'~^, ~}~%"
        missing-opts)

      (opts:exit sysexits:+usage+))

    ;; If `sendmail` is given, `email-to` must be defined.
    (when (not (null (getf options :sendmail)))
      (when (null (getf options  :email-to))
        (format *error-output* "error: `--sendmail' requires `--email-to'")
        (opts:exit sysexits:+usage+)))

    ;; Error if JQL is empty
    (when (null free-args)
      (format *error-output* "error: missing JQL")

      (opts:exit sysexits:+usage+))

    (make-instance 'config
                   :login (getf options :login)
                   :token (getf options :token)
                   :endpoint (getf options :endpoint)
                   :sendmail (getf options :sendmail)
                   :email-to (getf options :email-to)
                   :verbose (getf options :verbose)
                   :jql (first free-args))))
