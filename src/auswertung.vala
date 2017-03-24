using lirab;
using Sqlite;
using Gtk;
using Cairo;
using Pango;

public class causwertungFenster : GLib.Object{
    private Builder builder = new Builder.from_file("lirab.ui");
    private Window tmpfenster;
    public Window window6;
    private ScrolledWindow scrolledwindow10;
    private DrawingArea drawingarea1;
    private CheckButton checkbutton1;
    private CheckButton checkbutton2;
    private CheckButton checkbutton3;
    private CheckButton checkbutton4;
    private ToolButton toolbutton1;
    private ToolButton toolbutton2;
    private ToolButton toolbutton4;
    private ToolButton toolbutton5;
    private ToolButton toolbutton6;
    private Label label20;
    private int groesse = 0;
    private int seite = 0;     
    private int seiten = 0;     
    private int deckblatt = 1;
    private mittel[] blaetter = {};
	private ration rat;
    
    public causwertungFenster(ration r) {
    //Konstructor
		this.rat = r;
        builder.set_translation_domain ("lirab");
        builder.connect_signals (this);
        window6 = builder.get_object("window6") as Window;
        scrolledwindow10 = builder.get_object("scrolledwindow10") as ScrolledWindow;
        drawingarea1 = builder.get_object("drawingarea1") as DrawingArea;
        checkbutton1 = builder.get_object("checkbutton1") as CheckButton;
        checkbutton2 = builder.get_object("checkbutton2") as CheckButton;
        checkbutton3 = builder.get_object("checkbutton3") as CheckButton;
        checkbutton4 = builder.get_object("checkbutton4") as CheckButton;
        toolbutton1 = builder.get_object("toolbutton1") as ToolButton;
        toolbutton2 = builder.get_object("toolbutton2") as ToolButton;
        toolbutton4 = builder.get_object("toolbutton4") as ToolButton;
        toolbutton5 = builder.get_object("toolbutton5") as ToolButton;
        toolbutton6 = builder.get_object("toolbutton6") as ToolButton;
        label20 = builder.get_object("label20") as Label;
        //Ereignisse verbinden
        drawingarea1.draw.connect(maleSeite);
        toolbutton1.clicked.connect(vorherige_seite);
        toolbutton2.clicked.connect(naechste_seite);
        toolbutton4.clicked.connect(drucken);
        toolbutton5.clicked.connect(kleiner);
        toolbutton6.clicked.connect(groesser);
        checkbutton1.toggled.connect(aendern);
        checkbutton2.toggled.connect(aendern);
        checkbutton3.toggled.connect(aendern);
        checkbutton4.toggled.connect(aendern);
    }

    public void drucken(){
    //Drucken
        PrintSettings settings = null;
        PrintOperation printop;
        PrintOperationResult res;
        //Drucksystem initialisieren
        printop = new PrintOperation();
        printop.set_n_pages(seiten + 1 - auswertungFenster.deckblatt);
        printop.set_print_settings(settings);
        printop.draw_page.connect (print_pages);
        res = printop.run (PrintOperationAction.PRINT_DIALOG, auswertungFenster.tmpfenster);
//        res = printop.run (PrintOperationAction.PREVIEW, auswertungFenster.tmpfenster);
    }       
    
    public bool maleSeite(Cairo.Context cr){
    //Seite in Drawingarea malen    
        if (auswertungFenster.groesse == 1){
        //Groß
           if(scrolledwindow10.get_allocated_width() >= scrolledwindow10.get_allocated_height()/1.41){
                drawingarea1.set_size_request(scrolledwindow10.get_allocated_width() -20, int.parse(doubleparse(scrolledwindow10.get_allocated_width() * 1.41 -20, 0)));
                cr.scale((drawingarea1.get_allocated_width()-20)/1000.0, (drawingarea1.get_allocated_width()-20)/1000.0);
            }else{
                drawingarea1.set_size_request(int.parse(doubleparse(scrolledwindow10.get_allocated_height()/1410.0 -20)), scrolledwindow10.get_allocated_height()-20);
                cr.scale((drawingarea1.get_allocated_height()-20)/1410.0, (drawingarea1.get_allocated_height()-20)/1410.0);
			}
		}else{
        //Klein
           if((scrolledwindow10.get_allocated_width()-20) >= (scrolledwindow10.get_allocated_height()-20)/1.41){
                drawingarea1.set_size_request(int.parse(doubleparse(scrolledwindow10.get_allocated_height()/1.41 -20)), scrolledwindow10.get_allocated_height() -20);
                cr.scale((drawingarea1.get_allocated_height()-20)/1410.0, (drawingarea1.get_allocated_height()-20)/1410.0);
            }else{
                drawingarea1.set_size_request((scrolledwindow10.get_allocated_width() -20), int.parse(doubleparse((scrolledwindow10.get_allocated_width()-20)*1.41)));
                cr.scale((drawingarea1.get_allocated_width()-20)/1000.0, (drawingarea1.get_allocated_width()-20)/1000.0);
			}
		}
		draw_page((1000), seite, cr);
        auswertungFenster.label20.set_text(seite.to_string() + "/" + seiten.to_string());
		return true;
	}
	
