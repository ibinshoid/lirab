using Sqlite;
using Gtk;
using lirab;

string datenVerzeichnis;
string uiVerzeichnis;
clirabDb lirabDb;
cmittelFenster mittelFenster;
crationFenster rationFenster;
chauptFenster hauptFenster;
causwertungFenster auswertungFenster;
//ceditRation editRation;
mittel aktMittel;
ration aktRation;
TreeStore treestore;
	
public static int main (string[] args) {
	datenVerzeichnis = Environment.get_user_config_dir();
	lirabDb = new clirabDb();

	//Nach .ui dateien suchen
	if(File.new_for_path(Path.get_dirname(FileUtils.read_link("/proc/self/exe"))+"/../ui").query_file_type(0) == FileType.DIRECTORY){
		uiVerzeichnis = Path.get_dirname(FileUtils.read_link("/proc/self/exe"))+"/../ui";
	}else if(File.new_for_path("/usr/local/share/lirab/ui").query_file_type(0) == FileType.DIRECTORY){
		uiVerzeichnis = "/usr/local/share/lirab/ui";
	}else if(File.new_for_path("/usr/share/lirab").query_file_type(0) == FileType.DIRECTORY){
		uiVerzeichnis = "/usr/share/lirab/ui";
	}else{print("FEHLER! Verzeichnis mit den ui-Dateien konnte nicht gefunden werden"); return 1;}
	Environment.set_current_dir(uiVerzeichnis);

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
	treestore = new TreeStore(6, typeof(int), typeof(string), typeof(double), typeof(double), typeof(double), typeof(double), typeof(double), -1);
	mittelFenster.mittelLesen();
	hauptFenster.mittelLesen();
	rationFenster.rationenLesen();
	hauptFenster.auswertungBauen();
	hauptFenster.window1.show_all();
	Gtk.main ();
    return 0;
}

public string doubleparse(double dble, int nk=2){
	string wert;
	string rueckwert;
	int punkt;
	wert = dble.to_string();
	if (wert.index_of(".") < 1){
		wert = wert + ".";	
	}
	wert = wert + "000";
	punkt = wert.index_of(".");
	wert =wert.substring(punkt + 1, 3);
	if (int.parse(wert.substring(wert.length - 1)) > 5){
		wert =(int.parse(wert.substring(0, wert.length - 1))+1).to_string();
	}
	wert = wert.substring(0, nk);
	if (nk > 0) {
		wert = "," + wert; 
	}
	rueckwert = dble.to_string().substring(0, punkt ) + wert;
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
		

