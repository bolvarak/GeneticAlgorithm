#!/usr/bin/perl -w
## Define the package name
package GeneticAlgorithmMap;
	## Use strict syntax
	use strict;
	## Use warnings
	use warnings;
	## Use our debugger
	use Data::Dumper;
	## Define our constants
	use constant {
		END_X      => 2, 
		END_Y      => 0,
		MAP_HEIGHT => 10, 
		MAP_WIDTH  => 15, 
		START_X    => 13, 
		START_Y    => 9
	};
	## Set our instance placeholder
	my($oInstance);
	 #########################################################################
	### Singleton #############################################################
	 #########################################################################
	sub getInstance  {
		## Grab the reset denoter
		my($bReset) = shift;
		## Check for a pre-existing instance
		if ($oInstance and !$bReset) {
			## Return the existing instance
			return $oInstance;
		} else {
			## Return a new instance
			return new GeneticAlgorithm::Map();
		}
	}
	 #########################################################################
	### Constructor ###########################################################
	 #########################################################################
	sub new {
		## Grab the class
		my($sClass) = shift;
		## Set the map height and width
		my($iMapWidth)  = shift || (MAP_WIDTH);
		my($iMapHeight) = shift || (MAP_HEIGHT);
		## Setup the instance
		my($oSelf)      = {
			mMap       => {},
			mMapWidth  => $iMapWidth, 
			mMapHeight => $iMapHeight,  
			mStartX    => shift || (START_X), 
			mStartY    => shift || (START_Y), 
			mEndX      => shift || (END_X), 
			mEndY      => shift || (END_Y), 
			mMemory    => undef
		};
		## Set the instance
		$oInstance ||= bless($oSelf, $sClass);
		## Return the instance
		return $oInstance;
	}
	 #########################################################################
	### Public ################################################################
	 #########################################################################
	sub createMap {
		## Grab the instance and map array
		my($oSelf, @aMap) = @_;
		## Reset the map
		$oSelf->resetMemory();
		## Set the column
		my($iColumn)      = 0;
		## Set the row
		my($iRow)         = 0;
		## Loop through the map array
		for (my($iCoordinate) = 0; $iCoordinate < scalar(@aMap); $iCoordinate ++) {
			## Check to see if we are on the correct row
			if ($iColumn == $oSelf->{"mMapWidth"}) {
				## Reset the column
				$iColumn = 0;
				## Increment the row
				$iRow ++;
			}
			## Add the coordinate
			$oSelf->{"mMap"}->{$iRow}{$iColumn} = $aMap[$iCoordinate];
			## Increment the column
			$iColumn ++;
		}
		## Return instance
		return $oSelf;
	}
	sub render {

	}
	sub renderFromMemory {

	}
	sub resetMemory {
		## Grab the instance
		my($oSelf) = shift;
		## Generate an empty map
		for (my($iRow) = 0; $iRow < $oSelf->{"mMapHeight"}; $iRow ++) {
			## Create the empty row hashes
			$oSelf->{"mMap"}->{$iRow} = {};
		}
		## Set the rows
		while (my($iKey, $mValue) = each(%{$oSelf->{"mMap"}})) {
			## Generate the column hashes
			for (my($iColumn) = 0; $iColumn < $oSelf->{"mMapWidth"}; $iColumn ++) {
				## Set the column
				$oSelf->{"mMap"}->{$iKey}->{$iColumn} = 0;
			}
		}
		## Return instance
		return $oSelf;
	}
	sub testRoute {
		## Grab the instance, path and temporary memory
		my($oSelf, @aPath, $oMap) = @_;
	}
	 #########################################################################
	### Setters ###############################################################
	 #########################################################################
	sub setMap {
		## Grab the instance and map
		my($oSelf, %oMap) = @_;
		## Store the map
		$oSelf->{"mMap"} = %oMap;
		## Return instance
		return $oSelf;
	}
## All is well, terminate
1;
## No, actually terminate
__END__;