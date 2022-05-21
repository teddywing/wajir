# Copyright (c) 2022  Teddy Wing
#
# This file is part of Wajir.
#
# Wajir is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Wajir is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Wajir. If not, see <https://www.gnu.org/licenses/>.


LISP ?= sbcl

MAN_PAGE := doc/wajir.1


.PHONY: build
build: wajir

wajir: wajir.asd lib/* src/*.lisp
	$(LISP) --load wajir.asd \
		--eval '(ql:quickload :wajir)' \
		--eval '(asdf:make :wajir)' \
		--eval '(quit)'


.PHONY: doc
doc: $(MAN_PAGE)

$(MAN_PAGE): doc/wajir.1.txt
	a2x --no-xmllint --format manpage $<
