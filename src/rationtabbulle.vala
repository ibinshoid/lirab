using Gtk;
using lirab;

public class crationTabBulle:crationTab {
//Tab in dem Bullen Ration angezeigt wird

	public crationTabBulle(ration tabRat) {
	//Konstructor
		rat = tabRat;
		this.auswertungBauen();
		this.rationLaden();
		
		//Ereignisse verbinden
		rupdate.connect(updateBulle);
	}


	public void auswertungBauen(){
		mittelTitel.label7.set_text("ME(MJ)");
		bedarfTitel.label7.set_text("ME(MJ)");
		leistungTitel.label7.set_text("ME(MJ)");
	}

	public void updateBulle(){
		double kgts = 0;
		mittel sMittel = mittel();
		
		update();
		sMittel = summe.fmMittel;
		ergebnis.auswertung.label1.set_text("Versorgung");
		//Summe ausrechnen
		foreach (komponente k in grundFutter){
			kgts = k.fmMittel.TM * k.fmMittel.menge / 1000;
			k.auswertung.label7.set_text(doubleparse(k.fmMittel.ME * kgts));
		}
		foreach (komponente k in kraftFutter){
			kgts = k.fmMittel.TM * k.fmMittel.menge / 1000;
			k.auswertung.label7.set_text(doubleparse(k.fmMittel.ME * kgts));
		}
		//Versorgung ausrechnen und anzeigen
		ergebnis.auswertung.label4.set_text(doubleparse(sMittel.XP - bedarf[0].fmMittel.XP));
		ergebnis.auswertung.label7.set_text(doubleparse(sMittel.ME - bedarf[0].fmMittel.ME));
		bedarf[0].auswertung.label7.set_text(doubleparse(bedarf[0].fmMittel.ME));
		summe.fmMittel = sMittel;
		updateBulleListe();
	}

	public void updateBulleListe(){
	//Listenansicht aktualisieren
		updateListe();
		grid25.attach(new Label("Metabolische Energie (ME):"), 0, 13, 1, 1);
		grid25.attach(new Label(doubleparse(summe.fmMittel.ME) + " MJ"), 1, 13, 1, 1);
		foreach(Widget w in grid25.get_children()){
			w.set_halign(Align.END);
		}
		grid25.show_all();
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
		this.updateBulle();
		this.geaendert = 0;
	}

}	
