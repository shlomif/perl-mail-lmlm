package Mail::LMLM::Types::Mailman;

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

        if ($key =~ /^-?(maintenance[-_]url)$/)
        {
            $self->{'maintenance_url'} = $value;
        }
        elsif ($key =~ /^-?(owner)$/)
        {
            $self->{'owner'} = $value;
        }
        else
        {
            push @left, $key, $value;
        }
    }

    return \@left;

    
    return $args;
}

sub get_maintenance_url
{
    my $self = shift;

    if (exists($self->{'maintenance_url'}))
    {
        return $self->{'maintenance_url'};
    }
    else
    {
        return $self->{'homepage'} . "mailman/listinfo/" . $self->get_group_base(). "/";
    }
        
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

sub get_post_address
{
    my $self = shift;

    return $self->group_form();
}

sub get_owner_address
{
    my $self = shift;

    return @{$self->{'owner'}};
}

sub render_maint_url
{
    my $self = shift;
    my $htmler = shift;
    
    $htmler->start_para();
    $htmler->text("Go to ");
    $htmler->url($self->get_maintenance_url(), "to the maintenance URL");
    $htmler->text(" and follow the instructions there.");
    $htmler->end_para();

    return 0;
}

sub render_subscribe
{
    my $self = shift;

    my $htmler = shift;

    return $self->render_maint_url($htmler);
}

sub render_unsubscribe
{
    my $self = shift;

    my $htmler = shift;

    return $self->render_maint_url($htmler);
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
