#!/usr/bin/env perl

use Modern::Perl;
use autodie;
use IO::All;
use IPC::Run qw/run/;
use File::Basename;

die 'must be run as root!' unless $> == 0;

my $message = io('-')->slurp;

my @users = map { basename $_ } grep { eval { -e "$_/.fdm.conf" and -e "$_/.msmtprc" } } grep {!m#^/home/lost\+found$#} @{io('/home')};

my $command;
if (grep(/\@/,@ARGV)) {
	die "more than 1 possible deliverer!" if @users > 1;
	run ['shell-quote','msmtp',@ARGV],'>',\$command;
} else {
	run ['shell-quote','fdm','-va','stdin','fetch'],'>',\$command;
}

run ['su','-c',$command,$users[0]],\$message;
