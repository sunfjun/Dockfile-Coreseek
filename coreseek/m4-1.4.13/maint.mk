## maint.mk -- Makefile rules for m4 maintainers -*-Makefile-*-
##
## Copyright (C) 2004, 2005, 2006, 2007, 2008, 2009 Free Software
## Foundation
##
## This file is part of GNU M4.
##
## GNU M4 is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## GNU M4 is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

# This is reported not to work with make-3.79.1
# ME := $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
ME := maint.mk

# Do not save the original name or timestamp in the .tar.gz file.
# Use --rsyncable if available.
gzip_rsyncable := \
  $(shell gzip --help 2>/dev/null|grep rsyncable >/dev/null && echo --rsyncable)
GZIP_ENV = '--no-name --best $(gzip_rsyncable)'

GIT = git
VC = $(GIT)
VC-tag = git tag -s -m '$(VERSION)' -u $(gpg_key_ID)

VERSION_REGEXP = $(subst .,\.,$(VERSION))
my_distdir = $(PACKAGE)-$(VERSION)

# Ensure that we use only the standard $(VAR) notation,
# not @...@ in Makefile.am, now that we can rely on automake
# to emit a definition for each substituted variable.
makefile-check:
	grep -nE '@[A-Z_0-9]+@' `find $(srcdir) -name Makefile.am` \
	  && { echo '$(ME): use $$(...), not @...@' 1>&2; exit 1; } || :

news-date-check: NEWS version-check
	today=`date +%Y-%m-%d`;						\
	if head $(srcdir)/NEWS | grep '^\*.* $(VERSION_REGEXP) ('$$today')' \
	    >/dev/null; then						\
	  :;								\
	else								\
	  echo "version or today's date is not in NEWS" 1>&2;		\
	  exit 1;							\
	fi

changelog-check:
	if head $(srcdir)/ChangeLog | grep 'Version $(VERSION_REGEXP)\.$$' \
	    >/dev/null; then						\
	  :;								\
	else								\
	  echo "$(VERSION) not in ChangeLog" 1>&2;			\
	  exit 1;							\
	fi

