# Configure template for GNU M4.			-*-Autoconf-*-
# Copyright (C) 1991, 1993, 1994, 2004, 2005, 2006, 2007, 2008, 2009
# Free Software Foundation, Inc.
#
# This file is part of GNU M4.
#
# GNU M4 is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# GNU M4 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

AC_PREREQ([2.60])
AC_INIT([GNU M4], m4_esyscmd([build-aux/git-version-gen .tarball-version]),
  [bug-m4@gnu.org])
AC_CONFIG_AUX_DIR([build-aux])

AM_INIT_AUTOMAKE([1.10.1 dist-bzip2 gnu])

m4_pattern_forbid([^M4_[A-Z]])

AC_CONFIG_SRCDIR([src/m4.h])
AC_CONFIG_HEADERS([lib/config.h:lib/config.hin])

AC_PROG_CC
M4_EARLY

# M4 is single-threaded; so we can optimize gnulib code by using this:
gl_DISABLE_THREADS

# Tandem/NSK is broken - it has 'long long int' but not
# 'unsigned long long int', which confuses assumptions made by gnulib.
# Simply pretend that neither type exists if both do not work.
AC_TYPE_LONG_LONG_INT
AC_TYPE_UNSIGNED_LONG_LONG_INT
if test $ac_cv_type_long_long_int:$ac_cv_type_unsigned_long_long_int = yes:no
then
  ac_cv_type_long_long_int=no
  AC_DEFINE([HAVE_LONG_LONG_INT], 0,
    [Define to 1 if the system has the type `long long int'.])
fi

M4_INIT

AC_CACHE_CHECK([whether an open file can be renamed],
  [M4_cv_func_rename_open_file_works],
  [AC_RUN_IFELSE([AC_LANG_PROGRAM([AC_INCLUDES_DEFAULT],
      [FILE *f = fopen ("conftest.1", "w+");
       int result = rename ("conftest.1", "conftest.2");
       fclose (f); remove ("conftest.1"); remove ("conftest.2");
       return result;])],
    [M4_cv_func_rename_open_file_works=yes],
    [M4_cv_func_rename_open_file_works=no],
    [M4_cv_func_rename_open_file_works='guessing no'])])
if test "$M4_cv_func_rename_open_file_works" = yes ; then
  M4_rename_open_works=1
else
  M4_rename_open_works=0
fi
AC_DEFINE_UNQUOTED([RENAME_OPEN_FILE_WORKS], [$M4_rename_open_works],
  [Define to 1 if a file can be renamed while open, or to 0 if not.])

dnl Don't let changeword get in our way, if bootstrapping with a version of
dnl m4 that already turned the feature on.
m4_ifdef([changeword], [m4_undefine([changeword])])dnl

AC_MSG_CHECKING([[if changeword is wanted]])
AC_ARG_ENABLE([changeword],
  [AS_HELP_STRING([--enable-changeword],
     [enable -W and changeword() builtin])],
  [if test "$enableval" = yes; then
    AC_MSG_RESULT([yes])
    AC_DEFINE([ENABLE_CHANGEWORD], [1],
      [Define to 1 if the changeword(REGEXP) functionality is wanted])
  else
    AC_MSG_RESULT([no])
  fi], [AC_MSG_RESULT([no])])

AC_MSG_CHECKING([[which shell to use for syscmd]])
AC_ARG_WITH([syscmd-shell],
  [AS_HELP_STRING([--with-syscmd-shell], [shell used by syscmd [/bin/sh]])],
  [case $withval in
    yes[)] with_syscmd_shell=no;;
   esac], [with_syscmd_shell=no])
if test "$with_syscmd_shell" = no ; then
  with_syscmd_shell=/bin/sh
  if test "$cross_compiling" != yes ; then
dnl Give mingw a default that is more likely to be available.
    AS_IF([AS_EXECUTABLE_P([/bin/sh])], [],
      [if (cmd /c) 2>/dev/null; then with_syscmd_shell=cmd; fi])
dnl Too bad _AS_PATH_WALK is not public.
    M4_save_IFS=$IFS; IFS=$PATH_SEPARATOR
    for M4_dir in `if (command -p getconf PATH) 2>/dev/null ; then
	command -p getconf PATH
      else
	echo "/bin$PATH_SEPARATOR$PATH"
      fi`
    do
      IFS=$M4_save_IFS
      test -z "$M4_dir" && continue
      AS_EXECUTABLE_P(["$M4_dir/sh"]) \
	&& { with_syscmd_shell=$M4_dir/sh; break; }
    done
    IFS=$M4_save_IFS
  fi
fi
AC_MSG_RESULT([$with_syscmd_shell])
AC_DEFINE_UNQUOTED([SYSCMD_SHELL], ["$with_syscmd_shell"],
  [Shell used by syscmd and esyscmd, must accept -c argument.])

M4_WITH_DMALLOC

AC_CONFIG_COMMANDS([stamp-h], [[test -z "$CONFIG_HEADERS" || date > stamp-h]])

AC_CONFIG_FILES([Makefile
		 doc/Makefile
		 lib/Makefile
		 src/Makefile
		 tests/Makefile
		 checks/Makefile
		 examples/Makefile
])

AC_OUTPUT
