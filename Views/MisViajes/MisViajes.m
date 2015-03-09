//
//  MisViajes.m
//  TACCSI
//
//  Created by Angel Rivas on 3/2/15.
//  Copyright (c) 2015 Tecnologizame. All rights reserved.
//

#import "MisViajes.h"
#import "SimpleTableCell.h"

extern NSString* GlobalString;
extern NSString* GlobalID;
extern NSString* dispositivo;

@interface MisViajes ()

@end

@implementation MisViajes{
    SYSoapTool *soapTool;
    NSMutableArray* MAid_viaje;
    NSMutableArray* MAtaccsista;
    NSMutableArray* MAfecha;
    NSMutableArray* MAvehiculo;
    NSMutableArray* MAmonto;
    NSMutableArray* MAorigen;
    NSMutableArray* MAlat_origen;
    NSMutableArray* MAlon_origen;
    NSMutableArray* MAdestino;
    NSMutableArray* MAlat_destino;
    NSMutableArray* MAlon_destino;
    NSMutableArray* MApuntos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    ///NavigationBar
    
    self.view.backgroundColor = [UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1.0];
    
    navbar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    navbar.image = [UIImage imageNamed:@"home_navbar_bg"];
    //navbar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:navbar];
    
    lbl_navbar = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 20)];
    lbl_navbar.text = @"Mis viajes";
    lbl_navbar.textAlignment = NSTextAlignmentCenter;
    lbl_navbar.textColor = [UIColor blackColor];
    lbl_navbar.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    [self.view addSubview:lbl_navbar];
    
    btn_home_navbar = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, 18, 30)];
    [btn_home_navbar setImage:[UIImage imageNamed:@"icono_back_100x100"] forState:UIControlStateNormal];
    [btn_home_navbar addTarget:self action:@selector(Atras:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_home_navbar];
    
    
    contenedor_viajes = [[UIView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height -60)];
    [self.view addSubview:contenedor_viajes];
    
    tbl_viajes = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, contenedor_viajes.frame.size.width, contenedor_viajes.frame.size.height) style:UITableViewStylePlain];
    [contenedor_viajes addSubview:tbl_viajes];
    tbl_viajes.separatorColor = [UIColor blackColor];
    tbl_viajes.backgroundColor = [UIColor clearColor];
    tbl_viajes.dataSource = self;
    tbl_viajes.delegate = self;
    
    contenedor_mi_viaje = [[UIView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height -60)];
    contenedor_mi_viaje.backgroundColor = [UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1.0];
    [self.view addSubview:contenedor_mi_viaje];
    contenedor_mi_viaje.hidden = YES;
    
    lbl_fecha_viaje = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contenedor_mi_viaje.frame.size.width, 20)];
    lbl_fecha_viaje.textColor = [UIColor whiteColor];
    lbl_fecha_viaje.backgroundColor = [UIColor blackColor];
    lbl_fecha_viaje.textAlignment = NSTextAlignmentCenter;
    [contenedor_mi_viaje addSubview:lbl_fecha_viaje];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-[@"19.99" doubleValue]
                                                            longitude:[@"-99.99" doubleValue]
                                                                 zoom:15];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 20, contenedor_mi_viaje.frame.size.width, contenedor_mi_viaje.frame.size.height- 90) camera:camera];
    [contenedor_mi_viaje addSubview:mapView_];
    
    lbl_nombre_taccsista = [[UILabel alloc] initWithFrame:CGRectMake(10, contenedor_mi_viaje.frame.size.height - 70, ((contenedor_mi_viaje.frame.size.width / 3) *2) -10 , 20)];
    lbl_nombre_taccsista.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    [contenedor_mi_viaje addSubview:lbl_nombre_taccsista];
    
    lbl_vehiculo_taccsista = [[UILabel alloc] initWithFrame:CGRectMake(10, contenedor_mi_viaje.frame.size.height - 45, ((contenedor_mi_viaje.frame.size.width / 3) *2) -10  , 20)];
    lbl_vehiculo_taccsista.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    [contenedor_mi_viaje addSubview:lbl_vehiculo_taccsista];
    
    img_calificacion_viaje = [[UIImageView alloc] initWithFrame:CGRectMake(10, contenedor_mi_viaje.frame.size.height - 25, 55 , 10)];
    img_calificacion_viaje.image = [UIImage imageNamed:@"extrellas_15_10px"];
    [contenedor_mi_viaje addSubview:img_calificacion_viaje];
    
    lbl_calificacion_viaje = [[UILabel alloc] initWithFrame:CGRectMake((contenedor_mi_viaje.frame.size.width / 3) + 20, contenedor_mi_viaje.frame.size.height - 30, (contenedor_mi_viaje.frame.size.width / 3) , 20)];
    lbl_calificacion_viaje.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    [contenedor_mi_viaje addSubview:lbl_calificacion_viaje];
    
    lbl_monto = [[UILabel alloc] initWithFrame:CGRectMake((contenedor_mi_viaje.frame.size.width / 3) *2, contenedor_mi_viaje.frame.size.height - 50,  (contenedor_mi_viaje.frame.size.width / 3), 40)];
    lbl_monto.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    [contenedor_mi_viaje addSubview:lbl_monto];
    
    actividad = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    actividad.color = [UIColor colorWithRed:254.0/255.0 green:214.0/255.0 blue:0.0/255.0 alpha:1.0];
    actividad.hidesWhenStopped = TRUE;
    CGRect newFrames = actividad.frame;
    newFrames.origin.x = (self.view.frame.size.width / 2) -13;
    newFrames.origin.y = (self.view.frame.size.height / 2) - 13;
    actividad.frame = newFrames;
    actividad.backgroundColor = [UIColor clearColor];
    actividad.hidden = YES;
    [self.view addSubview:actividad];
    
    soapTool = [[SYSoapTool alloc]init];
    soapTool.delegate = self;
    
    MAid_viaje = [[NSMutableArray alloc] init];
    MAtaccsista = [[NSMutableArray alloc] init];
    MAfecha = [[NSMutableArray alloc] init];
    MAvehiculo = [[NSMutableArray alloc] init];
    MAmonto = [[NSMutableArray alloc] init];
    MAorigen = [[NSMutableArray alloc] init];
    MAlat_origen = [[NSMutableArray alloc] init];
    MAlon_origen = [[NSMutableArray alloc] init];
    MAdestino = [[NSMutableArray alloc] init];
    MAlat_destino = [[NSMutableArray alloc] init];
    MAlon_destino = [[NSMutableArray alloc] init];
    MApuntos = [[NSMutableArray alloc] init];
    
    NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"id_usuario", nil];
    NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:GlobalID, nil, nil];
    [soapTool callSoapServiceWithParameters__functionName:@"historico_usuario" tags:tags vars:vars wsdlURL:@"http://201.131.96.45/wbs/wbs_taccsi.php?wsdl"];
    [self Animacion:1];
    
}

