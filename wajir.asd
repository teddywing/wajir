;; Include the repo "lib/" directory in the system search path to make
;; available systems tracked as submodules.
(asdf:initialize-source-registry
  `(:source-registry
    (:tree ,(make-pathname :directory
                           (append
                             (pathname-directory *load-pathname*)
                             '("lib"))))
    :inherit-configuration))

(asdf:defsystem wajir
  :version "0.0.1"
  :depends-on (:cl-base64
               :cl-smtp
               :com.inuoe.jzon
               :dexador
               :sysexits
               :unix-opts)
  :components ((:module "src"
                :serial t
                :components ((:file "package")
                             (:file "config")
                             (:file "option")
                             (:file "email")
                             (:file "main"))))

  :build-operation "program-op"
  :build-pathname "wajir"
  :entry-point "wajir:main")

#+sb-core-compression
(defmethod asdf:perform ((o asdf:image-op) (c asdf:system))
  (uiop:dump-image (asdf:output-file o c) :executable t :compression t))
