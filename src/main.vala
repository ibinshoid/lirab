using Sqlite;
using Gtk;
using lirab;

const string version = "0.3";
string datenVerzeichnis;
string uiVerzeichnis;
clirabDb lirabDb;
cmittelFenster mittelFenster;
cmittelEdit mittelEdit;
crationFenster rationFenster;
crationEdit rationEdit;
chauptFenster hauptFenster;
causwertungFenster auswertungFenster;
//ceditRation editRation;
mittel aktMittel;
ration aktRation;
TreeStore treestore;
	
public static int main (string[] args) {
	lirabDb = new clirabDb();
	datenVerzeichnis = Environment.get_user_config_dir();
#if Linux
		if(File.new_for_path(Path.get_dirname(FileUtils.read_link("/proc/self/exe"))+"/ui").query_file_type(0) == FileType.DIRECTORY){
			uiVerzeichnis = Path.get_dirname(FileUtils.read_link("/proc/self/exe"))+"/ui";
		}else if(File.new_for_path("/usr/local/share/lirab/ui").query_file_type(0) == FileType.DIRECTORY){
			uiVerzeichnis = "/usr/local/share/lirab/ui";
		}else if(File.new_for_path("/usr/share/lirab").query_file_type(0) == FileType.DIRECTORY){
			uiVerzeichnis = "/usr/share/lirab/ui";
		}else{print("FEHLER! Verzeichnis mit den ui-Dateien konnte nicht gefunden werden"); return 1;}
		Environment.set_current_dir(uiVerzeichnis);
#elif Windows
			Environment.set_current_dir(Environment.get_system_data_dirs()[Environment.get_system_data_dirs().length-2] + "\\lirab\\ui");
#endif


	//Wenn Datenbank nicht da ist, dann erzeugen
	if(File.new_for_path(datenVerzeichnis + "/lirab.sqlite").query_exists()){
	}else{
		lirabDb.betriebAnlegen(datenVerzeichnis + "/lirab.sqlite");
	}
	lirabDb.open(datenVerzeichnis + "/lirab.sqlite");
	aktRation.id = -1;
	Gtk.init (ref args);
	mittelFenster = new cmittelFenster();
	hauptFenster = new chauptFenster();
	rationFenster = new crationFenster();
	mittelFenster.mittelLesen();
	hauptFenster.mittelLesen();
	rationFenster.rationenLesen();
	hauptFenster.window1.show_all();
	rationFenster.window4.show_all();
	Gtk.main ();
    return 0;
}

public string doubleparse(double dble, int nk=2){
    string wert;
	string rueckwert;
	wert = GLib.Math.round(dble * (Math.pow(10, nk))).to_string();
	if(wert.length <= nk-1){
		wert = GLib.Math.round(dble * (Math.pow(10, nk + 1))).to_string();
		wert += string.nfill(nk - wert.length, '0');
		rueckwert = wert.splice(-nk, -nk, "0,");
	}else if(wert.length == nk){
		rueckwert = wert.splice(-nk, -nk, "0,");
	}else{
		rueckwert = wert.splice(-nk, -nk, ",");
	}
	if(nk == 0){
		rueckwert= GLib.Math.round(dble).to_string();
	}
	return rueckwert;
}

public double sWert(double[] darr){
	double summe = 0;
	foreach (double d in darr){
		summe += d;
	}
	return summe;
}
public double mWert(double[] darr){
	double summe = 0;
	int i = 0;
	foreach (double d in darr){
		summe += d;
		i += 1;
	}
	return summe / i;
}

public int getTreeViewId(TreeView tv){
    int i = 0;
    TreeIter iter;
    TreeSelection selection;
    GLib.Value wert;
    TreeModel model;
	
	selection = tv.get_selection();
    var rows = selection.get_selected_rows(out model);
	foreach(TreePath a in rows){
		model.get_iter(out iter, a);
		model.get_value(iter, 0, out wert);
		i = wert.get_int();
	}
return i;
}
public string getTreeViewName(TreeView tv){
    string i = "";
    TreeIter iter;
    TreeSelection selection;
    GLib.Value wert;
    TreeModel model;
	
	selection = tv.get_selection();
    var rows = selection.get_selected_rows(out model);
	foreach(TreePath a in rows){
		model.get_iter(out iter, a);
		model.get_value(iter, 1, out wert);
		i = wert.get_string();
	}
	return i;
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

		