	public void aendern(){
	//Auswertung zusammenbauen
		
		seiten = 0;
		blaetter.length = 0;
		//Soll Deckblatt geruckt werden?
		if (auswertungFenster.checkbutton1.get_active()){
           auswertungFenster.deckblatt = 0;
        }else{
           auswertungFenster.deckblatt = 1;
           if (auswertungFenster.seite == 0){
                auswertungFenster.seite = 1;
           }
        }
		//Sollen Futtermittel geruckt werden?
		if (auswertungFenster.checkbutton2.get_active()){
			foreach(mittel m in rat.grundKomponenten){
				blaetter += m;
			}
			foreach(mittel m in rat.kraftKomponenten){
				blaetter += m;
			}
		}
		//Soll Berechnung geruckt werden?
		if (auswertungFenster.checkbutton3.get_active()){
			blaetter += mittel(){art = "tabelle"};
		}
		seiten = blaetter.length;
		if (seite >= seiten){
			seite = seiten;
		}
		auswertungFenster.drawingarea1.queue_draw();

		//Soll Liste geruckt werden?
		if (auswertungFenster.checkbutton4.get_active()){
			blaetter += mittel(){art = "liste"};
		}
		seiten = blaetter.length;
		if (seite >= seiten){
			seite = seiten;
		}
		auswertungFenster.drawingarea1.queue_draw();
	}
	
    public void print_pages(PrintOperation printop, PrintContext context, int page_nr){
    //Holt Seiten von draw_page und gibt sie scalliert an Drucksystem weiter
        //Wenn ohne Deckblatt dann beginnt Seitennummer mit 1
        if(auswertungFenster.deckblatt == 1){
			page_nr += 1;
		}
        context.get_cairo_context().scale(context.get_width()/1000.0, context.get_width()/1000.0);
        auswertungFenster.draw_page(1000, page_nr, context.get_cairo_context());
    }

    public void groesser(){
    //In Seitenbreite einpassen
        auswertungFenster.groesse = 1;
        auswertungFenster.drawingarea1.queue_draw();
    }
    public void kleiner(){
    //In Seitenhöhe einpassen
        auswertungFenster.groesse = 0;
        auswertungFenster.drawingarea1.queue_draw();
    }
    public void naechste_seite(){
    //Eine Seite vor blättern
        if (auswertungFenster.seite < auswertungFenster.seiten){
            auswertungFenster.seite += 1;
        }        auswertungFenster.drawingarea1.queue_draw();
    }
 
    public void vorherige_seite(){
    //Eine Seite zurück blättern
        if (auswertungFenster.seite > auswertungFenster.deckblatt){
            auswertungFenster.seite -= 1;
        }
        auswertungFenster.drawingarea1.queue_draw();
    }

    public Cairo.Context draw_page(int breite, int page_nr, Cairo.Context context){
    //Seite zusammenbauen Cairo.Context
        int width = breite;
        int heigh = int.parse(doubleparse(width * 1.41, 0));
        var cr = context;
        var layout1 = Pango.cairo_create_layout (cr);
        int dpi = Pango.SCALE;

        layout1.set_alignment(Pango.Alignment.CENTER);
        layout1.set_width(breite*dpi);
        //Seite weiß malen
        cr.set_source_rgb (1, 1, 1);
        cr.rectangle(0, 0, width, heigh);
        cr.fill();
		//Seitennummer unten anzeigen
		if(page_nr <= 0){
			layout1.set_markup("Erstellt mit Lirab " + version, -1);
		}else{
			layout1.set_markup("Seite " + (page_nr).to_string() + " / " + seiten.to_string(), -1);
		}
		layout1.set_alignment(Pango.Alignment.CENTER);
		layout1.set_font_description(FontDescription.from_string("sans 10"));
		cr.move_to(0, heigh - 20);
		cairo_layout_path (cr, layout1);
		cr.set_source_rgb(0, 0.0, 0);
		cr.fill();
        if (page_nr == 0){
        // Deckblatt drucken
			draw_deckblatt(breite, cr);
		}else if(blaetter[page_nr -1].name != null) {
		//Futtermittel drucken
			draw_futtermittel(breite, cr, page_nr);
		}else if(blaetter[page_nr -1].art == "tabelle"){
		//Auswertung drucken
			draw_auswertung(breite, cr, page_nr);
		}else if(blaetter[page_nr -1].art == "liste"){
		//Auswertung drucken
			draw_liste(breite, cr, page_nr);
		}
		return cr;
	}
	
