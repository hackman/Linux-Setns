#ifndef __linux
#error "No linux. Compile aborted."
#endif

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <errno.h>
#include <sched.h>
#define CLONE_ALL 0

#define InputStream	PerlIO *

MODULE = Linux::Setns		PACKAGE = Linux::Setns

SV * setns_wrapper(stream,nstype)
	InputStream	stream
	int			nstype
PPCODE:
	int fd = -1;
	ST(0) = sv_newmortal();
	fd = PerlIO_fileno(stream);
	if (setns(fd, nstype) == 0)
		XPUSHs(sv_2mortal(newSVnv(0)));
	else
		XPUSHs(sv_2mortal(newSVnv(errno)));
