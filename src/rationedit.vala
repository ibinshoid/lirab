using Gtk;
using lirab;

public class crationEdit {
	private Builder builder = new Builder.from_file("lirab.ui");
	public Window window2;
	private Button button5;
	private Entry entry1;
	private ComboBoxText comboboxtext1;
	private Grid grid14;
 	private	bedarf[] b = {};

	public crationEdit() {	
	//Rationfenster zusammenbauen
        builder.connect_signals (this);
		window2 = builder.get_object ("window2") as Window;
		button5 = builder.get_object ("button5") as Button;
		entry1 = builder.get_object ("entry1") as Entry;
		comboboxtext1 = builder.get_object ("comboboxtext1") as ComboBoxText;
		grid14 = builder.get_object ("grid14") as Grid;
		//Signale verbinden
		comboboxtext1.changed.connect(fensterBauen);
	}
	
	public ration rationErzeugen(){
	//neue Ration erzeugen
		MainLoop loop = new MainLoop ();
		MessageDialog dialog = null;
		int i = 0;
		
		this.fensterBauen();
		this.window2.show();
		this.button5.clicked.connect(()=>{
			i = 0;
			foreach (string r in lirabDb.rationenLesen()){
				if (r == this.entry1.get_text()) {
					dialog = new MessageDialog(this.window2,
												Gtk.DialogFlags.MODAL,
												Gtk.MessageType.WARNING,
												Gtk.ButtonsType.OK,
												"Eine Ration mit diesem Namen gibt es schon!"
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
		this.window2.hide();
	return rationBauen();
	}
	
	public ration rationBearbeiten(ration rat){
	//Ration bearbeiten
		MainLoop loop = new MainLoop ();
		Entry entry;
		int i = 0;
		ration r = rat;
		
        this.entry1.set_editable(false);
        this.entry1.set_has_frame(false);
        this.entry1.set_text(rat.name);
		this.comboboxtext1.set_button_sensitivity(SensitivityType.OFF);
        entry = this.comboboxtext1.get_child() as Entry;
        entry.set_text(rat.art);
		this.button5.set_label("Ändern");
		this.fensterBauen();
        foreach (mittel be in rat.tierBedarf){
	        this.b[i].spinbutton1.set_value(be.XP);
	        this.b[i].spinbutton2.set_value(be.nXP);
	        this.b[i].spinbutton3.set_value(be.NEL);
			i += 1;
		}
		this.window2.show();
		this.button5.clicked.connect(()=>{loop.quit();});
		loop.run();
		this.window2.hide();
		r.tierBedarf = rationBauen().tierBedarf[1:rationBauen().tierBedarf.length];
	return r;
	}
	
	public void fensterBauen(){
	//Grid14 füllen
		foreach (bedarf be in this.b){
			be.destroy();
		}
		this.b.length = 0;
		if(this.comboboxtext1.get_active_text() == "Milchkühe"){
			this.b += new bedarf("Bedarf zur Erhaltung", this.b.length);
			this.grid14.add(this.b[this.b.length - 1]);
			this.grid14.add(new Separator(Orientation.HORIZONTAL));
			this.b += new bedarf("Bedarf je Liter Milch", this.b.length);
			this.grid14.add(this.b[this.b.length - 1]);
		}else if(this.comboboxtext1.get_active_text() == "Färsen"){
			this.b += new bedarf("Bedarf", this.b.length);
			this.grid14.add(this.b[this.b.length - 1]);
			this.b[this.b.length - 1].label3.set_text("ME");
		}else if(this.comboboxtext1.get_active_text() == "Mastbullen"){
			this.b += new bedarf("Bedarf", this.b.length);
			this.grid14.add(this.b[this.b.length - 1]);
			this.b[this.b.length - 1].label3.set_text("ME");
		}
		grid14.show_all();
	}
	
	public ration rationBauen(){
	//Ration aus Werten bauen
        ration rat = ration();
        mittel[] m = {mittel()};

		rat.id = -1;
		rat.name = this.entry1.get_text();
		rat.art = this.comboboxtext1.get_active_text();
		rat.grundKomponenten = m;
		rat.kraftKomponenten = m;
		m.resize(0);
		m += new bedarf(rat.name, 0).tierBedarf;
		m[0].art = rat.art;
		m[0].menge = 1;
		foreach (bedarf be in this.b){
			be.tierBedarf.art = "Bedarf";
			m += be.tierBedarf;
		}
		rat.tierBedarf = m;
	return rat;
	}
}

