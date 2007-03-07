use strict;
use warnings;

use Module::Build;

my $build = Module::Build->new(
    'module_name' => "Mail::LMLM",
    'requires' => 
    {
        'Test::More' => 0,
    },
    'license' => "bsd",
);
$build->create_build_script;

use lib './lib';
require Mail::LMLM;

my $version = $Mail::LMLM::VERSION;

print "Generating the RPM SPEC file\n";
my $rpm_spec = "perl-Mail-LMLM.spec";
# Remove the .spec because it's not writable.
unlink($rpm_spec);
open I, "<$rpm_spec.in";
open O, ">$rpm_spec";
while (<I>)
{
    s!\[\[VERSION\]\]!$version!g;
    print O $_;
}
close(O);
close(I);
