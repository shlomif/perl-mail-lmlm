package Mail::LMLM::Types::Egroups;

use strict;

use Mail::LMLM::Types::Ezmlm;

use vars qw(@ISA);

@ISA=qw(Mail::LMLM::Types::Ezmlm);

sub initialize
{
    my $self = shift;

    $self->SUPER::initialize(@_);

    if (! exists($self->{'hostname'}) )
    {
        $self->{'hostname'} = "yahoogroups.com";
    }
}

sub get_homepage_hostname
{
    my $self = shift;

    return "groups.yahoo.com";
}

sub get_homepage
{
    my $self = shift;

    if ( exists($self->{'homepage'}) )
    {
        return $self->{'homepage'};
    }
    else
    {
        return "http://" . $self->get_homepage_hostname() . 
            "/group/" . $self->get_group_base() . "/";
    }
}

sub get_online_archive
{
    my $self = shift;

    if ( exists($self->{'online_archive'}) )
    {
        return $self->{'online_archive'};
    }
    else
    {
        return $self->get_homepage() . "messages/";
    }
}
