package Gruntmaster::Daemon::Runner::Interactive;

use 5.014000;
use strict;
use warnings;

use File::Slurp qw/slurp/;
use Gruntmaster::Daemon::Constants qw/WA/;
use Log::Log4perl qw/get_logger/;
use POSIX qw/mkfifo/;
use Try::Tiny;

our $VERSION = '5999-TRIAL';

##################################################

sub run{
  my ($test, $meta) = @_;
  get_logger->trace("Running on test $test...");

  mkfifo 'fifo1', 0600 or die $! unless -e 'fifo1';
  mkfifo 'fifo2', 0600 or die $! unless -e 'fifo2';

  my $ret = fork // get_logger->logdie("Fork failed: $!");
  if ($ret) {
	$meta->{files}{prog}{run}->($meta->{files}{prog}{name}, fds => [qw/0 fifo1 1 >fifo2/], map {defined $meta->{$_} ? ($_ => $meta->{$_}) : () } qw/timeout mlimit/);
	waitpid $ret, 0;
	die [WA, "Wrong Answer"] if $?;
  } else {
	try {
	  $meta->{files}{int}{run}->($meta->{files}{int}{name}, fds => [qw/1 >fifo1 0 fifo2 4 >result/]);
	} catch {
	  exit 1;
	};
	exit
  }

  scalar slurp 'result'
}

1
