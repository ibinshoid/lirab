using Gtk;
using lirab;

public class crationTab:Frame {
//Tab in dem Ration angezeigt wird
	private Builder builder = new Builder.from_file("lirab.ui");
	public signal void rupdate();
	protected Paned paned1;
	public SpinButton spinbutton1;
	protected Notebook notebook2;
	protected ScrolledWindow scrolledwindow2;
	protected ScrolledWindow scrolledwindow3;
	protected ScrolledWindow scrolledwindow4;
	protected ComboBox combobox1;
	protected ComboBox combobox2;
	protected Grid grid11;
	protected Grid grid15;
	protected Grid grid16;
	protected Grid grid18;
	protected Grid grid19;
	protected Grid grid20;
	protected Grid grid21;
	protected Grid grid22;
	protected Grid grid25;
	protected Box box1;
	protected VBox vbox1;
	protected Label label23;
	protected komponente[] grundFutter = {};
	protected komponente[] kraftFutter = {};
	protected komponente[] bedarf = {};
	protected komponente ergebnis = new komponente(mittel(), 0);
	protected komponente summe = new komponente(mittel(), 0);
	protected komponente gehalt = new komponente(mittel(), 0);
	protected ausw mittelTitel = new ausw();
	protected ausw bedarfTitel = new ausw();
	protected ausw leistungTitel = new ausw();
	protected mittel sMittel = mittel();
	public ration rat;
	public int geaendert = 0;
	

	public crationTab() {
	//Konstructor
        builder.connect_signals (this);
		rat = ration();
		notebook2 = builder.get_object ("notebook2") as Notebook;
		scrolledwindow2 = builder.get_object ("scrolledwindow2") as ScrolledWindow;
		scrolledwindow3 = builder.get_object ("scrolledwindow3") as ScrolledWindow;
		scrolledwindow4 = builder.get_object ("scrolledwindow4") as ScrolledWindow;
		paned1 = builder.get_object ("paned1") as Paned;
		label23 = builder.get_object ("label23") as Label;
		spinbutton1 = builder.get_object ("spinbutton1") as SpinButton;
		grid11 =  builder.get_object ("grid11") as Gtk.Grid;
		grid15 =  builder.get_object ("grid15") as Gtk.Grid;
		grid16 =  builder.get_object ("grid16") as Gtk.Grid;
		grid18 =  builder.get_object ("grid18") as Gtk.Grid;
		grid19 =  builder.get_object ("grid19") as Gtk.Grid;
		grid20 =  builder.get_object ("grid20") as Gtk.Grid;
		grid25 =  builder.get_object ("grid25") as Gtk.Grid;
		box1 = builder.get_object ("box1") as Box;
		vbox1 = builder.get_object ("vbox1") as VBox;
		combobox1 = new ComboBox();
		combobox2 = new ComboBox();
		grid21 = new Grid();
		grid21.set_orientation(Orientation.VERTICAL);
		grid22 = new Grid();
		grid22.set_orientation(Orientation.VERTICAL);
		tabBauen();
		this.show_all();
		
		//Ereignisse verbinden
		combobox1.changed.connect(()=>{eingabeHinzufuegen1(get_mittel(combobox1));});
		combobox2.changed.connect(()=>{eingabeHinzufuegen2(get_mittel(combobox2));});
		hauptFenster.readTreestore.connect(()=>{combobox1.set_model(treestore);
												combobox1.set_active(0);
												combobox2.set_model(treestore);
												combobox2.set_active(0);});
		spinbutton1.value_changed.connect(mengeAendern);
	}
	
