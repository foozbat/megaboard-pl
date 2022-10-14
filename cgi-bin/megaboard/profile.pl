# this lets a user modify their account

sub Profile
{
  if (!$in{'modifyprofile'}) 
  {
	open(PROFILE, "$profilepath/$cookie{'name'}/profile.dat");
	chomp(@profile = <PROFILE>);
	close(PROFILE);


    print qq^
    <html>

    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>Modify Your Profile</title>
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
    <tr><td bgcolor="$colors{'functitle'}" align=center><font face="system" color="$colors{'functitletext'}"><img src="/megaboard/images/profile.gif">Modify Your Profile</font></td></tr>
    <tr><td bgcolor="$colors{'functable'}">
    <font face="arial">
    <form action=megaboard.pl method=post>
    <input type=hidden name="name" value="$cookie{'name'}"><font face="verdana" size=2><b>$cookie{'name'}</b></font><p>
    Your email address:<br>
    <input type=text size=25 name="email" value="@profile[0]"
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}""><p>
    Your ICQ UIN <i>(optional)</i>:<br>
    <input type=text size=15 name="uin" value="@profile[1]"
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"><p>
    If you wish to change your password,<br>
	enter your new password TWICE:<br>
    <input type=password size=15 name="pass" value="$cookie{'pass'}"
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"><br>
    <input type=password size=15 name="verify" value="$cookie{'pass'}"
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"><p>
    <input type=hidden name="modifyprofile" value="1">
	<input type=hidden name="oldname" value="$cookie{'name'}">
	<input type=hidden name="oldemail" value="@profile[0]">
    <input type=hidden name="forum" value="$in{'forum'}">
	<input type=hidden name="job" value="profile">
    <input type=submit value="Modify" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">&nbsp;<input type=reset value="Clear" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">
    </td></tr></table></td></table>^;

	&footer;

    print qq^</body></html>^;
  }
  elsif ($in{'modifyprofile'})
  {
    # get the names of registered users
    opendir(PROFILES, "$profilepath");
    chomp(@names = readdir(PROFILES));
    closedir(PROFILES);


    #check if name is already taken
    #foreach $name (@names)
    #{
    #  $taken = 1;   # set default
    #  last if ( lc($name) eq lc($in{'name'}) && lc($name) ne lc($in{'oldname'}) );
    #  $taken = 0;   # not taken
    #}

    # get members' email addys
    foreach $member (@names)
    {
      open(PROFILE, "<$profilepath/$member/profile.dat");
      chomp(@fields = <PROFILE>);
      close(PROFILE);

      $emailtaken = 1;   # set default
      last if ( lc(@fields[0]) eq lc($in{'email'}) && lc(@fields[0]) ne lc($in{'oldemail'}) );
      $emailtaken = 0;   # not taken
    }

    # Check for invalid fields from form input
    if (length($in{'name'}) > 16 || $in{'name'} =~ /\s+/ || $in{'name'} =~ /\"/ || $in{'name'} eq '' || $in{'email'} !~ /.+@.+\..+/ || $in{'pass'} ne $in{'verify'} || $in{'pass'} eq '' || $in{'verify'} eq '' || $in{'uin'} =~ /\D+/ || $emailtaken)
    {
      print qq^
    <html>

    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>Modify Your Profile</title>
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
    <tr><td bgcolor="$colors{'functitle'}" align=center><font face="system" color="$colors{'functitletext'}"><img src="/megaboard/images/profile.gif">Modify Your Profile</font></td></tr>
    <tr><td bgcolor="$colors{'functable'}">
    <font face="arial">
	<form action=megaboard.pl method=post>^;

      #if ($taken == 1)
      #{
      #  print "<font color=red>Member Name Already Taken:</font><br>\n";
      #}
      #elsif (length($in{'name'}) > 16 || $in{'name'} =~ /\s+/ || $in{'name'} =~ /\"/ || $in{'name'} eq '')
      #{
      #  print "<font color=red>Invalid Member Name:</font><br>\n";
      #}
      #else
      #{
      #  print "Enter your desired membername<br>(16 characters max, no spaces):<br>\n";
      #}
      print qq^
      <input type=hidden name="name" value="$in{'name'}"><font face="verdana" size=2><b>$in{'name'}</b></font><p>^;

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
      <input type=hidden name="modifyprofile" value="1">
	  <input type=hidden name="oldname" value="$in{'oldname'}">
	  <input type=hidden name="oldemail" value="$in{'oldemail'}">
	  <input type=hidden name="forum" value="$in{'forum'}">
      <input type=hidden name="job" value="profile">
      <input type=submit value="Modify" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">&nbsp;<input type=reset value="Clear" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">
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
	  $in{'name'} =~ s/\//|/g;

      $in{'email'} =~ s/</&lt;/g;
      $in{'email'} =~ s/>/&gt;/g;
      $in{'email'} =~ s/"/&quot;/g;
	  $in{'email'} =~ s/\//|/g;

      # Write the profile record
      open(PROFILE, ">$profilepath/$in{'oldname'}/profile.dat");
      print PROFILE "$in{'email'}\n";
      print PROFILE "$in{'uin'}\n";
      print PROFILE "$encrypted_pass";
      close(PROFILE);

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
      Profile modified successfully<p>
      Member name: <b>$in{'name'}</b><br>
      Email: <b>$in{'email'}</b><br>
      ICQ UIN: <b>$in{'uin'}</b><br>
      Password: <i>encrypted</i><p>
	  Please Log-in again to utilize the changes^;

	  &footer;
	  
	  print qq^</body></html>^;

    } # END IF
  } # END IF
}

1;

