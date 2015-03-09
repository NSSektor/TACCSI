//
//  MisLugares.h
//  TACCSI
//
//  Created by Angel Rivas on 8/26/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MisLugares : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,GMSMapViewDelegate, CLLocationManagerDelegate, UIActionSheetDelegate>{
    
    __weak IBOutlet UIView*             contenedor_lugares;
     __weak IBOutlet UITableView*    tbl_mis_lugares;
    __weak IBOutlet UIButton*          btn_regresar;
    __weak IBOutlet UIButton*          btn_nuevo;
    __weak IBOutlet UITextField*       txt_buscar_lugar;
    __weak IBOutlet UIButton*          btn_buscar_lugar;
    __weak IBOutlet UIButton*          btn_cancelar_lugar;
    

    __weak IBOutlet UIView*          contenedor_nuevo;
    __weak IBOutlet UITextField*    txt_buscar;
    __weak IBOutlet UIButton*       btn_cancelar;
    __weak IBOutlet UIButton*       btn_buscar;
    __weak IBOutlet UIButton*       btn_cerrar_nuevos;
    __weak IBOutlet UIButton*       btn_guardar;
    __weak IBOutlet UITextField*    txt_nombre_lugar;
    __weak IBOutlet UITextField*    txt_referencias;
    __weak IBOutlet UIView*          contenedor_mapa;
    UIView*       contenedor_direccion;
    UITextField* txt_calle;
    UITextField* txt_numero;
    UILabel*      lbl_direccion;
    __weak IBOutlet UIView*          contenedor_tabla;
    __weak IBOutlet UIButton*       btn_confirmar_servicio;
    __weak IBOutlet UITableView*  tbl_buscar;
    IBOutlet UIView*                       contenedor_invisible_direccion;
    IBOutlet UIButton*                    btn_mi_ubicacion;
    IBOutlet UIButton*                    btn_buscar_direccion;
    IBOutlet UISegmentedControl* sg_tipo_mapa;
    IBOutlet UIImageView*              img_destino;
    GMSMapView *mapView_;
    
    
}

-(IBAction)Regresar:(id)sender;
-(IBAction)Nuevo:(id)sender;
-(IBAction)Buscar:(id)sender;
-(IBAction)ShowNuevo:(id)sender;
-(IBAction)CancelarBusqueda_lugar:(id)sender;
-(IBAction)Buscar_lugar:(id)sender;
-(IBAction)IniciarBusquedaLugar:(id)sender;

-(IBAction)ShowBuscar:(id)sender;

-(IBAction)setMap:(id)sender;
-(IBAction)UsarMiUbicacion:(id)sender;
-(void)BuscarDireccion;
-(IBAction)CancelarBusqueda:(id)sender;
-(IBAction)Guardar:(id)sender;

@end
