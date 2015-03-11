//
//  Portada.m
//  TACCSI
//
//  Created by Angel Rivas on 2/12/15.
//  Copyright (c) 2015 Tecnologizame. All rights reserved.
//

#import "Portada.h"

#import "Reachability.h"
#import "SimpleTableCell.h"
#import "BuscarDestino.h"
#import "Login.h"

extern NSMutableArray* MAtaccsistas;
extern NSMutableArray* MAid_taccsistas;
extern NSMutableArray* MAconductor_taccsistas;
extern NSMutableArray* MAplacas_taccsistas;
extern NSMutableArray* MAestatus_taccsistas;
extern NSMutableArray* MAlatitud_taccsistas;
extern NSMutableArray* MAlongitud_taccsistas;
extern NSMutableArray* MAdistancia_taccsistas;
extern NSMutableArray* MAfoto_taccsistas;
extern NSMutableArray* MApuntos_taccsistas;
extern NSMutableArray* MAservicios_taccsistas;
extern NSString* lat_origen;
extern NSString* lon_origen;
extern BOOL usar_ubicacion_actual;
extern BOOL actualizar_origen;
extern NSString* lat_origen;
extern NSString* lon_origen;
extern NSString* direccion_origen;
extern NSString* GlobalString;
extern BOOL tengo_destino;
extern NSString* direccion_destino;
extern NSString* lat_destino;
extern NSString* lon_destino;
extern NSString* direccion_destino;
extern NSString* documentsDirectory;
extern NSString* GlobalUsu;
extern NSString* GlobalPass;
extern NSString* GlobalID;
extern NSString* GlobalNombre;
extern NSString* GlobalApaterno;
extern NSString* GlobalAmaterno;
extern NSString* GlobalTelefono;
extern NSString* GlobalCorreo;
extern NSString* Globalfoto_perfil;
extern NSString* GlobalString;
extern NSString* id_taccsista;
extern NSString* DeviceToken;
extern BOOL usuario_logueado;
extern NSInteger estatus_viaje;
extern NSString* dispositivo;

@interface Portada (){
    BOOL revisa_estatus;
    BOOL reachable;
    CLLocation *LocacionSeleccionada;
    CLLocation *mi_ubicacion;
    BOOL busca_taccsistas;
    SYSoapTool *soapTool;
    BOOL dame_razones_cancelacion;
    NSMutableArray* MAImagenesxDescargar;
    NSMutableArray* MAUbicacionImages;
    int contador_app;
    BOOL ShowTaccsistas;
    BOOL ShowMenu;
    NSUInteger selectedMemberSZ;
    NSUInteger selectedPayment;
    NSString* lat_destino_viaje;
    NSString* lon_destino_viaje;
    NSString* direccion_destino_viaje;
    NSArray* datos_usuario;
    BOOL descarga_imagen_usuario;
    NSString* nombre_imagen_taccsista;
    NSString* imagen_usuario;
    NSArray*  array_menu;
    NSArray*  array_menu_logueado;
    NSString* metodo_;
    NSTimer* contadorTimer;
    NSString* pasajeros;
    NSString* forma_pago;
    
    NSString* nombre_taccsista;
    NSString* apaterno_taccsista;
    NSString* amaterno_taccsista;
    NSString* telefono_taccsista;
    NSString* marca_taccsista;
    NSString* modelo_taccsista;
    NSString* placas_taccsista;
    NSString* eco_taccsista;
    NSString* foto_taccsista;
    NSString* foto_taccsi;
    BOOL tengo_datos_viaje;
    NSString* latitud_taccsista;
    NSString* longitud_taccsista;
    GMSMarker *marker_taccsista;
    NSString* total_pago;
    BOOL pago_completo;
    int distancia;
    BOOL tengo_razones_cancelacion;
    CGFloat width_;
    CGFloat height_;
}

@end

