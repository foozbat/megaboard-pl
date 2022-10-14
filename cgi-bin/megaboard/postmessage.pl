# ----------------------------------------
# PostMessage
# ----------------------------------------

sub PostMessage
{
  if ($in{'postit'} eq '')
  {
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
    <font face="arial" size="+1" color="$colors{'funcbacktext'}"><b>$topic{$in{'topic'}}</b> > New Thread
    <center>
    <p>
	<table border=0 cellpadding=0 cellspacing=0>
	<td bgcolor="$colors{'functableborder'}">
    <table border=0 cellpadding=2 cellspacing=1>
    <tr><td bgcolor="$colors{'functitle'}" align=center><font face="system" color="$colors{'functitletext'}"><img src="/megaboard/images/post.gif">Post a Message</font></td></tr>
    <tr><td bgcolor="$colors{'functable'}">
    <font face="arial">^;
if (!$cookie{'name'})
{
    print qq^
    You must register a member name to post a message.<br>
    Click <a href="megaboard.pl?forum=$in{'forum'}&job=newmember">HERE</a> to register one now.^;
}
    print qq^
    <FORM ACTION="megaboard.pl" method=post>
    <TABLE>
      <TR><TD><font face="arial">Name:</TD><TD><font face="arial">Password (case-sensitive):</TD></TR>
      <TR><TD><INPUT TYPE="TEXT" SIZE="27" NAME="name" value="$cookie{'name'}" 
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"></TD><TD><INPUT TYPE="password" SIZE="28" NAME="pass" value="$cookie{'pass'}" 
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}""></TD></TR>
      <TR><TD COLSPAN="2"><font face="arial">Message Title:
      <TR><TD COLSPAN="2"><INPUT TYPE="TEXT" SIZE="63" NAME="title" 
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}""></TD></TR>
      <TR><TD COLSPAN="2"><font face="arial">Enter your message below:</TD></TR>
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
	  print qq^</TEXTAREA>
      <TR><TD COLSPAN="2">^;
	  
	  if ($settings{'htmlposts'} eq 'on')
	  {
	  print qq^<font face="arial"><input type="checkbox" name="HTML" value="ON">Check here if your message contains HTML.<br>^;
	  }
	  elsif (&authcookie)
	  {
	    print qq^<font face="arial"><input type="checkbox" name="HTML" value="ON">[<font color=$colors{'admincolor'}>ADMIN</font>] Check here if your message contains HTML.<br>^;
	  }

	  if (&authcookie)
	  {
		print qq^<font face="arial"><input type="checkbox" name="persistent" value="ON">[<font color=$colors{'admincolor'}>ADMIN</font>] Persistent Thread (stays on top always).<br>^;
	  }


	  print qq^
                          <font face="arial"><input type="checkbox" name="savepass" value="ON" checked>Check here to save your password on this computer.</TD></TR>
      <TR><TD COLSPAN="2" ALIGN="CENTER"><font face="arial">
	  <INPUT TYPE="hidden" NAME="job" VALUE="postmessage">
	  <INPUT TYPE="hidden" NAME="forum" VALUE="$in{'forum'}">
	  <INPUT TYPE="hidden" NAME="topic" VALUE="$in{'topic'}">
      <INPUT TYPE="hidden" NAME="to" VALUE="ALL">
      <INPUT TYPE="SUBMIT" Name="postit" VALUE="Post Message" 
	  style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1"> <INPUT TYPE="SUBMIT" NAME="postit" VALUE="Preview" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1"> <INPUT TYPE="RESET" VALUE="Clear Form" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">^;

	  if ($settings{'htmlposts'} eq 'on' || &authcookie)
	  {
	    print qq^
		<p><font size="2">
		HTML Tips:
		Make sure you close all tags that you open,<br> i.e. make sure you don't leave the &gt; off the end of a tag
		^;
	  }
	print qq^</TD></TR>
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
  elsif ($in{'postit'} eq 'Post Message')
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

    open(PASS, "<$profilepath/$in{'name'}/profile.dat");
    chomp(@user = <PASS>);
    close(PASS);

    $password = crypt($in{'pass'}, 'limabean');

	#check to see if user is banned
	open(BANFILE, "<$datapath/banned.dat");
	chomp(@bannedips = <BANFILE>);
	close(BANFILE);

	foreach $ip (@bannedips)
	{
	  if ($ENV{REMOTE_ADDR} eq $ip)
	  {
	    $banned = 1;
	  }
	  else
	  {
	    $banned = 0;
	  }
	}

    if (!$found || $in{'name'} eq '' || $in{'title'} !~ /\w+/ || $password ne @user[2])
    {
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
    <font face="arial" size="+1" color="$colors{'funcbacktext'}"><b>$topic{$in{'topic'}}</b> > New Thread
    <center>
    <p>
	<table border=0 cellpadding=0 cellspacing=0>
	<td bgcolor="$colors{'functableborder'}">
    <table border=0 cellpadding=2 cellspacing=1>
    <tr><td bgcolor="$colors{'functitle'}" align=center><font face="system" color="$colors{'functitletext'}"><img src="/megaboard/images/post.gif">Post a Message</font></td></tr>
    <tr><td bgcolor="$colors{'functable'}">
    <font face="arial">^;

if (!$cookie{'name'})
{
    print qq^
    You must register a member name to post a message.<br>
    Click <a href="megaboard.pl?job=newmember">HERE</a> to register one now.^;
}
      

    print qq^
      </font><p>
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
        <TR><TD><INPUT TYPE="TEXT" SIZE="27" NAME="name" VALUE="$in{'name'}"
		style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"></TD>
		<TD><INPUT TYPE="password" SIZE="28" NAME="pass" value="$in{'pass'}"
		style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"></TD></TR>
        <TR><TD COLSPAN="2">^;
if ($in{'title'} eq '' || $in{'title'} eq '\s+')
{
  print "<font color=red>You did not enter a message title.";
}
else
{
  print "Message Title:";
}
        print qq^
        <TR><TD COLSPAN="2"><INPUT TYPE="TEXT" SIZE="58" NAME="title" value="$in{'title'}"
		style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"></TD></TR>
        <TR><TD COLSPAN="2">Enter your message below:</TD></TR>
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

	  ## persistent messages
	  if ($in{'persistent'} eq 'ON' && &authcookie)
	  {
		print qq^<font face="arial"><input type="checkbox" name="persistent" value="ON" checked>[<font color=$colors{'admincolor'}>ADMIN</font>] Persistent Thread (stays on top always).<br>^;
	  }
	  elsif (&authcookie)
	  {
		print qq^<font face="arial"><input type="checkbox" name="persistent" value="ON">[<font color=$colors{'admincolor'}>ADMIN</font>] Persistent Thread (stays on top always).<br>^;
	  }

	  print qq^<input type="checkbox" name="savepass" value="ON" checked>Check here to save your password on this computer.</TD></TR>
        <TR><TD COLSPAN="2" ALIGN="CENTER">
	    <INPUT TYPE="hidden" NAME="job" VALUE="postmessage">
        <INPUT TYPE="hidden" NAME="forum" VALUE="$in{'forum'}">
	    <INPUT TYPE="hidden" NAME="topic" VALUE="$in{'topic'}">
        <INPUT TYPE="hidden" NAME="to" VALUE="ALL">
        <INPUT TYPE="SUBMIT" Name="postit" VALUE="Post Message" 
	  style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">&nbsp;<INPUT TYPE="SUBMIT" NAME="postit" VALUE="Preview" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">&nbsp;<INPUT TYPE="RESET" VALUE="Clear Form" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">^;

	  if ($settings{'htmlposts'} eq 'on' || &authcookie)
	  {
	    print qq^
		<p><font size="2">
		HTML Tips:
		Make sure you close all tags that you open,<br> i.e. make sure you don't leave the &gt; off the end of a tag
		^;
	  }
	print qq^</td></tr></TABLE>
      </FORM>
      </td></tr></table>
	</td></table>

      </center>^;

	  &footer;

	  print qq^
      </body>
      </html>^;
    
    }
	elsif ($banned)
	{
	  print qq^
	  <body bgcolor=black text=white>
	  <h2>You've been banned!</h2>
	  Shame on you...^;
	}
    else
    {
      opendir(DIR, "$messagepath/$in{'topic'}");
      chomp(@files = readdir(DIR));
      closedir(DIR);

	  if ($in{'persistent'} eq 'ON' && &authcookie)
	  {
		$largestpersistentnum = 0;
		$count1 = 0;
		foreach $threadnum (@files)
		{
			if ($threadnum =~ /persistent/)
			{
				($blahpoo, $persistentnum) = split(/-/, $threadnum);
				if ($persistentnum > $largestpersistentnum)
				{
					$largestpersistentnum = $persistentnum;
				}
				@files[$count1] = -1;
			}
			$count1 += 1;
		}
	    $persistentnum = $largestpersistentnum + 1;
	  }

	  # new message file to be created
	  @sorted = sort numerically @files;
	  $newfile = @sorted[-1] + 1;

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
  
  	  $in{'title'} =~ s/"/&quot;/g;

      $time = &GetTime;

# update the total number of messages posted, used for displaying message list

      open(TOTALIN, "<$messagepath/totalmessages");
      chomp($total = <TOTALIN>);
      close(TOTALIN);
      $total += 1;
      open(TOTALOUT, ">$messagepath/totalmessages");
      print TOTALOUT "$total";
      close(TOTALOUT);

# update the user's total posts
      open(USERPOSTS, "<$profilepath/$in{'name'}/posts.dat");
      chomp($userposts = <USERPOSTS>);
      close(USERPOSTS);
      $userposts += 1;
      open(POSTINC, ">$profilepath/$in{'name'}/posts.dat");
      print POSTINC "$userposts";
      close(POSTINC);

# has the user won the most posts award?
      opendir(PROFILES, "$profilepath");
      chomp(@members = readdir(PROFILES));
      closedir(PROFILES);
      foreach $member (@members)
      {
        open(NUM, "<$profilepath/$member/posts.dat");
        chomp($posts = <NUM>);
        close(NUM);

        $award = 0;
        last if ($userposts < $posts);
        $award = 1;
      }
      if ($award == 1)
      {
        open(AWARD, ">$awardpath/posts");
        print AWARD "$in{'name'}";
        close(AWARD);
      }

	  $in{'name'} =~ s/\|/&pipe;/g;

# Create the message file
	  if ($in{'persistent'} eq 'ON' && &authcookie)
	  {
		  $persistentfilename = 'persistent-';
		  $persistentfilename .= $persistentnum;
		  
	      open(MESSAGEFILE, ">$messagepath/$in{'topic'}/$persistentfilename") or die "Could not open file!";
		  print MESSAGEFILE "$in{'title'}\n";
		  print MESSAGEFILE "$in{'name'}\|";
		  print MESSAGEFILE "$in{'to'}\|";
		  print MESSAGEFILE "$time\|";
		  print MESSAGEFILE "$in{'textmessage'}\|";
		  print MESSAGEFILE "$total\||";
		  print MESSAGEFILE "$ENV{REMOTE_ADDR}\n";
		  close(MESSAGEFILE);
	  }
	  else
	  {
		  open(MESSAGEFILE, ">$messagepath/$in{'topic'}/$newfile") or die "Could not open file!";
		  print MESSAGEFILE "$in{'title'}\n";
		  print MESSAGEFILE "$in{'name'}\|";
		  print MESSAGEFILE "$in{'to'}\|";
		  print MESSAGEFILE "$time\|";
		  print MESSAGEFILE "$in{'textmessage'}\|";
		  print MESSAGEFILE "$total\||";
		  print MESSAGEFILE "$ENV{REMOTE_ADDR}\n";
		  close(MESSAGEFILE);
	  }

	  print qq^
	    <HTML>
		<HEAD>
		<SCRIPT LANGUAGE="JavaScript">
		window.location = "^;
		if ($in{'persistent'} eq 'ON' && &authcookie)
		{
			print qq^megaboard.pl?forum=$in{'forum'}&job=viewthread&topic=$in{'topic'}&thread=$persistentfilename&startat=1&new=$total^;
		}
		else
		{
			print qq^megaboard.pl?forum=$in{'forum'}&job=viewthread&topic=$in{'topic'}&thread=$newfile&startat=1&new=$total^;
		}
					
		print qq^";
		</SCRIPT>
		<BODY BGCOLOR=$colors{'funcback'} text=$colors{'funcbacktext'} link=$colors{'links'} vlink=$colors{'links'} alink=$colors{'links'}>
		If this page does not automatically redirect,^;
		if ($in{'persistent'} eq 'ON' && &authcookie)
		{
			print qq^<a href="megaboard.pl?forum=$in{'forum'}&job=viewthread&topic=$in{'topic'}&thread=$persistentfilename&startat=1&new=$total">click here to view your post</a>.^;
		}
		else
		{
			print qq^<a href="megaboard.pl?forum=$in{'forum'}&job=viewthread&topic=$in{'topic'}&thread=$newfile&startat=1&new=$total">click here to view your post</a>.^;
		}
		
		print qq^
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
$body =~ s/&gt;\:O/\<img src\=\"\/megaboard\/emoticons\/pissed\.gif\" border\=0\>/g;
$body =~ s/>\:O/\<img src\=\"\/megaboard\/emoticons\/pissed\.gif\" border\=0\>/g;
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

      <font face="Arial" color="$colors{'messagewindowbacktext'}"><big><strong>$topic{$in{'topic'}} </strong>&gt; $in{'title'}</big></p>
	  
	  <table border="0" width="100%" cellspacing=0 cellpadding=0>
	  <td bgcolor="$colors{'functableborder'}">
      <table border="0" width="100%" cellspacing="1" cellpadding="4">
	  <tr>
		<td width="170" bgcolor="$colors{'messagetopoftable'}" valign="top" align="left" nowrap><font face="verdana" size=2 color="$colors{'messagetoptext'}"><b>Member Name:</b></font></td>
		<td bgcolor="$colors{'messagetopoftable'}" valign="top" align="left"><font face="verdana" size=2 color="$colors{'messagetoptext'}"><b>Messages:</b></font></td>
	  </tr>
      <tr>
      <td width="170" bgcolor="$bgcolor" valign="top" align="left"><font
      face="Arial"><a name="$in{'thread'}.$file"></a><b>$in{'name'}</b> ^;

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

print qq^
      </font></td>
      </tr>
      <tr>
        <td valign="top" align="left" height="21" nowrap width="100%"><font size="-1" face="arial"><font color=$color{'links'}>$topic2num{$in{'topic'}}.$newdir.1</font>^;

       print qq^
       </font></td>
        <td valign="top" align="right" height="21" width="120" nowrap><font size="-1" face="arial">[1 of
        1]</font></td>
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
     <font face="Arial" color="$colors{'funcbacktext'}" size=5>
     Revise Your Post</font>

     
     <TABLE>
      <TR><TD COLSPAN="2"><font face="Arial" color="$colors{'funcbacktext'}">Message Title:
      <TR><TD COLSPAN="2"><INPUT TYPE="TEXT" SIZE="58" NAME="title" VALUE="$in{'title'}"
	  style="background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'}"></TD></TR>
      <TR><TD COLSPAN="2"><font face="Arial" color="#FFFFFF">Enter your message below:</TD></TR>
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

	  if ($in{'persistent'} eq 'ON' && &authcookie)
	  {
		print qq^<font face="arial"><input type="checkbox" name="persistent" value="ON" checked>[<font color=$colors{'admincolor'}>ADMIN</font>] Persistent Thread (stays on top always).<br>^;
	  }
	  elsif (&authcookie)
	  {
		print qq^<font face="arial"><input type="checkbox" name="persistent" value="ON">[<font color=$colors{'admincolor'}>ADMIN</font>] Persistent Thread (stays on top always).<br>^;
	  }

	  print qq^</TD></TR>
      <TR><TD COLSPAN="2" ALIGN="CENTER">
	  <INPUT TYPE="hidden" NAME="job" VALUE="postmessage">
  	  <INPUT TYPE="hidden" NAME="forum" VALUE="$in{'forum'}">
	  <INPUT TYPE="hidden" NAME="topic" VALUE="$in{'topic'}">
      <INPUT TYPE="hidden" NAME="to" VALUE="ALL">
      <INPUT TYPE="hidden" NAME="name" VALUE="$in{'name'}">
      <INPUT TYPE="hidden" NAME="pass" VALUE="$in{'pass'}">
	  <INPUT TYPE="SUBMIT" Name="postit" VALUE="Post Message" 
	  style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">&nbsp;<INPUT TYPE="SUBMIT" NAME="postit" VALUE="Preview" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">&nbsp;<INPUT TYPE="RESET" VALUE="Clear Form" style="background-color: $colors{'functitle'}; cursor: hand; color: $colors{'functitletext'}; border-style: solid; border-width: 1">^;

	  if ($settings{'htmlposts'} eq 'on' || &authcookie)
	  {
	    print qq^
		<p><font size="2">
		HTML Tips:
		Make sure you close all tags that you open,<br> i.e. make sure you don't leave the &gt; off the end of a tag
		^;
	  }
	print qq^</FORM></TABLE>
     

     </center>^;

	  &footer;

	  print qq^
	  </body>
	  </html>

     ^;
  } # END IF

}

1;