	private void draw_deckblatt(int breite, Cairo.Context cr){
        var layout1 = Pango.cairo_create_layout (cr);
        int dpi = Pango.SCALE;
 
        layout1.set_alignment(Pango.Alignment.CENTER);
        layout1.set_width(breite*dpi);
 
 		cr.set_source_rgb (0, 0, 0);
		cr.set_font_size(13);
		layout1.set_font_description(FontDescription.from_string("sans 25"));
        layout1.set_markup("<b><u>Ration:</u></b>", -1);
        cr.move_to(0, 80);
        cairo_layout_path (cr, layout1);
        layout1.set_markup("<b><u>" + rat.name + "</u></b>", -1);
        cr.move_to(0, 150);
        cairo_layout_path (cr, layout1);
        layout1.set_alignment(Pango.Alignment.RIGHT);
		layout1.set_font_description(FontDescription.from_string("sans 10"));
        layout1.set_markup("Druckdatum: " + new DateTime.now_local().format("%d.%m.%Y") + "   ", -1);
        cr.move_to(0, 20);
        cairo_layout_path (cr, layout1);
        cr.fill();
	}    

	private void draw_futtermittel(int breite, Cairo.Context cr, int page_nr){
		//Futtermittel drucken
        int dpi = Pango.SCALE;
		int zeilen = 5;
		int zeilenhoehe = 30;
		var layout2 = Pango.cairo_create_layout (cr);
        var layout1 = Pango.cairo_create_layout (cr);

        layout1.set_alignment(Pango.Alignment.CENTER);
        layout1.set_width(breite*dpi);
        layout2.set_width(breite*dpi);
        layout2.set_wrap(Pango.WrapMode.WORD);

		//Überschrift
		cr.set_source_rgb (0, 0, 0);
		layout1.set_font_description(FontDescription.from_string("sans 25"));
		layout1.set_markup(blaetter[page_nr -1].name, -1);
		cr.move_to(0, 60);
		cairo_layout_path (cr, layout1);
		cr.fill();
		layout1.set_font_description(FontDescription.from_string("sans 12"));
		layout1.set_markup("(" + blaetter[page_nr -1].art + ")", -1);
		cr.move_to(0, 100);
		cairo_layout_path (cr, layout1);
		cr.fill();
		
		//Inhaltsstoffe
		layout2.set_width(300 * dpi);
		layout2.set_alignment(Pango.Alignment.RIGHT);
		layout2.set_markup("Preis:", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].preis, 0) + " €/dt", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 2;
		
