using Gtk;
using lirab;

public class crationTab:Frame {
//Tab in dem Ration angezeigt wird
	private Builder builder = new Builder();
	private Paned paned1;
	public Button button14;
	public SpinButton spinbutton1;
	private ComboBox combobox1;
	private ComboBox combobox2;
	private Grid grid11;
	private Grid grid15;
	private Grid grid16;
	private Grid grid18;
	private Grid grid19;
	private Grid grid20;
	private Grid grid21;
	private Grid grid22;
	private VBox vbox1;
	private Label label23;
	private komponente[] grundFutter = {};
	private komponente[] kraftFutter = {};
	private komponente[] bedarf = {};
	private komponente ergebnis = new komponente(mittel(), 0);
	private komponente summe = new komponente(mittel(), 0);
	public ration rat;
	private int tiere;
	public crationTab(ration tabRat) {
	//Konstructor
		rat = tabRat;
		builder.add_from_file ("lirab.ui");
        builder.connect_signals (this);
		paned1 = builder.get_object ("paned1") as Paned;
		button14 = builder.get_object ("button14") as Button;
		label23 = builder.get_object ("label23") as Label;
		spinbutton1 = builder.get_object ("spinbutton1") as SpinButton;
		grid11 =  builder.get_object ("grid11") as Gtk.Grid;
		grid15 =  builder.get_object ("grid15") as Gtk.Grid;
		grid16 =  builder.get_object ("grid16") as Gtk.Grid;
		grid18 =  builder.get_object ("grid18") as Gtk.Grid;
		grid19 =  builder.get_object ("grid19") as Gtk.Grid;
		grid20 =  builder.get_object ("grid20") as Gtk.Grid;
		vbox1 = builder.get_object ("vbox1") as VBox;
		combobox1 = new ComboBox();
		combobox2 = new ComboBox();
		grid21 = new Grid();
		grid21.set_orientation(Orientation.VERTICAL);
		grid22 = new Grid();
		grid22.set_orientation(Orientation.VERTICAL);
		this.add(paned1);
		this.show();
		this.auswertungBauen();
		this.rationLaden();
		
		//Ereignisse verbinden
		combobox1.changed.connect(()=>{eingabeHinzufuegen1(get_mittel(combobox1));});
		combobox2.changed.connect(()=>{eingabeHinzufuegen2(get_mittel(combobox2));});
		hauptFenster.readTreestore.connect(()=>{combobox1.set_model(treestore);
												combobox2.set_model(treestore);});
		spinbutton1.value_changed.connect(mengeAendern);
		button14.clicked.connect(()=>{this.destroy();});
	}


	public void auswertungBauen(){
		ausw titel = new ausw();
		ausw bedarf = new ausw();
		ausw leistung = new ausw();
		CellRendererText cell = new CellRendererText();
		
		combobox1.set_hexpand(true);
		combobox1.set_model(treestore);
		combobox1.set_active(0);
		combobox1.pack_start(cell, true);
		combobox1.add_attribute(cell, "text", 1);
		combobox2.set_model(treestore);
		combobox2.set_active(0);
		combobox2.pack_start(cell, true);
		combobox2.add_attribute(cell, "text", 1);
		grid15.attach(combobox1, 0, 2, 1, 1);
		vbox1.pack_end(combobox2, false);
		titel.label1.set_text("Futtermittel");
		titel.label2.set_text("TM(kg)");
		titel.label3.set_text("RF(g)");
		titel.label4.set_text("XP(g)");
		titel.label5.set_text("nXp(g)");
		titel.label6.set_text("RNB");
		titel.label7.set_text("NEL(MJ)");
		summe.auswertung.label1.set_text("Summe");
		grid18.add(titel);
		grid18.add(new Separator(Orientation.HORIZONTAL));
		grid18.add(new Label("Grundfutter"));
		grid18.add(grid21);
		grid18.add(new Separator(Orientation.HORIZONTAL));
		grid18.add(new Label("Kraftfutter"));
		grid18.add(grid22);
		grid18.add(new Separator(Orientation.HORIZONTAL));
		grid18.add(new Label("Summe"));
		grid18.add(summe.auswertung);
		grid18.add(new Separator(Orientation.HORIZONTAL));
		bedarf.label1.set_text("Bedarf");
		bedarf.label2.set_text("TM(kg)");
		bedarf.label3.set_text("RF(g)");
		bedarf.label4.set_text("XP(g)");
		bedarf.label5.set_text("nXp(g)");
		bedarf.label6.set_text("RNB");
		bedarf.label7.set_text("NEL(MJ)");
		grid19.add(bedarf);
		leistung.label1.set_text("Leistung");
		leistung.label2.set_text("TM(kg)");
		leistung.label3.set_text("RF(g)");
		leistung.label4.set_text("XP(g)");
		leistung.label5.set_text("nXp(g)");
		leistung.label6.set_text("RNB");
		leistung.label7.set_text("NEL(MJ)");
		grid20.add(leistung);
		grid20.add(ergebnis.auswertung);
		vbox1.show_all();
		grid15.show_all();
		grid18.show_all();
		grid19.show_all();
		grid20.show_all();
	}

