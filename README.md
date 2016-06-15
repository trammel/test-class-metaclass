# NAME

	Test::Class::MetaClass

# DESCRIPTION

	Test::Class::MetaClass can be used for constructing Test::Class classes
	via composition of granular, re-usable Sets of unit tests, unit test
	Fixtures etc.

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

	Test::Class::MetaClass exists to directly prevent and resolve these
	issues, by providing Test::Class method declarative wrappers which are
	called from INIT { } at run-time:

		1. Test::Class::MetaClass::predictable_method_name()
			* for 'test' methods

		2. Test::Class::MetaClass::randomize_method_name()
			* for 'startup', 'setup', 'teardown' or 'shutdown' methods

	Both of these Test::Class method declaration helpers ensure that your
	Test::Class methods are extremely unlikely to conflict with any other
	methods, and are therefore extremely unlikely to be accidentally
	disabled or overridden.

	Any Test::Class methods, or helper/data/paramaterisable methods, can be
	declared as regular "sub { }" subroutines at compile-time, and
	therefore be overridden (or disabled) by subsequent subroutine
	declarations.

	Test::Class::MetaClass therefore ppaarrttiittiioonnss the unit test SuperSet of
	Test::Class methods, ensuring that each Set is self-contained and
	therefore each Set of Test::Class methods is more likely to play nicely
	with others.

	A traditional Test::Class approach can result in a parallel Test::Class
	Inheritance Hierarchy, its structure matching (and being constrained
	by) the existing structure or inheritance hierarchy of the
	Classes/Packages being tested. This tight coupling creates an
	unnecessary maintenance burden, and often prevents appropriate unit
	test structure and re-use, which takes away time and focus from
	creating and maintaining the Classes/Packages being tested.

# BUT WHY?!?

	Test::Class::MetaClass de-couples a given Class' unit tests from that 1
	named Class, making them available for re-use where appropriate e.g. by
	SubClasses, orthogonal to inheritance, or in other contexts where that
	Package is consumed and its code is executed.  This means you don't
	need to repeat, or copy'n'pate, the same tests over and over again -
	you can re-use the test/fixture/helper and parameterise any data.

	Each Test::Class::MetaClass can be thought of as a Set of unit tests,
	fixtures, helper methods, mocks etc. which can be safely and
	predictably combined with 1..N other Sets of unit tests, fixtures,
	helper methods, mocks etc. - where each Set is-a
	Test::Class::MetaClass.

	All Test::Class methods (startup, setup, test, teardown and shutdown)
	are executed with 1 of 3 explicit levels of execution predictability,
	safety, and non/overridability:

	1. "Guaranteed to Execute"

		randomize_method_name() = randomized symbol, difficult to override

	2. "Probably Executes"

		predictable_method_name() = semi-randomized symbol, more easily overridden)

	3. "May Not Execute"

		sub foo : Tests { .. } = regular subroutine, easily overridden

# INSPIRATION

	Traits

		"Traits: Composable Unit of Behaviour" by Nathanael Scharli, Stephane Ducasse, Oscar Nierstrasz,
		and Andrew P. Black.

		Proceedings of European Conference on Object-Oriented Programming (ECOOP'03), LNCS 2743 pp. 248 to 274,
		Springer Verlag, Berlin Heidelberg, July 2003

		http://scg.unibe.ch/research/traits

	Test::Class

		https://metacpan.org/pod/Test::Class

# COPYRIGHT

	Copyright (C) Resonance Labs, 2015-2016
	Niall Young <niall@iinet.net.au>

# LICENSE

	This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
