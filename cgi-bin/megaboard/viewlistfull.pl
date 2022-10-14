# this shows the list without a framed interface

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

	
print qq^
    <font face="arial" size=3 color="$colors{'funcbacktext'}"><b>Forum Topics:</b>
	<p>
	<table width="100%" cellpadding=0>
	<td bgcolor="$colors{'messagetableborder'}">
	<table border="0" width="100%" cellspacing="1" cellpadding="3">^;

# Sort our topics in the order in which they were posted in

if ($in{'showtopic'}) # if we're viewing the entire list
{
  $topic_order{1} = $in{'showtopic'};
}
else
{
	$counter = -2;
	foreach $topic (keys %topic)
	{
	  # get all of our threads into an array
	  opendir(THREADS, "$messagepath/$topic");
	  chomp(@threads = readdir(THREADS));
	  closedir(THREADS);
	 
	  sort numerically @threads;

	  $last = @threads[-1];

	  # get the last message
	  open(LAST, "$messagepath/$topic/$last");
	  chomp(@message = <LAST>);
	  close(LAST);

	  @lastmessage = split(/\|/, @message[-1]);

	  if (!defined(@lastmessage[4]))
	  {
	    @lastmessage[4] = $counter;
		$counter++;
	  }

	  $topic_order{@lastmessage[4]} = $topic;

	  @lastmessage[4] = NULL;

	}
}




# the actual sorting is here
foreach $topic_num (sort{$b <=> $a} keys %topic_order)
{
  print qq^
  <tr>
    <td bgcolor="$colors{'listtitle'}" colspan=^;
	
		if (defined($topicpass{$topic_order{$topic_num}}) && $in{'password'} ne $topicpass{$topic_order{$topic_num}})
		{
			print qq^5^;
		}
		else
		{
			print qq^2^;
		}
		print qq^>
		<table cellspacing=0 cellpadding=0 width=100%>
		<tr><td>^;
		if (defined($topicpass{$topic_order{$topic_num}}) && $in{'password'} ne $topicpass{$topic_order{$topic_num}})
		{
			print qq^<form action="megaboard.pl" method="post">^;
		}
		
		print qq^<font face="verdana" color="$colors{'listtitletext'}" width=100% size=2><b><a name="$topic_order{$topic_num}"></a>$topic{$topic_order{$topic_num}}</b></font>^;
		
		if (defined($topicpass{$topic_order{$topic_num}}) && $in{'password'} ne $topicpass{$topic_order{$topic_num}})
		{
			print qq^ <font face="verdana" size=2>&nbsp&nbsp;Password: <input type=password size=20 class="form" name="password"><input type="hidden" name="forum" value="$in{'forum'}"><input type="hidden" name="job" value="viewlistfull"><input type="hidden" name="showtopic" value="$topic_order{$topic_num}">^;
		}

		print qq^</td></form>^;

		if (!defined($topicpass{$topic_order{$topic_num}}) || $in{'password'} eq $topicpass{$topic_order{$topic_num}})
		{
			print qq^
		<td align=right><font size="-1" face="Arial"><a
    href="megaboard.pl?forum=$in{'forum'}&job=postmessage&topic=$topic_order{$topic_num}"><img src="/megaboard/images/post.gif" border="0" height="16" width="18"><font color="$colors{'links'}">Post New Thread</font></a></font></td></tr></table></td>
	<td bgcolor="$colors{'listtitle'}" nowrap><font size="2" face="verdana" color="$colors{'listtitletext'}"><b>Posted by</b></td>
	<td bgcolor="$colors{'listtitle'}"><font size="2" face="verdana" color="$colors{'listtitletext'}"><b>Posts</b></td>
    <td bgcolor="$colors{'listtitle'}" nowrap><font size="2" face="verdana" color="$colors{'listtitletext'}"><b>Last Post</b></td>^;
		}
		else
		{
			print qq^</table></td>^;
		}
  print qq^</tr>^;

  # get all of our threads
  opendir(THREADS, "$messagepath/$topic_order{$topic_num}");
  chomp(@threads = readdir(THREADS));
  closedir(THREADS);

  sort numerically @threads;
  
  foreach $thread (@threads)
  {
    open(THREAD, "$messagepath/$topic_order{$topic_num}/$thread");
	chomp(@messages = <THREAD>);
	close(THREAD);

	$lastmessage = @messages[-1];

	@lines = split(/\|/, $lastmessage);
	$threads{@lines[4]} = $thread;
  }

  $tbl_toggle = 0;

  if (!defined($topicpass{$topic_order{$topic_num}}) || $in{'password'} eq $topicpass{$topic_order{$topic_num}})
  {
  

	  if ($topic_num < 1)
	  {
		print qq^<tr><td bgcolor="$colors{'messagetableback1'}" colspan=5><font face="arial" size="2" color="$colors{'listtabletext'}">[ No Threads in Category ]</td></tr>^;
	  }

	  $counter = 0;
	  foreach $thread (sort{$b <=> $a} keys %threads)
	  {

		if ($threads{$thread} ne '.')
		{
		  if ($threads{$thread} ne '..')
		  {

			if (!$in{'showtopic'})
			{
			  last if ($counter == $settings{'maxlistsize'});
			}
			elsif (defined($in{'showtopic'}))
			{
			  last if ($counter == $settings{'maxlistsize'}*2+$in{'startat'}-1);
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
			$time = "<font color=red>Today</font> \@ $posthour";
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

		$messno = @message[4];

	  print qq^
	  <tr>
		<td width=5 bgcolor="$bgcolor"><font size=1>&nbsp</td><td bgcolor="$bgcolor" width="100%"><font face="arial" color="$colors{'listtabletext'}" size=2><a
		href="megaboard.pl?forum=$in{'forum'}&job=viewthread&topic=$topic_order{$topic_num}&thread=$threads{$thread}&startat=0&new=$messno">$title</a></font></td>
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
		<td bgcolor="$bgcolor" nowrap><font face="arial" size="2" color="$colors{'listtabletext'}">$time</font></td>
	  </tr>^;
			} # END IF
		  } # END IF
		} # END IF
	  } # END FOREACH

	  print qq^
	  <tr>
		<td align="right" bgcolor="$colors{'messageback'}" colspan=5><font face="arial" size="-2" color="$colors{'messagewindowbacktext'}">^;

	  @totalthreads = keys %threads;
	  $totalthreads = @totalthreads - 1;
	$startat = $counter+1;
	$nextnum = $settings{'maxlistsize'}*2;
	  if ($totalthreads > $settings{'maxlistsize'} && $counter == $settings{'maxlistsize'})
	  {
		print qq^[ <a href="megaboard.pl?forum=$in{'forum'}&job=viewlistfull&showtopic=$topic_order{$topic_num}&startat=$startat"><font color="$colors{'messagebacklink'}">VIEW NEXT PAGE &gt;&gt;</font></a> ] ^;
	  }

		print qq^[ <a href="#$topic_order{$topic_num}" target="messagelist"><font color="$colors{'messagebacklink'}">T O P</font></a> ]<br></td>
		  </tr>^;

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










