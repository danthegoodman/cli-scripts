#!/usr/bin/env perl

# sudo apt-get install libxml-simple-perl

# Bah! Perl references are crazy. I'll take my chances and go
# with some globals for a more straight forward script. Still,
# I can scope my sections to help prevent tons of globals.

use strict;
use XML::Simple;

sub convertName {
	$_ = shift;
	s/[-_]/ /g;
	s/\b(\w)/uc($1)/ge;
	s/\..*$//;
	$_;
}

my($gamesPath, $statsPath);
{ # readPathsFile
	open PATHS, "paths.input";
	chomp( ($gamesPath, $statsPath) = <PATHS>);
	$statsPath =~ s/~/$ENV{'HOME'}/e
	close PATHS
}


my %games;
{ # initGamesList
	my @files = `find $gamesPath -maxdepth 1 -type f -printf "%f\n"`;
	chomp @files;

	foreach (@files){
		$games{&convertName($_)} = [0,0,0,0];
	}
}

my $stats;
{ # readStatsFile
	my $xml = new XML::Simple;
	my $data = $xml->XMLin($statsPath);
	$stats = $$data{entry}{statistics}{li};
}

{ # processStatsFile
	my ($currentGame, $currentType);
	foreach (@$stats){
		my $v = $$_{stringvalue};
		if ($currentType == 0) {
			$currentGame = &convertName($v);
		} else {
			$games{$currentGame}[$currentType-1] = $v;
		}
		$currentType = ($currentType+1) % 5;
	}
}

my (@notries, @nowins, @wins);
{ # sortGamesByStatus
	foreach (sort keys %games){
		my $v = $games{$_};
		if ($$v[1] == 0) {
			push @notries, $_;
		} elsif ($$v[0] == 0) {
			push @nowins, $_;
		} else {
			push @wins, $_;
		}
	}
}

{ # reportStats
	if (@wins){
		print "## Games ################ Wins ## Tries\n";
		foreach (@wins){
			my $v = $games{$_};
			printf "%-25s %4d %8d\n", $_, $$v[0], $$v[1];
		}
	}

	if (@nowins) {
		print "\n## No Wins ############# Tries\n";
		foreach (@nowins){
			my $v = $games{$_};
			printf "%-25s %4d\n", $_, $$v[1];
		}
	}

	if (@notries) {
		print "\n# No Tries ############\n";
		foreach (@notries) {
			printf "$_\n";
		}
	}
}