	private void tabBauen(){
	//Teile des Tabs die immer gleich sind bauen
		this.add(paned1);
		//Linke Seite bauen
		CellRendererText cell = new CellRendererText();
		combobox1.set_hexpand(false);
		combobox1.set_model(treestore);
		combobox1.set_active(0);
		combobox1.pack_start(cell, true);
		combobox1.add_attribute(cell, "text", 1);
		combobox1.set_popup_fixed_width(true);
		combobox2.set_model(treestore);
		combobox2.set_active(0);
		combobox2.pack_start(cell, true);
		combobox2.add_attribute(cell, "text", 1);
		grid15.attach(combobox1, 0, 2, 1, 1);
		vbox1.pack_end(combobox2, false);
		//Rechte Seite bauen
		Box box2 = new Box(Orientation.HORIZONTAL, 10);
		Button abutton = new Button.with_label("Tabelle");
		abutton.clicked.connect(()=>{this.scrolledwindow3.reparent(notebook2);
									this.scrolledwindow4.reparent(notebook2);
									this.scrolledwindow2.reparent(box1);
									});
		Button bbutton = new Button.with_label("Liste");
		bbutton.clicked.connect(()=>{this.scrolledwindow2.reparent(notebook2);
									this.scrolledwindow4.reparent(notebook2);
									this.scrolledwindow3.reparent(box1);
									});
		Button cbutton = new Button.with_label("Grafik");
		cbutton.clicked.connect(()=>{this.scrolledwindow2.reparent(notebook2);
									this.scrolledwindow3.reparent(notebook2);
									this.scrolledwindow4.reparent(box1);
									});
		box2.add(abutton);
		box2.add(bbutton);
		box2.add(cbutton);
		box2.show_all();
		box1.add(box2);
		this.scrolledwindow2.reparent(box1);
		//Tabellenansicht
		mittelTitel.label1.set_text("Futtermittel");
		mittelTitel.label2.set_text("TM(kg)");
		mittelTitel.label3.set_text("RF(g)");
		mittelTitel.label4.set_text("XP(g)");
		mittelTitel.label5.set_text("nXp(g)");
		mittelTitel.label6.set_text("RNB");
		summe.auswertung.label1.set_text("Summe");
		gehalt.auswertung.label1.set_text("Gehalt/kg");
		grid18.add(mittelTitel);
		grid18.add(new Separator(Orientation.HORIZONTAL));
		grid18.add(new Label("Grundfutter"));
		grid18.add(grid21);
		grid18.add(new Separator(Orientation.HORIZONTAL));
		grid18.add(new Label("Kraftfutter"));
		grid18.add(grid22);
		grid18.add(new Separator(Orientation.HORIZONTAL));
		grid18.add(new Label("Summe"));
		grid18.add(summe.auswertung);
		grid18.add(gehalt.auswertung);
		grid18.add(new Separator(Orientation.HORIZONTAL));
		bedarfTitel.label1.set_text("Bedarf");
		bedarfTitel.label2.set_text("TM(kg)");
		bedarfTitel.label3.set_text("RF(g)");
		bedarfTitel.label4.set_text("XP(g)");
		bedarfTitel.label5.set_text("nXp(g)");
		bedarfTitel.label6.set_text("RNB");
		grid19.add(bedarfTitel);
		leistungTitel.label1.set_text("Leistung");
		leistungTitel.label2.set_text("TM(kg)");
		leistungTitel.label3.set_text("RF(g)");
		leistungTitel.label4.set_text("XP(g)");
		leistungTitel.label5.set_text("nXp(g)");
		leistungTitel.label6.set_text("RNB");
		grid20.add(leistungTitel);
		grid20.add(ergebnis.auswertung);
	}

	public void update(){
	//Tabellenansicht aktualisieren
		mittel[] tmpMittel = {};
		mittel eMittel = mittel();
		
		//rationTab.rat füllen
		rat.tiere = (int)this.spinbutton1.get_value(); 
		tmpMittel.length = 0;
		foreach (komponente k in grundFutter){
			tmpMittel += k.fmMittel;
		}
		rat.grundKomponenten = tmpMittel;
		tmpMittel.length = 0;
		foreach (komponente k in kraftFutter){
			tmpMittel += k.fmMittel;
		}
		rat.kraftKomponenten = tmpMittel;
		tmpMittel.length = 0;
		foreach (komponente k in bedarf){
			tmpMittel += k.fmMittel;
		}
		rat.tierBedarf = tmpMittel;
		//Summe anzeigen
		sMittel = rat.get_summe();
		this.label23.set_text(doubleparse(sMittel.menge) + " kg");
		summe.auswertung.label2.set_text(doubleparse(sMittel.TM));
		summe.auswertung.label3.set_text(doubleparse(sMittel.RF));
		summe.auswertung.label4.set_text(doubleparse(sMittel.XP));
		summe.auswertung.label5.set_text(doubleparse(sMittel.nXP));
		summe.auswertung.label6.set_text(doubleparse(sMittel.RNB));
		summe.auswertung.label7.set_text(doubleparse(sMittel.NEL));
		//Gehalt ausrechnen und anzeigen
		gehalt.auswertung.label2.set_text(doubleparse(sMittel.TM/sMittel.TM));
		gehalt.auswertung.label3.set_text(doubleparse(sMittel.RF/sMittel.TM));
		gehalt.auswertung.label4.set_text(doubleparse(sMittel.XP/sMittel.TM));
		gehalt.auswertung.label5.set_text(doubleparse(sMittel.nXP/sMittel.TM));
		gehalt.auswertung.label6.set_text(doubleparse(sMittel.RNB/sMittel.TM));
		gehalt.auswertung.label7.set_text(doubleparse(sMittel.NEL/sMittel.TM));
		ergebnis.fmMittel = eMittel;
		summe.fmMittel = sMittel;
	}
	
