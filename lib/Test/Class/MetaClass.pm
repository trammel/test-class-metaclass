package Test::Class::MetaClass;
use base 'Test::Class';

use strict;
use warnings;

use Test::More qw();
use Test::Exception qw();

=pod

=head1 NAME

Test::Class::MetaClass

=head1 DESCRIPTION

Test::Class::MetaClass can be used for constructing Test::Class classes via
composition of granular, re-usable Sets of unit tests, unit test Fixtures etc.

A static Test::Class approach can result in a number of costs:

	1. Unit tests, fixtures etc. are not easily re-used where it would
	   be appropriate to do so (e.g. SubClasses; or other contexts where
	   that same code is consumed or executed).

	2. Re-use of unit tests can be achieved by building a Test::Class
	   inheritance hierarchy, but its structure is constrained and
	   directly coupled to the structure of the Classes/Packages being
	   tested (e.g. inheritance hierarchy or explicit order-of-consumption
	   in lib/).

	3. Ordinary subroutine declarations (in a Class/Package or its
	   Test::Class) can easily (and often silently) be overridden,
	   accidentally or otherwise!

Test::Class::MetaClass exists to directly prevent and resolve these issues,
by providing Test::Class method declarative wrappers which are called
from INIT { } immediately before run-time:

	1. Test::Class::MetaClass::predictable_method_name()
		* for 'test' methods

	2. Test::Class::MetaClass::randomize_method_name()
		* for 'startup', 'setup', 'teardown' or 'shutdown' methods

Both of these Test::Class method declaration helpers ensure that your
Test::Class methods are extremely unlikely to conflict with any other methods,
and are therefore extremely unlikely to be accidentally disabled or overridden.

Any Test::Class methods, or helper/data/paramaterisable methods, can be
declared as regular "sub { }" subroutines at compile-time, and therefore be
overridden (or disabled) by subsequent subroutine declarations.

Test::Class::MetaClass therefore B<partitions> the unit test SuperSet of
Test::Class methods, ensuring that each Set is self-contained and therefore
each Set of Test::Class methods is more likely to play nicely with others.

A traditional Test::Class approach can result in a parallel Test::Class
Inheritance Hierarchy, its structure matching (and being constrained by) the
existing structure or inheritance hierarchy of the Classes/Packages being
tested. This tight coupling creates an unnecessary maintenance burden, and
often prevents appropriate unit test structure and re-use, which takes away
time and focus from creating and maintaining the Classes/Packages being tested.

=cut

# declare all of your randomized or predictable Test::Class methods in INIT {}
INIT {
	# e.g. see t/lib/Test/Class/MetaClass/Tests.pm

	# ensure $self->disabled() lives, Test::Class::MetaClass::Tests is the only Class
	# with an excemption, as disabled() should only be called from within a Test::Class
	# declaration
	Test::Class::MetaClass::randomize_method_name(
		sub {
			my ($self) = @_;
			Test::Exception::lives_ok(sub { return Test::Class::MetaClass::disabled() }, '$self->disabled() lives');
			return;
		},
		'startup', 1, 'disabled_lives'
	);

	# test randomize_method_name() and predictable_method_name() with all Test::Class method types
	foreach my $type (qw(test startup setup teardown shutdown)) {

		Test::Class::MetaClass::randomize_method_name(
			sub {
				my ($self) = @_;
				Test::Exception::lives_ok(
					sub {
						Test::More::ok(1, "Test::Class::MetaClass::randomize_method_name() successfully generates a $type test method");
						return;
					},
					"Test::Class::MetaClass::randomize_method_name(sub {...}, $type, 1) lives"
				);
				return;
			},
			$type, 2, 'rumba_test_mixin_randomize_method_name_generated_' . $type . '_method'
		);

		Test::Class::MetaClass::predictable_method_name(
			sub {
				my ($self) = @_;
				Test::Exception::lives_ok(
					sub {
						Test::More::ok(1, "Test::Class::MetaClass::predictable_method_name() successfully generates a $type test method");
						return;
					},
					"Test::Class::MetaClass::predictable_method_name(sub {...}, $type, 1) lives"
				);
				return;
			},
			$type, 2, 'rumba_test_mixin_predictable_method_name_generated_' . $type . '_method'
		);

	}

	Test::Class::MetaClass::predictable_method_name(
		sub {
			my ($self) = @_;
			Test::More::ok($self->can('randomize_method_name'), "\$self->can('randomise_method_name')");
			Test::More::ok($self->can('predictable_method_name'), "\$self->can('predictable_method_name')");
		},
		'test', 2, 'can__randomize_method_name__and__predictable_method_name'
	);

	# $self->class() lives
	Test::Class::MetaClass::randomize_method_name(
		sub {
			my ($self) = @_;
			Test::Exception::lives_ok(sub { return $self->class() }, '$self->class() lives');
		},
		'startup', 1, 'self_class_lives'
	);

	# If we store all of our mocks in %{$self->{'mocks'}}, we can iterate
	# over them and $mock->unmock_all() in teardown as a fail-safe catch-all.
	Test::Class::MetaClass::randomize_method_name(
		sub {
			my ($self) = @_;
			if (exists $self->{'mocks'} and %{$self->{'mocks'}}) {
				foreach my $mock (keys %{$self->{'mocks'}}) {
					if (ref($mock) and $self->{'mocks'}->{$mock}->can('unmock_all')) {
						$self->{'mocks'}->{$mock}->unmock_all()
					}
				}
			}
		},
		'teardown', 0, 'unmock_helper'
	);

}