-(IBAction)Atras:(id)sender{
    
    if (!contenedor_mi_viaje.isHidden) {
        contenedor_mi_viaje.hidden = YES;
    }
    else{
       [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)Animacion:(int)Code{
    if (Code==1) {
        btn_home_navbar.enabled = NO;
        actividad.hidesWhenStopped = TRUE;
        [actividad startAnimating];
    }
    else {
        btn_home_navbar.enabled = YES;
        [actividad stopAnimating];
        [actividad hidesWhenStopped];
    }
}

#pragma mark - SySoapTool

-(void)retriveFromSYSoapTool:(NSMutableArray *)_data{
    StringCode = @"";
    StringMsg = @"";
    StringCode = @"-10";
    StringMsg = @"Error en la conexión al servidor";
    NSData* data = [GlobalString dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    if(![parser parse]){
        NSLog(@"Error al parsear");
    }
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}

#pragma mark - XML

-(void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"The XML document is now being parsed.");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"Parse error: %ld", (long)[parseError code]);
    [self FillArray];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    //Store the name of the element currently being parsed.
    currentElement = [elementName copy];
    
    //Create an empty mutable string to hold the contents of elements
    currentElementString = [NSMutableString stringWithString:@""];
    
    //Empty the dictionary if we're parsing a new status element
    if ([elementName isEqualToString:@"Response"]) {
        [currentElementData removeAllObjects];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //Take the string inside an element (e.g. <tag>string</tag>) and save it in a property
    [currentElementString appendString:string];
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"code"]){
        StringCode = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    if ([elementName isEqualToString:@"msg"])
        StringMsg = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([elementName isEqualToString:@"id_viaje"])
        [MAid_viaje addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"taccsista"])
        [MAtaccsista addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"fecha"])
        [MAfecha addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"vehiculo"])
        [MAvehiculo addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"monto"])
        [MAmonto addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"origen"])
        [MAorigen addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"lat_origen"])
        [MAlat_origen addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"lon_origen"])
        [MAlon_origen addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"destino"])
        [MAdestino addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"lat_destino"])
        [MAlat_destino addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"lon_destino"])
        [MAlon_destino addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"puntos"])
        [MApuntos addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    //Document has been parsed. It's time to fire some new methods off!
    [self FillArray];
}

