; (push
;   (merge-pathnames "lib/" (asdf:system-source-directory :wajir))
;   asdf:*central-registry*)

(in-package :asdf-user)

; (initialize-source-registry
;   '(:source-registry
;     (:tree (merge-pathnames "lib/" (system-source-directory :wajir)))
;   :inherit-configuration))

(initialize-source-registry
  `(:source-registry
    (:tree ,(make-pathname :directory
                           (append
                             (pathname-directory *load-pathname*)
                             '("lib"))))
    :inherit-configuration))

(defsystem wajir
  :version "0.0.1"
  :depends-on (:com.inuoe.jzon
               :dexador)
  :components ((:module "src"
                :serial t
                :components ((:file "package")
                             (:file "main"))))

  :build-operation "program-op"
  :build-pathname "wajir"
  :entry-point "wajir")

#+sb-core-compression
(defmethod perform ((o image-op) (c system))
  (uiop:dump-image (output-file o c) :executable t :compression t))
