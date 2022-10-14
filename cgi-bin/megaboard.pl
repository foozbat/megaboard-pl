#!/usr/bin/perl

# Megaboard
# - by Aaron Bishop <mailman@directlink.net>
# ----------------------------------------
#	Megaboard is a highly customizable
#	message board script.  Megaboard's
#	interface is simple, and is designed
#	to mimic the functionality of the
#	popular Delphi.com message board 
#	system.
#
#   This script uses cgi-lib.pl (by
# ----------------------------------------

# !! Set up this variable or the board wont work !!
# this is the path to the http root directory
# no trailing forward slash!

$rootpath    = "/change/me";

# ----------------------------------------
# System Settings
# ----------------------------------------

# Neccesary tools
require "$rootpath/cgi-bin/cgi-lib.pl";
require "$rootpath/cgi-bin/cookie-lib.pl";

# Decode form input
&ReadParse;

# Forum Settings
require "$rootpath/megaboard/$in{'forum'}/admin/settings.dat";

# Subroutines
require "$path/viewthread.pl";
require "$path/viewmessage.pl";
require "$path/viewlist.pl";
require "$path/viewlistfull2.pl";
require "$path/postmessage.pl";
require "$path/deletepost.pl";
require "$path/reply.pl";
require "$path/edit.pl";
require "$path/viewip.pl";
require "$path/banuser.pl";
require "$path/deletethread.pl";
require "$path/lamerize.pl";
require "$path/admdispusers.pl";
require "$path/login.pl";
require "$path/users.pl";
require "$path/profile.pl";
require "$path/faq.pl";

# SET COOKIES!!! :)
&get_cookie;
&set_cookie(time()+5184000, ".$domain", "/cgi-bin/", 0); # Cookie stays active for 60 days

if ($in{'savepass'} eq 'ON')
{
  $cookie{'name'} = $in{'name'};  # this is the member name
  $cookie{'pass'} = $in{'pass'};  # this is their password
}

if ($in{'admin'})
{
  open(ADMIN, "$profilepath/$cookie{'name'}/profile.dat");
  chomp(@profile = <ADMIN>);
  close(ADMIN);

  if (crypt($cookie{'pass'}, 'limabean') eq @profile[2] && @profile[3] eq 'moderator')
  {
    $cookie{'admin'} = 1;
  }
}
if ($in{'logout'})
{
  $cookie{'admin'} = 0;
}
if (defined($in{'frames'}))
{
  $cookie{'frames'} = $in{'frames'};
}
if (!defined($cookie{'frames'}))
{
  $cookie{'frames'} = $settings{'frames'};
}
&set_cookie(time()+5184000, ".$domain", "/cgi-bin/", 0); # Cookie stays active for 60 days

print "Content-type: text/html\r\n\r\n";

# ----------------------------------------
# Main Program
# ----------------------------------------

## check admin auth ###

if (!$in{'job'} 
	&& $cookie{'frames'} eq 'on')		{ &ViewBoard; }
elsif (!$in{'job'} 
	&& $cookie{'frames'} eq 'off')		{ &ViewListFull; }
elsif ($in{'job'} eq 'viewboard')		{ &ViewBoard; }
elsif ($in{'job'} eq 'viewthread')		{ &ViewThread; }
elsif ($in{'job'} eq 'postmessage')		{ &PostMessage; }
elsif ($in{'job'} eq 'viewlist')		{ &ViewList; }
elsif ($in{'job'} eq 'viewlistfull')	{ &ViewListFull; }
elsif ($in{'job'} eq 'reply')			{ &Reply; }
elsif ($in{'job'} eq 'deletepost')		{ &DeletePost; }
elsif ($in{'job'} eq 'edit')			{ &Edit; }
elsif ($in{'job'} eq 'viewip')			{ &ViewIP; }
elsif ($in{'job'} eq 'viewmessage')		{ &ViewMessage; }
elsif ($in{'job'} eq 'newmember')		{ &NewMember; }
elsif ($in{'job'} eq "sendicq")			{ &SendICQ; }
elsif ($in{'job'} eq "toolbar")			{ &Toolbar; }
elsif ($in{'job'} eq "topbar")			{ &TopBar; }
elsif ($in{'job'} eq 'search')			{ &Search; }
elsif ($in{'job'} eq 'banuser')			{ &BanUser; }
elsif ($in{'job'} eq 'deletethread')	{ &DeleteThread; }
elsif ($in{'job'} eq 'lamer')			{ &Lamer; }
elsif ($in{'job'} eq 'faq')				{ &FAQ; }

