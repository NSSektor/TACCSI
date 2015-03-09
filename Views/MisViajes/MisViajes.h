//
//  MisViajes.h
//  TACCSI
//
//  Created by Angel Rivas on 3/2/15.
//  Copyright (c) 2015 Tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "SYSoapTool.h"

@interface MisViajes : UIViewController<UITableViewDataSource, UITableViewDelegate,NSXMLParserDelegate,SOAPToolDelegate>{
    
    UIImageView* navbar;
    UILabel*          lbl_navbar;
    UIButton*        btn_home_navbar;
    UIActivityIndicatorView* actividad;
    UIView*           contenedor_viajes;
    UITableView*  tbl_viajes;
    
    UIView*           contenedor_mi_viaje;
    UILabel*          lbl_fecha_viaje;
    GMSMapView*        mapView_;
    UILabel*          lbl_nombre_taccsista;
    UILabel*          lbl_vehiculo_taccsista;
    UILabel*          lbl_calificacion_viaje;
    UIImageView*  img_calificacion_viaje;
    UILabel*          lbl_monto;
    
    
    ////xml///
    NSString* currentElement;
    NSMutableDictionary* currentElementData;
    NSMutableString* currentElementString;
    NSString *StringCode;
    NSString *StringMsg;
    NSTimer* contadorTimerChecoPush;

}

-(void)FillArray;
-(void)Animacion:(int)Code;
-(IBAction)Atras:(id)sender;

@end
