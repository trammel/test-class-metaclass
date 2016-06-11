Test::Class::MetaClass

Test::Class::MetaClass enables simple de-coupling of a Class' Unit Tests from 1 Static Class.
This enables re-use of all Unit Tests, by all of the Class' SubClasses, Consumers or any
context in which the Class or Package's symbols are consumed, imported or executed.

Unit Tests orthogonal to Inheritance.  This enables testability of, and compliance to,
Liskov Substitutability.  It also enables fine-grained, predictable, and safe composition and
re-use of Test::Class based Unit Tests.

Each Test::Class::MetaClass can be thought of as a Set of Unit Tests, which can be safely and
predictably combined with 1..N other Sets of Unit Tests, where each Set is-a Test::Class::MetaClass

All Test::Class methods (startup, setup, test, teardown and shutdown) are executed with 1 of 3
distinct levels of execution predictability, safety, and non/overridability:

	1. "Guaranteed to Execute", by way of symbol randomization (difficult to override)
	2. "Probably Executes", but predictable symbol (moderately safe but overridable)
	3. "May Not Execute", an easily overridable sub : Test { } Test::Class test subroutine

HOW TO USE

	package Class::Test::MetaClass;
	use base 'Test::Class::MetaClass';

	INIT {
		# protected Test::Class::MetaClass test declarations
	}

	sub foo : Tests {
		# ordinary Test::Class test declarations
	}

	1;

1. "Guaranteed to Execute", by way of symbol randomization (difficult to override, not impossible):

	INIT {

		Test::Class::MetaClass::_randomized_method_name(
			sub {
				# tests
			},
			# test meta
		);

	}

2. "Probably Executes", by way of predictable symbol (moderately safe, but overridable):

	INIT {

		Test::Class::MetaClass::_predictable_method_name(
			sub {
				# tests
			},
			# test meta
		);

	}

3. "May Not Execute", easily overridable (regular Test::Class test subroutines)

	sub foo : Tests {
		# tests
	}

Test::Class::MetaClass therefore Partitions up the total Unit Tests, the SuperSet of Test::Class
methods, providing predictable and reliable safety where required, enforcing Test::Class fixtures
and proper dismantling of Test::Class fixtures via startup, setup, teardown and shutdown, or simple
Test::Class test methods which can easily be overridden by a subsequent Test::Class::MetaClass
use import.

A traditional Test::Class approach can result in a parallel Test::Class Inheritance Hierarchy,
in addition to an existing Inheritance Hierarchy: the Classes or Packages being tested.  Coupling
directly to the Classes constrains Unit Test Re-Use and created an unnecessary burden of ongoing
code complexity and maintenance when the underlying Classes or Packages change e.g. the order in
which packages are imported changes; or their inheritance hierarchy changes; or a Test::Class test
method is accidentally, mistakenly or silenting overriding another Test::Class test method which
should not be disabled or overridden. This may be obvious, or it may be non-obvious, hidden or
simply overlooked.  Maintaining this tightly coupled relationship, between 1 Class and its Unit
Tests, locks us into a given Inheritance Hierarchy all the more rigidly, and it takes away time
and focus from creating and maintaining Application Classes and Packages.

COPYRIGHT

	Resonance Labs, 2016
	Niall Young <niall@iinet.net.au>

INSPIRATIONS

	Test::Class

		https://metacpan.org/pod/Test::Class

	Traits

		"Traits: Composable Unit of Behaviour" by Nathanael Schärli, Stéphane Ducasse, Oscar Nierstrasz,
		and Andrew P. Black.

		Proceedings of European Conference on Object-Oriented Programming (ECOOP'03), LNCS 2743 p. 248�274,
		Springer Verlag, Berlin Heidelberg, July 2003

		http://scg.unibe.ch/research/traits
