//
//  Login.h
//  TACCSI
//
//  Created by Angel Rivas on 2/16/15.
//  Copyright (c) 2015 Tecnologizame. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "SYSoapTool.h"
#import "DBManager.h"

@interface Login : UIViewController<UITextFieldDelegate,SOAPToolDelegate, NSXMLParserDelegate>{
    IBOutlet UIView*           contenedor_vista;
    IBOutlet UIView*           contenedor_imagen;
    IBOutlet UIImageView* img_taccsi;
    
    IBOutlet UIView* contenedor_txt;
    IBOutlet UILabel* lbl_usuario;
    IBOutlet UITextField* txt_usuario;
    IBOutlet UILabel* lbl_pass;
    IBOutlet UITextField* txt_pass;
    
 //   IBOutlet UIView* contenedor_botones;
    IBOutlet UIButton* btn_iniciar;
    IBOutlet UIButton* btn_cancelar;
    IBOutlet UIButton* btn_registro;
    IBOutlet UIButton* btn_ayuda;
    IBOutlet UIActivityIndicatorView* actividad;
    
    ////xml///
    NSString* currentElement;
    NSMutableDictionary* currentElementData;
    NSMutableString* currentElementString;
    NSString *StringCode;
    NSString *StringMsg;
}

-(void)FillArray;
-(void)Animacion:(int)Code;
-(IBAction)Enviar:(id)sender;
-(IBAction)Cancelar:(id)sender;
-(IBAction)Registro:(id)sender;

@property (nonatomic, strong) DBManager *dbManager;

@end
