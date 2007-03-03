package Mail::LMLM::Types::Majordomo;

use strict;

use Mail::LMLM::Types::Base;

use vars qw(@ISA);

@ISA=qw(Mail::LMLM::Types::Base);

sub parse_args
{
    my $self = shift;

    my $args = shift;

    $args = $self->SUPER::parse_args($args);
    
    my (@left, $key, $value);

    while (scalar(@$args))
    {
        $key = shift(@$args);
        $value = shift(@$args);

        if ($key =~ /^-?(owner)$/)
        {
            $self->{'owner'} = $value;
        }
        else
        {
            push @left, $key, $value;
        }
    }

    return \@left;
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

    return ($self->get_group_base(), $self->get_hostname());
}

sub get_owner_address
{
    my $self = shift;

    return @{$self->{'owner'}};
}

sub render_mail_management
{
    my $self = shift;

    my $htmler = shift;
    my $begin_msg = shift;
    my $line_prefix = shift;

    $htmler->para($begin_msg . " write a message with the following line as body:");
    $htmler->indent_inc();
    $htmler->para(($line_prefix. " " . $self->get_group_base()), { 'bold' => 1});
    $htmler->indent_dec();
    $htmler->para("to the following address:");
    $htmler->indent_inc();
    $htmler->start_para();
    $htmler->email_address(
        "majordomo", $self->get_hostname()
        );
    $htmler->end_para();
    $htmler->indent_dec();

    return 0;
}

sub render_subscribe
{
    my $self = shift;

    my $htmler = shift;

    return $self->render_mail_management(
        $htmler,
        "To subscribe",
        "subscribe"
        );
}

sub render_unsubscribe
{
    my $self = shift;

    my $htmler = shift;

    return $self->render_mail_management(
        $htmler,
        "To unsubscribe",
        "unsubscribe"
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
