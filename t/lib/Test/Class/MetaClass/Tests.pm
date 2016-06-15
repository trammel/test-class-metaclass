package Test::Class::MetaClass::Tests;
use base qw(
	Test::Class::MetaClass
);

use strict;
use warnings;

INIT {

	# ensure $self->disabled() lives, Test::Class::MetaClass::Tests is the only Class
	# with an excemption, as disabled() should only be called from within a Test::Class
	# declaration
	Test::Class::MetaClass::randomize_method_name(
		sub {
			my ($self) = @_;
			Test::Exception::lives_ok(sub { return $self->disabled() }, '$self->disabled() lives');
			return;
		},
		'startup', 1
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

}

sub class { return 'Test::Class::MetaClass' }

1;
