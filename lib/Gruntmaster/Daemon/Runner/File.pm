package Gruntmaster::Daemon::Runner::File;

use 5.014000;
use strict;
use warnings;

use Gruntmaster::Daemon::Constants qw/WA/;
use File::Slurp qw/slurp/;
use Log::Log4perl qw/get_logger/;

our $VERSION = "5999-TRIAL";

##################################################

sub run{
  my ($test, $meta) = @_;
  get_logger->trace("Running on test $test...");
  $meta->{files}{prog}{run}->($meta->{files}{prog}{name}, fds => [qw/0 input 1 >output/], map {defined $meta->{$_} ? ($_ => $meta->{$_}) : () } qw/timeout olimit mlimit/);
  my $out = slurp 'output';
  my $ok = $meta->{okfile}[$test - 1];

  $out =~ s/^\s+//;
  $ok  =~ s/^\s+//;
  $out =~ s/\s+/ /;
  $ok  =~ s/\s+/ /;
  $out =~ s/\s+$//;
  $ok  =~ s/\s+$//;

  die [WA, "Wrong answer"] if $out ne $ok;
  $meta->{tests}[$test - 1] // 0
}

1;
__END__

=encoding utf-8

=head1 NAME

Gruntmaster::Daemon::Runner::File - Compare output with static text files

=head1 SYNOPSIS

  use Gruntmaster::Daemon::Runner::File;
  Gruntmaster::Daemon::Runner::File->run(5, $meta);

=head1 DESCRIPTION

Gruntmaster::Daemon::Runner::File is a runner which compares the program output for test C<$test> with C<< $meta->{tests}[$test - 1]>>. Before comparing, leading and trailing whitespace is removed, and sequences of whitespace are converted to a single space.

=head1 AUTHOR

Marius Gavrilescu E<lt>marius@ieval.roE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Marius Gavrilescu

This library is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.


=cut