@implementation Portada

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
    total_pago = @"";
    pago_completo = NO;
    busca_taccsistas = YES;
    NSString* FileName_paypal = [NSString stringWithFormat:@"%@/Paypal.txt", documentsDirectory];
    NSString *contents_paypal = [[NSString alloc] initWithContentsOfFile:FileName_paypal usedEncoding:nil error:nil];
    if (contents_paypal == nil || [contents_paypal isEqualToString:@"Error"])
        pago_completo = NO;
    else
        pago_completo = YES;
    _payPalConfiguration.acceptCreditCards = NO;
    // Or if you wish to have the user choose a Shipping Address from those already
    // associated with the user's PayPal account, then add:
    _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentNoNetwork];
    
    nombre_imagen_taccsista = @"";
    // Do any additional setup after loading the view from its nib.
    descarga_imagen_usuario = NO;
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"taccsi_bd.sql"];
    //SELECT ID FROM TABLE_USUARIOS  LIMIT 1
    NSString *query = [NSString stringWithFormat:@"select * from TABLE_USUARIOS LIMIT 1"];
    datos_usuario = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    if ([datos_usuario count]>0) {
        usuario_logueado = YES;
        [self ObtenDatosUsuario];
    }
    
    lat_destino_viaje = @"";
    lon_destino_viaje = @"";
    direccion_destino_viaje = @"";
    soapTool = [[SYSoapTool alloc]init];
    soapTool.delegate = self;
    ShowTaccsistas = NO;
    ShowMenu = NO;
    contador_app = 0;
    metodo_ = @"";
    tengo_datos_viaje = NO;
    
    array_menu = [[NSArray alloc]initWithObjects:@"Login", @"Ayuda", nil];
    // array_menu_logueado = [[NSArray alloc]initWithObjects:@"Mi cuenta", @"Mis lugares", @"Mis Contactos", @"Ayuda", @"Cerrar sesión", nil];
    array_menu_logueado = [[NSArray alloc]initWithObjects:@"Mi cuenta", @"Mis lugares", @"Ayuda", @"Cerrar sesión", nil];

   width_ = 270;
   height_ = 480;
    if ([dispositivo isEqualToString:@"iPhone5"]) {
        height_ = 568;
    }
    else if ([dispositivo isEqualToString:@"iPhone6"]){
        width_ = 325;
        height_ = 667;
    }else if ([dispositivo isEqualToString:@"iPhone6plus"]){
        width_ = 364;
        height_ = 736;
    }else if ([dispositivo isEqualToString:@"iPad"]){
        width_ = 718;
        height_ = 1024;
    }
    
    contenedor_menu = [[UIView alloc]initWithFrame:CGRectMake(-width_, 0, width_, height_)];
    contenedor_menu.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:contenedor_menu];
    
    
    UIImageView* img_fondo_menu =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contenedor_menu.frame.size.width, contenedor_menu.frame.size.height)];
    img_fondo_menu.image = [UIImage imageNamed:@"home_navbar_bg"];
   // [contenedor_menu addSubview:img_fondo_menu];
    
    img_perfil = [[UIImageView alloc]initWithFrame:CGRectMake(5, 20, 50, 50)];
    img_perfil.image = [UIImage imageNamed:@"img_menu"];
    [contenedor_menu addSubview:img_perfil];
    
    lbl_perfil = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 95, 50)];
    lbl_perfil.text = @"TACCSI";
    lbl_perfil.textAlignment = NSTextAlignmentCenter;
    lbl_perfil.textColor = [UIColor whiteColor];
    lbl_perfil.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    lbl_perfil.numberOfLines = 2;
    [contenedor_menu addSubview:lbl_perfil];

    
    tbl_menu = [[UITableView alloc] initWithFrame:CGRectMake(5, 80, 190, contenedor_menu.frame.size.height - 80) style:UITableViewStylePlain];
    tbl_menu.delegate = self;
    tbl_menu.dataSource = self;
    tbl_menu.separatorColor = [UIColor clearColor];
    tbl_menu.backgroundColor = [UIColor clearColor];
    [contenedor_menu addSubview:tbl_menu];
    
    contenedor_vista = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:contenedor_vista];
    
    //NavigationBar
    navbar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    navbar.image = [UIImage imageNamed:@"fondo_barra"];
    //navbar.backgroundColor = [UIColor blackColor];
    [contenedor_vista addSubview:navbar];
    
    lbl_navbar = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 20)];
    lbl_navbar.text = @"TACCSI";
    lbl_navbar.textAlignment = NSTextAlignmentCenter;
    lbl_navbar.textColor = [UIColor whiteColor];
    lbl_navbar.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    [contenedor_vista addSubview:lbl_navbar];
    
    btn_home_navbar = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, 29, 24)];
    [btn_home_navbar setImage:[UIImage imageNamed:@"menu_home"] forState:UIControlStateNormal];
    [btn_home_navbar addTarget:self action:@selector(ShowMenu:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_vista addSubview:btn_home_navbar];
    
    btn_taccsi_navbar = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 36 , 30, 26, 20)];
    [btn_taccsi_navbar setImage:[UIImage imageNamed:@"taxi_nav_lbtn"] forState:UIControlStateNormal];
    [btn_taccsi_navbar addTarget:self action:@selector(ShowTaccsistas:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_vista addSubview:btn_taccsi_navbar];
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    
    contenedor_mapa = [[UIView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 125)];
    [contenedor_vista addSubview:contenedor_mapa];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-[lat_origen doubleValue]
                                                            longitude:[lon_origen doubleValue]
                                                                 zoom:15];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, contenedor_mapa.frame.size.width, contenedor_mapa.frame.size.height) camera:camera];
    mapView_.delegate = self;
  //  mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = YES;
    [contenedor_mapa addSubview:mapView_];
    
    img_origen = [[UIImageView alloc] initWithFrame:CGRectMake(contenedor_mapa.frame.size.width/2 - 24, contenedor_mapa.frame.size.height /2 - 24, 48, 48)];
    img_origen.image = [UIImage imageNamed:@"home_map_mypos"];
    [contenedor_mapa addSubview:img_origen];
    
    contenedor_direccion = [[UIView alloc] initWithFrame:CGRectMake(contenedor_mapa.frame.size.width/2 - 105 , contenedor_mapa.frame.size.height/2 - 84, 210, 60)];
    contenedor_direccion.backgroundColor = [UIColor clearColor];
    [contenedor_mapa addSubview:contenedor_direccion];
    
    
    
    
    img_direccion = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, contenedor_direccion.frame.size.width, contenedor_direccion.frame.size.height)];
    img_direccion.image = [UIImage imageNamed:@"map_pin_detail_blanco"];
    [contenedor_direccion addSubview:img_direccion];
    
    lbl_direccion = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 40)];
    lbl_direccion.text = @"Buscando dirección...";
    lbl_direccion.textAlignment = NSTextAlignmentCenter;
    lbl_direccion.textColor = [UIColor blackColor];
    lbl_direccion.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    lbl_direccion.numberOfLines = 3;
    [contenedor_direccion addSubview:lbl_direccion];
    
    tab_bar = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 65, self.view.frame.size.width, 65)];
    tab_bar.image = [UIImage imageNamed:@"barra_menu_opciones"];
    [contenedor_vista addSubview:tab_bar];
    
  

    lbl_informacion_viaje = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 -150, self.view.frame.size.height - 35, 300, 25)];
    lbl_informacion_viaje.text = @"Esperando asignación de viaje";
    lbl_informacion_viaje.textAlignment = NSTextAlignmentCenter;
    lbl_informacion_viaje.textColor = [UIColor whiteColor];
    lbl_informacion_viaje.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    [contenedor_vista addSubview:lbl_informacion_viaje];
    
    btn_home_map_check = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 38, self.view.frame.size.height - 115, 76, 76)];
     [btn_home_map_check addTarget:self action:@selector(ShowResumenViaje:) forControlEvents:UIControlEventTouchUpInside];
    [btn_home_map_check setImage:[UIImage imageNamed:@"pedir_taccsi"] forState:UIControlStateNormal];
    [contenedor_vista addSubview:btn_home_map_check];
    
    
    lbl_confirmacion_viaje = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 45, 150, 35)];
    lbl_confirmacion_viaje.text = @"Obteniendo codigo de confirmacion";
    lbl_confirmacion_viaje.textAlignment = NSTextAlignmentLeft;
    lbl_confirmacion_viaje.numberOfLines = 2;
    lbl_confirmacion_viaje.textColor = [UIColor whiteColor];
    lbl_confirmacion_viaje.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    [contenedor_vista addSubview:lbl_confirmacion_viaje];
    
    btn_cancelar_viaje = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 160, self.view.frame.size.height - 35, 150, 25)];
    [btn_cancelar_viaje setTitle:@"Cancelar Viaje" forState:UIControlStateNormal];
    [btn_cancelar_viaje.titleLabel setTextAlignment:NSTextAlignmentRight];
    [btn_cancelar_viaje setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal ];
    btn_cancelar_viaje.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    [btn_cancelar_viaje addTarget:self action:@selector(CancelarVIaje:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_vista addSubview:btn_cancelar_viaje];
    
    btn_mi_taccsista = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 38, self.view.frame.size.height - 115, 76, 76)];
    [btn_mi_taccsista addTarget:self action:@selector(ShowInfoMiTaccsista:) forControlEvents:UIControlEventTouchUpInside];
    [btn_mi_taccsista setImage:[UIImage imageNamed:@"info_taccsista"] forState:UIControlStateNormal];
    [contenedor_vista addSubview:btn_mi_taccsista];
    
    contenedor_invisible = [[UIView alloc] initWithFrame:contenedor_mapa.frame];
    contenedor_invisible.backgroundColor = [UIColor clearColor];
    contenedor_invisible.hidden = YES;
    [contenedor_mapa addSubview:contenedor_invisible];
    
    
    contenedor_info_taccsista = [[UIView alloc]initWithFrame:self.view.frame];
    contenedor_info_taccsista.backgroundColor = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:0.5];
    contenedor_info_taccsista.hidden = YES;
    [contenedor_vista addSubview:contenedor_info_taccsista];
    
    
    
    UIView* sub_contenedor_info_taccsista = [[UIView alloc] initWithFrame:CGRectMake(0, contenedor_vista.frame.size.height / 2 - 78, contenedor_vista.frame.size.width, 163)];
    sub_contenedor_info_taccsista.backgroundColor = [UIColor whiteColor];
    [contenedor_info_taccsista addSubview:sub_contenedor_info_taccsista];
    
    UIImageView* fondo_cerrar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, contenedor_info_taccsista.frame.size.width, 50)];
    fondo_cerrar.image = [UIImage imageNamed:@"payment_btn_cancel"];
    [sub_contenedor_info_taccsista addSubview:fondo_cerrar];
    
    btn_cerrar_info_taccsista = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 150, 30)];
    [btn_cerrar_info_taccsista setTitle:@"Cancelar" forState:UIControlStateNormal];
    [btn_cerrar_info_taccsista setTitleColor:[UIColor colorWithRed:100.0/255.0 green:108.0/255.0 blue:121.0/255.0 alpha:1]  forState:UIControlStateNormal ];
    btn_cerrar_info_taccsista.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    [btn_cerrar_info_taccsista addTarget:self action:@selector(ShowInfoMiTaccsista:) forControlEvents:UIControlEventTouchUpInside];
    [sub_contenedor_info_taccsista addSubview:btn_cerrar_info_taccsista];
    
    for (int i=0; i<8;i++) {
        UILabel* lbl =[[UILabel alloc]init];
        switch (i) {
            case 0:{lbl.frame = CGRectMake(0, 51, self.view.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 1:{lbl.frame = CGRectMake(0 ,52, self.view.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1];}
                break;
            case 2:{lbl.frame = CGRectMake(self.view.frame.size.width / 3, 77, (self.view.frame.size.width / 3) * 2, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 3:{lbl.frame = CGRectMake(self.view.frame.size.width / 3, 78, (self.view.frame.size.width / 3) * 2, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 4:{lbl.frame = CGRectMake(self.view.frame.size.width / 3, 103, (self.view.frame.size.width / 3) * 2, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 5:{lbl.frame = CGRectMake(self.view.frame.size.width / 3, 104, (self.view.frame.size.width / 3) * 2, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 6:{lbl.frame = CGRectMake(self.view.frame.size.width / 3, 129, (self.view.frame.size.width / 3) * 2, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 7:{lbl.frame = CGRectMake(self.view.frame.size.width / 3, 130, (self.view.frame.size.width / 3) * 2, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            default:
                break;
        }
        [sub_contenedor_info_taccsista addSubview:lbl];
    }

    
    lbl_nombre_taccsista = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 3) ,53, (self.view.frame.size.width / 3) * 2, 24)];
    lbl_nombre_taccsista.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    [sub_contenedor_info_taccsista addSubview:lbl_nombre_taccsista];
    
    lbl_eco__taccsista = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 3),79, (self.view.frame.size.width / 3), 24)];
    lbl_eco__taccsista.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    [sub_contenedor_info_taccsista addSubview:lbl_eco__taccsista];
    
    lbl_placas_taccsista = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 3) * 2,79, (self.view.frame.size.width / 3), 24)];
    lbl_placas_taccsista.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    [sub_contenedor_info_taccsista addSubview:lbl_placas_taccsista];
    
    lbl_marca_taccsista = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 3),104, (self.view.frame.size.width / 3), 24)];
    lbl_marca_taccsista.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    [sub_contenedor_info_taccsista addSubview:lbl_marca_taccsista];
    
    lbl_modelo_taccsista = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 3) * 2,104, (self.view.frame.size.width / 3), 24)];
    lbl_modelo_taccsista.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    [sub_contenedor_info_taccsista addSubview:lbl_modelo_taccsista];
    
    lbl_telefono_taccsista = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 3) ,131 + 5, (self.view.frame.size.width / 3) * 2, 24)];
    lbl_telefono_taccsista.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    [sub_contenedor_info_taccsista addSubview:lbl_telefono_taccsista];
    
    btn_llamar_taccsista = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 45, 132, 30, 30)];
    [btn_llamar_taccsista addTarget:self action:@selector(LlamarTaccsista:) forControlEvents:UIControlEventTouchUpInside];
    [btn_llamar_taccsista setImage:[UIImage imageNamed:@"llamada"] forState:UIControlStateNormal];
    [sub_contenedor_info_taccsista addSubview:btn_llamar_taccsista];
    
    
    img_foto_taccsista = [[UIImageView alloc] initWithFrame:CGRectMake(((self.view.frame.size.width / 3) / 2) - 50, 63, 100, 100)];
    img_foto_taccsista.image = [UIImage imageNamed:@"img_menu"];
    [sub_contenedor_info_taccsista addSubview:img_foto_taccsista];

    btn_show_fin_viaje = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 38, self.view.frame.size.height - 115, 76, 76)];
    [btn_show_fin_viaje addTarget:self action:@selector(ShowPagarViaje:) forControlEvents:UIControlEventTouchUpInside];
    [btn_show_fin_viaje setImage:[UIImage imageNamed:@"finalizar_viaje"] forState:UIControlStateNormal];
    [contenedor_vista addSubview:btn_show_fin_viaje];
    btn_show_fin_viaje.hidden = YES;
    
    contenedor_fin_viaje = [[UIView alloc]initWithFrame:self.view.frame];
    contenedor_fin_viaje.backgroundColor = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:0.5];
    contenedor_fin_viaje.hidden = YES;
    [contenedor_vista addSubview:contenedor_fin_viaje];
    
    UIView* sub_contenedor_fin_viaje = [[UIView alloc] initWithFrame:CGRectMake(contenedor_vista.frame.size.width / 2 - 160, contenedor_vista.frame.size.height / 2 - 176, 320, 352)];
    [contenedor_fin_viaje addSubview:sub_contenedor_fin_viaje];
    
    img_fondo_fin_viaje = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, sub_contenedor_fin_viaje.frame.size.width, sub_contenedor_fin_viaje.frame.size.height)];
    img_fondo_fin_viaje.image = [UIImage imageNamed:@"ticket_pago_limpio"];
    [sub_contenedor_fin_viaje addSubview:img_fondo_fin_viaje];

    lbl_recibo_fin_viaje = [[UILabel alloc] initWithFrame:CGRectMake(45,55, 125, 40)];
    lbl_recibo_fin_viaje.font = [UIFont fontWithName:@"HelveticaNeue" size:22];
    lbl_recibo_fin_viaje.text = @"A pagar";
    [sub_contenedor_fin_viaje addSubview:lbl_recibo_fin_viaje];
    
    lbl_total_fin_viaje = [[UILabel alloc] initWithFrame:CGRectMake(160,55, 125, 40)];
    lbl_total_fin_viaje.font = [UIFont fontWithName:@"HelveticaNeue" size:22];
    lbl_total_fin_viaje.text = @"Recibo";
    [sub_contenedor_fin_viaje addSubview:lbl_total_fin_viaje];
    
    lbl_fin_viaje = [[UILabel alloc] initWithFrame:CGRectMake(45,95, 180, 20)];
    lbl_fin_viaje.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    lbl_fin_viaje.text = @"1 viaje";
    [sub_contenedor_fin_viaje addSubview:lbl_fin_viaje];
    
    lbl_forma_pago_fin_viaje = [[UILabel alloc] initWithFrame:CGRectMake(45,115, 180, 20)];
    lbl_forma_pago_fin_viaje.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    lbl_forma_pago_fin_viaje.text = @"1 viaje";
    [sub_contenedor_fin_viaje addSubview:lbl_forma_pago_fin_viaje];
    
    btn_pagar_fin_viaje = [[UIButton alloc] initWithFrame:CGRectMake(45, 145, 180, 30)];
    [btn_pagar_fin_viaje setTitle:@"Pagar Ahora" forState:UIControlStateNormal];
    [btn_pagar_fin_viaje setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal ];
    btn_pagar_fin_viaje.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    [btn_pagar_fin_viaje.titleLabel setTextAlignment:NSTextAlignmentCenter];
    btn_pagar_fin_viaje.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1];
    [btn_pagar_fin_viaje addTarget:self action:@selector(PagarViaje:) forControlEvents:UIControlEventTouchUpInside];
    [sub_contenedor_fin_viaje addSubview:btn_pagar_fin_viaje];
    
    btn_facebook = [[UIButton alloc] initWithFrame:CGRectMake(240, 95, 35, 35)];
    [btn_facebook setImage:[UIImage imageNamed:@"facebook_icon"] forState:UIControlStateNormal];
  //  [btn_facebook addTarget:self action:@selector(Facebook:) forControlEvents:UIControlEventTouchUpInside];
    [sub_contenedor_fin_viaje addSubview:btn_facebook];
    
    btn_twitter = [[UIButton alloc] initWithFrame:CGRectMake(240, 140, 35, 35)];
    [btn_twitter setImage:[UIImage imageNamed:@"twitter_icon"] forState:UIControlStateNormal];
    //  [btn_twitter addTarget:self action:@selector(Facebook:) forControlEvents:UIControlEventTouchUpInside];
    [sub_contenedor_fin_viaje addSubview:btn_twitter];
    
    califica_taccsista_fin_viaje = [[UILabel alloc] initWithFrame:CGRectMake(55,210, 210, 20)];
    califica_taccsista_fin_viaje.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    califica_taccsista_fin_viaje.text = @"Califica Taccsista";
    califica_taccsista_fin_viaje.textAlignment = NSTextAlignmentCenter;
    [sub_contenedor_fin_viaje addSubview:califica_taccsista_fin_viaje];
    
    slider__fin_viaje = [[UISlider alloc] initWithFrame:CGRectMake(55,240, 210, 30)];
    slider__fin_viaje.maximumTrackTintColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    slider__fin_viaje.tintColor = [UIColor colorWithRed:254.0/255.0 green:186.0/255.0 blue:10.0/255.0 alpha:1];
    slider__fin_viaje.minimumValue = 1;
    slider__fin_viaje.maximumValue = 5;
    slider__fin_viaje.value = 1;
    [sub_contenedor_fin_viaje addSubview:slider__fin_viaje];
    
    cancelar_fin_viaje = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, 320, 52)];
    [cancelar_fin_viaje setTitle:@"Cancelar" forState:UIControlStateNormal];
    [cancelar_fin_viaje setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal ];
    cancelar_fin_viaje.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22];
    [cancelar_fin_viaje.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [cancelar_fin_viaje addTarget:self action:@selector(ShowPagarViaje:) forControlEvents:UIControlEventTouchUpInside];
    [sub_contenedor_fin_viaje addSubview:cancelar_fin_viaje];
    
    
    
    
    
    
    
    contenedor_taccsistas = [[UIView alloc]initWithFrame:CGRectMake(width_, 0, width_, height_)];
    [self.view addSubview:contenedor_taccsistas];
//    contenedor_taccsistas.backgroundColor = [UIColor blackColor];
    
    UIImageView* img_fondo_taccsistas =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contenedor_taccsistas.frame.size.width, contenedor_taccsistas.frame.size.height)];
    img_fondo_taccsistas.image = [UIImage imageNamed:@"home_navbar_bg"];
    [contenedor_taccsistas addSubview:img_fondo_taccsistas];
    
    lbl_total_taccsistas  = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, contenedor_taccsistas.frame.size.width, 50)];
    lbl_total_taccsistas.text = @"Buscando Taccsistas cercanos";
    lbl_total_taccsistas.textAlignment = NSTextAlignmentCenter;
    lbl_total_taccsistas.textColor = [UIColor whiteColor];
    lbl_total_taccsistas.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    lbl_total_taccsistas.numberOfLines = 2;
    [contenedor_taccsistas addSubview:lbl_total_taccsistas];
    
    tbl_taccsistas = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, contenedor_taccsistas.frame.size.width, contenedor_taccsistas.frame.size.height - 80) style:UITableViewStylePlain];
    tbl_taccsistas.delegate = self;
    tbl_taccsistas.dataSource = self;
    tbl_taccsistas.separatorColor = [UIColor clearColor];
    tbl_taccsistas.backgroundColor = [UIColor clearColor];
    [contenedor_taccsistas addSubview:tbl_taccsistas];
    
    contenedor_resumen_fondo = [[UIView alloc]initWithFrame:self.view.frame];
    contenedor_resumen_fondo.backgroundColor = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:0.5];
    contenedor_resumen_fondo.hidden = YES;
    [self.view addSubview:contenedor_resumen_fondo];
    
    contenedor_resumen_viaje = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 160 , self
                                                                        .view.frame.size.height/2 - 176, 320, 352)];
    contenedor_resumen_viaje.backgroundColor = [UIColor clearColor];
    [contenedor_resumen_fondo addSubview:contenedor_resumen_viaje];
    
    img_resumen_viaje = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contenedor_resumen_viaje.frame.size.width, contenedor_resumen_viaje.frame.size.height)];
    img_resumen_viaje.image = [UIImage imageNamed:@"search_bg"];
    [contenedor_resumen_viaje addSubview:img_resumen_viaje];
    
    btn_cerrar_resumen_viaje = [[UIButton alloc] initWithFrame:CGRectMake(7, 11, 70, 40)];
    [btn_cerrar_resumen_viaje setTitle:@"Cancelar" forState:UIControlStateNormal];
    [btn_cerrar_resumen_viaje setTitleColor:[UIColor colorWithRed:100.0/255.0 green:108.0/255.0 blue:121.0/255.0 alpha:1]  forState:UIControlStateNormal ];
    btn_cerrar_resumen_viaje.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    [btn_cerrar_resumen_viaje addTarget:self action:@selector(ShowResumenViaje:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_resumen_viaje addSubview:btn_cerrar_resumen_viaje];
    
    lbl_desde_resumen_viaje = [[UILabel alloc] initWithFrame:CGRectMake(5, 80, 56, 21)];
    lbl_desde_resumen_viaje.textColor = [UIColor blackColor];
    lbl_desde_resumen_viaje.text = @"Origen";
    lbl_desde_resumen_viaje.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    [contenedor_resumen_viaje addSubview:lbl_desde_resumen_viaje];
    
    txt_origen = [[UITextField alloc] initWithFrame:CGRectMake(65, 78, 220, 25)];
    txt_origen.delegate = self;
    txt_origen.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    txt_origen.placeholder = @"Origen del viaje";
    txt_origen.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_origen.textAlignment = NSTextAlignmentCenter;
    [contenedor_resumen_viaje addSubview:txt_origen];
    
    lbl_hasta_resumen_viaje = [[UILabel alloc] initWithFrame:CGRectMake(5, 122, 56, 21)];
    lbl_hasta_resumen_viaje.textColor = [UIColor blackColor];
    lbl_hasta_resumen_viaje.text = @"Destino";
    lbl_hasta_resumen_viaje.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    [contenedor_resumen_viaje addSubview:lbl_hasta_resumen_viaje];
    
    txt_destino = [[UITextField alloc] initWithFrame:CGRectMake(65, 120, 220, 25)];
    txt_destino.delegate = self;
    txt_destino.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    txt_destino.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_destino.placeholder = @"Opcional";
    txt_destino.enabled = NO;
    txt_destino.textAlignment = NSTextAlignmentCenter;
    [contenedor_resumen_viaje addSubview:txt_destino];
    
    btn_destino = [[UIButton alloc] initWithFrame:CGRectMake(290, 120, 23, 23)];
    [btn_destino setImage:[UIImage imageNamed:@"text_icon_black_rquote"] forState:UIControlStateNormal];
    [btn_destino addTarget:self action:@selector(BuscarDestino:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_resumen_viaje addSubview:btn_destino];
    
    segmentMembers = [[CustomSegmentedControl alloc] init];
    [segmentMembers setSegmentWithCount:5
                            segmentsize:CGSizeMake( 60, 29 )
                           dividerImage:nil
                                    tag:9001
                               delegate:self];
    [segmentMembers setFrame:CGRectMake( 10, 180, 300, 29 )];
    [contenedor_resumen_viaje addSubview:segmentMembers];
    
    segmentPayments = [[CustomSegmentedControl alloc] init];
    [segmentPayments setSegmentWithCount:3
                             segmentsize:CGSizeMake( 150, 29 )
                            dividerImage:nil
                                     tag:9001
                                delegate:self];
    [segmentPayments setFrame:CGRectMake( 10, 237, 300, 29)];
    [contenedor_resumen_viaje addSubview:segmentPayments];
    
    btn_pedir_taccsi = [[UIButton alloc]initWithFrame:CGRectMake(0, 299, 320, 53)];
 /*   UIImageView* img_ = [[UIImageView alloc]initWithFrame:btn_pedir_taccsi.frame];
    img_.image = [UIImage imageNamed:@"payment_btn_cancel"];*/
    [btn_pedir_taccsi setTitle:@"Pedir Taccsi" forState:UIControlStateNormal];
    [btn_pedir_taccsi setTitleColor:[UIColor colorWithRed:100.0/255.0 green:108.0/255.0 blue:121.0/255.0 alpha:1]  forState:UIControlStateNormal ];
    btn_pedir_taccsi.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1];
                                        btn_pedir_taccsi.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    [btn_pedir_taccsi addTarget:self action:@selector(PedirTaccsi:) forControlEvents:UIControlEventTouchUpInside];
 //   [contenedor_resumen_viaje addSubview:img_];
    [contenedor_resumen_viaje addSubview:btn_pedir_taccsi];
    
    revisa_estatus = NO;
    
    MAid_taccsistas               = [[NSMutableArray alloc]init];
    MAconductor_taccsistas  = [[NSMutableArray alloc]init];
    MAplacas_taccsistas        = [[NSMutableArray alloc]init];
    MAestatus_taccsistas       = [[NSMutableArray alloc]init];
    MAlatitud_taccsistas         = [[NSMutableArray alloc]init];
    MAlongitud_taccsistas      = [[NSMutableArray alloc]init];
    MAdistancia_taccsistas     = [[NSMutableArray alloc]init];
    MAfoto_taccsistas             = [[NSMutableArray alloc]init];
    MApuntos_taccsistas        = [[NSMutableArray alloc]init];
    MAservicios_taccsistas      = [[NSMutableArray alloc]init];
    MAImagenesxDescargar   = [[NSMutableArray alloc]init];
    MAUbicacionImages         = [[NSMutableArray alloc]init];
    
    actividad = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    actividad.color = [UIColor colorWithRed:254.0/255.0 green:214.0/255.0 blue:0.0/255.0 alpha:1.0];
    actividad.hidesWhenStopped = TRUE;
    CGRect newFrames = actividad.frame;
    newFrames.origin.x = (contenedor_vista.frame.size.width / 2) -13;
    newFrames.origin.y = (contenedor_vista.frame.size.height / 2) - 13;
    actividad.frame = newFrames;
    actividad.backgroundColor = [UIColor clearColor];
    actividad.hidden = YES;
    [self.view addSubview:actividad];
    
    soapTool = [[SYSoapTool alloc]init];
    soapTool.delegate = self;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}

