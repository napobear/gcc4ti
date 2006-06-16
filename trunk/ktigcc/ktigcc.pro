TEMPLATE	= app
LANGUAGE	= C++

CONFIG	+= qt warn_on debug

LIBS	+= -lktexteditor -lqassistantclient -lkutils

HEADERS	+= tpr.h \
	ktigcc.h \
	preferences.h

SOURCES	+= ktigcc.cpp \
	preferences.cpp \
	tpr.cpp

FORMS	= mainform.ui \
	projectoptions.ui \
	programoptions.ui \
	preferencesdlg.ui

IMAGES	= images/00 \
	images/01 \
	images/02 \
	images/03 \
	images/04 \
	images/05 \
	images/06 \
	images/07 \
	images/08 \
	images/09 \
	images/10 \
	images/11 \
	images/12 \
	images/13 \
	images/14 \
	images/15 \
	images/16 \
	images/17 \
	images/18 \
	images/19 \
	images/20 \
	images/21 \
	images/22 \
	images/23 \
	images/24 \
	images/25 \
	images/26 \
	images/27 \
	images/tpr.png \
	images/folder1.png \
	images/folder2.png \
	images/filec.png \
	images/fileh.png \
	images/fileo.png \
	images/files.png \
	images/filet.png \
	images/filex.png

unix {
  UI_DIR = .ui
  MOC_DIR = .moc
  OBJECTS_DIR = .obj
}

KDEPREFIX = $$system(kde-config --prefix)
isEmpty(KDEPREFIX):error(KDE 3 kdelibs required.)

exists($$KDEPREFIX/include/kde3) {
  INCLUDEPATH += $$KDEPREFIX/include/kde3
} else:exists($$KDEPREFIX/include/kde) {
  INCLUDEPATH += $$KDEPREFIX/include/kde
} else {
  INCLUDEPATH += $$KDEPREFIX/include
}

KDELIBDIR = $$KDEPREFIX/lib$$system(kde-config --libsuffix)

!equals(KDELIBDIR,/usr/lib):!equals(KDELIBDIR,/usr/lib64) {
  LIBS += -L"$$KDELIBDIR" -Wl,--rpath,"$$KDELIBDIR"
}

GLIB2_MINVERSION = 2.0.0
HAVE_GLIB2 = $$system(pkg-config --atleast-version=$$GLIB2_MINVERSION glib-2.0 && echo yes || echo no)
!equals(HAVE_GLIB2,yes):error(glib2 $$GLIB2_MINVERSION or higher required.)
PKGCONFIG_CFLAGS += $$system(pkg-config --cflags glib-2.0)
LIBS += $$system(pkg-config --libs glib-2.0)

TICONV_MINVERSION = 0.0.1
HAVE_TICONV = $$system(pkg-config --atleast-version=$$TICONV_MINVERSION ticonv && echo yes || echo no)
!equals(HAVE_TICONV,yes):error(libticonv $$TICONV_MINVERSION or higher required.)
PKGCONFIG_CFLAGS += $$system(pkg-config --cflags ticonv)
LIBS += $$system(pkg-config --libs ticonv)

TICABLES_MINVERSION = 0.0.1
HAVE_TICABLES = $$system(pkg-config --atleast-version=$$TICABLES_MINVERSION ticables2 && echo yes || echo no)
!equals(HAVE_TICABLES,yes):error(libticables2 $$TICABLES_MINVERSION or higher required.)
PKGCONFIG_CFLAGS += $$system(pkg-config --cflags ticables2)
LIBS += $$system(pkg-config --libs ticables2)

syntaxfiles.path = /usr/share/apps/katepart/syntax/
syntaxfiles.files = gnuasm68k.xml masm68k.xml
INSTALLS += syntaxfiles

TIGCC = $$(TIGCC)
isEmpty(TIGCC) {
  TIGCC = /usr/local/tigcc
}
executable.path = $$TIGCC/bin
executable.files = ktigcc
INSTALLS += executable

QMAKE_CXXFLAGS_DEBUG = -Os -g -Wno-non-virtual-dtor $$PKGCONFIG_CFLAGS
QMAKE_CXXFLAGS_RELEASE = -Os -s -fomit-frame-pointer -Wno-non-virtual-dtor $$PKGCONFIG_CFLAGS

QMAKE_LFLAGS_RELEASE = -s

DISTFILES += $${syntaxfiles.files} configure COPYING KTIGCC.prj

distbz2.target = dist-bzip2
distbz2.commands = zcat ktigcc.tar.gz | bzip2 --best -c > ktigcc.tar.bz2
distbz2.depends = dist	
QMAKE_EXTRA_UNIX_TARGETS += distbz2
