using Gtk;
using lirab;

public class crationFenster {
	private Builder builder = new Builder.from_file("lirab.ui");
	public Window window4;
	private Button button7;
	private Button button8;
	private Button button9;
	private Button button10;
	private Gtk.ListStore liststore3;
	private TreeView treeview2;
	
	public crationFenster(){	
	//Hauptfenster zusammenbauen
        builder.connect_signals (this);
		window4 = builder.get_object ("window4") as Window;
		button7 = builder.get_object ("button7") as Button;
		button8 = builder.get_object ("button8") as Button;
		button9 = builder.get_object ("button9") as Button;
		button10 = builder.get_object ("button10") as Button;
		treeview2 = builder.get_object ("treeview2") as TreeView;
		liststore3 = builder.get_object ("liststore3") as Gtk.ListStore;
		
		//Ereignisse verbinden
		this.window4.destroy.connect (Gtk.main_quit);
		button7.clicked.connect(rationLaden);
		button8.clicked.connect(rationNeu);
		button9.clicked.connect(rationBearbeiten);
		button10.clicked.connect(rationLoeschen);
	}

	public void rationenLesen(){
	//Namen von Rationen lesen und in Listbox eintragen
		liststore3.clear();
		foreach(string r in lirabDb.rationenLesen()){
			liststore3.insert_with_values(null, -1, 0, 0, 1, r, -1);
		}
		
	}
	public void rationNeu(){
	//Ration anlegen
		rationEdit = new crationEdit();
		
		ration r = rationEdit.rationErzeugen();
		lirabDb.rationHinzufuegen(r);
		this.rationenLesen();
	}

	public void rationBearbeiten(){
	//Ration bearbeiten Fenster öffnen
		rationEdit = new crationEdit();
		
		ration r = rationEdit.rationBearbeiten(lirabDb.rationLesen(getTreeViewName(rationFenster.treeview2)));
		lirabDb.rationSpeichern(r);
	}

	public void rationLoeschen(){
    //Ration löschen
		string ration = "";
        ration = getTreeViewName(rationFenster.treeview2);
        Dialog dialog = new Dialog.with_buttons("Frage",
                                                    hauptFenster.window1,Gtk.DialogFlags.MODAL,
                                                    "Abbrechen", Gtk.ResponseType.CANCEL,
                                                    "Ok", Gtk.ResponseType.OK, null);
        dialog.get_content_area().add(new Label("Ration wirklich Löschen? \nAlle Daten gehen verloren\n"));          
		dialog.set_decorated(true);
        dialog.show_all();
        
        if (dialog.run() == Gtk.ResponseType.OK) {
            lirabDb.rationEntfernen(ration);
            rationFenster.rationenLesen();       
            dialog.close();
        }else{dialog.close();}
	}
	
	
	public void rationLaden(){
    //Ration laden
		hauptFenster.rationLaden(getTreeViewName(rationFenster.treeview2));
		rationFenster.window4.hide();
	}
}

