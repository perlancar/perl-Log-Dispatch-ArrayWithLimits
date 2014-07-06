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
    if (!ref($self->{array})) {
        no strict 'refs';
        say "$self->{array}";
        $self->{array} = \@{"$self->{array}"};
    }
    $self->{max_elems} = $args{max_elems} // undef;
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
     array         => $ary,    # default: [], you can always refer by name e.g. 'My::array' to refer to @My::array
     max_elems     => 100,     # defaults unlimited
 );

 $file->log(level => 'info', message => "Your comment\n");


=head1 DESCRIPTION

This module functions similarly to L<Log::Dispatch::Array>, with a few
differences:

=over

=item * only the messages (strings) are stored

=item * allow specifying array variable name (e.g. "My::array" instead of \@My:array)

This makes it possible to use in L<Log::Log4perl> configuration, which is a text
file.

=item * can apply some limits

Currently only max_elems (the maximum number of elements in the array) is
available. Future limits will be added (see L</"TODO">).

=back

Logging to an in-process array can be useful when debugging/testing, or when you
want to let users of your program connect to your program to request viewing the
ogs being produced.


=head1 METHODS

=head2 new(%args)

Constructor. This method takes a hash of parameters. The following options are
valid: C<min_level> and C<max_level> (see L<Log::Dispatch> documentation);
C<array> (a reference to an array, or if value is string, will be taken as name
of array variable; this is so this module can be used/configured e.g. by
L<Log::Log4perl> because configuration is specified via a text file),
C<max_elems>.

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
