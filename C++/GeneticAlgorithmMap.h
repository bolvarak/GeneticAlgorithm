// Application Definitions
#ifndef GENETICALGORITHMMAP_H
	#define GENETICALGORITHMMAP_H
	// Application Headers
	#include <stdlib.h>
	#include <vector>
	#include "Definitions.h"
	// Namespace Definition
	using namespace std;
	// Map class definition
	class GeneticAlgorithmMap {
	// Private properties
	private:
		// Map Storage
		static const int iMap[MAP_HEIGHT][MAP_WIDTH];
		static const int mMapWidth;
		static const int mMapHeight;
		// Starting points
		static const int mStartX;
		static const int mStartY;
		// End points
		static const int mEndX;
		static const int mEndY;
		             int mGeneration;
	// Public Properties
	public:
		// Memory storage
		int iMemory[MAP_HEIGHT][MAP_WIDTH];
		// Constructor Definition
		GeneticAlgorithmMap() {
			// Set the generation
			mGeneration = 0;
			// Clear memory
			ResetMemory();
		}
		// Displays the map
		void Render();
		// Displays just the generation counter
		void RenderGeneration();
		// Clears memory
		void ResetMemory();
		// Tests the route to see how far the organism can get and returns
		// a fitness score proportional to the distance reached from the exit
		double TestRoute(const vector<int> &vPath, GeneticAlgorithmMap &cMemory, int &iGeneration);
	};
#endif