=pod

=head1 PUBLIC METHODS

=head2 I<class>

Abstract Method - override this in your B<Test::Class> Package B<ONLY>.

Return the name of the Package or Class, e.g. ref($self) or $self->meta->name()

*********************************************************
WARNING: never implement this in a Test::Class::MetaClass
*********************************************************

=cut

sub class { die "you must implement class() in a Test::Class and not in a Test::Class::MetaClass!" }

=pod

=head2 I<predictable_method_name()>

Generate a unique, but predictable, method name to prevent it from being
accidentally, overridden. Unlike randomize_method_name(), this helper
calculates a fairly predictable name across subsequent run-times that
a human can then use for debugging, or careful and explicit overriding:

	INIT {
		Test::Class::MetaClass::predictable_method_name(
			sub { Test::Exception::ok('foo' eq 'foo', 'foo is foo') },
			'test', 1, 'foo_tests_about_bah'
		);
	}

This is the preferred approach for declaring 'test' Test::Class methods to
ensure they are always run, and cannot easily be overridden or disabled. Use
this where a completely randomized method name is overkill e.g. in any
Test::Class methods which you may need to debug, or carefully override.

PARAMETERS

	REQUIRED: $subroutine
		subroutine reference (body of the new method)
	REQUIRED: $type
		Test::Class method type (test|startup|setup|teardown|shutdown)
	OPTIONAL: $number_of_tests
		number of tests executed within $subroutine, if any
		See add_testinfo() via `perldoc Test::Class`
	OPTIONAL: $name
		An English name for the set of tests, useful for debugging etc.
		as this becomes part of the new method name at run-time.

=cut

sub predictable_method_name {
	my ($subroutine, $type, $number_of_tests, $name) = @_;

	die "$subroutine is not a CODE ref" if (ref($subroutine) ne 'CODE');
	die "you must specify a valid test method type (startup|setup|test|teardown|shutdown), see Test::Class's add_testinfo()"
		if (not $type) or (
			($type ne 'startup') and ($type ne 'setup') and ($type ne 'test') and
			($type ne 'teardown') and ($type ne 'shutdown')
		);

	my ($package, $filename, $line) = caller();

	# private implementation so this can't be overridden
	local *_unused_method_name = sub {
		my $method_name = '_' . $package . '_' . $type . '_';
			$method_name .= $name if ($name); # optional, to maintain same interface as randomize_method_name()
			$method_name .= '_';
		my $integer = 1;
		while (1) {
			last if (not __PACKAGE__->can($method_name . $integer));
			$integer++;
		}
		return $method_name . $integer;
	};

	my $unusedMethodName = _unused_method_name();
	no strict 'refs';
	*{$unusedMethodName} = $subroutine;
	use strict 'refs';

	# Call add_testinfo() via the calling $package so that it's associated with the correct
	# package in Test::Class' internals, and is not associated with Test::Class::MetaClass itself
	$package->add_testinfo($unusedMethodName, $type, $number_of_tests);

	return;
}

