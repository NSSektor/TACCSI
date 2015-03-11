//
//  ViewController.h
//  TACCSI
//
//  Created by Angel Rivas on 2/24/15.
//  Copyright (c) 2015 Tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "SYSoapTool.h"
#import "CustomSegmentedControl.h"
#import "PayPalMobile.h"

@interface ViewController : UIViewController<CLLocationManagerDelegate,UITableViewDataSource, UITableViewDelegate,NSXMLParserDelegate,SOAPToolDelegate,GMSMapViewDelegate, UITextFieldDelegate,CustomSegmentedControlDelegate,UIAlertViewDelegate,PayPalPaymentDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    
    UIView*           contenedor_vista;
    UIView*           contenedor_invisible;
    
    UIImageView* navbar;
    UILabel*          lbl_navbar;
    UIButton*        btn_home_navbar;
    UIButton*        btn_taccsi_navbar;
    
    UIImageView* tab_bar;
    UIButton*        btn_home_map_check;
    UILabel*          lbl_informacion_viaje;
    UILabel*          lbl_confirmacion_viaje;
    UIButton*        btn_cancelar_viaje;
    UIButton*        btn_mi_taccsista;
    
    UIView*            contenedor_mapa;
    GMSMapView* mapView_;
    UIImageView*   img_origen;
    UIButton*         btn_mi_posicion;
    CLLocationManager*   locationManager;
    
    UIView*           contenedor_taccsistas;
    UITableView*   tbl_taccsistas;
    UILabel*          lbl_total_taccsistas;
    
    UIView*           contenedor_direccion;
    UIImageView* img_direccion;
    UILabel*          lbl_direccion;
    
    UIView*           contenedor_menu;
    UIImageView* img_perfil;
    UILabel        *  lbl_perfil;
    UITableView*   tbl_menu;
    
   UIView*           contenedor_resumen_fondo;
   UIView*           contenedor_resumen_viaje;
   UIImageView*   img_resumen_viaje;
   UIButton*        btn_cerrar_resumen_viaje;
   UILabel*          lbl_desde_resumen_viaje;
   UITextField*     txt_origen;
   UILabel*          lbl_hasta_resumen_viaje;
   UITextField*     txt_destino;
   UIButton*        btn_destino;
   UIButton*        btn_pedir_taccsi;
    CustomSegmentedControl * segmentMembers;
    CustomSegmentedControl * segmentPayments;
    
   UIView*           contenedor_fin_viaje;
   UIImageView* img_fondo_fin_viaje;
   UILabel*          lbl_recibo_fin_viaje;
   UILabel*          lbl_total_fin_viaje;
   UILabel*          lbl_fin_viaje;
   UILabel*          lbl_forma_pago_fin_viaje;
   UIButton*        btn_pagar_fin_viaje;
   UIButton*        btn_facebook;
   UIButton*        btn_twitter;
   UILabel*          califica_taccsista_fin_viaje;
   UISlider*          slider__fin_viaje;
   UIButton*         cancelar_fin_viaje;
   UIButton*         btn_show_fin_viaje;
    
    UIView*           contenedor_cancelar_viaje;
    UIPickerView* picker_cancelar;
    UIImageView* img_fondo_cancelar_viaje;
    UILabel*          lbl_texto_cancelar_viaje;
    UIButton*        btn_enviar_cancelar_viaje;
    UIButton*         cancelar_cancelar_viaje;
    
    UIView* contenedor_info_taccsista;
    UIButton* btn_cerrar_info_taccsista;
    UILabel* lbl_nombre_taccsista;
    UILabel* lbl_eco__taccsista; 
    UILabel* lbl_placas_taccsista;
    UILabel* lbl_marca_taccsista;
    UILabel* lbl_modelo_taccsista;
    UILabel* lbl_telefono_taccsista;
    UIButton* btn_llamar_taccsista;
    UIImageView* img_foto_taccsista;
    
    
    
    UIActivityIndicatorView* actividad;
    
    ////xml///
    NSString* currentElement;
    NSMutableDictionary* currentElementData;
    NSMutableString* currentElementString;
    NSString *StringCode;
    NSString *StringMsg;
    NSTimer* contadorTimerChecoPush;

}

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
-(IBAction)EnviarCancelarViaje:(id)sender;

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;


-(void)EscribeArchivo_id_estatus_viaje:(NSString*)ID_ESTATUS id_viaje:(NSString*)ID_VIAJE lat_origen:(NSString*)LAT_ORIGEN lon_origen:(NSString*)LON_ORIGEN lat_destino:(NSString*)LAT_DESTINO lon_destino:(NSString*)LON_DESTINO id_taccsista:(NSString*)ID_TACCSISTA clave_confirmacion:(NSString*)CLAVE_CONFIRMACION foto_taccsista:(NSString*)FOTO_TACCSISTA nombre_taccsista:(NSString*)NOMBRE_TACCSISTA apaterno_taccsista:(NSString*)APATERNO_TACCSISTA amaterno_taccsista:(NSString*)AMATERNO_TACCSISTA telefono:(NSString*)TELEFONO marca:(NSString*)MARCA modelo:(NSString*)MODELO placas:(NSString*)PLACAS eco:(NSString*)ECO foto_taccsi:(NSString*)FOTO_TACCSI direccion_origen:(NSString*)DIRECCION_ORIGEN forma_pago:(NSString*)FORMA_PAGO importe:(NSString*)IMPORTE direccion_destino:(NSString*)DIRECCION_DESTINO pasajeros:(NSString*)PASAJEROS;

-(NSArray*)DameInfoVIaje;

-(void)actualizarxtimer:(id)sender;
-(void)ActualizarPintaPantalla:(id)sender;
-(void)RevisaDatosTaccsista;
-(IBAction)PagarPaypal:(id)sender;
-(void)PintaAlerta;


@end
