#!/usr/bin/perl -w
## Define the package name
package GeneticAlgorithmMap;
	## Use strict syntax
	use strict;
	## Use warnings
	use warnings;
	## Define our constants
	use constant {
		END_X      => 0, 
		END_Y      => 2,
		MAP_HEIGHT => 10, 
		MAP_WIDTH  => 15, 
		START_X    => 14, 
		START_Y    => 7
	};
	## Set our instance placeholder
	my($oInstance);
	## Map global
	my(@aMap) = (
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
		## Create the map
		$oInstance->createMap();
		## Return the instance
		return $oInstance;
	}
	 #########################################################################
	### Public ################################################################
	 #########################################################################
	sub createMap {
		## Grab the instance and map array
		my($oSelf)   = shift;
		my(@aNewMap) = shift || @aMap;
		## Reset the map
		$oSelf->resetMemory();
		## Set the column
		my($iColumn)      = 0;
		## Set the row
		my($iRow)         = 0;
		## Loop through the map array
		for (my($iCoordinate) = 0; $iCoordinate < scalar(@aNewMap); $iCoordinate ++) {
			## Check to see if we are on the correct row
			if ($iColumn == $oSelf->{"mMapWidth"}) {
				## Reset the column
				$iColumn = 0;
				## Increment the row
				$iRow ++;
			}
			## Add the coordinate
			$oSelf->{"mMap"}->{$iRow}{$iColumn} = $aNewMap[$iCoordinate];
			## Increment the column
			$iColumn ++;
		}
		## Return instance
		return $oSelf;
	}
	sub render {
		## Grab the instance and generation
		my($oSelf) = @_;
		## Clear the current render
		$oSelf->renderClear();
		## Loop through the Y-Axis
		for (my($iCoordinateY) = 0; $iCoordinateY < $oSelf->{"mMapHeight"}; $iCoordinateY ++) {
			## Loop through the X-Axis
			for (my($iCoordinateX) = 0; $iCoordinateX < $oSelf->{"mMapWidth"}; $iCoordinateX ++) {
				## Determine the type of block
				if ($oSelf->{"mMap"}->{$iCoordinateY}->{$iCoordinateX} eq 1) {      ## Wall
					## Render a wall cell
					$oSelf->renderWall();
				} elsif ($oSelf->{"mMap"}->{$iCoordinateY}->{$iCoordinateX} eq 5) { ## Entrance
					## Render the entry point
					$oSelf->renderEntry();
				} elsif ($oSelf->{"mMap"}->{$iCoordinateY}->{$iCoordinateX} eq 8) { ## Exit
					## Render the entry point
					$oSelf->renderEntry();
				} else {                                                            ## Empty Space/Step
					## Check for a step
					if ($oSelf->{"mMemory"}->{$iCoordinateY} and $oSelf->{"mMemory"}->{$iCoordinateY}->{$iCoordinateX} and ($oSelf->{"mMemory"}->{$iCoordinateY}->{$iCoordinateX} eq 1)) {
							## Render the step
							$oSelf->renderStep();
						} else {
							## Render the empty space
							$oSelf->renderNull();
						}
				}
			}
			## Render a new line
			$oSelf->renderStartNewRow();
		}
		## Start a new row
		$oSelf->renderStartNewRow();
		## Return instance
		return $oSelf;
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
		my($oSelf, @aDirections, $oMap) = @_;
		## Define the positions
		my($iPositionX) = $oSelf->{"mStartX"};
		my($iPositionY) = $oSelf->{"mStartY"};
		## Loop through the directions
		for (my($iDirection) = 0; $iDirection < scalar(@aDirections); $iDirection ++) {
			## Determine the direction
			if ($aDirections[$iDirection] == 0) {      ## North
				## Check the boundaries
				if ((($iPositionY - 1) < 0) or ($oSelf->{"mMap"}->{($iPositionY - 1)}->{$iPositionX} == 1)) {
					## Move along, nothing to see here
					next;
				} else {
					## Decrease the Y-Axis
					$iPositionY -= 1;
				}
			} elsif ($aDirections[$iDirection] == 1) { ## South
				## Check the boundaries
				if ((($iPositionY + 1) >= $oSelf->{"mMapHeight"}) or ($oSelf->{"mMap"}->{($iPositionY + 1)}->{$iPositionX}) == 1) {
					## Move along, nothing to see here
					next;
				} else {
					## Increment the Y-Axis
					$iPositionY += 1;
				}
			} elsif ($aDirections[$iDirection] == 2) { ## East
				## Check the boundaries
				if ((($iPositionX + 1) >= $oSelf->{"mMapWidth"}) or ($oSelf->{"mMap"}->{$iPositionY}->{($iPositionX + 1)} == 1)) {
					## Move along, nothing to see here
					next;
				} else {
					## Increment the X-Axis
					$iPositionX += 1;
				}
			} elsif ($aDirections[$iDirection] == 3) { ## West
				## Check the boundaries
				if ((($iPositionX - 1) > 0) or ($oSelf->{"mMap"}->{$iPositionY}->{($iPositionX - 1)} == 1)) {
					## Move along, nothing to see here
					next;
				} else {
					## Decrease the X-Axis
					$iPositionX -= 1;
				}
			}
			## Set the memory
			$oMap->{"mMemory"}->{$iPositionY}->{$iPositionX} = 1;
		}
		## Assign a fitness score proportional to the organism's distance from the exit
		my($iDifferenceX) = abs($iPositionX - $oSelf->{"mEndX"});
		my($iDifferenceY) = abs($iPositionY - $oSelf->{"mEndY"});
		## Run the algorithm
		return (1 / ($iDifferenceX + $iDifferenceY + 1));
	}
	 #########################################################################
	### Utilities #############################################################
	 #########################################################################
	sub renderClear {
		## Grab the instance
		my($oSelf) = shift;
		## Clear the screen
		system("clear");
		## Use this for Windows
		## system("cls");
		## Return instance
		return $oSelf;
	}
	sub renderClearLine {
		## Grab the instance
		my($oSelf) = shift;
		## Render the clear line
		print "\e[K\r";
		## Return instance
		return $oSelf;
	}
	sub renderEntry {
		## Grab the instance
		my($oSelf) = shift;
		## Render the entrance
		print "\e[45;33m|\e[0m";
		## Return instance
		return $oSelf;
	}
	sub renderGeneration {
		## Grab the instance and generation
		my($oSelf, $iGeneration) = @_;
		## Print the generation
		print ("Generation: ", $iGeneration);
		## Return instance
		return $oSelf;
	}
	sub renderNull {
		## Grab the instance
		my($oSelf) = shift;
		## Render the empy space
		print "\e[1;45m \e[0m";
		## Return instance
		return $oSelf;
	}
	sub renderStartNewRow {
		## Grab the instance
		my($oSelf) = shift;
		## Render the newline
		print "\n";
		## Return instance
		return $oSelf;
	}
	sub renderStep {
		## Grab the instance
		my($oSelf) = shift;
		## Render the step
		print "\e[45;33m=\e[0m";
		## Return instance
		return $oSelf;
	}
	sub renderWall {
		## Grab the instance
		my($oSelf) = shift;
		## Render the wall
		print "\e[45;32m+\e[0m";
		## Return instance
		return $oSelf;
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