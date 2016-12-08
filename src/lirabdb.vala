using Sqlite;
using lirab;

public class clirabDb{
	private Database db;
	private int rc = 0;

		
	public void open(string dbdatei) {
	//Datenbank öffnen
        rc=db.open (dbdatei, out db);
		if ( rc == 1){
			stderr.printf("Can't open database: %s\n", db.errmsg ());
		}
	}
	
	public void betriebAnlegen(string dbdatei){
	//Neuen leeren Betrieb anlegen
		Statement stmt;
		var e = File.new_for_path(dbdatei);
		if (e.query_exists ()) {
            stderr.printf("Ein Betrieb mit diesem Namen existiert bereits");
        }	
        
		rc = db.open (dbdatei, out db);
		if ( rc == 1){
			stderr.printf("Datenbank konnte nicht angelegt werden: %s\n", db.errmsg ());
		}
		//Tabelle für Einstellungen anlegen
		rc = db.prepare_v2("CREATE TABLE IF NOT EXISTS config (id INTEGER PRIMARY KEY AUTOINCREMENT,
																name TEXT
																wert TEXT)" , -1, out stmt);
		rc = stmt.step();
		if ( rc == 1){
			stderr.printf("Datentabellen konnten nicht angelegt werden: %s\n", db.errmsg ());
		}
		//Tabelle für Futtermittel anlegen										
		rc = db.prepare_v2("CREATE TABLE IF NOT EXISTS futtermittel (id INTEGER PRIMARY KEY AUTOINCREMENT, 
																name TEXT, 
																art TEXT, 
																preis DOUBLE, 
																tm DOUBLE, 
																rf DOUBLE, 
																sw DOUBLE, 
																xp DOUBLE, 
																rxp DOUBLE, 
																nxp DOUBLE, 
																rnb DOUBLE, 
																nel DOUBLE,
																me DOUBLE,
																udp DOUBLE,
																xs DOUBLE,
																bxs DOUBLE,
																xz DOUBLE,
																xl DOUBLE,
																cl DOUBLE,
																xa DOUBLE,
																ndf DOUBLE,
																adf DOUBLE,
																ndfo DOUBLE,
																nfc DOUBLE,
																elos DOUBLE,
																ca DOUBLE,
																p DOUBLE,
																mg DOUBLE,
																na DOUBLE,
																k DOUBLE)" , -1, out stmt);
		rc = stmt.step();
		
		if ( rc == 1){
			stderr.printf("Datentabellen konnten nicht angelegt werden: %s\n", db.errmsg ());
		}
	}
	
