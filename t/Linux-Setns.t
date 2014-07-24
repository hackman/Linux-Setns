# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl Linux-Setns.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More tests => 5;
BEGIN { use_ok('Linux::Setns') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

sub nsopen {
	my $nstype = $_[0];
	open my $F, '<', "/proc/$$/ns/$nstype" or die "Unable to open $nstype fd for pid $$\n";
	return $F;
}
my $FD;

SKIP: {
	skip "Should be root to test CLONE_ALL", 1 if $<;
	$FD = nsopen('mnt');
	is(&Linux::Setns::setns($FD, CLONE_ALL), 1);
};
SKIP: {
	skip "Should be root to test CLONE_NEWIPC", 1 if $<;
	$FD = nsopen('ipc');
	is(&Linux::Setns::setns($FD, CLONE_NEWIPC), 1);
};
SKIP: {
	skip "Should be root to test CLONE_NEWNET", 1 if $<;
	$FD = nsopen('net');
	is(&Linux::Setns::setns($FD, CLONE_NEWNET), 1);
};
SKIP: {
	skip "Should be root to test CLONE_NEWUTS", 1 if $<;
	$FD = nsopen('uts');
	is(&Linux::Setns::setns($FD, CLONE_NEWUTS), 1);
};

