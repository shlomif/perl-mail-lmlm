use ExtUtils::MakeMaker;

my $dist_name = "Mail-LMLM";

WriteMakefile(
    'NAME' => 'Mail::LMLM',
    'DISTNAME' => $dist_name,
    'VERSION_FROM' => 'lib/Mail/LMLM.pm',
    );

use lib './lib';
require Mail::LMLM;

my $version = $Mail::LMLM::VERSION;

print "Generating the RPM SPEC file\n";
my $rpm_spec = "perl-${dist_name}.spec";
open I, "<$rpm_spec.in";
open O, ">$rpm_spec";
while (<I>)
{
    s!\[\[VERSION\]\]!$version!g;
    print O $_;
}
close(O);
close(I);
