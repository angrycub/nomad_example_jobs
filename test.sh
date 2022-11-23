#!/usr/bin/perl -w
use strict;
use Data::Dumper;

my ($jobName) = @ARGV;

if (not defined $jobName) {
  die "Need a path to a Nomad job file.\n";
}

my $prog = "nomad";
my @args = ("job", "plan");
push @args, $jobName;

my $exitCode = 0;

my $return_value = `$prog @args 2>&1`;
if ($? == -1) {
    print "failed to execute: $!\n";
}
elsif ($? & 127) {
    printf "child died with signal %d, %s coredump\n",
        ($? & 127),  ($? & 128) ? 'with' : 'without';
}
else {
    $exitCode = $? >> 8;
}

if ($exitCode == 255) {
  print "I'm an exitcode 255!\n";
  # try parsing the error some?
  if ($return_value =~ "Failed to parse using HCL 2" ) {
    print "I'm here!\n";
    my $re = '/.*:\n([^:]+):(\d+),(\d+)-(\d+)\n(.*)/m';
    my @matches = $return_value =~ $re;
    # Print the entire match result
    print Dumper(@matches);
    exit

  }
}
if ($exitCode == 0) {
    print "Success!\n";
}
else {
    printf "Failed with error code %d\nError message: %s\n",
        $exitCode>>8, $return_value;
}