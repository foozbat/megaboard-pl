# ----------------------------------------
# ViewTread
# CONVERTED TO NEW MESSAGE FORMAT
# ----------------------------------------

sub ViewThread
{

# get our thread file into an array
open(THREADFILE, "<$messagepath/$in{'topic'}/$in{'thread'}");
chomp(@thread = <THREADFILE>);
close(THREADFILE);

# get the name of the "most posts" award winner
open(AWARD, "<$awardpath/posts");
$winner = <AWARD>;
close(AWARD);

# get the name of the "most popular" award winner
open(AWARD, "<$awardpath/replies");
$popular = <AWARD>;
close(AWARD);

# get the names of lamers
open(LAMERS, "<$awardpath/lamers");
chomp(@lamers = <LAMERS>);
close(LAMERS);

$threadtitle = @thread[0];

# generate the page
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

<body background="$forumurl/$settings{'backgroundimage'}" bgcolor="$colors{'messageback'}" text="$colors{'messagetext'}" link=$colors{'links'} vlink=$colors{'links'} alink=$colors{'links'}><center>^;

if ($cookie{'frames'} eq 'off')
{
  &header;
}

print qq^
</center>
<p><font face="Arial" color="$colors{'messagewindowbacktext'}"><big><strong>$topic{$in{'topic'}} </strong>&gt; $threadtitle</big></font>^;

if (&authcookie)
{
print qq^
<br>
<font face="verdana" color="$colors{'messagewindowbacktext'}" size=2>[ <a href="megaboard.pl?forum=$in{'forum'}&job=deletethread&topic=$in{'topic'}&thread=$in{'thread'}"><font color="$colors{'messagebacklink'}">DELETE THREAD</font></a> ]</font>^;
}
print qq^
<p>

<table width="100%" cellpadding=0>
<td bgcolor="$colors{'messagetableborder'}">
<table border="0" width="100%" cellspacing="1" cellpadding="4">
  <tr>
    <td width="170" bgcolor="$colors{'messagetopoftable'}" valign="top" align="left" nowrap><font face="verdana"
    color="$colors{'messagetoptext'}" size=2><b>Member Name:</b></font></td>
    <td bgcolor="$colors{'messagetopoftable'}" valign="top" align="left"><font face="verdana"
    color="$colors{'messagetoptext'}" size=2><b>Messages:</b></font></td>
  </tr>
^;

$tbl_toggle = 0;

$count = 0;
$total = @thread - 1;

$endbefore = $in{'startat'} + 20;

for ($count = $in{'startat'}; $count < $endbefore; $count++)
  {
    last if (!defined(@thread[$count]));  # modified 9-4-2000

    if (@thread[$count] ne @thread[0]) # added 9-4-2000
	{
    
	# split apart the raw data into variables we can use
	($membername, $messageto, $messagetime, $messagetext, $messagenum, $replyto, $ip) = split(/\|/, @thread[$count]);

	# Get the member info
	open(MEMBER, "<$profilepath/$membername/profile.dat");
	chomp(@memberinfo = <MEMBER>);
	close(MEMBER);

	$memberemail = @memberinfo[0];
	$memberuin   = @memberinfo[1];
	$rank        = @memberinfo[3];

	# Get the # of posts
	open(NUM, "<$profilepath/$membername/posts.dat");
	$numofposts = <NUM>;
	close(NUM);

	# Get the # of replies
	open(REP, "<$profilepath/$membername/replies.dat");
	$replies = <REP>;
	close(REP);

	$messagetext =~ s/&pipe;/|/g;

	# parse for smilys :)
	$messagetext =~ s/&gt;\:\(/\<img src\=\"\/megaboard\/emoticons\/angry\.gif\" border\=0\>/g;
	$messagetext =~ s/>\:\(/\<img src\=\"\/megaboard\/emoticons\/angry\.gif\" border\=0\>/g;
	$messagetext =~ s/\:\(/\<img src\=\"\/megaboard\/emoticons\/sad\.gif\" border\=0\>/g;
	$messagetext =~ s/&gt;\:O/\<img src\=\"\/megaboard\/emoticons\/pissed\.gif\" border\=0\>/g;
	$messagetext =~ s/>\:O/\<img src\=\"\/megaboard\/emoticons\/pissed\.gif\" border\=0\>/g;
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

	$linecount = 0;
	foreach $line (@lines)
	{
	  if ($line =~ /^\;/i) # if the line starts with a ";"
	  {
		@lines[$linecount] = "<font color=\"$colors{'quotetext'}\"\><i>$line</i></font>"; # make the font color "gray" for that line
	  }
	  $linecount += 1;
	}

	$messagetext = join('<br>', @lines);


	# This flips between two background colors on the message table

	$tbl_toggle ^= 1;     # $tbl_toggle XOR 1 
	if ($tbl_toggle == 1)
	{
	  $bgcolor = $colors{'messagetableback1'};
	}
	elsif ($tbl_toggle == 0)
	{
	  $bgcolor = $colors{'messagetableback2'};
	} # END IF

	if ($membername eq 'DELETED')
	{
	  print qq^
	  <tr>
		<td width="170" bgcolor="$bgcolor" valign="top" align="left"><a name="$topic2num{$in{'topic'}}.$in{'thread'}.$count"></a>^;
	}
	else
	{
	print qq^
	  <tr>
		<td width="170" bgcolor="$bgcolor" valign="top" align="left" nowrap><font
		face="Arial"><a name="$topic2num{$in{'topic'}}.$in{'thread'}.$count"></a><b>$membername </b>^;


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

		print qq^
		<p>
		Number of posts: $numofposts<br>
		Times replied to: $replies
		</font></td>^;

	} # END IF

	if ($membername eq 'DELETED')
	{
	  print qq^
	  <td bgcolor="$bgcolor" valign="top" align="center"><font face="arial" size="-1">Message deleted by $messageto on $messagetext.</font></td></tr>^;

	}
	else
	{
		$messageto =~ s/&pipe;/\|/g;

		print qq^
		<td bgcolor="$bgcolor" valign="top" align="left"><table border="0" width="100%"
		cellspacing="0" cellpadding="0" height="40">
		  <tr>
			<td valign="top" align="left" height="19" width="100%" nowrap><font face="arial" size=2>To:</font> <font face="Arial"><b>$messageto</b></font></td>
			<td valign="top" align="right" height="19" nowrap><font face="arial" size="-1">$messagetime</font></td>
		  </tr>
		  <tr>
			<td valign="top" align="left" height="21" nowrap width="100%"><font size="-1" face="arial"><a href="megaboard.pl?forum=$in{'forum'}&job=viewmessage&messno=$topic2num{$in{'topic'}}.$in{'thread'}.$count"><u>$topic2num{$in{'topic'}}.$in{'thread'}.$count</u></a>^;

	  if ($replyto >= 1)
	  {
		print " in reply to <a href=\"megaboard.pl?forum=$in{'forum'}&job=viewmessage&messno=$topic2num{$in{'topic'}}.$in{'thread'}.$replyto\"><u>$topic2num{$in{'topic'}}.$in{'thread'}.$replyto</u></a>";
	  }

	print qq^
	</font></td>
			<td valign="top" align="right" height="21" width="120" nowrap><font size="-1" face="arial">[$count of
			$total]</font></td>
		  </tr>
		</table>
		<hr color="$colors{'messagetableborder'}" height=1>
		<table border="0" width="100%" cellspacing="0" cellpadding="10">
		  <tr>
			<td width="100%"><font face="verdana" size=2>$messagetext</font></td>
		  </tr>
		</table>
		<p align="right">
		  <font face="Arial" size="-1"><a href="megaboard.pl?forum=$in{'forum'}&job=reply&to=$membername&topic=$in{'topic'}&thread=$in{'thread'}&replyto=$count"><img src="/megaboard/images/reply.gif" border=0 heigh=18 width=18>Reply</a>^;
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
    } # END IF
  } # END IF -- added 9-4-2000
} # END FOR

$tbl_toggle ^= 1;     # $tbl_toggle XOR 1
if ($tbl_toggle == 1)
{
  $bgcolor = $colors{'messagetableback1'};
}
elsif ($tbl_toggle == 0)
{
  $bgcolor = $colors{'messagetableback2'};
} # END IF

if ($total > 20)
{
  print "<tr><td colspan=2 bgcolor=$bgcolor>";
  print "<center><font face=\"arial\" size=\"-1\">";

  if ($in{'startat'} > 20)
  {
    $back = $in{'startat'} - 20;
    print "<a href=\"megaboard.pl?forum=$in{'forum'}&job=viewthread&topic=$in{'topic'}&thread=$in{'thread'}&startat=$back\">&lt;&lt; PREVIOUS PAGE</a> \| ";
  }

#  print $num, " ", $total, " ", $in{'startat'};

  $num = 1;

  if ($in{'startat'} == 0)
  {
    $in{'startat'} += 1; # bad!
  }

  while ($num <= $total)
  {
    $bla = ($num == $in{'startat'});
    if ($bla)
	{
	  print "<b>";
    }
	else
	{
  	  print "<a href=\"megaboard.pl?forum=$in{'forum'}&job=viewthread&topic=$in{'topic'}&thread=$in{'thread'}&startat=$num\">";
	}
	print "$num";
	$prev = $num;
	if (($total - $num) < 20)
	{
	  $num = $total;
	}
	else
	{
	  $num += 19;
	}
    if ($prev != $num)
	{ print " - $num"; }
    
	if ($bla) { print "</b>"; }	else { print "</a>"; }


	if ($num != $total)
	{
	  print " | ";
	}
	$num++;

#	print " ", $num, " ";
  } # END WHILE

  if ($total - $in{'startat'} >= 20)
  {
    $fwd = $in{'startat'} + 20;
    print " \| <a href=\"megaboard.pl?forum=$in{'forum'}&job=viewthread&topic=$in{'topic'}&thread=$in{'thread'}&startat=$fwd\">NEXT PAGE &gt;&gt;</a>";
  }


  print "</center></td></tr>";
} # END IF
print "<tr><td colspan=\"2\" bgcolor=\"$colors{'messageback'}\"><table cellspacing=0 cellpadding=0 border=0 width=100%><tr><td>";
if ($cookie{'frames'} eq 'off')
{
  $parentforumname = uc($topic{$in{'topic'}});
  print qq^<font face="arial" size="-2" color="$colors{'messagewindowbacktext'}">[ <a href="megaboard.pl?forum=$in{'forum'}&expanded=$in{'topic'}&frames=off">&lt;&lt; BACK TO $parentforumname</a> ]^;
}

print "</td><td align=right><font face=\"arial\" size=\"-2\" color=\"$colors{'messagewindowbacktext'}\">[ <a href=\"megaboard.pl?forum=$in{'forum'}&job=viewthread&topic=$in{'topic'}&thread=$in{'thread'}#$topic2num{$in{'topic'}}.$in{'thread'}.1\"><font color=\"$colors{'messagebacklink'}\">T O P</font></a> ]&nbsp;</td></tr></table></td></tr>";

print "</table></td></table>";

&footer;

print "</body></html>";


}

1;