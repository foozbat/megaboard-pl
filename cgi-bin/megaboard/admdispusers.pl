# displays all of the registered users on the board

sub AdmDispUsers
{
	opendir(USERS, "$profilepath");
	chomp(@users = readdir(USERS));
	closedir(USERS);

	print qq^
    <html>

    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>View Registered Users</title>
    <style>
	    a:link   {color:"$colors{'links'}"; text-decoration:none}
    	a:visited{color:"$colors{'links'}"; text-decoration:none}
	    a:hover  {color:"$colors{'links'}"; text-decoration:underline}
    </style>
    <script language="javascript">
    function askPassword(user)
    {
	var pass;
	if(pass = prompt("Enter new password:", ""))
	{
		window.location = "megaboard.pl?forum=$in{'forum'}&job=resetpass&user=" + user + "&pass=" + pass;
	}
    }

    function confirmDelete(user)
    {
	if (confirm('Are you sure you want to delete ' + user + "?"))
	{
		window.location = "megaboard.pl?forum=$in{'forum'}&job=deluser&user=" + user;
	}
    }
    </script>
    </head>

    <body background="$forumurl/$settings{'backgroundimage'}" bgcolor=$colors{'funcback'} text=$colors{'functabletext'} link="$colors{'links'}" vlink="$colors{'links'}" alink="$colors{'links'}">^;

	if ($cookie{'frames'} eq 'off')
	{
	  &header;
	}

	print qq^
	<font face="verdana" size=1 color=$colors{'funcbacktext'}><b>Options:</b><br>
	+M - Make user a moderator<br>
	-M - Remove user's moderator privilages<br>
	RP - Reset password to specified word (this will also reinstate a deleted user)<br>
	DEL - Delete user (changes user's password to prevent them from posting)<p>^;

	if (defined($in{'message'}))
	{
		%messages = ("addmodpass"    => "Successfully added moderator $in{'user'}",
			     "addmodfail"    => "Error adding moderator $in{'user'}, please re-login",
			     "demodpass"     => "Successfully removed moderator $in{'user'}",
		 	     "demodfail"     => "Error adding moderator $in{'user'}, please re-login",
			     "deluserpass"   => "Successfully deleted user $in{'user'}",
			     "deluserfail"   => "Error deleting user $in{'user'}, please re-login",
			     "resetpasspass" => "Successfully reset $in{'user'}'s password to $in{'newpass'}",
			     "resetpassfail" => "Error resetting password, please re-login");

		print "<b>[ $messages{$in{'message'}} ]</b><br><br>";
	}

	print qq^
	<table cellspacing=0 cellpadding=0 border=0 width=100%>
	<td bgcolor="$colors{'functableborder'}">
		<table cellspacing=1 cellpadding=3 border=0 width=100%>
		<tr><td bgcolor="$colors{'functitle'}" colspan=4><font face="verdana" color="$colors{'functitletext'}" size=2><b>Current Registered Users:</b></td><td colspan=2 bgcolor="$colors{'functitle'}"><font face="verdana" color="$colors{'functitletext'}" size=2><b>Posts/Replies</b></td>
		    <td bgcolor="$colors{'functitle'}"><font face="verdana" color="$colors{'functitletext'}" size=2><b>Email</b></td>
			<td bgcolor="$colors{'functitle'}"><font face="verdana" color="$colors{'functitletext'}" size=2><b>ICQ</b></td>
		</tr>^;

open(MOSTPOSTS, "$awardpath/posts");
chomp($mostposts = <MOSTPOSTS>);
close(MOSTPOSTS);

open(POPULAR, "$awardpath/replies");
chomp($popular = <POPULAR>);
close(POPULAR);

	foreach $user (@users)
	{
		if ($user ne '.')
		{
			if ($user ne '..')
			{
				open(PROFILE, "$profilepath/$user/profile.dat");
				chomp(@profile = <PROFILE>);
				close(PROFILE);

				open(POSTS, "$profilepath/$user/posts.dat");
				chomp($posts = <POSTS>);
				close(POSTS);

				open(REPLIES, "$profilepath/$user/replies.dat");
				chomp($replies = <REPLIES>);
				close(REPLIES);

				print qq^<tr><td bgcolor="$colors{'functable'}" nowrap align=center>^;

				print qq^<font face="arial" color="$colors{'functabletext'}" size=2>
				^;
				if (@profile[3] eq 'moderator')
				{
					print qq^<a href="megaboard.pl?forum=$in{'forum'}&job=demod&user=$user">-M</a>^;
				}
				else
				{
					if (@profile[2] =~ /MB\d\d\d\d\d/)
					{
						print qq^<font color=$colors{'quotetext'}>+M</font>^;
					}
					else
					{
						print qq^<a href="megaboard.pl?forum=$in{'forum'}&job=addmod&user=$user">+M</a>^;
					}
				}
				print qq^</td><td bgcolor="$colors{'functable'}" nowrap><font face="arial" color="$colors{'functabletext'}" size=2><a href="Javascript:askPassword('$user')">RP</a></td><td bgcolor="$colors{'functable'}" nowrap>^;

				if (@profile[2] =~ /MB\d\d\d\d\d/)
				{
					print qq^<font face="arial" color=$colors{'quotetext'} size=2>DEL</font>^;
				}
				else
				{
					print qq^<font face="arial" color="$colors{'functabletext'}" size=2><a href="Javascript:confirmDelete('$user')">DEL</a></font>^;
				}

				print qq^</td><td bgcolor="$colors{'functable'}" width=100%>
				<font face=arial color="^;

				if (@profile[3] eq 'moderator')
				{
					print "$colors{'admincolor'}";
				}
				elsif (@profile[2] =~ /MB\d\d\d\d\d/)
				{
					print "$colors{'quotetext'}";
				}
				else
				{
					print "$colors{'functabletext'}";
				}
							print qq^" size=2>$user^;
if ($user eq $mostposts)
{
  print "<img src=$imageurl/trophy.gif>";
}
if ($user eq $popular)
{
  print "<img src=$imageurl/thumbsup.gif>";
}
							print qq^</td><td bgcolor="$colors{'functable'}" nowrap align=center><font face=arial color="$colors{'functabletext'}" size=2>$posts</td><td bgcolor="$colors{'functable'}" nowrap align=center><font face=arial color="$colors{'functabletext'}" size=2>$replies</td>
							 <td bgcolor="$colors{'functable'}" nowrap><font face=arial color="^;
				if (@profile[2] =~ /MB\d\d\d\d\d/)
				{
					print "$colors{'quotetext'}";
				}
				else
				{
					print "$colors{'functabletext'}";
				}
				print qq^" size=2><a href=\"mailto:@profile[0]\">@profile[0]</a></td><td bgcolor="$colors{'functable'}" nowrap><font face=arial color="^;
				if (@profile[2] =~ /MB\d\d\d\d\d/)
				{
					print "$colors{'quotetext'}";
				}
				else
				{
					print "$colors{'functabletext'}";
				}
				print qq^" size=2>@profile[1]</td>
						 </tr>^;
			}
		}		
	} # END FOREACH

	print qq^
	</table></td></table>^;

	&footer;

	print qq^
	</body>
	</html>^;
}

1;