## modifying profile requires auth ##
elsif ($in{'job'} eq 'profile')			{ if (&authcookieprofile) { &Profile }
										  else { &accessdenied; }
										}
## ADMIN FUNCTIONS, REQUIRE AUTH ##
elsif ($in{'job'} eq 'admdispusers')	{ if (&authcookie) { &AdmDispUsers; }
										  else { &accessdenied; }
										}
elsif ($in{'job'} eq 'adminbar')		{ if (&authcookie) { &adminbar; }
										  else { &accessdenied; }
										}
elsif ($in{'job'} eq 'login')			{ &Login; }
elsif ($in{'job'} eq 'addmod')			{ if (&authcookie) { &addmod; }
										  else { &accessdenied; }
										}
elsif ($in{'job'} eq 'demod')			{ if (&authcookie) { &demod; }
										  else { &accessdenied; }
										}
elsif ($in{'job'} eq 'deluser')			{ if (&authcookie) { &deluser; }
										  else { &accessdenied; }
										}
elsif ($in{'job'} eq 'resetpass')		{ if (&authcookie) { &resetpass; }
										  else { &accessdenied; }
										}
## END ADMIN ##

else									{ &notdone; }

# ----------------------------------------
# ViewBoard
# ----------------------------------------

sub ViewBoard
{
print qq^
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>$settings{'title'}</title>
</head>

<frameset framespacing="0" border="false" frameborder="0" rows="$settings{'frameheight'},^;
if (&authcookie)
{
   print "25,";
}
print qq^*">
  <frame name="top" scrolling="no" noresize target="messagewindow" src="megaboard.pl?forum=$in{'forum'}&job=topbar" marginwidth="0" marginheight="0">^;

if (&authcookie)
{
  print qq^<frame name="admin" scrolling="no" noresize target="messagewindow" src="megaboard.pl?forum=$in{'forum'}&job=adminbar" marginwidth="0" marginheight="0">^;
}

  print qq^<frameset cols="268,*">
    <frameset rows="*,135">
      <frame name="messagelist" target="messagewindow" src="megaboard.pl?forum=$in{'forum'}&job=viewlist" scrolling="auto"
      marginwidth="3" marginheight="0">
      <frame name="toolbar" target="messagewindow" src="megaboard.pl?forum=$in{'forum'}&job=toolbar" scrolling="no">
      </frameset>
    <frame name="messagewindow" src="$forumurl/front.html" scrolling="auto">
  </frameset>

  <noframes>
  <body>
  <p>This page uses frames, but your browser doesn't support them.</p>
  </body>
  </noframes>
</frameset>
</html>^;

}

# ----------------------------------------
# NewMember
# ----------------------------------------

