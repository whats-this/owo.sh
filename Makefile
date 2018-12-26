PREFIX ?= /usr/local

.PHONY: install
install: install-bin install-man install-icons install-conf

install-bin: bin/owo
	mkdir -p $(PREFIX)/$(dir $<)
	install -m 0755 $< $(PREFIX)/$<

install-man: share/man/man1/owo.1
	mkdir -p $(PREFIX)/$(dir $<)
	install -m 0644 $<  $(PREFIX)/$<

install-icons: share/icons/default/500x500/apps/owo.png
	mkdir -p $(PREFIX)/$(dir $<)
	install -m 0655 $< $(PREFIX)/$<

install-conf: share/owo/owo.conf
	mkdir -p $(PREFIX)/$(dir $<)
	install -m 0644 $< $(PREFIX)/$<
