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
               :unix-opts
               :with-user-abort)
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
