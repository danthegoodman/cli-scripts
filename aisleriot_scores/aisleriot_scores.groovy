#!/usr/bin/env groovy

// apt-get install groovy

import java.math.*
import groovy.io.*

main()
void main(){
	paths = readPathsFile()
	games = initGamesList(paths)
	stats = readStatsFile(paths)
	processStatsFile(stats, games)
	sortedStatus = sortGamesByStatus(games)
	reportStats(games, sortedStatus)
}

String convertName(String name){
	name = name.replaceAll(/[-_]/," ")
	name = name.replaceAll(/\b\w/, { it.toUpperCase() } )
	def dot = name.indexOf('.')
	if(dot != -1)
		name = name.substring(0, dot)
	return name;
}

Map readPathsFile(){
	dirname = new File(getClass().protectionDomain.codeSource.location.path).parent
	file = new File("$dirname/paths.input")
	paths = file.readLines()
	return [
		games: paths[0],
		stats: paths[1].replace(/~/, System.getenv()['HOME'])
	]
}

Map initGamesList(Map paths){
	Map games = [:]
	new File(paths.games).eachFile(FileType.FILES){
		games[convertName(it.name)] = [0,0,0,0]
	}
	return games
}

def readStatsFile(Map paths){
	root = new XmlSlurper().parse(new File(paths.stats))
	return root.entry[1].li
}

void processStatsFile(stats, Map games){
	String currentGame = ""
	int currentType = 0
	stats.each {
		if (currentType == 0) {
			currentGame = convertName(it.toString())
		} else {
			games[currentGame][currentType-1] = it.toString() as Integer;
		}
		currentType = (currentType+1) % 5
	}
}

Map sortGamesByStatus(Map games){
	def result = [
		notries: [],
		nowins: [],
		wins: []
	]

	games.each{ k, v ->
		if(v[1] == 0)
			result.notries << k;
		else if (v[0] == 0)
			result.nowins << k;
		else
			result.wins << k;
	}

	result.each{ key, list ->
		list.sort()
	}

	return result;
}

void reportStats(games, sortedStatus){
	if (sortedStatus.wins) {
		println "## Games ################ Wins ## Tries"
		sortedStatus.wins.each{
			def v = games[it]
			printf "%-25s %4d %8d\n", it, v[0], v[1]
		}
	}

	if (sortedStatus.nowins) {
		println "\n## No Wins ############# Tries"
		sortedStatus.nowins.each{
			def v = games[it]
			printf "%-25s %4d\n", it, v[1]
		}
	}

	if (sortedStatus.notries) {
		println "\n# No Tries ############"
		sortedStatus.notries.each{
			println it
		}
	}
}


