package Net::MundiPagg;
$Net::MundiPagg::VERSION = '0.000001';
use Moo;
use XML::Compile::SOAP11;
use XML::Compile::WSDL11;
use XML::Compile::Transport::SOAPHTTP;

use File::ShareDir qw{ module_file };

has 'client' => (
    is      => 'ro',
    builder => sub {
        my $wsdl = module_file( ref $_[0], 'mundipagg.wsdl' );
        my $client = XML::Compile::WSDL11->new($wsdl);

        foreach my $i ( 0 .. 2 ) {
            my $xsd = module_file( ref $_[0], "schema$i.xsd" );
            $client->importDefinitions($xsd);
        }

        $client->compileCalls;

        return $client;
    },
);

our $AUTOLOAD;

## no critic (Subroutines::RequireArgUnpacking)
## no critic (ClassHierarchies::ProhibitAutoloading)
sub AUTOLOAD {
    my ( $method, $self, %args ) = ( $AUTOLOAD, @_ );

    $method =~ s/.*:://g;

    return $self->client->call( $method, %args );
}

1;

#ABSTRACT: Net::MundiPagg - Documentation coming soon :)

__END__

=pod

=encoding UTF-8

=head1 NAME

Net::MundiPagg - Net::MundiPagg - Documentation coming soon :)

=head1 VERSION

version 0.000001

=head1 AUTHOR

Blabos de Blebe <blabos@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Blabos de Blebe.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
