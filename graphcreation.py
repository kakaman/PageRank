import csv
datafile = open('/home/vyshnav/Documents/TwitterK2.csv', 'r')
datareader  = csv.reader(datafile)
data  = []
for row in datareader:
	data.append(row)

import networkx as nx
G = nx.DiGraph()
datafile = open('/home/vyshnav/Documents/TwitterK2.csv', 'r')
data = []
for row in datafile:
	G.add_edges_from(data)

lst = nx.edges(G)
strtweight = float(1.00)/float(len(lst)) #4352
pr = nx.pagerank(G, tol=.1, weight=strtweight)	

#returns sum of all values: .999999
#total pairs: 415/ 415
sum(pr.values())

d = {}
datawsink = open('/home/vyshnav/Documents/pagerank.csv', 'r')
datareader = csv.DictReader(datawsink)
for row in datareader:
	d = {row}

d = {}
datafile = open('/home/vyshnav/Documents/pagerank.csv', 'r')
datareader  = csv.reader(datafile)
data  = []
for row in datareader:
	data.append(row)

d.dict(data)
