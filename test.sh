#!/usr/bin/perl -w
use strict;
use Data::Dumper;
use File::Basename;

my ($jobName) = @ARGV;

if (not defined $jobName) {
  die "Need a path to a Nomad job file.\n";
}

my $dirname  = dirname($jobName);
chdir "$dirname";

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
    my $re = '/.*:\n([^:]+):(\d+),(\d+)-(\d+)\n(.*)/m';
    my @matches = $return_value =~ $re;
    # Print the entire match result
    if (@matches) {
      print Dumper(@matches);
    } else {
      print "***Failed to parse ***\n";
      print $return_value;
    }
  } else {
    print "*** Not an HCL2 error ***\n";
    print $return_value;
  }
  exit $exitCode;
}
if ($exitCode == 1) {
   print "Maybe Successful...Review output\n";
   print $return_value;
   exit;
}

if ($exitCode == 0) {
    print "Success!\n";
}
else {
    printf "Failed with error code %d\n\nError message: %s\n",
        $exitCode, $return_value;
}
exit $exitCode
