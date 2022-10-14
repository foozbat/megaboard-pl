# new View List Module
#   implements support for larger forums and
#   many forum topics

sub ViewListFull
{
	print qq^
	<html>

	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>$settings{'title'}</title>
	<style>
		a:link   {text-decoration:none}
		a:visited{text-decoration:none}
		a:hover  {text-decoration:underline}
		.form { background-color: $colors{'funcformcolor'}; color: $colors{'funcformtext'};
	         border-width: 1; 
			 border-left-style: solid; border-left-color: $colors{'functableborder'}; 
			 border-right-style: solid; border-right-color: $colors{'functableborder'}; 
			 border-top-style: solid; border-top-color: $colors{'functableborder'}; 
			 border-bottom-style: solid; border-bottom-color: $colors{'functableborder'};
			 }
	</style>
	</head>

	<body background="$forumurl/$settings{'backgroundimage'}" bgcolor="$colors{'messageback'}" text="$colors{'messagetext'}" link=$colors{'links'} vlink=$colors{'vlink'} alink=$colors{'links'}>
^;

&header;

# new forum table
print qq^
	<font face="arial" size=3 color="$colors{'funcbacktext'}"><b>$settings{'title'}</b></font>
	<p>
	<table width="100%" cellpadding=0>
	<td bgcolor="$colors{'messagetableborder'}">
	<table border="0" width="100%" cellspacing="1" cellpadding="4">^;
# Sort our topics in the order in which they were posted in

#if ($in{'showtopic'}) # if we're viewing the entire list
#{
#  $topic_order{1} = $in{'showtopic'};
#}
#else
#{
#	$counter = -2;
#	foreach $topic (keys %topic)
#	{
#	  # get all of our threads into an array
#	  opendir(THREADS, "$messagepath/$topic");
#	  chomp(@threads = readdir(THREADS));
#	  closedir(THREADS);
	 
#	  sort numerically @threads;

#	  $last = @threads[-1];

	  # get the last message
#	  open(LAST, "$messagepath/$topic/$last");
#	  chomp(@message = <LAST>);
#	  close(LAST);

#	  @lastmessage = split(/\|/, @message[-1]);

#	  if (!defined(@lastmessage[4]))
#	  {
#	    @lastmessage[4] = $counter;
#		$counter++;
#	  }

#	  $topic_order{@lastmessage[4]} = $topic;

#	  @lastmessage[4] = NULL;

#	}
#}

#$topic_order{1} = $in{'expanded'};
$counter = 1;
foreach $topic (keys %topic)
{
	if ($topic ne $in{'expanded'} || defined($in{'expandall'}))
	{
		$topic_order{$topic2num{$topic}} = $topic;
	}
	$counter++;
}
if (defined($in{'expanded'}) && !defined($in{'expandall'}))
{
	$topic_order{$counter} = $in{'expanded'};
}
# expand topic if only one subforum
if ($counter == 2)
{
	$in{'expanded'} = $topic_order{1};
	$oneforum = 1;
}
$counter = 0;

print qq^
<tr><td bgcolor="$colors{'listtitle'}" colspan=2 width=100%>
	<table cellspacing=0 cellpadding=0 border=0 width=100%><tr><td><font face="verdana" size=2 color="$colors{'listtitletext'}"><b>Forum Topics:</b></td>^;

	if (!defined($in{'expandall'}) && !$oneforum)
	{
		print qq^<td align=right><font face="verdana" size=1 color="$colors{'listtitletext'}">[ <a href="megaboard.pl?forum=$in{'forum'}&expandall"><font color="$colors{'links'}">EXPAND ALL</font></a> ]</td>^;
	}
	elsif (!$oneforum)
	{
		print qq^<td align=right><font face="verdana" size=1 color="$colors{'listtitletext'}">[ <a href="megaboard.pl?forum=$in{'forum'}"><font color="$colors{'links'}">COLLAPSE ALL</font></a> ]</td>^;
	}
	
	print qq^</tr></table></td>
	<td bgcolor="$colors{'listtitle'}" nowrap><font size="2" face="verdana" color="$colors{'listtitletext'}"><b>Posted by</b></td>
	<td bgcolor="$colors{'listtitle'}"><font size="2" face="verdana" color="$colors{'listtitletext'}"><b>Posts</b></td>
    <td bgcolor="$colors{'listtitle'}" nowrap><font size="2" face="verdana" color="$colors{'listtitletext'}"><b>Last Post</b></td></tr>^;

# the actual sorting is here
foreach $topic_num (sort{$b <=> $a} keys %topic_order)
{
  print qq^
  <tr>
    <td ^;
	if ($in{'expanded'} eq $topic_order{$topic_num} || defined($in{'expandall'}))
	{
		print qq^bgcolor="$colors{'messagetableback1'}" colspan=5^;
	}
	else
	{
		print qq^bgcolor="$colors{'messagetableback1'}" colspan=2^;
	}
	print qq^><table cellspacing=0 cellpadding=0 border=0 width=100%><tr><td>
    <a name="$topic_order{$topic_num}"></a>
	<table border=0 cellspacing=0 cellpadding=0>
	<tr><td valign=middle><img src="$imageurl/folder^;
	if ($in{'expanded'} eq $topic_order{$topic_num} || defined($in{'expandall'})) { print "-bw"; }
	print qq^.gif" width=24 height=22>&nbsp;</td><td width=100%>
	<font face="verdana" color="$colors{'listtabletext'}" width=100% size=2><b>^;
	if ($in{'expanded'} ne $topic_order{$topic_num} && !defined($in{'expandall'}))
	{
		print qq^<a href="megaboard.pl?forum=$in{'forum'}&expanded=$topic_order{$topic_num}"><font color="$colors{'links'}">^;
	}

	print qq^$topic{$topic_order{$topic_num}}</b>^;
	
	if ($in{'expanded'} ne $topic_order{$topic_num} && !defined($in{'expandall'}))
	{
		print "</font></a>";
	}
		
	print qq^<br><font size=1>» $topicdescription{$topic_order{$topic_num}}</font></font></td></table></td>^;
	if (($in{'expanded'} eq $topic_order{$topic_num} || defined($in{'expandall'})) && $topic_order{$topic_num} ne $newscomments)
	{
		print qq^<td align=right><font size="-1" face="Arial"><a
    href="megaboard.pl?forum=$in{'forum'}&job=postmessage&topic=$topic_order{$topic_num}"><img src="$imageurl/post.gif" border="0" height="16" width="18"><font color="$colors{'links'}">Post New Thread</font></a></font></td>^;
	}
	
	print qq^</tr></table></td>^;
	
#	if ($in{'expanded'} ne $topic_order{$topic_num})
#	{
#		print qq^</tr>^;
#	}

  # get all of our threads
  opendir(THREADS, "$messagepath/$topic_order{$topic_num}");
  chomp(@threads = readdir(THREADS));
  closedir(THREADS);

  sort numerically @threads;
  
  $count1 = 0;
  $pthreadfound = 0;
  foreach $thread (@threads)
  {
    if ($thread =~ /persistent/)
	{
		@persistentthreads[$count1] = $thread;
		$pthreadfound = 1;
		$count1 += 1;
	}
	else
	{
		open(THREAD, "$messagepath/$topic_order{$topic_num}/$thread");
		chomp(@messages = <THREAD>);
		close(THREAD);

		$lastmessage = @messages[-1];

		@lines = split(/\|/, $lastmessage);
		$threads{@lines[4]} = $thread;
	}
  }

  $tbl_toggle = 0;

	  # get all of our threads into an array
	  opendir(THREADS, "$messagepath/$topic_order{$topic_num}");
	  chomp(@threads = readdir(THREADS));
	  closedir(THREADS);
	 
	  sort numerically @threads;

	  $last = @threads[-1];

	  # get the last message
	  open(LAST, "$messagepath/$topic_order{$topic_num}/$last");
	  chomp(@message = <LAST>);
	  close(LAST);

	  @lastmessage = split(/\|/, @message[-1]);

  if (!defined($topicpass{$topic_order{$topic_num}}) || $in{'password'} eq $topicpass{$topic_order{$topic_num}})
  {
  

	  if (!defined(@lastmessage[4]))
	  {
		if ($in{'expanded'} eq $topic_order{$topic_num} || defined($in{'expandall'}))
		{
			print qq^<tr><td bgcolor="$colors{'messagetableback1'}" colspan=5><font face="arial" size="2" color="$colors{'listtabletext'}">[ No Threads in Category ]</td></tr>^;
			
		}
		else
		{
			print qq^<td bgcolor="$colors{'messagetableback1'}" colspan=3 align=center><font face="arial" size="2" color="$colors{'listtabletext'}">[ No Threads in Category ]</td></tr>^;
		}
	  }

	  $counter = 0;
	  $pmessagenum = 0;
	  if ($pthreadfound)
	  {
	  	  foreach $persistentthread (@persistentthreads)
		  {
		  			if (!$in{'startat'} && ($in{'expanded'} eq $topic_order{$topic_num} || defined($in{'expandall'})))
			{
			  last if ($counter == $settings{'maxlistsize'});
			}
			elsif (defined($in{'startat'}))
			{
			  if ($in{'expanded'} ne $topic_order{$topic_num})
			  {
			      $in{'startat'} = 0;
			  }
			  last if ($counter == $settings{'maxlistsize'}+$in{'startat'}-1);
			}

			  $counter += 1;
	  		  $pmessagenum += 1;

			if ($counter >= $in{'startat'})
			{

		open(THREAD, "$messagepath/$topic_order{$topic_num}/$persistentthread");
		chomp(@messages = <THREAD>);
		close(THREAD);

		$title = @messages[0];
		@post = split(/\|/, @messages[1]);
		$membername = @post[0];
		$num   = @messages - 1;

		$lastline = @messages[-1];
		@message = split(/\|/, $lastline);

		$time = @message[2];

		$curtime = &GetTime;

		($postdate, $posthour) = split(/\s/, "$time");
		($curdate, $curhour) = split (/\s/, "$curtime");

		if ($postdate eq $curdate)
		{
			$time = "<font color=$colors{'admincolor'}>Today</font> \@ $posthour";
		}
#		elsif ($in{'expanded'} eq $topic_order{$topic_num} || defined($in{'expandall'}))
#		{
#			$time = "$postdate <b>$posthour</b>";
#		}


		$tbl_toggle ^= 1;     # $tbl_toggle XOR 1 
		if ($tbl_toggle == 1)
		{
		  $bgcolor = $colors{'messagetableback1'};
		}
		elsif ($tbl_toggle == 0)
		{
		  $bgcolor = $colors{'messagetableback2'};
		} # END IF

		$messno = @message[4];

		$lastposter = @message[0];

		## NEW ## ADDS SUPPORT FOR COLLAPSED VIEW
		if ($in{'expanded'} eq $topic_order{$topic_num} || defined($in{'expandall'}))
		{

		$membername =~ s/&pipe;/\|/g;
	  print qq^
	  <tr>
		<td width=5 bgcolor="$bgcolor"><font size=1>&nbsp</td><td bgcolor="$bgcolor" width="100%"><font face="arial" color="$colors{'listtabletext'}" size=2>[ Notice: ] &nbsp<a
		href="megaboard.pl?forum=$in{'forum'}&job=viewthread&topic=$topic_order{$topic_num}&thread=$persistentthread&startat=1&new=$messno">$title</a></font></td>
		<td bgcolor="$bgcolor" nowrap><font face=arial size=2>^;
		
		foreach $moderator (keys %moderators)
		{
		  if ($membername eq $moderator)
		  {
			print "<font color=\"$colors{'admincolor'}\">";
		  }
		}
		  print qq^$membername</td>
		<td bgcolor="$bgcolor" align=center><font face="arial" size=2 color="$colors{'listtabletext'}">$num</td>
		<td bgcolor="$bgcolor" nowrap><font face="arial" size="2" color="$colors{'listtabletext'}">$time <font size=1 color=$colors{'quotetext'}>by $lastposter</font></td>
	  </tr>^;
			} # END NEW IF
			else
			{
				if ($counter == 1)
				{
					$lastmembername = @message[0];
					$lasttime = $time;
				}
				$totaltopicposts += $num;
			}

		  }
		}
	  }
	## END PTHREAD

	  foreach $thread (sort{$b <=> $a} keys %threads)
	  {
		if ($threads{$thread} ne '.')
		{
		  if ($threads{$thread} ne '..')
		  {

			if (!$in{'startat'} && ($in{'expanded'} eq $topic_order{$topic_num} || defined($in{'expandall'})))
			{
			  last if ($counter == $settings{'maxlistsize'});
			}
			elsif (defined($in{'startat'}))
			{
			  if ($in{'expanded'} ne $topic_order{$topic_num})
			  {
			      $in{'startat'} = 0;
			  }
			  last if ($counter == $settings{'maxlistsize'}+$in{'startat'}-1);
			}

			  $counter += 1;

			if ($counter >= $in{'startat'})
			{

		open(THREAD, "$messagepath/$topic_order{$topic_num}/$threads{$thread}");
		chomp(@messages = <THREAD>);
		close(THREAD);

		$title = @messages[0];
		@post = split(/\|/, @messages[1]);
		$membername = @post[0];
		$num   = @messages - 1;

		$lastline = @messages[-1];
		@message = split(/\|/, $lastline);

		$time = @message[2];

		$curtime = &GetTime;

		($postdate, $posthour) = split(/\s/, "$time");
		($curdate, $curhour) = split (/\s/, "$curtime");

		if ($postdate eq $curdate)
		{
			$time = "<font color=$colors{'admincolor'}>Today</font> \@ $posthour";
		}
#		elsif ($in{'expanded'} eq $topic_order{$topic_num} || defined($in{'expandall'}))
#		{
#			$time = "$postdate <b>$posthour</b>";
#		}


		$tbl_toggle ^= 1;     # $tbl_toggle XOR 1 
		if ($tbl_toggle == 1)
		{
		  $bgcolor = $colors{'messagetableback1'};
		}
		elsif ($tbl_toggle == 0)
		{
		  $bgcolor = $colors{'messagetableback2'};
		} # END IF

		$messno = @message[4];

		$lastposter = @message[0];

		## NEW ## ADDS SUPPORT FOR COLLAPSED VIEW
		if ($in{'expanded'} eq $topic_order{$topic_num} || defined($in{'expandall'}))
		{

		$membername =~ s/&pipe;/\|/g;
	  print qq^
	  <tr>
		<td width=5 bgcolor="$bgcolor"><font size=1>&nbsp</td><td bgcolor="$bgcolor" width="100%"><font face="arial" color="$colors{'listtabletext'}" size=2><a
		href="megaboard.pl?forum=$in{'forum'}&job=viewthread&topic=$topic_order{$topic_num}&thread=$threads{$thread}&startat=1&new=$messno">$title</a></font></td>
		<td bgcolor="$bgcolor" nowrap><font face=arial size=2>^;
		
		foreach $moderator (keys %moderators)
		{
		  if ($membername eq $moderator)
		  {
			print "<font color=\"$colors{'admincolor'}\">";
		  }
		}
		  print qq^$membername</td>
		<td bgcolor="$bgcolor" align=center><font face="arial" size=2 color="$colors{'listtabletext'}">$num</td>
		<td bgcolor="$bgcolor" nowrap><font face="arial" size="2" color="$colors{'listtabletext'}">$time <font size=1 color=$colors{'quotetext'}>by $lastposter</font></td>
	  </tr>^;

			} # END NEW IF
			else
			{
				if ($counter-$pmessagenum == 1)
				{
					$lastmembername = @message[0];
					$lasttime = $time;
				}
				$totaltopicposts += $num;
			}

			} # END IF
		  } # END IF
		} # END IF

	  } # END FOREACH

	  if ($in{'expanded'} ne $topic_order{$topic_num} && defined(@lastmessage[4]) && !defined($in{'expandall'}))
	  {
	  			print qq^
			<td bgcolor="$bgcolor" nowrap><font face=arial size=2><font face=arial size=1>Last post by</font><br>^;
			
			foreach $moderator (keys %moderators)
			{
			  if ($lastmembername eq $moderator)
			  {
				print "<font color=\"$colors{'admincolor'}\">";
			  }
			}
			  print qq^$lastmembername</td>
			<td bgcolor="$bgcolor" align=center><font face="arial" size=2 color="$colors{'listtabletext'}">$totaltopicposts</td>
			<td bgcolor="$bgcolor" nowrap><font face="arial" size="2" color="$colors{'listtabletext'}"><font face=arial size=1>Last post at</font><br>$lasttime</font></td></tr>^;
			$totaltopicposts = 0;
			#last;
	  }

		if ($in{'expanded'} eq $topic_order{$topic_num} || defined($in{'expandall'}))
		{
	  print qq^
	  <tr>
		<td align="right" bgcolor="$colors{'messageback'}" colspan=5><font face="verdana" size="-2" color="$colors{'messagewindowbacktext'}">^;

	  @totalthreads = keys %threads;
	  $totalthreads = @totalthreads - 1;
	$startat = $counter+1;
	$nextnum = $settings{'maxlistsize'}*2;

### PAGE SELECTION LIST ###
	  if ($totalthreads > $settings{'maxlistsize'})
	  {
print "<font face=verdana size=1 color=$colors{'messagebacktext'}>[ PAGE: ";

$pages = int($totalthreads / $settings{'maxlistsize'});

if ($totalthreads % $settings{'maxlistsize'} != 0)
{
	$pages += 1;
}

$curpage = 1;
$startat = 0;

while ($curpage <= $pages)
{
	if ($startat == $in{'startat'})
	{
		print "<b>";
	}
	else
	{
		print "<a href=megaboard.pl?forum=$in{'forum'}&expanded=$topic_order{$topic_num}&startat=$startat><font color=$colors{'messagebacklink'}>";
	}
	print "$curpage ";
	if ($startat == $in{'startat'})
	{
		print "</b>";
	}
	else
	{
		print "</font></a>";
	}

	($startat == 0 ? $startat = 1 : $startat += $settings{'maxlistsize'});
	$curpage++;
}

print " ] ";
### END PAGE SELECTION LIST #####
	  }

		print qq^[ <a href="#$topic_order{$topic_num}"><font face="arial" color="$colors{'messagebacklink'}">T O P</font></a> ]<br></td>
		  </tr>^;
		
		} # END IF

	  # reset hash for next category
	  foreach $key (keys %threads)
	  {
		delete $threads{$key};
	  }
	} #end if
	else
	{
		print qq^<tr><td align="right" bgcolor="$colors{'messageback'}" colspan=5><font face="verdana" size=1>&nbsp</td></tr>^;
	  # reset hash for next category
	  foreach $key (keys %threads)
	  {
		delete $threads{$key};
	  }

	}

} # END FOREACH
print qq^
</table>
</td>
</table>^;

&footer;

print qq^</body>
</html>^;

}

1;