-(void)Animacion:(int)Code{
    if (Code==1) {
        btn_cerrar_resumen_viaje.enabled = NO;
        btn_pedir_taccsi.enabled = NO;
        actividad.hidesWhenStopped = TRUE;
        [actividad startAnimating];
    }
    else {
        btn_cerrar_resumen_viaje.enabled = YES;
        btn_pedir_taccsi.enabled = YES;
        [actividad stopAnimating];
        [actividad hidesWhenStopped];
    }
}

-(void)EscribeArchivo_id_estatus_viaje:(NSString*)ID_ESTATUS id_viaje:(NSString*)ID_VIAJE lat_origen:(NSString*)LAT_ORIGEN lon_origen:(NSString*)LON_ORIGEN lat_destino:(NSString*)LAT_DESTINO lon_destino:(NSString*)LON_DESTINO id_taccsista:(NSString*)ID_TACCSISTA clave_confirmacion:(NSString*)CLAVE_CONFIRMACION foto_taccsista:(NSString*)FOTO_TACCSISTA nombre_taccsista:(NSString*)NOMBRE_TACCSISTA apaterno_taccsista:(NSString*)APATERNO_TACCSISTA amaterno_taccsista:(NSString*)AMATERNO_TACCSISTA telefono:(NSString*)TELEFONO marca:(NSString*)MARCA modelo:(NSString*)MODELO placas:(NSString*)PLACAS eco:(NSString*)ECO foto_taccsi:(NSString*)FOTO_TACCSI direccion_origen:(NSString*)DIRECCION_ORIGEN forma_pago:(NSString*)FORMA_PAGO importe:(NSString*)IMPORTE direccion_destino:(NSString*)DIRECCION_DESTINO pasajeros:(NSString*)PASAJEROS{
    NSArray* Viaje;
    NSString* FileName = [NSString stringWithFormat:@"%@/Viaje.txt", documentsDirectory];
    if ([ID_ESTATUS isEqualToString:@""] || [ID_VIAJE isEqualToString:@""]) {
        Viaje = [[NSArray alloc] initWithObjects:@"Error", nil];
    }
    
    Viaje = [[NSArray alloc]initWithObjects:ID_ESTATUS,ID_VIAJE,LAT_ORIGEN, LON_ORIGEN,LAT_DESTINO, LON_DESTINO,ID_TACCSISTA,CLAVE_CONFIRMACION,FOTO_TACCSISTA,NOMBRE_TACCSISTA,APATERNO_TACCSISTA,AMATERNO_TACCSISTA,TELEFONO,MARCA,MODELO,PLACAS,ECO,FOTO_TACCSI,DIRECCION_ORIGEN,FORMA_PAGO,IMPORTE, DIRECCION_DESTINO, PASAJEROS, nil];
    
    [Viaje writeToFile:FileName atomically:YES];
    
}

-(NSArray*)DameInfoVIaje{
    NSString* FileName = [NSString stringWithFormat:@"%@/Viaje.txt", documentsDirectory];
    NSArray* array_viaje = [[NSArray alloc]initWithContentsOfFile:FileName];
    return array_viaje;
}

-(void)actualizarxtimer:(id)sender{
    if (revisa_estatus==YES && reachable ==YES) {
        NSArray* datos_viaje = [self DameInfoVIaje];
        if ([datos_viaje count]>0) {
            NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"id_viaje", @"id_usuario", nil];
            NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:[datos_viaje objectAtIndex:1], GlobalID, nil];
            
            
            metodo_ = @"EstatusMiViaje";
            [soapTool callSoapServiceWithParameters__functionName:@"EstatusMiViaje" tags:tags vars:vars wsdlURL:@"http://201.131.96.45/wbs/wbs_taccsi.php?wsdl"];
            [self Animacion:1];
        }
        else{
            [contadorTimer invalidate];
        }
    }
    else{
        [contadorTimer invalidate];
    }
}

-(IBAction)CancelarVIaje:(id)sender{
    
}

