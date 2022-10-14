#!/usr/bin/perl

sub FAQ
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
<font face="arial" size="+1" color="$colors{'funcbacktext'}"><b>[ Frequently Asked Questions ]</b></font>
<hr height=1 color=$colors{'messagetableborder'}><center>
<table width=75% cellpadding=3>
<tr><td>
<font face="verdana" size="-1" color=$colors{'quotetext'}>
<b><font color=$colors{'funcbacktext'}>What is the name that is underneath my username?</font></b>
<p>
That is your rank on the forum.  Rank is determined by the number of posts you make.  Beware, if you spam the board the moderators may decide to remove your rank and denote you a Lamer.  Here are the post levels required to earn rank:
<p>
<center>
<table width=85%>
<tr><td width=50%><font face="verdana" size="-1" color=$colors{'quotetext'}><b>@statusnames[0]:</b></td><td width=50%><font face="verdana" size="-1" color=$colors{'quotetext'}>0-99</td></tr>
<tr><td width=50%><font face="verdana" size="-1" color=$colors{'quotetext'}><b>@statusnames[1]:</b></td><td width=50%><font face="verdana" size="-1" color=$colors{'quotetext'}>100-499</td></tr>
<tr><td width=50%><font face="verdana" size="-1" color=$colors{'quotetext'}><b>@statusnames[2]:</b></td><td width=50%><font face="verdana" size="-1" color=$colors{'quotetext'}>500-999</td></tr>
<tr><td width=50%><font face="verdana" size="-1" color=$colors{'quotetext'}><b>@statusnames[3]:</b></td><td width=50%><font face="verdana" size="-1" color=$colors{'quotetext'}>1000-2499</td></tr>
<tr><td width=50%><font face="verdana" size="-1" color=$colors{'quotetext'}><b>@statusnames[4]:</b></td><td width=50%><font face="verdana" size="-1" color=$colors{'quotetext'}>2500+</td></tr>
<tr><td width=50%><font face="verdana" size="-1" color=$colors{'admincolor'}><b>@statusnames[5]:</b></td><td width=50%><font face="verdana" size="-1" color=$colors{'quotetext'}>Forum Moderators</td></tr>
<tr><td width=50%><font face="verdana" size="-1" color=$colors{'quotetext'}><b>Lamer!</b></td><td width=50%><font face="verdana" size="-1" color=$colors{'quotetext'}>Spammers, Flamers, other annoying pests</td></tr>
</table>
</center>
<br>

<b><font color=$colors{'funcbacktext'}>What are those funny pictures next to a person's name?</font></b>
<p>
Those are the forum awards.  They are as follows:
<blockquote>
<img src="/megaboard/images/trophy.gif"> This is the award for the person with the most posts.<br>
<img src="/megaboard/images/thumbsup.gif"> This is the award for the person who has been replied to the most.<br>
<img src="/megaboard/images/lamer.gif"> This indicates that the person is an annoying pest. Steer away from those people :)</blockquote>

<b><font color=$colors{'funcbacktext'}>Smilies</font></b><br>
<table width=100%>
<tr><td><font face="verdana" size="-1" color=$colors{'quotetext'}>:)</td><td><font face="verdana" size="-1" color=$colors{'quotetext'}>Smile</td><td><img src="/megaboard/emoticons/smily.gif"></td></tr>
<tr><td><font face="verdana" size="-1" color=$colors{'quotetext'}>:D</td><td><font face="verdana" size="-1" color=$colors{'quotetext'}>Big Smile</td><td><img src="/megaboard/emoticons/bigsmile.gif"></td></tr>
<tr><td><font face="verdana" size="-1" color=$colors{'quotetext'}>;)</td><td><font face="verdana" size="-1" color=$colors{'quotetext'}>Wink</td><td><img src="/megaboard/emoticons/wink.gif"></td></tr>
<tr><td><font face="verdana" size="-1" color=$colors{'quotetext'}>8)</td><td><font face="verdana" size="-1" color=$colors{'quotetext'}>Glasses</td><td><img src="/megaboard/emoticons/glasses.gif"></td></tr>
<tr><td><font face="verdana" size="-1" color=$colors{'quotetext'}>B)</td><td><font face="verdana" size="-1" color=$colors{'quotetext'}>Sun Glasses</td><td><img src="/megaboard/emoticons/sunglasses.gif"></td></tr>
<tr><td><font face="verdana" size="-1" color=$colors{'quotetext'}>:(</td><td><font face="verdana" size="-1" color=$colors{'quotetext'}>Frown</td><td><img src="/megaboard/emoticons/sad.gif"></td></tr>
<tr><td><font face="verdana" size="-1" color=$colors{'quotetext'}>&gt;:(</td><td><font face="verdana" size="-1" color=$colors{'quotetext'}>Angry</td><td><img src="/megaboard/emoticons/angry.gif"></td></tr>
<tr><td><font face="verdana" size="-1" color=$colors{'quotetext'}>&gt;:O</td><td><font face="verdana" size="-1" color=$colors{'quotetext'}>REALLY Angry!</td><td><img src="/megaboard/emoticons/pissed.gif"></td></tr>
<tr><td><font face="verdana" size="-1" color=$colors{'quotetext'}>( 8'(|)</td><td><font face="verdana" size="-1" color=$colors{'quotetext'}>Homer, D'OH!</td><td><img src="/megaboard/emoticons/homer.gif"></td></tr>
</table>
</td></tr></table>^;

&footer;

print qq^</body>
</html>^;

}

1;