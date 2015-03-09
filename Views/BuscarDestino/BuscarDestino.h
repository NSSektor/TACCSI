//
//  BuscarDestino.h
//  TACCSI
//
//  Created by Angel Rivas on 2/16/15.
//  Copyright (c) 2015 Tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "SYSoapTool.h"

@interface BuscarDestino : UIViewController<CLLocationManagerDelegate,UITableViewDataSource, UITableViewDelegate,GMSMapViewDelegate, UITextFieldDelegate>{
    
    IBOutlet UIView*           contenedor_vista;
    IBOutlet UIImageView* navbar;
    IBOutlet UILabel*          lbl_navbar;
    IBOutlet UIButton*        btn_home_navbar;
    IBOutlet UIImageView* tab_bar;
    IBOutlet UIButton*        btn_home_map_check;
    IBOutlet UIButton*        btn_search;
    
    IBOutlet UIView*           contenedor_mapa;
    GMSMapView*             mapView_;
    IBOutlet UIImageView*  img_destino;
    CLLocationManager*   locationManager;
    
    IBOutlet UIView*           contenedor_direccion;
    IBOutlet UIImageView* img_direccion;
    IBOutlet UILabel*          lbl_direccion;
    
    IBOutlet UIView* contenedor_busqueda;
    IBOutlet UITextField* txt_estado;
    IBOutlet UITextField* txt_municipio;
    IBOutlet UITextField* txt_cp;
    IBOutlet UITextField* txt_calle;
    IBOutlet UIButton*    btn_busqueda;
    IBOutlet UIButton*    btn_limpiar;
    
    IBOutlet UITableView* tbl_buscar;
    
    IBOutlet UIActivityIndicatorView* actividad;
}

-(IBAction)UsarMiUbicacion:(id)sender;
-(void)BuscaDireccion;
-(IBAction)BuscaLugar:(id)sender;
-(IBAction)CancelarBusqueda:(id)sender;
-(IBAction)ShowBusqueda:(id)sender;
-(IBAction)Atras:(id)sender;
-(IBAction)UsarUbicacionDestino:(id)sender;

@end
