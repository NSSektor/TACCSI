//
//  MisLugares.m
//  TACCSI
//
//  Created by Angel Rivas on 8/26/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import "MisLugares.h"
#import "Reachability.h"
#import "MiCuenta.h"

extern NSString* GlobalUsu;
extern NSString* GlobalPass;
extern NSString* GlobalID;
extern NSString* GlobalNombre;
extern NSString* GlobalApaterno;
extern NSString* GlobalAmaterno;
extern NSString* GlobalTelefono;
extern NSString* GlobalCorreo;
extern NSString* documentsDirectory;
NSMutableArray* MAFavoritos;
extern NSString* lat_favorito;
extern NSString* lon_favorito;
extern NSString* direccion_favorito;
extern NSString* dispositivo;
extern BOOL actualizar_favorito;
extern BOOL usar_ubicacion_actual_favorito;

@interface MisLugares (){
    BOOL show_nuevo;
    BOOL ShowBuscar;
    NSMutableArray* MArrayLatitud;
    NSMutableArray* MArrayLongitud;
    NSMutableArray*MArrayDIreccion;
    BOOL Subir;
    CLLocationManager *locationManager;
    CLLocation *LocacionSeleccionada;
    CLLocation *mi_ubicacion;
    NSString* FileName;
    NSString* FileName_tem;
    NSInteger index_lugar;
    BOOL sin_favoritos;
    CGRect frame_contenedor_direccion;
    BOOL reachable;
}

@end

@implementation MisLugares

#pragma mark -
#pragma mark Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Add Observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    }
    
    return self;
}

#pragma mark -
#pragma mark Notification Handling
- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    
    if ([reachability isReachable]) {
        NSLog(@"Reachable");
        reachable = YES;
    } else {
        NSLog(@"Unreachable");
        reachable = NO;
    }
}

