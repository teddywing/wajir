(setf ql:*local-project-directories* '("./lib"))

(let ((dependencies (append
                      (asdf:system-depends-on (asdf:find-system :wajir))
                      (asdf:system-depends-on (asdf:find-system :com.inuoe.jzon))))
      (local-dependencies '("com.inuoe.jzon"
                            "sysexits")))
  (ql:bundle-systems
    (set-difference
      (sort dependencies #'string-lessp)
      local-dependencies
      :test #'equal)
    :to "./bundle"
    :include-local-projects t))

(quit)
