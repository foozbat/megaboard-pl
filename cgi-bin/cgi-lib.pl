
#!/usr/local/bin/perl

# Perl Routines to Manipulate CGI input
# S.E.Brenner@bioc.cam.ac.uk
# $Header: /cys/people/seb1005/http/cgi-bin/RCS/cgi-lib.pl,v 1.7 1994/11/04 00:17:17 seb1005 Exp $
#
# Copyright 1994 Steven E. Brenner
# Unpublished work.
# Permission granted to use and modify this library so long as the
# copyright above is maintained, modifications are documented, and
# credit is given for any use of the library.
#
# Thanks are due to many people for reporting bugs and suggestions
# especially Meng Weng Wong, Maki Watanabe, Bo Frese Rasmussen,
# Andrew Dalke, Mark-Jason Dominus and Dave Dittrich.

# see http://www.seas.upenn.edu/~mengwong/forms/   or
#     http://www.bio.cam.ac.uk/web/                for more information

# Minimalist http form and script (http://www.bio.cam.ac.uk/web/minimal.cgi):
# if (&MethGet) {
#   print &PrintHeader,
#       '<form method=POST><input type="submit">Data: <input name="myfield">';
# } else {
#   &ReadParse(*input);
#   print &PrintHeader, &PrintVariables(%input);
# }


# MethGet
# Return true if this cgi call was using the GET request, false otherwise
# Now that cgi scripts can be put in the normal file space, it is useful
# to combine both the form and the script in one place with GET used to
# retrieve the form, and POST used to get the result.

sub MethGet {
  return ($ENV{'REQUEST_METHOD'} eq "GET");
}

# ReadParse
# Reads in GET or POST data, converts it to unescaped text, and puts
# one key=value in each member of the list "@in"
# Also creates key/value pairs in %in, using '\0' to separate multiple
# selections

# If a variable-glob parameter (e.g., *cgi_input) is passed to ReadParse,
# information is stored there, rather than in $in, @in, and %in.

sub ReadParse {
    local (*in) = @_ if @_;


  local ($i, $loc, $key, $val);

  # Read in text
  if ($ENV{'REQUEST_METHOD'} eq "GET") {
    $in = $ENV{'QUERY_STRING'};
  } elsif ($ENV{'REQUEST_METHOD'} eq "POST") {
    read(STDIN,$in,$ENV{'CONTENT_LENGTH'});
  }

  @in = split(/&/,$in);

  foreach $i (0 .. $#in) {
    # Convert plus's to spaces
    $in[$i] =~ s/\+/ /g;

    # Split into key and value.
    ($key, $val) = split(/=/,$in[$i],2); # splits on the first =.

    # Convert %XX from hex numbers to alphanumeric
    $key =~ s/%(..)/pack("c",hex($1))/ge;
    $val =~ s/%(..)/pack("c",hex($1))/ge;

    # Associate key and value
    $in{$key} .= "\0" if (defined($in{$key})); # \0 is the multiple separator
    $in{$key} .= $val;

  }

  return 1; # just for fun
}

# PrintHeader
# Returns the magic line which tells WWW that we're an HTML document

sub PrintHeader {
  return "Content-type: text/html\n\n";
}

# PrintVariables
# Nicely formats variables in an associative array passed as a parameter
# And returns the HTML string.

sub PrintVariables {
  local (%in) = @_;
  local ($old, $out, $output);
  $old = $*;  $* =1;
  $output .=  "<DL COMPACT>";
  foreach $key (sort keys(%in)) {
    foreach (split("\0", $in{$key})) {
      ($out = $_) =~ s/\n/<BR>/g;
      $output .=  "<DT><B>$key</B><DD><I>$out</I><BR>";
    }
  }
  $output .=  "</DL>";
  $* = $old;

  return $output;
}

# PrintVariablesShort
# Nicely formats variables in an associative array passed as a parameter
# Using one line per pair (unless value is multiline)
# And returns the HTML string.


sub PrintVariablesShort {
  local (%in) = @_;
  local ($old, $out, $output);
  $old = $*;  $* =1;
  foreach $key (sort keys(%in)) {
    foreach (split("\0", $in{$key})) {
      ($out = $_) =~ s/\n/<BR>/g;
      $output .= "<B>$key</B> is <I>$out</I><BR>";
    }
  }
  $* = $old;

  return $output;
}

1; #return true
