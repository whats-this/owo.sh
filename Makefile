PREFIX ?= /usr

install: install-bin install-man

install-bin: bin/owo
	mkdir -p $(PREFIX)/$(dir $<)
	install -m 0755 $< $(PREFIX)/$<

install-man: share/man/man1/owo.1
	mkdir -p $(PREFIX)/$(dir $<)
	gzip -9nc $< > $(PREFIX)/$<
