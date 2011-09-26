## no critic (RequireUseStrict)
package Net::Proxy::Connector::tcp_balance;

## use critic (RequireUseStrict)
use strict;
use warnings;

require Net::Proxy::Connector::tcp;
use base "Net::Proxy::Connector::tcp";

sub connect {
    my @params = @_;
    my ($self) = shift @params;
    for ( sort {int(rand(3))-1} @{$self->{hosts}} ) {
        $self->{host} = $_;
        my $sock = eval { $self->SUPER::connect(@params); };
        return $sock if $sock;
    }

}

1;

__END__

# ABSTRACT: A Net::Proxy connector for outbound tcp balancing and failover

=head1 SYNOPSIS

Net::Proxy::Connector::tcp_balance - connector for outbound tcp balancing and failover

=head1 SYNOPSIS

=over 4

    use Net::Proxy;
    use Net::Proxy::Connector::tcp_balance; # optional

    # proxy connections from localhost:6789 to remotehost:9876
    # using standard TCP connections
    my $proxy = Net::Proxy->new(
        {   in  => { type => 'tcp', port => '6789' },
            out => { type => 'tcp_balance', hosts => [ 'remotehost1', 'remotehost2' ], port => '9876' },
        }
    );

    # register the proxy object
    $proxy->register();

    # and now proxy connections indefinitely
    Net::Proxy->mainloop();

=back

=head1 DESCRIPTION 

C<Net::Proxy::Connector::tcp_balance> is an outbound tcp connector for C<Net::Proxy> that provides randomized load balancing and also provides failover when outbound tcp hosts are unavailable.

The capabilities of the C<Net::Proxy::Connector::tcp_balance> are otherwise identical to those C<Net::Proxy::Connector::tcp>

=head1 CONNECTOR OPTIONS

The connector accept the following options:

=head2 C<in>

=over 4

=item * host

The listening address. If not given, the default is C<localhost>.

=item * port

The listening port.

=back

=head2 C<out>

=over 4

=item * hosts

The remote hosts.  An array ref. 

=item * port

The remote port.

=item * timeout

The socket timeout for connection (C<out> only).

=back

=cut