		layout2.set_width(300 * dpi);
		layout2.set_font_description(FontDescription.from_string("sans 12"));
		layout2.set_markup("Trockenmasse (TM):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].TM, 0) + " g/kg", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Rohfaser (RF):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].RF, 0) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Strukturwert (SW):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].SW, 0) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 2;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Eiweiß (XP):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].XP, 0) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Reineiweiß (rXP):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].rXP, 0) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("nutzbares Eiweiß (nXP):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].nXP, 0) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Stickstoffbilanz (RNB):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].RNB, 1) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("stabiles Eiweiß (UDP):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].UDP) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 2;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Netto-Energie-Laktation (NEL):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].NEL) + " MJ/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Umsetzbare Energie (ME):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].ME) + " MJ/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 2;

		layout2.set_width(300 * dpi);
		layout2.set_markup("Stärke (XS):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].XS, 0) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("stabile Stärke (bXS):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].bXS, 0) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Zucker (XZ):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].XZ, 0) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Rohfett (XL):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].XL, 0) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Cellulase (CL):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].CL, 0) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Rohasche (XA):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].XA, 0) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Gerüstsubstanz (NDF):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].NDF, 0) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("unverdauliche NDF (ADF):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].ADF, 0) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Organische NDF (NDFo):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].NDFo, 0) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Zucker+Stärke (NFC):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].NFC, 0) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Verdaulichkeit (ELOS):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].ELOS, 0) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 2;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Calzium (Ca):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].Ca, 1) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Phosphor (P):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].P, 1) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Magnesium (Mg):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].Mg, 1) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Natrium (Na):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].Na, 1) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Kalium (K):", -1);
		cr.move_to(200, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(blaetter[page_nr -1].K, 1) + " g/kg TM", -1);
		cr.move_to(500, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
 	}	

	private void draw_auswertung(int breite, Cairo.Context cr, int page_nr){
		//Auswertung drucken
        int dpi = Pango.SCALE;
		int zeilen = 0;
		int zeilenhoehe = 20;
        double kgts = 0;
        mittel sMittel = mittel();
		var layout2 = Pango.cairo_create_layout (cr);
        var layout1 = Pango.cairo_create_layout (cr);
 
        layout1.set_alignment(Pango.Alignment.CENTER);
        layout1.set_width(breite*dpi);
        layout2.set_width(breite*dpi);
        layout2.set_wrap(Pango.WrapMode.WORD);

		//Überschrift
		cr.set_source_rgb (0, 0, 0);
		layout1.set_font_description(FontDescription.from_string("sans 25"));
		layout1.set_markup("Auswertung: Tabelle", -1);
		cr.move_to(0, 60);
		cairo_layout_path (cr, layout1);
		cr.fill();
		//Auswertung
		layout2.set_font_description(FontDescription.from_string("sans 10"));
		layout2.set_markup("Futtermittel:", -1);
		cr.move_to(50, 200);
		cairo_layout_path (cr, layout2);
		layout2.set_markup("Menge (kg FM / TM):", -1);
		cr.move_to(200, 200);
		cairo_layout_path (cr, layout2);
		layout2.set_markup("XP (g):", -1);
		cr.move_to(380, 200);
		cairo_layout_path (cr, layout2);
		layout2.set_markup("nXP (g):", -1);
		cr.move_to(510, 200);
		cairo_layout_path (cr, layout2);
		layout2.set_markup("RNB (g):", -1);
		cr.move_to(640, 200);
		cairo_layout_path (cr, layout2);
		layout2.set_markup("NEL (MJ):", -1);
		cr.move_to(770, 200);
		cairo_layout_path (cr, layout2);
		cr.fill();
		cr.rectangle(40, 180, breite -80, 40);
		cr.stroke();
		zeilen = 12;
		//Grundfutter
		layout2.set_markup("<b><u>Grundfutter:</u></b>", -1);
		cr.move_to(50, zeilen*zeilenhoehe);
		cairo_layout_path (cr, layout2);
		zeilen +=1;
		cr.fill();
		foreach(mittel m in rat.grundKomponenten){
            kgts =m.menge * m.TM / 1000;
            layout2.set_markup(m.name, -1);
            cr.move_to(50, zeilen*zeilenhoehe);
            cairo_layout_path (cr, layout2);
             sMittel.menge += kgts;
            layout2.set_markup(doubleparse(m.menge) + " / " + doubleparse(kgts), -1);
            cr.move_to(250, zeilen*zeilenhoehe);
            cairo_layout_path (cr, layout2);
             sMittel.XP += m.XP * kgts;
            layout2.set_markup(doubleparse(m.XP * kgts), -1);
            cr.move_to(380, zeilen*zeilenhoehe);
            cairo_layout_path (cr, layout2);
             sMittel.nXP += m.nXP * kgts;
            layout2.set_markup(doubleparse(m.nXP * kgts), -1);
            cr.move_to(510, zeilen*zeilenhoehe);
            cairo_layout_path (cr, layout2);
             sMittel.RNB += m.RNB * kgts;
            layout2.set_markup(doubleparse(m.RNB * kgts), -1);
            cr.move_to(640, zeilen*zeilenhoehe);
            cairo_layout_path (cr, layout2);
             sMittel.NEL += m.NEL * kgts;
            layout2.set_markup(doubleparse(m.NEL * kgts), -1);
            cr.move_to(770, zeilen*zeilenhoehe);
            cairo_layout_path (cr, layout2);
            cr.fill();
			zeilen += 1;
		}
		//Kraftfutter
		zeilen += 1;
		layout2.set_markup("<b><u>Kraftfutter:</u></b>", -1);
		cr.move_to(50, zeilen*zeilenhoehe);
		cairo_layout_path (cr, layout2);
		zeilen +=1;
		cr.fill();
		foreach(mittel m in rat.kraftKomponenten){
            kgts =m.menge * m.TM / 1000;
            layout2.set_markup(m.name, -1);
            cr.move_to(50, zeilen*zeilenhoehe);
            cairo_layout_path (cr, layout2);
             sMittel.menge += kgts;
            layout2.set_markup(doubleparse(m.menge) + " / " + doubleparse(kgts), -1);
            cr.move_to(250, zeilen*zeilenhoehe);
            cairo_layout_path (cr, layout2);
             sMittel.XP += m.XP * kgts;
            layout2.set_markup(doubleparse(m.XP * kgts), -1);
            cr.move_to(380, zeilen*zeilenhoehe);
            cairo_layout_path (cr, layout2);
             sMittel.nXP += m.nXP * kgts;
            layout2.set_markup(doubleparse(m.nXP * kgts), -1);
            cr.move_to(510, zeilen*zeilenhoehe);
            cairo_layout_path (cr, layout2);
             sMittel.RNB += m.RNB * kgts;
            layout2.set_markup(doubleparse(m.RNB * kgts), -1);
            cr.move_to(640, zeilen*zeilenhoehe);
            cairo_layout_path (cr, layout2);
             sMittel.NEL += m.NEL * kgts;
            layout2.set_markup(doubleparse(m.NEL * kgts), -1);
            cr.move_to(770, zeilen*zeilenhoehe);
            cairo_layout_path (cr, layout2);
            cr.fill();
			zeilen += 1;
		}
		cr.rectangle(40, 220, breite -80, (zeilen - 10)* zeilenhoehe);
		cr.stroke();
		//Summe
		zeilen += 2;
		layout2.set_markup("Summe:", -1);
		cr.move_to(50, zeilen*zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_markup(doubleparse(sMittel.menge), -1);
		cr.move_to(250, zeilen*zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_markup(doubleparse(sMittel.XP), -1);
		cr.move_to(380, zeilen*zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_markup(doubleparse(sMittel.nXP), -1);
		cr.move_to(510, zeilen*zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_markup(doubleparse(sMittel.RNB), -1);
		cr.move_to(640, zeilen*zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_markup(doubleparse(sMittel.NEL), -1);
		cr.move_to(770, zeilen*zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		cr.rectangle(40, 220, breite -80, (zeilen - 10)* zeilenhoehe);
		cr.stroke();
		//Bedarf
		zeilen += 2;
		foreach(mittel m in rat.tierBedarf){
            kgts =m.menge * m.TM / 1000;
            layout2.set_markup(m.name, -1);
            cr.move_to(50, zeilen*zeilenhoehe);
            cairo_layout_path (cr, layout2);
            layout2.set_markup(doubleparse(m.XP * kgts), -1);
            cr.move_to(380, zeilen*zeilenhoehe);
            cairo_layout_path (cr, layout2);
            layout2.set_markup(doubleparse(m.nXP * kgts), -1);
            cr.move_to(510, zeilen*zeilenhoehe);
            cairo_layout_path (cr, layout2);
            layout2.set_markup(doubleparse(m.NEL * kgts), -1);
            cr.move_to(770, zeilen*zeilenhoehe);
            cairo_layout_path (cr, layout2);
            cr.fill();
			zeilen += 1;
		}
		cr.rectangle(40, 220, breite -80, (zeilen - 10)* zeilenhoehe);
		cr.stroke();
		//Milch
		zeilen += 2;
		layout2.set_markup("Liter Milch:", -1);
		cr.move_to(50, zeilen*zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_markup(doubleparse((sMittel.XP - rat.tierBedarf[0].XP) / rat.tierBedarf[1].XP), -1);
		cr.move_to(380, zeilen*zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_markup(doubleparse((sMittel.nXP - rat.tierBedarf[0].nXP) / rat.tierBedarf[1].nXP), -1);
		cr.move_to(510, zeilen*zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_markup(doubleparse((sMittel.NEL - rat.tierBedarf[0].NEL) / rat.tierBedarf[1].NEL), -1);
		cr.move_to(770, zeilen*zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		cr.rectangle(40, 220, breite -80, (zeilen - 10)* zeilenhoehe);
		cr.stroke();
	}

	private void draw_liste(int breite, Cairo.Context cr, int page_nr){
		//Liste drucken
        int dpi = Pango.SCALE;
		int zeilen = 5;
		int zeilenhoehe = 30;
		var layout2 = Pango.cairo_create_layout (cr);
        var layout1 = Pango.cairo_create_layout (cr);
 
        layout1.set_alignment(Pango.Alignment.CENTER);
        layout1.set_width(breite*dpi);
        layout2.set_width(breite*dpi);
        layout2.set_alignment(Pango.Alignment.RIGHT);
        layout2.set_wrap(Pango.WrapMode.WORD);

		//Überschrift
		cr.set_source_rgb (0, 0, 0);
		layout1.set_font_description(FontDescription.from_string("sans 25"));
		layout1.set_markup("Auswertung: Liste", -1);
		cr.move_to(0, 60);
		cairo_layout_path (cr, layout1);
		cr.fill();
		
		//Inhaltsstoffe
		layout2.set_width(300 * dpi);
		layout2.set_font_description(FontDescription.from_string("sans 12"));
		layout2.set_markup("Trockenmasse (TM):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().TM, 2) + " kg", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Rohfaser (RF):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().RF, 0) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().RF / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Strukturwert (SW):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().SW, 0) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().SW / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 2;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Eiweiß (XP):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().XP, 0) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().XP / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Reineiweiß (rXP):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().rXP, 0) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().rXP / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("nutzbares Eiweiß (nXP):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().nXP, 0) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().nXP / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Stickstoffbilanz (RNB):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().RNB, 1) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("stabiles Eiweiß (UDP):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().UDP) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().UDP / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 2;
		
		if(rat.art == "Milchkühe"){
			layout2.set_width(300 * dpi);
			layout2.set_markup("Netto-Energie-Laktation (NEL):", -1);
			cr.move_to(100, zeilen * zeilenhoehe);
			cairo_layout_path (cr, layout2);
			layout2.set_width(150 * dpi);
			layout2.set_markup(doubleparse(rat.get_summe().NEL) + " MJ/kg TM", -1);
			cr.move_to(400, zeilen * zeilenhoehe);
			cairo_layout_path (cr, layout2);
			cr.fill();
			zeilen += 2;
		}else{
			layout2.set_width(300 * dpi);
			layout2.set_markup("Umsetzbare Energie (ME):", -1);
			cr.move_to(100, zeilen * zeilenhoehe);
			cairo_layout_path (cr, layout2);
			layout2.set_width(150 * dpi);
			layout2.set_markup(doubleparse(rat.get_summe().ME) + " MJ/kg TM", -1);
			cr.move_to(400, zeilen * zeilenhoehe);
			cairo_layout_path (cr, layout2);
			cr.fill();
			zeilen += 2;
		}
		layout2.set_width(300 * dpi);
		layout2.set_markup("Stärke (XS):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().XS, 0) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().XS / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("stabile Stärke (bXS):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().bXS, 0) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().bXS / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Zucker (XZ):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().XZ, 0) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().XZ / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Rohfett (XL):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().XL, 0) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().XL / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Cellulase (CL):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().CL, 0) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().CL / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Rohasche (XA):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().XA, 0) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().XA / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Gerüstsubstanz (NDF):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().NDF, 0) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().NDF / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("unverdauliche NDF (ADF):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().ADF, 0) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().ADF / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Organische NDF (NDFo):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().NDFo, 0) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().NDFo / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Zucker+Stärke (NFC):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().NFC, 0) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().NFC / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Verdaulichkeit (ELOS):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().ELOS, 0) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().ELOS / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 2;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Calzium (Ca):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().Ca, 1) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().Ca / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Phosphor (P):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().P, 1) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().P / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Magnesium (Mg):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().Mg, 1) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().Mg / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Natrium (Na):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().Na, 1) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().Na / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
		layout2.set_width(300 * dpi);
		layout2.set_markup("Kalium (K):", -1);
		cr.move_to(100, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(150 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().K, 1) + " g/kg TM", -1);
		cr.move_to(400, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		layout2.set_width(100 * dpi);
		layout2.set_markup(doubleparse(rat.get_summe().K / rat.get_summe().TM / 10, 2) + " %", -1);
		cr.move_to(550, zeilen * zeilenhoehe);
		cairo_layout_path (cr, layout2);
		cr.fill();
		zeilen += 1;
		
	}

}
