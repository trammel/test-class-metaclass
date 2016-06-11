package Test::Class::MetaClass;
use base 'Test::Class';

use strict;
use warnings;

=pod

=head1 NAME

	Test::Class::MetaClass

=head1 DESCRIPTION

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

=cut

INIT {

	# TODO Test::Class::MetaClass tests
	Test::Class::MetaClass::_randomize_method_name(
		sub {
			# _randomized_method_name tests
		},
		#meta
	);

	# TODO Test::Class::MetaClass tests
	Test::Class::MetaClass::_randomize_method_name(
		sub {
			# _predictable_method_name tests
		},
		#meta
	);

}

=pod

=head1 PRIVATE METHODS

=head2 _randomize_method_name

=cut

sub _randomize_method_name { }

=pod

=head2 _predictable_method_name

=cut

sub _predictable_method_name { }

=pod

=head1 USAGE

		1. Guaranteed to Execute, by way of symbol randomization

			INIT {

				Test::Class::MetaClass::_randomized_method_name(
					sub {
						# tests
					},
					# test meta
				);

			}

		2. Guaranteed to Execute, but predictable symbol (moderately safe but overridable)

			INIT {

				Test::Class::MetaClass::_predictable_method_name(
					sub {
						# tests
					},
					# test meta
				);

			}

		3. No Guarantee of Execution, easily overridable (regular Test::Class test subroutines)

			sub foo : Tests {
				# tests
			}

	Test::Class::MetaClass therefore Partitions up the Unit Test SuperSet of Test::Class methods,
	providing predictable and reliable safety where required, enforcing Test::Class fixtures and
	proper dismantling of Test::Class fixtures via startup, setup, teardown and shutdown, or simple
	Test::Class test methods which can easily be overridden by a subsequent Test::Class::MetaClass
	use import.

	A traditional Test::Class approach can result in a parallel Test::Class Inheritance Hierarchy,
	to the existing Inheritance Hierarchy of the Classes or Packages being tested.  This maintenance
	overhead is an unnecessary burden, taking focus and time away from creating and maintaining the
	Classes being tested.

=head1 COPYRIGHT

	Resonance Labs, 2016
	Niall Young <niall@iinet.net.au>

=head1 LICENSE

=head1 INSPIRATION

=head2 Traits

	"Traits: Composable Unit of Behaviour" by Nathanael Schärli, Stéphane Ducasse, Oscar Nierstrasz,
	and Andrew P. Black.

	Proceedings of European Conference on Object-Oriented Programming (ECOOP'03), LNCS 2743 p. 248—274,
	Springer Verlag, Berlin Heidelberg, July 2003

	http://scg.unibe.ch/research/traits

=head2 Test::Class

	https://metacpan.org/pod/Test::Class

=cut

1;
