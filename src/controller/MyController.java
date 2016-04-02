package controller;

import java.net.URL;
import java.sql.*;
import java.util.ResourceBundle;

import org.postgresql.ds.PGSimpleDataSource;

import javafx.beans.property.SimpleStringProperty;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.scene.control.TableColumn.CellDataFeatures;
import javafx.util.Callback;

import java.sql.Connection;
import java.sql.ResultSet;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;

public class MyController implements Initializable {

	@Override
	public void initialize(URL location, ResourceBundle resources) {
		// TODO Auto-generated method stub
		
	}
	
	@SuppressWarnings("rawtypes")
	private ObservableList<ObservableList> data;
	
	@FXML
	private Label label;
	@FXML
	private Button loadData;
	@FXML
	private ProgressIndicator progress;
	@FXML
	private Tab gamerTableTab, updateTableTab;
	@FXML
	private TableView gamerTableView, updateTableView;
	@FXML
	private TextField dbIP, dbName, dbUser, dbPass, inputNumber;
	
	private PGSimpleDataSource ds;
	
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void handleButtonAction(ActionEvent event){
		System.err.println("Connecting to database...");
		
		data = FXCollections.observableArrayList();
		
		// Datenquelle erzeugen und konfigurieren
		ds = new PGSimpleDataSource();
		/*ds.setServerName("192.168.0.23");
		ds.setDatabaseName("schokofabrik");
		ds.setUser("schokouser");
		ds.setPassword("schokoUser");*/
		ds.setServerName(dbIP.getText());
		ds.setDatabaseName(dbName.getText());
		ds.setUser(dbUser.getText());
		ds.setPassword(dbPass.getText());
		// Verbindung herstellen
		try(
			Connection con = ds.getConnection();
			// Abfrage vorbereiten und ausführen
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("select * from produkt");
			){
			
			label.setText("connected!");
			gamerTableTab.setDisable(false);
			updateTableTab.setDisable(false);
			progress.setProgress(100);
			
			
			
			for(int i=0 ; i<rs.getMetaData().getColumnCount(); i++){
                //We are using non property style for making dynamic table
                final int j = i;
				TableColumn col = new TableColumn(rs.getMetaData().getColumnName(i+1));
                col.setCellValueFactory(new Callback<CellDataFeatures<ObservableList,String>,ObservableValue<String>>(){                    
                    public ObservableValue<String> call(CellDataFeatures<ObservableList, String> param) {                                                                                              
                        return new SimpleStringProperty(param.getValue().get(j).toString());                        
                    }                    
                });

                gamerTableView.getColumns().addAll(col); 
                System.out.println("Column ["+i+"] ");
            }
			
			
			
			// Ergebnisse verarbeiten
			while (rs.next()) { // Cursor bewegen
				ObservableList<String> row = FXCollections.observableArrayList();
                for(int i=1 ; i<=rs.getMetaData().getColumnCount(); i++){
                    //Iterate Column
                    row.add(rs.getString(i));
                }
                System.out.println("Row [1] added "+row );
                data.add(row);
			}
			
			//adding data to tableView
			gamerTableView.setItems(data);
			
		}catch (SQLException se){
			System.err.println("Error");
			label.setText("Error");
			se.printStackTrace(System.err);
		}
	}
	
	@FXML
	public void updateButton(ActionEvent event){
		
		String input = inputNumber.getText();
		
		if(CheckString(input)){
			updateRow(Integer.parseInt(input));
			
		} else {
			inputNumber.setText("Enter number!");
		}
		
	}
	
	private void updateRow(int index){
		data = null;
		data = FXCollections.observableArrayList();
		
		try(
			Connection con = ds.getConnection();
			// Abfrage vorbereiten und ausführen
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("select * from produkt where nummer="+index);
			){
			
			
			for(int i=0 ; i<rs.getMetaData().getColumnCount(); i++){
                //We are using non property style for making dynamic table
                final int j = i;
				TableColumn col = new TableColumn(rs.getMetaData().getColumnName(i+1));
                col.setCellValueFactory(new Callback<CellDataFeatures<ObservableList,String>,ObservableValue<String>>(){                    
                    public ObservableValue<String> call(CellDataFeatures<ObservableList, String> param) {                                                                                              
                        return new SimpleStringProperty(param.getValue().get(j).toString());                        
                    }                    
                });

                updateTableView.getColumns().addAll(col); 
                System.out.println("Column ["+i+"] ");
            }
			
			
			
			// Ergebnisse verarbeiten
			while (rs.next()) { // Cursor bewegen
				ObservableList<String> row = FXCollections.observableArrayList();
                for(int i=1 ; i<=rs.getMetaData().getColumnCount(); i++){
                    //Iterate Column
                    row.add(rs.getString(i));
                }
                System.out.println("Row [1] added "+row );
                data.add(row);
			}
			
			//adding data to tableView
			updateTableView.setItems(data);
			
		}catch (SQLException se){
			System.err.println("Error");
			label.setText("Error");
			se.printStackTrace(System.err);
		}
	}
	
	public static boolean CheckString(String str) {
	    for (char c : str.toCharArray()) {
	        if (!Character.isDigit(c))
	            return false;
	    }
	    return true;
	}
}
