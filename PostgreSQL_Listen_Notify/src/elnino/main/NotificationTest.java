package elnino.main;
import java.sql.Connection;
import java.sql.DriverManager;

public class NotificationTest {

	public static void main(String args[]) throws Exception {
		Class.forName("org.postgresql.Driver");
		String url = "jdbc:postgresql://localhost:5432/test";

		
		// Create two distinct connections, one for the notifier
		// and another for the listener to show the communication
		// works across connections although this example would
		// work fine with just one connection.
		
		Connection lConn = DriverManager.getConnection(url,"postgres","postgres123");
		Connection nConn = DriverManager.getConnection(url,"postgres","postgres123");

		// Create two threads, one to issue notifications and
		// the other to receive them.
		Listener listener = new Listener(lConn);
		Notifier notifier = new Notifier(nConn);
		listener.start();
		notifier.start();
		
	}

}

