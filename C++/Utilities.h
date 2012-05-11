#ifndef UTILITIES_H
	#define UTILITIES_H
	// Application headers
	#include <stdlib.h>
	#include <math.h>
	#include <sstream>
	#include <string>
	#include <iostream>
	// Namespace
	using namespace std;
	// Convert integers to strings
	string IntegerToString(int iNumber);
	// Random integer generator
	inline int RandomInteger(int iNumberX, int iNumberY) {
		// Return the random number
		return (rand() % (iNumberY - iNumberX + 1) + iNumberX);
	}
	// Random float point generator
	inline double RandomFloat() {
		// Return the random floating point
		return (rand() / (RAND_MAX + 1.0));
	}
	// Random boolean generator
	inline bool RandomBoolean() {
		// Generate the random boolean
		if (RandomInteger(0, 1)) {
			// Return the boolean
			return true;
		} else {
			// Return the boolean
			return false;
		}
	}
	// Return a random floating point between -1.0 and 1.0
	inline double RandomClamped() {
		// Generate and return the random floating point
		return (RandomFloat() - RandomFloat());
	}
	// Clear render buffer
	inline void RenderClearBuffer() {
		// Clear the buffer
		system("clear");
	}
	// Clear buffer line
	inline void RenderClearBufferLine() {
		// Clear the buffer line
		cout << "\e[K\r";
	}
	// Render entry point
	inline void RenderEntryPoint() {
		// Render the entry
		cout << "\e[45:33m|\e[0m";
	}
	// Render Generation
	inline void RenderGenerationToScreen(int iGeneration) {
		// Render the generation
		cout << "Generation:  " << iGeneration << endl;
	}
	// Render new line
	inline void RenderNewLine() {
		// Render the new line
		cout << endl;
	}
	// Render empty space
	inline void RenderNull() {
		// Render the empty space
		cout << "\e[1;45m \e[0m";
	}
	// Render step
	inline void RenderStep() {
		// Render the step
		cout << "\e[45;33m=\e[0m";
	}
	// Render wall
	inline void RenderWall() {
		// Render the wall
		cout << "\e[45;32m+\e[0m";
	}
#endif
