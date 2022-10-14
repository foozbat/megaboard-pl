sub DeleteThread
{
  if ($in{'delete'} eq '')
  {
	open(TITLE, "<$messagepath/$in{'topic'}/$in{'thread'}");
	chomp($messagetitle = <TITLE>);
	close(TITLE);

	print qq^
	<html>

	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>Delete A Thread</title>
	<style>
		  a:link   {text-decoration:none}
		  a:visited{text-decoration:none}
		  a:hover  {text-decoration:underline}
	</style>
	</head>

<body background="$forumurl/$settings{'backgroundimage'}" bgcolor="$colors{'messageback'}" text="$colors{'messagetext'}" link=$colors{'links'} vlink=$colors{'links'} alink=$colors{'links'}>^;

if ($cookie{'frames'} eq 'off')
{
  &header;
}
print qq^
	<font face="arial" size="+1" color=white><b>$topic{$in{'topic'}}</b> &gt; $messagetitle
	<center>
	<p>
	<table border=0 cellpadding=3 cellspacing=1>
	<tr><td bgcolor="#C0C0C0" align=center><table cellspacing=0 cellpadding=0 border=0><tr><td><img src="/megaboard/images/delete.gif"></td><td><font face="system">Delete an entire thread</font></td></tr></table></td></tr>
	<tr><td bgcolor="#EFEFEF">
	<font face="arial">
	Only Moderators or Administrators may delete threads.
	<form action="megaboard.pl" method="post">
	<table>
	  <TR><TD>Name:</TD><TD>Password (case sensitive):</TD></TR>
	  <TR><TD><INPUT TYPE="TEXT" SIZE="27" NAME="name" value="$cookie{'name'}"></TD><TD><INPUT TYPE="password" SIZE="28" NAME="pass" value="$cookie{'pass'}"></TD></TR>
	  <TR><TD COLSPAN="2"><input type="checkbox" name="savepass" value="ON" checked>Check here to save your password on this computer.
	  <INPUT TYPE="hidden" NAME="job" VALUE="deletethread">
	  <INPUT TYPE="hidden" NAME="forum" VALUE="$in{'forum'}">
	  <INPUT TYPE="hidden" NAME="topic" VALUE="$in{'topic'}">
	  <INPUT TYPE="hidden" NAME="thread" VALUE="$in{'thread'}"></TD></TR>
	  <TR><TD COLSPAN="2" align=center><INPUT TYPE="SUBMIT" NAME="delete" VALUE="Delete Thread">&nbsp;&nbsp;<INPUT TYPE="RESET" VALUE="Clear Form"></TR></TD>
	</table>
	</td></tr></table>^;

	  &footer;

	  print qq^
	  </body></html>^;
  }
  elsif ($in{'delete'} eq 'Delete Thread')
  {
    opendir(PROFILES, "$profilepath");
    chomp(@profiles = readdir(PROFILES));
    closedir(PROFILES);

    # Check to see if the name is good
    foreach $profile (@profiles)
    {
      if (lc($profile) eq lc($in{'name'})) 
      {
        $found = 1;
      } # END IF
    } # END FOREACH

    open(PASS, "<$profilepath/$in{'name'}/profile.dat");
    chomp(@profile = <PASS>);
    close(PASS);

    $password = crypt($in{'pass'}, 'limabean');

# Check the moderator password
	if ($password eq @profile[2] && @profile[3] eq 'moderator')
	{
	  $passcorrect = 1;
	}
	elsif ($password eq @profile[2] && @profile[3] eq 'administrator')
	{
	  $passcorrect = 1;
	}

    if (!$found || $in{'name'} eq '' || !$passcorrect)
    {
	  print qq^
	  <html>

	  <head>
	  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	  <title>Delete A Thread</title>
	  <style>
			a:link   {color:"navy"; text-decoration:none}
			a:visited{color:"navy"; text-decoration:none}
			a:hover  {color:"navy"; text-decoration:underline}
	  </style>
	  </head>

	  <body bgcolor=black text=black link="navy" vlink="navy" alink="blue">
	  <font face="arial" size="+1" color=white><b>$topic{$in{'topic'}}</b> &gt; 
	  <center>
	  <p>
	  <table border=0 cellpadding=3 cellspacing=1>
	  <tr><td bgcolor="#C0C0C0" align=center><table cellspacing=0 cellpadding=0 border=0><tr><td><img src="/megaboard/images/delete.gif"></td><td><font face="system">Delete an entire thread</font></td></tr></table></td></tr>
	  <tr><td bgcolor="#EFEFEF">
	  <font face="arial">
	  Only Moderators or Administrators may delete threads.
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
		<TR><TD><INPUT TYPE="TEXT" SIZE="27" NAME="name" value="$cookie{'name'}"></TD><TD><INPUT TYPE="password" SIZE="28" NAME="pass" value="$cookie{'pass'}"></TD></TR>
		<TR><TD COLSPAN="2"><input type="checkbox" name="savepass" value="ON" checked>Check here to save your password on this computer.
		<INPUT TYPE="hidden" NAME="job" VALUE="deletethread">
		<INPUT TYPE="hidden" NAME="forum" VALUE="$in{'forum'}">
	  <INPUT TYPE="hidden" NAME="topic" VALUE="$in{'topic'}">
	  <INPUT TYPE="hidden" NAME="thread" VALUE="$in{'thread'}"></TD></TR>

		<TR><TD COLSPAN="2" align=center><INPUT TYPE="SUBMIT" NAME="delete" VALUE="Delete Thread">&nbsp;&nbsp;<INPUT TYPE="RESET" VALUE="Clear Form"></TR></TD>
	  </table>
	  </td></tr></table>^;

	  &footer;

	  print qq^
	  </body></html>^;
	} 
    else
	{
	  open(THREAD, "<$messagepath/$in{'topic'}/$in{'thread'}");
	  chomp(@thread = <THREAD>);
	  close(THREAD);

	  open(TOTALMESSAGES, "<$messagepath/totalmessages");
	  chomp($totalmessages = <TOTALMESSAGES>);
	  close(TOTALMESSAGES);

	  $totalmessages -= @thread-1;

	  open(TOTALMESSAGES, ">$messagepath/totalmessages");
	  print TOTALMESSAGES $totalmessages;
	  close(TOTALMESSAGES);

	  # delete the thread
	  unlink "$messagepath/$in{'topic'}/$in{'thread'}";

	  print qq^
	  <html>

	  <head>
	  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	  <title>Delete A Message</title>
	  <style>
			a:link   {color:"navy"; text-decoration:none}
			a:visited{color:"navy"; text-decoration:none}
			a:hover  {color:"navy"; text-decoration:underline}
	  </style>
	  </head>

	  <body bgcolor=black text=black link="navy" vlink="navy" alink="blue">
	  <font face="arial" size="+1" color=white><b>$topic{$in{'topic'}}</b> 
	  <center>
	  <p>
	  <table border=0 cellpadding=3 cellspacing=1>
	  <tr><td bgcolor="#C0C0C0" align=center><font face="system"><img src="/megaboard/images/delete.gif">Delete an entire thread</font></td></tr>
	  <tr><td bgcolor="#EFEFEF">
	  <font face="arial">
	  <table cellpadding=5>
      <tr><td align=center>Thread $topic2num{$in{'topic'}}.$in{'thread'} has been delelted.<br></td></tr></table>
	  </td></tr></table>

      </center>^;

	  &footer;

	  print qq^

      </body>
      </html>^;
	}


  } # END IF
} # End of subroutine

1;