=pod

=head2 I<randomize_method_name()>

Randomize a unqiue Test::Class method symbol, to make it hard to
disable or override the method, accidentally or deliberately:

	INIT {
		Test::Class::MetaClass::randomize_method_name(
			sub { Test::Exception::ok('foo' eq 'foo', 'foo is foo') },
			'test', 1
		);
	}

This is the preferred approach for declaring startup|setup|teardown|shutdown
Test::Class methods to ensure they are B<always> run and cannot easily be
disabled or accidentally overridden.

PARAMETERS

	REQUIRED: $subroutine
		subroutine reference (body of the new method)
	REQUIRED: $type
		Test::Class method type (test|startup|setup|teardown|shutdown)
	OPTIONAL: $number_of_tests
		# of tests executed within $subroutine, if any
		See add_testinfo() via `perldoc Test::Class`
	OPTIONAL: $name
		This is unused, it exists simply to maintain the same interface as
		predictable_method_name() so that Test::Class methods can be easily
		switched via s/predictable/randomized/ or vice-versa in their INIT
		declaration

=cut

sub randomize_method_name {
	my ($subroutine, $type, $number_of_tests, $name) = @_;

	die "$subroutine is not a CODE ref" if (ref($subroutine) ne 'CODE');
	die "you must specify a valid test method type (startup|setup|test|teardown|shutdown), see Test::Class's add_testinfo()"
		if (not $type) or (
			($type ne 'startup') and ($type ne 'setup') and ($type ne 'test') and
			($type ne 'teardown') and ($type ne 'shutdown')
		);

	my ($package, $filename, $line) = caller();

	# private implementation so this can't be overridden
	local *_unused_method_name = sub {
		# TODO randomize the randomisation algorithm ;)
		my $method_name = '_' . $package . '_' . $type . '_';
			$method_name .= $name . '_' if ($name); # optional, to maintain same interface as predictable_method_name()
			$method_name .= chr(int(rand(25) + 65)) . chr(int(rand(25) + 65)) .
				chr(int(rand(25) + 65)) . chr(int(rand(25) + 65));
		while (1) {
			last if (not __PACKAGE__->can($method_name));
			$method_name .= chr(int(rand(25) + 65));
		}
		return $method_name;
	};

	my $unusedMethodName = _unused_method_name();
	no strict 'refs';
	*{$unusedMethodName} = $subroutine;
	use strict 'refs';

	# Call add_testinfo() via the calling $package so that it's associated with the correct
	# package in Test::Class' internals, and is not associated with Test::Class::MetaClass itself
	$package->add_testinfo($unusedMethodName, $type, $number_of_tests);

	return;
}

=pod

=head2 I<disabled()>

Disable any Test::Class method B<in your Test::Class declaration> by aliasing
the original method to $self->disabled() e.g.

	sub test_some_things { shift->disabled(@_) };

This is a last resort, where it may preferable to TEMPORARILY disable a given
Test::Class method until the conflict, or failing test, can be investigated
and resolved. Ideally this means the original Test::Class method remains
intact, and any offending code is factored out or paramaterised.

******************************************************************************
WARNING: only alias a method to disabled() in a Test::Class Class declaration,
not in a Test::Class::MetaClass, so all disabled methods occur consistently at
a single layer (the Test::Class level) to keep them easy to find and manage.
******************************************************************************

=cut