	public void mittelHinzufuegen(mittel name){
	//Neues Mittel hinzufügen
		Statement stmt;
		string eid = "(SELECT 1 + max(id) FROM 'futtermittel')";

		//Wenn keine id mitgegeben wird nächstgrößere berechnen
		if (name.id >-1){
			eid = "'" + name.id.to_string() + "'";
		}
		
		rc = db.prepare_v2("INSERT INTO 'futtermittel' VALUES ("
							+ eid + ",'"
							+ name.name + "','"
							+ name.art + "','"
							+ name.preis.to_string() + "','"
							+ name.TM.to_string() + "','"
							+ name.RF.to_string() + "','"
							+ name.SW.to_string() + "','"
							+ name.XP.to_string() + "','"
							+ name.rXP.to_string() + "','"
							+ name.nXP.to_string() + "','"
							+ name.RNB.to_string() + "','"
							+ name.NEL.to_string() + "','"
							+ name.ME.to_string() + "','"
							+ name.UDP.to_string() + "','"
							+ name.XS.to_string() + "','"
							+ name.bXS.to_string() + "','"
							+ name.XZ.to_string() + "','"
							+ name.XL.to_string() + "','"
							+ name.CL.to_string() + "','"
							+ name.XA.to_string() + "','"
							+ name.NDF.to_string() + "','"
							+ name.ADF.to_string() + "','"
							+ name.NDFo.to_string() + "','"
							+ name.NFC.to_string() + "','"
							+ name.ELOS.to_string() + "','"
							+ name.Ca.to_string() + "','"
							+ name.P.to_string() + "','"
							+ name.Mg.to_string() + "','"
							+ name.Na.to_string() + "','"
							+ name.K.to_string() + "' )", -1, out stmt, null);
		rc = stmt.step();
		if ( rc != 0 ) {
			stderr.printf ("SQL error mittelHinzufuegen: %d, %s\n", rc, db.errmsg ());
			rc = 0;
		}
	}
	public mittel[] mittelLesen () {
	//Mittel aus Datenbank lesen
		Statement stmt;
		mittel[] Mittel = {};
		mittel rueckMittel = mittel();
		
		rc = db.prepare_v2("SELECT * from 'futtermittel'", -1, out stmt, null);
		if ( rc == 1 ) {
			stderr.printf ("SQL error mittelLesen: %d, %s\n", rc, db.errmsg ());
			rc = 0;
		}
		do {
			rc = stmt.step();
			switch ( rc ) {
			case Sqlite.DONE:
				break;
				case Sqlite.ROW:
					rueckMittel.id = stmt.column_int(0);
					rueckMittel.name = stmt.column_text(1);
					rueckMittel.art = stmt.column_text(2);
					rueckMittel.preis = stmt.column_double(3);
					rueckMittel.TM  = stmt.column_double(4);
					rueckMittel.RF  = stmt.column_double(5);
					rueckMittel.SW  = stmt.column_double(6);
					rueckMittel.XP  = stmt.column_double(7);
					rueckMittel.rXP = stmt.column_double(8);
					rueckMittel.nXP = stmt.column_double(9);
					rueckMittel.RNB = stmt.column_double(10);
					rueckMittel.NEL = stmt.column_double(11);
					rueckMittel.ME  = stmt.column_double(12);
					rueckMittel.UDP = stmt.column_double(13);
					rueckMittel.XS  = stmt.column_double(14);
					rueckMittel.bXS = stmt.column_double(15);
					rueckMittel.XZ  = stmt.column_double(16);
					rueckMittel.XL  = stmt.column_double(17);
					rueckMittel.CL  = stmt.column_double(18);
					rueckMittel.XA  = stmt.column_double(19);
					rueckMittel.NDF = stmt.column_double(20);
					rueckMittel.ADF = stmt.column_double(21);
					rueckMittel.NDFo= stmt.column_double(22);
					rueckMittel.NFC = stmt.column_double(23);
					rueckMittel.ELOS= stmt.column_double(24);
					rueckMittel.Ca  = stmt.column_double(25);
					rueckMittel.P   = stmt.column_double(26);
					rueckMittel.Mg  = stmt.column_double(27);
					rueckMittel.Na  = stmt.column_double(28);
					rueckMittel.K   = stmt.column_double(29);
					Mittel += rueckMittel;
					break;
				default:
					print("Fehler beim Lesen der Mittel \n");
					break;
				}
			} 
		while ( rc == Sqlite.ROW );
		return Mittel;	
		
	}

	public void mittelEntfernen(int mittelid){
	//Mittel entfernen
		Statement stmt;
		rc = db.prepare_v2("DELETE FROM 'futtermittel' WHERE id = '" + mittelid.to_string() + "'", -1, out stmt, null);
		rc = stmt.step();
		if ( rc == 1 ) {
			stderr.printf ("SQL error: %d, %s\n", rc, db.errmsg ());
			rc = 0;
		}
	}
	
