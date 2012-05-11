// Application Headers
#include <stdlib.h>
#include <time.h>
#include "GeneticAlgorithm.h"
#include "Definitions.h"
// Namespace definition
using namespace std;
// global definitions
GeneticAlgorithm* cGeneticAlgorithm;
// Main()
int main () {
	// Setup our stop boolean
	bool bDone = false;
	// Instantiate the algorithm
	cGeneticAlgorithm = new GeneticAlgorithm(CROSSOVER_RATE, MUTATION_RATE, POPULATION_SIZE, CHROMOSOME_LENGTH, GENE_LENGTH);
	// Execute the algorithm
	cGeneticAlgorithm->Execute();
	// Loop until done
	while (!bDone) {
		// Check to see if the algorithm has started
		if (cGeneticAlgorithm->Started()) {
			// Epoch
			cGeneticAlgorithm->Epoch();
		} else {
			// Render a clean line
			cout << "----------------------------------------------------------------------------------" << endl;
			// Render the Generation count
			cout << "Generations:  " << cGeneticAlgorithm->Generation() << endl;
			// Render the fittest genome
			cout << "Fittest Genome:  " << cGeneticAlgorithm->GetFittest() << endl;
			// Render a clean line
			cout << "----------------------------------------------------------------------------------" << endl;
			// Set the done boolean
			bDone = true;
		}
	}
	// Return
	return 0;
}