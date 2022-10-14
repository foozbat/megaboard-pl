# users.pl
# This file contains several modules for manipulating users
#
# addmod, demod, resetpass, deluser

# Add a moderator #
sub addmod
{
	if (&authcookie)
	{
		open(PROFILE, "<$profilepath/$in{'user'}/profile.dat");
		chomp(@profile = <PROFILE>);
		close(PROFILE);

		@profile[3] = "moderator";

		open(PROFILEOUT, ">$profilepath/$in{'user'}/profile.dat");
		print PROFILEOUT "@profile[0]\n";
		print PROFILEOUT "@profile[1]\n";
		print PROFILEOUT "@profile[2]\n";
		print PROFILEOUT "@profile[3]";
		close(PROFILEOUT);
	
		print qq^
	        <HTML>
		<HEAD>
		<SCRIPT LANGUAGE="JavaScript">
		window.location = "megaboard.pl?forum=$in{'forum'}&job=admdispusers&message=addmodpass&user=$in{'user'}";
		</SCRIPT>
		<BODY BGCOLOR=$colors{'funcback'} text=$colors{'funcbacktext'} link=$colors{'links'} vlink=$colors{'links'} alink=$colors{'links'}>
		If this page does not automatically redirect,
		<a href="megaboard.pl?forum=$in{'forum'}&job=admdispusers&message=addmodpass&user=$in{'user'}">click here to view users</a>.
		</BODY>
		</HTML>^;
	}
	else
	{
		print qq^
	        <HTML>
		<HEAD>
		<SCRIPT LANGUAGE="JavaScript">
		window.location = "megaboard.pl?forum=$in{'forum'}&job=admdispusers&message=addmodfail&user=$in{'user'}";
		</SCRIPT>
		<BODY BGCOLOR=$colors{'funcback'} text=$colors{'funcbacktext'} link=$colors{'links'} vlink=$colors{'links'} alink=$colors{'links'}>
		If this page does not automatically redirect,
		<a href="megaboard.pl?forum=$in{'forum'}&job=admdispusers&message=addmodfail&user=$in{'user'}">click here to view users</a>.
		</BODY>
		</HTML>^;
	}
}

# Remove moderator
sub demod
{
	if (&authcookie)
	{
		open(PROFILE, "<$profilepath/$in{'user'}/profile.dat");
		chomp(@profile = <PROFILE>);
		close(PROFILE);

		@profile[3] = "";

		open(PROFILEOUT, ">$profilepath/$in{'user'}/profile.dat");
		print PROFILEOUT "@profile[0]\n";
		print PROFILEOUT "@profile[1]\n";
		print PROFILEOUT "@profile[2]\n";
		print PROFILEOUT "@profile[3]";
		close(PROFILEOUT);
	
		print qq^
	        <HTML>
		<HEAD>
		<SCRIPT LANGUAGE="JavaScript">
		window.location = "megaboard.pl?forum=$in{'forum'}&job=admdispusers&message=demodpass&user=$in{'user'}";
		</SCRIPT>
		<BODY BGCOLOR=$colors{'funcback'} text=$colors{'funcbacktext'} link=$colors{'links'} vlink=$colors{'links'} alink=$colors{'links'}>
		If this page does not automatically redirect,
		<a href="megaboard.pl?forum=$in{'forum'}&job=admdispusers&message=demodpass&user=$in{'user'}">click here to view users</a>.
		</BODY>
		</HTML>^;
	}
	else
	{
		print qq^
	        <HTML>
		<HEAD>
		<SCRIPT LANGUAGE="JavaScript">
		window.location = "megaboard.pl?forum=$in{'forum'}&job=admdispusers&message=demodfail&user=$in{'user'}";
		</SCRIPT>
		<BODY BGCOLOR=$colors{'funcback'} text=$colors{'funcbacktext'} link=$colors{'links'} vlink=$colors{'links'} alink=$colors{'links'}>
		If this page does not automatically redirect,
		<a href="megaboard.pl?forum=$in{'forum'}&job=admdispusers&message=demodfail&user=$in{'user'}">click here to view users</a>.
		</BODY>
		</HTML>^;
	}
}