	public void update(){
		double kgts = 0;
		double total = 0;
		mittel[] tmpMittel = {};
		mittel eMittel = ergebnis.fmMittel;
		mittel sMittel = summe.fmMittel;
		ergebnis.auswertung.label1.set_text("Liter Milch");
		rat.tiere = (int)this.spinbutton1.get_value(); 
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
		rat.grundKomponenten = tmpMittel;
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
		rat.kraftKomponenten = tmpMittel;
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
	public void eingabeHinzufuegen1(mittel m){
	//Grundfutter hinzufuegen
		if (m.id != 0){
			komponente k = new komponente(m, this.grundFutter.length);
			this.grundFutter += k;
			k.eingabe.spinbutton.set_value(m.menge);
			k.weg.connect((t, pos) => {eingabeEntfernen1(pos);});
			k.anders.connect(update);
			this.grid16.add(k.eingabe);
			this.grid21.add(k.auswertung);
			this.grid16.show_all();
			this.grid21.show_all();
		}
		this.combobox1.set_active(0);
	}
	
	public void eingabeEntfernen1(int i){
	//Grundfutter entfernen
		if (this.grundFutter.length >= 1){
			this.grundFutter[i] = null;
			//Array neu ordnen
			if (i+1 < this.grundFutter.length){
				this.grundFutter[this.grundFutter.length - 1].wo = i;
				this.grundFutter.move(this.grundFutter.length - 1, i, 1);
			}
			this.grundFutter.resize(this.grundFutter.length - 1);
		}
	}

	public void eingabeHinzufuegen2(mittel m){
	//Kraftfutter hinzufuegen
		if (m.id != 0){
			komponente k = new komponente(m, this.kraftFutter.length);
			this.kraftFutter += k;
			k.eingabe.spinbutton.set_value(m.menge);
			k.weg.connect((t, pos) => {eingabeEntfernen2(pos);});
			k.anders.connect(update);
			this.vbox1.pack_start(k.eingabe, false);
			this.grid22.add(k.auswertung);
			this.vbox1.show_all();
			this.grid22.show_all();
		}
		this.combobox2.set_active(0);
	}
	
	public void eingabeEntfernen2(int i){
	//Kraftfutter entfernen
		if (this.kraftFutter.length >= 1){
			this.kraftFutter[i] = null;
			//Array neu ordnen
			if (i+1 < this.kraftFutter.length){
				this.kraftFutter[this.kraftFutter.length - 1].wo = i;
				this.kraftFutter.move(this.kraftFutter.length - 1, i, 1);
			}
			this.kraftFutter.resize(this.kraftFutter.length - 1);
		}
	}

	public void bedarfHinzufuegen(mittel m){
	//Bedarf hinzufügen
		komponente k = new komponente(m, this.bedarf.length);
		this.bedarf += k;
		k.eingabe.spinbutton.set_value(1);
		k.fmMittel.TM = 1000 ;
		k.eingabe.anders();
		this.grid19.add(k.auswertung);
		this.grid19.show_all();
	}

	public void bedarfEntfernen(int i){
	//Bedarf entfernen
		if (this.bedarf.length >= 1){
			bedarf[i] = null;
			//Array neu ordnen
			if (i+1 < bedarf.length){
				bedarf[bedarf.length - 1].wo = i;
				bedarf.move(bedarf.length - 1, i, 1);
			}
			bedarf.resize(bedarf.length - 1);
		}
	}
	
	private void rationLaden(){
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
		this.spinbutton1.set_value(rat.tiere);
		this.mengeAendern();
		this.update();
	}

	public void rationSpeichern(){
	//Aktuelle Ration speichern
		ration tmpRat = ration();
		mittel[] mit = {};
		foreach(komponente k in this.grundFutter){
			k.fmMittel.menge = k.menge;
			mit += k.fmMittel;
		}
		tmpRat.grundKomponenten = mit;
		mit.resize(0);

		foreach (komponente k in this.kraftFutter){
			mit += k.fmMittel;
		}
		tmpRat.kraftKomponenten = mit;
		mit.resize(0);
		foreach (komponente k in this.bedarf){
			mit += k.fmMittel;
		}
		tmpRat.tierBedarf = mit;
		tmpRat.name = rat.name;
		tmpRat.art = rat.art;
		tmpRat.tiere = rat.tiere;
		lirabDb.rationSpeichern(tmpRat);
	}
	
	public void mengeAendern(){
	//Futtermenge an Kuhzahl anpassen
		int tierZahl;
		
		tierZahl = rat.tiere;
		foreach (komponente k in this.grundFutter){
			k.eingabe.spinbutton.set_value(k.eingabe.spinbutton.get_value() * this.spinbutton1.get_value() / tierZahl);
			k.tiere = (int)this.spinbutton1.get_value();
			k.update();
		}
		rat.tiere = (int)this.spinbutton1.get_value();
		
	}
	
}	
