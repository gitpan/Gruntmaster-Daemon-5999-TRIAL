package Gruntmaster::Daemon::Judge::Points;

use 5.014000;
use strict;
use warnings;

use Gruntmaster::Daemon::Constants qw/AC REJ/;
use List::Util qw/sum/;
use Log::Log4perl qw/get_logger/;

our $VERSION = '5999-TRIAL';

##################################################

sub judge{
  no warnings qw/numeric/;
  get_logger->trace("Judging results: @_");
  my $points = sum 0, grep { !ref } @_;
  $points == 100 ? (result => AC, result_text => 'Accepted') : (result => REJ, result_text => "$points points", points => $points)
}

1
