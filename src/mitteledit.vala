using Gtk;
using lirab;

public class cmittelEdit {
	
	private Builder builder = new Builder.from_file("lirab.ui");
	public Window window5;
	private Button button12;
	private Button button13;
	private SpinButton spinbutton1;
	private SpinButton spinbutton2;
	private SpinButton spinbutton3;
	private SpinButton spinbutton4;
	private SpinButton spinbutton5;
	private SpinButton spinbutton6;
	private SpinButton spinbutton7;
	private SpinButton spinbutton8;
	private SpinButton spinbutton9;
	private SpinButton spinbutton10;
	private SpinButton spinbutton11;
	private SpinButton spinbutton12;
	private SpinButton spinbutton13;
	private SpinButton spinbutton14;
	private SpinButton spinbutton15;
	private SpinButton spinbutton16;
	private SpinButton spinbutton17;
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
	private SpinButton spinbutton28;
	private Entry entry2;
	private ComboBoxText comboboxtext2;

	public cmittelEdit() {	
	//Mittelfenster zusammenbauen
        builder.connect_signals (this);
		window5 = builder.get_object ("window5") as Window;
		button12 = builder.get_object("button12") as Button;
		button13 = builder.get_object("button13") as Button;
		spinbutton1  = builder.get_object("spinbutton1")  as SpinButton;
		spinbutton2  = builder.get_object("spinbutton2")  as SpinButton;
		spinbutton3  = builder.get_object("spinbutton3")  as SpinButton;
		spinbutton4  = builder.get_object("spinbutton4")  as SpinButton;
		spinbutton5  = builder.get_object("spinbutton5")  as SpinButton;
		spinbutton6  = builder.get_object("spinbutton6")  as SpinButton;
		spinbutton7  = builder.get_object("spinbutton7")  as SpinButton;
		spinbutton8  = builder.get_object("spinbutton8")  as SpinButton;
		spinbutton9  = builder.get_object("spinbutton9")  as SpinButton;
		spinbutton10 = builder.get_object("spinbutton10") as SpinButton;
		spinbutton11 = builder.get_object("spinbutton11") as SpinButton;
		spinbutton12 = builder.get_object("spinbutton12") as SpinButton;
		spinbutton13 = builder.get_object("spinbutton13") as SpinButton;
		spinbutton14 = builder.get_object("spinbutton14") as SpinButton;
		spinbutton15 = builder.get_object("spinbutton15") as SpinButton;
		spinbutton16 = builder.get_object("spinbutton16") as SpinButton;
		spinbutton17 = builder.get_object("spinbutton17") as SpinButton;
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
		spinbutton28 = builder.get_object("spinbutton28") as SpinButton;
		entry2 = builder.get_object("entry2") as Entry;
		comboboxtext2 = builder.get_object("comboboxtext2") as ComboBoxText;
		//Signale verbinden
		this.button13.clicked.connect(()=>{this.window5.hide();});
	}
	
	public mittel mittelErzeugen(){
	//neues Mittel machen
		MainLoop loop = new MainLoop ();
		MessageDialog dialog = null;
		int i = 0;
		
		this.window5.show();
		this.button12.clicked.connect(()=>{
			i = 0;
			foreach (mittel m in lirabDb.mittelLesen()){
				if (m.name == this.entry2.get_text() && m.art == this.comboboxtext2.get_active_text()) {
					dialog = new MessageDialog(this.window5,
												Gtk.DialogFlags.MODAL,
												Gtk.MessageType.WARNING,
												Gtk.ButtonsType.OK,
												"Ein Futtermittel mit diesem Namen gibt es schon!"
												);
					dialog.set_title("Hinweis");
					dialog.set_decorated(true);
					dialog.run();
					dialog.destroy();
					i = 1;
					break;
				}
			}
			if (i == 0){
				loop.quit();
			}
		});
		loop.run();
		this.window5.hide();
		return mittelBauen();
	}

