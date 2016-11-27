using Gtk;
using lirab;

public class crationFenster {
	private Builder builder = new Builder();
	public Window window4;
	public Window window2;
	private Button button5;
	private Button button7;
	private Button button8;
	private Button button9;
	private Button button10;
	private Entry entry1;
	private ComboBoxText comboboxtext1;
	private ListStore liststore3;
	private TreeView treeview2;
	private Grid grid14;
 	private	bedarf[] b = {};
	
	public crationFenster(){	
	//Hauptfenster zusammenbauen
		builder.add_from_file ("lirab.ui");
        builder.connect_signals (this);
		window2 = builder.get_object ("window2") as Window;
		window4 = builder.get_object ("window4") as Window;
		button5 = builder.get_object ("button5") as Button;
		button7 = builder.get_object ("button7") as Button;
		button8 = builder.get_object ("button8") as Button;
		button9 = builder.get_object ("button9") as Button;
		button10 = builder.get_object ("button10") as Button;
		entry1 = builder.get_object ("entry1") as Entry;
		treeview2 = builder.get_object ("treeview2") as TreeView;
		comboboxtext1 = builder.get_object ("comboboxtext1") as ComboBoxText;
		grid14 = builder.get_object ("grid14") as Grid;
		liststore3 = builder.get_object ("liststore3") as ListStore;
		this.window4.destroy.connect (Gtk.main_quit);
		
		//Ereignisse verbinden
		button5.clicked.connect(rationAnlegen);
		button7.clicked.connect(rationLaden);
		button8.clicked.connect(rationBauen);
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
	
	public void rationAnlegen(){
	//Neue leere Ration in Datenbank anlegen
        ration rat = ration();
        mittel[] m = {mittel()};
        double[] d = {0};

		rat.id = -1;
		rat.name = rationFenster.entry1.get_text();
		rat.art = rationFenster.comboboxtext1.get_active_text();
		
		rat.grundKomponenten = m;
		rat.kraftKomponenten = m;
		m.resize(0);
		m += new bedarf(rat.name, 0).tierBedarf;
		m[0].art = rat.art;
		m[0].menge = aktRation.tiere;
		foreach (bedarf be in rationFenster.b){
			be.tierBedarf.art = "Bedarf";
			m += be.tierBedarf;
		}
		rat.tierBedarf = m;
		lirabDb.rationHinzufuegen(rat);
		aktRation = rat;
		rationFenster.rationenLesen();
		rationFenster.window2.hide();
	}

	public void rationBauen(){
	//Fenster zum Ration anlegen bauen und anzeigen
        rationFenster.entry1.set_editable(true);
        rationFenster.entry1.set_text("");
        rationFenster.comboboxtext1.set_active(0);
		foreach (bedarf be in rationFenster.b){
			be.destroy();
		}
		rationFenster.b.length = 0;
		rationFenster.b += new bedarf("Bedarf zur Erhaltung", rationFenster.b.length);
		rationFenster.grid14.add(rationFenster.b[rationFenster.b.length - 1]);
		rationFenster.grid14.add(new HSeparator());
		rationFenster.b += new bedarf("Bedarf je Liter Milch", rationFenster.b.length);
		rationFenster.grid14.add(rationFenster.b[rationFenster.b.length - 1]);
		rationFenster.grid14.show_all();
		rationFenster.window2.show();
	}
	
	public void rationLoeschen(){
    //Ration löschen
		string ration = "";
        ration = getTreeViewName(rationFenster.treeview2);
        Dialog dialog = new Dialog.with_buttons("Frage",
                                                    hauptFenster.window1,Gtk.DialogFlags.MODAL,
                                                    Gtk.Stock.CANCEL, Gtk.ResponseType.CANCEL,
                                                    Gtk.Stock.OK, Gtk.ResponseType.OK);
        dialog.get_content_area().add(new Label("Ration wirklich Löschen? \nAlle Daten gehen verloren\n"));          
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

	public void rationBearbeiten(){
	//Fenster zum Ration bearbeiten bauen und anzeigen
		int i = 0;
		Entry entry;
		string name = "";
        ration rat;
		//Fenster bauen
		rationFenster.rationBauen();
        //Werte setzen
        name = getTreeViewName(rationFenster.treeview2);
        rat = lirabDb.rationLesen(name);
        rationFenster.entry1.set_editable(false);
        rationFenster.entry1.set_text(rat.name);
        entry = rationFenster.comboboxtext1.get_child() as Entry;
        entry.set_text(rat.art);
        foreach (mittel be in rat.tierBedarf){
	        rationFenster.b[i].spinbutton1.set_value(be.XP);
	        rationFenster.b[i].spinbutton2.set_value(be.nXP);
	        rationFenster.b[i].spinbutton3.set_value(be.NEL);
	        i += 1;
		}
	}

}

