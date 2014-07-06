package Log::Dispatch::ArrayWithLimits;

use 5.010001;
use warnings;
use strict;

use parent qw(Log::Dispatch::Output);

# DATE
# VERSION

sub new {
    my ($class, %args) = @_;
    my $self = {};
    $self->{array} = $args{array} // [];
    bless $self, $class;
    $self->_basic_init(%args);
    $self;
}

sub log_message {
    my $self = shift;
    my %args = @_;

    push @{$self->{array}}, $args{message};

    if (defined($self->{max_elems}) && @{$self->{array}} > $self->{max_elems}) {
        splice(@{$self->{array}}, 0, @{$self->{array}}-$self->{max_elems});
    }
}

1;
# ABSTRACT: Log to array, with some limits applied

=head1 SYNOPSIS

 use Log::Dispatch::ArrayWithLimits;

 my $file = Log::Dispatch::ArrayWithLimits(
     min_level     => 'info',
     array         => $ary,    # default: []
     max_elems     => 100,     # defaults unlimited
 );

 $file->log(level => 'info', message => "Your comment\n");


=head1 DESCRIPTION

This module functions similarly to L<Log::Dispatch::Array>, except that only the
messages are stored and there are some limits applied (currently only the
maximum number of elements in the array).

Logging to an in-process array can be useful when debugging/testing, or when you
want to let users of your program connect to your program to request viewing the
ogs being produced.


=head1 METHODS

=head2 new(%args)

Constructor. This method takes a hash of parameters. The following options are
valid: C<min_level> and C<max_level> (see L<Log::Dispatch> documentation);
C<array>, C<max_elems>.

=head2 log_message(message => STR)

Send a message to the appropriate output. Generally this shouldn't be called
directly but should be called through the C<log()> method (in
LLog::Dispatch::Output>).


=head1 TODO

max_total_len

max_age


=head1 SEE ALSO

L<Log::Dispatch>

L<Log::Dispatch::Array>

=cut
