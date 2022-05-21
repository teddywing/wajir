(defpackage :wajir
  (:use :cl)

  (:local-nicknames (:interrupt :with-user-abort)
                    (:jzon :com.inuoe.jzon))

  (:export :main))
