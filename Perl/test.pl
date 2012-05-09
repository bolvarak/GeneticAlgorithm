#!/usr/bin/perl -w
## Use strict syntax
use strict;
## Use warnings
use warnings;
## Use our debugger
use Data::Dumper;
## Use our genetic algorithm
use GeneticAlgorithm;
## Use our genetic algorithm map
use GeneticAlgorithmMap;
## Seed the random number generator
srand(time);
## Grab an instance of the algorithm
my($oAlgorithm) = new GeneticAlgorithm();
## Define the map
my(@aMap)       = (
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
 	1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1,
 	8, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1,
 	1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1,
 	1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1,
 	1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1,
 	1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 1,
 	1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 5,
 	1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1,
 	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
);
## Grab an instance of the map
my($oMap)       = new GeneticAlgorithmMap();
## Dump the map
print Dumper($oMap->createMap(@aMap));
## print Dumper($oAlgorithm);