sub disabled {

	return;

	# TODO implement a standard mechanism to ensure this type of method can
	# only be called at the Class level, and not within a Test::Class::MetaClass
	# This will keep all customisation of any consumed MetaClass at the Class
	# layer, so that we don't end up with MetaClass <-> MetaClass inter-dependencies
	my ($package, $filename, $line) = caller();

	die "disabled() was called by a Test::Class::MetaClass when it should only be called by a Test::Class Class"
		if ($package =~ /^Test::Class::MetaClass.*/ and $package !~ /^Test::Class::MetaClass::Tests$/);

	return;
}

=pod

=head1 BUT WHY?!?

Test::Class::MetaClass de-couples a given Class' unit tests from that 1 named
Class, making them available for re-use where appropriate e.g. by SubClasses,
orthogonal to inheritance, or in other contexts where that Package is consumed
and its code is executed.  This means you don't need to repeat, or copy'n'pate,
the same tests over and over again - you can re-use the test/fixture/helper and
parameterise any data.

Each Test::Class::MetaClass can be thought of as a Set of unit tests, fixtures,
helper methods, mocks etc. which can be safely and predictably combined with
1..N other Sets of unit tests, fixtures, helper methods, mocks etc. - where
each Set is-a Test::Class::MetaClass.

All Test::Class methods (startup, setup, test, teardown and shutdown) are
executed with 1 of 3 explicit levels of execution predictability, safety, and
non/overridability:

1. "Guaranteed to Execute"

	randomize_method_name() = randomized symbol, difficult to override

2. "Probably Executes"

	predictable_method_name() = semi-randomized symbol, more easily overridden)

3. "May Not Execute"

	sub foo : Tests { .. } = regular subroutine, easily overridden

=head1 MOCKS

Mocks instantiated and stored in %{$self->{'mocks'}} will automatically
receive a unmock_all() in Test::Class::MetaClass' default teardown, iff
they can('unmock_all').

For safety you should only mock() in a 'test' method, and get into the habit
of un-mocking at the end of that same 'test' method e.g. by calling local
helper methods e.g. _mock_foo() _unmock_foo().  This localises the mocks to
only the 'test' methods that require it, and avoids side-effects between
distinct 'test' methods.

=head1 SYNOPSIS

	package NameSpace::SuperClass::SubClass::Tests;
	use base qw(
		Test::Class::MetaClass
		NameSpace::SuperClass::Tests
		NameSpace::CommonFixtures
	); # note for overloading these are consumed in reverse order from bottom/end to top/start!

	use strict;
	use warnings;

	INIT {

		Test::Class::MetaClass::randomize_method_name(
			sub {
				my ($self) = @_;
				Test::More::use_ok('NameSpace::SuperClass::SubClass');
				return
			},
			'startup', 1, 'optional_startup_name'
		);

		Test::Class::MetaClass::predictable_method_name(
			sub {
				my ($self) = @_;
				Test::More::is(1, 1, 'etc');

				# mock something
				# test it
				# unmock it

				return
			},
			'test', 1, 'optional_test_name'
		);

	}

	sub class { return 'NameSpace::SuperClass::SubClass' }

	1;

=pod

=head1 TODO

Remove the need for named Test::Class and create an anonymous Class at
run-time in a standard (or dynamically created) .t

The list of relevent Test::Class::MetaClass declarations could therefore
become a static Class method, deprecating class() and further reducing the
amount of testing code that needs to be written and maintained e.g.

	package SuperClass::SubClass;
	sub tests { return qw(SuperClass::Tests SuperClass::SubClass::Tests) }
	1;

=head1 INSPIRATION

=head2 Traits

	"Traits: Composable Unit of Behaviour" by Nathanael Scharli, Stephane Ducasse, Oscar Nierstrasz,
	and Andrew P. Black.

	Proceedings of European Conference on Object-Oriented Programming (ECOOP'03), LNCS 2743 pp. 248 to 274,
	Springer Verlag, Berlin Heidelberg, July 2003

	http://scg.unibe.ch/research/traits

=head2 Test::Class

	https://metacpan.org/pod/Test::Class

=head1 COPYRIGHT

	Copyright (C) Resonance Labs, 2015-2016
	Niall Young <niall@iinet.net.au>

=head1 LICENSE

	This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.

=cut

1;
