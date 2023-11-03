#!/usr/bin/perl -w
use strict;
use Cwd 'abs_path';
use Data::Dumper;
use File::Basename;

my ($job) = @ARGV;
my $QUIET_SUCCESS = defined $ENV{'QUIET_SUCCESS'} && $ENV{'QUIET_SUCCESS'} eq "true";

if (not defined $job) {
    die "Need a path to a Nomad job file.\n";
}

my $dirname = abs_path(dirname($job));
my $jobname = basename($job);

if ( $dirname ne "" ) {
    chdir "$dirname";
}

my $prog = "nomad";
my @args = ("job", "plan");
push @args, $jobname;

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
    # try parsing the error some?
    if ($return_value =~ "Failed to parse using HCL 2") {
        my $re = qr/Error getting job struct: Failed to parse using HCL 2.[^\n]*\n[^:]+:([^:]+): (.*)/m;

        # my $re = qr/.*:\n([^:]+):(\d+),(\d+)-(\d+)\n(.*)/m;
        my @matches = $return_value =~ $re;
        # Print the entire match result
        if (@matches) {
            my $lineRe = qr/(\d+),(\d+)-(\d+)/;
            my @lineMatches = $matches[0] =~ $lineRe;
            my $lineInfo = join( '🫥', @lineMatches );
            print "$dirname/$jobname🫥$lineInfo🫥$matches[1]\n";
            exit $exitCode;
        }
        print "***Failed to parse HCL2 error***\n";
        print $return_value;
    }
    if ($return_value =~ "Error parsing job file") {
        my $re = qr/Error getting job struct: Error parsing job file from ([^:]+):\n[^:]+:([^:]+): (.*)/m;
        my @matches = $return_value =~ $re;
        # Print the entire match result
        if (@matches) {
            my $lineRe = qr/(\d+),(\d+)-(\d+)/;
            my @lineMatches = $matches[1] =~ $lineRe;
            my $lineInfo = join( '🫥', @lineMatches );
            print "$dirname/$jobname🫥$lineInfo🫥$matches[2]\n";
            exit $exitCode;
        }
        print "***Failed to parse parsing error***\n";
        print "$dirname/$jobname\n";
        print $return_value;
        exit $exitCode;
    }
    if ($return_value =~ "Error during plan: ") {
        my @matches = split('\n', $return_value);
        shift @matches;
        # Print the entire match result
        if (@matches) {
            s/[ \t]+\* // for @matches;
            # my $lineRe = qr/(\d+),(\d+)-(\d+)/;
            # my @lineMatches = $matches[1] =~ $lineRe;
            # my $lineInfo = join( '🫥', @lineMatches );
            my $message = join(", ", @matches);
            $message =~ s/occurred:, /occurred: /g;
            print "$dirname/$jobname🫥1🫥1🫥1🫥$message\n";
            exit $exitCode;
        }
        print "***Failed to parse plan error***\n";
        print "$dirname/$jobname\n";
        print $return_value;
        exit $exitCode;
    }
    print "***Failed to parse unexpected error***\n";
    print "$dirname/$jobname\n";
    print $return_value;
    exit $exitCode;
}

if ($exitCode == 1) {
    if ($return_value =~ "Job Warnings:") {
        print "Maybe Successful...Review output\n";
        print $return_value;
        exit;
    } else {
        if (! $QUIET_SUCCESS) {
            print "Success!\n";
        }
        exit;
    }
}

if ($exitCode == 0) {
    if (! $QUIET_SUCCESS) {
        print "Success!\n";
    }
}
else {
    printf "Failed with error code %d\n\nError message: %s\n",
        $exitCode, $return_value;
}
exit $exitCode;
