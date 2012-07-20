# $Id: Makefile,v 1.41 2007/10/18 17:33:41 skx Exp $
#
#  Makefile for GNUMP3d v2.x
#
# Steve
# --
#
#

#
#  PREFIX for installation.
#
PREFIX     = 


#
#  Installation Directories.
#
BINDIR      = /usr/bin
TEMPDIR     = /usr/share/gnump3d
CONFDIR     = /etc/gnump3d
CACHEDIR    = /var/cache/gnump3d
SERVEDIR    = /var/cache/gnump3d/serving
MANDIR      = /usr/local/man/man1
LOGDIR      = /var/log/gnump3d
LIBDIR      = `perl bin/getlibdir`
PLUGDIR     = $(LIBDIR)/gnump3d/plugins
LANGDIR     = $(LIBDIR)/gnump3d/lang


#
#  Only used to build distribution tarballs.
#
DIST_PREFIX = $(TMP)
VERSION     = 3.0
BASE        = gnump3d



#
#  Default target, give the user some help.
#
a:
	@echo "gnump3d $VERSION Makefile"
	@echo ""
	@echo " Available targets (alphabetically):"
	@echo "    make debug     - Show debug diagnostics from this Makefile"
	@echo "    make dist      - Create distribution archives."
	@echo "    make install   - Install the software in ${BINDIR}."
	@echo "    make profile   - Run the binary under the Perl profiler"
	@echo "    make sign      - GPG sign the distribution files."
	@echo "    make test      - Run the test suite."
	@echo "    make uninstall - Removes this software completely."
	@echo " "
	@echo " Developer options:"
	@echo "    make clean     - Remove editor files"
	@echo "    make diff      - Show the local differences"
	@echo "    make update    - Update the local copy"
	@echo " "
	@echo " For more details see:"
	@echo "    http://www.gnump3d.org/"
	@echo " "

#
# Dummy target.
#
.PHONY: test install sign



clean:
	@find . -name "*~" -print | xargs rm -f
	@find . -name ".#*" -print | xargs rm -f
	@find . -name "tmon.out*" -print | xargs rm -f



debug:
	@echo "System information:"
	@echo "  I am `whoami` on `hostname`"
	@echo " "
	@echo "  This is `uname`"
	@echo " "
	@echo "Installation options:"
	@echo "    Prefix            : $(PREFIX)"
	@echo "    Binary directory  : ${BINDIR}"
	@echo "    Man page directory: ${MANDIR}"
	@echo "    Template directory: ${TEMPDIR}"
	@echo "    Plugin directory  : ${PLUGDIR}"
	@echo "    Language directory: ${LANGDIR}"


diff:
	cvs diff --unified 2>/dev/null


dist:   clean test-update
	rm -rf $(DIST_PREFIX)/$(BASE)-$(VERSION)
	rm -f $(DIST_PREFIX)/$(BASE)-$(VERSION).tar.bz2
	rm -f $(DIST_PREFIX)/$(BASE)-$(VERSION).tar.gz
	cp -R . $(DIST_PREFIX)/$(BASE)-$(VERSION)
	find  $(DIST_PREFIX)/$(BASE)-$(VERSION) -name "CVS" -print | xargs rm -rf
	find  $(DIST_PREFIX)/$(BASE)-$(VERSION) -name ".cvsignore" -exec rm -f \{\} \;
	perl ./bin/generate-win-conf etc/
	cd $(DIST_PREFIX) && tar -cvf $(DIST_PREFIX)/$(BASE)-$(VERSION).tar $(BASE)-$(VERSION)/
	gzip $(DIST_PREFIX)/$(BASE)-$(VERSION).tar
	mv $(DIST_PREFIX)/$(BASE)-$(VERSION).tar.gz .
	cd $(DIST_PREFIX) && tar -cvf $(BASE)-$(VERSION).tar $(BASE)-$(VERSION)/
	bzip2 $(DIST_PREFIX)/$(BASE)-$(VERSION).tar
	mv $(DIST_PREFIX)/$(BASE)-$(VERSION).tar.bz2 .
	cd $(DIST_PREFIX) && zip -r $(BASE)-$(VERSION).zip $(BASE)-$(VERSION)/
	mv $(DIST_PREFIX)/$(BASE)-$(VERSION).zip .
	rm -rf $(DIST_PREFIX)/$(BASE)-$(VERSION)


