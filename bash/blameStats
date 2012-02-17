#!/bin/bash
function findAllGitFiles(){
	echo Finding... >&2
	git ls-tree --name-only -r HEAD
}
function filterTextFiles(){
	echo Filtering... >&2
	while read filename; do
		if [[ `file --mime-encoding "$filename"` == *us-ascii* ]]
		then
			echo $filename
		fi
	done
}
function extractAuthors(){
    sed -En 's|[0-9a-f]+ [a-zA-Z/.-]+ \(([a-zA-Z]+ [a-zA-Z]*)[ ]+2.*|\1|p'
}
function blameAuthors(){
	while read filename; do
		echo $filename >&2
		git --no-pager blame -f "$filename" | extractAuthors 
	done
}
function countUniqueNames(){
	echo Counting... >&2
	sort | uniq -c 
}

findAllGitFiles | filterTextFiles | blameAuthors | countUniqueNames 