-(void)RevisaDatosTaccsista{
    NSArray* datos_taccsista = [self DameInfoVIaje];
    
    /*PintaRuta*/
    NSString* la_origen = [NSString stringWithFormat:@"%@", [datos_taccsista objectAtIndex:2]];
    NSString* lo_origen = [NSString stringWithFormat:@"%@", [datos_taccsista objectAtIndex:3]];
    NSString* la_destino  = [NSString stringWithFormat:@"%@", [datos_taccsista objectAtIndex:4]];
    NSString* lo_destino  = [NSString stringWithFormat:@"%@", [datos_taccsista objectAtIndex:5]];
    
    CLLocationCoordinate2D position_origen = CLLocationCoordinate2DMake([la_origen doubleValue], [lo_origen doubleValue]);
    CLLocationCoordinate2D position_destino = CLLocationCoordinate2DMake([la_destino doubleValue], [lo_destino doubleValue]);
    CLLocationCoordinate2D position_taccsista = CLLocationCoordinate2DMake([latitud_taccsista doubleValue], [longitud_taccsista doubleValue]);
    GMSMarker *marker_origen = [GMSMarker markerWithPosition:position_origen];
    GMSMarker *marker_destino = [GMSMarker markerWithPosition:position_destino];
    marker_destino.title = @"Destino";
    marker_destino.icon = [UIImage imageNamed:@"destino.png"];
    marker_origen.title = @"Origen";
    marker_origen.icon = [UIImage imageNamed:@"origen.png"];
    marker_taccsista = [GMSMarker markerWithPosition:position_taccsista];
    marker_taccsista.title = [NSString stringWithFormat:@"%@, @%@, %@", [datos_taccsista objectAtIndex:9], [datos_taccsista objectAtIndex:10], [datos_taccsista objectAtIndex:11]];
    marker_taccsista.icon = [UIImage imageNamed:@"taxi.png"];
    marker_taccsista.map = mapView_;
    distancia = 0;

    
    if (![la_destino isEqualToString:@""] && ![lo_destino isEqualToString:@""]) {
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
                NSDictionary* distance = [step objectForKey:@"distance"];
                distancia = distancia + [[distance objectForKey:@"value"] intValue];
                [path addLatitude:[latitud_ doubleValue]  longitude:[longitud_ doubleValue]];
            }
            GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
            polyline.strokeWidth = 2.f;
            polyline.geodesic = YES;
            polyline.strokeColor = [UIColor redColor];
            polyline.map = mapView_;
        }];
        
        GMSCoordinateBounds* bounds =
        [[GMSCoordinateBounds alloc] initWithCoordinate:position_origen coordinate:position_destino];
        [mapView_ moveCamera:[GMSCameraUpdate fitBounds:bounds]];
        
        /*Pinta Ruta*/
    }
    else{
        marker_origen.map = mapView_;
        
        GMSCameraPosition *sydney = [GMSCameraPosition cameraWithLatitude:[la_origen doubleValue]
                                                                longitude:[lo_origen doubleValue]
                                                                     zoom:mapView_.camera.zoom];
        [mapView_ setCamera:sydney];
    }
    
    if ([[[datos_taccsista objectAtIndex:8] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || [[[datos_taccsista objectAtIndex:9] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || [[[datos_taccsista objectAtIndex:10] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || [[[datos_taccsista objectAtIndex:11] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || [[[datos_taccsista objectAtIndex:12] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || [[[datos_taccsista objectAtIndex:13] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || [[[datos_taccsista objectAtIndex:14] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || [[[datos_taccsista objectAtIndex:15] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || [[[datos_taccsista objectAtIndex:16] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || [[[datos_taccsista objectAtIndex:17] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        
        NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"id_usuario", @"id_taxista", @"id_viaje", nil];
        NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:GlobalID, [datos_taccsista objectAtIndex:6],[datos_taccsista objectAtIndex:1], nil];
        
        
        metodo_ = @"usrDameInfoTaxista";
        [soapTool callSoapServiceWithParameters__functionName:@"usrDameInfoTaxista" tags:tags vars:vars wsdlURL:@"http://201.131.96.45/wbs/wbs_taccsi.php?wsdl"];
        [self Animacion:1];
    }
    else{
        [self Animacion:2];
        btn_mi_taccsista.hidden = NO;
        lbl_confirmacion_viaje.text = [NSString stringWithFormat:@"%@", [datos_taccsista objectAtIndex:7]];
        lbl_nombre_taccsista.text = [NSString stringWithFormat:@"%@ %@ %@", [datos_taccsista objectAtIndex:9], [datos_taccsista objectAtIndex:10], [datos_taccsista objectAtIndex:11]];
        lbl_eco__taccsista.text = [NSString stringWithFormat:@"Eco: %@", [datos_taccsista objectAtIndex:16]];
        lbl_placas_taccsista.text = [NSString stringWithFormat:@"Placas: %@", [datos_taccsista objectAtIndex:15]];
        lbl_marca_taccsista.text = [NSString stringWithFormat:@"Marca: %@", [datos_taccsista objectAtIndex:13]];
        lbl_modelo_taccsista.text  = [NSString stringWithFormat:@"Modelo: %@", [datos_taccsista objectAtIndex:14]];
        lbl_telefono_taccsista.text  = [NSString stringWithFormat:@"Teléfono: %@", [datos_taccsista objectAtIndex:12]];
        telefono_taccsista = [datos_taccsista objectAtIndex:12];
        nombre_imagen_taccsista  = [NSString stringWithFormat:@"%@%@%@_%@", [datos_taccsista objectAtIndex:9], [datos_taccsista objectAtIndex:10], [datos_taccsista objectAtIndex:11], [datos_taccsista objectAtIndex:6]];
        foto_taccsista = [datos_taccsista objectAtIndex:8];
        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* foofile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[nombre_imagen_taccsista stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@".png"]];
        UIImage *pImage;
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
        if (!fileExists) {
            pImage = [UIImage imageNamed:@"sin_foto"];
            [self DescargaImagenes];
        }
        else
            pImage = [UIImage imageWithContentsOfFile:foofile];
        img_foto_taccsista.image = pImage;
        
        //aqui muestro el contenedor taccsista
    }
/*    NSArray* array_ = [self DameInfoVIaje];
    if ([array_ count]>0) {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:position_taccsista.latitude
                                                                longitude:position_taccsista.longitude
                                                                     zoom:mapView_.camera.zoom];
        [mapView_ setCamera:camera];
    }*/
    if (![contadorTimer isValid]) {
        revisa_estatus = YES;
        contadorTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(actualizarxtimer:) userInfo:nil repeats:YES];
    }
    tengo_datos_viaje = YES;
    [self PintaPantallaXEstatus];
}

-(void)viewDidAppear:(BOOL)animated{
    
    lbl_total_taccsistas.text = @"Buscando Taccsistas cercanos";
    
    if (usuario_logueado == YES) {
        [self ObtenDatosUsuario];
    }
    if (tengo_destino == YES) {
        txt_destino.text = direccion_destino;
        txt_destino.enabled = YES;
        tengo_destino = NO;
        lat_destino_viaje = [NSString stringWithFormat:@"%@", lat_destino];
        lon_destino_viaje = [NSString stringWithFormat:@"%@", lon_destino];
        direccion_destino_viaje = [NSString stringWithFormat:@"%@", direccion_destino];
    }
    NSArray* datos_viaje = [[NSArray alloc] initWithArray:[self DameInfoVIaje]];
    if ([datos_viaje count]>0) {
        estatus_viaje = [[datos_viaje objectAtIndex:0] integerValue];
        [self PintaPantallaXEstatus];
    }
    else{
        estatus_viaje = 0;
        lbl_informacion_viaje.hidden = YES;
        lbl_confirmacion_viaje.hidden = YES;
        btn_cancelar_viaje.hidden = YES;
        btn_mi_taccsista.hidden = YES;
    }
}


-(void)ObtenDatosUsuario{
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"taccsi_bd.sql"];
    //SELECT ID FROM TABLE_USUARIOS  LIMIT 1
    NSString *query = [NSString stringWithFormat:@"select * from TABLE_USUARIOS LIMIT 1"];
    datos_usuario = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSArray* datos_usuario_ = [[NSArray alloc]init];
    datos_usuario_ = [datos_usuario objectAtIndex:0];
    GlobalUsu = [datos_usuario_ objectAtIndex:6];
    GlobalCorreo = [datos_usuario_ objectAtIndex:6];
    Globalfoto_perfil = [datos_usuario_ objectAtIndex:1];
    GlobalID = [datos_usuario_ objectAtIndex:0];
    GlobalNombre = [datos_usuario_ objectAtIndex:2];
    GlobalApaterno = [datos_usuario_ objectAtIndex:3];
    GlobalAmaterno = [datos_usuario_ objectAtIndex:4];
    GlobalTelefono = [datos_usuario_ objectAtIndex:5];
    GlobalPass = [datos_usuario_ objectAtIndex:7];
    lbl_perfil.text = [NSString stringWithFormat:@"%@", GlobalNombre];
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    imagen_usuario = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[GlobalID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@".png"]];
    UIImage *pImage;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imagen_usuario];
    if (!fileExists || descarga_imagen_usuario) {
        pImage = [UIImage imageNamed:@"sin_foto.png"];
        descarga_imagen_usuario = YES;
        [self DescargaImagenes];
    }
    else
        pImage = [UIImage imageWithContentsOfFile:imagen_usuario];
    
    img_perfil.image = pImage;
    
    [tbl_menu reloadData];
    
}

-(IBAction)PedirTaccsi:(id)sender{
    BOOL error_ = YES;
    if (ShowTaccsistas) {
        [self ShowTaccsistas:self];
    }
    
    if (usuario_logueado) {
        error_ = NO;
    }
    
    
    if (error_ == NO) {
        if (id_taccsista==nil || [id_taccsista isEqualToString:@""] || !id_taccsista ) {
            id_taccsista = @"0";
        }
        [self Animacion:1];
        
       pasajeros = [NSString stringWithFormat:@"%lu", (unsigned long)selectedMemberSZ];
       forma_pago = @"1";
        if (selectedPayment>0) {
            forma_pago = @"4";
        }
        
        NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"usuario", @"dispositivo", @"push_token",@"origen", @"destino", @"lat_origen", @"lon_origen", @"lat_destino", @"lon_destino", @"personas", @"pago", @"descuento", @"id_conductor", @"so",  nil];
        NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:GlobalUsu , DeviceToken, DeviceToken, txt_origen.text, direccion_destino_viaje, lat_origen, lon_origen, lat_destino_viaje, lon_destino_viaje, pasajeros ,forma_pago, @"", id_taccsista, @"I", nil];
        
        [soapTool callSoapServiceWithParameters__functionName:@"usrNuevoViaje" tags:tags vars:vars wsdlURL:@"http://201.131.96.45/wbs/wbs_taccsi.php?wsdl"];
        
        metodo_ = @"usrNuevoViaje";
        busca_taccsistas = NO;
    }
    else{
        [self IrLogin];
    }
}

-(void)IrLogin{
    NSString* view_name = @"Login";
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height == 568.0f) {
            view_name = [view_name stringByAppendingString:@"_iPhone5"];
        }
        if (screenSize.height == 667.0f) {
            view_name = [view_name stringByAppendingString:@"_iPhone6"];
        }
        if (screenSize.height == 736.0f) {
            view_name = [view_name stringByAppendingString:@"_iPhone6plus"];
        }
    }
    else{
        view_name = [view_name stringByAppendingString:@"_iPad"];
    }
    Login *view = [[Login alloc] initWithNibName:view_name bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];
}

-(IBAction)BuscarDestino:(id)sender{
   // [contadorTimer invalidate];
    NSString* error_ = @"";
    
    if ([lat_origen isEqualToString:@""] || [lon_origen isEqualToString:@""]) {
        error_ = @"Debe de escoger una dirección válida";
    }
  /*  NSString* id_taccsista_ = [NSString stringWithFormat:@"%@", id_taccsista];
    if ([id_taccsista_ isEqualToString:@"0"] || !id_taccsista_ || [id_taccsista_ isEqualToString:@""]) {
        error_ = @"";
        id_taccsista_ = 0;
    }*/
    if ([error_ isEqualToString:@""]) {
        NSString* view_name = @"BuscarDestino";
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height == 568.0f) {
                view_name = [view_name stringByAppendingString:@"_iPhone5"];
            }
            if (screenSize.height == 667.0f) {
                view_name = [view_name stringByAppendingString:@"_iPhone6"];
            }
            if (screenSize.height == 736.0f) {
                view_name = [view_name stringByAppendingString:@"_iPhone6plus"];
            }
        } else {
            /*Do iPad stuff here.*/
            view_name = [view_name stringByAppendingString:@"_iPad"];
            
        }
      //  actualizar_origen = NO;
        BuscarDestino *view = [[BuscarDestino alloc] initWithNibName:view_name bundle:nil];
        view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:view animated:YES completion:nil];
    }
    else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"TACCSI" message:error_ delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark --
#pragma mark -- CustomSegmentedControlDelegate --

- (UIButton*) buttonFor:(CustomSegmentedControl*)segmentedControl atIndex:(NSUInteger)segmentIndex
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([segmentedControl isEqual:segmentMembers]) {
        [btn setFrame:CGRectMake( 0, 0, 60, 29 )];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
         [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [btn setTitleColor:[UIColor colorWithRed:1.0f green:225/255.0f blue:0.0f alpha:1.0f]
      //            forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:16.0f]];
        
        if (segmentIndex == 0) {
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"search_seg_pay_1.png"]]
                           forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"search_seg_pay_1_selected.png"]]
                           forState:UIControlStateSelected];
            [btn setTitle:[NSString stringWithFormat:@"  %@", @"1"]
                 forState:UIControlStateNormal];
            [btn setSelected:YES];
            selectedMemberSZ = segmentIndex + 1;
        }
        else if (segmentIndex == 1) {
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"search_seg_pay_2.png"]]
                           forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"search_seg_pay_1_selected.png"]]
                           forState:UIControlStateSelected];
            [btn setTitle:[NSString stringWithFormat:@"  %@", @"2"]
                 forState:UIControlStateNormal];
            [btn setSelected:NO];
        }
        else if (segmentIndex == 2) {
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"search_seg_pay_2.png"]]
                           forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"search_seg_pay_1_selected.png"]]
                           forState:UIControlStateSelected];
            [btn setTitle:[NSString stringWithFormat:@"  %@", @"3"]
                 forState:UIControlStateNormal];
            [btn setSelected:NO];
        }
        else if (segmentIndex == 3) {
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"search_seg_pay_2.png"]]
                           forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"search_seg_pay_1_selected.png"]]
                           forState:UIControlStateSelected];
            [btn setTitle:[NSString stringWithFormat:@"  %@", @"4"]
                 forState:UIControlStateNormal];
            [btn setSelected:NO];
        }
        else if (segmentIndex == 1) {
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"search_seg_pay_2.png"]]
                           forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"search_seg_pay_1_selected.png"]]
                           forState:UIControlStateSelected];
            [btn setTitle:[NSString stringWithFormat:@"     %@", @"2 - 4"]
                 forState:UIControlStateNormal];
            [btn setSelected:NO];
        }
        else {
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"search_seg_pay_3.png"]]
                           forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"search_seg_pay_3_selected.png"]]
                           forState:UIControlStateSelected];
            [btn setTitle:[NSString stringWithFormat:@"      %@", @"> 5"]
                 forState:UIControlStateNormal];
            [btn setSelected:NO];
            [btn setSelected:NO];
        }
        
        
    }
    else if ([segmentedControl isEqual:segmentPayments]) {
        [btn setFrame:CGRectMake( 0, 0, 150, 29 )];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:16.0f]];
        
        if (segmentIndex == 0) {
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"search_seg_pay_1.png"]]
                           forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"search_seg_pay_1_selected.png"]]
                           forState:UIControlStateSelected];
            [btn setTitle:[NSString stringWithFormat:@" %@", @"Efectivo"]
                 forState:UIControlStateNormal];
            [btn setSelected:YES];
             selectedPayment = segmentIndex;
        }
        else if (segmentIndex == 1) {
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"search_seg_pay_3.png"]]
                           forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"search_seg_pay_3_selected.png"]] forState:UIControlStateSelected];
            [btn setTitle:[NSString stringWithFormat:@" %@", @"Tarjeta de crédito"]
                 forState:UIControlStateNormal];
            [btn setSelected:NO];
        }
        

    }
    
    
    return btn;
}

