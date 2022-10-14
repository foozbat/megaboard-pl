#!/usr/bin/perl

require "/web/hit-squad/cgi-bin/cgi-lib.pl";

&ReadParse;

print "Content-type: text/html\r\n\r\n";

if (!defined($in{'install'})) # print the form
{
print qq^
<html>
<head><title>Megaboard Installation</title></head>

<font face=verdana size=2>
<h1>Megaboard Installation</h1>

<b>Please supply the following information:</b>
<form action="foruminstall.pl" method=post>
Domain Name (no www):<br>
<input type=text size=20 name="domainname"><p>

Path to http root directory:<br>
<input type=text size=20 name="httproot"><p>

Forum ID Tag (no spaces, a small word to identify the forum, eg "mainforum"):<br>
<input type=text size=20 name="forumtag"><p>

Forum Name:<br>
<input type=text size=20 name="forumname"><p>

Enter Desired Topic Names (up to 10):<br>
<input type=text size=20 name="topic1"><br>
<input type=text size=20 name="topic2"><br>
<input type=text size=20 name="topic3"><br>
<input type=text size=20 name="topic4"><br>
<input type=text size=20 name="topic5"><br>
<input type=text size=20 name="topic6"><br>
<input type=text size=20 name="topic7"><br>
<input type=text size=20 name="topic8"><br>
<input type=text size=20 name="topic9"><br>
<input type=text size=20 name="topic10"><br>

<hr width=50% align=left>
<b>Administrator setup:</b><p>

Nickname:<br>
<input type=text size=20 name="nickname"><p>

Email Address:<br>
<input type=text size=20 name="email"><p>

Desired Password:<br>
<input type=password size=20 name="password"><p>

ICQ Number (optional):<br>
<input type=text size=20 name="icq"><p>

Make sure your settings are correct and press "Install" to setup your board<br>
<input type="submit" value="Install" name="install">

</form>

</html>
^;
}
else # install the board
{
	if (!&Install)
	{
		print "<br>errors occured\n";
	}
	else
	{
		print "<br>all ok\n";
	}
}

