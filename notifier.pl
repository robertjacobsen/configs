#!/usr/bin/env perl
use strict;
use warnings;
use POSIX;

if (`ps aux | grep notifier.pl | grep -v $$ | grep -v grep`) {
    die "Daemon already running. Aborting.";
}

my $parent = fork();
exit if $parent;
POSIX::setsid;

my $arch = `uname` =~ /^Darwin/ ? 'Mac' : 'Linux';
if ($arch eq 'Linux' && !`which notify-send`) {
    die "Linux - Cannot find notify-send.";
} elsif ($arch eq 'Mac' && !`which terminal-notifier`) {
    die "Mac - Cannot find terminal-notifier. Install it with:\n sudo gem install terminal-notifier";
}

if (!defined $ARGV[0]) {
    die "Usage: perl notifier.pl user\@hostname.com";
}

my $ssh_login = $ARGV[0];
my ($user, $host) = $ssh_login =~ m{^(\w+)\@(.*?)$};

# Create SSH tunnel
if (!`ps aux | grep ssh | grep 22222 | grep -v grep`) {
    `ssh -f $ssh_login -L 22222:$host:22 -N`;
}

my $last = q();
while (1) {
    my $ts = `ssh -qt $user\@localhost -p 22222 cat .weechat-event`;
    if ($ts =~ /^201\d-\d{2}-\d{2}_\d{6}$/ &&
        $ts ne $last) {
        $last = $ts;
        if ($arch eq 'Linux') {
            `notify-send -u normal "Notification from Weechat"`;
        } else {
            `terminal-notifier -message "Notification from Weechat"`;
        }
    }
    sleep 3;
}
