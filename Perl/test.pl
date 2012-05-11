#!/usr/bin/perl -w
## Use strict syntax
use strict;
## Use warnings
use warnings;
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
## Set the loop boolean
my($bDone) = undef;
## Loop until done
while (!$bDone) {
	## Check to see if the algorithm has started
	if ($oAlgorithm->getStarted()) {
		## Epoch
		$oAlgorithm->epoch();
	} else {
		## Render a clean line
		print "----------------------------------------------------------------------------------\n";
		## Render the Generation count
		print "Generations:  ", $oAlgorithm->getGeneration(), "\n";
		## Render the fittest genome
		print "Fittest Genome:  ", $oAlgorithm->getFittest(), "\n";
		## Render a clean line
		print "----------------------------------------------------------------------------------\n";
		## Set the done boolean
		$bDone = 1;
	}
}
