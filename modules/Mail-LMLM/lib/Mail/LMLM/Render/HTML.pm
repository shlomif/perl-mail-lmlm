package Mail::LMLM::Render::HTML;

use strict;

use vars qw(@ISA);

use Mail::LMLM::Render;

@ISA=qw(Mail::LMLM::Render);

sub initialize
{
    my $self = shift;

    my $out_file = shift;

    $self->{'out'} = $out_file;

    return 0;
}

sub htmlize_onechar
{
    my $c = shift;

    if ($c eq "<")
    {
        return "\&lt;";
    }
    elsif ($c eq ">")
    {
        return "\&gt;";
    }
    elsif ($c eq '&')
    {
        return "\&amp;"
    }
    elsif ($c eq "\n")
    {
        return "<br />";
    }
    else
    {
        return $c;
    }
}

sub htmlize
{
    my $text = shift;

    $text =~ s/(<|>|\&|\n)/&htmlize_onechar($1)/ge;

    return $text;
}

sub text
{
    my $self = shift;
    
    my $text = shift;

    my $style;
    
    if (scalar(@_))
    {
        $style = shift;    
    }
    else
    {
        $style = {};
    }

    my $out = htmlize($text);

    if ($style->{'bold'})
    {
        $out = "<b>".$out."</b>";
    }
    if ($style->{'underline'})
    {
        $out = "<u>".$out."</u>";
    }
    if ($style->{'italic'})
    {
        $out = "<i>".$out."</i>";
    }

    print {*{$self->{'out'}}} $out;

    return 0;
}

sub newline
{
    my $self = shift;

    print {*{$self->{'out'}}} "<br />\n" ;
}

sub indent_inc
{
    my $self = shift;

    print {*{$self->{'out'}}} "\n<div class=\"indent\">\n";

    return 0;
}

sub indent_dec
{
    my $self = shift;

    print {*{$self->{'out'}}} "\n</div>\n" ;

    return 0;
}

sub start_link
{
    my $self = shift;

    my $url = shift;

    print {*{$self->{'out'}}} "<a href=\"$url\">";

    return 0;
}

sub end_link
{
    my $self = shift;

    print {*{$self->{'out'}}} "</a>";

    return 0;
}

sub start_section
{
    my $self = shift;

    my $title = shift;

    my $options;
    
    if (scalar(@_))
    {
        $options = shift;
    }
    else
    {
        $options = {};
    }

    my $o = $self->{'out'};

    my $id_attr = "";
    if (exists($options->{'id'}))
    {
        $id_attr = " id=\"" . $options->{'id'} . "\"";
    }

    print {*{$o}} "<h2${id_attr}>";
    if (exists($options->{'title_url'}))
    {
        print {*{$o}} "<a href=\"" . $options->{'title_url'} . "\">" ;
    }
    $self->text($title);
    if (exists($options->{'title_url'}))
    {
        print {*{$o}} "</a>";
    }    
    print {*{$o}} "</h2>" ;
    print {*{$o}} "\n\n";
    

    return 0;
}

sub start_para
{
    my $self = shift;

    print {*{$self->{'out'}}}("<p>\n");

    return 0;
}

sub end_para
{
    my $self = shift;

    print {*{$self->{'out'}}}("\n</p>\n");

    return 0;
}

sub end_section
{
    my $self = shift;

    print {*{$self->{'out'}}}("\n\n");

    return 0;
}

sub start_document
{
    my $self = shift;

    my $head_title = shift;

    my $body_title = shift;
    
    my $o = $self->{'out'};

    print {*{$o}} <<"EOF" ;
<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html 
     PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US" lang="en-US">
<head>
<title>$head_title</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link rel="stylesheet" href="./style.css" type="text/css" />
</head>
<body>
EOF
        

    print {*{$o}}("<h1>");

    $self->text($body_title);

    print {*{$o}}("</h1>\n\n");

    return 0;
}

sub end_document
{
    my $self = shift;

    print {*{$self->{'out'}}}(
        "\n" .
        "</body>\n" .
        "</html>\n"
        );

    return 0;
}

sub horizontal_line
{
    my $self = shift;

    print {*{$self->{'out'}}}("\n\n<hr />\n\n");

    return 0;
}

1;

