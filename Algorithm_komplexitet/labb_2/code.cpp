#include <bits/stdc++.h>
using namespace std;

int main(void) {
    int v, e, m;
    cin >> v >> e >> m;
    vector <bool> vertice(v+1, false);
    vector <pair <int, int> > edges;

    for (int i=0; i<e; i++) {
        int a, b;
        cin >> a >> b;
        vertice[a] = true;
        vertice[b] = true;
        edges.push_back(make_pair(a, b));
    }

    // for(int i=0; i<e; i++) {
    //     cout << edges[i].first << " " << edges[i].second << endl;
    // }

    vector <int> dec(v+1, 0);
    int vt = v;
    for (int i=1; i<=v; i++) {
        if(!vertice[i]) {
            vt--;
            for(int j=i; j<=v; j++) {
                dec[j]++;
            }
        }
    }
    v = vt;
    
    for(int i=0; i<e; i++) {
        edges[i].first  -= dec[edges[i].first ];
        edges[i].second -= dec[edges[i].second];	
    }
    
    int n = v+3, s = e+2, k = m+3;
    if (k > n) k = n;

    cout << n << endl << s << endl << k << endl;
    cout << "1 1\n1 2\n1 3\n";

    for(int i=3; i<n; i++) {
        cout << m;
        for(int j=4; j<=k; j++) {
            cout << " " << j;
        }
        cout << endl;
    }

    cout << "2 1 3\n2 2 3\n";

    for(int i=0; i<e; i++) {
    	cout << "2 " << edges[i].first+3 << " " << edges[i].second+3 << endl;
    }
    
    return 0;
}
