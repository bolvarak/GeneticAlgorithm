// Application Definitions
#ifndef GENETICALGORITHM_H
	#define GENETICALGORITHM_H
	// Application Headers
	#include <vector>
	#include <sstream>
	#include "Definitions.h"
	#include "GeneticAlgorithmMap.h"
	#include "Utilities.h"
	// Namespace Definition
	using namespace std;
	// Genome structure
	struct Genome {
		vector<int> vBits;
		double      dFitness;
		// Fitness structure definition
		Genome():dFitness(0){}
		// Genome constructor definition
		Genome(const int iNumberOfBits):dFitness(0) {
			// Create a random bit string
			for (int iBit = 0; iBit < iNumberOfBits; ++iBit) {
				// Append the bit
				vBits.push_back(RandomInteger(0, 1));
			}
		}
	};
	// Genetic Algorithm Class Definition
	class GeneticAlgorithm {
	// Private Properties
	private:
		vector<Genome>      mGenomes;
		int                 mPopulationSize;
		double              mCrossoverRate;
		double              mMutationRate;
		int                 mChromosomeLength;
		int                 mGeneLength;
		int                 mFittestGenome;
		double              mBestFitnessScore;
		double              mTotalFitnessScore;
		int                 mGeneration;
		GeneticAlgorithmMap mMap;
		GeneticAlgorithmMap mBrain;
		bool                mBusy;
		// Binary to Integer Conversion Definition
		int BinaryToInteger(const vector<int> &vBinary);
		// Decoding Definition
		vector<int> Decode(const vector<int> &vEncodedBits);
		// Population Creation Definition
		void CreatePopulation();
		// Crossover Definition
		void Crossover(const vector<int> &vMother, const vector<int> &vFather, vector<int> &vOffspringAlpha, vector<int> &vOffspringBeta);
		// Mutation Definition
		void Mutate(vector<int> &vBits);
		// Selection Definition
		Genome& Selection();
		// Update Fitness Score Definition
		void UpdateFitnessScores();
	// Public Properties
	public:
		// Epoch Definition
		void Epoch();
		// Execution Definition
		void Execute();
		// Accessor Method Definitions
		int Generation() {
			// Return the current generation
			return mGeneration;
		}
		// GeneticAlgorithm Constructor Definition
		GeneticAlgorithm(double dCrossoverRate, double dMutationRate, int iPopulationSize, int iNumberOfBits, int iGeneLength);
		int GetFittest() {
			// Return the fittest genome
			return mFittestGenome;
		}
		bool Started() {
			// Return the busy state
			return mBusy;
		}
		// Algorithm Destructor Definition
		void Stop() {
			// Stop the algorithm
			mBusy = false;
		}
	};
#endif
