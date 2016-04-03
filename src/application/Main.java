package application;
	
import javafx.application.Application;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.stage.Stage;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Label;

import java.sql.*;
import org.postgresql.ds.PGSimpleDataSource;


public class Main extends Application {
	
	
	@Override
	public void start(Stage primaryStage) {
		try {
			Parent root = FXMLLoader.load(getClass().getResource("/application/MyView.fxml"));
			Scene scene = new Scene(root);
			scene.getStylesheets().add(getClass().getResource("application.css").toExternalForm());
			primaryStage.setScene(scene);
			primaryStage.setTitle("Schokofabrik Reader");
			primaryStage.show();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args) {
		/*
		// Datenquelle erzeugen und konfigurieren
		PGSimpleDataSource ds = new PGSimpleDataSource();
		ds.setServerName("192.168.0.23");
		ds.setDatabaseName("schokofabrik");
		ds.setUser("schokouser");
		ds.setPassword("schokoUser");
		// Verbindung herstellen
		try(
			Connection con = ds.getConnection();
			// Abfrage vorbereiten und ausführen
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("select * from produkt");
			){
			 
			Array data = rs.getArray(0);
			
			// Ergebnisse verarbeiten
			while (rs.next()) { // Cursor bewegen
				String wert = rs.getString(2);
				System.out.println(wert);
			}
			
		}catch (SQLException se){
			System.err.println("Error");
			se.printStackTrace(System.err);
		}*/
		
		launch(args);
	}
}