m4-check:
	@grep -n 'AC_DEFUN([^[]' $(srcdir)/m4/*.m4 \
	  && { echo '$(ME): quote the first arg to AC_DEFUN' 1>&2; \
	       exit 1; } || :

vc-diff-check:
	(CDPATH=; cd $(srcdir) && $(VC) diff) > vc-diffs || :
	if test -s vc-diffs; then				\
	  cat vc-diffs;						\
	  echo "Some files are locally modified:" 1>&2;		\
	  exit 1;						\
	else							\
	  rm vc-diffs;						\
	fi

maintainer-distcheck:
	$(MAKE) distcheck
	$(MAKE) my-distcheck

# Don't make a distribution if checks fail.
# Also, make sure the NEWS file is up-to-date.
vc-dist: $(local-check) vc-diff-check maintainer-distcheck
	$(MAKE) dist

# Use this to make sure we don't run these programs when building
# from a virgin tgz file, below.
null_AM_MAKEFLAGS = \
  ACLOCAL=false \
  AUTOCONF=false \
  AUTOMAKE=false \
  AUTOHEADER=false \
  MAKEINFO=false

# Use -Wformat -Werror to detect format-string/arg-list mismatches.
# Also, check for shadowing problems with -Wshadow, and for pointer
# arithmetic problems with -Wpointer-arith.
# These CFLAGS are pretty strict.  If you build this target, you probably
# have to have a recent version of gcc and glibc headers.
TMPDIR ?= /tmp
t=$(TMPDIR)/$(PACKAGE)/test
my-distcheck: $(local-check) check
	-rm -rf $(t)
	mkdir -p $(t)
	GZIP=$(GZIP_ENV) $(AMTAR) -C $(t) -zxf $(distdir).tar.gz
	cd $(t)/$(distdir)				\
	  && ./configure				\
	  && $(MAKE) CFLAGS='$(warn_cflags)'		\
	      AM_MAKEFLAGS='$(null_AM_MAKEFLAGS)'	\
	  && $(MAKE) dvi				\
	  && $(MAKE) check				\
	  && $(MAKE) distclean
	(cd $(t) && mv $(distdir) $(distdir).old	\
	  && $(AMTAR) -zxf - ) < $(distdir).tar.gz
	diff -ur $(t)/$(distdir).old $(t)/$(distdir)
	-rm -rf $(t)
	@echo "========================"; \
	echo "$(distdir).tar.gz is ready for distribution"; \
	echo "========================"

gnulib-version = $$(cd $(gnulib_dir) && git describe)

announcement: NEWS ChangeLog $(rel-files)
	@$(srcdir)/build-aux/announce-gen				\
	    --release-type=$(RELEASE_TYPE)				\
	    --package=$(PACKAGE)					\
	    --prev=$(PREV_VERSION)					\
	    --curr=$(VERSION)						\
	    --gpg-key-id=$(gpg_key_ID)					\
	    --news=$(srcdir)/NEWS					\
	    --bootstrap-tools=autoconf,automake,gnulib			\
	    --gnulib-version=$(gnulib-version)				\
	    $(addprefix --url-dir=, $(url_dir_list))

.PHONY: alpha beta major
alpha beta major: $(local-check) version-check
	test $@ = major						\
	  && { echo $(VERSION) | grep -E '^[0-9]+(\.[0-9]+)+$$'	\
	       || { echo "invalid version string: $(VERSION)" 1>&2; exit 1;};}\
	  || :
	$(MAKE) vc-dist
	$(MAKE) news-date-check changelog-check
	$(MAKE) deltas
	$(MAKE) -s announcement RELEASE_TYPE=$@ > /tmp/announce-$(my_distdir)

.PHONY: version-check
version-check:
	@case $(VERSION) in \
	*[acegikmoqsuwy]) \
	  echo "Version \`$(VERSION)' is not a releasable version, please read:"; \
	  echo "    http://www.gnu.org/software/libtool/contribute.html"; \
	  exit 1; \
	  ;; \
	esac
	@if test -z "$(PREV_VERSION)"; \
		then echo "PREV_VERSION is not set"; exit 1; fi

.PHONY: prev-tarball
prev-tarball: version-check
## Make sure we have the previous release tarball in the tree.
	@ofile="$(PACKAGE)-$(PREV_VERSION).tar.gz"; \
	if test -f $$ofile; then :; \
	else echo "Cannot make deltas without $$ofile"; exit 1; fi

.PHONY: new-tarball
new-tarball:
## Make sure we have the new release tarball in the tree.
	@ofile="$(PACKAGE)-$(VERSION).tar.gz"; \
	if test -f $$ofile; then :; \
	else echo "Cannot make deltas without $$ofile"; exit 1; fi

.PHONY: deltas
deltas: delta-diff

DIFF = diff
DIFF_OPTIONS = -ruNp

.PHONY: delta-diff
delta-diff: prev-tarball new-tarball
## Unpack the tarballs somewhere to diff them
	rm -rf delta-diff
	mkdir delta-diff
	ofile="../$(PACKAGE)-$(PREV_VERSION)-$(VERSION).diff.gz"; \
	cd delta-diff \
	&& tar xzf "../$(PACKAGE)-$(PREV_VERSION).tar.gz" \
	&& tar xzf "../$(PACKAGE)-$(VERSION).tar.gz" \
	&& $(DIFF) $(DIFF_OPTIONS) \
		$(PACKAGE)-$(PREV_VERSION) $(PACKAGE)-$(VERSION) \
		| GZIP=$(GZIP_ENV) gzip -c > $$ofile
	rm -rf delta-diff

.PHONY: web-manual
web-manual:
	@cd '$(srcdir)/doc' ; \
	  $(SHELL) ../build-aux/gendocs.sh -o '$(abs_builddir)/doc/manual' \
	    --email $(PACKAGE_BUGREPORT) $(PACKAGE) \
	    "$(PACKAGE_NAME) - $(manual_title)"
	@echo " *** Upload the doc/manual directory to web-cvs."
