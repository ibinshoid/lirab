using Sqlite;
using Gtk;
using lirab;

const string localePfad = config.INSTALL_PATH + "/share/locale";
const string GETTEXT_PACKAGE = "lask";
const string version = config.LIRAB_VERSION;
string datenVerzeichnis;
string uiVerzeichnis;
int debuging=0;
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
	datenVerzeichnis = Environment.get_user_config_dir();
    #if Linux
            if(File.new_for_path(Path.get_dirname(FileUtils.read_link("/proc/self/exe"))+"/ui").query_file_type(0) == FileType.DIRECTORY){
                uiVerzeichnis = Path.get_dirname(FileUtils.read_link("/proc/self/exe"))+"/ui";
            }else if(File.new_for_path(config.INSTALL_PATH +"/share/lirab/ui").query_file_type(0) == FileType.DIRECTORY){
                uiVerzeichnis = config.INSTALL_PATH + "/share/lirab/ui";
            }else{
                err("Verzeichnis mit den ui-Dateien konnte nicht gefunden werden", 1);
                return 1;
            }
            Environment.set_current_dir(uiVerzeichnis);
    #elif Windows
                uiVerzeichnis = Environment.get_system_data_dirs()[Environment.get_system_data_dirs().length-2] + "\\lirab\\ui";
                Environment.set_current_dir(uiVerzeichnis);
    #endif

    foreach (string arg in args){
        if(arg == "--debug"){debuging=1;}
        if(arg == "--help"){
            stdout.printf(_(
"""Aufruf: lirab [Option]
Rationsberechnung für Linux

Optionen:
  --debug     gibt Debugmeldungen aus
  --version   zeigt die aktuelle Versionsnummer an
  --help      zeigt diese Hilfeseite an
"""));
            return 0;
        }
        if(arg == "--version"){
            print(_("LASK Version = " + version + "\n"));
            return 0;
        }
    }
	//Wenn Datenbank nicht da ist, dann erzeugen
	lirabDb = new clirabDb();
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

		