-(IBAction)setMap:(id)sender{
    switch(((UISegmentedControl*)sender).selectedSegmentIndex)
    
    {
        case 0:{
            mapView_.mapType = kGMSTypeNormal;
        }
            break;
        case 1:{
            mapView_.mapType = kGMSTypeHybrid;
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [txt_buscar addTarget:self action:@selector(Buscar:) forControlEvents:UIControlEventEditingDidBegin];
    [txt_buscar addTarget:self action:@selector(Buscar:) forControlEvents:UIControlEventEditingDidEnd];
    [txt_buscar addTarget:self action:@selector(Buscar:) forControlEvents:UIControlEventEditingChanged];
    [btn_regresar addTarget:self action:@selector(Regresar:) forControlEvents:UIControlEventTouchUpInside];
    [btn_nuevo addTarget:self action:@selector(Nuevo:) forControlEvents:UIControlEventTouchUpInside];
    [btn_cerrar_nuevos addTarget:self action:@selector(ShowNuevo:) forControlEvents:UIControlEventTouchUpInside];
    FileName = [NSString stringWithFormat:@"%@/%@_Favoritos.txt", documentsDirectory, GlobalID];
    FileName_tem = [NSString stringWithFormat:@"%@/%@_Favoritos_tem.txt", documentsDirectory, GlobalID];
    MAFavoritos = [[NSMutableArray alloc] initWithContentsOfFile:FileName];
    sin_favoritos = NO;
    if ([MAFavoritos count]==0 || MAFavoritos == nil || !MAFavoritos) {
        MAFavoritos = [[NSMutableArray alloc] init];
        [MAFavoritos addObject:@"Sin favoritos|||"];
        sin_favoritos = YES;
        txt_buscar_lugar.enabled = NO;
        //contents = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%@|%@|%@|%@|%@", NamePlace, lbl_calle_numero_destino.text, lbl_direccion_destino.text, lat_origen, lat_destino], nil];
    }
    actualizar_favorito = NO;
    btn_cancelar.hidden = YES;
    contenedor_tabla.hidden = YES;
    tbl_buscar.dataSource = self;
    tbl_buscar.delegate = self;
    txt_buscar_lugar.delegate = self;
    txt_buscar_lugar.clearButtonMode = UITextFieldViewModeWhileEditing;
    btn_cancelar_lugar.hidden = YES;
    txt_buscar.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_buscar.delegate = self;
    
    /*
    [txt_buscar addTarget:self action:@selector(ShowBuscar:) forControlEvents:UIControlEventEditingDidBegin];
    [txt_buscar addTarget:self action:@selector(ShowBuscar:) forControlEvents:UIControlEventEditingDidEnd];
    [txt_buscar addTarget:self action:@selector(ShowBuscar:) forControlEvents:UIControlEventEditingChanged];
    
    [ addTarget:self action:@selector(ShowBuscar:) forControlEvents:UIControlEventEditingDidBegin];
    [txt_buscar addTarget:self action:@selector(ShowBuscar:) forControlEvents:UIControlEventEditingDidEnd];
    [txt_buscar addTarget:self action:@selector(ShowBuscar:) forControlEvents:UIControlEventEditingChanged];*/
    
    txt_nombre_lugar.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_nombre_lugar.delegate = self;
    txt_referencias.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_referencias.delegate = self;
    ShowBuscar = NO;
    btn_cancelar.hidden = YES;
    [btn_cancelar addTarget:self action:@selector(CancelarBusqueda:) forControlEvents:UIControlEventTouchUpInside];
    [btn_buscar addTarget:self action:@selector(ShowBuscar:) forControlEvents:UIControlEventTouchUpInside];
    btn_buscar.hidden = YES;
    [btn_cancelar_lugar addTarget:self action:@selector(CancelarBusqueda_lugar:) forControlEvents:UIControlEventTouchUpInside];
    [btn_buscar_lugar addTarget:self action:@selector(IniciarBusquedaLugar:) forControlEvents:UIControlEventTouchUpInside];
    contenedor_tabla.hidden = YES;
    tbl_buscar.dataSource = self;
    tbl_buscar.delegate = self;
    txt_buscar.clearButtonMode = UITextFieldViewModeWhileEditing;
    [txt_buscar_lugar addTarget:self action:@selector(Buscar_lugar:) forControlEvents:UIControlEventEditingDidBegin];
    [txt_buscar_lugar addTarget:self action:@selector(Buscar_lugar:) forControlEvents:UIControlEventEditingChanged];
    [txt_buscar_lugar addTarget:self action:@selector(Buscar_lugar:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [txt_buscar addTarget:self action:@selector(Buscar:) forControlEvents:UIControlEventEditingDidBegin];
    [txt_buscar addTarget:self action:@selector(Buscar:) forControlEvents:UIControlEventEditingChanged];
    [txt_buscar addTarget:self action:@selector(Buscar:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    ShowBuscar = NO;
    [btn_regresar addTarget:self action:@selector(Regresar:) forControlEvents:UIControlEventTouchUpInside];
    [btn_cancelar addTarget:self action:@selector(CancelarBusqueda:) forControlEvents:UIControlEventTouchUpInside];
    [btn_buscar addTarget:self action:@selector(ShowBuscar:) forControlEvents:UIControlEventTouchUpInside];
    MArrayDIreccion = [[NSMutableArray alloc]initWithObjects:@"Sin resultados", nil];
    MArrayLatitud = [[NSMutableArray alloc]init];
    MArrayLongitud = [[NSMutableArray alloc]init];
    contenedor_invisible_direccion.hidden = YES;
    contenedor_direccion = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    [contenedor_nuevo addSubview:contenedor_direccion];
    
    GMSCameraPosition* camera = [GMSCameraPosition cameraWithLatitude:[@"19.64" doubleValue]
                                                            longitude:[@"-99.19" doubleValue]
                                                                 zoom:15];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, contenedor_mapa.frame.size.width, contenedor_mapa.frame.size.height) camera:camera];

 
    btn_mi_ubicacion = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 10, 40, 40)];
    [btn_mi_ubicacion addTarget:self action:@selector(UsarMiUbicacion:) forControlEvents:UIControlEventTouchUpInside];
    [btn_mi_ubicacion setImage:[UIImage imageNamed:@"mi_posicion"] forState:UIControlStateNormal];
    [contenedor_mapa addSubview:btn_mi_ubicacion];
    
    
    img_destino = [[UIImageView alloc] initWithFrame:CGRectMake(contenedor_mapa.frame.size.width/2 - 24, contenedor_mapa.frame.size.height /2 - 24, 48, 48)];
    img_destino.image = [UIImage imageNamed:@"home_map_mypos"];
    [contenedor_mapa addSubview:img_destino];
    
    
    [btn_buscar_direccion setBackgroundImage:[UIImage imageNamed:@"magnifier.png"] forState:UIControlStateNormal];
    [btn_buscar_direccion addTarget:self action:@selector(ShowBuscar:) forControlEvents:UIControlEventTouchUpInside];
    [btn_guardar addTarget:self action:@selector(Guardar:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *itemArray = [NSArray arrayWithObjects: @"Normal", @"Híbrido",  nil];
    sg_tipo_mapa = [[UISegmentedControl alloc] initWithItems:itemArray];
    sg_tipo_mapa.frame = CGRectMake(10, contenedor_mapa.frame.size.height - 34 , 150, 30);
    [sg_tipo_mapa addTarget:self action:@selector(setMap:) forControlEvents: UIControlEventValueChanged];
    sg_tipo_mapa.selectedSegmentIndex = 0;
    sg_tipo_mapa.tintColor = [UIColor darkGrayColor];
    sg_tipo_mapa.backgroundColor = [UIColor whiteColor];
    sg_tipo_mapa.selectedSegmentIndex = 0;
    sg_tipo_mapa.hidden = YES;
    contenedor_invisible_direccion = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contenedor_mapa.frame.size.width, contenedor_mapa.frame.size.height)];
    contenedor_invisible_direccion.backgroundColor = [UIColor clearColor];
    contenedor_invisible_direccion.hidden = YES;

    
    mapView_.delegate = self;
    
    [contenedor_mapa addSubview:mapView_];
    [contenedor_mapa addSubview:img_destino];
    [contenedor_mapa addSubview:sg_tipo_mapa];
    [contenedor_mapa addSubview:btn_mi_ubicacion];
    [contenedor_mapa addSubview:btn_buscar_direccion];
    [contenedor_mapa addSubview:contenedor_invisible_direccion];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    tbl_mis_lugares.delegate = self;
    tbl_mis_lugares.dataSource = self;
    txt_buscar.delegate = self;
    show_nuevo = false;
    contenedor_nuevo.hidden = YES;
}


-(IBAction)Regresar:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(IBAction)Nuevo:(id)sender{
    [txt_buscar_lugar resignFirstResponder];
    index_lugar = -1;
    actualizar_favorito = YES;
    [self UsarMiUbicacion:self];
    [self ShowNuevo:self];
}

-(IBAction)Buscar:(id)sender{
    
    contenedor_tabla.hidden = NO;
    btn_cancelar.hidden = NO;
    btn_buscar.hidden = YES;
    NSString* rawString = [NSString stringWithFormat:@"%@%@", @"México,", [txt_buscar text]];
    MArrayLatitud = [[NSMutableArray alloc]init];
    MArrayLongitud = [[NSMutableArray alloc]init];
    MArrayDIreccion = [[NSMutableArray alloc]init];
    
    if ([txt_buscar.text length] >= 4) {
        NSString *geocodingBaseUrl = @"http://maps.googleapis.com/maps/api/geocode/json?";
        NSString *url = [NSString stringWithFormat:@"%@address=%@&sensor=false", geocodingBaseUrl,rawString];
        url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSURL *queryUrl = [NSURL URLWithString:url];
        NSData *data = [NSData dataWithContentsOfURL: queryUrl];
        NSError* error;
        NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        NSArray* results = [json objectForKey:@"results"];
        NSLog(@"%lu", (unsigned long)[results count]);
        for (int i = 0; i<[results count]; i++) {
            NSDictionary *result = [results objectAtIndex:i];
            NSString* StringTemporal = [[result objectForKey:@"formatted_address"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *country = [result objectForKey:@"address_components"];
            NSString* prueba = [NSString stringWithFormat:@"%@", country];
            NSLog(@"%@", prueba);
            if ([prueba rangeOfString:@"MX"].location != NSNotFound) {
                NSLog(@"string does not contain bla");
                [MArrayDIreccion addObject:StringTemporal];
                NSDictionary *geometry = [result objectForKey:@"geometry"];
                NSDictionary *location = [geometry objectForKey:@"location"];
                [MArrayLatitud addObject:[location objectForKey:@"lat"]];
                [MArrayLongitud addObject:[location objectForKey:@"lng"]];
            }
            //         NSString *short_name = [country objectForKey:@"short_name"];
            
        }
    }
    
    if([MArrayDIreccion count]==0)
        [MArrayDIreccion addObject:@"Sin resultados"];
    [tbl_buscar reloadData];
}

-(IBAction)CancelarBusqueda:(id)sender{
    MArrayDIreccion = [[NSMutableArray alloc]initWithObjects:@"Sin resultados", nil];
    MArrayLatitud = [[NSMutableArray alloc]init];
    MArrayLongitud = [[NSMutableArray alloc]init];
    [tbl_buscar reloadData];
    [txt_buscar resignFirstResponder];
    txt_buscar.text = @"";
    contenedor_tabla.hidden = YES;
    btn_cancelar.hidden = YES;
    btn_buscar.hidden = NO;
}

-(IBAction)ShowBuscar:(id)sender{
    [txt_buscar becomeFirstResponder];
    contenedor_tabla.hidden = NO;
    btn_cancelar.hidden = NO;
    btn_buscar.hidden = YES;
}

-(IBAction)Buscar_lugar:(id)sender{
    if (!sin_favoritos) {
        btn_cancelar_lugar.hidden = NO;
        btn_buscar_lugar.hidden = YES;
        NSString* string_ = [MAFavoritos objectAtIndex:0];
        MAFavoritos = [[NSMutableArray alloc] initWithContentsOfFile:FileName];
        if ([MAFavoritos count]==0 || MAFavoritos == nil || !MAFavoritos) {
            MAFavoritos = [[NSMutableArray alloc] init];
            [MAFavoritos addObject:@"Sin favoritos||||"];
        }
        if (![string_ isEqualToString:@"Sin favoritos||||"]) {
            if ([txt_buscar_lugar.text length] >= 1) {
                
                NSMutableArray* MAFavoritos_tem = [[NSMutableArray alloc] init];
                for (int i = 0; i<[MAFavoritos count]; i++) {
                    NSArray* Array_  = [[MAFavoritos objectAtIndex:i] componentsSeparatedByString:@"|"];
                    if ([Array_ count] == 4) {
                        NSRange r = [[Array_ objectAtIndex:0] rangeOfString: txt_buscar_lugar.text options:NSCaseInsensitiveSearch];
                        if (r.length>0) {
                            [MAFavoritos_tem addObject:[MAFavoritos objectAtIndex:i]];
                        }
                    }
                }
                if ([MAFavoritos_tem count]>0 || MAFavoritos !=nil || MAFavoritos) {
                    [MAFavoritos_tem writeToFile:FileName_tem atomically:YES];
                }
                MAFavoritos = [[NSMutableArray alloc] initWithContentsOfFile:FileName_tem];
                if ([MAFavoritos count]==0 || MAFavoritos == nil || !MAFavoritos) {
                    MAFavoritos = [[NSMutableArray alloc] init];
                    [MAFavoritos addObject:@"Sin favoritos||||"];
                }
            }
            [tbl_mis_lugares reloadData];
        }
    }
}

-(IBAction)CancelarBusqueda_lugar:(id)sender{
    MAFavoritos = [[NSMutableArray alloc] initWithContentsOfFile:FileName];
    if ([MAFavoritos count]==0 || MAFavoritos == nil || !MAFavoritos) {
        MAFavoritos = [[NSMutableArray alloc] init];
        [MAFavoritos addObject:@"Sin favoritos||||"];
    }
    [tbl_mis_lugares reloadData];
    [txt_buscar_lugar resignFirstResponder];
    txt_buscar_lugar.text = @"";
    btn_cancelar_lugar.hidden = YES;
    btn_buscar_lugar.hidden = NO;
}

-(IBAction)IniciarBusquedaLugar:(id)sender{
    
    if (!sin_favoritos) {
        btn_cancelar_lugar.hidden = NO;
        btn_buscar_lugar.hidden = YES;
        [txt_buscar becomeFirstResponder];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger retorno = 0;
    if (tableView==tbl_mis_lugares)
        retorno = [MAFavoritos count];
    if (tableView==tbl_buscar)
        retorno = [MArrayDIreccion count];
    return retorno;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectNull];
    sectionHeader.backgroundColor = [UIColor groupTableViewBackgroundColor];
    sectionHeader.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    if (tableView==tbl_buscar)
        sectionHeader.text = [NSString stringWithFormat:@"  Resultados %@", @""];
    return sectionHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell  = nil;
    cell  = [tableView dequeueReusableCellWithIdentifier:@"celda"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"celda"];
    }
    
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    if (tableView==tbl_mis_lugares){
        
        NSArray* Array_ = [[NSArray alloc]init];
        NSString* string_ = [NSString stringWithFormat:@"%@", [MAFavoritos objectAtIndex:indexPath.row]];
        Array_  = [string_ componentsSeparatedByString:@"|"];
        NSString* title = @" Sin favoritos ";
        NSString* subtitle = @"";
       if ([Array_ count] == 4) {
           title = [Array_ objectAtIndex:0];
           subtitle = [NSString stringWithFormat:@"%@", [Array_ objectAtIndex:1]];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@", title];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        cell.textLabel.numberOfLines = 2;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", subtitle];
        cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        cell.detailTextLabel.numberOfLines = 2;
    }
    if (tableView==tbl_buscar){
        cell.textLabel.text = [MArrayDIreccion objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        cell.textLabel.numberOfLines = 2;
    }
    
    return cell;
    
}

#pragma mark - UITableViewDataSource

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==tbl_buscar) {
        NSLog(@"%@", MArrayLatitud);
        NSLog(@"%@", MArrayLongitud);
        NSString* direccion_ = [NSString stringWithFormat:@"%@", [[MArrayDIreccion objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        NSString* latitud_ = [MArrayLatitud objectAtIndex:indexPath.row];
        NSString* longitud_ = [MArrayLongitud objectAtIndex:indexPath.row];
        if (![direccion_ isEqualToString:@"Sin resultados"]) {
            GMSCameraPosition *sydney = [GMSCameraPosition cameraWithLatitude:[ latitud_ doubleValue] longitude:[ longitud_ doubleValue] zoom:mapView_.camera.zoom];
            [mapView_ setCamera:sydney];
            lat_favorito  = [MArrayLongitud objectAtIndex:indexPath.row];
            lon_favorito = [MArrayLongitud objectAtIndex:indexPath.row];
            [self CancelarBusqueda:self];
            actualizar_favorito = YES;
            [self BuscarDireccion];
        }
    }
    if (tableView == tbl_mis_lugares) {
        
        if (!sin_favoritos) {
            index_lugar = indexPath.row;
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Editar", @"Eliminar", nil];
            [actionSheet showInView:self.view];
        }
    }
    return indexPath;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        //Editar
        [txt_buscar resignFirstResponder];
        [txt_buscar_lugar resignFirstResponder];
        NSString* string_ = [NSString stringWithFormat:@"%@", [MAFavoritos objectAtIndex:index_lugar]];
        NSArray* Array_  = [string_ componentsSeparatedByString:@"|"];
        txt_nombre_lugar.text = [Array_ objectAtIndex:0];
        txt_referencias.text = [Array_ objectAtIndex:1];
        direccion_favorito = [Array_ objectAtIndex:1];
        lat_favorito = [Array_ objectAtIndex:2];
        lon_favorito = [Array_ objectAtIndex:3];
        actualizar_favorito = NO;
        GMSCameraPosition* camera = [GMSCameraPosition cameraWithLatitude:[lat_favorito doubleValue]
                                                                longitude:[lon_favorito doubleValue]
                                                                     zoom:mapView_.camera.zoom];
        [mapView_ setCamera:camera];
        [self ShowNuevo:self];

    }
    else if(buttonIndex==1){
        //Eliminar
        NSMutableArray* MAFavoritos_tem =  [[NSMutableArray alloc] init];
        for (int i = 0; i<[MAFavoritos count]; i++) {
            if (i != index_lugar)
                [MAFavoritos_tem addObject:[MAFavoritos objectAtIndex:i]];
        }
        [MAFavoritos_tem writeToFile:FileName atomically:YES];
        MAFavoritos = [[NSMutableArray alloc] initWithContentsOfFile:FileName];
        if ([MAFavoritos count]==0 || MAFavoritos == nil || !MAFavoritos)
            MAFavoritos = [[NSMutableArray alloc] initWithObjects:@"Sin favoritos||||", nil];
        sin_favoritos = YES;
        txt_buscar_lugar.enabled = NO;
        [tbl_mis_lugares reloadData];
        
    }
    else if (buttonIndex==2){
        //Vista Previa
        
    }
}

-(IBAction)ShowNuevo:(id)sender{
    
  /*  CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGRect frame_lugares = contenedor_lugares.frame;
    CGRect frame_nuevo = contenedor_nuevo.frame;*/
    
    if (contenedor_tabla.hidden == NO) {
        [self CancelarBusqueda:self];
    }
    else{
        if (show_nuevo == NO) {
            [txt_buscar resignFirstResponder];
            show_nuevo = YES;
            /* frame_lugares.origin.y = -768;
             if (screenSize.height < 481)
             frame_lugares.origin.y = -480;
             frame_nuevo.origin.y = 0;*/
            contenedor_lugares.hidden = YES;
            contenedor_nuevo.hidden = NO;
        }else{
            show_nuevo = NO;
            actualizar_favorito = NO;
            txt_buscar.text = @"";
            [txt_buscar resignFirstResponder];
            txt_nombre_lugar.text = @"";
            [txt_nombre_lugar resignFirstResponder];
            txt_referencias.text = @"";
            [txt_referencias resignFirstResponder];

            MArrayDIreccion = [[NSMutableArray alloc]initWithObjects:@"Sin resultados", nil];
            MArrayLatitud = [[NSMutableArray alloc]init];
            MArrayLongitud = [[NSMutableArray alloc]init];
            [tbl_buscar reloadData];
            contenedor_lugares.hidden =  NO;
            contenedor_nuevo.hidden = YES;
        }
    }
    
    
    
    
    /* [UIView beginAnimations:Nil context:nil];
     [UIView setAnimationDuration:0.2];
     contenedor_nuevo.frame = frame_nuevo;
     contenedor_lugares.frame = frame_lugares;
     [UIView commitAnimations];*/
    
}

#pragma mark - hidden keyboard



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    //  [self CancelarBusqueda:self];
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
    [self CancelarBusqueda:self];
}



-(void)BuscarDireccion{
    if (actualizar_favorito==YES) {
        txt_referencias.text = @"Buscando Dirección...";
        dispatch_queue_t myQueue = dispatch_queue_create("tecnologizame.TACCSI", 0);
        dispatch_async(myQueue, ^{
            CLGeocoder *geocoders = [[CLGeocoder alloc] init];
            [geocoders reverseGeocodeLocation:self->LocacionSeleccionada completionHandler:^(NSArray *placemarks, NSError *error) {
                //10
                if(placemarks.count){
                    NSDictionary *dictionary = [[placemarks objectAtIndex:0] addressDictionary];
                    txt_referencias.text = @"";
                    if ([dictionary objectForKey:@"Thoroughfare"]) {
                        txt_referencias.text = [NSString stringWithFormat:@"%@", [dictionary valueForKey:@"Thoroughfare"]];
                    }
                    if ([dictionary objectForKey:@"SubThoroughfare"]) {
                        txt_referencias.text = [NSString stringWithFormat:@"%@ %@", txt_referencias.text, [dictionary valueForKey:@"SubThoroughfare"]];
                    }
                    if ([dictionary objectForKey:@"SubLocality"]) {
                        txt_referencias.text = [NSString stringWithFormat:@"%@ %@", txt_referencias.text, [dictionary valueForKey:@"SubLocality"]];
                    }
                    if ([dictionary objectForKey:@"ZIP"]) {
                        txt_referencias.text = [NSString stringWithFormat:@"%@ %@", txt_referencias.text, [dictionary valueForKey:@"ZIP"]];
                    }
                    if ([dictionary objectForKey:@"State"]) {
                        txt_referencias.text = [NSString stringWithFormat:@"%@ %@", txt_referencias.text, [dictionary valueForKey:@"State"]];
                    }
                }
            }];
            
        });
        
    }
}



-(IBAction)UsarMiUbicacion:(id)sender{
    GMSCameraPosition *sydney = [GMSCameraPosition cameraWithLatitude:mi_ubicacion.coordinate.latitude
                                                            longitude:mi_ubicacion.coordinate.longitude
                                                                 zoom:mapView_.camera.zoom];
    [mapView_ setCamera:sydney];
    lat_favorito = [[NSNumber numberWithDouble:mi_ubicacion.coordinate.latitude] stringValue];
    lon_favorito = [[NSNumber numberWithDouble:mi_ubicacion.coordinate.longitude] stringValue];
    [self BuscarDireccion];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    mi_ubicacion = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude
                                              longitude:newLocation.coordinate.longitude];
    if ( usar_ubicacion_actual_favorito == YES) {
        GMSCameraPosition *sydney = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                                longitude:newLocation.coordinate.longitude
                                                                     zoom:mapView_.camera.zoom];
        [mapView_ setCamera:sydney];
        LocacionSeleccionada = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude
                                
                                                          longitude:newLocation.coordinate.longitude];
        lat_favorito = [[NSNumber numberWithDouble:newLocation.coordinate.latitude] stringValue];
        lon_favorito = [[NSNumber numberWithDouble:newLocation.coordinate.longitude] stringValue];
        usar_ubicacion_actual_favorito = NO;
        [self BuscarDireccion];
    }
}

