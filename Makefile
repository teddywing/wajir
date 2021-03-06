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


prefix ?= /usr/local
exec_prefix ?= $(prefix)
bindir ?= $(exec_prefix)/bin
datarootdir ?= $(prefix)/share
mandir ?= $(datarootdir)/man
man1dir ?= $(mandir)/man1


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


bundle:
	mkdir -p lib/wajir
	cp -a wajir.asd src lib/wajir/

	$(LISP) --load bundle.lisp

bundle/bundled-local-projects/0000/wajir/wajir: bundle
	$(LISP) --load bundle/bundle.lisp \
		--eval '(asdf:make :wajir)' \
		--eval '(quit)'


.PHONY: pkg
pkg: wajir_$(VERSION).tar.bz2

wajir_$(VERSION).tar.bz2: bundle wajir.asd src/*.lisp
	git archive \
		--prefix=wajir_$(VERSION)/ \
		--output=wajir_$(VERSION).tar \
		HEAD
	tar -r \
		-s ,bundle,wajir_$(VERSION)/bundle, \
		-f wajir_$(VERSION).tar \
		bundle
	bzip2 wajir_$(VERSION).tar


.PHONY: install
install: bundle/bundled-local-projects/0000/wajir/wajir $(MAN_PAGE)
	install -m 755 bundle/bundled-local-projects/0000/wajir/wajir $(DESTDIR)$(bindir)

	install -d $(DESTDIR)$(man1dir)
	install -m 644 $(MAN_PAGE) $(DESTDIR)$(man1dir)
