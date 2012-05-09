#!/usr/bin/perl -w
## Define our package name
package GeneticAlgorithm;
	## Use our map package
	use GeneticAlgorithmMap;
	## Use strict syntax
	use strict;
	## Use warnings
	use warnings;
	## Define our constants
	use constant {
		CHROMOSOME_LENGTH => 70,    ## The length of each chromosome
		CROSSOVER_RATE    => 0.7,   ## The rate at which genes crossover
		GENE_LENGTH       => 2,     ## The length of each gene
		MUTATION_RATE     => 0.001, ## The rate of mutation
		POPULATION_SIZE   => 140    ## The size of each population
	};
	## Instance placeholder
	my($oInstance);
	 #########################################################################
	### Singleton #############################################################
	 #########################################################################
	sub getInstance {
		## Grab the reset denoter
		my($bReset) = shift;
		## Check for a pre-existing instance
		if ($oInstance and !$bReset) {
			## Return the existing instance
			return $oInstance;
		} else {
			## Return a new instance
			return new GeneticAlgorithm();
		}
	}
	 #########################################################################
	### Constructor ###########################################################
	 #########################################################################
	sub new {
		## Grab the class name
		my($sClass) = shift;
		## Setup the instance
		my($oSelf)  = {
			mCrossoverRate     => shift || (CROSSOVER_RATE), 
			mMutationRate      => shift || (MUTATION_RATE), 
			mPopulationSize    => shift || (POPULATION_SIZE), 
			mChromosomeLength  => shift || (CHROMOSOME_LENGTH), 
			mTotalFitnessScore => 0.0, 
			mGeneLength        => shift || (GENE_LENGTH), 
			mBusy              => 0, 
			mGenomes           => undef, 
			mFittestGenome     => undef, 
			mBestFitnessScore  => undef,
			mMap               => undef, 
			mBrain             => undef, 
			mGeneration        => undef
		};
		## Set the instance
		$oInstance ||= bless($oSelf, $sClass);
		## Create an initial population
		$oInstance->createPopulation();
		## Return the instance
		return $oInstance;
	}
	 #########################################################################
	### Public ################################################################
	 #########################################################################
	sub createPopulation {
		## Grab the instance
		my($oSelf) = shift;
		## Reset any existing populations
		$oSelf->{"mGenomes"} = [];
		## Loop through the population
		for (my($iGenome) = 0; $iGenome < $oSelf->{"mPopulationSize"}; $iGenome ++) {
			## Encode and add the genome
			push(@{$oSelf->{"mGenomes"}}, $oSelf->getGenome($oSelf->{"mChromosomeLength"}));
		}
		## Reset the variables
		$oSelf->{"mGeneration"}        = 0;
		$oSelf->{"mFittestGenome"}     = 0;
		$oSelf->{"mBestFitnessScore"}  = 0;
		$oSelf->{"mTotalFitnessScore"} = 0;
	}
	sub crossover {
		## Grab the instance, parents and offspring
		my($oSelf, @aMother, @aFather, @aOffspringAlphpa, @aOffspringBeta) = @_;
		## Simply set the offspring as the parents dependant on the 
		## crossover rate or if the parents are the same
		if (($oSelf->randomFloat() < $oSelf->{"mCrossoverRate"}) || (@aMother == @aFather)) {
			## Set the first child
			@aOffspringAlphpa = @aMother;
			## Set the second child
			@aOffspringBeta   = @aFather;
			## Return 
			return;
		}
		## Set the crossover point
		my($iCrossoverPoint)                                               = $oSelf->randomInteger(0, ($oSelf->{"mChromosomeLength"} - 1));
		## Swap the bits
		for (my($iGenome) = 0; $iGenome < $iCrossoverPoint; $iGenome ++) {
			## Add an alpha offspring
			push(@aOffspringAlphpa, $aMother[$iGenome]);
			## Add a beta offspring
			push(@aOffspringBeta, $aFather[$iGenome]);
		}
		for (my($iGenome) = $iCrossoverPoint; $iGenome < scalar(@aMother); $iGenome ++) {
			## Add an alpha genome
			push(@aOffspringAlphpa, $aFather[$iGenome]);
			## Add a beta offspring
			push(@aOffspringBeta, $aMother[$iGenome]);
		}
	}
	sub epoch {
		## Grab the instance
		my($oSelf) = shift;
		## Update the fitness scores
		$oSelf->updateFitnessScores();
		## Population incrementor
		my($iNewOffspring) = 0;
		## Create a placeholder for the offspring
		my(@aOffspring, %oMother, %oFather, %oOffspringAlpha, %oOffspringBeta);
		## Loop through the offspring
		while ($iNewOffspring < $oSelf->{"mPopulationSize"}) {
			## Select two parents
			%oMother         = $oSelf->naturalSelection();
			%oFather         = $oSelf->naturalSelection();
			## Placeholders for the offspreing
			%oOffspringAlpha = $oSelf->getGenome();
			%oOffspringBeta  = $oSelf->getGenome();
			## Crossover
			$oSelf->crossover(\$oMother{"aBits"}, \$oFather{"aBits"}, \$oOffspringAlpha{"aBits"}, \$oOffspringBeta{"aBits"});
			## Mutate
			$oSelf->mutate(\$oOffspringAlpha{"aBits"});
			$oSelf->mutate(\$oOffspringBeta{"aBits"});
			## Add the offspring to the new population
			push(@aOffspring, %oOffspringAlpha);
			push(@aOffspring, %oOffspringBeta);
			## Increment the count
			$iNewOffspring += 2;
		}
		## Set the new population into the system
		$oSelf->{"mGenomes"}     = @aOffspring;
		## Increment the generation
		$oSelf->{"mGeneration"} += 1;
	}
	sub execute {
		## Grab the instance
		my($oSelf) = shift;
		## Create a new population
		$oSelf->createPopulation();
		## Tell everyone we are busy
		$oSelf->{"mBusy"} = 1;
	}
	sub mutate {
		## Grab the instance and bits
		my($oSelf, @aBits) = @_;
		## Loop through the bits
		for (my($iBit) = 0; $iBit < scalar(@aBits); $iBit ++) {
			## Determine if the bit should be flipped
			if ($oSelf->randomFloat() < $oSelf->{"mMutationRate"}) {
				## Flip the bit
				$aBits[$iBit] = !$aBits[$iBit];
			}
		}
	}
	sub naturalSelection {
		## Grab the instance
		my($oSelf)           = shift;
		## Set the slice placeholder
		my($iSlice)          = ($oSelf->randomFloat() * $oSelf->{"mTotalFitnessScore"});
		## Set the total placeholder
		my($iTotal)          = 0.0;
		## Set the selected Genome placeholder
		my($iSelectedGenome) = 0;
		## Loop through the population
		for (my($iGenome) = 0; $iGenome < $oSelf->{"mPopulationSize"}; $iGenome ++) {
			## Set the total fitnes
			$iTotal += @{$oSelf->{"mGenomes"}}[$iGenome]->{"iFitness"};
			## Is this the genome we are looking for
			if ($iTotal > $iSlice) {
				## Set the selected genome
				$iSelectedGenome = $iGenome;
				## End the loop
				last;
			}
		}
		## Return the selected genome
		return @{$oSelf->{"mGenomes"}}[$iSelectedGenome];
	}
	sub render {
		## Grab the instance
		my($oSelf) = shift;
		## Dump this instance
		print Dumper($oSelf);
	}
	sub updateFitnessScores {
		## Grab the instance
		my($oSelf) = shift;
		## Reset the globals
		$oSelf->{"mFittestGenome"}     = 0;
		$oSelf->{"mBestFitnessScore"}  = 0;
		$oSelf->{"mTotalFitnessScore"} = 0;
		## Setup a temporary brain
		my($oTemporaryMemory)          = new GeneticAlgorithmMap();
		## Update the fitness scores and keep track of the fittest so far
		for (my($iGenome) = 0; $iGenome < $oSelf->{"mPopulationSize"}; $iGenome ++) {
			## Grab the directions
			my(@aDirections) = $oSelf->decode(\@{$oSelf->{"mGenomes"}}[$iGenome]->{"aBits"});
			## Decode each genome's chromosome into an array of directions
			@{$oSelf->{"mGenomes"}}[$iGenome]->{"iFitness"} = $oSelf->{"mMap"}->testRoute(\@aDirections, \$oTemporaryMemory);
			## Update the total fitness score
			$oSelf->{"mTotalFitnessScore"} += @{$oSelf->{"mGenomes"}}[$iGenome]->{"iFitness"};
			## Is this the genome we are looking for
			if (@{$oSelf->{"mGenomes"}}[$iGenome]->{"iFitness"} > $oSelf->{"mBestFitnessScore"}) {
				## Store it
				$oSelf->{"mBestFitnessScore"} = @{$oSelf->{"mGenomes"}}[$iGenome]->{"iFitness"};
				## Set the fittest genome
				$oSelf->{"mFittestGenome"}    = $iGenome;
				## Update the memory with the temporary memory
				$oSelf->{"mBrain"}            = $oTemporaryMemory;
				## Has the solution been found
				if (@{$oSelf->{"mGenomes"}}[$iGenome]->{"iFitness"} == 1) {
					## A solution has been found, stop the algorithm
					$oSelf->{"mBusy"} = 0;
				}
			}
			## Reset the temporary memory
			$oTemporaryMemory->resetMemory();
		}

	}
	 #########################################################################
	### Utilities #############################################################
	 #########################################################################
	sub binaryToInteger {
		## Grab the instance and binary array
		my($oSelf, @aBinary) = @_;
		## Set the default value
		my($iValue)          = 0;
		## Set the multiplier
		my($iMultiplier)     = 1;
		## Loop through the bits
		for (my($iBit) = scalar(@aBinary); $iBit > 0; $iBit --) {
			## Set the new value
			$iValue += ($aBinary[($iBit - 1)] * $iMultiplier);
			## Set the new multiplier
			$iMultiplier *= 2;
		}
		## Return the value
		return $iValue;
	}
	sub decode {
		## Grab the instance and encoded bits
		my($oSelf, @aEncodedBits) = @_;
		## Create a directions placeholder
		my(@aDirections);
		## Loop through the genes
		for (my($iGene) = 0; $iGene < scalar(@aEncodedBits); $iGene ++) {
			## Current gene placeholder
			my(@aCurrentGene);
			## Loop through the gene's bits
			for (my($iBit) = 0; $iBit < $oSelf->{"mGeneLength"}; $iBit ++) {
				## Add the bit
				push(@aCurrentGene, $aEncodedBits[($iGene + $iBit)]);
			}
			## Decode the bit
			push(@aDirections, $oSelf->binaryToInteger(\@aCurrentGene));
		}
		## Return the directions
		return @aDirections;
	}
	sub randomBoolean {
		## Grab the instance
		my($oSelf) = shift;
		## Generate the random boolean
		if ($oSelf->randomInteger(0, 2)) {
			## Return true
			return 1;
		} else {
			## Return false
			return 0;
		}
	}
	sub randomClamped {
		## Grab the instance
		my($oSelf) = shift;
		## Generate the clamp
		return ($oSelf->randomFloat() - $oSelf->randomFloat());
	}
	sub randomFloat {
		## Grab the instance
		my($oSelf) = shift;
		## Return the random floating point
		return (rand() / 1.0);
	}
	sub randomInteger {
		## Grab the instance, first number and second number
		my($oSelf, $iNumberAlpha, $iNumberBeta) = @_;
		## Return the random integer
		return int(rand($iNumberBeta));
	}
	 #########################################################################
	### Getters ###############################################################
	 #########################################################################
	sub getGenome {
		## Grab the instance and number of bits
		my($oSelf, $iNumberOfBits) = @_;
		## Setup the Genome
		my($oGenome)               = {
			aBits    => [], 
			iFitness => 0
		};
		## Loop to the number of bits
		for (my($iBit) = 0; $iBit < $iNumberOfBits; $iBit ++) {
			## Push the bit
			push(@{$oGenome->{"aBits"}}, $oSelf->randomInteger(0, 2));
		}
		## Return the genome
		return $oGenome;

	}
## All is well, terminate
1;
## No, actually terminate
__END__;