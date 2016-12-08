using Gtk;

namespace lirab{
	public struct mittel{
		public int id ;
		public string name;
		public string art;
		public double menge;
		public double preis;
		public double TM;	//Trockenmasse
		public double RF;	//Rohfaser
		public double SW;	//Strukturwert
		public double XP;	//Eiweiß
		public double rXP;	//Reineiweiß
		public double nXP;	//nutzbares Eiweiß
		public double RNB;	//N-Bilanz
		public double UDP;	//Pansenstabiles Eiweiß
		public double NEL;	//Netto Energie Laktation
		public double ME;	//Metaboliche Energie
		public double XS;	//Stärke
		public double bXS;	//pansenstabile Stärke
		public double XZ;	//Zucker
		public double XL;	//Rohfett
		public double CL;	//Cellulase
		public double XA;	//Rohasche
		public double NDF;	//Gerüstsubstanzen
		public double ADF;	//unverdauliche NDF
		public double NDFo;	//organische NDF
		public double NFC;	//Zucker+Stärke
		public double ELOS;	//Verdaulichkeit
		public double Ca;	//Calzium
		public double P;	//Phosphor
		public double Mg;	//Magnesium
		public double Na;	//Natrium
		public double K;	//Kalium
	}
	
	public struct ration{
		public int id;
		public string name;
		public string art;
		public int tiere;
		public mittel[] grundKomponenten;
		public mittel[] kraftKomponenten;
		public mittel[] tierBedarf;
		
	}
	 
	public class eing:Grid{
	//Futterauswahl und -menge in der linken Spalte
		public signal void weg();
		public signal void anders();
		public Button button = new Button();
		public Button entf = new Button.from_icon_name("gtk-cancel", IconSize.MENU);
		public SpinButton spinbutton;
		public Adjustment adjustment;
		public CellRendererText cell;
		
		public eing(int id, string name){
			//Eingabe bauen
			this.spinbutton = new SpinButton.with_range(0, 10000,0.1);
			this.spinbutton.set_digits(2);
			this.button.set_label(name);
			this.button.set_hexpand(true);
			this.add(button);
			this.add(spinbutton);
			this.add(entf);
			this.entf.clicked.connect(()=>{weg();});
			this.spinbutton.value_changed.connect(()=>{anders();});
		}
	}

	public class ausw:Grid{
	//Auswertung anzeigen in der rechten Spalte
		public Label label1 = new Label("Name");
		public Label label2 = new Label("");
		public Label label3 = new Label("");
		public Label label4 = new Label("");
		public Label label5 = new Label("");
		public Label label6 = new Label("");
		public Label label7 = new Label("");
		public Label label8 = new Label("");
		public Label label9 = new Label("");
		public Label label10 = new Label("");
		
		public ausw(){
			//Auswertung bauen
			this.set_column_spacing(10);
			this.set_column_homogeneous(false);
			label1.set_width_chars(20);
			this.add(label1);
			label2.set_width_chars(10);
			this.add(label2);
			label3.set_width_chars(10);
			this.add(label3);
			label4.set_width_chars(10);
			this.add(label4);
			label5.set_width_chars(10);
			this.add(label5);
			label6.set_width_chars(10);
			this.add(label6);
			label7.set_width_chars(10);
			this.add(label7);
			label8.set_width_chars(10);
			this.add(label8);
			label9.set_width_chars(10);
			this.add(label9);
		}
	}
	
	public class komponente{
	//Eingabemodul und Auswertung plus Daten
		public signal void anders();
		public signal void weg(int pos);
		public eing eingabe;
		public ausw auswertung;
		public mittel fmMittel;
		public int wo;
		public double menge = 0;
		public int tiere = 1;
		public komponente(mittel mi, int pos){
		//Constructor
			wo = pos;
			fmMittel = mi;
			this.eingabe = new eing(0, mi.name);
			this.auswertung = new ausw();
			//Ereignisse verbinden
			this.eingabe.weg.connect(()=>{weg(wo);});
			this.eingabe.anders.connect(update);
			this.auswertung.label1.set_text(fmMittel.name);
		}
		
		~komponente(){
		//Destructor
			this.eingabe.destroy();
			this.auswertung.destroy();
		}
		
		public void update(){
			double kgts = 0;
			this.menge = this.eingabe.spinbutton.get_value();
			this.fmMittel.menge = this.eingabe.spinbutton.get_value() / this.tiere;
			kgts = fmMittel.TM * fmMittel.menge / 1000;
			this.auswertung.label1.set_text(fmMittel.name);
			this.auswertung.label2.set_text(doubleparse(fmMittel.TM * fmMittel.menge / 1000));
			this.auswertung.label3.set_text(doubleparse(fmMittel.RF * kgts));
			this.auswertung.label4.set_text(doubleparse(fmMittel.XP * kgts));
			this.auswertung.label5.set_text(doubleparse(fmMittel.nXP * kgts));
			this.auswertung.label6.set_text(doubleparse(fmMittel.RNB * kgts));
			this.auswertung.label7.set_text(doubleparse(fmMittel.NEL * kgts));
			anders();
		}
	}

	public class bedarf: Grid{
		// Bedarf eingeben und Widget
		public int wo;
		public mittel tierBedarf = mittel();
		private Label label0 = new Label("");
		private Label label1 = new Label("XP");
		private Label label2 = new Label("nXP");
		private Label label3 = new Label("NEL");
		public SpinButton spinbutton1 = new SpinButton.with_range(0,1000,1);
		public SpinButton spinbutton2 = new SpinButton.with_range(0,1000,1);
		public SpinButton spinbutton3 = new SpinButton.with_range(0,1000,1);
		
		public bedarf(string name, int pos){
			wo = pos;
			this.tierBedarf.name = name;
			label0.set_text(name);
			spinbutton1.set_digits(2);
			this.spinbutton1.changed.connect (() => {update();});
			spinbutton2.set_digits(2);
			this.spinbutton2.changed.connect (() => {update();});
			spinbutton3.set_digits(2);
			this.spinbutton3.changed.connect (() => {update();});
			this.set_column_spacing(10);
			this.set_row_spacing(10);
			this.set_hexpand(true);
			this.set_row_homogeneous(false);
			this.attach(label0, 0, 0, 4, 1);
			this.attach(label1, 0, 1, 1, 1);
			this.attach(spinbutton1, 1, 1, 1, 1);
			this.attach(label2, 2, 1, 1, 1);
			this.attach(spinbutton2, 3, 1, 1, 1);
			this.attach(label3, 0, 2, 1, 1);
			this.attach(spinbutton3, 1, 2, 1, 1);
			
		}
		public void update(){
			this.tierBedarf.XP  = spinbutton1.get_value();
			this.tierBedarf.nXP = spinbutton2.get_value();
			this.tierBedarf.NEL = spinbutton3.get_value();
		}
	}
}