sub NewMember
{
  if (!$in{'createprofile'}) 
  {
    print qq^
    <html>

    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>Register a new user</title>
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
    <tr><td bgcolor="$colors{'functitle'}" align=center><font face="system" color="$colors{'functitletext'}"><img src="/megaboard/images/register.gif">Register a New User</font></td></tr>
    <tr><td bgcolor="$colors{'functable'}">
    <font face="arial">
    <form action=megaboard.pl method=post>
    Enter your desired membername<br>
	(16 characters max, no spaces):<br>
    <input type=text size=25 name="name"
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"><p>
    Your email address:<br>
    <input type=text size=25 name="email" 
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}""><p>
    Your ICQ UIN <i>(optional)</i>:<br>
    <input type=text size=15 name="uin"
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"><p>
    Enter your desired password TWICE:<br>
    <input type=password size=15 name="pass"
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"><br>
    <input type=password size=15 name="verify"
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"><p>
	<input type="checkbox" name="savepass" value="ON" checked>Check here to save your password on this computer.<p>
    <input type=hidden name="createprofile" value="1">
    <input type=hidden name="forum" value="$in{'forum'}">
	<input type=hidden name="job" value="newmember">
    <input type=submit value="Create" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">&nbsp;<input type=reset value="Clear" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">
    </td></tr></table></td></table>^;

	&footer;

    print qq^</body></html>^;
  }
  elsif ($in{'createprofile'})
  {
    # get the names of registered users
    opendir(PROFILES, "$profilepath");
    chomp(@names = readdir(PROFILES));
    closedir(PROFILES);


    #check if name is already taken
    foreach $name (@names)
    {
      $taken = 1;   # set default
      last if lc($name) eq lc($in{'name'});
      $taken = 0;   # not taken
    }

    # get members' email addys
    foreach $member (@names)
    {
      open(PROFILE, "<$profilepath/$member/profile.dat");
      chomp(@fields = <PROFILE>);
      close(PROFILE);

      

      $emailtaken = 1;   # set default
      last if lc(@fields[0]) eq lc($in{'email'});
      $emailtaken = 0;   # not taken
    }

    # Check for invalid fields from form input
    if (length($in{'name'}) > 16 || $in{'name'} =~ /\s+/ || $in{'name'} =~ /\"/ || $in{'name'} eq '' || $in{'email'} !~ /.+@.+\..+/ || $in{'pass'} ne $in{'verify'} || $in{'pass'} eq '' || $in{'verify'} eq '' || $in{'uin'} =~ /\D+/ || $taken || $emailtaken)
    {
      print qq^
    <html>

    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>Register a new user</title>
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
    <tr><td bgcolor="$colors{'functitle'}" align=center><font face="system" color="$colors{'functitletext'}"><img src="/megaboard/images/register.gif">Register a New User</font></td></tr>
    <tr><td bgcolor="$colors{'functable'}">
    <font face="arial">
	<form action=megaboard.pl method=post>^;

      if ($taken == 1)
      {
        print "<font color=red>Member Name Already Taken:</font><br>\n";
      }
      elsif (length($in{'name'}) > 16 || $in{'name'} =~ /\s+/ || $in{'name'} =~ /\"/ || $in{'name'} eq '')
      {
        print "<font color=red>Invalid Member Name:</font><br>\n";
      }
      else
      {
        print "Enter your desired membername<br>(16 characters max, no spaces):<br>\n";
      }

      print qq^
      <input type=text size=25 name="name" value="$in{'name'}"
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"><p>^;


      if ($in{'email'} !~ /.+@.+\..+/)
      {
        print "<font color=red>Invalid Email Address<br></font>\n";
      }
	  elsif ($emailtaken == 1)
      {
        print "<font color=red>Email Address Already Registered:<br></font>\n";
      }
      else
      {
        print "Your email address:<br>\n";
      }

      print qq^
      <input type=text size=25 name="email" value="$in{'email'}"
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"><p>^;

      if ($in{'uin'} =~ /\D+/)
      {
        print "<font color=red>ICQ UIN must be a number:</font><br>\n";
      }
      else
      {
        print "Your ICQ UIN <i>(optional)</i>:<br>\n";
      }

      print qq^
      <input type=text size=15 name="uin" value="$in{'uin'}"
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"><p>^;

      if ($in{'pass'} ne $in{'verify'})
      {
        print "<font color=red>Passwords do not match, please retype:</font><br>\n";
      }
      elsif ($in{'pass'} eq '' || $in{'verify'} eq '')
      {
        print "<font color=red>You must enter a password</font><br>\n";
      }
      else
      {
        print "Enter your desired password TWICE:<br>\n";
      }

      print qq^
      <input type=password size=15 name="pass" value="$in{'pass'}"
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"><br>
      <input type=password size=15 name="verify" value="$in{'verify'}"
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"><p>
	  <input type="checkbox" name="savepass" value="ON" checked>Check here to save your password on this computer.<p>
      <input type=hidden name="createprofile" value="1">
	  <input type=hidden name="forum" value="$in{'forum'}">
      <input type=hidden name="job" value="newmember">
      <input type=submit value="Create" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">&nbsp;<input type=reset value="Clear" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">
    </td></tr></table></td></table>^;

	&footer;

    print qq^</body></html>^;

    }
    else
    {
      $encrypted_pass = crypt($in{'pass'}, 'limabean');  # limabean is the salt for the password crypt, can be changed if desired

      # Get rid of html and other baddies
      $in{'name'} =~ s/</&lt;/g;
      $in{'name'} =~ s/>/&gt;/g;
      $in{'name'} =~ s/"/&quot;/g;

      $in{'email'} =~ s/</&lt;/g;
      $in{'email'} =~ s/>/&gt;/g;
      $in{'email'} =~ s/"/&quot;/g;

      # Write the profile record
      mkdir("$profilepath/$in{'name'}", 0777);
      open(PROFILE, ">$profilepath/$in{'name'}/profile.dat");
      print PROFILE "$in{'email'}\n";
      print PROFILE "$in{'uin'}\n";
      print PROFILE "$encrypted_pass";
      close(PROFILE);

      # Create the file that holds the user's # of posts
      open(NUMPOSTS, ">$profilepath/$in{'name'}/posts.dat");
      print NUMPOSTS "0";
      close(NUMPOSTS);

      # Create the file that holds the times user is replied to
      open(REPLIES, ">$profilepath/$in{'name'}/replies.dat");
      print REPLIES "0";
      close(REPLIES);

      # Return Output
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

		<body background="$forumurl/$settings{'backgroundimage'}" bgcolor=$colors{'funcback'} text=$colors{'funcbacktext'} link="$colors{'links'}" vlink="$colors{'links'}" alink="$colors{'links'}">^;

	if ($cookie{'frames'} eq 'off')
	{
	  &header;
	}

      print qq^
      Profile created successfully<p>
      Member name: <b>$in{'name'}</b><br>
      Email: <b>$in{'email'}</b><br>
      ICQ UIN: <b>$in{'uin'}</b><br>
      Password: <i>encrypted</i>^;

	  &footer;
	  
	  print qq^</body></html>^;

    } # END IF
  } # END IF
}

# ----------------------------------------
# SendICQ
# ----------------------------------------

sub SendICQ
{
  print qq^
  <html>
  <head><title>Send ICQ Message to $in{'sendto'}</title></head>
  <body bgcolor=black text=white>
  <center>
  <form action="http://wwp.icq.com/scripts/WWPMsg.dll" method="post">
  <table cellpadding="1" cellspacing="1"><tr><td>
  <table cellpadding="0" cellspacing="0" border="0">
  <tr>
  <td align="center" nowrap colspan="2">
  <font size="-1" face="arial"><b>Send ICQ to $in{'sendto'}</b><hr></font></td>
  </tr>
  <tr>
  <td align="center"><font size="-2" face="arial"><b>Sender Name</b> (optional):</font><br><input type="text" name="from" value="" size=15 maxlength=40 onfocus="this.select()"></td>
  <td align="center"><font size="-2" face="arial"><b>Sender EMail</b> (optional):</font><br><input type="text" name="fromemail" value="" size=15 maxlength=40 onfocus="this.select()">
  <input type="hidden" name="subject" value="$in{'subject'}"></td>
  </tr>
  <tr>
  <td align="center" colspan="2"><font size="-2" face="ms sans serif">Message:</font><br>
  <textarea name="body" rows="3" cols="30" wrap="Virtual"></textarea><br></td>
  </tr>
  <tr>
  <td colspan="2" align="center">
  <input type="hidden" name="to" value="$in{'uin'}">
  <input type="submit" name="Send" value="Send Message">&nbsp;&nbsp;
  <input type="reset" value="Clear">
  </td>
  </tr>
  </table>
  </td></tr></table>
  </center></body></html>^;
}

# ----------------------------------------
# Toolbar
# ----------------------------------------

sub Toolbar
{
  print qq^
  <html>

  <head>
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
  <base target="messagewindow">
  <title>Toolbar</title>
  </head>

  <body bgcolor="$colors{'listback'}" text="$colors{'listtabletext'}">

  <table cellspacing=0 cellpadding=0 border=0 width=100%>
  <td bgcolor="$colors{'listborder'}">
  <table cellspacing=1 cellpadding=3 border=0 width=100%>
  <tr><td colspan=2 bgcolor="$colors{'listtitle'}" align=center><font face="system" color="$colors{'listtitletext'}">Message Tools</font></td></tr>
  <tr><td bgcolor="$colors{'listtable'}" align=center valign=top>
  <font face="arial" size="-1">
  <form action="megaboard.pl">
	  Search Messages:<br>
	  <input type=text name="string" size=12
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"><br>
	  <input type="hidden" name="forum" value="$in{'forum'}">
	  <input type="hidden" name="job" value="search">
	  <input type=submit value="Search"style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1"></form></td>
  <td bgcolor="$colors{'listtable'}" align=center valign=top>
  <font face="arial" size="-1">
  <form action="megaboard.pl">Jump to Message #<br>
	  <input type="text" size="12" name="messno"
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"><br>
	  <input type="hidden" name="forum" value="$in{'forum'}">
	  <input type="hidden" name="job" value="viewmessage">
	  <input type="submit" value="Jump"style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1"></form>
  </td></tr></table>
  </td></table>
  </body>
  </html>^;
}

# ----------------------------------------
# TopBar
# ----------------------------------------

sub TopBar
{
  print qq^
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>New Page 5</title>
  <style>
    a:link   {text-decoration:none}
   	a:visited{text-decoration:none}
	a:hover  {text-decoration:underline}
  </style>
<base target="messagewindow">
</head>

<body bgcolor="$colors{'topbarback'}" text="$colors{'topbartext'}" background="$forumurl/back.gif" link=$colors{'topbarlinks'} alink=$colors{'topbarlinks'} vlink=$colors{'topbarlinks'}>
<table cellspacing=0 cellpadding=0 border=0 width=100%>
<tr><td><a href="$homepage" target="_top"><img src="$forumurl/mbtitle.gif" border=0></a></td>
  <td align=right valign=bottom>
  <table>
  <tr><td><font face="arial"><a href=$forumurl/front.html><img src="/megaboard/images/home.gif" height=18 width=18 border=0>Home</a>
 | <a href=/megaboard/faq.html><img src="/megaboard/images/faq.gif" border=0 height=18 width=18>FAQ</a>
 | <a href=/cgi-bin/megaboard.pl?forum=$in{'forum'}&job=newmember><img src="/megaboard/images/register.gif" border=0 height=18 width=18>Register</a>
 | <a href=/cgi-bin/megaboard.pl?forum=$in{'forum'}&frames=off target="_top"><img src="/megaboard/images/noframes.gif" border=0 height=18 width=18><font color="$colors{'topbarlinks'}">No Frames</font></a>&nbsp;&nbsp;
</td></tr></table>
</td></tr>
</table>
</body>
</html>^;
}


# ----------------------------------------
# Search
# ----------------------------------------

sub Search
{
  if ($in{'string'} !~ /\w+/) # if it is not a character
  {
    print "\n\n<body bgcolor=black text=white>";
    print "<font face=\"arial\"><h2>Please enter a valid search argument.</h2>\n";
    print "eg. no empty searches or just spaces.\n";
    print "</font></body>";

  }
  else
  {
    print qq^
   	<html>

	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>Search Results</title>
	<style>
		a:link   {color:"$colors{'links'}"; text-decoration:none}
		a:visited{color:"$colors{'links'}"; text-decoration:none}
		a:hover  {color:"$colors{'links'}"; text-decoration:underline}
	</style>
	</head>

	<body background="$forumurl/$settings{'backgroundimage'}" bgcolor="$colors{'messageback'}" text="$colors{'messagetext'}" link=$colors{'links'} vlink=$colors{'vlinks'} alink=$colors{'alink'}>
^;

    if ($cookie{'frames'} eq 'off')
	{
	  &header;
	}

    $string = $in{'string'};

    # parse search string for baddies
    $string =~ s/\\/\\\\/g;
    $string =~ s/\|/\\|/g;
    
	opendir(PROFILES, "$profilepath");
	chomp(@profiles = readdir(PROFILES));
	closedir(PROFILES);

	foreach $profile (@profiles)
	{
		open(PROFILE, "<$profilepath/$profile/profile.dat");
		chomp (@profiledata = <PROFILE>);
		close(PROFILE);

		if (@profiledata[3] eq 'moderator' || @profiledata[3] eq 'administrator')
		{
		  $moderators{$profile} = @profiledata[0];
		}
	}


	print qq^
	
	<font face="arial" size=3><b>Search Results for <i>"$string"</i></b><p></font>
	<table cellspacing=0 cellpadding=0 border=0 width=100%>
	<td bgcolor="$colors{'listborder'}">
	<table cellspacing=1 cellpadding=4 width=100%>^;
	
	foreach $key (keys %topic)
    {
      opendir(SEARCHDIRS, "$messagepath/$key");
      chomp(@threads = readdir(SEARCHDIRS));
      close(SEARCHDIRS);
      @threads = sort numerically @threads;

      foreach $thread (@threads)
      {
	    open(THREAD, "$messagepath/$key/$thread");
		chomp(@messages = <THREAD>);
		close(THREAD);

        $counter = 0;
		$totalmessages = @messages - 1;
		$tbl_toggle = 0;
        foreach $message (@messages)
        {
          @searchfile = split(/\|/, $message);
		  $text = lc(@searchfile[3]);
		  $string = lc($string);

          if ($text =~ /$string/)
          {
            $found = 1;
			$topbutton = 1;
            $title = @messages[0];
     		$time = @searchfile[2];
			$membername = @searchfile[0];

			$membername =~ s/&pipe;/\|/g;

            if(!$printed)
            {
              print qq^
			  <tr><td bgcolor="$colors{'listtitle'}" colspan=2 width=100%><font face="verdana" size=2 color="$colors{'listtitletext'}"><a name="$topic{$key}"></a><b>$topic{$key}</b></font></td>
			  <td bgcolor="$colors{'listtitle'}" nowrap><font size="2" face="verdana"><b>Posted by</b></td>
			  <td bgcolor="$colors{'listtitle'}" nowrap><font size="2" face="verdana"><b>Posted on</b></td>
			  </tr>
              ^;
              $printed = 1; 
            }

			$tbl_toggle ^= 1;     # $tbl_toggle XOR 1 
			if ($tbl_toggle == 1)
			{
			  $bgcolor = $colors{'messagetableback1'};
			}
			elsif ($tbl_toggle == 0)
			{
			  $bgcolor = $colors{'messagetableback2'};
			} # END IF

			print qq^
			  <tr>
				<td width=5 bgcolor="$bgcolor"><font size=1>&nbsp</td><td bgcolor="$bgcolor" width="100%"><font face="arial" color="$colors{'listtabletext'}" size=2><a
				href="megaboard.pl?forum=$in{'forum'}&job=viewmessage&messno=$topic2num{$key}.$thread.$counter">$title</a> [$counter of $totalmessages]</font></td>
				<td bgcolor="$bgcolor"><font face=arial size=2>^;
				
				foreach $moderator (keys %moderators)
				{
				  if ($membername eq $moderator)
				  {
					print "<font color=\"$colors{'admincolor'}\">";
				  }
				}
				  print qq^$membername</td>
				<td bgcolor="$bgcolor" nowrap><font face="arial" size="2" color="$colors{'listtabletext'}">$time</font></td>
			  </tr>^;
          }
		  $counter++;
        } # END FOREACH
        
      } # END FOREACH
		$printed = 0;

	  if ($topbutton)
	  {
	  
	  print qq^
	  <tr>
		<td align="right" bgcolor="$colors{'messageback'}" colspan=5><font face="arial" size="-2" color="$colors{'messagewindowbacktext'}">^;
		print qq^[ <a href="#$topic{$key}"><font color="$colors{'messagebacklink'}">T O P</font></a> ]<br></td>
	  </tr>^;
	  $topbutton = 0;
	  }

	} # END FOREACH

    if (!$found)
    {
      # "unparse" the string for printing

      $string =~ s/\\\\/\\/g;
      $string =~ s/\\\|/\|/g;

      print "<td bgcolor=$colors{'listtable'}><font size=2 face=\"arial\"><i>\"$string\"</i> was not found in any message text.</td>\n";
    }# END IF
	
		print qq^
		</table>
		</td>
		</table>^;
		&footer;

print qq^</body></html>^;


  } # END IF
}

sub notdone
{
  print qq^
  <body bgcolor=black text=white link=blue vlink=blue alink=blue>
  <font face=arial>
  <h2>Sorry!</h2>
  That feature has not been implemented yet.<br>
  <a href="mailto:mailman\@directlink.net">mailman\@hit-squad.net</a>
  <p>
  If you are getting this error, you may have a corrupt cookie for the forum.  Open your temporary internet files folder and <b>delete the cookies for hit-squad.net</b>.
  </font>
  </body>^;
}

sub decreasingorder { $b <=> $a }
sub numerically { $a <=> $b }

sub header
{
	if ($settings{'customheadfoot'} eq 'on')
	{
		open(HEADER, "$datapath/customheader.html");
		chomp(@header = <HEADER>);
		close(HEADER);

		foreach $line (@header)
		{
			print "$line\n";
		}
	}
	else
	{
	print qq^
	<table width=100% cellspacing=0 cellpadding=0 border=0>
	<tr><td bgcolor="$colors{'topbarback'}" background="$forumurl/back.gif"><a href="$homepage" target="_top"><img src="$forumurl/mbtitle.gif" border=0></a></td>
	  <td align=right valign=bottom bgcolor="$colors{'topbarback'}" background="$forumurl/back.gif">
	  <font face="arial" color="$colors{'topbartext'}"><a href="megaboard.pl?forum=$in{'forum'}"><img src="/megaboard/images/home.gif" height=18 width=18 border=0><font color="$colors{'topbarlinks'}">Home</font></a>
	 | <a href=/megaboard/faq.html><img src="/megaboard/images/faq.gif" border=0 height=18 width=18><font color="$colors{'topbarlinks'}">FAQ</font></a>
	 | <a href=/cgi-bin/megaboard.pl?forum=$in{'forum'}&job=newmember><img src="/megaboard/images/register.gif" border=0 height=18 width=18><font color="$colors{'topbarlinks'}">Register</font></a> 
	 | <a href=/cgi-bin/megaboard.pl?forum=$in{'forum'}&frames=on><img src="/megaboard/images/frames.gif" border=0 height=18 width=18><font color="$colors{'topbarlinks'}">Frames</font></a>&nbsp;&nbsp;
	</td></tr>
	</table><p>^;
	}

	opendir(PROFILES, "$profilepath");
	chomp(@profiles = readdir(PROFILES));
	closedir(PROFILES);

	open(TOTAL, "<$messagepath/totalmessages");
	chomp($totalmessages = <TOTAL>);
	close(TOTAL);


	foreach $profile (@profiles)
	{
		open(PROFILE, "<$profilepath/$profile/profile.dat");
		chomp (@profiledata = <PROFILE>);
		close(PROFILE);

		if (@profiledata[3] eq 'moderator' || @profiledata[3] eq 'administrator')
		{
		  $moderators{$profile} = @profiledata[0];
		}
	}

	print qq^
	<font face="verdana">
	<table cellspacing=0 cellpadding=0 width=100% border=0>
	<td bgcolor="$colors{'listborder'}">
	<table width=100% cellspacing=1 cellpaddding=4 border=0>
	<tr><td bgcolor="$colors{'listtable'}">
	<table width=100%>
	<tr><td valign=top nowrap>
	<font size=2 color="$colors{'listtabletext'}" face="verdana"><form action="megaboard.pl"><b>Forum Staff:&nbsp;&nbsp;</b>^;
	
	$count = 0;
	print qq^</td><td width=100%><font size=2 color="$colors{'listtabletext'}" face="verdana">^;
	foreach $moderator (keys %moderators)
	{
	  if ($count > 0)  { print ", "; }
	  print "<a href=\"mailto:$moderators{$moderator}\"><font color=\"$colors{'links'}\">$moderator</font></a>";
	  $count++;
	}

	print qq^</td><td align=right nowrap valign=top><font size=2 color="$colors{'listtabletext'}" face="verdana">Total Posts: <b>$totalmessages</b></td></tr>
<tr><td colspan=2 align=bottom>^;


	if (defined($cookie{'name'}))
	{
	  open(PROFILE, "$profilepath/$cookie{'name'}/profile.dat");
	  chomp(@profile = <PROFILE>);
	  close(PROFILE);

	  if (@profile[2] eq crypt($cookie{'pass'}, 'limabean')) {  print "<font face=\"verdana\" color=\"$colors{'listborder'}\" size=2>[ Logged in as <b>$cookie{'name'}</b> ]</font>";  }
	}

print qq^</td><td align=bottom>

	  <input type=text name="string" size=14 value="Search" 
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"> <input type="hidden" name="forum" value="$in{'forum'}"><input type="hidden" name="job" value="search">
	  </font></td></tr>^;


	print qq^</table>
		</td></tr>
		<tr><td bgcolor="$colors{'messageback'}" align=center>
		<table cellspacing=0 cellpadding=0 border=0>
		<tr><td><font face="verdana" size=2 color="$colors{'listtabletext'}">
		<b>Forum Options: [</td>
		<td><font size=1>&nbsp;<a href="megaboard.pl?forum=$in{'forum'}"><img src="/megaboard/images/home.gif" height=18 width=18 border=0></a>&nbsp;</td>
			<td><b><a href="megaboard.pl?forum=$in{'forum'}"><font face="verdana" size=2 color="$colors{'links'}" color="$colors{'links'}">Main Forum</font></a>&nbsp;|</b></td>
		<td><font size=1>&nbsp;<a href=/cgi-bin/megaboard.pl?forum=$in{'forum'}&job=faq><img src="/megaboard/images/faq.gif" border=0 height=18 width=18></a>&nbsp;</td>
			<td><b><a href=/cgi-bin/megaboard.pl?forum=$in{'forum'}&job=faq><font face="verdana" size=2 color="$colors{'links'}">FAQ</font></a> |</b></td>
		<td><font size=1>&nbsp;<a href=/cgi-bin/megaboard.pl?forum=$in{'forum'}&job=newmember><img src="/megaboard/images/register.gif" border=0 height=18 width=18></a>&nbsp;</td>
			<td><b><a href=/cgi-bin/megaboard.pl?forum=$in{'forum'}&job=newmember><font face="verdana" size=2 color="$colors{'links'}">Register</font></a> |</b></td>
		<td><font size=1>&nbsp;<a href=/cgi-bin/megaboard.pl?forum=$in{'forum'}&job=profile><img src="/megaboard/images/profile.gif" border=0 height=18 width=18></a>&nbsp;</td>
			<td><b><a href=/cgi-bin/megaboard.pl?forum=$in{'forum'}&job=profile><font face="verdana" size=2 color="$colors{'links'}">Profile</font></a> |</b></td>
		<td><font size=1>&nbsp;<a href=/cgi-bin/megaboard.pl?forum=$in{'forum'}&job=login><img src="/megaboard/images/login.gif" border=0 height=18 width=18></a>&nbsp;</td>
			<td><b><a href=/cgi-bin/megaboard.pl?forum=$in{'forum'}&job=login><font face="verdana" size=2 color="$colors{'links'}">Login</font></a>&nbsp;</b></td>^;

	 if ($settings{'disallowframes'} ne 'yes')
	 {
		print qq^<td><b>|<font size=1>&nbsp;<a href=/cgi-bin/megaboard.pl?forum=$in{'forum'}&frames=on><img src="/megaboard/images/frames.gif" border=0 height=18 width=18></a>&nbsp;</td>
					<td><b><a href=/cgi-bin/megaboard.pl?forum=$in{'forum'}&frames=on><font face="verdana" size=2 color="$colors{'links'}">Frames</font></a>&nbsp;</b></td>^;
	 }
	 print qq^
		<td><font face="verdana" size=2 color="$colors{'listtabletext'}"><b>]</b></td></tr></table>
		
		</td></tr>
		</table></td></table></form><p>^;


	if (&authcookie)
	{
	  &adminbar;
	}

	print "<p>\n";
}


sub footer
{
  print qq^
  		<br>
		<font face="verdana" size=2 color=$colors{'footer'}>
		<center>Forum Powered by [ Megaboard v2.0 ]<br><font size=1>
		written by <a href="mailto:mailman\@hit-squad.net"><font color="$colors{'links'}">Mailman</font></a> &copy;2000-2001</center>^;

	if ($settings{'customheadfoot'} eq 'on')
	{
		open(HEADER, "$datapath/customfooter.html");
		chomp(@header = <HEADER>);
		close(HEADER);

		foreach $line (@header)
		{
			print "$line\n";
		}
	}
}

sub adminbar
{
  if ($cookie{'frames'} eq 'on')
  {
    print qq^<base target="messagewindow">^;
  }

  print qq^
  <table width=100% border=1 bordercolor=red cellspacing=0 height=25>
  <td bgcolor=white><font face=arial color=red size=2>&nbsp&nbsp<b>Administration:</b>
  [ <a href="megaboard.pl?forum=$in{'forum'}&job=admdispusers"><font color=red><u>USERS</u></font></a> ] [ <a href="megaboard.pl?forum=$in{'forum'}&job=admbanlist"><font color=red><u>BAN LIST</u></font></a> ] [ <a <a href="megaboard.pl?forum=$in{'forum'}&logout=1" target="_top"><font color=red><u>LOGOUT</u></font></a> ]</td>
  </table>^;
}

sub authcookie
{
	open(ADMIN, "$profilepath/$cookie{'name'}/profile.dat");
	chomp(@profile = <ADMIN>);
	close(ADMIN);

	if ($cookie{'admin'} && @profile[3] eq 'moderator' && crypt($cookie{'pass'}, 'limabean') eq @profile[2])
	{
		return 1; ## AUTH OK
	}
	else
	{
		return 0; ## AUTH FAIL
	}
}

sub authcookieprofile
{
	open(PROFILE, "$profilepath/$cookie{'name'}/profile.dat");
	chomp(@profile = <PROFILE>);
	close(PROFILE);

	if (crypt($cookie{'pass'}, 'limabean') eq @profile[2])
	{
		return 1; ## AUTH OK
	}
	else
	{
		return 0; ## AUTH FAIL
	}
}

sub accessdenied
{
	print qq^
	<html>
	<head><title>Access Denied!</title></head>

	<body bgcolor=black text=white>
	<font face="verdana" size=2><center>
	<b>Access Denied!</b><p>
	You must login with a valid username and password.
	Cookies must be enabled in your browser.
	</center>
	</body>

	</html>^;
}

sub GetTime
{
  $year  = (localtime)[5];
  $month = (localtime)[4];
  $day   = (localtime)[3];
  $hour  = (localtime)[2];
  $min   = (localtime)[1];

  $month++;

  if ($hour == 0)
  {
    $hour = 12;
    $ampm = 'am';
  }
  elsif ($hour == 12)
  {
    $ampm = 'pm';
  }
  elsif ($hour > 12)
  {
    $hour -= 12;
    $ampm = 'pm';
  }
  else
  {
    $ampm = 'am';
  }# END IF

  if ($month < 10)
  {
    $month = "0$month";
  }
  if ($day < 10)
  {
    $day = "0$day";
  }
  if ($hour < 10)
  {
    $hour = "0$hour";
  }
  if ($min < 10)
  {
    $min = "0$min";
  }

  $year = 1900 + $year;

  return "$month-$day-$year $hour:$min$ampm";
}














