// Application headers
#include "Utilities.h"
// Convert integers to strings
string IntegerToString(int iNumber) {
	// Create the buffer
	ostringstream cBuffer;
	// Send the integer to the buffer for conversion
	cBuffer << iNumber;
	// Return the string
	return cBuffer.str();
}
