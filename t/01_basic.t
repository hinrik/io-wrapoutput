use strict;
use warnings FATAL => 'all';
use Test::More tests => 3;
BEGIN { use_ok('IO::WrapOutput') }

open my $orig_stdout, '>&', STDOUT or BAIL_OUT("Can't dup STDOUT: $!");
open my $orig_stderr, '>&', STDERR or BAIL_OUT("Can't dup STDERR: $!");

$SIG{ALRM} = sub { die "Timed out\n" };
alarm 5;
my ($new_stdout, $new_stderr) = wrap_output();

print "Test out\n";
warn "Test err\n";
my $new_out = readline($new_stdout);
my $new_err = readline($new_stderr);

unwrap_output();
alarm 0;

is($new_out, "Test out\n", 'Got piped STDOUT');
is($new_err, "Test err\n", 'Got piped STDERR');
