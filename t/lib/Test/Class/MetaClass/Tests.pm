package Test::Class::MetaClass::Tests;
use base qw(
	Test::Class::MetaClass
);

use strict;
use warnings;

# README: this file represents the template which your own Test::Class::MetaClass
# packages should emulate for all intended features of Test::Class::MetaClass

# Test::Class::MetaClass::Tests is empty as Test::Class::MetaClass provides
# its own tests in INIT {} but you should follow this example file when you
# partition your tests across several Test::Class::MetaClass packages for
# improved re-use and safety of tests

INIT {
	# declare Test::Class::MetaClass::randomize_method_name() based Test::Class
	# methods here i.e. startup, setup, test, teardown, shutdown
}

# declare regular Test::Class methods (not randomized) methods here i.e. startup,
# setup, test, teardown, shutdown.  These are legitimate targets for overriding,
# disabling etc. via symbol manipulation at the Class-level (only)

1;