	public void rationHinzufuegen(ration r){
	//Neue Ration hinzufügen
		Statement stmt;
		int rc = 0;
		int i = 0;
		
		if (r.name in lirabDb.rationenLesen()){
			print("Tabelle " + r.name +" gibts schon");
		}
		//Tabelle für Ration anlegen
		rc = db.prepare_v2("CREATE TABLE IF NOT EXISTS 'rat_" + r.name +  "' (id INTEGER PRIMARY KEY AUTOINCREMENT, 
																name TEXT, 
																art TEXT, 
																wo TEXT, 
																menge DOUBLE,
																preis DOUBLE,
																tm DOUBLE, 
																rf DOUBLE, 
																sw DOUBLE, 
																xp DOUBLE, 
																rxp DOUBLE, 
																nxp DOUBLE, 
																rnb DOUBLE, 
																nel DOUBLE,
																me DOUBLE,
																udp DOUBLE,
																xs DOUBLE,
																bxs DOUBLE,
																xz DOUBLE,
																xl DOUBLE,
																cl DOUBLE,
																xa DOUBLE,
																ndf DOUBLE,
																adf DOUBLE,
																ndfo DOUBLE,
																nfc DOUBLE,
																elos DOUBLE,
																ca DOUBLE,
																p DOUBLE,
																mg DOUBLE,
																na DOUBLE,
																k DOUBLE)" , -1, out stmt);
		rc = stmt.step();
		if ( rc != 0 ) {
			stderr.printf ("SQL error RationHinzufuegen: %d, %s\n", rc, db.errmsg ());
			rc = 0;
		}
		//Tierbedarf anlegen
		foreach (mittel m in r.tierBedarf){
			rc = db.prepare_v2("INSERT OR REPLACE INTO 'rat_" + r.name + "' VALUES ('"
								+ i.to_string() + "', '"
								+ m.name + "','"
								+ m.art + "','"
								+ "tierBedarf" + "','"
								+ m.menge.to_string() + "','"
								+ m.preis.to_string() + "','"
								+ m.TM.to_string() + "','"
								+ m.RF.to_string() + "','"
								+ m.SW.to_string() + "','"
								+ m.XP.to_string() + "','"
								+ m.rXP.to_string() + "','"
								+ m.nXP.to_string() + "','"
								+ m.RNB.to_string() + "','"
								+ m.NEL.to_string() + "','"
								+ m.ME.to_string() + "','"
								+ m.UDP.to_string() + "','"
								+ m.XS.to_string() + "','"
								+ m.bXS.to_string() + "','"
								+ m.XZ.to_string() + "','"
								+ m.XL.to_string() + "','"
								+ m.CL.to_string() + "','"
								+ m.XA.to_string() + "','"
								+ m.NDF.to_string() + "','"
								+ m.ADF.to_string() + "','"
								+ m.NDFo.to_string() + "','"
								+ m.NFC.to_string() + "','"
								+ m.ELOS.to_string() + "','"
								+ m.Ca.to_string() + "','"
								+ m.P.to_string() + "','"
								+ m.Mg.to_string() + "','"
								+ m.Na.to_string() + "','"
								+ m.K.to_string() + "' )", -1, out stmt, null);
			rc = stmt.step();

			if ( rc != 0 ) {
				stderr.printf ("SQL error BedarfHinzufuegen: %d, %s\n", rc, db.errmsg ());
				rc = 0;
			}
			i += 1;
		}
	}

