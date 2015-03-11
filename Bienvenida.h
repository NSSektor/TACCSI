//
//  Bienvenida.h
//  Pet Locator
//
//  Created by Angel Rivas on 6/9/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYSoapTool.h"

@interface Bienvenida : UIViewController<SOAPToolDelegate, NSXMLParserDelegate, UITextFieldDelegate>{
    
    UIImageView* img_presentation1;
    UIImageView* img_presentation2;
    UIImageView* img_presentation3;
    __weak IBOutlet UIButton* btn_yasoyusuario;
    __weak IBOutlet UIButton* btn_nuevousuario;
    __weak IBOutlet UIButton* btn_atras;
    
    UIActivityIndicatorView *actividad;
    UIView*           contenedor_login_fondo;
    UIView*           contenedor_login;
    UIImageView*   img_resumen_viaje;
    UIButton*        btn_cerrar_login;
    UILabel*          lbl_usuario;
    UITextField*     txt_usuario;
    UILabel*          lbl_pass;
    UITextField*     txt_pass;
    UIButton*        btn_olvide_pass;
    UIButton*        btn_iniciar_sesion;
    
    UIView*           contenedor_registro_fondo;
    UIView*           contenedor_registro;
    UIButton*        btn_cerrar_registro;
    UILabel*          lbl_nombre;
    UITextField*     txt_nombre;
    UILabel*          lbl_apaterno;
    UITextField*     txt_apaterno;
    UILabel*          lbl_amaterno;
    UITextField*     txt_amaterno;
    UILabel*          lbl_fecha_nacimiento;
    UITextField*     txt_fecha_nacimiento;
    UIButton*        btn_fecha_nacimiento;
    UILabel*          lbl_telefono;
    UITextField*     txt_telefono;
    UILabel*          lbl_correo;
    UITextField*     txt_correo;
    UILabel*          lbl_correo2;
    UITextField*     txt_correo2;
    UILabel*          lbl_pass_registro;
    UITextField*     txt_pass_registro;
    UILabel*          lbl_pass_registro2;
    UITextField*     txt_pass_registro2;
    
    UIButton*        btn_condiciones;
    UIButton*        btn_iniciar_registro;
    
    NSTimer *contadorTimer;
    
    ////xml///
    NSString* currentElement;
    NSMutableDictionary* currentElementData;
    NSMutableString* currentElementString;
    NSString *StringCode;
    NSString *StringMsg;
}


-(IBAction)actualizarimagen:(id)sender;

-(IBAction)ShowLogin:(id)sender;
-(IBAction)ShowRegistro:(id)sender;

-(IBAction)Login:(id)sender;
-(IBAction)Registro:(id)sender;
-(IBAction)Atras:(id)sender;
-(void)FillArray;
-(void)Animacion:(int)Code;
-(NSString*)formatNumber:(NSString*)mobileNumber;
-(NSUInteger)getLength:(NSString*)mobileNumber;
- (BOOL)validateEmail:(NSString *)emailStr;
-(IBAction)ShowDate:(id)sender;
-(NSString*)ConvierteFecha:(NSDate*)Fecha;

@end
