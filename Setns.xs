#ifndef __linux
#error "No linux. Compile aborted."
#endif

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "sched.h"


MODULE = Linux::Setns		PACKAGE = Linux::Setns

SV * setns(int fd, int nstype)
	CODE:
		ST(0) = sv_newmortal();
			if(setns(fd, nstype) == 0) 
				sv_setiv(ST(0), 1);

