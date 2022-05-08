LISP ?= sbcl


.PHONY: build
build: wajir

wajir: wajir.asd lib/* src/*.lisp
	$(LISP) --load wajir.asd \
		--eval '(ql:quickload :wajir)' \
		--eval '(asdf:make :wajir)' \
		--eval '(quit)'