#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture {
    [mapView clear];
}

- (void)mapView:(GMSMapView *)mapView
idleAtCameraPosition:(GMSCameraPosition *)cameraPosition {
    if (actualizar_favorito ==NO) {
        actualizar_favorito = YES;
        txt_referencias.text = direccion_favorito;
    }
    else{
        LocacionSeleccionada =
        [[CLLocation alloc] initWithLatitude:cameraPosition.target.latitude
                                   longitude:cameraPosition.target.longitude];
        // CLGeocoder *geocoders = [[CLGeocoder alloc] init];
        
        lat_favorito = [[NSNumber numberWithDouble:cameraPosition.target.latitude] stringValue];
        lon_favorito = [[NSNumber numberWithDouble:cameraPosition.target.longitude] stringValue];
        NSLog(@"Latitud Origen: %@,  Longitud Origen: %@", lat_favorito, lon_favorito);
        [self BuscarDireccion];
    }
    
}


-(IBAction)Guardar:(id)sender{
    
    NSString* error_ = @"";
    
    if ([[txt_referencias.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
        error_ = @"Debe existir una dirección valida";
        [txt_referencias becomeFirstResponder];
    }
    
    if ([error_ isEqualToString:@""]) {
        MAFavoritos = [[NSMutableArray alloc] initWithContentsOfFile:FileName];
        if ([MAFavoritos count]==0 || MAFavoritos == nil || !MAFavoritos) {
            MAFavoritos = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%@|%@|%@|%@", txt_nombre_lugar.text, txt_referencias.text, lat_favorito, lon_favorito], nil];
            [MAFavoritos writeToFile:FileName atomically:YES];
        }
        else{
            if (index_lugar>=0) {
                NSMutableArray* MAFavoritos_tem = [[NSMutableArray alloc] init];
                for (int i = 0; i<[MAFavoritos count]; i++) {
                    if (i != index_lugar) {
                        [MAFavoritos_tem addObject:[MAFavoritos objectAtIndex:i]];
                    }
                    else{
                         [MAFavoritos_tem addObject:[NSString stringWithFormat:@"%@|%@|%@|%@", txt_nombre_lugar.text, txt_referencias.text, lat_favorito, lon_favorito]];
                    }
                }
                [MAFavoritos_tem writeToFile:FileName atomically:YES];
                MAFavoritos = [[NSMutableArray alloc] initWithContentsOfFile:FileName];
            }
            else{
                [MAFavoritos addObject:[NSString stringWithFormat:@"%@|%@|%@|%@", txt_nombre_lugar.text, txt_referencias.text, lat_favorito, lon_favorito]];
                [MAFavoritos writeToFile:FileName atomically:YES];
            }
        }
        txt_buscar_lugar.enabled = YES;
        sin_favoritos = NO;
        [tbl_mis_lugares reloadData];
        [self ShowNuevo:self];
    }
    else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"TACCSI" message:error_ delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
}


- (NSUInteger)supportedInterfaceOrientations {
    
    NSUInteger retorno;
    //  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    retorno = UIInterfaceOrientationMaskPortrait;
    // else
    //   retorno = UIInterfaceOrientationMaskLandscape;
    return retorno;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
