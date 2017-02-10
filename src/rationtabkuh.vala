using Gtk;
using lirab;

public class crationTabKuh:crationTab {
//Tab in dem Kuh Ration angezeigt wird

	public crationTabKuh(ration tabRat) {
	//Konstructor
		rat = tabRat;
		this.auswertungBauen();
		this.rationLaden();
		
		//Ereignisse verbinden
		rupdate.connect(updateKuh);
	}


	public void auswertungBauen(){
		mittelTitel.label7.set_text("NEL(MJ)");
		bedarfTitel.label7.set_text("NEL(MJ)");
		leistungTitel.label7.set_text("NEL(MJ)");
	}
	public void updateKuhListe(){
	//Listenansicht aktualisieren
		updateListe();
		grid25.attach(new Label("Leistung:"), 3, 1, 1, 1);
		grid25.attach(new Label(doubleparse(ergebnis.fmMittel.XP) + " Liter"), 3, 8, 1, 1);
		grid25.attach(new Label(doubleparse(ergebnis.fmMittel.nXP) + " Liter"), 3, 10, 1, 1);
		grid25.attach(new Label("Netto Energie Laktation (NEL):"), 0, 13, 1, 1);
		grid25.attach(new Label(doubleparse(summe.fmMittel.NEL) + " MJ"), 1, 13, 1, 1);
		grid25.attach(new Label(doubleparse(ergebnis.fmMittel.NEL) + " Liter"), 3, 13, 1, 1);
		foreach(Widget w in grid25.get_children()){
			w.set_halign(Align.END);
		}
		grid25.show_all();
	}

	public void updateKuh(){
	//Tabellenansicht aktualisieren
		double kgts = 0;
		mittel sMittel = mittel();
		mittel eMittel = mittel();

		update();
		eMittel = ergebnis.fmMittel;
		sMittel = summe.fmMittel;
		ergebnis.auswertung.label1.set_text("Liter Milch");
		//Summe ausrechnen
		foreach (komponente k in grundFutter){
			kgts = k.fmMittel.TM * k.fmMittel.menge / 1000;
			k.auswertung.label7.set_text(doubleparse(k.fmMittel.NEL * kgts));
		}
		foreach (komponente k in kraftFutter){
			kgts = k.fmMittel.TM * k.fmMittel.menge / 1000;
			k.auswertung.label7.set_text(doubleparse(k.fmMittel.NEL * kgts));
		}
		//Summe anzeigen
		summe.auswertung.label7.set_text(doubleparse(sMittel.NEL));
		//Gehalt ausrechnen und anzeigen
		gehalt.auswertung.label7.set_text(doubleparse(sMittel.NEL/sMittel.TM));
		//Liter Milch ausrechnen
		if (bedarf.length >= 2){
			eMittel.XP = ((sMittel.XP - bedarf[0].fmMittel.XP) / bedarf[1].fmMittel.XP);
			eMittel.nXP = ((sMittel.nXP - bedarf[0].fmMittel.nXP) / bedarf[1].fmMittel.nXP);
			eMittel.NEL = ((sMittel.NEL - bedarf[0].fmMittel.NEL) / bedarf[1].fmMittel.NEL);
		}
		//Liter Milch anzeigen
		ergebnis.auswertung.label4.set_text(doubleparse(eMittel.XP));
		ergebnis.auswertung.label5.set_text(doubleparse(eMittel.nXP));
		ergebnis.auswertung.label6.set_text(doubleparse(sMittel.RNB / sMittel.TM));
		ergebnis.auswertung.label7.set_text(doubleparse(eMittel.NEL));
		bedarf[0].auswertung.label7.set_text(doubleparse(bedarf[0].fmMittel.NEL));
		bedarf[1].auswertung.label7.set_text(doubleparse(bedarf[1].fmMittel.NEL));
		ergebnis.fmMittel = eMittel;
		updateKuhListe();
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
		this.updateKuh();
		this.geaendert = 0;
	}

}	
