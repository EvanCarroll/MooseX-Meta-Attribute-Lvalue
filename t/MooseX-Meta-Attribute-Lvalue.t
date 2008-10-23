#!perl 

use Test::More tests => 4;

BEGIN {
	use_ok( 'MooseX::Meta::Attribute::Lvalue' );
}

diag( "Testing MooseX::Meta::Attribute::Lvalue $MooseX::Meta::Attribute::Lvalue::VERSION, Perl $], $^X" );


{
    package App;
        use Moose;
        with 'MooseX::Meta::Attribute::Lvalue';

            has 'name' => ( 
                is => 'rw', isa => 'Str' , 
                traits => [ 'Lvalue' ] , 
                lvalue => 1 
            );

            has 'sign' => ( 
                is => 'rw' , 
                isa => 'Str', 
                lvalue => 0 , 
                traits => [ 'Lvalue' ] 
            );

}

package main;
my $app = App->new( name => 'frank', sign => 'pisces' );


isa_ok( $app, "App" );

eval { $app->name = "Ralph" } ;  # Will be changed 
ok( $app->name eq "Ralph", "Lvalue = 1" );

eval { $app->sign = "aries" };   # lvalue is 0, does not get changed
ok( $app->sign eq "pisces", "Lvalue = 0" );  



# print $app->name;
# print "has_method BUILD: " . $app->meta->has_method( 'BUILD' );
# print $app->meta->get_attribute( "name" )->{lvalue} ;
