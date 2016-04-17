package controller;

import java.net.URL;
import java.sql.*;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ResourceBundle;
import org.postgresql.ds.PGSimpleDataSource;
import org.postgresql.util.PSQLException;
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

	@SuppressWarnings("rawtypes")
	private ObservableList<ObservableList> data;
	@SuppressWarnings("rawtypes")
	private ObservableList<ObservableList> spieler;
	@SuppressWarnings("rawtypes")
	private ObservableList<ObservableList> spiel;
	private PGSimpleDataSource dataSource;
	private String[] inarr;
	private Connection connection;

	@FXML
	private Label label, insertLabel;
	@FXML
	private DatePicker bisDate, vonDate;
	@FXML
	private DatePicker datePick;
	@FXML
	private Button spielerUpdateButton, loadData, updateButton, disconnect, updateTable, insertButton;
	@FXML
	private ProgressIndicator progress;
	@FXML
	private Tab outputTableTab, insertTableTab, spielerTableTab;
	@SuppressWarnings("rawtypes")
	@FXML
	private TableView gamerTableView, updateTableView, spielerTableView;
	@FXML
	private TextField gehaltTF, persnrTF, dbIP, dbName, dbUser, dbPass, timeTF, nummerTF, mannschaftTF, gegnerTF, mannschaftTFI, gegnerTFI;
	@SuppressWarnings("rawtypes")
	@FXML
	private ComboBox positionCB, ergebnisCB, standCB;

	/**
	 * handleButtonAction will be executed, when the "connect" button in the
	 * "connect to database" is pressed. It tries to connect to a database by
	 * using the given parameters. In case they're working, the main select
	 * statement will be executed
	 * 
	 * @param event
	 *            ActionEvent generated by the click event
	 */
	@SuppressWarnings("unchecked")
	public void handleButtonAction(ActionEvent event) {

		label.setText("Laden...");
		System.out.println("Connecting to database...");

		data = FXCollections.observableArrayList();

		// data source configuration
		dataSource = new PGSimpleDataSource();
		dataSource.setServerName(dbIP.getText());
		dataSource.setDatabaseName(dbName.getText());
		dataSource.setUser(dbUser.getText());
		dataSource.setPassword(dbPass.getText());

		// building up the connection to the database
		try {
			connection = dataSource.getConnection();

			System.out.println("successfully connected!");

			// save needed options for the comboboxes in a ObservableList, which
			// can be inserted into the ComboBoxes
			ObservableList<String> stand = FXCollections.observableArrayList("Sieg", "Unentschieden", "Niederlage");

			ergebnisCB.setItems(stand);
			standCB.setItems(stand);

			ObservableList<String> position = FXCollections.observableArrayList("torwart", "innenverteidiger",
					"aussenverteidiger", "defensiver mittelfeldspieler", "offensiver mittelfeldspieler",
					"fluegelspieler", "stuermer");

			positionCB.setItems(position);

			// the static tableViews are saved in an seperate attribute, so it
			// has not to be created, with every clickOnTable action
			spiel = getTable("SELECT * FROM spiel", gamerTableView);
			spieler = getTable("SELECT * FROM spieler", spielerTableView);

			// put the gotten data into the tableViews
			gamerTableView.setItems(getTable("select * from spiel", gamerTableView));
			spielerTableView.setItems(getTable("select * from spieler", spielerTableView));

			updateTableClicked(null);
			connection.commit();

			label.setText("Verbunden!");

			// error handling with error messages
		} catch (PSQLException e) {
			System.err.println("PSQL Error");
			label.setText("SQL Error");
			e.printStackTrace(System.err);
		} catch (SQLException se) {
			System.err.println("SQL Error");
			label.setText("SQL Error");
			se.printStackTrace(System.err);
		}
	}

	/**
	 * getTable adds all needed data to the tableView if executed
	 * 
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ObservableList<ObservableList> getTable(String statement, TableView tableView) throws SQLException {

		ObservableList<ObservableList> table = FXCollections.observableArrayList();

		try {
			connection = dataSource.getConnection();
			// prepare statement and execute it
			Statement st = connection.createStatement();
			connection.setAutoCommit(false);
			ResultSet rs = st.executeQuery(statement);
			outputTableTab.setDisable(false);
			spielerTableTab.setDisable(false);
			insertTableTab.setDisable(false);
			progress.setProgress(100);

			for (int i = 0; i < rs.getMetaData().getColumnCount(); i++) {
				final int j = i;
				TableColumn col = new TableColumn(rs.getMetaData().getColumnName(i + 1));
				col.setCellValueFactory(
						new Callback<CellDataFeatures<ObservableList, String>, ObservableValue<String>>() {
							public ObservableValue<String> call(CellDataFeatures<ObservableList, String> param) {
								return new SimpleStringProperty(param.getValue().get(j).toString());
							}
						});

				tableView.getColumns().addAll(col);

			}

			// process results
			while (rs.next()) { // Cursor bewegen
				ObservableList<String> row = FXCollections.observableArrayList();
				for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++) {
					// Iterate Column
					row.add(rs.getString(i));

				}

				table.add(row);
			}

			// after the successful connection construction, the connect button
			// will (logically) disabled
			// and the disconnect button enabled
			loadData.setDisable(true);
			disconnect.setDisable(false);

		} catch (PSQLException se) {
			connection.rollback();
			System.err.println("Error");

		} catch (Exception se) {
			connection.rollback();
			System.err.println("Error");

		}
		return table;
	}

	/**
	 * updateClicked will be executed, if the "update" button for the row update
	 * is pressed. It takes the given parameters and puts them into a SQL
	 * statement, which is protected by a transaction.
	 * 
	 * @param event
	 *            ActionEvent generated by the click event
	 * @throws SQLException
	 *             could throw a SQLException, caused by the rollback() method
	 */
	@FXML
	public void updateClicked(ActionEvent event) throws SQLException {

		try {
			// get all the data from the textfields and combobox to insert it
			// into the prepared statement
			String num = nummerTF.getText();
			String gew = gegnerTF.getText();
			String bez = mannschaftTF.getText();
			String stand = (String) standCB.getValue();

			String sql = "UPDATE spiel SET datum='" + num + "', bezeichnung=?, gegner=?, ergebnis=? WHERE datum='" + num
					+ "'";

			connection.setAutoCommit(false);

			PreparedStatement statement = connection.prepareStatement(sql);

			statement.setString(1, bez);
			statement.setString(2, gew);
			statement.setString(3, stand);

			statement.executeUpdate();

			connection.commit();

			System.out.println("Update successful");

			updateTableClicked(null);

		} catch (SQLException se) {
			// transaction rollback in case of an error with the SQL statement
			connection.rollback();
			System.err.println("Update Error");
			se.printStackTrace(System.err);
		}
	}
	
	/**
	 * updateClicked will be executed, if the "update" button for the row update
	 * is pressed. It takes the given parameters and puts them into a SQL
	 * statement, which is protected by a transaction.
	 * 
	 * @param event
	 *            ActionEvent generated by the click event
	 * @throws SQLException
	 *             could throw a SQLException, caused by the rollback() method
	 */
	@FXML
	public void spielerUpdateClicked(ActionEvent event) throws SQLException {

		try {
			if(gehaltTF.getText().matches("-?\\d+(\\.\\d+)?")){
				
				// get all the data from the textfields and combobox to insert it
				// into the prepared statement
				String persnr = persnrTF.getText();
				String pos = (String) positionCB.getValue();
				int gehalt = Integer.parseInt(gehaltTF.getText());
				String von = vonDate.getValue().toString();
				String bis = bisDate.getValue().toString();
				System.out.println(von);
	
				String sql = "UPDATE spieler SET persnr='" + persnr + "', position=?, gehalt=?, von='"+von+"', bis='"+bis+"' WHERE persnr='" + persnr
						+ "'";
	
				connection.setAutoCommit(false);
	
				PreparedStatement statement = connection.prepareStatement(sql);
	
				statement.setString(1, pos);
				statement.setInt(2, gehalt);
	
				statement.executeUpdate();
	
				connection.commit();
	
				System.out.println("Update successful");
	
				updateTableClicked(null);
			} else {
				System.err.println("enter numeric \"gehalt\"");
			}

		} catch (SQLException se) {
			// transaction rollback in case of an error with the SQL statement
			connection.rollback();
			System.err.println("Update Error");
			se.printStackTrace(System.err);
		}
	}

	/**
	 * updateTableClicked will be executed, when the upper "update" button for
	 * the tableView is pressed. Clears the whole tableView to add the latest
	 * data.
	 * 
	 * @param event
	 *            ActionEvent generated by the click event
	 * @throws SQLException 
	 */
	@SuppressWarnings("unchecked")
	@FXML
	public void updateTableClicked(ActionEvent event) throws SQLException {

		spiel = getTable("SELECT * FROM spiel", gamerTableView);
		spieler = getTable("SELECT * FROM spieler", spielerTableView);
		
		// clear all columns in the tableView to avoid duplication to columns
		gamerTableView.getColumns().clear();
		spielerTableView.getColumns().clear();

		data.clear();
		data = FXCollections.observableArrayList();

		// new data is inserted
		try {
			gamerTableView.setItems(getTable("select * from spiel", gamerTableView));
			data.clear();
			data = FXCollections.observableArrayList();
			spielerTableView.setItems(getTable("select * from spieler", spielerTableView));
		} catch (SQLException e) {
			System.err.println("ERROR occured");
		}
	}

	/**
	 * disconnectPressed 
	 * disconnect button pressed; tabs will be deactivated and
	 * the textfields reset for clean reuse. simple explained: the program will
	 * be "reseted"
	 * 
	 * @param event
	 *            ActionEvent generated by the click event
	 */
	@FXML
	public void disconnectPressed(ActionEvent event) {

		try {
			connection.close();

			label.setText("nicht verbunden");
			outputTableTab.setDisable(true);
			spielerTableTab.setDisable(true);
			insertTableTab.setDisable(true);
			progress.setProgress(0);
			loadData.setDisable(false);
			disconnect.setDisable(true);

			nummerTF.setText("");
			mannschaftTF.setText("");
			gegnerTF.setText("");

			updateButton.setDisable(true);

			System.out.println("Verbindung getrennt");

			// clear all columns in the tableView
			gamerTableView.getColumns().clear();

			data.clear();
			data = FXCollections.observableArrayList();

		} catch (SQLException e) {
			System.err.println("Connection could not be closed!");
			label.setText("Fehler!");
			e.printStackTrace();
		}

	}

	/**
	 * insertClicked 
	 * checks if the given input for the insert is valid. In this
	 * case, it will be inserted into the database.
	 * 
	 * @param event
	 *            ActionEvent generated by the click event
	 * @throws SQLException
	 *             could throw a SQLException, caused by the rollback() method
	 */
	@FXML
	public void insertButtonClicked(ActionEvent event) throws SQLException {

		try {
			
			Statement st = connection.createStatement();
			connection.setAutoCommit(false);

			String gegner = gegnerTFI.getText();
			String mannschaft = mannschaftTFI.getText();
			String timestamp = datePick.getValue() + " " + timeTF.getText();

			String sql = "INSERT INTO spiel VALUES('" + timestamp + "', ?, ?, ?)";

			connection.setAutoCommit(false);

			PreparedStatement statement = connection.prepareStatement(sql);

			statement.setString(1, mannschaft);
			statement.setString(2, gegner);
			statement.setString(3, (String) ergebnisCB.getValue());

			statement.executeUpdate();

			connection.commit();
			
		} catch (SQLException se) {
			connection.rollback();
			System.err.println("Update - Error");
			insertLabel.setText("SQL Error! Kontrolliere deine Eingabe");
			se.printStackTrace(System.err);
		}

	}

	/**
	 * onMouseClicked will be executed, if the user clicks inside the tableView
	 * on a cell. This method reads the data, which is inside the clicked row.
	 * 
	 * @param event
	 *            MouseEvent generated by the mouse event
	 * @throws SQLException
	 */
	@SuppressWarnings("unchecked")
	@FXML
	public void onMouseClicked(MouseEvent event) throws SQLException {

		// get the clicked row
		@SuppressWarnings("rawtypes")
		TablePosition focusedCell = gamerTableView.getFocusModel().getFocusedCell();
		int row = focusedCell.getRow();

		// get the data of this row
		String input = spiel.get(row) + "";

		// the [] of the string are removed
		input = input.substring(1, input.length() - 1);

		// split the string up at ", "
		inarr = input.split(", ");

		// enable the update button, to enable the user to click it, as now the
		// cell is chosen
		updateButton.setDisable(false);

		// the content of the chosen row is inserted into the textfields
		nummerTF.setText(inarr[0]);
		mannschaftTF.setText(inarr[1]);
		gegnerTF.setText(inarr[2]);
		standCB.setValue(inarr[3]);

		mannschaftTF.setDisable(false);
		standCB.setDisable(false);
		gegnerTF.setDisable(false);

	}

	/**
	 * changeDateFormat
	 * method to change the format of a given date, from american format or the opposite
	 * @param date
	 * @param america
	 * @return
	 */
	public String changeDateFormat(String date, boolean america) {

		if (!america) {
			// split the string up at "."
			String[] arr;
			arr = date.split(".");
			// return the well formed date
			return arr[2] + "-" + arr[1] + "-" + arr[0];
		} else {
			// split the string up at "-"
			String[] arr;
			arr = date.split("-");
			// return the well formed date
			return arr[2] + "." + arr[1] + "." + arr[0];
		}
	}

	/**
	 * onMouseClicked will be executed, if the user clicks inside the tableView
	 * on a cell. This method reads the data, which is inside the clicked row.
	 * 
	 * @param event
	 *            MouseEvent generated by the mouse event
	 * @throws SQLException
	 */
	@SuppressWarnings("unchecked")
	@FXML
	public void spielerOnMouseClicked(MouseEvent event) throws SQLException {

		// get the clicked row
		@SuppressWarnings("rawtypes")
		TablePosition focusedCell = spielerTableView.getFocusModel().getFocusedCell();
		int row = focusedCell.getRow();

		// get the data of this row
		String input = spieler.get(row) + "";

		// the [] of the string are removed
		input = input.substring(1, input.length() - 1);

		// split the string up at ", "
		inarr = input.split(", ");

		// enable the update button, to enable the user to click it, as now the
		// cell is chosen
		spielerUpdateButton.setDisable(false);

		// the content of the chosen row is inserted into the textfields
		persnrTF.setText(inarr[0]);
		positionCB.setValue(inarr[1]);
		gehaltTF.setText(inarr[2]);
		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		LocalDate date = LocalDate.parse(inarr[3], formatter);
		vonDate.setValue(date);
		
		date = LocalDate.parse(inarr[4], formatter);
		bisDate.setValue(date);

		positionCB.setDisable(false);
		gehaltTF.setDisable(false);
		vonDate.setDisable(false);
		bisDate.setDisable(false);

	}

	/**
	 * deleteClicked this method will be executed, when the delete button is
	 * pressed in the output tab. It will execute a delete SQL statment which
	 * deletes the selected row.
	 * 
	 * @param event
	 *            MouseEvent generated by the mouse event
	 * @throws SQLException
	 *             could throw a SQLException, caused by the rollback() method
	 */
	@FXML
	public void deleteClicked(ActionEvent event) throws SQLException {

		try {

			connection.setAutoCommit(false);

			String sql = "DELETE FROM produkt WHERE nummer=?";

			PreparedStatement statement = connection.prepareStatement(sql);

			statement.setInt(1, Integer.parseInt(inarr[0]));
			statement.executeUpdate();

			connection.commit();

			System.out.println("Loeschen erfolgreich");

			updateTableClicked(null);

			// disable the update button, to prevent the user to click it, as no
			// cell is selected
			updateButton.setDisable(true);

		} catch (SQLException se) {
			connection.setAutoCommit(false);
			// transaction rollback in case of an error with the SQL statement
			connection.rollback();
			System.err.println("Loesch Fehler");
			se.printStackTrace(System.err);
		}
	}

	/**
	 * initialize necessary method of Initializable
	 */
	@Override
	public void initialize(URL location, ResourceBundle resources) {
		// not much to do here...
	}
}
