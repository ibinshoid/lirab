using Gtk;
using lirab;

public class chauptFenster {
	private Builder builder = new Builder();
	public signal void readTreestore();
	public signal void saveTab();
	public Window window1;
	public TreeStore treestore1;
	private SpinButton spinbutton8;
	private Label label23;
	private Gtk.MenuItem menu4;
	public Notebook notebook1;
	private Paned paned1;
	private Grid grid11;
	private Grid grid15;
	private Grid grid16;
	private VBox vbox1;
	private VBox vbox5;
	private VBox vbox6;
	private VBox vbox11;
	
	public chauptFenster() {	
	//Hauptfenster zusammenbauen
		builder.add_from_file ("lirab.ui");
        builder.connect_signals (this);
		window1 = builder.get_object ("window1") as Window;
		paned1 = builder.get_object ("paned1") as Paned;
		spinbutton8 = builder.get_object ("spinbutton8") as SpinButton;
		label23 =  builder.get_object ("label23") as Label;
		menu4 =  builder.get_object ("imagemenuitem4") as Gtk.MenuItem;
		grid11 =  builder.get_object ("grid11") as Gtk.Grid;
		grid15 =  builder.get_object ("grid15") as Gtk.Grid;
		grid16 =  builder.get_object ("grid16") as Gtk.Grid;
		notebook1 = new Notebook();
		grid11.add(notebook1);
		treestore1 = builder.get_object ("treestore1") as TreeStore;
		vbox1 = builder.get_object ("vbox1") as VBox;
		vbox5 = builder.get_object ("vbox5") as VBox;
		vbox6 = builder.get_object ("vbox6") as VBox;
		vbox11 = builder.get_object ("vbox11") as VBox;
		//Ereignisse verbinden
		this.window1.destroy.connect (Gtk.main_quit);
		mittelFenster.anders.connect(mittelLesen);
	}
	
	
	public void editFuttermittel(){
		mittelFenster.window3.show_all();
	}
	
	public void mittelLesen(){
	// Liste mit Futtermitteln füllen
		TreeIter[] iter = new TreeIter[8]; 
		TreeIter iter2 =  TreeIter();	
		mittel[] Mittel = {};
		//treestore nicht direkt bearbeiten, weil sonst Absturz!
		TreeStore tmptreestore;
		tmptreestore = new TreeStore(6, typeof(int), typeof(string), typeof(double), typeof(double), typeof(double), typeof(double), typeof(double), -1);

		tmptreestore.append(out iter[0], null);
		tmptreestore.set(iter[0], 1, "Futter hinzufügen", -1);
		tmptreestore.append(out iter[0], null);
		tmptreestore.set(iter[0], 1, "Grünfutter", -1);
		tmptreestore.append(out iter[1], null);
		tmptreestore.set(iter[1], 1, "Silagen", -1);
		tmptreestore.append(out iter[2], null);
		tmptreestore.set(iter[2], 1, "Heu, Stroh", -1);
		tmptreestore.append(out iter[3], null);
		tmptreestore.set(iter[3], 1, "Getreide", -1);
		tmptreestore.append(out iter[4], null);
		tmptreestore.set(iter[4], 1, "Ölsaaten", -1);
		tmptreestore.append(out iter[5], null);
		tmptreestore.set(iter[5], 1, "Mischfutter", -1);
		tmptreestore.append(out iter[6], null);
		tmptreestore.set(iter[6], 1, "Mineralfutter", -1);
		tmptreestore.append(out iter[7], null);
		tmptreestore.set(iter[7], 1, "Sonstiges", -1);

		Mittel = lirabDb.mittelLesen();
		foreach (mittel m in Mittel){
			if (m.art == "Grünfutter"){
				tmptreestore.append(out iter2, iter[0]);
				tmptreestore.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}else if (m.art == "Silagen"){
				tmptreestore.append(out iter2, iter[1]);
				tmptreestore.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}else if (m.art == "Heu, Stroh"){
				tmptreestore.append(out iter2, iter[2]);
				tmptreestore.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}else if (m.art == "Getreide"){
				tmptreestore.append(out iter2, iter[3]);
				tmptreestore.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}else if (m.art == "Ölsaaten"){
				tmptreestore.append(out iter2, iter[4]);
				tmptreestore.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}else if (m.art == "Mischfutter"){
				tmptreestore.append(out iter2, iter[5]);
				tmptreestore.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}else if (m.art == "Mineralfutter"){
				tmptreestore.append(out iter2, iter[6]);
				tmptreestore.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}else if (m.art == "Sonstiges"){
				tmptreestore.append(out iter2, iter[7]);
				tmptreestore.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}
		}
		treestore = tmptreestore;
		readTreestore();
	}	
	
