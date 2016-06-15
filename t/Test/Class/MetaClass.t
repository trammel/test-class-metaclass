#!/usr/bin/env perl

use strict;
use warnings;

# TODO note this is pretty standard, so really we can generate all of our
# Test::Class instances on the fly, and the Set of 1..N Test::Class::MetaClass
# that apply to any given Class wrt testing could become a private Class/Package
# "static" Attribute or Method (as opposed to a Class Instance Attribute or Method)

use Test::Class::MetaClass::Tests;
Test::Class::MetaClass::Tests->runtests();

1;