-(void)FillArray{
    
    [self Animacion:2];
    if ([StringCode integerValue]<0) {
        [MAtaccsista addObject:StringMsg];
        [MAid_viaje addObject:@""];
        [MAfecha addObject:@""];
        [MAvehiculo addObject:@""];
        [MAmonto addObject:@""];
        [MAorigen addObject:@""];
        [MAlat_origen addObject:@""];
        [MAlon_origen addObject:@""];
        [MAdestino addObject:@""];
        [MAlat_destino addObject:@""];
        [MAlon_destino addObject:@""];
        [MApuntos addObject:@""];
    }
    else{
        if ([MAid_viaje count] == 0) {
            [MAtaccsista addObject:@"Sin viajes"];
            [MAid_viaje addObject:@""];
            [MAfecha addObject:@""];
            [MAvehiculo addObject:@""];
            [MAmonto addObject:@""];
            [MAorigen addObject:@""];
            [MAlat_origen addObject:@""];
            [MAlon_origen addObject:@""];
            [MAdestino addObject:@""];
            [MAlat_destino addObject:@""];
            [MAlon_destino addObject:@""];
            [MApuntos addObject:@""];
        }
    }
    [tbl_viajes reloadData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger retorno = 0;
    if (tableView == tbl_viajes){
        retorno = [MAid_viaje count];
    }
    return retorno;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"TableCell";
    SimpleTableCell *cell;
    if (tableView == tbl_viajes) {
        cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSString* NibName = @"SimpleTableCell";
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NibName owner:self options:nil];
            cell = [nib objectAtIndex:9];
            if ([dispositivo isEqualToString:@"iPhone6"])
                cell = [nib objectAtIndex:10];
            if ([dispositivo isEqualToString:@"iPhone6plus"])
                cell = [nib objectAtIndex:11];
            if ([dispositivo isEqualToString:@"iPad"])
                cell = [nib objectAtIndex:12];
        }
        //      cell.img_menu.image = [UIImage imageNamed:@"motor_off.png"];
        
        cell.nombre_taccsista_viaje.text = [MAtaccsista objectAtIndex:indexPath.row];
        cell.fecha_taccsista_viaje.text = [MAfecha objectAtIndex:indexPath.row];
        cell.vehiculo_taccsista_viaje.text = [MAvehiculo objectAtIndex:indexPath.row];
        cell.monto_taccsista_viaje.text = [NSString stringWithFormat:@" $ %.2f", [[MAmonto objectAtIndex:indexPath.row]  floatValue]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}

//Change the Height of the Cell [Default is 44]:
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 75;
}

