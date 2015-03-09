//
//  BuscarDestino.m
//  TACCSI
//
//  Created by Angel Rivas on 2/16/15.
//  Copyright (c) 2015 Tecnologizame. All rights reserved.
//

#import "BuscarDestino.h"
#import "Reachability.h"

extern NSString* lat_destino;
extern NSString* lon_destino;
extern BOOL usar_ubicacion_actual_destino;
extern BOOL actualizar_destino;
extern NSString* lat_destino;
extern NSString* lon_destino;
extern NSString* direccion_destino;
extern BOOL tengo_destino;


@interface BuscarDestino (){
    CLLocation *LocacionSeleccionada;
    CLLocation *mi_ubicacion;
    BOOL reachable;
    BOOL showBusqueda;
    NSMutableArray* MArrayLatitud;
    NSMutableArray* MArrayLongitud;
    NSMutableArray*MArrayDIreccion;
    BOOL actualizar_camera_x_lista;
}

@end

@implementation BuscarDestino

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
        reachable = YES;
    }else{
        reachable = NO;
    }
}
/*
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    actualizar_camera_x_lista = NO;
    MArrayDIreccion = [[NSMutableArray alloc]initWithObjects:@"", nil];
    MArrayLatitud = [[NSMutableArray alloc]init];
    MArrayLongitud = [[NSMutableArray alloc]init];
    
    contenedor_vista = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:contenedor_vista];
    
    ///NavigationBar
    navbar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    navbar.image = [UIImage imageNamed:@"home_navbar_bg"];
    //navbar.backgroundColor = [UIColor blackColor];
    [contenedor_vista addSubview:navbar];
    
    lbl_navbar = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 20)];
    lbl_navbar.text = @"TACCSI";
    lbl_navbar.textAlignment = NSTextAlignmentCenter;
    lbl_navbar.textColor = [UIColor blackColor];
    lbl_navbar.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    [contenedor_vista addSubview:lbl_navbar];
    
    btn_home_navbar = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, 18, 30)];
    [btn_home_navbar setImage:[UIImage imageNamed:@"icono_back_100x100"] forState:UIControlStateNormal];
    [btn_home_navbar addTarget:self action:@selector(Atras:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_vista addSubview:btn_home_navbar];
    
    contenedor_mapa = [[UIView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 110)];
    [contenedor_vista addSubview:contenedor_mapa];
    
    if ([lat_destino isEqualToString:@""] || [lon_destino isEqualToString:@""]) {
        usar_ubicacion_actual_destino = YES;
    }
    if (tengo_destino == YES) {
        actualizar_camera_x_lista = YES;
    }
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[lat_destino doubleValue]
                                                            longitude:[lon_destino doubleValue]
                                                                 zoom:15];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, contenedor_mapa.frame.size.width, contenedor_mapa.frame.size.height) camera:camera];
    mapView_.delegate = self;
    //  mapView_.myLocationEnabled = YES;
    [contenedor_mapa addSubview:mapView_];
    
    UIButton* btn_mi_posicion = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 10, 40, 40)];
    [btn_mi_posicion addTarget:self action:@selector(UsarMiUbicacion:) forControlEvents:UIControlEventTouchUpInside];
    [btn_mi_posicion setImage:[UIImage imageNamed:@"mi_posicion"] forState:UIControlStateNormal];
    [contenedor_mapa addSubview:btn_mi_posicion];
    
    img_destino = [[UIImageView alloc] initWithFrame:CGRectMake(contenedor_mapa.frame.size.width/2 - 24, contenedor_mapa.frame.size.height /2 - 24, 48, 48)];
    img_destino.image = [UIImage imageNamed:@"home_map_mypos"];
    [contenedor_mapa addSubview:img_destino];
    
    
    contenedor_direccion = [[UIView alloc] initWithFrame:CGRectMake(contenedor_mapa.frame.size.width/2 - 105 , contenedor_mapa.frame.size.height/2 - 84, 210, 60)];
    contenedor_direccion.backgroundColor = [UIColor clearColor];
    [contenedor_mapa addSubview:contenedor_direccion];
    
    btn_search = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn_search addTarget:self action:@selector(ShowBusqueda:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_direccion addSubview:btn_search];
    
    img_direccion = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, contenedor_direccion.frame.size.width, contenedor_direccion.frame.size.height)];
    img_direccion.image = [UIImage imageNamed:@"home_map_pin_detail_search"];
    [contenedor_direccion addSubview:img_direccion];
    
    lbl_direccion = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 150, 40)];
    lbl_direccion.text = @"Buscando dirección...";
    lbl_direccion.textAlignment = NSTextAlignmentCenter;
    lbl_direccion.textColor = [UIColor blackColor];
    lbl_direccion.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    lbl_direccion.numberOfLines = 3;
    [contenedor_direccion addSubview:lbl_direccion];
    
    tab_bar = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    tab_bar.image = [UIImage imageNamed:@"barra_menu_opciones"];
    [contenedor_vista addSubview:tab_bar];
    
    /*  */
    btn_home_map_check = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 38, self.view.frame.size.height - 90, 76, 76)];
    [btn_home_map_check addTarget:self action:@selector(UsarUbicacionDestino:) forControlEvents:UIControlEventTouchUpInside];
    [btn_home_map_check setImage:[UIImage imageNamed:@"confirmar_destino"] forState:UIControlStateNormal];
    [contenedor_vista addSubview:btn_home_map_check];
    
    contenedor_busqueda = [[UIView alloc] initWithFrame:CGRectMake(0, 60, contenedor_vista.frame.size.width, contenedor_vista.frame.size.height - 60)];
    contenedor_busqueda.backgroundColor = [UIColor whiteColor];
    [contenedor_vista addSubview:contenedor_busqueda];
    
    for (int i=0; i<10;i++) {
        UILabel* lbl =[[UILabel alloc]init];
        switch (i) {
            case 0:{lbl.frame = CGRectMake(0, 1, self.view.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 1:{lbl.frame = CGRectMake(0, 2, self.view.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1];}
                break;
            case 2:{lbl.frame = CGRectMake(15, 27, self.view.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 3:{lbl.frame = CGRectMake(15, 28, self.view.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1];}
                break;
            case 4:{lbl.frame = CGRectMake(15, 53, self.view.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 5:{lbl.frame = CGRectMake(15, 54, self.view.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1];}
                break;
            case 6:{lbl.frame = CGRectMake(15, 79, self.view.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 7:{lbl.frame = CGRectMake(15, 80, self.view.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1];}
                break;
            case 8:{lbl.frame = CGRectMake(0, 105, self.view.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 9:{lbl.frame = CGRectMake(0, 106, self.view.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1];}
                break;
                
            default:
                break;
        }
        [contenedor_busqueda addSubview:lbl];
    }
    
    txt_estado = [[UITextField alloc] initWithFrame:CGRectMake(10, 3, contenedor_busqueda.frame.size.width - 20, 24)];
    txt_estado.delegate = self;
    txt_estado.placeholder = @"Estado";
    txt_estado.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_estado.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    txt_estado.textAlignment = NSTextAlignmentCenter;
    [contenedor_busqueda addSubview:txt_estado];
    
    txt_municipio = [[UITextField alloc] initWithFrame:CGRectMake(10, 29, contenedor_busqueda.frame.size.width - 20, 24)];
    txt_municipio.delegate = self;
    txt_municipio.placeholder = @"Municipio o Delegación";
    txt_municipio.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_municipio.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    txt_municipio.textAlignment = NSTextAlignmentCenter;
    [contenedor_busqueda addSubview:txt_municipio];
    
    txt_cp = [[UITextField alloc] initWithFrame:CGRectMake(10, 56, contenedor_busqueda.frame.size.width - 20, 24)];
    txt_cp.delegate = self;
    txt_cp.placeholder = @"C.P.";
    txt_cp.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_cp.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    txt_cp.textAlignment = NSTextAlignmentCenter;
    [contenedor_busqueda addSubview:txt_cp  ];
    
    txt_calle = [[UITextField alloc] initWithFrame:CGRectMake(10, 81, contenedor_busqueda.frame.size.width - 20, 24)];
    txt_calle.delegate = self;
    txt_calle.placeholder = @"Calle";
    txt_calle.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_calle.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    txt_calle.textAlignment = NSTextAlignmentCenter;
    [contenedor_busqueda addSubview:txt_calle];
    
    //btn_busqueda = [[UIButton alloc] initWithFrame:CGRectMake(contenedor_busqueda.frame.size.width - contenedor_busqueda.frame.size.width + 20, 108, contenedor_busqueda.frame.size.width - 40, 35)];
    btn_busqueda = [[UIButton alloc] initWithFrame:CGRectMake(0, 110, contenedor_busqueda.frame.size.width / 2, 35)];
    [btn_busqueda setTitle:@"Buscar" forState:UIControlStateNormal];
    [btn_busqueda setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    btn_busqueda.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1];
    btn_busqueda.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    [btn_busqueda addTarget:self action:@selector(BuscaLugar:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_busqueda addSubview:btn_busqueda];
    
    btn_limpiar = [[UIButton alloc] initWithFrame:CGRectMake(contenedor_busqueda.frame.size.width / 2, 110, contenedor_busqueda.frame.size.width / 2, 35)];
    [btn_limpiar setTitle:@"Limpiar búsqueda" forState:UIControlStateNormal];
    [btn_limpiar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    btn_limpiar.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1];
    btn_limpiar.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    [btn_limpiar addTarget:self action:@selector(CancelarBusqueda:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_busqueda addSubview:btn_limpiar];
    
    
    tbl_buscar = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, contenedor_busqueda.frame.size.width, contenedor_busqueda.frame.size.height - 150)];
    tbl_buscar.delegate = self;
    tbl_buscar.dataSource = self;
    tbl_buscar.separatorColor = [UIColor clearColor];
    [contenedor_busqueda addSubview:tbl_buscar];
    
    actividad = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    actividad.color = [UIColor colorWithRed:254.0/255.0 green:214.0/255.0 blue:0.0/255.0 alpha:1.0];
    actividad.hidesWhenStopped = TRUE;
    CGRect newFrames = actividad.frame;
    newFrames.origin.x = (contenedor_busqueda.frame.size.width / 2) -13;
    newFrames.origin.y = (contenedor_busqueda.frame.size.height / 2) - 13;
    actividad.frame = newFrames;
    actividad.backgroundColor = [UIColor clearColor];
    actividad.hidden = YES;
    [contenedor_busqueda addSubview:actividad];
    
    contenedor_busqueda.hidden = YES;
    
        
        
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}

-(IBAction)UsarUbicacionDestino:(id)sender{
    tengo_destino = YES;
    [self Atras:self];
}

-(IBAction)Atras:(id)sender{
    if (!contenedor_busqueda.isHidden) {
        contenedor_busqueda.hidden = YES;
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(IBAction)ShowBusqueda:(id)sender{
    if ([contenedor_busqueda isHidden]){
        contenedor_busqueda.hidden = NO;
    }
    else{
        contenedor_busqueda.hidden = YES;
        [txt_calle resignFirstResponder];
        [txt_cp resignFirstResponder];
        [txt_estado resignFirstResponder];
        [txt_municipio resignFirstResponder];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(IBAction)BuscaLugar:(id)sender{
    
    NSString *address = [NSString stringWithFormat:@"México,%@,%@,%@,%@", txt_estado.text, txt_municipio.text, txt_calle.text, [txt_cp text]];
    
    btn_busqueda.enabled = NO;
    [txt_calle resignFirstResponder];
    [txt_cp resignFirstResponder];
    [txt_estado resignFirstResponder];
    [txt_calle resignFirstResponder];
    MArrayDIreccion = [[NSMutableArray alloc]init];
    MArrayLatitud = [[NSMutableArray alloc]init];
    MArrayLongitud = [[NSMutableArray alloc]init];
    actividad.hidesWhenStopped = TRUE;
    [actividad startAnimating];
    NSString *geocodingBaseUrl = @"http://maps.googleapis.com/maps/api/geocode/json?";
    NSString *url = [NSString stringWithFormat:@"%@address=%@&sensor=false", geocodingBaseUrl,address];
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
    btn_busqueda.enabled = YES;
    [actividad stopAnimating];
    [actividad hidesWhenStopped];
    if([MArrayDIreccion count]==0)
        [MArrayDIreccion addObject:@"Sin resultados"];
    [tbl_buscar reloadData];

}

-(IBAction)CancelarBusqueda:(id)sender{
    MArrayLatitud = [[NSMutableArray alloc]init];
    MArrayLongitud = [[NSMutableArray alloc]init];
    MArrayDIreccion = [[NSMutableArray alloc]init];
    [MArrayDIreccion addObject:@""];
    txt_calle.text = @"";
    [txt_calle resignFirstResponder];
    txt_cp.text = @"";
    [txt_cp resignFirstResponder];
    txt_estado.text= @"";
    [txt_estado resignFirstResponder];
    txt_municipio.text= @"";
    [txt_municipio resignFirstResponder];
    txt_calle.text = @"";
    [txt_calle resignFirstResponder];
    [tbl_buscar reloadData];
}

//Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger retorno = 0;
    if (tableView==tbl_buscar)
        retorno = [MArrayDIreccion count];
    return retorno;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectNull];
    sectionHeader.backgroundColor = [UIColor groupTableViewBackgroundColor];
    sectionHeader.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        sectionHeader.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    //sectionHeader.text = [NSString stringWithFormat:@"  Radio %d", section];
    if (tableView==tbl_buscar){
        sectionHeader.text = [NSString stringWithFormat:@"  Resultados %@", @""];
        /*if (con_favoritos==YES) {
            sectionHeader.text = [NSString stringWithFormat:@"  Favoritos %@", @""];
        }*/
    }
    return sectionHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell  = nil;
    cell  = [tableView dequeueReusableCellWithIdentifier:@"celda"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"celda"];
    }
    
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    if (tableView==tbl_buscar){
        cell.textLabel.text = [MArrayDIreccion objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        cell.textLabel.numberOfLines = 2;
    }
    
    return cell;
    
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==tbl_buscar) {
        NSString* direccion_ = [NSString stringWithFormat:@"%@", [[MArrayDIreccion objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if (![direccion_ isEqualToString:@""] &&  ![direccion_ isEqualToString:@"Sin resultados"]) {
            NSString* latitud_ = [MArrayLatitud objectAtIndex:indexPath.row];
            NSString* longitud_ = [MArrayLongitud objectAtIndex:indexPath.row];
            lbl_direccion.text = direccion_;
            GMSCameraPosition *sydney = [GMSCameraPosition cameraWithLatitude:[ latitud_ doubleValue] longitude:[ longitud_ doubleValue]
                                                                         zoom:mapView_.camera.zoom];
            [mapView_ setCamera:sydney];
            lat_destino  = [NSString stringWithFormat:@"%@", latitud_];
            lon_destino = [NSString stringWithFormat:@"%@", longitud_];
            direccion_destino = direccion_;
            actualizar_camera_x_lista = YES;
            [self CancelarBusqueda:self];
         //   [self BuscaDireccion];
            [self ShowBusqueda:self];
        }
    }
    return indexPath;
}


-(void)BuscaDireccion{
    CLGeocoder *geocoders = [[CLGeocoder alloc] init];
    [geocoders reverseGeocodeLocation:self->LocacionSeleccionada completionHandler:^(NSArray *placemarks, NSError *error) {
        lbl_direccion.text = @"Buscando Dirección...";
        if(placemarks.count){
            NSDictionary *dictionary = [[placemarks objectAtIndex:0] addressDictionary];
            lbl_direccion.text = @"";
            direccion_destino = @"";
            if ([dictionary objectForKey:@"Thoroughfare"]) {
                direccion_destino = [NSString stringWithFormat:@"%@", [dictionary valueForKey:@"Thoroughfare"]];
                lbl_direccion.text = [NSString stringWithFormat:@"%@", [dictionary valueForKey:@"Thoroughfare"]];
            }
            if ([dictionary objectForKey:@"SubThoroughfare"]) {
                direccion_destino = [NSString stringWithFormat:@"%@ %@", direccion_destino, [dictionary valueForKey:@"SubThoroughfare"]];
                lbl_direccion.text = [NSString stringWithFormat:@"%@ %@", lbl_direccion.text, [dictionary valueForKey:@"SubThoroughfare"]];
            }
            if ([dictionary objectForKey:@"SubLocality"]) {
                direccion_destino = [NSString stringWithFormat:@"%@ %@", direccion_destino, [dictionary valueForKey:@"SubLocality"]];
                lbl_direccion.text = [NSString stringWithFormat:@"%@ %@", lbl_direccion.text, [dictionary valueForKey:@"SubLocality"]];
            }
            if ([dictionary objectForKey:@"ZIP"]) {
                direccion_destino = [NSString stringWithFormat:@"%@ %@", direccion_destino, [dictionary valueForKey:@"ZIP"]];
                lbl_direccion.text = [NSString stringWithFormat:@"%@ %@", lbl_direccion.text, [dictionary valueForKey:@"ZIP"]];
            }
            if ([dictionary objectForKey:@"State"]) {
                direccion_destino = [NSString stringWithFormat:@"%@ %@", direccion_destino, [dictionary valueForKey:@"State"]];
                lbl_direccion.text = [NSString stringWithFormat:@"%@ %@", lbl_direccion.text, [dictionary valueForKey:@"State"]];
            }
        }
    }];
}

-(IBAction)UsarMiUbicacion:(id)sender{
    if (mi_ubicacion==nil) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
    }
    GMSCameraPosition *sydney = [GMSCameraPosition cameraWithLatitude:mi_ubicacion.coordinate.latitude
                                                            longitude:mi_ubicacion.coordinate.longitude
                                                                 zoom:mapView_.camera.zoom];
    [mapView_ setCamera:sydney];
    lat_destino = [[NSNumber numberWithDouble:mi_ubicacion.coordinate.latitude] stringValue];
    lon_destino = [[NSNumber numberWithDouble:mi_ubicacion.coordinate.longitude] stringValue];
    
    [self BuscaDireccion];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    mi_ubicacion = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude
                                              longitude:newLocation.coordinate.longitude];
    if (usar_ubicacion_actual_destino == YES) {
        usar_ubicacion_actual_destino = NO;
        GMSCameraPosition *sydney = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                                longitude:newLocation.coordinate.longitude
                                                                     zoom:mapView_.camera.zoom];
        [mapView_ setCamera:sydney];
        LocacionSeleccionada = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude
                                                          longitude:newLocation.coordinate.longitude];
        
        
        
        lat_destino = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
        lon_destino = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
        usar_ubicacion_actual_destino = NO;
        if (!actualizar_camera_x_lista) {
            [self BuscaDireccion];
        }
        else{
            actualizar_camera_x_lista = NO;
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture {
    /* if (mapView==mapView_) {
     [mapView clear];
     }*/
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    return NO;
}

- (void)mapView:(GMSMapView *)mapView
didTapInfoWindowOfMarker:(GMSMarker *)marker{
    
}


- (void)mapView:(GMSMapView *)mapView
idleAtCameraPosition:(GMSCameraPosition *)cameraPosition {
    if (actualizar_destino==NO) {
        actualizar_destino = YES;
        lbl_direccion.text = direccion_destino;
    }
    else{

        if (!actualizar_camera_x_lista) {
            LocacionSeleccionada =
            [[CLLocation alloc] initWithLatitude:cameraPosition.target.latitude
                                       longitude:cameraPosition.target.longitude];
            // CLGeocoder *geocoders = [[CLGeocoder alloc] init];
            
            lat_destino = [[NSNumber numberWithDouble:cameraPosition.target.latitude] stringValue];
            lon_destino = [[NSNumber numberWithDouble:cameraPosition.target.longitude] stringValue];
            NSLog(@"Latitud Origen: %@,  Longitud Origen: %@", lat_destino, lon_destino);
            [self BuscaDireccion];
        }
        else{
            actualizar_camera_x_lista = NO;
            LocacionSeleccionada =
            [[CLLocation alloc] initWithLatitude:[lat_destino doubleValue]
                                       longitude:[lon_destino doubleValue]];
            // CLGeocoder *geocoders = [[CLGeocoder alloc] init];
            if (![direccion_destino isEqualToString:@""]) {
                lbl_direccion.text = direccion_destino;
            }
        }
        
    }
}



#pragma mark - Set Orientation

- (NSUInteger)supportedInterfaceOrientations {
    
    NSUInteger retorno;
    //  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    retorno = UIInterfaceOrientationMaskPortrait;
    // else
    //   retorno = UIInterfaceOrientationMaskLandscape;
    return retorno;
}
@end