sub Install
{
	#change to the http root directory
	$error = chdir("$in{'httproot'}");

	#makes the megaboard directory
	$error = mkdir("megaboardtest", 0777);

	# make main subdirectories
	$error = chdir("megaboardtest");

	$error = mkdir("emoticons", 0777);
	$error = mkdir("images", 0777);
	$error = mkdir("$in{'forumtag'}", 0777);

	# copy emoticon images
	&move("mbinstallfiles/angry.gif", "megaboardtest/emoticons/angry.gif");
	&move("mbinstallfiles/bigsmile.gif", "megaboardtest/emoticons/bigsmile.gif");
	&move("mbinstallfiles/glasses.gif", "megaboardtest/emoticons/glasses.gif");
	&move("mbinstallfiles/homer.gif", "megaboardtest/emoticons/homer.gif");
	&move("mbinstallfiles/pissed.gif", "megaboardtest/emoticons/pissed.gif");
	&move("mbinstallfiles/sad.gif", "megaboardtest/emoticons/sad.gif");
	&move("mbinstallfiles/smily.gif", "megaboardtest/emoticons/smily.gif");
	&move("mbinstallfiles/sunglasses.gif", "megaboardtest/emoticons/sunglasses.gif");
	&move("mbinstallfiles/wink.gif", "megaboardtest/emoticons/wink.gif");

	# copy forum images
	&move("mbinstallfiles/admintop.gif", "megaboardtest/images/admintop.gif");
	&move("mbinstallfiles/ban.gif", "megaboardtest/images/ban.gif");
	&move("mbinstallfiles/bigtitle.gif", "megaboardtest/images/bigtitle.gif");
	&move("mbinstallfiles/comments.gif", "megaboardtest/images/comments.gif");
	&move("mbinstallfiles/delete.gif", "megaboardtest/images/delete.gif");
	&move("mbinstallfiles/edit.gif", "megaboardtest/images/edit.gif");
	&move("mbinstallfiles/faq.gif", "megaboardtest/images/faq.gif");
	&move("mbinstallfiles/frames.gif", "megaboardtest/images/frames.gif");
	&move("mbinstallfiles/home.gif", "megaboardtest/images/home.gif");
	&move("mbinstallfiles/iplog.gif", "megaboardtest/images/iplog.gif");
	&move("mbinstallfiles/lamer.gif", "megaboardtest/images/lamer.gif");
	&move("mbinstallfiles/mail.gif", "megaboardtest/images/mail.gif");
	&move("mbinstallfiles/mbfooter.gif", "megaboardtest/images/mbfooter.gif");
	&move("mbinstallfiles/noframes.gif", "megaboardtest/images/noframes.gif");
	&move("mbinstallfiles/post.gif", "megaboardtest/images/post.gif");
	&move("mbinstallfiles/register.gif", "megaboardtest/images/register.gif");
	&move("mbinstallfiles/reply.gif", "megaboardtest/images/reply.gif");
	&move("mbinstallfiles/sendtofriend.gif", "megaboardtest/images/sendtofriend.gif");
	&move("mbinstallfiles/thumbsup.gif", "megaboardtest/images/thumbsup.gif");
	&move("mbinstallfiles/trophy.gif", "megaboardtest/images/trophy.gif");
	&move("mbinstallfiles/unlamer.gif", "megaboardtest/images/unlamer.gif");

	# set up the forum directory
	chdir("$in{'forumtag'}");

	mkdir("admin", 0777);
	mkdir("awards", 0777);
	mkdir("messages", 0777);
	mkdir("profiles");

	# make the file that stores banned ip's
	open(CREATEBAN, ">admin/banned.dat");
	close(CREATEBAN);

	# make the settings.dat file
	open(CREATESETTINGS, ">admin/settings.dat");

	print CREATESETTINGS qq^
		# ----------------------------------------
		# This file contains the Forum Settings
		# DO NOT MODIFY THIS FILE!
		# Use the forum administration program
		#  to modify forum settings
		# ----------------------------------------

		\$domain      = "$in{'domain'}"; #!!!!!!!!

		\$rootpath    = "$in{'httproot'}";

		\$datapath    = "\$rootpath/megaboard/hitsquad/admin";
		\$imageurl    = "/megaboard/images";

		\$path        = "\$rootpath/cgi-bin/megaboard/";
		\$messagepath = "\$rootpath/megaboard/hitsquad/messages";
		\$profilepath = "\$rootpath/megaboard/hitsquad/profiles";
		\$awardpath   = "\$rootpath/megaboard/hitsquad/awards";

		\$homepage    = "http://www.hit-squad.net";

		\$forumurl    = "/megaboard/hitsquad/";

		\$anonymousposting = "TRUE";

		\%settings    = (title => '$in{forumname}',
						 htmlposts => 'off',
						 frameheight => '80',
						 frames => 'off',
						 maxlistsize => '25',
						 customheadfoot => 'on',
						 backgroundimage => 'back.gif');

		\%topic       = (hitsquad_general     => 'HiT-SQUAD General Forum',
						 serious_sam	     => 'Serious Sam Forum',
						 feedback_suggestions => 'Feedback & Suggestions');

		\%topic2num   = (hitsquad_general     => '1',
						 serious_sam	     => '2',
						 feedback_suggestions => '3');

		\%num2topic   = (1 => 'hitsquad_general',
						 2 => 'serious_sam',
						 3 => 'feedback_suggestions');

		\@months = ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');

		# Colors
		# ----------------------------------------

		\%colors = (
				   links      => '#ff4444',
			       vlink      => 'gray',
			       footer     => 'silver',
		# message window #
				   messagetopoftable => '#220000',
				   messagetoptext => 'white',
				   messageback => 'black',
				   messagetext => 'white',
				   messagewindowbacktext => 'white',
				   messagetableback1  => '#222222',
				   messagetableback2  => '#222222',
				   messagetableborder => 'gray',
			       messagebacklink    => '#ff4444',
			       admincolor         => 'red',
			       quotetext          => 'silver',
		# messagelist #
				   listback  => 'black',
				   listbacktext => 'white',
				   listtable   => '#222222',
				   listtitle    => '#220000',
				   listtitletext => 'white',
				   listtabletext => 'white',
			       listborder => 'gray',
		# board functions #
				   funcback    => 'black',
				   funcbacktext => 'white',
				   functable    => '#222222',
				   functitle    => '#220000',
			       functitletext => 'white',
				   functabletext => 'white',
			       functableborder => 'gray',
			       funcformcolor => 'black',
			       funcformtext => 'white',
		# top bar #
				   topbarback   => 'black',
				   topbartext   => 'white',
				   topbarlinks  => 'white'
		);
	^; # end printing
	close(CREATESETTINGS);


	return $error;
}

sub move
{
	local $from = $_[0];
	local $to = $_[1];

	open(FILE, "$in{'httproot'}/$from");
	open(NEWFILE, ">$in{'httproot'}/$to");
	while (<FILE>)
	{
		print NEWFILE;
	}
	close(NEWFILE);
	close(FILE);

	#unlink $from;

	print "$from copied to $to sucessfully<br>\n";
}

