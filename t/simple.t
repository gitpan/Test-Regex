use Test::More tests => 3;

BEGIN {
use_ok( 'Test::Regex' );
}

matches_are( "dog food", qr/dog\s*(.+)/, 1=>"food" );
matches_are( "dog food", qr/dog\s*(.+)/, 1=>"food", "Matched" );