# delete a user, changes password to 
sub deluser
{
	if (&authcookie)
	{
		open(PROFILE, "<$profilepath/$in{'user'}/profile.dat");
		chomp(@profile = <PROFILE>);
		close(PROFILE);
		
		srand;

		open(PROFILEOUT, ">$profilepath/$in{'user'}/profile.dat");
		print PROFILEOUT "@profile[0]\n";
		print PROFILEOUT "@profile[1]\n";
		print PROFILEOUT "MB", int(rand(10)), int(rand(10)), int(rand(10)), int(rand(10)), int(rand(10)), "\n";
		print PROFILEOUT "@profile[3]";
		close(PROFILEOUT);
	
		print qq^
	        <HTML>
		<HEAD>
		<SCRIPT LANGUAGE="JavaScript">
		window.location = "megaboard.pl?forum=$in{'forum'}&job=admdispusers&message=deluserpass&user=$in{'user'}";
		</SCRIPT>
		<BODY BGCOLOR=$colors{'funcback'} text=$colors{'funcbacktext'} link=$colors{'links'} vlink=$colors{'links'} alink=$colors{'links'}>
		If this page does not automatically redirect,
		<a href="megaboard.pl?forum=$in{'forum'}&job=admdispusers&message=deluserpass&user=$in{'user'}">click here to view users</a>.
		</BODY>
		</HTML>^;
	}
	else
	{
		print qq^
	        <HTML>
		<HEAD>
		<SCRIPT LANGUAGE="JavaScript">
		window.location = "megaboard.pl?forum=$in{'forum'}&job=admdispusers&message=deluserfail&user=$in{'user'}";
		</SCRIPT>
		<BODY BGCOLOR=$colors{'funcback'} text=$colors{'funcbacktext'} link=$colors{'links'} vlink=$colors{'links'} alink=$colors{'links'}>
		If this page does not automatically redirect,
		<a href="megaboard.pl?forum=$in{'forum'}&job=admdispusers&message=deluserfail&user=$in{'user'}">click here to view users</a>.
		</BODY>
		</HTML>^;
	}
}

# resets a users password to $in{'pass'} #
# this also reinstates deleted users     #
sub resetpass
{
	if (&authcookie && $in{'pass'} ne 'null')
	{
		open(PROFILE, "<$profilepath/$in{'user'}/profile.dat");
		chomp(@profile = <PROFILE>);
		close(PROFILE);
		
		open(PROFILEOUT, ">$profilepath/$in{'user'}/profile.dat");
		print PROFILEOUT "@profile[0]\n";
		print PROFILEOUT "@profile[1]\n";
		print PROFILEOUT crypt($in{'pass'}, 'limabean'), "\n";
		print PROFILEOUT "@profile[3]";
		close(PROFILEOUT);
	
		print qq^
	        <HTML>
		<HEAD>
		<SCRIPT LANGUAGE="JavaScript">
		window.location = "megaboard.pl?forum=$in{'forum'}&job=admdispusers&message=resetpasspass&user=$in{'user'}&newpass=$in{'pass'}";
		</SCRIPT>
		<BODY BGCOLOR=$colors{'funcback'} text=$colors{'funcbacktext'} link=$colors{'links'} vlink=$colors{'links'} alink=$colors{'links'}>
		If this page does not automatically redirect,
		<a href="megaboard.pl?forum=$in{'forum'}&job=admdispusers&message=resetpasspass&user=$in{'user'}&newpass=$in{'pass'}">click here to view users</a>.
		</BODY>
		</HTML>^;
	}
	else
	{
		print qq^
	        <HTML>
		<HEAD>
		<SCRIPT LANGUAGE="JavaScript">
		window.location = "megaboard.pl?forum=$in{'forum'}&job=admdispusers&message=resetpassfail&user=$in{'user'}";
		</SCRIPT>
		<BODY BGCOLOR=$colors{'funcback'} text=$colors{'funcbacktext'} link=$colors{'links'} vlink=$colors{'links'} alink=$colors{'links'}>
		If this page does not automatically redirect,
		<a href="megaboard.pl?forum=$in{'forum'}&job=admdispusers&message=resetpassfail&user=$in{'user'}">click here to view users</a>.
		</BODY>
		</HTML>^;
	}
}

1;