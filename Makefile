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
