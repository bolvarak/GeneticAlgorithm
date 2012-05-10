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
## Execute the algorithm
$oAlgorithm->execute();
