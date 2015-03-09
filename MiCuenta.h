//
//  MiCuenta.h
//  TACCSI
//
//  Created by Angel Rivas on 9/1/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYSoapTool.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "DBManager.h"

@interface MiCuenta : UIViewController<UITextFieldDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, SOAPToolDelegate, NSXMLParserDelegate>{
    
    __weak IBOutlet UIView* contenedor_txt;
    __weak IBOutlet UILabel* lbl_nombre;
    __weak IBOutlet UITextField* txt_nombre;
    __weak IBOutlet UITextField* txt_apaterno;
    __weak IBOutlet UITextField* txt_amaterno;
    __weak IBOutlet UILabel* lbl_correo;
    __weak IBOutlet UITextField* txt_correo;
    __weak IBOutlet UILabel* lbl_telefono;
    __weak IBOutlet UITextField* txt_telefono;
    __weak IBOutlet UILabel* lbl_pass;
    __weak IBOutlet UITextField* txt_pass;
    __weak IBOutlet UITextField* txt_pass1;
    
    __weak IBOutlet UIButton* btn_guardar;
    __weak IBOutlet UIButton* btn_cancelar;
    __weak IBOutlet UIButton* btn_editar;
    
    __weak IBOutlet UILabel* lbl_lugares;
    __weak IBOutlet UIButton* btn_lugares;
    __weak IBOutlet UIImageView* img_foto;
    __weak IBOutlet UIButton* btn_foto;
    
     __weak IBOutlet UIActivityIndicatorView* actividad;
    
    ////xml///
    NSString* currentElement;
    NSMutableDictionary* currentElementData;
    NSMutableString* currentElementString;
    NSString *StringCode;
    NSString *StringMsg;
    
}

-(IBAction)ShowEditar:(id)sender;
-(IBAction)Cancelar:(id)sender;
-(IBAction)Atras:(id)sender;
-(IBAction)Guardar:(id)sender;
-(IBAction)Lugares:(id)sender;

-(NSString*)formatNumber:(NSString*)mobileNumber;
-(NSUInteger)getLength:(NSString*)mobileNumber;
- (BOOL)validateEmail:(NSString *)emailStr;
- (IBAction)foto:(id)sender;
@property (nonatomic, strong) DBManager *dbManager;
-(void)FillArray;
-(void)Animacion:(int)Code;

@end
