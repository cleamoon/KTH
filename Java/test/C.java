public class C extends Thread {
	static int a = 0;
	public static void main(String[]Args) throws Exception {
		C MyC = new C();
		 MyC.start();
		 MyC.sleep(1);
		 System.out.println(a);
		 MyC.join();
		 System.out.println(a);
		 //runLoop(1000000);
		 System.out.println(a);
	}
	public static void runLoop(int b) {
		for (int i = 0; i < b; i++) {
			a = i;
		}
	} 
	public void run() {
		runLoop(12345678);
	}
}