#pragma mark - UITableViewDataSource
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![[MAtaccsista objectAtIndex:indexPath.row]isEqualToString:@"Sin viajes"] && [StringCode integerValue]>=0) {
        lbl_fecha_viaje.text = [MAfecha objectAtIndex:indexPath.row];
        
        /*PintaRuta*/
        NSString* la_origen = [NSString stringWithFormat:@"%@", [MAlat_origen objectAtIndex:indexPath.row]];
        NSString* lo_origen = [NSString stringWithFormat:@"%@", [MAlon_origen objectAtIndex:indexPath.row]];
        NSString* la_destino  = [NSString stringWithFormat:@"%@", [MAlat_destino objectAtIndex:indexPath.row]];
        NSString* lo_destino  = [NSString stringWithFormat:@"%@", [MAlon_destino objectAtIndex:indexPath.row]];
        
        CLLocationCoordinate2D position_origen = CLLocationCoordinate2DMake([la_origen doubleValue], [lo_origen doubleValue]);
        CLLocationCoordinate2D position_destino = CLLocationCoordinate2DMake([la_destino doubleValue], [lo_destino doubleValue]);

        GMSMarker *marker_origen = [GMSMarker markerWithPosition:position_origen];
        GMSMarker *marker_destino = [GMSMarker markerWithPosition:position_destino];
        marker_destino.title = [ MAdestino objectAtIndex:indexPath.row];
        marker_destino.icon = [UIImage imageNamed:@"destino"];
        marker_origen.title = [MAorigen objectAtIndex:indexPath.row];
        marker_origen.icon = [UIImage imageNamed:@"origen.png"];
        
        [mapView_ clear];
        
        marker_origen.map = mapView_;
        marker_destino.map = mapView_;
        /* ;*/
        GMSMutablePath *path = [GMSMutablePath path];
        [path addLatitude:[la_origen doubleValue]  longitude:[lo_origen doubleValue]];
        [path addLatitude:[la_destino doubleValue]  longitude:[lo_destino doubleValue]];
        //   [path addLatitude:[latitud_taccsista doubleValue]  longitude:[longitud_taccsista doubleValue]];
        NSString *baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@,%@&destination=%@,%@&sensor=true", la_origen, lo_origen, la_destino, lo_destino ];
        NSURL *url = [NSURL URLWithString:[baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSError *error = nil;
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSArray *routes = [result objectForKey:@"routes"];
            NSDictionary *firstRoute = [routes objectAtIndex:0];
            NSDictionary *leg =  [[firstRoute objectForKey:@"legs"] objectAtIndex:0];
            
            NSArray *steps = [leg objectForKey:@"steps"];
            int stepIndex = 0;
            
            CLLocationCoordinate2D stepCoordinates[1  + [steps count] + 1];
            
            stepCoordinates[stepIndex] =position_origen;
            GMSMutablePath *path = [GMSMutablePath path];
            for (NSDictionary *step in steps) {
                NSDictionary *start_location = [step objectForKey:@"start_location"];
                NSString* latitud_ = [start_location objectForKey:@"lat"];
                NSString* longitud_ = [start_location objectForKey:@"lng"];
                [path addLatitude:[latitud_ doubleValue]  longitude:[longitud_ doubleValue]];
            }
            GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
            polyline.strokeWidth = 2.f;
            polyline.geodesic = YES;
            polyline.strokeColor = [UIColor blueColor];
            polyline.map = mapView_;
        }];
        
        GMSCoordinateBounds* bounds =
        [[GMSCoordinateBounds alloc] initWithCoordinate:position_origen coordinate:position_destino];
        [mapView_ moveCamera:[GMSCameraUpdate fitBounds:bounds]];
        
        lbl_nombre_taccsista.text = [MAtaccsista objectAtIndex:indexPath.row];
        lbl_vehiculo_taccsista.text = [MAvehiculo objectAtIndex:indexPath.row];
        lbl_monto.text = [NSString stringWithFormat:@" $ %.2f", [[MAmonto objectAtIndex:indexPath.row]  floatValue]];
        lbl_calificacion_viaje.text = [NSString stringWithFormat:@"%.1f", [[MApuntos objectAtIndex:indexPath.row]  floatValue]];
        float puntos_taccsista = [[MApuntos objectAtIndex:indexPath.row] floatValue];
        if (puntos_taccsista < 0.5)
           img_calificacion_viaje.image = [UIImage imageNamed:@"extrellas_00_10px"];
        else if (puntos_taccsista >= 0.5 && puntos_taccsista < 1)
            img_calificacion_viaje.image = [UIImage imageNamed:@"extrellas_05_10px"];
        else if (puntos_taccsista >= 1 && puntos_taccsista < 1.5)
            img_calificacion_viaje.image = [UIImage imageNamed:@"extrellas_10_10px"];
        else if (puntos_taccsista >= 1.5 && puntos_taccsista < 2)
            img_calificacion_viaje.image = [UIImage imageNamed:@"extrellas_15_10px"];
        else if (puntos_taccsista >= 2 && puntos_taccsista < 2.5)
            img_calificacion_viaje.image = [UIImage imageNamed:@"extrellas_20_10px"];
        else if (puntos_taccsista >= 2.5 && puntos_taccsista < 3)
            img_calificacion_viaje.image = [UIImage imageNamed:@"extrellas_25_10px"];
        else if (puntos_taccsista >= 3 && puntos_taccsista < 3.5)
            img_calificacion_viaje.image = [UIImage imageNamed:@"extrellas_30_10px"];
        else if (puntos_taccsista >= 3.5 && puntos_taccsista < 4)
            img_calificacion_viaje.image = [UIImage imageNamed:@"extrellas_35_10px"];
        else if (puntos_taccsista >= 4 && puntos_taccsista < 4.5)
            img_calificacion_viaje.image = [UIImage imageNamed:@"extrellas_40_10px"];
        else if (puntos_taccsista >= 4.5 && puntos_taccsista < 5)
            img_calificacion_viaje.image = [UIImage imageNamed:@"extrellas_45_10px"];
        else if (puntos_taccsista >= 5){
            img_calificacion_viaje.image = [UIImage imageNamed:@"extrellas_50_10px"];
        }
        
        contenedor_mi_viaje.hidden = NO;
        
    }
    return indexPath;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    
    NSUInteger retorno;
  //  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        retorno = UIInterfaceOrientationMaskPortrait;
   // else
     //   retorno = UIInterfaceOrientationMaskLandscape;
    return retorno;
}


@end
