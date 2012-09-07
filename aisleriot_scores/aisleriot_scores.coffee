#!/usr/bin/env coffee

# apt-get install nodejs
# npm install libxmljs-easy printf
# sudo npm -g install coffee-script

fs = require 'fs'
xml = require 'libxmljs-easy'
printf = require 'printf'

# Coffee-script does not hoist functions, so main
# will be called at the end of this script
main = ->
	paths = readPathsFile()
	games = initGamesList(paths)
	stats = readStatsFile(paths)
	processStatsFile(stats, games)
	sortedStatus = sortGamesByStatus(games)
	reportStats(games, sortedStatus)

convertGameName = (name) ->
	name = name.replace(/[-_]/g,' ')
	name = name.replace(/\b\w/g, (s)-> s.toUpperCase())
	dot = name.indexOf('.')
	if dot isnt -1
		name = name.substring(0, dot)
	return name

readPathsFile = ->
	file = fs.readFileSync("#{__dirname}/paths.input").toString()
	paths = file.split('\n')
	return {
		games: paths[0]
		stats: paths[1].replace(/~/, process.env['HOME'])
	}

initGamesList = (paths) ->
	games = {}
	fs.readdirSync(paths.games).forEach (it)->
		fileStatus = fs.statSync("#{paths.games}/#{it}")
		if not fileStatus.isDirectory()
			games[convertGameName(it)] = [0,0,0,0]
	return games

readStatsFile = (paths) ->
	file = fs.readFileSync(paths.stats)
	return xml.parse(file).entry[1].li

processStatsFile = (stats, games)->
	currentGame = ""
	currentType = 0

	for it in stats
		text = it.$.text().trim()
		if currentType is 0
			currentGame = convertGameName(text)
		else
			games[currentGame][currentType - 1] = Number(text)
		currentType = (currentType + 1) % 5

sortGamesByStatus = (games) ->
	result =
		notries: []
		nowins: []
		wins: []

	for k, v of games
		if v[1] is 0
			result.notries.push(k)
		else if v[0] is 0
			result.nowins.push(k)
		else
			result.wins.push(k)

	for key, list of result
		list.sort()

	return result

reportStats = (games, sortedStatus) ->
	if sortedStatus.wins.length > 0
		console.log "## Games ################ Wins ## Tries"
		sortedStatus.wins.forEach (it)->
			v = games[it]
			console.log printf("%-25s %4d %8d", it, v[0], v[1])

	if sortedStatus.nowins.length > 0
		console.log "\n## No Wins ############# Tries"
		sortedStatus.nowins.forEach (it) ->
			v = games[it]
			console.log printf("%-25s %4d", it, v[1])

	if sortedStatus.notries.length > 0
		console.log "\n## No Tries ############"
		sortedStatus.notries.forEach (it) ->
			console.log it

main()