use inc::Module::Install;

name     'MooseX-Meta-Attribute-Lvalue';
all_from 'lib/MooseX/Meta/Attribute/Lvalue.pm';
author   'Christopher Brown <ctbrown@cpan.org>';

build_requires 'Test::More';

auto_install;

WriteAll;

