# ----------------------------------------
# Edit
# ----------------------------------------

sub Edit
{
  if ($in{'postit'} eq '')
  {
    open(THREAD, "<$messagepath/$in{'topic'}/$in{'thread'}");
    chomp(@thread = <THREAD>);
    close(THREAD);

    $old = @thread[$in{'messno'}];
	@oldmessage = split(/\|/, $old);

    $messagetitle = @thread[0];

    $membername    = @oldmessage[0];
    $messageto     = @oldmessage[1];
    $messagetime   = @oldmessage[2];
    $messagetext   = @oldmessage[3];

    $messagetext =~ s/<br>/\n/g;
	$messagetext =~ s/<p>/\n/g;

    @replytext = split("\n", $messagetext);

    print qq^
    <html>

    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>Edit A Message</title>
    <style>
	    a:link   {text-decoration:none}
    	a:visited{text-decoration:none}
	    a:hover  {text-decoration:underline}
    </style>
    </head>

    <body background="$forumurl/$settings{'backgroundimage'}" bgcolor=$colors{'funcback'} text=$colors{'functabletext'} link="$colors{'links'}" vlink="$colors{'links'}" alink="$colors{'links'}">^;

if ($cookie{'frames'} eq 'off')
{
  &header;
}

print qq^
    <font face="arial" size="+1" color=white><b>$topic{$in{'topic'}}</b> > $messagetitle
    <center>
    <p>
	<table border=0 cellpadding=0 cellspacing=0>
	<td bgcolor="$colors{'functableborder'}">
    <table border=0 cellpadding=2 cellspacing=1>
    <tr><td bgcolor="$colors{'functitle'}" align=center><font face="system" color="$colors{'functitletext'}"><img src="/megaboard/images/edit.gif">Edit Your Message</font></td></tr>
    <tr><td bgcolor="$colors{'functable'}">
    <font face="arial">^;
if (!$cookie{'name'})
{
    print qq^
    You must register a member name to post a message.<br>
    Click <a href="megaboard.pl?job=newmember">HERE</a> to register one now.^;
}
    print qq^
    <FORM ACTION="megaboard.pl" method=post>
    <TABLE>
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
      <TR><TD COLSPAN="2">Edit your message below:</TD></TR>
      <TR><TD COLSPAN="2" ALIGN="CENTER">^;
	  
	  if ($ENV{HTTP_USER_AGENT} =~ /MSIE/)
	  {
	    print qq^<TEXTAREA COLS=50 ROWS=15 WRAP="VIRTUAL" NAME="textmessage" 
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}">^;
	  }
	  else
	  {
	    print qq^<TEXTAREA COLS=50 ROWS=15 WRAP="VIRTUAL" NAME="textmessage">^;
	  }
	  
    foreach $line (@replytext)
    {
      print "$line\n";
    } 

    print qq^</TEXTAREA>
      <TR><TD COLSPAN="2">^;
	  
	  if ($settings{'htmlposts'} eq 'on')
	  {
	  print qq^<input type="checkbox" name="HTML" value="ON">Check here if your message contains HTML.<br>^;
	  }
	  elsif (&authcookie)
	  {
	    print qq^<font face="arial"><input type="checkbox" name="HTML" value="ON">[<font color=$colors{'admincolor'}>ADMIN</font>] Check here if your message contains HTML.<br>^;
	  }

	  print qq^<input type="checkbox" name="savepass" value="ON" checked>Check here to save your password on this computer.</TD></TR>
      <TR><TD COLSPAN="2" ALIGN="CENTER">
	  <INPUT TYPE="hidden" NAME="job" VALUE="edit">
	  <INPUT TYPE="hidden" NAME="forum" VALUE="$in{'forum'}">
	  <INPUT TYPE="hidden" NAME="topic" VALUE="$in{'topic'}">
      <INPUT TYPE="hidden" NAME="thread" VALUE="$in{'thread'}">
	  <INPUT TYPE="hidden" NAME="messno" VALUE="$in{'messno'}">
      <INPUT TYPE="SUBMIT" NAME="postit" VALUE="Modify Message" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">&nbsp;<INPUT TYPE="SUBMIT" NAME="postit" VALUE="Preview" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">&nbsp;<INPUT TYPE="RESET" VALUE="Clear Form" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">^;

	  if ($settings{'htmlposts'} eq 'on' || &authcookie)
	  {
	    print qq^
		<p><font size="2">
		HTML Tips:
		Make sure you close all tags that you open,<br> i.e. make sure you don't leave the &gt; off the end of a tag
		^;
	  }
	print qq^
	</TD></TR>
    </TABLE>
    </FORM>
    </td></tr></table>
	</td></table>


    </center>^;

	  &footer;

	  print qq^

    </body>
    </html>^;
  }
  elsif ($in{'postit'} eq 'Modify Message')
  {
    opendir(PROFILES, "$profilepath");
    chomp(@profiles = readdir(PROFILES));
    closedir(PROFILES);

    foreach $profile (@profiles)
    {
      if (lc($profile) eq lc($in{'name'})) 
      {
        $in{'name'} = $profile;
        $found = 1;
      }
    }

#    open(OLDMESSAGE, "<$messagepath/$in{'topic'}/$in{'thread'}/$in{'messno'}");
#	chomp(@lines = <OLDMESSAGE>);
#	close(OLDMESSAGE);

    open(THREAD, "<$messagepath/$in{'topic'}/$in{'thread'}");
    chomp(@thread = <THREAD>);
    close(THREAD);

    @lines = split(/\|/, @thread[$in{'messno'}]);

    open(PASS, "<$profilepath/$in{'name'}/profile.dat");
    chomp(@profile = <PASS>);
    close(PASS);

# Check to see if this is the owner
	if (lc(@lines[0]) eq lc($in{'name'}))
	{
      $owner = 1;  # he is the owner
	}
# Check to see if this is a moderator or admin
#	elsif (@profile[3] eq 'moderator')
#	{
#	  $owner = 1;
#	}

    $password = crypt($in{'pass'}, 'limabean');

# Check user's password
	if ($password eq @profile[2] && lc(@lines[0]) eq lc($in{'name'}))
	{
      $passcorrect = 1;
	}
# Check the moderator password (if applicable)
#	elsif ($password eq @profile[2] && @profile[3] eq 'moderator')
#	{
#	  $passcorrect = 1;
#	}

    $password = crypt($in{'pass'}, 'limabean');


    if (!$found || !$owner || $in{'name'} eq '' || !$passcorrect)
    {
    open(THREAD, "<$messagepath/$in{'topic'}/$in{'thread'}");
    chomp(@thread = <THREAD>);
    close(THREAD);

    $old = @thread[$in{'messno'}];
	@oldmessage = split(/\|/, $old);

    $messagetitle = @thread[0];

    $membername    = @oldmessage[0];
    $messageto     = @oldmessage[1];
    $messagetime   = @oldmessage[2];
    $messagetext   = @oldmessage[3];

    $messagetext =~ s/<br>/\n/g;
	$messagetext =~ s/<p>/\n/g;

    @oldtext = split("\n", $messagetext);

      print qq^
      <html>

      <head>
      <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
      <title>Post A Message</title>
	<style>
	    a:link   {text-decoration:none}
    	a:visited{text-decoration:none}
	    a:hover  {text-decoration:underline}
    </style>
    </head>

    <body background="$forumurl/$settings{'backgroundimage'}" bgcolor=$colors{'funcback'} text=$colors{'functabletext'} link="$colors{'links'}" vlink="$colors{'links'}" alink="$colors{'links'}">^;

if ($cookie{'frames'} eq 'off')
{
  &header;
}

print qq^
    <font face="arial" size="+1" color=$colors{'funcbacktext'}><b>$topic{$in{'topic'}}</b> > $messagetitle
    <center>
    <p>
	<table border=0 cellpadding=0 cellspacing=0>
	<td bgcolor="$colors{'functableborder'}">
    <table border=0 cellpadding=2 cellspacing=1>
    <tr><td bgcolor="$colors{'functitle'}" align=center><font face="system" color="$colors{'functitletext'}"><img src="/megaboard/images/edit.gif">Edit Your Message</font></td></tr>
    <tr><td bgcolor="$colors{'functable'}">
	  <font face="arial">^;
	  if (!$cookie{'name'})
	  {
		  print qq^
		  You must register a member name to post a message.<br>
		  Click <a href="megaboard.pl?job=newmember">HERE</a> to register one now.^;
	  }
	  print qq^
		<FORM ACTION="megaboard.pl" method=post>
		<TABLE>
		  <TR><TD>^;
	  if ($in{'name'} eq '') 
	  {
		print "<font color=red>You did not enter a name.";
	  }
	  elsif (!$found || !$owner)
	  {
		print "<font color=red>Invalid User.";
	  }
	  else
	  {
		print "Name:";
	  }
			  print "</TD><TD>";

	  if (!$passcorrect || !$found || !$owner)
	  {
		print "<font color=red>Incorrect Password.";
	  }
	  else
	  {
		print "Password:";
	  }
        print qq^
        </TD></TR>
        <TR><TD><INPUT TYPE="TEXT" SIZE="27" NAME="name"
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"></TD>
		<TD><INPUT TYPE="password" SIZE="28" NAME="pass"
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"></TD></TR>
        <TR><TD COLSPAN="2">Edit your message below:</TD></TR>
        <TR><TD COLSPAN="2" ALIGN="CENTER">^;
	  
	  if ($ENV{HTTP_USER_AGENT} =~ /MSIE/)
	  {
	    print qq^<TEXTAREA COLS=50 ROWS=15 WRAP="VIRTUAL" NAME="textmessage" 
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}">^;
	  }
	  else
	  {
	    print qq^<TEXTAREA COLS=50 ROWS=15 WRAP="VIRTUAL" NAME="textmessage">^;
	  }
	  print qq^$in{'textmessage'}</TEXTAREA>
      <TR><TD COLSPAN="2">^;
	  
	  if ($settings{'htmlposts'} eq 'on')
	  {
	  print qq^<input type="checkbox" name="HTML" value="ON">Check here if your message contains HTML.<br>^;
	  }
	  elsif (&authcookie)
	  {
	    print qq^<font face="arial"><input type="checkbox" name="HTML" value="ON">[<font color=$colors{'admincolor'}>ADMIN</font>] Check here if your message contains HTML.<br>^;
	  }

	  print qq^<input type="checkbox" name="savepass" value="ON" checked>Check here to save your password on this computer.</TD></TR>
        <TR><TD COLSPAN="2" ALIGN="CENTER">
	  <INPUT TYPE="hidden" NAME="job" VALUE="edit">
	  <INPUT TYPE="hidden" NAME="forum" VALUE="$in{'forum'}">
	  <INPUT TYPE="hidden" NAME="topic" VALUE="$in{'topic'}">
      <INPUT TYPE="hidden" NAME="thread" VALUE="$in{'thread'}">
	  <INPUT TYPE="hidden" NAME="messno" VALUE="$in{'messno'}">
      <INPUT TYPE="SUBMIT" NAME="postit" VALUE="Modify Message" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">&nbsp;<INPUT TYPE="SUBMIT" NAME="postit" VALUE="Preview" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">&nbsp;<INPUT TYPE="RESET" VALUE="Clear Form" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">^;

	  if ($settings{'htmlposts'} eq 'on' || &authcookie)
	  {
	    print qq^
		<p><font size="2">
		HTML Tips:
		Make sure you close all tags that you open,<br> i.e. make sure you don't leave the &gt; off the end of a tag
		^;
	  }
	print qq^
	</TD></TR>
      </TABLE>
      </FORM>
      </td></tr></table>
      </td></table>

      </center>^;

	  &footer;

	  print qq^

      </body>^;
    }
    else
    {
	  open(THREAD, "<$messagepath/$in{'topic'}/$in{'thread'}");
	  chomp(@thread = <THREAD>);
	  close(THREAD);

	  @message = split(/\|/, @thread[$in{'messno'}]);

      $membername    = @message[0];
	  $messageto     = @message[1];
	  $messagetime   = @message[2];
#	  $messagetext   = @message[3];
      $postnum       = @message[4];
	  $replyto       = @message[5];
	  $ip			 = @message[6];


      if ($in{'HTML'} eq "ON")
      {
		@temp = split(/\n/, $in{'textmessage'});
		$counter = 0;
		foreach $line (@temp)
		{
		  chop($line);
		  @temp[$counter] = $line;
		  $counter++;
		}
		$in{'textmessage'} = join('', @temp);

		$in{'textmessage'} =~ s/<br><p>/<p>/g;
	  }
      else
      {
		$in{'textmessage'} =~ s/</&lt;/g;
        $in{'textmessage'} =~ s/>/&gt;/g;

        $in{'textmessage'} = "$in{'textmessage'}z";
		@temp = split(/\n/, $in{'textmessage'});
		$counter = 0;
		foreach $line (@temp)
		{
		  chop($line);
		  @temp[$counter] = $line;
		  $counter++;
		}
		$in{'textmessage'} = join('<br>', @temp);

		$in{'textmessage'} =~ s/"/&quot;/g;
		$in{'textmessage'} =~ s/\|/&pipe;/g;
      }

      $body = $in{'textmessage'};

      $time = &GetTime;

      $body = "$body<p>[ Message edited by $in{'name'} on $time. ]";

	  @thread[$in{'messno'}] = "$membername\|$messageto\|$messagetime\|$body\|$postnum\|$replyto|$ip";

# make the message file
      open(MESSAGEFILE, ">$messagepath/$in{'topic'}/$in{'thread'}") or die "Could not open file!";

	  foreach $line (@thread)
	  {
        print MESSAGEFILE "$line\n";
	  }

	  close(MESSAGEFILE);

      open(BLECK, "<$messagepath/$in{'topic'}/$in{'thread'}");
	  chomp(@array = <BLECK>);
	  close(BLECK);

	  $total = @array - 1;
	  $startat = $total;

      
	  $rem = $total % 20;
	  if ($rem == 0)
	  { $rem = 20; }
	  $startat -= $rem;
      $startat += 1;


  	  print qq^
	    <HTML>
		<HEAD>
		<SCRIPT LANGUAGE="JavaScript">
		window.location = "megaboard.pl?forum=$in{'forum'}&job=viewthread&topic=$in{'topic'}&thread=$in{'thread'}&startat=$startat#$topic2num{$in{'topic'}}.$in{'thread'}.$total";
		</SCRIPT>
		<BODY BGCOLOR=$colors{'funcback'} text=$colors{'funcbacktext'} link=$colors{'links'} vlink=$colors{'links'} alink=$colors{'links'}>
		If this page does not automatically redirect,
		<a href="megaboard.pl?forum=$in{'forum'}&job=viewthread&topic=$in{'topic'}&thread=$in{'thread'}&startat=$startat#$topic2num{$in{'topic'}}.$in{'thread'}.$total">click here to view your post</a>.
		</BODY>
		</HTML>^;
    } # END IF
  }