	protected void updateListe(){
	//Listenansicht aktualisieren
		sMittel = rat.get_summe();

		foreach(Widget w in grid25.get_children()){
			w.destroy();
		}
		grid25.attach(new Label("Inhaltsstoff:"), 0, 1, 1, 1);
		grid25.attach(new Label("Gehalt:   "), 1, 1, 1, 1);
		grid25.attach(new Label("Anteil %:"), 2, 1, 1, 1);
		grid25.attach(new Label(""), 0, 3, 3, 1);
		grid25.attach(new Label("Rohfaser (RF):"), 0, 6, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.RF) + " g   "), 1, 6, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.RF/sMittel.TM/10) + " %"), 2, 6, 1, 1);
		grid25.attach(new Label("Strukturwert (SW):"), 0, 7, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.SW) + " g   "), 1, 7, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.SW/sMittel.TM/10) + " %"), 2, 7, 1, 1);
		grid25.attach(new Label("Eiweiß (XP):"), 0, 8, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.XP) + " g   "), 1, 8, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.XP/sMittel.TM/10) + " %"), 2, 8, 1, 1);
		grid25.attach(new Label("Reineiweiß (rXP):"), 0, 9, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.rXP) + " g   "), 1, 9, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.rXP/sMittel.TM/10) + " %"), 2, 9, 1, 1);
		grid25.attach(new Label("nutzb. Eiweiß (nXP):"), 0, 10, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.nXP) + " g   "), 1, 10, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.nXP/sMittel.TM/10) + " %"), 2, 10, 1, 1);
		grid25.attach(new Label("N-Bilanz (RNB):"), 0, 11, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.RNB) + " g   "), 1, 11, 1, 1);
		grid25.attach(new Label("Pansenstabiles Eiweiß (UDP):"), 0, 12, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.UDP) + " g   "), 1, 12, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.UDP/sMittel.TM/10) + " %"), 2, 12, 1, 1);
		grid25.attach(new Label("Stärke (XS):"), 0, 15, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.XS) + " g   "), 1, 15, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.XS/sMittel.TM/10) + " %"), 2, 15, 1, 1);
		grid25.attach(new Label("pansenstabile Stärke (bXS):"), 0, 16, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.bXS) + " g   "), 1, 16, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.bXS/sMittel.TM/10) + " %"), 2, 16, 1, 1);
		grid25.attach(new Label("Zucker (XZ):"), 0, 17, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.XZ) + " g   "), 1, 17, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.XZ/sMittel.TM/10) + " %"), 2, 17, 1, 1);
		grid25.attach(new Label("Rohfett (XL):"), 0, 18, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.XL) + " g   "), 1, 18, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.XL/sMittel.TM/10) + " %"), 2, 18, 1, 1);
		grid25.attach(new Label("Cellulase (CL):"), 0, 19, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.CL) + " g   "), 1, 19, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.CL/sMittel.TM/10) + " %"), 2, 19, 1, 1);
		grid25.attach(new Label("Rohasche (XA):"), 0, 20, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.XA) + " g   "), 1, 20, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.XA/sMittel.TM/10) + " %"), 2, 20, 1, 1);
		grid25.attach(new Label("Gerüstsubstanzen (NDF):"), 0, 21, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.NDF) + " g   "), 1, 21, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.NDF/sMittel.TM/10) + " %"), 2, 21, 1, 1);
		grid25.attach(new Label("unverdauliche NDF (ADF):"), 0, 22, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.ADF) + " g   "), 1, 22, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.ADF/sMittel.TM/10) + " %"), 2, 22, 1, 1);
		grid25.attach(new Label("Zucker+Stärke (NFC):"), 0, 23, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.NFC) + " g   "), 1, 23, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.NFC/sMittel.TM/10) + " %"), 2, 23, 1, 1);
		grid25.attach(new Label("organische NDF (NDFo):"), 0, 24, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.NDFo) + " g   "), 1, 24, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.NDFo/sMittel.TM/10) + " %"), 2, 24, 1, 1);
		grid25.attach(new Label("Verdaulichkeit (ELOS):"), 0, 25, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.ELOS) + " g   "), 1, 25, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.ELOS/sMittel.TM/10) + " %"), 2, 25, 1, 1);
		grid25.attach(new Label("Calzium (Ca):"), 0, 26, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.Ca) + " g   "), 1, 26, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.Ca/sMittel.TM/10) + " %"), 2, 26, 1, 1);
		grid25.attach(new Label("Phosphor (P):"), 0, 27, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.P) + " g   "), 1, 27, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.P/sMittel.TM/10) + " %"), 2, 27, 1, 1);
		grid25.attach(new Label("Magnesium (Mg):"), 0, 28, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.Mg) + " g   "), 1, 28, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.Mg/sMittel.TM/10) + " %"), 2, 28, 1, 1);
		grid25.attach(new Label("Natrium (Na):"), 0, 29, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.Na) + " g   "), 1, 29, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.Na/sMittel.TM/10) + " %"), 2, 29, 1, 1);
		grid25.attach(new Label("Kalium (K):"), 0, 30, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.K) + " g   "), 1, 30, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.K/sMittel.TM/10) + " %"), 2, 30, 1, 1);
		//Nährstoffverhältnisse
		grid25.attach(new Label(""), 0, 31, 3, 1);
		grid25.attach(new Label("Nährstoffe:"), 0, 32, 1, 1);
		grid25.attach(new Label("Verhältnis:   "), 1, 32, 1, 1);
		grid25.attach(new Label("K:Na"), 0, 34, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.K/sMittel.Na, 1) + ":1   "), 1, 34, 1, 1);
		grid25.attach(new Label("Ca:P"), 0, 35, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.Ca/sMittel.P, 1) + ":1   "), 1, 35, 1, 1);
		grid25.attach(new Label("K:Mg"), 0, 36, 1, 1);
		grid25.attach(new Label(doubleparse(sMittel.K/sMittel.Mg, 1) + ":1   "), 1, 36, 1, 1);
	}
	
	protected void eingabeHinzufuegen1(mittel m){
	//Grundfutter hinzufuegen
		komponente[] ktmp = this.grundFutter;
		
		if (m.id != 0){
			komponente k = new komponente(m, this.grundFutter.length);
			ktmp += k;
			this.grundFutter = ktmp;
			k.eingabe.spinbutton.set_value(m.menge);
			k.weg.connect((t, pos) => {eingabeEntfernen1(pos);});
			k.anders.connect(()=>{rupdate();
							      geaendert = 1;});
			this.grid16.add(k.eingabe);
			this.grid21.add(k.auswertung);
			this.grid16.show_all();
			this.grid21.show_all();
			k.tiere = (int)this.spinbutton1.get_value();
			k.update();
		}
		this.combobox1.set_active(0);
	}
	
	protected void eingabeEntfernen1(int i){
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

	protected void eingabeHinzufuegen2(mittel m){
	//Kraftfutter hinzufuegen
		komponente[] ktmp;
		
		if (m.id != 0){
			ktmp = this.kraftFutter;
			komponente k = new komponente(m, this.kraftFutter.length);
			ktmp += k;
			this.kraftFutter = ktmp;
			k.eingabe.spinbutton.set_value(m.menge);
			k.weg.connect((t, pos) => {eingabeEntfernen2(pos);});
			k.anders.connect(()=>{rupdate();
								  geaendert = 1;});
			this.vbox1.pack_start(k.eingabe, false);
			this.grid22.add(k.auswertung);
			this.vbox1.show_all();
			this.grid22.show_all();
		}
		this.combobox2.set_active(0);
	}
	
	protected void eingabeEntfernen2(int i){
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

	protected void bedarfHinzufuegen(mittel m){
	//Bedarf hinzufügen
		komponente[] ktmp = this.bedarf;
		
		komponente k = new komponente(m, this.bedarf.length);
		ktmp += k;
		this.bedarf = ktmp;
		k.eingabe.spinbutton.set_value(1);
		k.fmMittel.TM = 1000 ;
		k.eingabe.anders();
		this.grid19.add(k.auswertung);
		this.grid19.show_all();
	}

	protected void bedarfEntfernen(int i){
	//Bedarf entfernen
		if (this.bedarf.length >= 1){
			this.bedarf[i] = null;
			//Array neu ordnen
			if (i+1 < this.bedarf.length){
				this.bedarf[this.bedarf.length - 1].wo = i;
				this.bedarf.move(this.bedarf.length - 1, i, 1);
			}
			this.bedarf.resize(this.bedarf.length - 1);
		}
	}
	
	public void rationSpeichern(){
	//Aktuelle Ration speichern
		ration tmpRat = ration();
		mittel[] mit = {};
		
		this.geaendert = 0;
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
	
	protected void mengeAendern(){
	//Futtermenge an Kuhzahl anpassen
		int tierZahl;
		
		tierZahl = rat.tiere;
		foreach (komponente k in this.grundFutter){
			k.eingabe.spinbutton.set_value(k.eingabe.spinbutton.get_value() * this.spinbutton1.get_value() / tierZahl);
			k.tiere = (int)this.spinbutton1.get_value();
			k.update();
		}
		foreach (komponente k in this.kraftFutter){
			k.eingabe.spinbutton.set_value(k.eingabe.spinbutton.get_value() * this.spinbutton1.get_value() / tierZahl);
			k.tiere = (int)this.spinbutton1.get_value();
			k.update();
		}
		rat.tiere = (int)this.spinbutton1.get_value();
	}
	
	public void rationAendern(ration r){
	//Ration Ändern
		this.geaendert = 1;
		foreach (komponente k in this.bedarf){
			k.fmMittel = r.tierBedarf[k.wo];
			k.fmMittel.TM = 1000;
			k.update();
		}
	}
	
}	
