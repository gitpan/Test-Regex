package Test::Regex;

use warnings;
use strict;

use Test::Builder;

=head1 NAME

Test::Regex - Tests for regular expressions

=head1 VERSION

Version 0.01

EXTREMELY ALPHA

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Start of a module to do checking of captured expressions and other dollar vars.

=head1 WARNING

This is an extremely early release, just as a proof of concept to see
if anyone wants to nibble on it.  There's little testing on the results,
and even less error checking.  Please send your comments to perl-qa
mailing list at lists.perl.org.

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=cut

my $Test = Test::Builder->new;

sub import {
    my $self = shift;
    my $caller = caller;
    no strict 'refs';
    *{$caller.'::matches_are'} = \&matches_are;

    $Test->exported_to($caller);
    $Test->plan(@_);
}


=head1 FUNCTIONS

=head2 matches_are( $str, qr/regex/ [, var1=>result1... ] [, message ] )

Lets you check the dollar vars of your results

    matches_are( "dog food", qr/dog(.+)/, 1=>"food", "Matched OK" );

Eventually we'll handle the punc vars, but for now this will do.

=cut

sub matches_are {
    my $str = shift;
    my $re = shift;
    my @parms = @_;


    my @errors;
    my $re_matched = ( $str =~ $re );
    if ( !$re_matched ) {
        push( @errors, "Regex didn't match.  Subexpressions won't be checked." );
    }

    while ( @parms >= 2 ) {
        my $var = shift @parms;
        my $expected = shift @parms;
        my $value = eval("\$$var");

        # All special vars are crap if the re doesn't match.
        if ( $re_matched ) {
            if ( $value ne $expected ) {
                push( @errors, qq{\$$var is "$value", not "$expected"} );
            }
        }
    }
    my $msg = shift @parms;

    my $ok = !@errors;

    $Test->ok( $ok, $msg );
    $Test->diag( $_ ) for @errors;

    return $ok;
}


=head1 AUTHOR

Andy Lester, C<< <andy@petdance.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-test-regex@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.  I will be notified, and then you'll automatically
be notified of progress on your bug as I make changes.

=head1 ACKNOWLEDGEMENTS

Matthew Weigel for the inspiration and initial brainstorming.  RJBS for
his naming prowess.

=head1 COPYRIGHT & LICENSE

Copyright 2004 Andy Lester, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Test::Regex
