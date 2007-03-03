package Mail::LMLM::Types::Ezmlm;

use strict;

use Mail::LMLM::Types::Base;

use vars qw(@ISA);

@ISA=qw(Mail::LMLM::Types::Base);

sub parse_args
{
    my $self = shift;

    my $args = shift;

    $args = $self->SUPER::parse_args($args);
    
    return $args;
}

sub group_form
{
    my $self = shift;

    my $add = shift;

    return (
        ( $self->get_group_base() .
        ($add ? ("-" . $add) : "") )
        ,
        $self->get_hostname()
        );
}

sub get_subscribe_address
{
    my $self = shift;
    
    return $self->group_form("subscribe");
}

sub get_unsubscribe_address
{
    my $self = shift;

    return $self->group_form("unsubscribe");
}

sub get_post_address
{
    my $self = shift;

    return $self->group_form();
}

sub get_owner_address
{
    my $self = shift;

    return $self->group_form("owner");
}


sub render_something_with_email_addr
{
    my $self = shift;

    my $htmler = shift;
    my $begin_msg = shift;
    my $address_method = shift;

    
    $htmler->para($begin_msg);
    $htmler->indent_inc();
    $htmler->start_para();
    $htmler->email_address(
        $self->$address_method()
        );
    $htmler->end_para();
    $htmler->indent_dec();

    return 0;
}

sub render_subscribe
{
    my $self = shift;

    my $htmler = shift;

    return $self->render_something_with_email_addr(
        $htmler,
        "Send an empty mail message to the following address: ",
        \&get_subscribe_address
        );
}

sub render_unsubscribe
{
    my $self = shift;

    my $htmler = shift;

    return $self->render_something_with_email_addr(
        $htmler,
        "Send an empty mail message to the following address: ",
        \&get_unsubscribe_address
        );
}

sub render_post
{
    my $self = shift;

    my $htmler = shift;

    return $self->render_something_with_email_addr(
        $htmler,
        "Send your messages to the following address: ",
        \&get_post_address
        );
}

sub render_owner
{
    my $self = shift;

    my $htmler = shift;

    return $self->render_something_with_email_addr(
        $htmler,
        "Send messages to the mailing-list owner to the following address: ",
        \&get_owner_address
        );
}

1;
