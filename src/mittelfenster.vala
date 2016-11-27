using Gtk;
using lirab;

public class cmittelFenster {
	private Builder builder = new Builder();
	public Window window2;
	public Window window3;
	public Window window4;
	public Window window5;
	private TreeStore treestore1;
	public TreeView treeview1;
	private Button button1;
	private Button button2;
	private Button button3;
	private Button button4;
	private Button button12;
	private Button button13;
	private SpinButton spinbutton1;
	private SpinButton spinbutton2;
	private SpinButton spinbutton3;
	private SpinButton spinbutton4;
	private SpinButton spinbutton5;
	private SpinButton spinbutton6;
	private SpinButton spinbutton7;
	private SpinButton spinbutton18;
	private SpinButton spinbutton19;
	private SpinButton spinbutton20;
	private SpinButton spinbutton21;
	private SpinButton spinbutton22;
	private SpinButton spinbutton23;
	private SpinButton spinbutton24;
	private SpinButton spinbutton25;
	private SpinButton spinbutton26;
	private SpinButton spinbutton27;
	private Entry entry1;
	private Entry entry2;
	private ComboBoxText comboboxtext2;
	private Grid grid7;
	public signal void anders();
	
	public cmittelFenster() {	
	//Mittelfenster zusammenbauen
		builder.add_from_file ("lirab.ui");
        builder.connect_signals (this);
		window2 = builder.get_object ("window2") as Window;
		window3 = builder.get_object ("window3") as Window;
		window4 = builder.get_object ("window4") as Window;
		window5 = builder.get_object ("window5") as Window;
		treestore1 = builder.get_object ("treestore1") as TreeStore;
		treeview1 = builder.get_object ("treeview1") as TreeView;
		button1 = builder.get_object("button1") as Button;
		button2 = builder.get_object("button2") as Button;
		button3 = builder.get_object("button3") as Button;
		button4 = builder.get_object("button4") as Button;
		button12 = builder.get_object("button12") as Button;
		button13 = builder.get_object("button13") as Button;
		spinbutton1 = builder.get_object("spinbutton1") as SpinButton;
		spinbutton2 = builder.get_object("spinbutton2") as SpinButton;
		spinbutton3 = builder.get_object("spinbutton3") as SpinButton;
		spinbutton4 = builder.get_object("spinbutton4") as SpinButton;
		spinbutton5 = builder.get_object("spinbutton5") as SpinButton;
		spinbutton6 = builder.get_object("spinbutton6") as SpinButton;
		spinbutton7 = builder.get_object("spinbutton7") as SpinButton;
		spinbutton18 = builder.get_object("spinbutton18") as SpinButton;
		spinbutton19 = builder.get_object("spinbutton19") as SpinButton;
		spinbutton20 = builder.get_object("spinbutton20") as SpinButton;
		spinbutton21 = builder.get_object("spinbutton21") as SpinButton;
		spinbutton22 = builder.get_object("spinbutton22") as SpinButton;
		spinbutton23 = builder.get_object("spinbutton23") as SpinButton;
		spinbutton24 = builder.get_object("spinbutton24") as SpinButton;
		spinbutton25 = builder.get_object("spinbutton25") as SpinButton;
		spinbutton26 = builder.get_object("spinbutton26") as SpinButton;
		spinbutton27 = builder.get_object("spinbutton27") as SpinButton;
		entry1 = builder.get_object("entry1") as Entry;
		entry2 = builder.get_object("entry2") as Entry;
		comboboxtext2 = builder.get_object("comboboxtext2") as ComboBoxText;
		grid7 = builder.get_object("grid7") as Grid;
		this.window2.destroy.connect(Gtk.main_quit);
		this.button2.clicked.connect(mittelBearbeiten); 
		this.button3.clicked.connect(mittelEntfernen); 
		this.button12.clicked.connect(mittelHinzufuegen);
		this.button13.clicked.connect(mittelSaeubern);
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
	}
	
	public void mittelEntfernen(){
	//Mittel entfernen
		Dialog dialog = new Dialog.with_buttons("Frage",hauptFenster.window1,Gtk.DialogFlags.MODAL,
														Gtk.Stock.CANCEL, Gtk.ResponseType.CANCEL,
														Gtk.Stock.OK, Gtk.ResponseType.OK);
		dialog.get_content_area().add(new Label("Futtermittel wirklich Löschen? \nAlle Daten gehen verloren\n"));			
		dialog.show_all();
		
		if (dialog.run() == Gtk.ResponseType.OK) {
			lirabDb.mittelEntfernen(aktMittel.id);
			this.mittelLesen();
			anders();
			dialog.close();
		}else{dialog.close();}
	}
	
	public void mittelHinzufuegen(){
	//Futtermittel in Datenbank speichern
		mittel fMittel = mittel();
		
		//Wenn Ändern  dann Mittel löschen und neu Schreiben
		if(this.button12.get_label() == "Ändern"){
			lirabDb.mittelEntfernen(aktMittel.id);
		}
		fMittel.id = -1;
		fMittel.name = this.entry2.get_text();
		fMittel.art = comboboxtext2.get_active_text();
		fMittel.TM = this.spinbutton1.get_value_as_int();
		fMittel.RF = this.spinbutton2.get_value_as_int();
		fMittel.XP = this.spinbutton3.get_value_as_int();
		fMittel.nXP = this.spinbutton4.get_value_as_int();
		fMittel.ME = this.spinbutton5.get_value();
		fMittel.NEL = this.spinbutton6.get_value();
		fMittel.RNB = this.spinbutton7.get_value_as_int();
		
		lirabDb.mittelHinzufuegen(fMittel);
		this.mittelLesen();
		anders();
		this.mittelSaeubern();
	}
	
	public void mittelBearbeiten(){
	//Mittel Bearbeiten Fenster füllen und zeigen
		Entry cbentry = this.comboboxtext2.get_child() as Entry;
		
		cbentry.set_text(aktMittel.art);
		this.entry2.set_text(aktMittel.name);
		this.spinbutton1.set_value(aktMittel.TM);
		this.spinbutton2.set_value(aktMittel.RF);
		this.spinbutton3.set_value(aktMittel.XP);
		this.spinbutton4.set_value(aktMittel.nXP);
		this.spinbutton5.set_value(aktMittel.ME);
		this.spinbutton6.set_value(aktMittel.NEL);
		this.spinbutton7.set_value(aktMittel.RNB);
		this.button12.set_label("Ändern");
		this.window5.show();
	}
	
	public void mittelSaeubern(){
	//Mittel hinzufügen Fenster sauber machen
		
		foreach(Widget w in grid7.get_children()){
			if(w.get_type().name() == "GtkSpinButton"){
				SpinButton s = w as SpinButton;
				s.set_value(0);
			}else if(w.get_type().name() == "GtkEntry"){
				Entry e = w as Entry;
				e.set_text("");
			}else if(w.get_type().name() == "GtkComboBoxText"){
				ComboBoxText c = w as ComboBoxText;
				c.set_active(0);
			}
		}
		this.button12.set_label("Hinzufügen");
		this.window5.hide();
		
	}
	
}