install:
	install -d ${PREFIX}/${CONFDIR}
	install -d ${PREFIX}/${BINDIR}
	install -d ${PREFIX}/${TEMPDIR}
	install -d ${PREFIX}/${MANDIR}
	install -d ${PREFIX}/${PLUGDIR}
	install -d ${PREFIX}/${LANGDIR}
	install -d ${PREFIX}/${LOGDIR}
	install -d ${PREFIX}/${CACHEDIR}
	chmod 777 ${PREFIX}/${CACHEDIR}
	install -d ${PREFIX}/$(SERVEDIR)
	chmod 777 ${PREFIX}/${SERVEDIR}
	chmod a+rx ${PREFIX}/${LIBDIR}/gnump3d/
	chmod a+rx ${PREFIX}/${LIBDIR}/gnump3d/plugins
	chmod a+rx ${PREFIX}/${LIBDIR}/gnump3d/lang
	cp lib/gnump3d/*.pm ${PREFIX}/${LIBDIR}/gnump3d
	cp lib/gnump3d/plugins/*.pm ${PREFIX}/${PLUGDIR}
	-rm ${PREFIX}/${PLUGDIR}/bug.pm
	cp lib/gnump3d/lang/*.pm ${PREFIX}/${LANGDIR}
	cp bin/gnump3d2 ${PREFIX}/${BINDIR}
	chmod 755 ${PREFIX}/${BINDIR}/gnump3d2
	-ln -sf ${PREFIX}/${BINDIR}/gnump3d2 ${PREFIX}/${BINDIR}/gnump3d
	cp bin/gnump3d-top ${PREFIX}/$(BINDIR)
	chmod 755 ${PREFIX}/${BINDIR}/gnump3d-top
	cp bin/gnump3d-index ${PREFIX}/${BINDIR}
	chmod 755 ${PREFIX}/${BINDIR}/gnump3d-index
	cp man/gnump3d-top.1 ${PREFIX}/${MANDIR}
	cp man/gnump3d-index.1 ${PREFIX}/${MANDIR}
	cp man/gnump3d.1 ${PREFIX}/${MANDIR}
	cp man/gnump3d.conf.1 ${PREFIX}/${MANDIR}
	cp -R templates/* ${PREFIX}/${TEMPDIR}
	chmod -R a+r ${PREFIX}/${TEMPDIR}
	chmod +rx ${PREFIX}/${TEMPDIR}/*/
	if [ -e ${PREFIX}/${CONFDIR}/gnump3d.conf ]; then cp ${PREFIX}/${CONFDIR}/gnump3d.conf ${PREFIX}/${CONFDIR}/gnump3d.conf-orig ; fi
	sed "s#PLUGINDIR#${LIBDIR}#g" etc/gnump3d.conf > ${PREFIX}/${CONFDIR}/gnump3d.conf
	cp etc/mime.types ${PREFIX}/${CONFDIR}
	cp etc/file.types ${PREFIX}/${CONFDIR}
	-rm -f ${PREFIX}/$(LIBDIR)/gnump3d/FreezeThaw.pm
	-rm -f ${PREFIX}/$(LIBDIR)/gnump3d/playlist.pm


profile:
	perl -d:DProf=1 bin/gnump3d2
	dprofpp


sign: dist
	-rm -f *.asc
	for i in gnump3d-$(VERSION).*; do gpg --armor --detach-sign $$i; done


test:
	prove --shuffle tests/


test-update:
	cd tests && make modules && make files

test-verbose:
	prove --shuffle --verbose tests/


uninstall:
	rm -f ${BINDIR}/gnump3d-top
	rm -f ${BINDIR}/gnump3d-index
	rm -f ${BINDIR}/gnump3d2
	rm -f ${BINDIR}/gnump3d
	rm -f ${MANDIR}/gnump3d-top.1
	rm -f ${MANDIR}/gnump3d-index.1
	rm -f ${MANDIR}/gnump3d.1
	rm -f ${MANDIR}/gnump3d.conf.1
	rm -rf $(LIBDIR)/gnump3d/
	rm -rf ${TEMPDIR}
	rm -f   /etc/gnump3d/gnump3d.conf
	-rm -rf ${CONFDIR}
	-rm -rf ${LOGDIR}
	-rm -rf ${CACHEDIR}
	-rm -rf ${SERVEDIR}


update:
	cvs -z3 update -A -d -P 2>/dev/null