	public void rationenVerwalten(){
		rationFenster.window4.show_all();
	}

	public void rationBearbeiten(){
		crationTab tmpTab;
		tmpTab = this.notebook1.get_nth_page(this.notebook1.get_current_page()) as crationTab;
		rationFenster.rationBearbeiten(tmpTab.rat);
	}

	public void rationLaden(string name){
	//ration laden und Gui bauen
		ration rat;
		crationTab ratTab;
		
		rat = lirabDb.rationLesen(name);
		//Tab bauen
		if (rat.art == "Milchkühe"){
			ratTab = new crationTabKuh(rat);
			this.notebook1.append_page(ratTab, new Label(rat.name));
			this.notebook1.set_current_page(this.notebook1.get_n_pages() - 1);
		}else if (rat.art == "Färsen"){
			rat.tierBedarf[0].ME = rat.tierBedarf[0].NEL;
			ratTab = new crationTabFaerse(rat);
			this.notebook1.append_page(ratTab, new Label(rat.name));
			this.notebook1.set_current_page(this.notebook1.get_n_pages() - 1);
		}else if (rat.art == "Mastbullen"){
			rat.tierBedarf[0].ME = rat.tierBedarf[0].NEL;
			ratTab = new crationTabBulle(rat);
			this.notebook1.append_page(ratTab, new Label(rat.name));
			this.notebook1.set_current_page(this.notebook1.get_n_pages() - 1);
		}
	}
	
	public void rationSpeichern(){
	//Aktuelle Ration speichern
		crationTab tmpTab;
		tmpTab = this.notebook1.get_nth_page(this.notebook1.get_current_page()) as crationTab;
		tmpTab.rationSpeichern();
	}
	
	public void rationSchliessen(){
	//Aktuellen Tab schließen
		crationTab tmpTab;
		
		tmpTab = this.notebook1.get_nth_page(this.notebook1.get_current_page()) as crationTab;
		if(tmpTab.geaendert == 1){
			Dialog dialog = new Dialog.with_buttons("Frage",hauptFenster.window1,Gtk.DialogFlags.MODAL,
															Gtk.Stock.CANCEL, Gtk.ResponseType.CANCEL,
															Gtk.Stock.OK, Gtk.ResponseType.OK);
			dialog.get_content_area().add(new Label("Ration wurde geändert. Ohne speichern schließen? \nAlle Änderungen gehen verloren\n"));			
			dialog.show_all();
			
			if (dialog.run() == Gtk.ResponseType.OK) {
				tmpTab.destroy();
				tmpTab  = null;
				dialog.close();
			}else{dialog.close();}
		}else{
			tmpTab.destroy();
			tmpTab  = null;
		}
	}

	
	public void rationDrucken(){
		crationTab tmpTab;
		
		tmpTab = this.notebook1.get_nth_page(this.notebook1.get_current_page()) as crationTab;
		auswertungFenster = new causwertungFenster(tmpTab.rat);
		auswertungFenster.window6.show_all();
		auswertungFenster.aendern();
	}
	
}