- (void) touchUpInsideSegment:(CustomSegmentedControl *)segmentedControl index:(NSUInteger)segmentIndex
{
    if ([segmentedControl isEqual:segmentMembers]) {
        selectedMemberSZ = segmentIndex + 1;
    }
    else {
        selectedPayment = segmentIndex;
    }
}

-(IBAction)ShowTaccsistas:(id)sender{
    CGRect frame_panel_vista = contenedor_vista.frame;
    CGRect frame_taccsistas = contenedor_taccsistas.frame;
    if (ShowTaccsistas==NO) {
        ShowTaccsistas = YES;
        frame_panel_vista.origin.x = frame_panel_vista.origin.x - width_;
        frame_taccsistas.origin.x = frame_taccsistas.origin.x - width_;
        contenedor_invisible.hidden = NO;
    }
    else{
        ShowTaccsistas = NO;
        frame_panel_vista.origin.x = frame_panel_vista.origin.x + width_;
        frame_taccsistas.origin.x = frame_taccsistas.origin.x + width_;
        contenedor_invisible.hidden = YES;
    }
    
    [UIView beginAnimations:Nil context:nil];
    [UIView setAnimationDuration:0.9];
    contenedor_vista.frame = frame_panel_vista;
    contenedor_taccsistas.frame = frame_taccsistas;
    [UIView commitAnimations];
}

-(IBAction)ShowMenu:(id)sender{
    CGRect frame_panel_vista = contenedor_vista.frame;
    CGRect frame_menu = contenedor_menu.frame;
    if (ShowMenu==NO) {
        ShowMenu = YES;
        frame_panel_vista.origin.x = frame_panel_vista.origin.x + width_;
        frame_menu.origin.x = frame_menu.origin.x + width_;
        contenedor_invisible.hidden = NO;
    }
    else{
        ShowMenu = NO;
        frame_panel_vista.origin.x = frame_panel_vista.origin.x - width_;
        frame_menu.origin.x = frame_menu.origin.x - width_;
        contenedor_invisible.hidden = YES;
    }
    
    [UIView beginAnimations:Nil context:nil];
    [UIView setAnimationDuration:0.9];
    contenedor_vista.frame = frame_panel_vista;
    contenedor_menu.frame = frame_menu;
    [UIView commitAnimations];
}

-(IBAction)ShowResumenViaje:(id)sender{
    if ([contenedor_resumen_fondo isHidden]){
        contenedor_resumen_fondo.hidden = NO;
        txt_origen.text = lbl_direccion.text;
    }
    else{
        contenedor_resumen_fondo.hidden = YES;
        lbl_direccion.text = txt_origen.text;
    }
}

-(IBAction)ShowInfoMiTaccsista:(id)sender{
    if ([contenedor_info_taccsista isHidden]){
        contenedor_info_taccsista.hidden = NO;
    }
    else{
        contenedor_info_taccsista.hidden = YES;
    }
}

-(IBAction)ShowPagarViaje:(id)sender{
    if ([contenedor_fin_viaje isHidden]){
        contenedor_fin_viaje.hidden = NO;
    }
    else{
        contenedor_fin_viaje.hidden = YES;
    }
}


-(void)BuscarTaccsisCercanos{
    if (reachable == YES) {
        if (actualizar_origen==YES && revisa_estatus == NO) {
            direccion_origen = @"";
            lbl_direccion.text = @"Buscando dirección...";
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://201.131.96.45/wbs/get_taccsis.php?lat=%@&lon=%@", lat_origen, lon_origen]];
                NSData* data =    [NSData dataWithContentsOfURL:
                                   url];
                NSString *respuesta = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
                respuesta = [respuesta stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSLog(@"%@", respuesta);
                NSData* datas = [respuesta dataUsingEncoding:NSUTF8StringEncoding];
                busca_taccsistas = YES;
                MAid_taccsistas               = [[NSMutableArray alloc]init];
                MAconductor_taccsistas  = [[NSMutableArray alloc]init];
                MAplacas_taccsistas        = [[NSMutableArray alloc]init];
                MAestatus_taccsistas       = [[NSMutableArray alloc]init];
                MAlatitud_taccsistas         = [[NSMutableArray alloc]init];
                MAlongitud_taccsistas      = [[NSMutableArray alloc]init];
                MAdistancia_taccsistas     = [[NSMutableArray alloc]init];
                MAfoto_taccsistas             = [[NSMutableArray alloc]init];
                MApuntos_taccsistas        = [[NSMutableArray alloc]init];
                MAservicios_taccsistas      = [[NSMutableArray alloc]init];
                [mapView_ clear];
                
                NSXMLParser *parser = [[NSXMLParser alloc] initWithData:datas];
                [parser setDelegate:self];
                if(![parser parse]){
                    NSLog(@"Error al parsear");
                }
                [parser setShouldProcessNamespaces:NO];
                [parser setShouldReportNamespacePrefixes:NO];
                [parser setShouldResolveExternalEntities:NO];
                [parser parse];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self PintaTaccsistas];
                });
            });
            
        }
    }
}

-(void)PintaTaccsistas{
    CLGeocoder *geocoders = [[CLGeocoder alloc] init];
    [geocoders reverseGeocodeLocation:self->LocacionSeleccionada completionHandler:^(NSArray *placemarks, NSError *error) {
        //10
        if(placemarks.count){
            NSDictionary *dictionary = [[placemarks objectAtIndex:0] addressDictionary];
            lbl_direccion.text = @"Buscando dirección...";
            direccion_origen = @"";
            if ([dictionary objectForKey:@"Thoroughfare"]) {
                direccion_origen = [NSString stringWithFormat:@"%@", [dictionary valueForKey:@"Thoroughfare"]];
                lbl_direccion.text = [NSString stringWithFormat:@"%@", [dictionary valueForKey:@"Thoroughfare"]];
            }
            if ([dictionary objectForKey:@"SubThoroughfare"]) {
                direccion_origen = [NSString stringWithFormat:@"%@ %@", direccion_origen, [dictionary valueForKey:@"SubThoroughfare"]];
                lbl_direccion.text = [NSString stringWithFormat:@"%@ %@", lbl_direccion.text, [dictionary valueForKey:@"SubThoroughfare"]];
            }
            if ([dictionary objectForKey:@"SubLocality"]) {
                direccion_origen = [NSString stringWithFormat:@"%@ %@", direccion_origen, [dictionary valueForKey:@"SubLocality"]];
                lbl_direccion.text = [NSString stringWithFormat:@"%@ %@", lbl_direccion.text, [dictionary valueForKey:@"SubLocality"]];
            }
            if ([dictionary objectForKey:@"ZIP"]) {
                direccion_origen = [NSString stringWithFormat:@"%@ %@", direccion_origen, [dictionary valueForKey:@"ZIP"]];
                lbl_direccion.text = [NSString stringWithFormat:@"%@ %@", lbl_direccion.text, [dictionary valueForKey:@"ZIP"]];
            }
            if ([dictionary objectForKey:@"State"]) {
                 direccion_origen = [NSString stringWithFormat:@"%@ %@", direccion_origen, [dictionary valueForKey:@"State"]];
                lbl_direccion.text = [NSString stringWithFormat:@"%@ %@", lbl_direccion.text, [dictionary valueForKey:@"State"]];
            }
        }
    }];
}

-(void)DescargaImagenes{
    if (reachable == YES) {
        if (![nombre_imagen_taccsista isEqualToString:@""]) {
            NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString* foofile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[nombre_imagen_taccsista stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@".png"]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                UIImage* pImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:foto_taccsista]]];
                
                NSData *webData = UIImagePNGRepresentation(pImage);
                [webData writeToFile:foofile atomically:YES];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *pImage;
                    pImage = [UIImage imageWithContentsOfFile:foofile];
                    nombre_imagen_taccsista = @"";
                    img_foto_taccsista.image = pImage;
                });
            });
        }
        if (descarga_imagen_usuario) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                
                NSArray* words = [Globalfoto_perfil componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString* nospacestring = [words componentsJoinedByString:@""];
                UIImage* pImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:nospacestring]]];
                NSData *webData = UIImagePNGRepresentation(pImage);
                [webData writeToFile:imagen_usuario atomically:YES];
                descarga_imagen_usuario = NO;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *pImage;
                    pImage = [UIImage imageWithContentsOfFile:imagen_usuario];
                    img_perfil.image = pImage;
                });
            });

        }
        if (actualizar_origen==YES) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                
                for (int i = 0; i<[MAImagenesxDescargar count]; i++) {
                    NSArray* words = [[MAImagenesxDescargar objectAtIndex:i] componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSString* nospacestring = [words componentsJoinedByString:@""];
                    UIImage* pImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:nospacestring]]];
                    NSData *webData = UIImagePNGRepresentation(pImage);
                    [webData writeToFile:[MAUbicacionImages objectAtIndex:i] atomically:YES];
                    contador_app++;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([MAid_taccsistas count] == [MAconductor_taccsistas count] == [MAplacas_taccsistas count] == [MAestatus_taccsistas count] == [MAlatitud_taccsistas count] == [MAlongitud_taccsistas count] == [MAdistancia_taccsistas count] == [MAfoto_taccsistas count] == [MApuntos_taccsistas count] == [MAservicios_taccsistas count]) {
                        MAUbicacionImages = [[NSMutableArray alloc] init];
                        MAImagenesxDescargar = [[NSMutableArray alloc]init];
                        [tbl_taccsistas reloadData];
                        
                    }
                });
            });
            
        }
    }
}

