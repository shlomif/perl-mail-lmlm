package Mail::LMLM::Types::Base;

use strict;

use Mail::LMLM::Object;

use vars qw(@ISA);

@ISA=qw(Mail::LMLM::Object);

sub parse_args
{
    my $self = shift;

    my $args = shift;

    my (@left, $key, $value);

    while (scalar(@$args))
    {
        $key = shift(@$args);
        $value = shift(@$args);
        if ($key =~ /^-?(id)$/)
        {
            $self->{'id'} = $value;
        }
        elsif ($key =~ /^-?(group_base)$/)
        {
            $self->{'group_base'} = $value;
        }
        elsif ($key =~ /^-?(desc|description)$/)
        {
            $self->{'description'} = $value;
        }
        elsif ($key =~ /^-?(hostname|host)$/)
        {
            $self->{'hostname'} = $value;
        }
        elsif ($key =~ /^-?(homepage)$/)
        {
            $self->{'homepage'} = $value;
        }
        elsif ($key =~ /^-?(online_archive)$/)
        {
            $self->{'online_archive'} = $value;
        }
        elsif ($key =~ /^-?(guidelines)$/)
        {
            $self->{'guidelines'} = $value;
        }
        elsif ($key =~ /^-?(notes)$/)
        {
            $self->{'notes'} = $value;            
        }
        else
        {
            push @left, $key, $value;
        }
    }

    return (\@left);
}

sub initialize
{
    my $self = shift;

    $self->parse_args([@_]);

    return 0;
}

sub get_id
{
    my $self = shift;

    return $self->{'id'};
}

sub get_description
{
    my $self = shift;

    return $self->{'description'};
}

sub get_homepage
{
    my $self = shift;

    return $self->{'homepage'};
}

sub get_group_base
{
    my $self = shift;

    return $self->{'group_base'};
}

sub get_hostname
{
    my $self = shift;

    return $self->{'hostname'};
}

sub get_online_archive
{
    my $self = shift;

    return $self->{'online_archive'};
}

sub get_guidelines
{
    my $self = shift;

    return $self->{'guidelines'};
}

sub render_subscribe
{
    my $self = shift;

    my $htmler = shift;

    return 0;
}

sub render_unsubscribe
{
    my $self = shift;

    my $htmler = shift;

    return 0;
}

sub render_post
{
    my $self = shift;

    my $htmler = shift;

    return 0;
}

sub render_owner
{
    my $self = shift;

    my $htmler = shift;

    return 0;
}

sub render_none
{
    my $self = shift;

    my $htmler = shift;

    $htmler->para("None.");

    return 0;
}

sub render_homepage
{
    my $self = shift;

    my $htmler = shift;

    my $homepage = $self->get_homepage();

    if ($homepage)
    {
        $htmler->start_para();
        $htmler->url($homepage);
        $htmler->end_para();
    }
    else
    {
        $self->render_none($htmler);
    }
    
    return 0;
}

sub render_online_archive
{
    my $self = shift;

    my $htmler = shift;

    my $archive = $self->get_online_archive();

    if (ref($archive) eq "CODE")
    {
        $archive->($self, $htmler);
    }
    elsif (ref($archive) eq "")
    {
        $htmler->start_para();
        $htmler->url($archive);
        $htmler->end_para();
    }
    else
    {
        $self->render_none($htmler);
    }

    return 0;
}


sub render_field
{
    my $self = shift;

    my $htmler = shift;

    my $desc = shift;

    if (ref($desc) eq "CODE")
    {
        $desc->($self, $htmler);
    }
    elsif (ref($desc) eq "ARRAY")
    {
        foreach my $paragraph (@$desc)
        {
            $htmler->para(
                $paragraph
            );
        }
    }
    elsif (ref($desc) eq "")
    {
        $htmler->para(
            $desc
            );
    }
    return 0;
}

sub render_description
{
    my $self = shift;
    my $htmler = shift;
    $self->render_field($htmler,$self->get_description());
}

sub render_guidelines
{
    my $self = shift;
    my $htmler = shift;
    $self->render_field($htmler,$self->get_guidelines());
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

1;
