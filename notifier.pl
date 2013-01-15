#!/usr/bin/env perl
use strict;
use warnings;
use POSIX;

sub create_ssh_tunnel {
    my ($user, $host) = @_;

    if (!`ps aux | grep ssh | grep 22222 | grep -v grep`) {
        `ssh -f $user\@$host -L 22222:$host:22 -N`;
    }
}

sub read_event {
    my ($user) = @_;
    return `ssh -qt $user\@localhost -p 22222 cat .weechat-event`;
}

sub send_notification {
    my ($arch, $notification) = @_;

    if ($arch eq 'Linux') {
        `notify-send -u normal "$notification"`;
    } else {
        `terminal-notifier -message "$notification"`;
    }
}

if (!defined $ARGV[0]) {
    die "Usage: perl notifier.pl user\@hostname.com";
}

if (`ps aux | grep notifier.pl | grep -v $$ | grep -v grep`) {
    exit 0;
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

my $ssh_login = $ARGV[0];
my ($user, $host) = $ssh_login =~ m{^(\w+)\@(.*?)$};

# Create SSH tunnel
create_ssh_tunnel($user, $host);

my $last = q();
while (1) {
    my $ts = read_event($user);

    if (!$ts) {
        # Reinitialise SSH tunnel
        create_ssh_tunnel($user, $host);
        $ts = read_event($user);
    }

    if ($ts =~ /^201\d-\d{2}-\d{2}_\d{6}$/ &&
        $ts ne $last) {
        $last = $ts;

        send_notification($arch, 'Notification from Weechat');
    }

    sleep 3;
}
