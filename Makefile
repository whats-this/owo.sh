.POSIX:
.SUFFIXES:

PREFIX ?= /usr/local

.PHONY: install
install: bin/owo share/man/man1/owo.1 share/owo/oworc
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	mkdir -p $(DESTDIR)$(PREFIX)/share/man/man1
	mkdir -p $(DESTDIR)$(PREFIX)/share/owo
	install -m 0755 bin/owo $(DESTDIR)$(PREFIX)/bin/owo
	install -m 0644 share/man/man1/owo.1 $(DESTDIR)$(PREFIX)/share/man/man1/owo.1
	install -m 0644 share/owo/oworc $(DESTDIR)$(PREFIX)/share/owo/oworc

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/owo
	rm -f $(DESTDIR)$(PREFIX)/share/man/man1/owo.1
	rm -f $(DESTDIR)$(PREFIX)/share/owo/oworc # let's not remove the whole directory if it was modified
	rm -f $(DESTDIR)$(PREFIX)/share/owo # okay?
