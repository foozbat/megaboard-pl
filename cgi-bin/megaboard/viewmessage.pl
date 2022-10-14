# ----------------------------------------
# ViewMessage
# ----------------------------------------

sub ViewMessage
{
# Get Form input

  @elems = split(/\./, "$in{'messno'}");

  $elem = @elems[0];
  $in{'topic'} = $num2topic{$elem};
  $in{'thread'} = @elems[1];
  $in{'file'} = @elems[2];

  # get our thread file into an array
  open(THREADFILE, "<$messagepath/$in{'topic'}/$in{'thread'}");
  chomp(@thread = <THREADFILE>);
  close(THREADFILE);

  $threadtitle = @thread[0];
  $line = @thread[$in{'file'}];
  $lastfile = @thread - 1;

  if (!$line) 
  {
    print qq^
	<html>
	  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	  <title>Not Found!</title>
	  </script>
	  <style>
		a:link   {text-decoration:none}
		a:visited{text-decoration:none}
		a:hover  {text-decoration:underline}
	  </style>
	  </head>

	<body background="$forumurl/$settings{'backgroundimage'}" bgcolor=$colors{'funcback'} text=$colors{'funcbacktext'}>
	<center>
	<table cellspacing=0 cellpadding=0 border=0>
	<td bgcolor=$colors{'functableborder'}>
	<table border=0 cellpadding=3 cellspacing=1 border=0>
	<tr><td bgcolor="$colors{'functitle'}" align=center><font face="system" color=$colors{'functitletext'}>View A Message</td></tr>
	<tr><td bgcolor="$colors{'functable'}">
	
	<table cellpadding=5>
	<tr><td align=center><font face="arial"  size=2 color=$colors{'functabletext'}>Specified Post Does Not Exist<p>
	Please check to make sure you entered the correct message number.
	</td></tr></table>
	</td></tr></table>
	</td></table>
	</center></body></html>
    ^;
  }
  else
  {
  chomp($line);

  ($membername, $messageto, $messagetime, $messagetext, $messagenum, $replyto) = split(/\|/, $line);

  # Get the member info
  open(MEMBER, "<$profilepath/$membername/profile.dat");
  chomp(@memberinfo = <MEMBER>);
  close(MEMBER);

  # Get the # of replies
  open(REP, "<$profilepath/$membername/replies.dat");
  $replies = <REP>;
  close(REP);


  $memberemail = @memberinfo[0];
  $memberuin   = @memberinfo[1];
  $rank        = @memberinfo[3];

  # Get the # of posts
  open(NUM, "<$profilepath/$membername/posts.dat");
  $numofposts = <NUM>;
  close(NUM);

  # get the name of the "most posts" award winner
  open(AWARD, "<$awardpath/posts");
  $winner = <AWARD>;
  close(AWARD);

  # get the name of the "most popular" award winner
  open(AWARD, "<$awardpath/replies");
  $popular = <AWARD>;
  close(AWARD);

# get pipes back
$messagetext =~ s/&pipe;/|/g;

# parse for smilys :)
$messagetext =~ s/&gt;\:\(/\<img src\=\"\/megaboard\/emoticons\/angry\.gif\" border\=0\>/g;
$messagetext =~ s/>;\:\(/\<img src\=\"\/megaboard\/emoticons\/angry\.gif\" border\=0\>/g;
$messagetext =~ s/\:\(/\<img src\=\"\/megaboard\/emoticons\/sad\.gif\" border\=0\>/g;
$messagetext =~ s/&gt;\:0/\<img src\=\"\/megaboard\/emoticons\/pissed\.gif\" border\=0\>/g;
$messagetext =~ s/>\:0/\<img src\=\"\/megaboard\/emoticons\/pissed\.gif\" border\=0\>/g;
$messagetext =~ s/\:\)/\<img src\=\"\/megaboard\/emoticons\/smily\.gif\" border\=0\>/g;
$messagetext =~ s/\:D/\<img src\=\"\/megaboard\/emoticons\/bigsmile\.gif\" border\=0\>/g;
$messagetext =~ s/\;\)/\<img src\=\"\/megaboard\/emoticons\/wink\.gif\" border\=0\>/g;
$messagetext =~ s/B\)/\<img src\=\"\/megaboard\/emoticons\/sunglasses\.gif\" border\=0\>/g;
$messagetext =~ s/8\)/\<img src\=\"\/megaboard\/emoticons\/glasses\.gif\" border\=0\>/g;
$messagetext =~ s/\( 8'\(\|\)/\<img src\=\"\/megaboard\/emoticons\/homer\.gif\" border\=0\>/g;

$membername =~ s/&pipe;/\|/g;

if ($messagetext !~ /<a/)
{
	$messagetext =~ s/<br>/ <br>/g;
	$messagetext =~ s/(http:\/\/\S+)/<a href=\"$1\"><u>$1<\/u><\/a>/g;
}

@lines = split(/<br>/, $messagetext);

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
  <a name="top"></a>
  <p><font face="Arial" color="$colors{'messagewindowbacktext'}"><big><strong>$topic{$in{'topic'}} </strong>&gt; $threadtitle</big></font></p>

<table width="100%" cellpadding=0>
<td bgcolor="$colors{'messagetableborder'}">
<table border="0" width="100%" cellspacing="1" cellpadding="4">
  <tr>
    <td width="170" bgcolor="$colors{'messagetopoftable'}" valign="top" align="left" nowrap><font face="verdana" size=2 color="$colors{'messagetoptext'}"><b>Member Name:</b></font></td>
    <td bgcolor="$colors{'messagetopoftable'}" valign="top" align="left"><font face="verdana" size=2 color="$colors{'messagetoptext'}"><b>Messages:</b></font></td>
  </tr>
  <tr>
    <td width="170" bgcolor="$bgcolor" valign="top" align="left"><font
    face="Arial"><b>$membername</b> ^;

# is he a winner?
    if ($membername eq $winner)
    {
      print "<img src=\"/megaboard/images/trophy.gif\" alt=\"$membername has the most posts on the board!\" height=15 width=19 border=0>";
    }
    if ($membername eq $popular)
    {
      print "<img src=\"/megaboard/images/thumbsup.gif\" alt=\"$membername is the most popular person on the board!\" height=15 width=19 border=0>";
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
	if (&authcookie)
	{
	   print qq^<br><a href="megaboard.pl?forum=$in{'forum'}&job=viewip&topic=$in{'topic'}&thread=$in{'thread'}&messno=$count"><img src="/megaboard/images/iplog.gif" border=0 heigh=18 width=18>IP</a> | 
				<a href="megaboard.pl?forum=$in{'forum'}&job=banuser&topic=$in{'topic'}&thread=$in{'thread'}&messno=$count"><img src="/megaboard/images/ban.gif" border=0 heigh=18 width=18>Ban!</a> | ^;

				foreach $lamer (@lamers)
				{
				  if ($lamer eq $membername)
				  {
					print "<a href=\"megaboard.pl?forum=$in{'forum'}&job=lamer&lamername=$membername&unlamer=1\"><img src=\"/megaboard/images/unlamer.gif\" border=0 heigh=18 width=18>UNLame!</a>";
					$lamerfound = 1;
				  }
				}
				if (!$lamerfound)
				{
				  print "<a href=\"megaboard.pl?forum=$in{'forum'}&job=lamer&lamername=$membername\"><img src=\"/megaboard/images/lamer.gif\" border=0 heigh=18 width=18>Lamer!</a>";
				}

				$lamerfound = 0;
	}

	$messageto =~ s/&pipe;/\|/g;

    print qq^
    <p>
    Number of posts: $numofposts<br>
    Times replied to: $replies<br>

    </font></td>
    <td bgcolor="$bgcolor" valign="top" align="left"><table border="0" width="100%"
    cellspacing="0" cellpadding="0" height="40">
      <tr>
        <td valign="top" align="left" height="19" width="100%" nowrap>To: <font face="Arial"><b>$messageto</b></font></td>
        <td valign="top" align="right" height="19" width="120" nowrap><font face="arial" size="-1">$messagetime</font></td>
      </tr>
      <tr>
        <td valign="top" align="left" height="21" nowrap width="100%"><font size="-1" face="arial"><a href="megaboard.pl?job=viewmessage&messno=$elem.$in{'thread'}.$in{'file'}"><u>$elem.$in{'thread'}.$in{'file'}</u></a>^;

  if ($replyto >= 1)
  {
    print " in reply to <a href=\"megaboard.pl?forum=$in{'forum'}&job=viewmessage&messno=$elem.$in{'thread'}.$replyto\"><u>$elem.$in{'thread'}.$replyto</u></a>";
  }

print qq^
</font></td>
        <td valign="top" align="right" height="21" width="120" nowrap><font size="-1" face="arial">[$in{'file'} of
        $lastfile]</font></td>
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
        </font></td>
      </tr>
    </table><center>
        <font face="verdana" size=2>
        [ <a href="megaboard.pl?forum=$in{'forum'}&job=viewthread&topic=$in{'topic'}&thread=$in{'thread'}">View Full Thread</a> ]</center>

</font><font face="Arial" size="-1"><p align="right"><a href="megaboard.pl?forum=$in{'forum'}&job=reply&to=$membername&topic=$in{'topic'}&thread=$in{'thread'}&replyto=$file"><img src="/megaboard/images/reply.gif" border=0 heigh=18 width=18>Reply</a>^;
if ($cookie{'name'} eq $membername)
{
		print qq^
		  | <a href="megaboard.pl?forum=$in{'forum'}&job=edit&topic=$in{'topic'}&thread=$in{'thread'}&messno=$count"><img src="/megaboard/images/edit.gif" border=0 heigh=18 width=18>Edit</a> ^;
}
if ($cookie{'name'} eq $membername || &authcookie)
{
		 print qq^ | <a href="megaboard.pl?forum=$in{'forum'}&job=deletepost&topic=$in{'topic'}&thread=$in{'thread'}&messno=$count"><img src="/megaboard/images/delete.gif" border=0 heigh=18 width=18>Delete</a>^;
}
	print qq^
	</td>
  </tr>
^;

print "<tr><td colspan=\"2\" align=right bgcolor=\"$colors{'messageback'}\"><font face=\"arial\" size=\"-2\" color=\"$colors{'messagewindowbacktext'}\">[ <a href=\"megaboard.pl?forum=$in{'forum'}&job=viewthread&topic=$in{'topic'}&thread=$in{'thread'}#$topic2num{$in{'topic'}}.$in{'thread'}.1\"><font color=$colors{'links2'}>T O P</font></a> ]&nbsp;</td></tr>";
print "</table></td></table>";

&footer;

print "</body></html>";
  } # END IF
}

1;