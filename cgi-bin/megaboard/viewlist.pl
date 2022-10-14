
# ----------------------------------------
# ViewList
# CONVERTED TO NEW MESSAGE FORMAT
# ----------------------------------------

sub ViewList
{

open(TOTAL, "<$messagepath/totalmessages");
chomp($totalmessages = <TOTAL>);
close(TOTAL);


print qq^
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<base target="messagewindow">
<title>Message List</title>
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

<body bgcolor="$colors{'listback'}" text="$colors{'listtext'}" link="$colors{'links'}" vlink="$colors{'vlink'}" alink="$colors{'alink'}">

<hr>^;
if ($in{'showtopic'})
{
  print qq^
  <font color="$colors{'listbacktext'}" face="arial">
  Now Showing All Threads in Category:<p>^;
}
else
{
  print qq^

  <font color="$colors{'listbacktext'}" face="arial">
	<b>Message Board Topics:<br>
    </b><font size="-2">
	($totalmessages total posts)
    <font size="-1" face=arial>
    <p>
   <a href="megaboard.pl?forum=$in{'forum'}&job=viewlist" target="messagelist"><font color="$colors{'links'}">Click here</font></a> to get the latest messages.</font>^;
 }
 print qq^
<table cellspacing=0 cellpadding=0 width="100%" border=0>
<td bgcolor="$colors{'listborder'}">
<table border="0" width="100%" cellspacing="1" cellpadding="2">^;


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
  if ($topic_order{$topic_num} ne 'totalmessages') # get rid of that file
  {
  
  print qq^
  <tr>
    <td bgcolor="$colors{'listtitle'}" colspan=^;
	if (defined($topicpass{$topic_order{$topic_num}}) && $in{'password'} ne $topicpass{$topic_order{$topic_num}})
	{
		print qq^3^;
	}
	else
	{
		print qq^2^;
	}
	
	print qq^><font face="System" color="$colors{'listtitletext'}"><a name="$topic_order{$topic_num}"></a>$topic{$topic_order{$topic_num}}</font></td>^;

	if (!defined($topicpass{$topic_order{$topic_num}}) || $in{'password'} eq $topicpass{$topic_order{$topic_num}})
	{
	print qq^
    <td bgcolor="$colors{'listtitle'}" align=right nowrap><font size="-1" face="Arial"><a
    href="megaboard.pl?forum=$in{'forum'}&job=postmessage&topic=$topic_order{$topic_num}"><img src="/megaboard/images/post.gif" border="0" height="16" width="18"><font color="$colors{'links'}">Post</font></a></font></td>^;
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

  if (!defined($topicpass{$topic_order{$topic_num}}) || $in{'password'} eq $topicpass{$topic_order{$topic_num}})
  {


  if ($topic_num < 1)
  {
    print qq^<tr><td bgcolor="$colors{'messagetableback1'}" colspan=3><font face="arial" size="2" color="$colors{'listtabletext'}">[ No Threads in Category ]</td></tr>^;
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
	      $counter += 1;
		}

    open(THREAD, "$messagepath/$topic_order{$topic_num}/$threads{$thread}");
	chomp(@messages = <THREAD>);
	close(THREAD);

	$title = @messages[0];
    $num   = @messages - 1;

    $lastline = @messages[-1];
    @message = split(/\|/, $lastline);

  $curtime   = &GetTime;
	($curmonth, $today, $curyearandtime) = split("-", "$curtime");
	($curyear, $curhourmin) = split(" ", "$curyearandtime");

	
	$time = @message[2];

	  ($month, $day, $yearandtime) = split("-", "$time");
	  ($year, $hourmin) = split(" ", "$yearandtime");
  

# Check to see if posted previous day

  if ($day < $today)
  {
    $time = "@months[$month-1] $day";
  }
  else
  {
    $time = $hourmin;
  }

# Check to see if posted previous month
if ($month < $curmonth && $year <= $curyear)
{
	$time = "@months[$month-1] $day";
}

	$messno = @message[4];

  print qq^
  <tr>
    <td width=5 bgcolor="$colors{'listtable'}"><font size=1>&nbsp</td><td bgcolor="$colors{'listtable'}" width=200><small><font face="Arial" color="$colors{'listtabletext'}"><a
    href="megaboard.pl?forum=$in{'forum'}&job=viewthread&topic=$topic_order{$topic_num}&thread=$threads{$thread}&startat=0&new=$messno"><small><u>$title</u></a> <font color="$colors{'listtabletext'}">($num)</font></small></td>
    <td width="50" bgcolor="$colors{'listtable'}" align=right><font size="-1" color="$colors{'listtabletext'}">$time</font></td>
  </tr>^;
      } # END IF
	} # END IF
  } # END FOREACH

  print qq^
  <tr>
    <td bgcolor="$colors{'listback'}" colspan=3 align="right"><font face="arial" size="-2" color="$colors{'listtabletext'}">^;
	
  @totalthreads = keys %threads;
  $totalthreads = @totalthreads - 1;
  if ($totalthreads > $settings{'maxlistsize'} && !$in{'showtopic'})
  {
	print qq^[ <a href="megaboard.pl?forum=$in{'forum'}&job=viewlist&showtopic=$topic_order{$topic_num}" target="messagelist"><font color="$colors{'messagebacklink'}">VIEW ALL $totalthreads THREADS</font></a> ] ^;
  }

    print qq^	
	[ <a href="megaboard.pl?forum=$in{'forum'}&job=viewlist#$topic_order{$topic_num}" target="messagelist"> <font color="$colors{'messagebacklink'}">T O P</font></a> ]</td>
  </tr>^;

  } # END IF

# reset hash for next category
  foreach $key (keys %threads)
  {
    delete $threads{$key};
  }

	}
	if (defined($topicpass{$topic_order{$topic_num}}) && $in{'password'} ne $topicpass{$topic_order{$topic_num}})
	{
		print qq^<tr><td bgcolor="$colors{'listtable'}" colspan=3><form action="megaboard.pl" method="post" target="messagelist"><font face="verdana" size=2 color="$colors{'listtabletext'}">&nbsp;Password: <input type=password size=20 class="form" name="password"><input type="hidden" name="forum" value="$in{'forum'}"><input type="hidden" name="job" value="viewlist"><input type="hidden" name="showtopic" value="$topic_order{$topic_num}"></td></form></tr>
		<tr><td align="right" bgcolor="$colors{'messageback'}" colspan=3><font face="verdana" size=1>&nbsp</td></tr>^;
	  # reset hash for next category
	  foreach $key (keys %threads)
	  {
		delete $threads{$key};
	  }
	}

	

} # END FOREACH

print qq^
</table>
</td></table>
</body>
</html>^;

}

1;