	public void rationSpeichern(ration r){
	//Daten in Ration schreiben
		Statement stmt;
		rc = db.prepare_v2("DELETE FROM 'rat_" + r.name + "' WHERE id > 0", -1, out stmt, null);
		rc = stmt.step();
		if ( rc != 0 ) {
			stderr.printf ("SQL error BedarfHinzufuegen: %d, %s\n", rc, db.errmsg ());
			rc = 0;
		}
		//Tierzahl speichern
		rc = db.prepare_v2("UPDATE 'rat_" + r.name + "' SET menge = '" + r.tiere.to_string() + "' WHERE id = '0'", -1, out stmt, null);
		rc = stmt.step();
		foreach (mittel m in r.tierBedarf){
			rc = db.prepare_v2("INSERT INTO 'rat_" + r.name + "' VALUES (
								(SELECT 1 + max(id) FROM 'rat_" + r.name + "'),'"
								+ m.name + "','"
								+ m.art + "','"
								+ "tierBedarf" + "','"
								+ m.menge.to_string() + "','"
								+ m.preis.to_string() + "','"
								+ m.TM.to_string() + "','"
								+ m.RF.to_string() + "','"
								+ m.SW.to_string() + "','"
								+ m.XP.to_string() + "','"
								+ m.rXP.to_string() + "','"
								+ m.nXP.to_string() + "','"
								+ m.RNB.to_string() + "','"
								+ m.NEL.to_string() + "','"
								+ m.ME.to_string() + "','"
								+ m.UDP.to_string() + "','"
								+ m.XS.to_string() + "','"
								+ m.bXS.to_string() + "','"
								+ m.XZ.to_string() + "','"
								+ m.XL.to_string() + "','"
								+ m.CL.to_string() + "','"
								+ m.XA.to_string() + "','"
								+ m.NDF.to_string() + "','"
								+ m.ADF.to_string() + "','"
								+ m.NDFo.to_string() + "','"
								+ m.NFC.to_string() + "','"
								+ m.ELOS.to_string() + "','"
								+ m.Ca.to_string() + "','"
								+ m.P.to_string() + "','"
								+ m.Mg.to_string() + "','"
								+ m.Na.to_string() + "','"
								+ m.K.to_string() + "' )", -1, out stmt, null);
			rc = stmt.step();
			if ( rc != 0 ) {
				stderr.printf ("SQL error BedarfHinzufuegen: %d, %s\n", rc, db.errmsg ());
				rc = 0;
			}
		}
		foreach (mittel m in r.grundKomponenten){
			rc = db.prepare_v2("INSERT INTO 'rat_" + r.name + "' VALUES (
								(SELECT 1 + max(id) FROM 'rat_" + r.name + "'),'"
								+ m.name + "','"
								+ m.art + "','"
								+ "grundKomponenten" + "','"
								+ m.menge.to_string() + "','"
								+ m.preis.to_string() + "','"
								+ m.TM.to_string() + "','"
								+ m.RF.to_string() + "','"
								+ m.SW.to_string() + "','"
								+ m.XP.to_string() + "','"
								+ m.rXP.to_string() + "','"
								+ m.nXP.to_string() + "','"
								+ m.RNB.to_string() + "','"
								+ m.NEL.to_string() + "','"
								+ m.ME.to_string() + "','"
								+ m.UDP.to_string() + "','"
								+ m.XS.to_string() + "','"
								+ m.bXS.to_string() + "','"
								+ m.XZ.to_string() + "','"
								+ m.XL.to_string() + "','"
								+ m.CL.to_string() + "','"
								+ m.XA.to_string() + "','"
								+ m.NDF.to_string() + "','"
								+ m.ADF.to_string() + "','"
								+ m.NDFo.to_string() + "','"
								+ m.NFC.to_string() + "','"
								+ m.ELOS.to_string() + "','"
								+ m.Ca.to_string() + "','"
								+ m.P.to_string() + "','"
								+ m.Mg.to_string() + "','"
								+ m.Na.to_string() + "','"
								+ m.K.to_string() + "' )", -1, out stmt, null);
			rc = stmt.step();
			if ( rc != 0 ) {
				stderr.printf ("SQL error BedarfHinzufuegen: %d, %s\n", rc, db.errmsg ());
				rc = 0;
			}
		}
		foreach (mittel m in r.kraftKomponenten){
			rc = db.prepare_v2("INSERT INTO 'rat_" + r.name + "' VALUES (
								(SELECT 1 + max(id) FROM 'rat_" + r.name + "'),'"
								+ m.name + "','"
								+ m.art + "','"
								+ "kraftKomponenten" + "','"
								+ m.menge.to_string() + "','"
								+ m.preis.to_string() + "','"
								+ m.TM.to_string() + "','"
								+ m.RF.to_string() + "','"
								+ m.SW.to_string() + "','"
								+ m.XP.to_string() + "','"
								+ m.rXP.to_string() + "','"
								+ m.nXP.to_string() + "','"
								+ m.RNB.to_string() + "','"
								+ m.NEL.to_string() + "','"
								+ m.ME.to_string() + "','"
								+ m.UDP.to_string() + "','"
								+ m.XS.to_string() + "','"
								+ m.bXS.to_string() + "','"
								+ m.XZ.to_string() + "','"
								+ m.XL.to_string() + "','"
								+ m.CL.to_string() + "','"
								+ m.XA.to_string() + "','"
								+ m.NDF.to_string() + "','"
								+ m.ADF.to_string() + "','"
								+ m.NDFo.to_string() + "','"
								+ m.NFC.to_string() + "','"
								+ m.ELOS.to_string() + "','"
								+ m.Ca.to_string() + "','"
								+ m.P.to_string() + "','"
								+ m.Mg.to_string() + "','"
								+ m.Na.to_string() + "','"
								+ m.K.to_string() + "' )", -1, out stmt, null);
			rc = stmt.step();
			if ( rc != 0 ) {
				stderr.printf ("SQL error BedarfHinzufuegen: %d, %s\n", rc, db.errmsg ());
				rc = 0;
			}
		}

	}
	
