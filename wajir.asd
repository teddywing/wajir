(in-package :asdf-user)

;; Include the repo "lib/" directory in the system search path to make
;; available systems tracked as submodules.
(initialize-source-registry
  `(:source-registry
    (:tree ,(make-pathname :directory
                           (append
                             (pathname-directory *load-pathname*)
                             '("lib"))))
    :inherit-configuration))

(defsystem wajir
  :version "0.0.1"
  :depends-on (:cl-base64
               :com.inuoe.jzon
               :dexador)
  :components ((:module "src"
                :serial t
                :components ((:file "package")
                             (:file "config")
                             (:file "main"))))

  :build-operation "program-op"
  :build-pathname "wajir"
  :entry-point "wajir")

#+sb-core-compression
(defmethod perform ((o image-op) (c system))
  (uiop:dump-image (output-file o c) :executable t :compression t))
