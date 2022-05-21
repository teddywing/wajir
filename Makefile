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


PREFIX=/usr/local

LISP ?= sbcl

VERSION := $(shell fgrep ':version' wajir.asd | awk -F '"' '{ print $$2 }')

MAN_PAGE := doc/wajir.1


.PHONY: all
all: wajir $(MAN_PAGE)


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


bundle: bundle.lisp
	mkdir -p lib/wajir
	cp -a wajir.asd src lib/wajir/

	$(LISP) --load bundle.lisp

bundle/bundled-local-projects/0000/wajir/wajir: bundle
	$(LISP) --load bundle/bundle.lisp \
		--eval '(asdf:make :wajir)' \
		--eval '(quit)'


.PHONY: pkg
pkg: wajir_$(VERSION).tar.bz2

wajir_$(VERSION).tar.bz2: bundle
	git archive --output=wajir_$(VERSION).tar HEAD
	tar -rf wajir_$(VERSION).tar bundle
	bzip2 wajir_$(VERSION).tar


.PHONY: install
install: bundle/bundled-local-projects/0000/wajir/wajir $(MAN_PAGE)
	install -m 755 bundle/bundled-local-projects/0000/wajir/wajir $(PREFIX)/bin
	install -m 755 $(MAN_PAGE) $(PREFIX)/share/man/man1
