NAME    := iptv-cli
VERSION := $(shell cat VERSION)
ARCH    := all
STAGE   := build/$(NAME)_$(VERSION)_$(ARCH)
DEB     := dist/$(NAME)_$(VERSION)_$(ARCH).deb

.PHONY: all deb clean install uninstall

all: deb

deb: clean
	mkdir -p $(STAGE)/DEBIAN $(STAGE)/usr/bin \
	         $(STAGE)/usr/share/applications $(STAGE)/usr/share/doc/$(NAME)
	sed 's/@VERSION@/$(VERSION)/' src/iptv-cli > $(STAGE)/usr/bin/iptv-cli
	chmod 755 $(STAGE)/usr/bin/iptv-cli
	sed 's/@VERSION@/$(VERSION)/' packaging/control > $(STAGE)/DEBIAN/control
	cp packaging/iptv-cli.desktop $(STAGE)/usr/share/applications/
	cp README.md $(STAGE)/usr/share/doc/$(NAME)/README.md
	cp LICENSE   $(STAGE)/usr/share/doc/$(NAME)/copyright
	mkdir -p dist
	dpkg-deb --build --root-owner-group $(STAGE) $(DEB)
	@echo "Built $(DEB)"

install: deb
	sudo apt install ./$(DEB)

uninstall:
	sudo apt remove $(NAME)

clean:
	rm -rf build dist
