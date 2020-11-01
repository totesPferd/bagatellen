bin_PROGRAMS =  icor
icor_SOURCES = cmdline.c icor.c main.c
icor_CPPFLAGS = $(ICOR_CFLAGS)
icor_LDADD = $(ICOR_LIBS) -lm

if HAVE_HELP2MAN
man1_MANS = $(ax_help2man_MANS)
@AX_HELP2MAN_RULES@
endif
