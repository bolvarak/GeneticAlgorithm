// Application Header
#include "GeneticAlgorithmMap.h"
#include "Utilities.h"
// Define our maze
const int GeneticAlgorithmMap::iMap[MAP_HEIGHT][MAP_WIDTH] = {
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
};
// Define the map dimensions
const int GeneticAlgorithmMap::mMapHeight = MAP_HEIGHT;
const int GeneticAlgorithmMap::mMapWidth  = MAP_WIDTH;
// Define the map start positions
const int GeneticAlgorithmMap::mStartX    = 14;
const int GeneticAlgorithmMap::mStartY    = 7;
// Define the map end positions
const int GeneticAlgorithmMap::mEndX      = 0;
const int GeneticAlgorithmMap::mEndY      = 2;
// Render method
void GeneticAlgorithmMap::Render() {
	// Clear the current buffer
	RenderClearBuffer();
	// Loop through the y-axis
	for (int iCoordinateY = 0; iCoordinateY < mMapHeight; ++iCoordinateY) {
		// Loop through the x-axis
		for (int iCoordinateX = 0; iCoordinateX < mMapWidth; ++iCoordinateX) {
			if (iMap[iCoordinateY][iCoordinateX] == 1) {         // Is this a wall
				// Render a wall
				RenderWall();
			} else if (iMap[iCoordinateY][iCoordinateX] == 5) {  // Is this an exit
				// Render entry point
				RenderEntryPoint();
			} else if  (iMap[iCoordinateY][iCoordinateX] == 8) { // Is this an entrance
				// Render entry point
				RenderEntryPoint();
			} else {
				// Check for a step
				if (iMemory[iCoordinateY] && iMemory[iCoordinateY][iCoordinateX] && (iMemory[iCoordinateY][iCoordinateX] == 1)) {
					// Render the step
					RenderStep();
				} else {
					// Render empty space
					RenderNull();
				}
			}
		}
		// Render a new line
		RenderNewLine();
	}
	// Render another new line
	RenderNewLine();
	// Render the generation
	RenderGenerationToScreen(mGeneration);
}
// Render only the generation
void GeneticAlgorithmMap::RenderGeneration() {
	// Render the generation
	RenderGenerationToScreen(mGeneration);
}
// Reset Memory Method
void GeneticAlgorithmMap::ResetMemory() {
	// Loop through the y-axis
	for (int iCoordinateY = 0; iCoordinateY < mMapHeight; ++iCoordinateY) {
		// Loop through the x-axis
		for (int iCoordinateX = 0; iCoordinateX < mMapWidth; ++iCoordinateX) {
			// Reset the coordinates
			iMemory[iCoordinateY][iCoordinateX] = 0;
		}
	}
}
// Test Route Method
double GeneticAlgorithmMap::TestRoute(const vector<int> &vPath, GeneticAlgorithmMap &cMemory, int &iGeneration) {
	// Set the generation
	mGeneration    = iGeneration;
	// Define the positions
	int iPositionX = mStartX;
	int iPositionY = mStartY;
	// Loop through the paths
	for (int iDirection = 0; iDirection < (int) vPath.size(); ++iDirection) {
		// Determine the direction
		switch (vPath[iDirection]) {
			// North
			case 0 : 
				// Check the boundaries
				if (((iPositionY - 1) < 0) || (iMap[(iPositionY - 1)][iPositionX] == 1)) {
					// Done
					break;
				} else {
					// Decriment Y-axis
					iPositionY -= 1;
				}
				// Done
				break;
			// South
			case 1 : 
				// Check the boundaries
				if (((iPositionY + 1) >= mMapHeight) || (iMap[(iPositionY + 1)][iPositionX] == 1)) {
					// Done
					break;
				} else {
					// Increment Y-axis
					iPositionY += 1;
				}
				// Done
				break;
			// East
			case 2 : 
				// Check the boundaries
				if (((iPositionX + 1) >= mMapWidth) || (iMap[iPositionY][(iPositionX + 1)] == 1)) {
					// Done
					break;
				} else {
					// Increment X-axis
					iPositionX += 1;
				}
				// Done
				break;
			// West
			case 3 : 
				// Check the boundaries
				if (((iPositionX - 1) < 0) || (iMap[iPositionY][iPositionX - 1] == 1)) {
					// Done
					break;
				} else {
					// Decrement X-axis
					iPositionX -= 1;
				}
				// Done
				break;
		}
		// Set the memory set
		cMemory.iMemory[iPositionY][iPositionX] = 1;
	}
	// Assign fitness score proportional to the organism's distance from the exit
	int iDifferenceX = abs(iPositionX - mEndX);
	int iDifferenceY = abs(iPositionY - mEndY);
	// Run the algorithm
	return (1 / (double)(iDifferenceX + iDifferenceY + 1));
}
