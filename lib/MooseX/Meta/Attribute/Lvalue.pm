package MooseX::Meta::Attribute::Lvalue;
    

  our $VERSION = '0.03';
  our $AUTHORITY = 'cpan:CTBROWN';

  use Moose::Role;
  

    sub BUILD { } # This is a dummy version to support after.
                  # It gets overwritten if the major class has 
                  # a BUILD method

    after BUILD => sub { 
        $_[0]->_install_lvalue_writer;
    };


# INSTALLS a _lvalue_writer for the attribute all lvalue attributes
# This is done after the build statement
  sub _install_lvalue_writer {
    
        my ( $self, @args ) = @_;

        my %attributes = %{ $self->meta->get_attribute_map };
        while ( my ($name, $attribute) = each %attributes) {

            # use Data::Dumper;
            # print Dumper( $attribute );
            if ( 
                $attribute->does( 'MooseX::Meta::Attribute::Trait::Lvalue' ) 
                and $attribute->{ lvalue }
                and $attribute->_is_metadata eq 'rw'
            ) {

                $self->meta->add_method( 
                    $name, 
                    sub :lvalue {       
                        $_[0]->{ $name } 
                    } 
                );

             }
            
         }          
  }



package MooseX::Meta::Attribute::Trait::Lvalue;

    use Moose::Role;

    has 'lvalue' => (
      is  => 'rw' ,
      isa => 'Bool' ,
      predicate => 'has_lvalue' ,
    );


package Moose::Meta::Attribute::Custom::Trait::Lvalue;

  sub register_implementation { 
        'MooseX::Meta::Attribute::Trait::Lvalue' ;
  };


1;

__END__

=pod

=head1 NAME

MooseX::Meta::Attribute::Lvalue - Immplements lvalue accessors via meta-attribute trait

=head1 VERSION

Version 0.03

=head1 SYNOPSIS

    package App;
        use Moose;
        with 'MooseX::Meta::Attribute::Lvalue';

        has 'name' => (
            is          => 'rw' ,
            isa         => 'Str' ,
            required    => 1 ,
            traits => [ 'Lvalue' ] ,   # DO NOT FORGET THIS
            lvalue      => 1 
        );


    package main;
        my $app = App->new( name => 'Foo' );

        $app->name = "Bar";      
        print $app->name;       # Bar



=head1 DESCRIPTION

This package provides a Moose meta attribute via a role/trait that 
provides Lvalue accessors to your Moose attributes when the Lvalue is
true.    

Moose does not support lvalue accessors due to existing limitations in
the lvalue implementation.  Specifically, the lvalue accessors break
certain encapsulations.  However with many simple classes, you often 
don't care and would rather use the Lvalue syntax.  This module 
provides that functionality.

While the how/when the lvalue accessor gets built might change, the 
API will not likely change.

=head1 METHODS

=over 

=item _install_lvalue_writer

This method installs lvalue writers for those attributes that are:
1) rw
2) the attribute has a true lvalue 
3) the attribute does MooseX::Meta::Attribute::Trait::Lvalue

=item BUILD

This is just a dummy subroutine so that we can apply after, before methods

=back

=head1 EXPORT

None by default.


=head1 AUTHOR

Christopher Brown, C<< <cbrown at opendatagroup.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-moosex-attribute-lvalue at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-Attribute-Lvalue>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MooseX::Attribute::Lvalue


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooseX-Attribute-Lvalue>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooseX-Attribute-Lvalue>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MooseX-Attribute-Lvalue>

=item * Search CPAN

L<http://search.cpan.org/dist/MooseX-Attribute-Lvalue>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 Christopher Brown, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of MooseX::Attribute::Lvalue
