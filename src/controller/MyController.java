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
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.input.MouseEvent;

public class MyController implements Initializable {

	@Override
	public void initialize(URL location, ResourceBundle resources) {
		// not much to do here...
	}
	
	@SuppressWarnings("rawtypes")
	private ObservableList<ObservableList> data;
	
	@FXML
	private Label label, insertLabel;
	@FXML
	private Button loadData, chooseButton, updateButton, disconnect;
	@FXML
	private ProgressIndicator progress;
	@FXML
	private Tab gamerTableTab, insertTableTab;
	@SuppressWarnings("rawtypes")
	@FXML
	private TableView gamerTableView, updateTableView;
	@FXML
	private TextField dbIP, dbName, dbUser, dbPass, inputNumber, nummerTF, bezeichnungTF, gewichtTF;
	@FXML
	private TextField nummerTFI, bezeichnungTFI, gewichtTFI;
	
	private PGSimpleDataSource dataSource;
	private String[] inarr;
	private Connection connection;
	private Statement statement;
	
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void handleButtonAction(ActionEvent event){
		System.out.println("Connecting to database...");
		
		data = FXCollections.observableArrayList();
		
		// Datenquelle erzeugen und konfigurieren
		dataSource = new PGSimpleDataSource();
		dataSource.setServerName(dbIP.getText());
		dataSource.setDatabaseName(dbName.getText());
		dataSource.setUser(dbUser.getText());
		dataSource.setPassword(dbPass.getText());
		// Verbindung herstellen
		try{
			connection = dataSource.getConnection();
			// Abfrage vorbereiten und ausführen
			statement = connection.createStatement();
			ResultSet rs = statement.executeQuery("select * from produkt");
			

			label.setText("connected!");
			System.out.println("successfully connected!");
			gamerTableTab.setDisable(false);
			insertTableTab.setDisable(false);
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
            }
			
			// Ergebnisse verarbeiten
			while (rs.next()) { // Cursor bewegen
				ObservableList<String> row = FXCollections.observableArrayList();
                for(int i=1 ; i<=rs.getMetaData().getColumnCount(); i++){
                    //Iterate Column
                    row.add(rs.getString(i));
                    
                }
                data.add(row);
			}
			
			gamerTableView.setItems(data);
			
			loadData.setDisable(true);
			disconnect.setDisable(false);
			
		} catch (org.postgresql.util.PSQLException e){
			System.err.println("Error");
			label.setText("Error");
			e.printStackTrace(System.err);
		} catch (SQLException se){
			System.err.println("Error");
			label.setText("Error");
			se.printStackTrace(System.err);
		} 
	}
	
	@FXML
	public void updateClicked(ActionEvent event) throws SQLException{
		
		try{
			Statement statement = connection.createStatement();
			
			connection.setAutoCommit(false);
			
			statement.executeUpdate("UPDATE produkt SET bezeichnung=\'"+bezeichnungTF.getText()+"\', gewicht=\'"+gewichtTF.getText()+"\' WHERE nummer=\'"+inarr[0]+"\'");
			
			connection.commit();
			
			System.out.println("Update successful");
			
			updateTableClicked(null);
			
		} catch (SQLException se){
			connection.rollback();
			System.err.println("Update Error");
			se.printStackTrace(System.err);
		} finally {
			if (statement != null) {
				statement.close();
			}
		}
		
	}
	
	@FXML
	public void updateTableClicked(ActionEvent event){
		
		gamerTableView.getColumns().clear();
		
		data.clear();
		data = FXCollections.observableArrayList();
		
		handleButtonAction(null);
		
	}
	
	@FXML
	public void disconnectPressed(ActionEvent event){
		
		try {
			connection.close();
			
			label.setText("not connected");
			gamerTableTab.setDisable(true);
			insertTableTab.setDisable(true);
			progress.setProgress(0);
			loadData.setDisable(false);
			disconnect.setDisable(true);
			
			System.out.println("Disconnected");
			
		} catch (SQLException e) {
			System.err.println("Connection could not be closed!");
			label.setText("Error");
			e.printStackTrace();
		}
		
	}
	
	@FXML
	public void insertClicked(ActionEvent event) throws SQLException{
		
		if(nummerTFI.getText().matches("^-?\\d+$") && gewichtTFI.getText().matches("^-?\\d+$")){
			
			int num = Integer.parseInt(nummerTFI.getText());
			int gew = Integer.parseInt(gewichtTFI.getText());
			String bez = bezeichnungTFI.getText();
			
			try {
				
				connection.setAutoCommit(false);
				statement.executeUpdate("INSERT INTO produkt VALUES ("+ num +", '"+ bez +"', '"+ gew +"')");
				connection.commit();
				
				System.out.println("Insert successful!");
				insertLabel.setText("Insert successful");
				
			} catch (SQLException e) {
				
				connection.close();
				insertLabel.setText("Insert error!");
				System.err.println("Insert error!");
				e.printStackTrace();
				
			} finally {
				if (statement != null) {
					statement.close();
				}
			}
			
		} else {
			insertLabel.setText("ERROR: check your input! nummer and gewicht have to be integer!");
		}
		
	}
	
	@FXML
	public void onMouseClicked(MouseEvent event){
		
		@SuppressWarnings("rawtypes")
		TablePosition focusedCell = gamerTableView.getFocusModel().getFocusedCell();
        int row = focusedCell.getRow();
		
		String input = data.get(row)+"";
		
		input = input.substring(1,input.length()-1);
		
		inarr = input.split(", ");
		
		updateButton.setDisable(false);
		
		nummerTF.setText(inarr[0]);
		bezeichnungTF.setText(inarr[1]);
		gewichtTF.setText(inarr[2]);
		
		bezeichnungTF.setDisable(false);
		gewichtTF.setDisable(false);

	}
}