# Preview a message
###############################
  elsif ($in{'postit'} eq 'Preview')
  {
      opendir(DIR, "$messagepath/$in{'topic'}");
      chomp(@dirs = readdir(DIR));
      @sorted = sort numerically @dirs;
      closedir(DIR);
      $newdir = @sorted[-1] + 1;

	  open(THREAD, "<$messagepath/$in{'topic'}/$in{'thread'}");
	  chomp(@thread = <THREAD>);
	  close(THREAD);
	  $messagetitle = @thread[0];

      # Get the member info
      open(MEMBER, "<$profilepath/$in{'name'}/profile.dat");
      chomp(@memberinfo = <MEMBER>);
      close(MEMBER);

      $memberemail = @memberinfo[0];
      $memberuin   = @memberinfo[1];
	  $rank        = @memberinfo[3];

 
      # Get the # of posts
      open(NUM, "<$profilepath/$in{'name'}/posts.dat");
      $numofposts = <NUM>;
      close(NUM);

	  # Get the # of replies
	  open(REP, "<$profilepath/$in{'name'}/replies.dat");
	  $replies = <REP>;
	  close(REP);

      # get the name of the "most posts" award winner
      open(AWARD, "<$awardpath/posts");
      $winner = <AWARD>;
      close(AWARD);

      # get the name of the "most popular" award winner
      open(AWARD, "<$awardpath/replies");
      $popular = <AWARD>;
      close(AWARD);


      $body = $in{'textmessage'};

      if ($in{'HTML'} eq "ON")
      {
        $body =~ s/\n//g;
      }
      else
      {
        $body =~ s/</&lt;/g;
        $body =~ s/>/&gt;/g;
        $body =~ s/\n\n/<p>/g;
        $body =~ s/\n/<br>/g;
        $body =~ s/"/&quot;/g;
      }

      $in{'textmessage'} =~ s/\n//g;

$body =~ s/&pipe;/|/g;

# parse for smilys :)
$body =~ s/&gt;\:\(/\<img src\=\"\/megaboard\/emoticons\/angry\.gif\" border\=0\>/g;
$body =~ s/>;\:\(/\<img src\=\"\/megaboard\/emoticons\/angry\.gif\" border\=0\>/g;
$body =~ s/\:\(/\<img src\=\"\/megaboard\/emoticons\/sad\.gif\" border\=0\>/g;
$body =~ s/&gt;\:0/\<img src\=\"\/megaboard\/emoticons\/pissed\.gif\" border\=0\>/g;
$body =~ s/>\:0/\<img src\=\"\/megaboard\/emoticons\/pissed\.gif\" border\=0\>/g;
$body =~ s/\:\)/\<img src\=\"\/megaboard\/emoticons\/smily\.gif\" border\=0\>/g;
$body =~ s/\:D/\<img src\=\"\/megaboard\/emoticons\/bigsmile\.gif\" border\=0\>/g;
$body =~ s/\;\)/\<img src\=\"\/megaboard\/emoticons\/wink\.gif\" border\=0\>/g;
$body =~ s/B\)/\<img src\=\"\/megaboard\/emoticons\/sunglasses\.gif\" border\=0\>/g;
$body =~ s/8\)/\<img src\=\"\/megaboard\/emoticons\/glasses\.gif\" border\=0\>/g;
$body =~ s/\( 8'\(\|\)/\<img src\=\"\/megaboard\/emoticons\/homer\.gif\" border\=0\>/g;

if ($body !~ /<a/)
{
	$body =~ s/<br>/ <br>/g;
	$body =~ s/(http:\/\/\S+)/<a href=\"$1\"><u>$1<\/u><\/a>/g;
	$body =~ s/ <br>/<br>/g;
}


@lines = split(/<br>/, $body);

$count = 0;
foreach $line (@lines)
{
  if ($line =~ /^\;/i) # if the line starts with a ";"
  {
    @lines[$count] = "<font color=\"$colors{'quotetext'}\"\><i>$line</i></font><br>"; # make the font color "gray" for that line
  }
  else
  {
    @lines[$count] = "$line<br>";
  }
  $count += 1;
}
      $bgcolor = $colors{'messagetableback1'};

      print qq^
      <html>

      <head>
      <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
      <title>$threadtitle</title>
      <script language="JavaScript">
      <!-- JavaScript

      function openWindow(url) {
        popupWin = window.open(url, 'new_page', 'width=350,height=200')
      }
      // done -->
      </script>
	  <style>
		a:link   {text-decoration:none}
		a:visited{text-decoration:none}
		a:hover  {text-decoration:underline}
	  </style>

      </head>

  <body background="$forumurl/$settings{'backgroundimage'}" bgcolor="$colors{'messageback'}" text="$colors{'messagetext'}" link=$colors{'links'} vlink=$colors{'links'} alink=$colors{'alink'}>^;
	if ($cookie{'frames'} eq 'off')
	{
	  &header;
	}
	print qq^

      <font face="Arial" color="$colors{'messagewindowbacktext'}"><big><strong>$topic{$in{'topic'}} </strong>&gt; $messagetitle</big></p>
	  
	  <table border="0" width="100%" cellspacing=0 cellpadding=0>
	  <td bgcolor="$colors{'functableborder'}">
      <table border="0" width="100%" cellspacing="1" cellpadding="4">
	  <tr>
		<td width="170" bgcolor="$colors{'messagetopoftable'}" valign="top" align="left" nowrap><font face="verdana" size=2 color="$colors{'messagetoptext'}"><b>Member Name:</b></font></td>
		<td bgcolor="$colors{'messagetopoftable'}" valign="top" align="left"><font face="verdana" size=2 color="$colors{'messagetoptext'}"><b>Messages:</b></font></td>
	  </tr>
      <tr>
      <td width="170" bgcolor="$bgcolor" valign="top" align="left"><font
      face="Arial"><a name="$in{'thread'}.$in{'messno'}"></a><b>$in{'name'}</b> ^;

# is he a winner?
    if ($in{'name'} eq $winner)
    {
      print "<img src=\"/megaboard/images/trophy.gif\" alt=\"$in{'name'} has the most posts on the board!\" height=15 width=19 border=0>";
    }
    if ($in{'name'} eq $popular)
    {
      print "<img src=\"/megaboard/images/thumbsup.gif\" alt=\"$in{'name'} is the most popular person on the board!\" height=15 width=19 border=0>";
    }
# is he a lamer?
    $islamer = 0;
	foreach $lamer (@lamers)
	{
	  if ($membername eq $lamer)
	  {
		  print "<img src=\"/megaboard/images/lamer.gif\" alt=\"$membername is a f***in' lamer!\" height=18 width=18 border=0>";
		  print "<br><font face=\"verdana\" size=1><b>Lamer!</b><br></font>\n";
		  $islamer = 1;
	  }
	}

	if ($islamer != 1)
	{
		if ($rank eq 'moderator' || $rank eq 'administrator')
		{
		  print "<br><font face=\"verdana\" size=1 color=$colors{'admincolor'}><b>@statusnames[5]</b><br></font>\n";
		}
		## status names
		elsif ($numofposts < 100)
		{
		  print "<br><font face=\"verdana\" size=1><b>@statusnames[0]</b><br></font>\n";
		}
		elsif ($numofposts >= 100 && $numofposts < 500)
		{
		  print "<br><font face=\"verdana\" size=1><b>@statusnames[1]</b><br></font>\n";
		}
		elsif ($numofposts >= 500 && $numofposts < 1000)
		{
		  print "<br><font face=\"verdana\" size=1><b>@statusnames[2]</b><br></font>\n";
		}
		elsif ($numofposts >= 1000 && $numofposts < 2500)
		{
		  print "<br><font face=\"verdana\" size=1><b>@statusnames[3]</b><br></font>\n";
		}
		elsif ($numofposts >= 2500)
		{
		  print "<br><font face=\"verdana\" size=1><b>@statusnames[4]</b><br></font>\n";
		}
	}

    print qq^
    <font size="-1"><a href="mailto:$memberemail"><img src="/megaboard/images/mail.gif" border=0>Email</a>^;

    if ($memberuin)
    {
      print "&nbsp;<a href=\"Javascript:openWindow('megaboard.pl?forum=$in{'forum'}&job=sendicq&sendto=$membername&subject=$threadtitle&uin=$memberuin')\"><img src=\"http://wwp.icq.com/scripts/online.dll?icq=$memberuin&img=5\" border=0>ICQ</a>\n";
    }

    print qq^
    <p>
    Number of posts: $numofposts<br>
    Times replied to: $replies
	</font></td>
      <td bgcolor="$bgcolor" valign="top" align="left"><table border="0" width="100%"
      cellspacing="0" cellpadding="0" height="40">
      <tr>
        <td valign="top" align="left" height="19" width="100%" nowrap>To: <font face="Arial">
		<b>$in{'to'}</b></font></td>
        <td valign="top" align="right" height="19" width="120" nowrap><font face="arial" size="-1">^;

$time = &GetTime;
print $time;

	$threadsize = @thread - 1;

	@message = split(/\|/, @thread[$in{'messno'}]);

	$replyto = @message[5];

print qq^
      </font></td>
      </tr>
      <tr>
        <td valign="top" align="left" height="21" nowrap width="100%"><font size="-1" face="arial"><font color=$colors{'links'}><u>$topic2num{$in{'topic'}}.$in{'thread'}.$in{'messno'}</u></font>^;

		if ($replyto >= 1)
		{
		print " in reply to <font color=$colors{'links'}><u>$topic2num{$in{'topic'}}.$in{'thread'}.$replyto</u></font>";
		}

       print qq^
       </font></td>
        <td valign="top" align="right" height="21" width="120" nowrap><font size="-1" face="arial">[$in{'messno'} of
        $threadsize]</font></td>
      </tr>
      </table>
      <hr color="$colors{'messagetableborder'}" height=1>
      <table border="0" width="100%" cellspacing="0" cellpadding="10">
      <tr>
        <td width="100%"><font face="verdana" size=2>^;

		foreach $line (@lines)
		{
		  print $line;
		}

		print qq^
        <br></font></td>
      </tr>
      </table>
      <p align=right>
      </td>
     </tr>
     </table>
	 </td></table>
<br>

     <center>

     <FORM ACTION="megaboard.pl" method=post>
     <font face="Arial" color="#FFFFFF" size=5>
     Revise Your Post</font>

     
     <TABLE>
      <TR><TD COLSPAN="2"><font face="Arial" color="#FFFFFF">Edit your message below:</TD></TR>
      <TR><TD COLSPAN="2" ALIGN="CENTER">^;
	  
	  if ($ENV{HTTP_USER_AGENT} =~ /MSIE/)
	  {
	    print qq^<TEXTAREA COLS=50 ROWS=15 WRAP="VIRTUAL" NAME="textmessage" 
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}">^;
	  }
	  else
	  {
	    print qq^<TEXTAREA COLS=50 ROWS=15 WRAP="VIRTUAL" NAME="textmessage">^;
	  }
	  print qq^$in{'textmessage'}</TEXTAREA>
      <TR><TD COLSPAN="2">^;
	  
	  if ($settings{'htmlposts'} eq 'on')
	  {
	  print qq^<input type="checkbox" name="HTML" value="ON" ^;
	    if ($in{'HTML'} eq 'ON')
		{
	      print "checked";
		}
	
	   print qq^>Check here if your message contains HTML.<br>^;
	  }
	  elsif (&authcookie)
	  {
	  print qq^<input type="checkbox" name="HTML" value="ON" ^;
	    if ($in{'HTML'} eq 'ON')
		{
	      print "checked";
		}
	
	   print qq^>[<font color=$colors{'admincolor'}>ADMIN</font>] Check here if your message contains HTML.<br>^;
	  }

	  print qq^</TD></TR>
      <TR><TD COLSPAN="2" ALIGN="CENTER">
	  <INPUT TYPE="hidden" NAME="job" VALUE="edit">
	  <INPUT TYPE="hidden" NAME="forum" VALUE="$in{'forum'}">
	  <INPUT TYPE="hidden" NAME="topic" VALUE="$in{'topic'}">
      <INPUT TYPE="hidden" NAME="thread" VALUE="$in{'thread'}">
	  <INPUT TYPE="hidden" NAME="messno" VALUE="$in{'messno'}">
      <INPUT TYPE="hidden" NAME="name" VALUE="$in{'name'}">
      <INPUT TYPE="hidden" NAME="pass" VALUE="$in{'pass'}">
      <INPUT TYPE="SUBMIT" NAME="postit" VALUE="Modify Message" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">&nbsp;<INPUT TYPE="SUBMIT" NAME="postit" VALUE="Preview" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">&nbsp;<INPUT TYPE="RESET" VALUE="Clear Form" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1"></TD></TR>^;

	  if ($settings{'htmlposts'} eq 'on')
	  {
	    print qq^
		<p><font size="2">
		HTML Tips:
		Make sure you close all tags that you open,<br> i.e. make sure you don't leave the &gt; off the end of a tag
		^;
	  }
	print qq^
     </TABLE>
     </FORM>

     </center>^;

	  &footer;

	  print qq^
	  </body>
	  </html>

     ^;
  } # END IF

}

1;