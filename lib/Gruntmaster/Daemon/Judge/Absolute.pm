package Gruntmaster::Daemon::Judge::Absolute;

use 5.014000;
use strict;
use warnings;

use Gruntmaster::Daemon::Constants qw/AC/;

our $VERSION = '5999-TRIAL';

##################################################

sub judge{
	my $result = pop;
	ref $result ? (result => $result->[0], result_text => $result->[1]) : (result => AC, result_text => 'Accepted')
}

1;
__END__
