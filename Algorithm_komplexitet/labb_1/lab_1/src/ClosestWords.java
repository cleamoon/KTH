/* Labb 2 i DD1352 Algoritmer, datastrukturer och komplexitet    */
/* Se labbanvisning under kurssidan http://www.csc.kth.se/DD1352 */
/* Ursprunglig författare: Viggo Kann KTH viggo@nada.kth.se      */
import java.util.LinkedList;
import java.util.List;

public class ClosestWords {
  LinkedList<String> closestWords = new LinkedList<String>();
  int[][] M =  new int [42][42];
  int closestDistance = -1;

  int partDist(String w1, String w2, int w1len, int w2len) {
    if (w1len == 0)
      return w2len;
    if (w2len == 0)
      return w1len;
    int res = partDist(w1, w2, w1len - 1, w2len - 1) + 
	(w1.charAt(w1len - 1) == w2.charAt(w2len - 1) ? 0 : 1);
    int addLetter = partDist(w1, w2, w1len - 1, w2len) + 1;
    if (addLetter < res)
      res = addLetter;
    int deleteLetter = partDist(w1, w2, w1len, w2len - 1) + 1;
    if (deleteLetter < res)
      res = deleteLetter;
    return res;
  }
  
  int partDist2(String w1, String w2, int l1, int l2) {
	  for(int i = 1; i<=l1; i++) 
	  	for(int j = 1; j<=l2; j++) {
	  		int a = M[i-1][j-1] + (w1.charAt(i - 1) == w2.charAt(j - 1) ? 0 : 1); 
	  		int b = M[i-1][j] + 1;
	  		int c = M[i][j-1] + 1;
	  		/*
	  		if(a>=b) 
	  			if(b>=c) M[i][j] = c;
	  			else M[i][j] = b;
	  		else 
	  			if(a>=c) M[i][j] = c;
	  			else M[i][j] = a;
	  			*/
	  		M[i][j] = Math.min(a, Math.min(b, c));
	  	}
	  return M[l1][l2];
  }

  int Distance(String w1, String w2) {
	  // return partDist(w1, w2, w1.length(), w2.length());
	  return partDist2(w1, w2, w1.length(), w2.length());
  }

  public ClosestWords(String w, List<String> wordList) {
	/*  
	for(int x=0; x<5; x++) {
		for(int y=0; y<5; y++) {
			System.out.print("x: " + x + " y: " + y + " = " + partDist2("labd", "blad", x, y) + '\n'); 
		}
	}
	*/
  	String w1 = w, prev = "", w2;
  	int l1 = w.length(), l2, i, j, a, b, c;
  	//for(i = 0; i<50; i++) M[i][0]=i;
  	//for(j = 0; j<50; j++) M[0][j]=j;

	for(i = 0; i<42; i++) M[i][0]=i;
	for(j = 0; j<42; j++) M[0][j]=j;
    for (String s : wordList) {
    	if(Math.abs(s.length()-w.length()) <= closestDistance || closestDistance == -1) {
    		int p = 0;
    		while(p<s.length() && p<prev.length()) {
    			if(s.charAt(p) != prev.charAt(p)) break;
    			p++;
    		}
	      //int dist = Distance(w, s);
	      //w2 = s;
    		p++;
	      l2 = s.length();
	  	  for(i = 1; i<=l1; i++) { 
	  	  	for(j = p; j<=l2; j++) {
	  	  		a = M[i-1][j-1] + (w.charAt(i - 1) == s.charAt(j - 1) ? 0 : 1); 
	  	  		b = M[i-1][j]+1;
	  	  		c = M[i][j-1]+1;
	  	  		if(a>=b) 
	  	  			if(b>=c) M[i][j] = c;
	  	  			else M[i][j] = b;
	  	  		else 
	  	  			if(a>=c) M[i][j] = c;
	  	  			else M[i][j] = a;
	  	  	}
	  	  }
	  	  int dist = M[l1][l2]; 
	      // System.out.println("d(" + w + "," + s + ")=" + dist);
	      if (dist < closestDistance || closestDistance == -1) {
	        closestDistance = dist;
	        closestWords.clear();
	        closestWords.add(s);
	      }
	      else if (dist == closestDistance)
	        closestWords.add(s);
	    	prev = s;
	    }
    }
  }

  int getMinDistance() {
    return closestDistance;
  }

  List<String> getClosestWords() {
    return closestWords;
  }
}
