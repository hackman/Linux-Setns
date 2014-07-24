package Linux::Setns;

use 5.018001;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Linux::Setns ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	setns CLONE_ALL CLONE_NEWIPC CLONE_NEWNET CLONE_NEWUTS
);

our $VERSION = '0.01';

use constant {
	CLONE_ALL => 0,
	CLONE_NEWIPC => 0x08000000,
	CLONE_NEWNET => 0x40000000,
	CLONE_NEWUTS => 0x04000000
};

require XSLoader;
XSLoader::load('Linux::Setns', $VERSION);

# Preloaded methods go here.

sub setns {
	my $ret = setns_wrapper($_[0], $_[1]);
	return 1 if ($ret == 0);
	if ($ret == 1) {
		print STDERR "Error: setns() The calling thread did not have the required privilege (CAP_SYS_ADMIN) for this operation\n";
		return 0;
	}
	if ($ret == 9) {
		print STDERR "Error: setns() fd is not a valid file descriptor\n";
		return 0;
	}
	if ($ret == 12) {
		print STDERR "Error: setns() Cannot allocate sufficient memory to change the specified namespace\n";
		return 0;
	}
	if ($ret == 22) {
		print STDERR "Error: setns() fd refers to a namespace whose type does not match that specified in nstype, or there is problem with reassociating the the thread with the specified namespace\n";
		return 0;
	}
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Linux::Setns - Perl extension for switching the current prcoess namespace to another namespace pointed by a file descriptor.

=head1 SYNOPSIS

	use Linux::Unshare qw(unshare :clone);

	die "setns() requires root privileges\n" if $<;

	open my $FD, '<', "/proc/PID/ns/mnt" or die "setns(): unable to open FD\n";

	setns($FD, CLONE_ALL);
	# now your process is in the same namespace as the $FD you have supplied
	# in this case, you have to previously know what is the type of namespace of that $FD

	setns($FD, CLONE_NEWIPC);
	# Switch your current IPC namespace to the one pointed by $FD
	setns($FD, CLONE_NEWNET);
	# Switch your current Network namespace to the one pointed by $FD
	setns($FD, CLONE_NEWUTC);
	# Switch your current UTS namespace to the one pointed by $FD

=head1 DESCRIPTION

This trivial module provides interface to the Linux setns system call. It
also provides the CLONE_* constants that are used to specify which kind of
namespace you are entering. Also a new CLONE_ALL constat is provided so you
can join/switch to any type of namespace.

The setns system call allows a process to 'join/switch' one of its namespaces
to namespace pointed by a file descriptor(usually located in /proc/PID/ns/{ipc,mnt,net,pid,user,uts}).

Note: keep in mind that using CLONE_NEWIPC, CLONE_NEWNET or CLONE_NEWUTS will fail if the FD is not of that type.

RETRUN VALUE
	1 on success
	0 on failure


=head2 EXPORT

 setns			- the subroutine

 CLONE_ALL		- flag that tells that the FD can be of any namespace type
 CLONE_NEWIPC	- when this flag is used the FD must be from a IPC namespace
 CLONE_NEWNET	- when this flag is used the FD must be from a Network namespace
 CLONE_NEWUTS	- when this flag is used the FD must be from a UTS namespace


=head1 SEE ALSO

setns(s) Linux man page.

=head1 AUTHOR

Marian HackMan Marinov, E<lt>hackman@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Marian HackMan Marinov

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
