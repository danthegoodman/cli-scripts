#!/usr/bin/env python2

import re
import os
from xml.etree import ElementTree

# Python does not hoist functions, so main
# will be called at the end of this script
def main():
	paths = readPathsFile()
	games = initGamesList(paths)
	stats = readStatsFile(paths)
	processStatsFile(stats, games)
	sortedStatus = sortGamesByStatus(games)
	reportStats(games, sortedStatus)

def convertGameName(name):
	name = re.sub(r'[-_]', ' ', name)
	name = re.sub(r'\b\w', lambda pat: pat.group(0).upper(), name)
	name = re.sub(r'\..*$', '', name)
	return name

def readPathsFile():
	dirname = os.path.dirname(os.path.realpath(__file__))
	f = open(dirname+'/paths.input')
	paths = f.read().splitlines()
	f.close()
	return {
		'games': paths[0],
		'stats': re.sub(r'~', os.environ['HOME'], paths[1])
	}

def initGamesList(paths):
	games = {}
	for it in os.listdir(paths['games']):
		if not os.path.isdir(paths['games']+'/'+it):
			games[ convertGameName(it) ] = [0,0,0,0]
	return games

def readStatsFile(paths):
	root = ElementTree.parse(paths['stats'])
	return root.findall('entry[2]/li/stringvalue')

def processStatsFile(stats, games):
	currentGame = ""
	currentType = 0

	for it in stats:
		if currentType == 0:
			currentGame = convertGameName(it.text)
		else:
			games[currentGame][currentType - 1] = int(it.text)
		currentType = (currentType + 1) % 5

def sortGamesByStatus(games):
	result = {
		'notries': [],
		'nowins': [],
		'wins': []
	}

	for k, v in games.iteritems():
		if v[1] == 0:
			result['notries'].append(k)
		elif v[0] == 0:
			result['nowins'].append(k)
		else:
			result['wins'].append(k)

	for k, v in result.iteritems():
		v.sort()

	return result

def reportStats(games, sortedStatus):
	if len(sortedStatus['wins']) > 0:
		print "## Games ################ Wins ## Tries"
		for it in sortedStatus['wins']:
			v = games[it]
			print "{:<25} {:>4} {:>8}".format(it, v[0], v[1])

	if len(sortedStatus['nowins']) > 0:
		print "\n## No Wins ############# Tries"
		for it in sortedStatus['nowins']:
			v = games[it]
			print "{:<25} {:>4}".format(it, v[1])

	if len(sortedStatus['notries']) > 0:
		print "\n## No Tries ############"
		for it in sortedStatus['notries']:
			print it

main()