	public string[] rationenLesen(){
	//Rationen aus Datenbank lesen
		Statement stmt;
		string[] rationen = {};
	
        rc = db.prepare_v2("SELECT name from sqlite_master where type='table' order by name", -1, out stmt, null);
        if ( rc == 1 ) {
            stderr.printf ("SQL error rationenLesen: %d, %s\n", rc, db.errmsg ());
            rc = 0;
        }
        do {
            rc = stmt.step();
            switch ( rc ) {
            case Sqlite.DONE:
                break;
            case Sqlite.ROW:
                if (stmt.column_text(0)[0:4] == "rat_"){
                    rationen += stmt.column_text(0).substring(4);
                }
                break;
            default:
                print("Fehler beim Einlesen der Rationen");
                break;
            }
        } 
        while ( rc == Sqlite.ROW );
        return rationen;
    
		
	}
		

	public ration rationLesen(string name){
	//Ration aus Datenbank lesen
		Statement stmt;
		mittel[] tierBedarf = {};
		mittel[] grundKomponenten = {};
		mittel[] kraftKomponenten = {};
		ration rueckRation = ration();
		mittel tmpMittel = mittel();
		
		rc = db.prepare_v2("SELECT * from 'rat_" + name + "'", -1, out stmt, null);
		if ( rc == 1 ) {
			stderr.printf ("SQL error mittelLesen: %d, %s\n", rc, db.errmsg ());
			rc = 0;
		}
		do {
			rc = stmt.step();
			switch ( rc ) {
			case Sqlite.DONE:
				break;
			case Sqlite.ROW:
				if (stmt.column_int(0) == 0){
					rueckRation.name = stmt.column_text(1);
					rueckRation.art = stmt.column_text(2);
					rueckRation.tiere = stmt.column_int(4);
				}else{
					tmpMittel.id = stmt.column_int(0);
					tmpMittel.name = stmt.column_text(1);
					tmpMittel.art = stmt.column_text(2);
					tmpMittel.menge = stmt.column_double(4);
					tmpMittel.preis = stmt.column_double(5);
					tmpMittel.TM  = stmt.column_double(6);
					tmpMittel.RF  = stmt.column_double(7);
					tmpMittel.SW  = stmt.column_double(8);
					tmpMittel.XP  = stmt.column_double(9);
					tmpMittel.rXP = stmt.column_double(10);
					tmpMittel.nXP = stmt.column_double(11);
					tmpMittel.RNB = stmt.column_double(12);
					tmpMittel.NEL = stmt.column_double(13);
					tmpMittel.ME  = stmt.column_double(14);
					tmpMittel.UDP = stmt.column_double(15);
					tmpMittel.XS  = stmt.column_double(16);
					tmpMittel.bXS = stmt.column_double(17);
					tmpMittel.XZ  = stmt.column_double(18);
					tmpMittel.XL  = stmt.column_double(19);
					tmpMittel.CL  = stmt.column_double(20);
					tmpMittel.XA  = stmt.column_double(21);
					tmpMittel.NDF = stmt.column_double(22);
					tmpMittel.ADF = stmt.column_double(23);
					tmpMittel.NDFo= stmt.column_double(24);
					tmpMittel.NFC = stmt.column_double(25);
					tmpMittel.ELOS= stmt.column_double(26);
					tmpMittel.Ca  = stmt.column_double(27);
					tmpMittel.P   = stmt.column_double(28);
					tmpMittel.Mg  = stmt.column_double(29);
					tmpMittel.Na  = stmt.column_double(30);
					tmpMittel.K   = stmt.column_double(31);
					if(stmt.column_text(3) == "tierBedarf"){
						tierBedarf += tmpMittel;
					}else if(stmt.column_text(3) == "grundKomponenten"){
						grundKomponenten += tmpMittel;
					}else if(stmt.column_text(3) == "kraftKomponenten"){
						kraftKomponenten += tmpMittel;
					}
				}
				break;
			default:
				print("Fehler beim Lesen der Ration \n");
				break;
			}
		} 
		while ( rc == Sqlite.ROW );
		rueckRation.tierBedarf = tierBedarf;
		rueckRation.grundKomponenten = grundKomponenten;
		rueckRation.kraftKomponenten = kraftKomponenten;
		return rueckRation;	
	}
	
	public void rationEntfernen(string ration){
	    //Feld entfernen

        Statement stmt;
        rc = db.prepare_v2("DROP TABLE IF EXISTS 'rat_" + ration + "'", -1, out stmt, null);
        rc = stmt.step();
        if ( rc == 1 ) {
            stderr.printf ("SQL error: %d, %s\n", rc, db.errmsg ());
            rc = 0;
        }

	
	}
	
}
