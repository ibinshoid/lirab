using Gtk;
using lirab;

public class chauptFenster {
	private Builder builder = new Builder();
	public Window window1;
	public TreeStore treestore1;
	private SpinButton spinbutton8;
	private Label label23;
	private Gtk.MenuItem menu4;
	private ComboBox combobox1;
	private ComboBox combobox2;
	private Notebook notebook1;
	private Notebook notebook2;
	private Paned paned1;
	private Grid grid11;
	private Grid grid15;
	private Grid grid16;
	private VBox vbox1;
	private VBox vbox5;
	private VBox vbox6;
	private VBox vbox11;
	private Box vbox7 = new Box(Gtk.Orientation.VERTICAL, 0);
	private Box vbox8 = new Box(Gtk.Orientation.VERTICAL, 0);
	private komponente[] grundFutter = {};
	private komponente[] kraftFutter = {};
	private komponente[] bedarf = {};
	private komponente ergebnis = new komponente(mittel(), 0);
	private komponente summe = new komponente(mittel(), 0);
	
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
		notebook2 =  builder.get_object ("notebook2") as Gtk.Notebook;
		combobox1 = new ComboBox();
		combobox2 = new ComboBox();
		notebook1 = new Notebook();
		grid11.add(notebook1);
		treestore1 = builder.get_object ("treestore1") as TreeStore;
		vbox1 = builder.get_object ("vbox1") as VBox;
		vbox5 = builder.get_object ("vbox5") as VBox;
		vbox6 = builder.get_object ("vbox6") as VBox;
		vbox11 = builder.get_object ("vbox11") as VBox;
		//Ereignisse verbinden
		this.window1.destroy.connect (Gtk.main_quit);
		combobox1.changed.connect(()=>{eingabeHinzufuegen1(get_mittel(combobox1));});
		combobox2.changed.connect(()=>{eingabeHinzufuegen2(get_mittel(combobox2));});
		mittelFenster.anders.connect(mittelLesen);
		spinbutton8.value_changed.connect(mengeAendern);
	}
	
	public void auswertungBauen(){
		ausw titel = new ausw();
		ausw bedarf = new ausw();
		ausw leistung = new ausw();
		CellRendererText cell = new CellRendererText();
		
		combobox1.set_model(treestore);
		combobox1.pack_start(cell, true);
		combobox1.add_attribute(cell, "text", 1);
		combobox2.set_model(treestore);
		combobox2.pack_start(cell, true);
		combobox2.add_attribute(cell, "text", 1);
		titel.label1.set_text("Futtermittel");
		titel.label2.set_text("TM(kg)");
		titel.label3.set_text("RF(g)");
		titel.label4.set_text("XP(g)");
		titel.label5.set_text("nXp(g)");
		titel.label6.set_text("RNB");
		titel.label7.set_text("NEL(MJ)");
		grid15.attach(combobox1, 0, 2, 1, 1);
		summe.auswertung.label1.set_text("Summe");
		vbox1.pack_end(combobox2, false);
		vbox5.pack_start(titel, false);
		vbox5.pack_start(new Separator(Orientation.HORIZONTAL));
		vbox5.pack_start(new Label("Grundfutter"));
		vbox5.pack_start(vbox7, false);
		vbox5.pack_start(new Separator(Orientation.HORIZONTAL));
		vbox5.pack_start(new Label("Kraftfutter"));
		vbox5.pack_start(vbox8, false);
		vbox5.pack_start(new Separator(Orientation.HORIZONTAL));
		vbox5.pack_start(new Label("Summe"));
		vbox5.pack_end(summe.auswertung, false);
		vbox5.pack_end(new Separator(Orientation.HORIZONTAL));
		bedarf.label1.set_text("Bedarf");
		bedarf.label2.set_text("TM(kg)");
		bedarf.label3.set_text("RF(g)");
		bedarf.label4.set_text("XP(g)");
		bedarf.label5.set_text("nXp(g)");
		bedarf.label6.set_text("RNB");
		bedarf.label7.set_text("NEL(MJ)");
		vbox6.pack_start(bedarf, false);
		leistung.label1.set_text("Leistung");
		leistung.label2.set_text("TM(kg)");
		leistung.label3.set_text("RF(g)");
		leistung.label4.set_text("XP(g)");
		leistung.label5.set_text("nXp(g)");
		leistung.label6.set_text("RNB");
		leistung.label7.set_text("NEL(MJ)");
		vbox11.pack_start(leistung, false);
		vbox11.pack_start(ergebnis.auswertung, false);
		vbox1.show_all();
		grid15.show_all();
		vbox5.show_all();
		vbox6.show_all();
		vbox11.show_all();
	}
	
	public void update(){
		double kgts = 0;
		double total = 0;
		mittel[] tmpMittel = {};
		mittel eMittel = ergebnis.fmMittel;
		mittel sMittel = summe.fmMittel;
		ergebnis.auswertung.label1.set_text("Liter Milch");
		aktRation.tiere = (int)this.spinbutton8.get_value(); 
		//Summe ausrechnen
		tmpMittel.length = 0;
		foreach (komponente k in grundFutter){
			tmpMittel += k.fmMittel;
			kgts = k.fmMittel.TM * k.fmMittel.menge / 1000;
			total += k.menge;
			sMittel.TM += (kgts);
			sMittel.RF += (k.fmMittel.RF * kgts);
			sMittel.XP += (k.fmMittel.XP * kgts);
			sMittel.nXP += (k.fmMittel.nXP * kgts);
			sMittel.RNB += (k.fmMittel.RNB * kgts);
			sMittel.NEL += (k.fmMittel.NEL * kgts);
		}
		aktRation.grundKomponenten = tmpMittel;
		tmpMittel.length = 0;
		foreach (komponente k in kraftFutter){
			tmpMittel += k.fmMittel;
			kgts = k.fmMittel.TM * k.fmMittel.menge / 1000;
			total += k.menge;
			sMittel.TM += (kgts);
			sMittel.RF += (k.fmMittel.RF * kgts);
			sMittel.XP += (k.fmMittel.XP * kgts);
			sMittel.nXP += (k.fmMittel.nXP * kgts);
			sMittel.RNB += (k.fmMittel.RNB * kgts);
			sMittel.NEL += (k.fmMittel.NEL * kgts);
		}
		aktRation.kraftKomponenten = tmpMittel;
		tmpMittel.length = 0;
		//Summe anzeigen
		this.label23.set_text(doubleparse(total) + " kg");
		summe.auswertung.label2.set_text(doubleparse(sMittel.TM));
		summe.auswertung.label3.set_text(doubleparse(sMittel.RF));
		summe.auswertung.label4.set_text(doubleparse(sMittel.XP));
		summe.auswertung.label5.set_text(doubleparse(sMittel.nXP));
		summe.auswertung.label6.set_text(doubleparse(sMittel.RNB));
		summe.auswertung.label7.set_text(doubleparse(sMittel.NEL));
		//Liter Milch ausrechnen
		if (bedarf.length >= 2){
			eMittel.XP = ((sMittel.XP - bedarf[0].fmMittel.XP) / bedarf[1].fmMittel.XP);
			eMittel.nXP = ((sMittel.nXP - bedarf[0].fmMittel.nXP) / bedarf[1].fmMittel.nXP);
			eMittel.NEL = ((sMittel.NEL - bedarf[0].fmMittel.NEL) / bedarf[1].fmMittel.NEL);
		}
		//Liter Milch anzeigen
		ergebnis.auswertung.label4.set_text(doubleparse(eMittel.XP));
		ergebnis.auswertung.label5.set_text(doubleparse(eMittel.nXP));
		ergebnis.auswertung.label7.set_text(doubleparse(eMittel.NEL));
		
	}
	
	public void editFuttermittel(){
		mittelFenster.window3.show_all();
	}
	
	public void mittelLesen(){
	// Liste mit Futtermitteln füllen
		TreeIter[] iter = new TreeIter[8]; 
		TreeIter iter2 =  TreeIter();	
		mittel[] Mittel = {};

		//Leer machen
		combobox1.set_model(null);
		combobox2.set_model(null);
		treestore.clear();
		combobox1.set_model(treestore);
		combobox2.set_model(treestore);
		//Voll machen
		treestore.append(out iter[0], null);
		treestore.set(iter[0], 1, "Futter hinzufügen", -1);
		treestore.append(out iter[0], null);
		treestore.set(iter[0], 1, "Grünfutter", -1);
		treestore.append(out iter[1], null);
		treestore.set(iter[1], 1, "Silagen", -1);
		treestore.append(out iter[2], null);
		treestore.set(iter[2], 1, "Heu, Stroh", -1);
		treestore.append(out iter[3], null);
		treestore.set(iter[3], 1, "Getreide", -1);
		treestore.append(out iter[4], null);
		treestore.set(iter[4], 1, "Ölsaaten", -1);
		treestore.append(out iter[5], null);
		treestore.set(iter[5], 1, "Mischfutter", -1);
		treestore.append(out iter[6], null);
		treestore.set(iter[6], 1, "Mineralfutter", -1);
		treestore.append(out iter[7], null);
		treestore.set(iter[7], 1, "Sonstiges", -1);

		Mittel = lirabDb.mittelLesen();
		foreach (mittel m in Mittel){
			if (m.art == "Grünfutter"){
				treestore.append(out iter2, iter[0]);
				treestore.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}else if (m.art == "Silagen"){
				treestore.append(out iter2, iter[1]);
				treestore.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}else if (m.art == "Heu, Stroh"){
				treestore.append(out iter2, iter[2]);
				treestore.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}else if (m.art == "Getreide"){
				treestore.append(out iter2, iter[3]);
				treestore.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}else if (m.art == "Ölsaaten"){
				treestore.append(out iter2, iter[4]);
				treestore.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}else if (m.art == "Mischfutter"){
				treestore.append(out iter2, iter[5]);
				treestore.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}else if (m.art == "Mineralfutter"){
				treestore.append(out iter2, iter[6]);
				treestore.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}else if (m.art == "Sonstiges"){
				treestore.append(out iter2, iter[7]);
				treestore.set (iter2, 0, m.id, 1, m.name, 2, m.TM.to_string(), 3, m.RF.to_string(), 4, m.XP.to_string(), 5, m.nXP.to_string(), 6, m.RNB.to_string(), 7, doubleparse(m.NEL), 8, doubleparse(m.ME), -1);
			}
		}
	}	
	
	public void editRationen(){
		rationFenster.window4.show_all();
	}

	public void eingabeHinzufuegen1(mittel m){
	//Grundfutter hinzufuegen
		if (m.id != 0){
			hauptFenster.grundFutter +=(new komponente(m, hauptFenster.grundFutter.length));
			grundFutter[grundFutter.length-1].eingabe.spinbutton.set_value(m.menge);
			grundFutter[grundFutter.length-1].weg.connect((t, pos) => {eingabeEntfernen1(pos);});
			grundFutter[grundFutter.length-1].anders.connect(update);
			hauptFenster.grid16.add(grundFutter[grundFutter.length-1].eingabe);
			hauptFenster.vbox7.pack_start(grundFutter[grundFutter.length-1].auswertung, false);
			hauptFenster.grid16.show_all();
			hauptFenster.vbox7.show_all();
		}
		hauptFenster.combobox1.set_active(0);
	}
	
	public void eingabeEntfernen1(int i){
	//Grundfutter entfernen
		if (hauptFenster.grundFutter.length >= 1){
			hauptFenster.grundFutter[i] = null;
			//Array neu ordnen
			if (i+1 < hauptFenster.grundFutter.length){
				hauptFenster.grundFutter[hauptFenster.grundFutter.length - 1].wo = i;
				hauptFenster.grundFutter.move(hauptFenster.grundFutter.length - 1, i, 1);
			}
			hauptFenster.grundFutter.resize(hauptFenster.grundFutter.length - 1);
		}
	}
	public void eingabeHinzufuegen2(mittel m){
	//Kraftfutter hinzufuegen
		if (m.id != 0){
			hauptFenster.kraftFutter += new komponente(m, hauptFenster.kraftFutter.length);
			hauptFenster.kraftFutter[kraftFutter.length-1].eingabe.spinbutton.set_value(m.menge);
			hauptFenster.kraftFutter[kraftFutter.length-1].weg.connect((t, pos) => {eingabeEntfernen2(pos);});
			hauptFenster.kraftFutter[kraftFutter.length-1].anders.connect(update);
			hauptFenster.vbox1.pack_start(hauptFenster.kraftFutter[hauptFenster.kraftFutter.length - 1].eingabe, false);
			hauptFenster.vbox8.pack_start(hauptFenster.kraftFutter[hauptFenster.kraftFutter.length - 1].auswertung, false);
			hauptFenster.vbox1.show_all();
			hauptFenster.vbox8.show_all();
		}
		hauptFenster.combobox2.set_active(0);
	}
	
	public void eingabeEntfernen2(int i){
	//Kraftfutter entfernen
		if (hauptFenster.kraftFutter.length >= 1){
			hauptFenster.kraftFutter[i] = null;
			//Array neu ordnen
			if (i+1 < hauptFenster.kraftFutter.length){
				hauptFenster.kraftFutter[hauptFenster.kraftFutter.length - 1].wo = i;
				hauptFenster.kraftFutter.move(hauptFenster.kraftFutter.length - 1, i, 1);
			}
			hauptFenster.kraftFutter.resize(hauptFenster.kraftFutter.length - 1);
		}
	}

	public void bedarfHinzufuegen(mittel m){
	//Bedarf hinzufügen
		hauptFenster.bedarf += new komponente(m, hauptFenster.bedarf.length);
		bedarf[hauptFenster.bedarf.length-1].eingabe.spinbutton.set_value(1);
		bedarf[hauptFenster.bedarf.length -1].fmMittel.TM = 1000 * aktRation.tiere;
		bedarf[hauptFenster.bedarf.length -1].eingabe.anders();
		hauptFenster.vbox6.pack_start(hauptFenster.bedarf[hauptFenster.bedarf.length -1].auswertung, false);
		hauptFenster.vbox6.show_all();
	}

	public void bedarfEntfernen(int i){
	//Bedarf entfernen
		if (hauptFenster.bedarf.length >= 1){
			bedarf[i] = null;
			//Array neu ordnen
			if (i+1 < bedarf.length){
				bedarf[bedarf.length - 1].wo = i;
				bedarf.move(bedarf.length - 1, i, 1);
			}
			bedarf.resize(bedarf.length - 1);
		}
	}

	public mittel get_mittel(ComboBox cb){
		TreeIter iter =  TreeIter();	
		GLib.Value wert;
		mittel mi = mittel();
		cb.get_active_iter(out iter);
		treestore.get_value(iter, 0, out wert);
		foreach (mittel m in lirabDb.mittelLesen()){
			if (m.id == wert.get_int()){
				mi = m;
			}
		}
		return mi;
	}
	
	public void rationLaden(string name){
	//ration laden und Gui bauen
		ration rat;
		
		hauptFenster.rationSchliessen();
		rat = lirabDb.rationLesen(name);
		//Tab bauen
		hauptFenster.paned1.reparent(hauptFenster.notebook1);
		hauptFenster.notebook1.set_tab_label_text(paned1, rat.name);
		aktRation = rat;
		//Daten eintragen
		foreach(mittel m in rat.tierBedarf){
			bedarfHinzufuegen(m);
		}
		foreach(mittel m in rat.grundKomponenten){
			eingabeHinzufuegen1(m);
		}
		foreach(mittel m in rat.kraftKomponenten){
			eingabeHinzufuegen2(m);
		}
		this.spinbutton8.set_value(aktRation.tiere);
		hauptFenster.window1.resize(1000, hauptFenster.window1.get_allocated_height());
		hauptFenster.update();
	}
	
	public void rationSpeichern(){
	//Aktuelle Ration speichern
		if(aktRation.name != null){
			ration rat = ration();
			mittel[] mit = {};
			foreach(komponente k in hauptFenster.grundFutter){
				mit += k.fmMittel;
			}
			rat.grundKomponenten = mit;
			mit.resize(0);
	
			foreach (komponente k in hauptFenster.kraftFutter){
				mit += k.fmMittel;
			}
			rat.kraftKomponenten = mit;
			mit.resize(0);
			foreach (komponente k in hauptFenster.bedarf){
				mit += k.fmMittel;
			}
			rat.tierBedarf = mit;
			rat.name = aktRation.name;
			rat.art = aktRation.art;
			rat.tiere = aktRation.tiere;
			lirabDb.rationSpeichern(rat);
		}
	}
	
	public void rationSchliessen(){
		//Sauber machen
		foreach (komponente k in hauptFenster.bedarf){
			k.auswertung.destroy();
		}
		bedarf.resize(0);
		foreach (komponente k in hauptFenster.grundFutter){
			k.eingabe.destroy();
			k.auswertung.destroy();
		}
		hauptFenster.grundFutter.resize(0);
		foreach (komponente k in hauptFenster.kraftFutter){
			k.eingabe.destroy();
			k.auswertung.destroy();
		}
		hauptFenster.kraftFutter.resize(0);
		aktRation = ration();
		//Tab entfernen
		hauptFenster.paned1.reparent(hauptFenster.notebook2);
		
	}
	
	public void rationDrucken(){
		if(aktRation.name != null){
			auswertungFenster = new causwertungFenster();
			auswertungFenster.window6.show_all();
			auswertungFenster.aendern();
		}
	}
	
	public void mengeAendern(){
	//Futtermenge an Kuhzahl anpassen
		int tierZahl;
		
		tierZahl = aktRation.tiere;
		foreach (komponente k in this.grundFutter){
			k.eingabe.spinbutton.set_value(k.eingabe.spinbutton.get_value() * this.spinbutton8.get_value() / tierZahl);
		}
		foreach (komponente k in this.kraftFutter){
			k.eingabe.spinbutton.set_value(k.eingabe.spinbutton.get_value() * this.spinbutton8.get_value() / tierZahl);
		}
		
	}
	
}
