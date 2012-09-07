# aisleriot_scores

## About

Aisleriot (or `sol`) is the GNOME collection of solitare games.
There are close to 90 games in this collection, with no easy method for determining which games have notbeen played, which games have been played but not won, and finally the games that have been won.

These scripts solves that problem by sorting the games by such criteria.

I feel that this task, while by no means difficult, is sufficiently complex to test several key parts of a language and it's libraries.
As such, each script produces the same output as it's brethren and attempts to
solve the problem in similar methods.

Last tested with version 3.4.1

## Example (Trimmed)

    $ ./aisleriot_scores.py
	## Games ################ Wins ## Tries
	Athena                       1        1
	Bakers Dozen                 1        1
	Bakers Game                  1        3
	Bear River                   1        1

	## No Wins ############# Tries
	Accordion                    1
	Agnes                        1

	## No Tries ############
	Scorpion
	Will O The Wisp

## Tasks Overview

By solving this problem, I am demonstrating how to accomplish the following tasks in any given language:

1. Define, use, and limit the scope of variables
1. Define and use subroutines/functions
1. Substitute string contents using regular expressions
1. Read a file into a set of strings
1. List the files within a directory
1. Maintain a Hash/Associative Array
1. Read and parse and XML file
1. Iterate over a set of items
1. Iterate over a hash of items
1. Sort a list of items
1. Print data in a formatted manner

## Further Details

Some scripts require extra libraries to be installed.
At the top of each script are comments detailing how to install the extra libraries inside of debian/ubuntu linux.
