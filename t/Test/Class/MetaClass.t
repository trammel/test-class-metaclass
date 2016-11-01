#!/usr/bin/env perl

use strict;
use warnings;

# README: this file represents the template which your own .t files
# should emulate for all intended features of Test::Class::MetaClass

# no more calling Test::Class->runtests(), you must call runtests()
# on your Test::Class::MetaClass super-set declared like below:
Test::Class::MetaClass::Test->runtests();

package Test::Class::MetaClass::Test;
use base qw(
	Test::Class::MetaClass
	Test::Class::MetaClass::Tests
);
# add any extra Test::Class::MetaClass packages above in the use base
# above. The use base qw() is evaluated in LIFO "reverse" order so you
# can override methods declared in the last package with any package
# above it in the list

use strict;
use warnings;

sub class { 'Test::Class::MetaClass::Test' }

# Class-level methods can be used to parameterise your MetaClass
# behaviours, or resolve a conflict, etc. at run-time e.g.

1;
