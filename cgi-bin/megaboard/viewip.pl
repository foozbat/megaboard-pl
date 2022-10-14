# ----------------------------------------
# View Logged IP
# ----------------------------------------

sub ViewIP
{
  if (!$in{'view'})
  {
   	print qq^
	<html>

	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>View Logged IP</title>
    <style>
	    a:link   {color:"$colors{'links'}"; text-decoration:none}
    	a:visited{color:"$colors{'links'}"; text-decoration:none}
	    a:hover  {color:"$colors{'links'}"; text-decoration:underline}
    </style>
    </head>

    <body background="$forumurl/$settings{'backgroundimage'}" bgcolor=$colors{'funcback'} text=$colors{'functabletext'} link="$colors{'links'}" vlink="$colors{'links'}" alink="$colors{'links'}">^;

if ($cookie{'frames'} eq 'off')
{
  &header;
}

print qq^
	<center>
	<p>
	<table border=0 cellpadding=0 cellspacing=0>
	<td bgcolor="$colors{'functableborder'}">
    <table border=0 cellpadding=2 cellspacing=1>
    <tr><td bgcolor="$colors{'functitle'}" align=center><font face="system" color="$colors{'functitletext'}"><img src="/megaboard/images/iplog.gif">View Logged IP</font></td></tr>
    <tr><td bgcolor="$colors{'functable'}">
	<font face="arial">Only Moderators or Administrators can view logged IP's.
	<p>
	<form action="megaboard.pl" method="post">
	<table>
	<TR><TD>Name:</TD><TD>Password (case sensitive):</TD></TR>
	<TR><TD><INPUT TYPE="TEXT" SIZE="27" NAME="name" value="$cookie{'name'}"
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"></TD>
	<TD><INPUT TYPE="password" SIZE="28" NAME="pass" value="$cookie{'pass'}"
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"></TD></TR>
	<TR><TD COLSPAN="2"><input type="checkbox" name="savepass" value="ON" checked>Check here to save your password on this computer.
    <INPUT TYPE="hidden" NAME="job" VALUE="viewip">
    <INPUT TYPE="hidden" NAME="forum" VALUE="$in{'forum'}">
    <INPUT TYPE="hidden" NAME="topic" VALUE="$in{'topic'}">
	<INPUT TYPE="hidden" NAME="thread" VALUE="$in{'thread'}">
	<INPUT TYPE="hidden" NAME="messno" VALUE="$in{'messno'}">
	</td></tr>
    <TR><TD COLSPAN="2" align=center><INPUT TYPE="SUBMIT" NAME="view" VALUE="View IP" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">&nbsp;&nbsp;<INPUT TYPE="RESET" VALUE="Clear Form" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1"></TR></TD>
	</table></td></tr></table></td></table>^;

	  &footer;

	  print qq^
	  </body></html>^;
  }
  elsif ($in{'view'} eq "View IP")
  {
    opendir(PROFILES, "$profilepath");
    chomp(@profiles = readdir(PROFILES));
    closedir(PROFILES);

    open(OLDMESSAGE, "<$messagepath/$in{'topic'}/$in{'thread'}");
	chomp(@thread = <OLDMESSAGE>);
	close(OLDMESSAGE);

    @lines = split(/\|/, @thread[$in{'messno'}]);
	$messagetitle = @thread[0];

    # Check to see if the name is good
    foreach $profile (@profiles)
    {
      if (lc($profile) eq lc($in{'name'})) 
      {
        $found = 1;
		$deletedname = $profile;
      } # END IF
    } # END FOREACH

    open(PASS, "<$profilepath/$in{'name'}/profile.dat");
    chomp(@profile = <PASS>);
    close(PASS);


	if (lc(@lines[0]) eq lc($in{'name'}))
	{
      $owner = 1;  # he is the owner
	}
# Check to see if this is a moderator or admin
	elsif (@profile[3] eq 'moderator' || @profile[3] eq 'administrator')
	{
	  $owner = 1;
	}

    $password = crypt($in{'pass'}, 'limabean');

# Check user's password
	if ($password eq @profile[2] && lc(@lines[0]) eq lc($in{'name'}))
	{
      $passcorrect = 1;
	}
# Check the moderator password (if applicable)
	elsif ($password eq @profile[2] && @profile[3] eq 'moderator')
	{
	  $passcorrect = 1;
	}
	elsif ($password eq @profile[2] && @profile[3] eq 'administrator')
	{
	  $passcorrect = 1;
	}

	if (!$found || !$owner || $in{'name'} eq '' || !$passcorrect)
    {
		print qq^
		<html>

		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<title>Delete A Message</title>
    <style>
	    a:link   {color:"$colors{'links'}"; text-decoration:none}
    	a:visited{color:"$colors{'links'}"; text-decoration:none}
	    a:hover  {color:"$colors{'links'}"; text-decoration:underline}
    </style>
    </head>

    <body background="$forumurl/$settings{'backgroundimage'}" bgcolor=$colors{'funcback'} text=$colors{'functabletext'} link="$colors{'links'}" vlink="$colors{'links'}" alink="$colors{'links'}">^;

if ($cookie{'frames'} eq 'off')
{
  &header;
}

print qq^
	<center>
	<p>
	<table border=0 cellpadding=0 cellspacing=0>
	<td bgcolor="$colors{'functableborder'}">
    <table border=0 cellpadding=2 cellspacing=1>
    <tr><td bgcolor="$colors{'functitle'}" align=center><font face="system" color="$colors{'functitletext'}"><img src="/megaboard/images/iplog.gif">View Logged IP</font></td></tr>
    <tr><td bgcolor="$colors{'functable'}">
		<font face="arial">Only Moderators or Administrators can view logged IP's.
		<p>
		<form action="megaboard.pl" method="post">
		<table>
		<TR><TD>^;
if ($in{'name'} eq '') 
{
  print "<font color=red>You did not enter a name:";
}
elsif (!$found || !$owner)
{
  print "<font color=red>Invalid User:";
}
else
{
  print "Name:";
}
        print "</TD><TD>";

if ($password ne @user[2])
{
  print "<font color=red>Incorrect Password:";
}
else
{
  print "Password (case-sensitive):";
}
        print qq^
		</TD></TR>
		<TR><TD><INPUT TYPE="TEXT" SIZE="27" NAME="name" value="$cookie{'name'}"
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"></TD>
		<TD><INPUT TYPE="password" SIZE="28" NAME="pass" value="$cookie{'pass'}"
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"></TD></TR>
		<TR><TD COLSPAN="2"><input type="checkbox" name="savepass" value="ON" checked>Check here to save your password on this computer.
		<INPUT TYPE="hidden" NAME="job" VALUE="viewip">
		<INPUT TYPE="hidden" NAME="job" VALUE="viewip">
		<INPUT TYPE="hidden" NAME="topic" VALUE="$in{'topic'}">
		<INPUT TYPE="hidden" NAME="thread" VALUE="$in{'thread'}">
		<INPUT TYPE="hidden" NAME="messno" VALUE="$in{'messno'}">
		</td></tr>
    <TR><TD COLSPAN="2" align=center><INPUT TYPE="SUBMIT" NAME="view" VALUE="View IP" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">&nbsp;&nbsp;<INPUT TYPE="RESET" VALUE="Clear Form" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1"></TR></TD>
	</table></td></tr></table></td></table>^;

	  &footer;

	  print qq^
	  </body></html>^;
	}
	else
	{
	   $ip = @lines[6];
	   print qq^
	   <body bgcolor=black text=white>
	   $ip
	   ^;
	}
  }
}

1;