	public mittel mittelBearbeiten(mittel aktMittel){
	//Mittel Bearbeiten Fenster füllen und zeigen
		Entry cbentry = this.comboboxtext2.get_child() as Entry;
		MainLoop loop = new MainLoop ();
		mittel m;
		
		cbentry.set_text(aktMittel.art);
		this.entry2.set_text(aktMittel.name);
		this.spinbutton2.set_value(aktMittel.TM);
		this.spinbutton3.set_value(aktMittel.preis);
		this.spinbutton4.set_value(aktMittel.RF);
		this.spinbutton5.set_value(aktMittel.SW);
		this.spinbutton6.set_value(aktMittel.XP);
		this.spinbutton7.set_value(aktMittel.rXP);
		this.spinbutton8.set_value(aktMittel.nXP);
		this.spinbutton9.set_value(aktMittel.RNB);
		this.spinbutton10.set_value(aktMittel.UDP);
		this.spinbutton11.set_value(aktMittel.NEL);
		this.spinbutton12.set_value(aktMittel.ME);
		this.spinbutton13.set_value(aktMittel.XS);
		this.spinbutton14.set_value(aktMittel.bXS);
		this.spinbutton15.set_value(aktMittel.XZ);
		this.spinbutton16.set_value(aktMittel.XL);
		this.spinbutton17.set_value(aktMittel.CL);
		this.spinbutton18.set_value(aktMittel.XA);
		this.spinbutton19.set_value(aktMittel.NDF);
		this.spinbutton20.set_value(aktMittel.ADF);
		this.spinbutton21.set_value(aktMittel.NDFo);
		this.spinbutton22.set_value(aktMittel.NFC);
		this.spinbutton23.set_value(aktMittel.ELOS);
		this.spinbutton24.set_value(aktMittel.Ca);
		this.spinbutton25.set_value(aktMittel.P);
		this.spinbutton26.set_value(aktMittel.Mg);
		this.spinbutton27.set_value(aktMittel.Na);
		this.spinbutton28.set_value(aktMittel.K);
		this.button12.set_label("Ändern");
		this.comboboxtext2.set_sensitive(false);
		this.window5.show();
		this.button12.clicked.connect(()=>{loop.quit();});
		loop.run();
		this.window5.hide();
		m = mittelBauen();
		m.id = aktMittel.id;
		m.menge = aktMittel.menge;
		return m;
	}
	
	public mittel mittelBauen(){
	//Futtermittel aus Werten bauen
		mittel fMittel = mittel();
		fMittel.id	 = -1;
		fMittel.name = this.entry2.get_text();
		fMittel.art  = this.comboboxtext2.get_active_text();
		fMittel.TM   = this.spinbutton2.get_value();
		fMittel.preis= this.spinbutton3.get_value();
		fMittel.RF   = this.spinbutton4.get_value();
		fMittel.SW   = this.spinbutton5.get_value();
		fMittel.XP   = this.spinbutton6.get_value();
		fMittel.rXP  = this.spinbutton7.get_value();
		fMittel.nXP  = this.spinbutton8.get_value();
		fMittel.RNB  = this.spinbutton9.get_value();
		fMittel.UDP  = this.spinbutton10.get_value();
		fMittel.NEL  = this.spinbutton11.get_value();
		fMittel.ME   = this.spinbutton12.get_value();
		fMittel.XS   = this.spinbutton13.get_value();
		fMittel.bXS  = this.spinbutton14.get_value();
		fMittel.XZ   = this.spinbutton15.get_value();
		fMittel.XL   = this.spinbutton16.get_value();
		fMittel.CL   = this.spinbutton17.get_value();
		fMittel.XA   = this.spinbutton18.get_value();
		fMittel.NDF  = this.spinbutton19.get_value();
		fMittel.ADF  = this.spinbutton20.get_value();
		fMittel.NDFo = this.spinbutton21.get_value();
		fMittel.NFC  = this.spinbutton22.get_value();
		fMittel.ELOS = this.spinbutton23.get_value();
		fMittel.Ca   = this.spinbutton24.get_value();
		fMittel.P    = this.spinbutton25.get_value();
		fMittel.Mg   = this.spinbutton26.get_value();
		fMittel.Na   = this.spinbutton27.get_value();
		fMittel.K    = this.spinbutton28.get_value();
		return fMittel;
	}
		

}