-(IBAction)UsarMiUbicacion:(id)sender{
    if ( revisa_estatus == NO) {
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
        lat_origen = [[NSNumber numberWithDouble:mi_ubicacion.coordinate.latitude] stringValue];
        lon_origen = [[NSNumber numberWithDouble:mi_ubicacion.coordinate.longitude] stringValue];
        [self BuscarTaccsisCercanos];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if ( revisa_estatus == NO) {
        mi_ubicacion = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude
                                                  longitude:newLocation.coordinate.longitude];
        if (usar_ubicacion_actual == YES) {
            GMSCameraPosition *sydney = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                                    longitude:newLocation.coordinate.longitude
                                                                         zoom:mapView_.camera.zoom];
            [mapView_ setCamera:sydney];
            LocacionSeleccionada = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude
                                                              longitude:newLocation.coordinate.longitude];
            lat_origen = [[NSNumber numberWithDouble:newLocation.coordinate.latitude] stringValue];
            lon_origen = [[NSNumber numberWithDouble:newLocation.coordinate.longitude] stringValue];
            usar_ubicacion_actual = NO;
            [self BuscarTaccsisCercanos];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (busca_taccsistas==YES){
        if ([elementName isEqualToString:@"id"]){
            [MAid_taccsistas addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
        if ([elementName isEqualToString:@"msg"])
            StringMsg = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([elementName isEqualToString:@"conductor"])
            [MAconductor_taccsistas addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if ([elementName isEqualToString:@"estatus"])
            [MAestatus_taccsistas addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if ([elementName isEqualToString:@"placas"])
            [MAplacas_taccsistas addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if ([elementName isEqualToString:@"latitud"])
            [MAlatitud_taccsistas addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if ([elementName isEqualToString:@"longitud"])
            [MAlongitud_taccsistas addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if ([elementName isEqualToString:@"distancia"])
            [MAdistancia_taccsistas addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if ([elementName isEqualToString:@"foto"])
            [MAfoto_taccsistas addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if ([elementName isEqualToString:@"puntos"])
            [MApuntos_taccsistas addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if ([elementName isEqualToString:@"servicios"])
            [MAservicios_taccsistas addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    else{
        if ([metodo_ isEqualToString:@"usrNuevoViaje"] || [metodo_ isEqualToString:@"EstatusMiViaje"] || [metodo_ isEqualToString:@"usrFinViaje"]) {
            if ([elementName isEqualToString:@"code"])
                StringCode = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([elementName isEqualToString:@"msg"])
                StringMsg = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([elementName isEqualToString:@"ll"]){
                NSString* Stringlatlon = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSArray* arrayll = [Stringlatlon componentsSeparatedByString:@"@"];
                if ([arrayll count] == 2) {
                    latitud_taccsista = [arrayll objectAtIndex:0];
                    longitud_taccsista = [arrayll objectAtIndex:1];
                }
            }
        }
        if ([metodo_ isEqualToString:@"usrDameInfoTaxista"]) {
            if ([elementName isEqualToString:@"code"])
                StringCode = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([elementName isEqualToString:@"msg"])
                StringMsg = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([elementName isEqualToString:@"nombre"])
                nombre_taccsista = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([elementName isEqualToString:@"apaterno"])
                apaterno_taccsista = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([elementName isEqualToString:@"amaterno"])
                amaterno_taccsista = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([elementName isEqualToString:@"telefono"])
                telefono_taccsista = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([elementName isEqualToString:@"marca"])
                marca_taccsista = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([elementName isEqualToString:@"modelo"])
                modelo_taccsista = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([elementName isEqualToString:@"placas"])
                placas_taccsista = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([elementName isEqualToString:@"eco"])
                eco_taccsista = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([elementName isEqualToString:@"foto_taxi"])
                foto_taccsi = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([elementName isEqualToString:@"foto_taxista"])
                foto_taccsista = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
      /*  else if ([metodo_ isEqualToString:@""]){
            
        }*/
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    //Document has been parsed. It's time to fire some new methods off!
    if (busca_taccsistas==YES) {
        busca_taccsistas = NO;
        if ([MAid_taccsistas count] == [MAconductor_taccsistas count] && [MAid_taccsistas count] == [MAplacas_taccsistas count] && [MAid_taccsistas count] == [MAestatus_taccsistas count] && [MAid_taccsistas count] == [MAlatitud_taccsistas count] && [MAid_taccsistas count] == [MAlongitud_taccsistas count] && [MAid_taccsistas count] == [MAdistancia_taccsistas count] && [MAid_taccsistas count] == [MAfoto_taccsistas count] && [MAid_taccsistas count] == [MApuntos_taccsistas count] && [MAid_taccsistas count] == [MAservicios_taccsistas count]) {
            lbl_total_taccsistas.text = [NSString stringWithFormat:@"%zd taccsistas cercanos", [MAlatitud_taccsistas count]];
            [tbl_taccsistas reloadData];
        }
    }
    else
        [self FillArray];
}

-(void)FillArray{
    
    [self Animacion:2];
    
    if ([metodo_ isEqualToString:@"usrNuevoViaje"]) {
        if ([StringCode integerValue]<0) {
            NSString* mensajeAlerta = StringMsg;
            //  NSInteger code = [StringCode intValue];
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"TACCSI"
                                                              message:mensajeAlerta
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
            [self Animacion:2];
        }
        else{
            estatus_viaje =1;
            [self EscribeArchivo_id_estatus_viaje:@"1" id_viaje:StringCode lat_origen:lat_origen lon_origen:lon_origen lat_destino:lat_destino_viaje lon_destino:lon_destino_viaje id_taccsista:id_taccsista clave_confirmacion:@"" foto_taccsista:@"" nombre_taccsista:@"" apaterno_taccsista:@"" amaterno_taccsista:@"" telefono:@"" marca:@"" modelo:@"" placas:@"" eco:@"" foto_taccsi:@"" direccion_origen:direccion_origen forma_pago:@"" importe:@"" direccion_destino:direccion_destino_viaje pasajeros:pasajeros];
            
            [self ShowResumenViaje:self];
            [self PintaPantallaXEstatus];
        }
    }
    else if ([metodo_ isEqualToString:@"usrDameInfoTaxista"]){
        if ([StringCode integerValue]>=0) {
            NSArray* array_viaje = [self DameInfoVIaje];
            [self EscribeArchivo_id_estatus_viaje:@"2" id_viaje:[array_viaje objectAtIndex:1] lat_origen:[array_viaje objectAtIndex:2] lon_origen:[array_viaje objectAtIndex:3] lat_destino:[array_viaje objectAtIndex:4] lon_destino:[array_viaje objectAtIndex:5] id_taccsista:[array_viaje objectAtIndex:6] clave_confirmacion:[array_viaje objectAtIndex:7] foto_taccsista:foto_taccsista nombre_taccsista:nombre_taccsista apaterno_taccsista:apaterno_taccsista amaterno_taccsista:amaterno_taccsista telefono:telefono_taccsista marca:marca_taccsista modelo:modelo_taccsista placas:placas_taccsista eco:eco_taccsista foto_taccsi:foto_taccsista direccion_origen:[array_viaje objectAtIndex:18] forma_pago:[array_viaje objectAtIndex:19] importe:[array_viaje objectAtIndex:20] direccion_destino:[array_viaje objectAtIndex:21] pasajeros:[array_viaje objectAtIndex:22]];
            
            lbl_nombre_taccsista.text = [NSString stringWithFormat:@"%@ %@ %@", nombre_taccsista, apaterno_taccsista, amaterno_taccsista];
            lbl_eco__taccsista.text = [NSString stringWithFormat:@"Eco: %@", eco_taccsista];
            lbl_placas_taccsista.text = [NSString stringWithFormat:@"Placas: %@", placas_taccsista];
            lbl_marca_taccsista.text = [NSString stringWithFormat:@"Marca: %@", marca_taccsista];
            lbl_modelo_taccsista.text  = [NSString stringWithFormat:@"Modelo: %@", modelo_taccsista];
            lbl_telefono_taccsista.text  = [NSString stringWithFormat:@"Teléfono: %@", telefono_taccsista];
            nombre_imagen_taccsista  = [NSString stringWithFormat:@"%@%@%@_%@", nombre_taccsista, apaterno_taccsista, amaterno_taccsista, [array_viaje objectAtIndex:6]];
            
            [self DescargaImagenes];
            
            btn_mi_taccsista.hidden = NO;
            tengo_datos_viaje = YES;
            [self PintaPantallaXEstatus];
        }
        
            
    }
    else if ([metodo_ isEqualToString:@"EstatusMiViaje"]){
          if ([StringCode integerValue]>=0) {
              NSArray* datos_viaje = [self DameInfoVIaje];
              NSArray *array_ = [StringMsg componentsSeparatedByString:@"@"];
            //  switch (estatus_viaje) {
               switch ([StringCode integerValue]) {
                  case 1:{
                      if ([[array_ objectAtIndex:0] isEqualToString:@"CANCELADO"]){
                          estatus_viaje = 1;
                          id_taccsista = @"0";
                          UIAlertView* alert_  = [[UIAlertView alloc] initWithTitle:@"Viaje Cancelado" message:[NSString stringWithFormat:@"Razón: %@", [array_ objectAtIndex:2]]delegate:self cancelButtonTitle:@"Intentar nuevamente" otherButtonTitles:@"Llamar al 01 800", @"Cancelar", nil];
                          [alert_ setTag:1];
                          [alert_ show];
                          
                          [self PintaPantallaXEstatus];
                      }
                      if ([array_ count]==2 ) {
                          if ([[array_ objectAtIndex:0]isEqualToString:@"SIN RESPUESTA"]) {
                              UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"TACCSI" message:@"No hay TACCSISTAS disponibles" delegate:self cancelButtonTitle:@"Intentar nuevamente" otherButtonTitles:@"Llamar al 01 800", @"Cancelar", nil];
                              [alert setTag:1];
                              [alert show];
                          }
                      }
                  }
                      break;
                   case 2:{
                       if ([array_ count]==3) {
                           if ([[array_ objectAtIndex:0] isEqualToString:@"ASIGNADO"]) {
                               estatus_viaje = 2;
                               [self EscribeArchivo_id_estatus_viaje:@"2" id_viaje:[datos_viaje objectAtIndex:1] lat_origen:[datos_viaje objectAtIndex:2] lon_origen:[datos_viaje objectAtIndex:3] lat_destino:[datos_viaje objectAtIndex:4] lon_destino:[datos_viaje objectAtIndex:5] id_taccsista:[array_ objectAtIndex:1] clave_confirmacion:[NSString stringWithFormat:@"Confirmación: %@", [array_ objectAtIndex:2]] foto_taccsista:[datos_viaje objectAtIndex:8] nombre_taccsista:[datos_viaje objectAtIndex:9] apaterno_taccsista:[datos_viaje objectAtIndex:10] amaterno_taccsista:[datos_viaje objectAtIndex:11] telefono:[datos_viaje objectAtIndex:12] marca:[datos_viaje objectAtIndex:13] modelo:[datos_viaje objectAtIndex:14] placas:[datos_viaje objectAtIndex:15] eco:[datos_viaje objectAtIndex:16] foto_taccsi:[datos_viaje objectAtIndex:17] direccion_origen:[datos_viaje objectAtIndex:18] forma_pago:[datos_viaje objectAtIndex:19] importe:[datos_viaje objectAtIndex:20] direccion_destino:[datos_viaje objectAtIndex:21] pasajeros:[datos_viaje objectAtIndex:22]];
                               lbl_confirmacion_viaje.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"Confirmación: %@", [array_ objectAtIndex:2]]];
                               [self PintaPantallaXEstatus];
                           }
                       }
                   }
                       break;
                   case 3:{
                       estatus_viaje = 3;
                       [self EscribeArchivo_id_estatus_viaje:@"3" id_viaje:[datos_viaje objectAtIndex:1] lat_origen:[datos_viaje objectAtIndex:2]  lon_origen:[datos_viaje objectAtIndex:3]  lat_destino:[datos_viaje objectAtIndex:4]  lon_destino:[datos_viaje objectAtIndex:5]  id_taccsista:[datos_viaje objectAtIndex:6]  clave_confirmacion:[datos_viaje objectAtIndex:7]  foto_taccsista:[datos_viaje objectAtIndex:8]  nombre_taccsista:[datos_viaje objectAtIndex:9]  apaterno_taccsista:[datos_viaje objectAtIndex:10]  amaterno_taccsista:[datos_viaje objectAtIndex:11]  telefono:[datos_viaje objectAtIndex:12]  marca:[datos_viaje objectAtIndex:13]  modelo:[datos_viaje objectAtIndex:14]  placas:[datos_viaje objectAtIndex:15]  eco:[datos_viaje objectAtIndex:16]  foto_taccsi:[datos_viaje objectAtIndex:11]  direccion_origen:[datos_viaje objectAtIndex:18]  forma_pago:[datos_viaje objectAtIndex:19]  importe:[array_ objectAtIndex:1]  direccion_destino:[datos_viaje objectAtIndex:21]  pasajeros:[datos_viaje objectAtIndex:22] ];
                       
                       
                       [self PintaPantallaXEstatus];
                   }
                       break;
                  case 4:{
                      estatus_viaje = 1;
                      id_taccsista = @"0";
                      UIAlertView* alert_  = [[UIAlertView alloc] initWithTitle:@"Viaje Cancelado" message:[NSString stringWithFormat:@"Razón: %@", [array_ objectAtIndex:2]]delegate:self cancelButtonTitle:@"Intentar nuevamente" otherButtonTitles:@"Llamar al 01 800", @"Cancelar", nil];
                      [alert_ setTag:1];
                      [alert_ show];
                      
                      [self PintaPantallaXEstatus];
                  }
                      break;
                   case 5:{
                       NSArray* datos_taccsista = [self DameInfoVIaje];
                       estatus_viaje = 5;
                       [self EscribeArchivo_id_estatus_viaje:@"5" id_viaje:[datos_taccsista objectAtIndex:1]lat_origen:[datos_taccsista objectAtIndex:2] lon_origen:[datos_taccsista objectAtIndex:3] lat_destino:[datos_taccsista objectAtIndex:4] lon_destino:[datos_taccsista objectAtIndex:5] id_taccsista:[datos_taccsista objectAtIndex:6] clave_confirmacion:[datos_taccsista objectAtIndex:7] foto_taccsista:[datos_taccsista objectAtIndex:8] nombre_taccsista:[datos_taccsista objectAtIndex:9] apaterno_taccsista:[datos_taccsista objectAtIndex:10] amaterno_taccsista:[datos_taccsista objectAtIndex:11] telefono:[datos_taccsista objectAtIndex:12] marca:[datos_taccsista objectAtIndex:13] modelo:[datos_taccsista objectAtIndex:14] placas:[datos_taccsista objectAtIndex:15] eco:[datos_taccsista objectAtIndex:16] foto_taccsi:[datos_taccsista objectAtIndex:17] direccion_origen:[datos_taccsista objectAtIndex:18] forma_pago:[datos_taccsista objectAtIndex:19] importe:[datos_taccsista objectAtIndex:20] direccion_destino:[datos_taccsista objectAtIndex:21] pasajeros:[datos_taccsista objectAtIndex:22]];
                       if (!tengo_datos_viaje) {
                           [self RevisaDatosTaccsista];
                       }
                       else{
                           marker_taccsista = nil;
                            CLLocationCoordinate2D position_taccsista = CLLocationCoordinate2DMake([latitud_taccsista doubleValue], [longitud_taccsista doubleValue]);
                           marker_taccsista = [GMSMarker markerWithPosition:position_taccsista];
                           marker_taccsista.title = [NSString stringWithFormat:@"%@, @%@, %@", [datos_taccsista objectAtIndex:9], [datos_taccsista objectAtIndex:10], [datos_taccsista objectAtIndex:11]];
                           marker_taccsista.icon = [UIImage imageNamed:@"taxi.png"];
                           marker_taccsista.map = mapView_;
                       }
                       [self PintaPantallaXEstatus];
                   }
                       break;
                  default:{
                      estatus_viaje = 0;
                      [self EscribeArchivo_id_estatus_viaje:@"" id_viaje:@"" lat_origen:@"" lon_origen:@"" lat_destino:@"" lon_destino:@"" id_taccsista:@"" clave_confirmacion:@"" foto_taccsista:@"" nombre_taccsista:@"" apaterno_taccsista:@"" amaterno_taccsista:@"" telefono:@"" marca:@"" modelo:@"" placas:@"" eco:@"" foto_taccsi:@"" direccion_origen:@"" forma_pago:@"" importe:@"" direccion_destino:@"" pasajeros:@""];
                      [self PintaPantallaXEstatus];
                  }
                      break;
              }
          }
          else{
              estatus_viaje = 0;
              [self EscribeArchivo_id_estatus_viaje:@"" id_viaje:@"" lat_origen:@"" lon_origen:@"" lat_destino:@"" lon_destino:@"" id_taccsista:@"" clave_confirmacion:@"" foto_taccsista:@"" nombre_taccsista:@"" apaterno_taccsista:@"" amaterno_taccsista:@"" telefono:@"" marca:@"" modelo:@"" placas:@"" eco:@"" foto_taccsi:@"" direccion_origen:@"" forma_pago:@"" importe:@"" direccion_destino:@"" pasajeros:@""];
              [self PintaPantallaXEstatus];
          }
    }
    else if ([metodo_ isEqualToString:@"usrFinViaje"]){
        [self Animacion:2];
        if ([StringCode integerValue]<0) {
            NSString* mensajeAlerta = StringMsg;
            //  NSInteger code = [StringCode intValue];
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"TACCSI"
                                                              message:mensajeAlerta
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
        else{
            NSString* FileName = [NSString stringWithFormat:@"%@/Estatus.txt", documentsDirectory];
            [@"Error" writeToFile:FileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
            NSString* InicioViaje_FileName = [NSString stringWithFormat:@"%@/InicioViaje.txt", documentsDirectory];
            [@"Error" writeToFile:InicioViaje_FileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
            NSString* FileName_paypal = [NSString stringWithFormat:@"%@/Paypal.txt", documentsDirectory];
            [@"Error" writeToFile:FileName_paypal atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
            estatus_viaje = 0;
            [self EscribeArchivo_id_estatus_viaje:@"" id_viaje:@"" lat_origen:@"" lon_origen:@"" lat_destino:@"" lon_destino:@"" id_taccsista:@"" clave_confirmacion:@"" foto_taccsista:@"" nombre_taccsista:@"" apaterno_taccsista:@"" amaterno_taccsista:@"" telefono:@"" marca:@"" modelo:@"" placas:@"" eco:@"" foto_taccsi:@"" direccion_origen:@"" forma_pago:@"" importe:@"" direccion_destino:@"" pasajeros:@""];
            [self PintaPantallaXEstatus];
        }
    }
    else{
        estatus_viaje = 0;
        [self EscribeArchivo_id_estatus_viaje:@"" id_viaje:@"" lat_origen:@"" lon_origen:@"" lat_destino:@"" lon_destino:@"" id_taccsista:@"" clave_confirmacion:@"" foto_taccsista:@"" nombre_taccsista:@"" apaterno_taccsista:@"" amaterno_taccsista:@"" telefono:@"" marca:@"" modelo:@"" placas:@"" eco:@"" foto_taccsi:@"" direccion_origen:@"" forma_pago:@"" importe:@"" direccion_destino:@"" pasajeros:@""];
        [self PintaPantallaXEstatus];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1) {
        if (buttonIndex==0) {
            NSArray* datos_viaje = [self DameInfoVIaje];
            if ([datos_viaje count]>0) {
                NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"usuario", @"dispositivo", @"push_token",@"origen", @"destino", @"lat_origen", @"lon_origen", @"lat_destino", @"lon_destino", @"personas", @"pago", @"descuento", @"id_conductor", @"so",  nil];
                NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:GlobalUsu , DeviceToken, DeviceToken, [datos_viaje objectAtIndex:18], [datos_viaje objectAtIndex:21], [datos_viaje objectAtIndex:2], [datos_viaje objectAtIndex:3], [datos_viaje objectAtIndex:4], [datos_viaje objectAtIndex:5], [datos_viaje objectAtIndex:22] ,[datos_viaje objectAtIndex:19], @"", [datos_viaje objectAtIndex:6], @"I", nil];
                metodo_ = @"usrNuevoViaje";
                [soapTool callSoapServiceWithParameters__functionName:@"usrNuevoViaje" tags:tags vars:vars wsdlURL:@"http://201.131.96.45/wbs/wbs_taccsi.php?wsdl"];
                [self Animacion:1];
            }
            else{
                estatus_viaje = 0;
                [self PintaPantallaXEstatus];
            }
            
           
            
        }
        else if (buttonIndex==1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:+525555620772"]]];
        }
        else if (buttonIndex == 2){
            estatus_viaje = 0;
            [self PintaPantallaXEstatus];
        }
    }
    
    if (alertView.tag==2) {
        if (buttonIndex==0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", telefono_taccsista]]];
            
        }
    }
}

-(IBAction)LlamarTaccsista:(id)sender{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"TACCSI" message:@"Esta llamada puede tener costo" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles: @"Cancelar", nil];
    [alert setTag:2];
    [alert show];
    
}

-(void)PintaPantallaXEstatus{

    /*
     estatus 0
     btn_taccsi_navbar.hidden = NO;
     btn_home_map_check.hidden = NO;
     contenedor_taccsistas.hidden = NO;
     contenedor_direccion.hidden = NO;
     img_origen.hidden = NO;
     
     
     estatus 1
     lbl_informacion_viaje.hidden = YES;
     
     estatus 2
     
     lbl_confirmacion_viaje.hidden = YES;
     btn_cancelar_viaje.hidden = YES;
     btn_mi_taccsista.hidden = YES;
     contenedor_info_taccsista.hidden = YES;
     
     */
    
    [contadorTimer invalidate];
    switch (estatus_viaje) {
        case 0:{
            btn_taccsi_navbar.hidden = NO;
            btn_home_map_check.hidden = NO;
            contenedor_taccsistas.hidden = NO;
            contenedor_direccion.hidden = NO;
            img_origen.hidden = NO;
            
            lbl_informacion_viaje.hidden = YES;
            
            lbl_confirmacion_viaje.hidden = YES;
            btn_cancelar_viaje.hidden = YES;
            btn_mi_taccsista.hidden = YES;
            contenedor_info_taccsista.hidden = YES;
            
            btn_show_fin_viaje.hidden = YES;
            
            revisa_estatus = NO;
            busca_taccsistas = YES;
            [self EscribeArchivo_id_estatus_viaje:@"" id_viaje:@"" lat_origen:@"" lon_origen:@"" lat_destino:@"" lon_destino:@"" id_taccsista:@"" clave_confirmacion:@"" foto_taccsista:@"" nombre_taccsista:@"" apaterno_taccsista:@"" amaterno_taccsista:@"" telefono:@"" marca:@"" modelo:@"" placas:@"" eco:@"" foto_taccsi:@"" direccion_origen:@"" forma_pago:@"" importe:@"" direccion_destino:@"" pasajeros:@""];
      /*   buug de la camara cuando regresa
       
       LocacionSeleccionada =
            [[CLLocation alloc] initWithLatitude:mapView_.camera.
                                       longitude:cameraPosition.target.longitude];
            // CLGeocoder *geocoders = [[CLGeocoder alloc] init];
            
            lat_origen = [[NSNumber numberWithDouble:cameraPosition.target.latitude] stringValue];
            lon_origen = [[NSNumber numberWithDouble:cameraPosition.target.longitude] stringValue];
            NSLog(@"Latitud Origen: %@,  Longitud Origen: %@", lat_origen, lon_origen);
            [self BuscarTaccsisCercanos];*/
        }
            break;
        case 1:{
            revisa_estatus = YES;
            busca_taccsistas = NO;
            [mapView_ clear];
            btn_taccsi_navbar.hidden = YES;
            btn_home_map_check.hidden = YES;
            contenedor_taccsistas.hidden = YES;
            contenedor_direccion.hidden = YES;
            img_origen.hidden = YES;
            
            lbl_informacion_viaje.hidden = NO;
            
            lbl_confirmacion_viaje.hidden = YES;
            btn_cancelar_viaje.hidden = YES;
            btn_mi_taccsista.hidden = YES;
            contenedor_info_taccsista.hidden = YES;
            
            btn_show_fin_viaje.hidden = YES;
            
            NSArray* array_ = [self DameInfoVIaje];
            if ([array_ count]>0) {
                GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[array_ objectAtIndex:2] doubleValue]
                                                                        longitude:[[array_ objectAtIndex:3] doubleValue]
                                                                             zoom:mapView_.camera.zoom];
                 [mapView_ setCamera:camera];
            }
            if (![contadorTimer isValid]) {
                revisa_estatus = YES;
                contadorTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(actualizarxtimer:) userInfo:nil repeats:YES];
            }
        }
            break;
        case 2:{
            revisa_estatus = YES;
            busca_taccsistas = NO;
            btn_taccsi_navbar.hidden = YES;
            btn_home_map_check.hidden = YES;
            contenedor_taccsistas.hidden = YES;
            contenedor_direccion.hidden = YES;
            img_origen.hidden = YES;
            
            lbl_informacion_viaje.hidden = YES;
            
            lbl_confirmacion_viaje.hidden = NO;
            btn_cancelar_viaje.hidden = NO;
            contenedor_info_taccsista.hidden = YES;
            
            btn_show_fin_viaje.hidden = YES;
            
            if (!tengo_datos_viaje) {
                [self RevisaDatosTaccsista];
            }
            
        }
            break;
        case 3:{
            
            revisa_estatus = YES;
            busca_taccsistas = NO;
            btn_taccsi_navbar.hidden = YES;
            btn_home_map_check.hidden = YES;
            contenedor_taccsistas.hidden = YES;
            contenedor_direccion.hidden = YES;
            img_origen.hidden = YES;
            
            lbl_informacion_viaje.hidden = YES;
            
            lbl_confirmacion_viaje.hidden = YES;
            btn_cancelar_viaje.hidden = YES;
            contenedor_info_taccsista.hidden = YES;
            
            btn_show_fin_viaje.hidden = NO;
            
            NSArray* info_viaje = [self DameInfoVIaje];
            
            lbl_total_fin_viaje.text = [NSString stringWithFormat:@" $ %.2f", [[info_viaje objectAtIndex:20]  floatValue]];
            
            if ([[info_viaje objectAtIndex:19] isEqualToString:@"1"]) {
                lbl_forma_pago_fin_viaje.text = @"Pago en efectivo";
            }
            else{
                lbl_forma_pago_fin_viaje.text = @"Pago con PayPal";
            }
            
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-[[info_viaje objectAtIndex:2] doubleValue]
                                                                    longitude:[[info_viaje objectAtIndex:3] doubleValue]
                                                                         zoom:15];
            [mapView_ setCamera:camera];
            
            [mapView_ clear];
            
        }
            break;
        case 5:{
            revisa_estatus = YES;
            busca_taccsistas = NO;
            btn_taccsi_navbar.hidden = YES;
            btn_home_map_check.hidden = YES;
            contenedor_taccsistas.hidden = YES;
            contenedor_direccion.hidden = YES;
            img_origen.hidden = YES;
            
            lbl_informacion_viaje.hidden = YES;
            
            lbl_confirmacion_viaje.text = @"DIsfrute su viaje";
            btn_cancelar_viaje.hidden = YES;
            if (!tengo_datos_viaje) {
                [self RevisaDatosTaccsista];
            }
            if (![contadorTimer isValid]) {
                revisa_estatus = YES;
                contadorTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(actualizarxtimer:) userInfo:nil repeats:YES];
            }
        }
            break;
        default:{
            btn_taccsi_navbar.hidden = NO;
            btn_home_map_check.hidden = NO;
            contenedor_taccsistas.hidden = NO;
            contenedor_direccion.hidden = NO;
            img_origen.hidden = NO;
            lbl_informacion_viaje.hidden = YES;
            revisa_estatus = NO;
            busca_taccsistas = YES;
            [self EscribeArchivo_id_estatus_viaje:@"" id_viaje:@"" lat_origen:@"" lon_origen:@"" lat_destino:@"" lon_destino:@"" id_taccsista:@"" clave_confirmacion:@"" foto_taccsista:@"" nombre_taccsista:@"" apaterno_taccsista:@"" amaterno_taccsista:@"" telefono:@"" marca:@"" modelo:@"" placas:@"" eco:@"" foto_taccsi:@"" direccion_origen:@"" forma_pago:@"" importe:@"" direccion_destino:@"" pasajeros:@""];
        }
            break;
    }
}



-(IBAction)PagarViaje:(id)sender{
    busca_taccsistas = NO;
    if ([forma_pago isEqualToString:@"4"] && pago_completo == NO) {
        [self PagarPaypal:self];
    }
    else{
        if (reachable) {
            NSArray* datos_viaje = [self DameInfoVIaje];
            float distancia_from = distancia;
            NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"id_usuario", @"id_viaje", @"comentarios",@"puntos_servicio", @"puntos_taxista", @"importe", @"distancia", nil];
            NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:GlobalID ,[datos_viaje objectAtIndex:1], @"", [NSString stringWithFormat:@"%0.f", slider__fin_viaje.value], @"",  [NSString stringWithFormat:@"%.2f", [[datos_viaje objectAtIndex:20]  floatValue]], [NSString stringWithFormat:@"%.2f", distancia_from / 1000], nil];
            
            [soapTool callSoapServiceWithParameters__functionName:@"usrFinViaje" tags:tags vars:vars wsdlURL:@"http://201.131.96.45/wbs/wbs_taccsi.php?wsdl"];
            [self Animacion:1];
        }
        else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"TACCSI" message:@"No existe conexión a internet" delegate:nil cancelButtonTitle:@"Aceptat" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger retorno = 0;
    if (tableView == tbl_taccsistas)
        retorno = 1;
    else if (tableView == tbl_menu)
        retorno = 1;
    
    return retorno;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger retorno = 0;
    if (tableView == tbl_menu){
        if (usuario_logueado == YES)
            retorno = [array_menu_logueado count];
        else
            retorno = [array_menu count];
    }
    else if (tableView == tbl_taccsistas){
        retorno = [MAid_taccsistas count];
    }
    
    return retorno;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *simpleTableIdentifier = @"TableCell";
    SimpleTableCell *cell;
    if (tableView == tbl_menu) {
        cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSString* NibName = @"SimpleTableCell";
      //      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
       //         NibName = @"TableCell_Ipad";
         //   }
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NibName owner:self options:nil];
            cell = [nib objectAtIndex:2];
        }
        //      cell.img_menu.image = [UIImage imageNamed:@"motor_off.png"];
        if (usuario_logueado == YES){
            cell.lbl_menu.text = [array_menu_logueado objectAtIndex:indexPath.row];
            if (indexPath.row==3) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        else{
            cell.lbl_menu.text = [array_menu objectAtIndex:indexPath.row];
            if (indexPath.row==1) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        
        //        index_menu++;
    }
    else if (tableView == tbl_taccsistas){
        cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSString* NibName = @"SimpleTableCell";
    //        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
      //          NibName = @"TableCell_Ipad";
       //     }
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NibName owner:self options:nil];
            cell = [nib objectAtIndex:1];
        }
        
        NSLog(@"%@%@%@%@%@%@%@%@%@%@", MAid_taccsistas,MAconductor_taccsistas,MAplacas_taccsistas,MAestatus_taccsistas,MAlatitud_taccsistas,MAlongitud_taccsistas,MAdistancia_taccsistas,MAfoto_taccsistas,MApuntos_taccsistas,MAservicios_taccsistas);
        
        
        
        cell.nombre_taccsista.text = [MAplacas_taccsistas objectAtIndex:indexPath.row];
        cell.distancia_taccsista.text = [NSString stringWithFormat:@"A %@ km de distancia", [MAdistancia_taccsistas objectAtIndex:indexPath.row]];
        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* foofile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[[MAid_taccsistas objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@".png"]];
        UIImage *pImage;
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
        if (!fileExists || contador_app == 0) {
            pImage = [UIImage imageNamed:@"sin_foto.png"];
            [MAImagenesxDescargar addObject:[MAfoto_taccsistas objectAtIndex:indexPath.row]];
            [MAUbicacionImages addObject:foofile];
        }
        else
            pImage = [UIImage imageWithContentsOfFile:foofile];
        
       // UIImage *myIcon = [self scaleImage:pImage toSize:CGSizeMake(100, 100)];
        cell.img_taccsista.image = pImage;
        
        CLLocationCoordinate2D position_taccsista = CLLocationCoordinate2DMake([[MAlatitud_taccsistas objectAtIndex:indexPath.row] doubleValue], [[MAlongitud_taccsistas objectAtIndex:indexPath.row] doubleValue]);
        GMSMarker* marker_taccsistas = [GMSMarker markerWithPosition:position_taccsista];
        NSString* estatus_ = [MAestatus_taccsistas objectAtIndex:indexPath.row];
        UIImage* image_;
        if ([ estatus_ isEqualToString:@"taxi_ocupado"]){
            estatus_ = @"Taccsi ocupado";
            image_ =  [UIImage imageNamed:@"taxi_ocupado"];
            marker_taccsistas.icon = image_;
        }
        else if ([ estatus_ isEqualToString:@"taxi_servicio"]){
            estatus_ = @"Taccsi en servicio";
           image_ = [UIImage imageNamed:@"taxi_servicio"];
            marker_taccsistas.icon = image_;
        }
        else if ([ estatus_ isEqualToString:@"taxi_libre"]){
            estatus_ = @"Taccsista libre";
           image_= [UIImage imageNamed:@"taxi_libre"];
            marker_taccsistas.icon = image_;
        }
        
        if (revisa_estatus == NO) {
            marker_taccsistas.title = [MAconductor_taccsistas objectAtIndex:indexPath.row];
            marker_taccsistas.appearAnimation = kGMSMarkerAnimationPop;
            marker_taccsistas.map = mapView_;
        }
        
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
  /*      UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 80, 310, 1)];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 120, 1020, 1)];
        separatorLineView.backgroundColor = [UIColor grayColor]; // set color as you want.
        [cell.contentView addSubview:separatorLineView];*/
        
        
        if (indexPath.row == [MAlatitud_taccsistas count] - 1) {
            contador_app++;
            if ([MAImagenesxDescargar count] != 0) {
                [self DescargaImagenes];
            }
        }
    }
    return cell;
    
}

//Change the Height of the Cell [Default is 44]:
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    float retorno = 35;
    if (tableView == tbl_taccsistas) {
        retorno = 60;
    }
    return retorno;
}

#pragma mark - UITableViewDataSource
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==tbl_menu) {
        if (indexPath.row == 0 && usuario_logueado == NO) {
            [self IrLogin];
        }
        if (indexPath.row == 0 && usuario_logueado == YES) {
         /*   logueo = NO;
            NSString* view_name = @"MiCuenta";
            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                if (screenSize.height == 568.0f) {
                    view_name = [view_name stringByAppendingString:@"_iPhone5"];
                }
                if (screenSize.height == 667.0f) {
                    view_name = [view_name stringByAppendingString:@"_iPhone6"];
                }
                if (screenSize.height == 736.0f) {
                    view_name = [view_name stringByAppendingString:@"_iPhone6plus"];
                }
            } else {
                view_name = [view_name stringByAppendingString:@"_iPad"];
                
            }
            
            MiCuenta *view = [[MiCuenta alloc] initWithNibName:view_name bundle:nil];
            view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:view animated:YES completion:nil];*/
        }
        if (indexPath.row == 1 && usuario_logueado == NO) {
         //   [self ShowAyuda:self];
        }
        if (indexPath.row == 1 && usuario_logueado == YES) {
          /*  logueo = NO;
            formulario_atras_lugares = @"Portada";
            NSString* view_name = @"MisLugares";
            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                if (screenSize.height == 568.0f) {
                    view_name = [view_name stringByAppendingString:@"_iPhone5"];
                }
                if (screenSize.height == 667.0f) {
                    view_name = [view_name stringByAppendingString:@"_iPhone6"];
                }
                if (screenSize.height == 736.0f) {
                    view_name = [view_name stringByAppendingString:@"_iPhone6plus"];
                }
            } else {
                view_name = [view_name stringByAppendingString:@"_iPad"];
                
            }
            
            MisLugares *view = [[MisLugares alloc] initWithNibName:view_name bundle:nil];
            view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:view animated:YES completion:nil];*/
        }
        if (indexPath.row==2) {
       //     [self ShowAyuda:self];
        }
        if (indexPath.row == 3) {
            
            usuario_logueado = NO;
            GlobalAmaterno = @"";
            GlobalApaterno = @"";
            GlobalCorreo = @"";
            GlobalID = @"";
            GlobalNombre = @"";
            GlobalPass  = @"";
            GlobalTelefono = @"";
            GlobalUsu = @"";
            self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"taccsi_bd.sql"];
            NSString *query = [NSString stringWithFormat:@"delete from TABLE_USUARIOS"];
            [self.dbManager executeQuery:query];
            if (self.dbManager.affectedRows != 0)
                NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            else
                NSLog(@"Could not execute the query.");
            img_perfil.image = [UIImage imageNamed:@"img_menu"];
            lbl_perfil.text = @"TACCSI";
            [tbl_menu reloadData];
        }
    }
    if (tableView==tbl_taccsistas) {
        NSString* estatus_ = [MAestatus_taccsistas objectAtIndex:indexPath.row];
        if ([ estatus_ isEqualToString:@"taxi_libre"]){
            id_taccsista = [NSString stringWithFormat:@"%ld" , (long)[[MAid_taccsistas objectAtIndex:indexPath.row] integerValue]];
       //     [self ShowTaccsistas:self];
            [self ShowResumenViaje:self];
          //  [self PedirTaccsi:self];
        }
        
        
    }
    return indexPath;
    
}

