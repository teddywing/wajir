(asdf:defsystem wajir
  :version "0.0.1"
  :depends-on (:cl-smtp
               :dexador)
  :components ((:module "src"
                :serial t
                :components ((:file "package")
                             (:file "main"))))

  :build-operation "program-op"
  :build-pathname "wajir"
  :entry-point "wajir")

#+sb-core-compression
(defmethod asdf:perform ((o asdf:image-op) (c asdf:system))
  (uiop:dump-image (asdf:output-file o c) :executable t :compression t))
