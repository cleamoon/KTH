#include <bits/stdc++.h>
using namespace std;

int main () {
    ofstream testFile;
    testFile.open ("input.txt");
    int N = 1024;
    testFile << N << endl;
    for (int i=0; i<N; i++) {
	double x = (10.0 * (double) i/(double) N);
	testFile << sin(x) << endl;
    }
    testFile.close();
    return 0;
}
      
