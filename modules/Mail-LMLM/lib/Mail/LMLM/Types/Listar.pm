package Mail::LMLM::Types::Listar;

use strict;

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

sub get_request_address
{
    my $self = shift;

    return $self->group_form("request");
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

sub render_sub_or_unsub
{
    my $self = shift;

    my $htmler = shift;

    my $command = shift;

    $htmler->para("Send a message containing the following line:");
    $htmler->indent_inc();
    $htmler->para("$command", {'bold' => 1});
    $htmler->indent_dec();
    $htmler->para("To the following address:");
    $htmler->indent_inc();
    $htmler->email_address(
        $self->get_request_address()
        );
    $htmler->indent_dec();
    
    return 0;    
}

sub render_subscribe
{
    my $self = shift;

    my $htmler = shift;

    return $self->render_sub_or_unsub($htmler, "subscribe");
}

sub render_unsubscribe
{
    my $self = shift;

    my $htmler = shift;

    return $self->render_sub_or_unsub($htmler, "unsubscribe");
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
