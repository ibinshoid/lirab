using Gtk;
using lirab;

public class cmittelFenster {
	private Builder builder = new Builder.from_file("lirab.ui");
	public Window window2;
	public Window window3;
	public Window window4;
	private TreeStore treestore1;
	public TreeView treeview1;
	private Button button1;
	private Button button2;
	private Button button3;
	private Button button4;
	public signal void anders();
	
	public cmittelFenster() {	
	//Mittelfenster zusammenbauen
        builder.connect_signals (this);
		window2 = builder.get_object ("window2") as Window;
		window3 = builder.get_object ("window3") as Window;
		window4 = builder.get_object ("window4") as Window;
		treestore1 = builder.get_object ("treestore1") as TreeStore;
		treeview1 = builder.get_object ("treeview1") as TreeView;
		button1 = builder.get_object("button1") as Button;
		button2 = builder.get_object("button2") as Button;
		button3 = builder.get_object("button3") as Button;
		button4 = builder.get_object("button4") as Button;
		//Signale verbinden
		this.window2.destroy.connect(Gtk.main_quit);
		this.button1.clicked.connect(mittelNeu); 
		this.button2.clicked.connect(mittelBearbeiten); 
		this.button3.clicked.connect(mittelEntfernen); 
		this.treeview1.cursor_changed.connect(mittelUpdate); 
	}
	
	public void mittelLesen(){
		TreeIter[] iter = new TreeIter[8]; 
		TreeIter iter2 =  TreeIter();	
		mittel[] Mittel = {};
		
		Mittel = lirabDb.mittelLesen();
		this.treestore1.clear();
		this.treestore1.append(out iter[0], null);
		this.treestore1.set(iter[0], 1, "Grünfutter", -1);
		this.treestore1.append(out iter[1], null);
		this.treestore1.set(iter[1], 1, "Silagen", -1);
		this.treestore1.append(out iter[2], null);
		this.treestore1.set(iter[2], 1, "Heu, Stroh", -1);
		this.treestore1.append(out iter[3], null);
		this.treestore1.set(iter[3], 1, "Getreide", -1);
		this.treestore1.append(out iter[4], null);
		this.treestore1.set(iter[4], 1, "Ölsaaten", -1);
		this.treestore1.append(out iter[5], null);
		this.treestore1.set(iter[5], 1, "Mischfutter", -1);
		this.treestore1.append(out iter[6], null);
		this.treestore1.set(iter[6], 1, "Mineralfutter", -1);
		this.treestore1.append(out iter[7], null);
		this.treestore1.set(iter[7], 1, "Sonstiges", -1);

		foreach (mittel m in Mittel){
			if (m.art == "Grünfutter"){
				this.treestore1.append(out iter2, iter[0]);
				this.treestore1.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME));
			}else if (m.art == "Silagen"){
				this.treestore1.append(out iter2, iter[1]);
				this.treestore1.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}else if (m.art == "Heu, Stroh"){
				this.treestore1.append(out iter2, iter[2]);
				this.treestore1.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}else if (m.art == "Getreide"){
				this.treestore1.append(out iter2, iter[3]);
				this.treestore1.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}else if (m.art == "Ölsaaten"){
				this.treestore1.append(out iter2, iter[4]);
				this.treestore1.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}else if (m.art == "Mischfutter"){
				this.treestore1.append(out iter2, iter[5]);
				this.treestore1.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}else if (m.art == "Mineralfutter"){
				this.treestore1.append(out iter2, iter[6]);
				this.treestore1.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}else if (m.art == "Sonstiges"){
				this.treestore1.append(out iter2, iter[7]);
				this.treestore1.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}
		}	
	}
	
	public void mittelUpdate(){
	//Auswahl von treeview1 in aktMittel schreiben
		TreeSelection selection;
		TreeModel model;
		GLib.Value wert;
		TreeIter iter =  TreeIter();	
		
		selection = this.treeview1.get_selection();
		selection.get_selected(out model, out iter);
		model.get_value(iter, 0, out wert);
		foreach (mittel m in lirabDb.mittelLesen()){
			if (m.id == wert.get_int()){
				aktMittel = m;
			}
		}
		if(wert.get_int() == 0){
			button2.set_sensitive(false);
			button3.set_sensitive(false);
		}else{
			button2.set_sensitive(true);
			button3.set_sensitive(true);
		}
	}

	public void mittelNeu(){
	//Mittel anlegen
		mittelEdit = new cmittelEdit();
		mittel m;
		
		m = mittelEdit.mittelErzeugen();
		lirabDb.mittelHinzufuegen(m);
		this.mittelLesen();
		anders();
	}
	
	public void mittelEntfernen(){
	//Mittel entfernen
		Dialog dialog = new Dialog.with_buttons("Frage",hauptFenster.window1,Gtk.DialogFlags.MODAL,
														"Abbrechen", Gtk.ResponseType.CANCEL,
														"Ok", Gtk.ResponseType.OK);
		dialog.get_content_area().add(new Label("Futtermittel wirklich Löschen? \nAlle Daten gehen verloren\n"));			
		dialog.set_decorated(true);
		dialog.show_all();
		
		if (dialog.run() == Gtk.ResponseType.OK) {
			lirabDb.mittelEntfernen(aktMittel.id);
			this.mittelLesen();
			anders();
			dialog.close();
		}else{dialog.close();}
	}
	
	public void mittelBearbeiten(){
	//Mittel Bearbeiten Fenster zeigen
		mittelEdit = new cmittelEdit();
		mittel m;
		
		m = mittelEdit.mittelBearbeiten(aktMittel);
		lirabDb.mittelEntfernen(m.id);
		lirabDb.mittelHinzufuegen(m);
		this.mittelLesen();
		anders();
	}
	
	
}

