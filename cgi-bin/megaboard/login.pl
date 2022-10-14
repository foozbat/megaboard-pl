# ----------------------------------------
# Login
#   This module allows the user to login
#   Logging in allows a registered user
#   to post
#
#   Inputs required:
#   none
# ----------------------------------------

sub Login
{
  if ($in{'login'} eq '')
  {
    print qq^
	<html>

	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>Login</title>
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

	if (defined($cookie{'name'}))
	{
	  open(PROFILE, "$profilepath/$cookie{'name'}/profile.dat");
	  chomp(@profile = <PROFILE>);
	  close(PROFILE);

	  if (@profile[2] eq crypt($cookie{'pass'}, 'limabean')) { $loggedin = 1; }
	}

print qq^
     <center>
  	<table border=0 cellpadding=0 cellspacing=0>
	<td bgcolor="$colors{'functableborder'}">
    <table border=0 cellpadding=2 cellspacing=1>
    <tr><td bgcolor="$colors{'functitle'}" align=center><font face="system" color="$colors{'functitletext'}"><img src="/megaboard/images/login.gif">Login</font></td></tr>
    <tr><td bgcolor="$colors{'functable'}">
	<font face="arial">
<font size=2>Logging in allows registered users to post messages.<br>
	If you have not registered, please <a href="megaboard.pl?forum=$in{'forum'}&job=newmember">sign up</a> for a <b>free</b> account.<br></font>
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
	  <TR><TD COLSPAN="2"><input type="hidden" name="savepass" value="ON">
	  <INPUT TYPE="hidden" NAME="job" VALUE="login">
	  <INPUT TYPE="hidden" NAME="forum" VALUE="$in{'forum'}"></TD></TR>
	  <TR><TD COLSPAN="2" align=center><INPUT TYPE="SUBMIT" NAME="login" VALUE="Login" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">&nbsp;&nbsp;<INPUT TYPE="RESET" VALUE="Clear Form" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1"></TR></TD>
	</table><font size=2><br>Logging in saves your username and password in a cookie.<br>
	This cookie will remain active for 60 days after you leave the forum<br>
	and will refresh every time you visit.<br><br>
</td></tr></table></td></table>^;

	  &footer;

	  print qq^
	  </body></html>^;
  }
  elsif ($in{'login'} eq 'Login')
  {
    opendir(PROFILES, "$profilepath");
    chomp(@profiles = readdir(PROFILES));
    closedir(PROFILES);

    foreach $profile (@profiles)
    {
      if (lc($profile) eq lc($in{'name'})) 
      {
        $found = 1;
      } # END IF
    } # END FOREACH

    open(PROFILE, "$profilepath/$in{'name'}/profile.dat");
    chomp(@profile = <PROFILE>);
    close(PROFILE);

    $password = crypt($in{'pass'}, 'limabean');

# Check user's password
	if ($password eq @profile[2])
	{
      $passcorrect = 1;
	}

    if (!$found || $in{'name'} eq '' || !$passcorrect)
    {
	  print qq^
	  <html>

	  <head>
	  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	  <title>Login</title>
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
    	<table border=0 cellpadding=0 cellspacing=0>
	<td bgcolor="$colors{'functableborder'}">
    <table border=0 cellpadding=2 cellspacing=1>
    <tr><td bgcolor="$colors{'functitle'}" align=center><font face="system" color="$colors{'functitletext'}"><img src="/megaboard/images/login.gif">Login</font></td></tr>
    <tr><td bgcolor="$colors{'functable'}">
	  <font face="arial">
	<font size=2>Logging in allows registered users to post messages.<br>
	If you have not registered, please <a href="megaboard.pl?forum=$in{'forum'}&job=newmember">sign up</a> for a <b>free</b> account.<br></font>
      <FORM ACTION="megaboard.pl" method=post>
      <TABLE>
        <TR><TD>^;
if ($in{'name'} eq '') 
{
  print "<font color=red>You did not enter a name:";
}
elsif (!$found)
{
  print "<font color=red>Invalid User:";
}
else
{
  print "Name:";
}
        print "</TD><TD>";

if (!$passcorrect)
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
		<TR><TD COLSPAN="2">
			<input type="hidden" name="savepass" value="ON">
			  <INPUT TYPE="hidden" NAME="job" VALUE="login">
	  <INPUT TYPE="hidden" NAME="forum" VALUE="$in{'forum'}"></TD></TR>
	  <TR><TD COLSPAN="2" align=center><INPUT TYPE="SUBMIT" NAME="login" VALUE="Login" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">&nbsp;&nbsp;<INPUT TYPE="RESET" VALUE="Clear Form" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1"></TR></TD>
	</table><font size=2><br>Logging in saves your username and password in a cookie.<br>
	This cookie will remain active for 60 days after you leave the forum<br>
	and will refresh every time you visit.<br><br>
	  </td></tr></table></td></table>^;

	  &footer;

	  print qq^
	  </body></html>
	  ^;
	} 
    else
	{
	# redirect
	  if (@profile[3] eq 'moderator' || @profile[3] eq 'administrator')
	  {
		$adminvar = "\&admin=1";
	  }
	  print qq^
	    <HTML>
		<HEAD>
		<SCRIPT LANGUAGE="JavaScript">
		window.location = "megaboard.pl?forum=$in{'forum'}&loggedin$adminvar";
		</SCRIPT>
		<BODY BGCOLOR=$colors{'funcback'} text=$colors{'funcbacktext'} link=$colors{'links'} vlink=$colors{'links'} alink=$colors{'links'}>
		If this page does not automatically redirect,
		<a href="megaboard.pl?forum=$in{'forum'}&loggedin$adminvar">click here return to the forum</a>.
		</BODY>
		</HTML>^;
	}


  } # END IF
} # End of subroutine

1;
