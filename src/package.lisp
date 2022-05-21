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


(defpackage :wajir
  (:use :cl)

  (:local-nicknames (:interrupt :with-user-abort)
                    (:jzon :com.inuoe.jzon))

  (:export :main))
