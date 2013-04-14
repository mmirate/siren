#!/usr/bin/env perl

# siren.pl - forward local mail to fdm and everything else to msmtp
# Copyright (C) <year>  <name of author>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

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
