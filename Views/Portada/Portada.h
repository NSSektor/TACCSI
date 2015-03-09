//
//  Portada.h
//  TACCSI
//
//  Created by Angel Rivas on 2/12/15.
//  Copyright (c) 2015 Tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "SYSoapTool.h"
#import "CustomSegmentedControl.h"
#import "DBManager.h"
#import "PayPalMobile.h"

@interface Portada : UIViewController<CLLocationManagerDelegate,UITableViewDataSource, UITableViewDelegate,NSXMLParserDelegate,SOAPToolDelegate,GMSMapViewDelegate, UITextFieldDelegate,CustomSegmentedControlDelegate,UIAlertViewDelegate,PayPalPaymentDelegate>{
    
    IBOutlet UIView*           contenedor_vista;
    IBOutlet UIView*           contenedor_invisible;
    
    IBOutlet UIImageView* navbar;
    IBOutlet UILabel*          lbl_navbar;
    IBOutlet UIButton*        btn_home_navbar;
    IBOutlet UIButton*        btn_taccsi_navbar;
    
    IBOutlet UIImageView* tab_bar;
    IBOutlet UIButton*        btn_home_map_check;
    IBOutlet UILabel*          lbl_informacion_viaje;
    IBOutlet UILabel*          lbl_confirmacion_viaje;
    IBOutlet UIButton*        btn_cancelar_viaje;
    IBOutlet UIButton*        btn_mi_taccsista;
   // IBOutlet UIButton*        btn_order_taccsi;
    
    IBOutlet UIView*           contenedor_mapa;
    GMSMapView*             mapView_;
    IBOutlet UIImageView*  img_origen;
    CLLocationManager*   locationManager;
    
    IBOutlet UIView*           contenedor_menu;
    IBOutlet UIImageView* img_perfil;
    IBOutlet UILabel        *  lbl_perfil;
    IBOutlet UITableView*   tbl_menu;
    
    IBOutlet UIView* contenedor_info_taccsista;
    IBOutlet UIButton* btn_cerrar_info_taccsista;
    IBOutlet UILabel* lbl_nombre_taccsista;
    IBOutlet UILabel* lbl_eco__taccsista;
    IBOutlet UILabel* lbl_placas_taccsista;
    IBOutlet UILabel* lbl_marca_taccsista;
    IBOutlet UILabel* lbl_modelo_taccsista;
    IBOutlet UILabel* lbl_telefono_taccsista;
    IBOutlet UIButton* btn_llamar_taccsista;
    IBOutlet UIImageView* img_foto_taccsista;
    
    IBOutlet UIView*           contenedor_taccsistas;
    IBOutlet UITableView*   tbl_taccsistas;
    IBOutlet UILabel*          lbl_total_taccsistas;
    
    IBOutlet UIView*           contenedor_direccion;
    IBOutlet UIImageView* img_direccion;
    IBOutlet UILabel*          lbl_direccion;
    
    IBOutlet UIView*           contenedor_resumen_fondo;
    IBOutlet UIView*           contenedor_resumen_viaje;
    IBOutlet UIImageView*   img_resumen_viaje;
    IBOutlet UIButton*        btn_cerrar_resumen_viaje;
    IBOutlet UILabel*          lbl_desde_resumen_viaje;
    IBOutlet UITextField*     txt_origen;
    IBOutlet UILabel*          lbl_hasta_resumen_viaje;
    IBOutlet UITextField*     txt_destino;
    IBOutlet UIButton*        btn_destino;
    IBOutlet UIButton*        btn_pedir_taccsi;
    CustomSegmentedControl * segmentMembers;
    CustomSegmentedControl * segmentPayments;
    
    IBOutlet UIView*           contenedor_fin_viaje;
    IBOutlet UIImageView* img_fondo_fin_viaje;
    IBOutlet UILabel*          lbl_recibo_fin_viaje;
    IBOutlet UILabel*          lbl_total_fin_viaje;
    IBOutlet UILabel*          lbl_fin_viaje;
    IBOutlet UILabel*          lbl_forma_pago_fin_viaje;
    IBOutlet UIButton*        btn_pagar_fin_viaje;
    IBOutlet UIButton*        btn_facebook;
    IBOutlet UIButton*        btn_twitter;
    IBOutlet UILabel*          califica_taccsista_fin_viaje;
    IBOutlet UISlider*          slider__fin_viaje;
    IBOutlet UIButton*         cancelar_fin_viaje;
    IBOutlet UIButton*         btn_show_fin_viaje;

    
    ////xml///
    NSString* currentElement;
    NSMutableDictionary* currentElementData;
    NSMutableString* currentElementString;
    NSString *StringCode;
    NSString *StringMsg;
    IBOutlet UIActivityIndicatorView* actividad;
}

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;

-(void)FillArray;
-(void)Animacion:(int)Code;
-(void)BuscarTaccsisCercanos;
-(void)PintaTaccsistas;
-(void)DescargaImagenes;
-(IBAction)UsarMiUbicacion:(id)sender;
-(IBAction)ShowTaccsistas:(id)sender;
-(IBAction)ShowMenu:(id)sender;
-(IBAction)ShowInfoMiTaccsista:(id)sender;
-(IBAction)ShowPagarViaje:(id)sender;
-(IBAction)ShowResumenViaje:(id)sender;
-(IBAction)BuscarDestino:(id)sender;
-(IBAction)PedirTaccsi:(id)sender;
-(void)ObtenDatosUsuario;
-(void)IrLogin;
-(IBAction)LlamarTaccsista:(id)sender;
-(void)PintaPantallaXEstatus;
-(IBAction)PagarViaje:(id)sender;
-(IBAction)CancelarVIaje:(id)sender;

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;


-(void)EscribeArchivo_id_estatus_viaje:(NSString*)ID_ESTATUS id_viaje:(NSString*)ID_VIAJE lat_origen:(NSString*)LAT_ORIGEN lon_origen:(NSString*)LON_ORIGEN lat_destino:(NSString*)LAT_DESTINO lon_destino:(NSString*)LON_DESTINO id_taccsista:(NSString*)ID_TACCSISTA clave_confirmacion:(NSString*)CLAVE_CONFIRMACION foto_taccsista:(NSString*)FOTO_TACCSISTA nombre_taccsista:(NSString*)NOMBRE_TACCSISTA apaterno_taccsista:(NSString*)APATERNO_TACCSISTA amaterno_taccsista:(NSString*)AMATERNO_TACCSISTA telefono:(NSString*)TELEFONO marca:(NSString*)MARCA modelo:(NSString*)MODELO placas:(NSString*)PLACAS eco:(NSString*)ECO foto_taccsi:(NSString*)FOTO_TACCSI direccion_origen:(NSString*)DIRECCION_ORIGEN forma_pago:(NSString*)FORMA_PAGO importe:(NSString*)IMPORTE direccion_destino:(NSString*)DIRECCION_DESTINO pasajeros:(NSString*)PASAJEROS;

-(NSArray*)DameInfoVIaje;

-(void)actualizarxtimer:(id)sender;
-(void)RevisaDatosTaccsista;
-(IBAction)PagarPaypal:(id)sender;

@end
