using Gtk;
using lirab;

public class chauptFenster {
	private Builder builder = new Builder.from_file("lirab.ui");
	public signal void readTreestore();
	public signal void saveTab();
	public Window window1;
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
	private Gtk.MenuItem menuitem5;
	private Gtk.MenuItem menuitem6;
	private Gtk.MenuItem menuitem7;
	private Gtk.MenuItem menuitem8;
	private Gtk.MenuItem menuitem9;
	private Gtk.MenuItem menuitem10;
	private Gtk.MenuItem imagemenuitem5;
	
	public chauptFenster() {	
	//Hauptfenster zusammenbauen
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
		vbox1 = builder.get_object ("vbox1") as VBox;
		vbox5 = builder.get_object ("vbox5") as VBox;
		vbox6 = builder.get_object ("vbox6") as VBox;
		vbox11 = builder.get_object ("vbox11") as VBox;
		menuitem5 = builder.get_object ("menuitem5") as Gtk.MenuItem;
		menuitem6 = builder.get_object ("menuitem6") as Gtk.MenuItem;
		menuitem7 = builder.get_object ("menuitem7") as Gtk.MenuItem;
		menuitem8 = builder.get_object ("menuitem8") as Gtk.MenuItem;
		menuitem9 = builder.get_object ("menuitem9") as Gtk.MenuItem;
		menuitem10 = builder.get_object ("menuitem10") as Gtk.MenuItem;
		imagemenuitem5 = builder.get_object ("imagemenuitem5") as Gtk.MenuItem;
		//Ereignisse verbinden
		this.window1.delete_event.connect(beenden);
		mittelFenster.anders.connect(mittelLesen);
		this.menuitem5.activate.connect(editFuttermittel);
		this.menuitem6.activate.connect(rationenVerwalten);
		this.menuitem7.activate.connect(rationSpeichern);
		this.menuitem8.activate.connect(rationBearbeiten);
		this.menuitem9.activate.connect(()=>{rationSchliessen(null);});
		this.menuitem10.activate.connect(rationDrucken);
		this.imagemenuitem5.activate.connect(()=>{this.window1.close();});
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
			}else{
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
		rationEdit = new crationEdit();
		crationTab tmpTab;
		ration r;
		
		tmpTab = this.notebook1.get_nth_page(this.notebook1.get_current_page()) as crationTab;
		if(tmpTab != null){
			r = rationEdit.rationBearbeiten(tmpTab.rat);
			tmpTab.rationAendern(r);
		}
	}

	public void rationLaden(string name){
	//ration laden und Gui bauen
		ration rat;
		crationTab ratTab = null;
		Box box = new Box (Gtk.Orientation.HORIZONTAL, 0);
		Button button = new Button.from_icon_name("process-stop", IconSize.MENU);
		
		rat = lirabDb.rationLesen(name);
		//Tab bauen
		box.set_hexpand(false);
		button.set_relief(ReliefStyle.NONE);
		box.add(new Label(rat.name));
		box.add(button);
		box.show_all();
		if (rat.art == "Milchkühe"){
			ratTab = new crationTabKuh(rat);
			this.notebook1.append_page(ratTab, box);
			this.notebook1.set_current_page(this.notebook1.get_n_pages() - 1);
		}else if (rat.art == "Färsen"){
			rat.tierBedarf[0].ME = rat.tierBedarf[0].NEL;
			ratTab = new crationTabFaerse(rat);
			this.notebook1.append_page(ratTab, box);
			this.notebook1.set_current_page(this.notebook1.get_n_pages() - 1);
		}else if (rat.art == "Mastbullen"){
			rat.tierBedarf[0].ME = rat.tierBedarf[0].NEL;
			ratTab = new crationTabBulle(rat);
			this.notebook1.append_page(ratTab, box);
			this.notebook1.set_current_page(this.notebook1.get_n_pages() - 1);
		}
		button.clicked.connect(()=>{rationSchliessen(ratTab, 1);});
	}
	
	public void rationSpeichern(){
	//Aktuelle Ration speichern
		crationTab tmpTab;
		tmpTab = this.notebook1.get_nth_page(this.notebook1.get_current_page()) as crationTab;
		if(tmpTab != null){
			tmpTab.rationSpeichern();
		}
	}
	
	public void rationSchliessen(crationTab? tab, int i = 0){
	//Aktuellen Tab schließen
		crationTab tmpTab;

		if(tab == null){
			tmpTab = this.notebook1.get_nth_page(this.notebook1.get_current_page()) as crationTab;
		}else{
			tmpTab = tab;
		}
		if(tmpTab.geaendert == 1){
			Dialog dialog = new Dialog.with_buttons("Speichern?",hauptFenster.window1,Gtk.DialogFlags.MODAL,
															"Abbrechen", Gtk.ResponseType.DELETE_EVENT,
															"Schließen ohne Speichern", Gtk.ResponseType.CANCEL,
															"Speichern", Gtk.ResponseType.OK);
			dialog.get_content_area().add(new Label("Ration '" + tmpTab.rat.name + "' wurde geändert.\n"));			
			dialog.set_decorated(true);
			dialog.show_all();
			
			switch(dialog.run()){
			case Gtk.ResponseType.OK:
				tmpTab.rationSpeichern();
				if(i != 2){
					tmpTab.destroy();
					tmpTab  = null;
				}
				dialog.close();
				break;
			case Gtk.ResponseType.CANCEL:
				tmpTab.geaendert = 0;
				if(i != 2){
					tmpTab.destroy();
					tmpTab  = null;
				}
				dialog.close();
				break;
			case Gtk.ResponseType.DELETE_EVENT:
				dialog.close();
				break;
			}
		}else{
			if(i != 2){
				tmpTab.destroy();
				tmpTab  = null;
			}
		}
	}

	
	public void rationDrucken(){
		crationTab tmpTab;
		
		tmpTab = this.notebook1.get_nth_page(this.notebook1.get_current_page()) as crationTab;
		if(tmpTab != null){
			auswertungFenster = new causwertungFenster(tmpTab.rat);
			auswertungFenster.window6.show_all();
			auswertungFenster.aendern();
		}
	}
	
	public bool beenden(){
	//Programm beenden
		crationTab tmpTab;
		int i = 0;
		bool b = true;
		
		foreach(Widget w in this.notebook1.get_children()){
			tmpTab = w as crationTab;
			this.rationSchliessen(tmpTab, 2);
			if(tmpTab.geaendert == 1){
				i += 1;
			}
		}
		if(i == 0){
			b = false;
			Gtk.main_quit();
		}
		return b;
	}
	
}