#pragma mark - GMSMapViewDelegate



- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    return NO;
}

- (void)mapView:(GMSMapView *)mapView
idleAtCameraPosition:(GMSCameraPosition *)cameraPosition {
    if ( revisa_estatus == NO) {
        if (mapView==mapView_) {
            if (actualizar_origen==NO) {
                actualizar_origen = YES;
                lbl_direccion.text = direccion_origen;
            }
            else{
                LocacionSeleccionada =
                [[CLLocation alloc] initWithLatitude:cameraPosition.target.latitude
                                           longitude:cameraPosition.target.longitude];
                // CLGeocoder *geocoders = [[CLGeocoder alloc] init];
                
                lat_origen = [[NSNumber numberWithDouble:cameraPosition.target.latitude] stringValue];
                lon_origen = [[NSNumber numberWithDouble:cameraPosition.target.longitude] stringValue];
                NSLog(@"Latitud Origen: %@,  Longitud Origen: %@", lat_origen, lon_origen);
                [self BuscarTaccsisCercanos];
            }
            
        }
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

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
    
    float width = newSize.width;
    float height = newSize.height;
    
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    if(height < width)
        rect.origin.y = height / 3;
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    if (ShowTaccsistas) {
        [self ShowTaccsistas:self];
    }
    else if (ShowMenu){
         [self ShowMenu:self];
    }
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(IBAction)PagarPaypal:(id)sender{
    // Create a PayPalPayment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    
    // Amount, currency, and description
    payment.amount = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@" $ %.2f", [total_pago floatValue]]];
    payment.currencyCode = @"MXN";
    payment.shortDescription = @"Servicio";
    PayPalPaymentViewController *paymentViewController;
    paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                   configuration:self.payPalConfiguration
                                                                        delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    [self verifyCompletedPayment:completedPayment];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
    NSString* FileName_paypal = [NSString stringWithFormat:@"%@/Paypal.txt", documentsDirectory];
    [@"Completo" writeToFile:FileName_paypal atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    pago_completo = YES;
}

@end
