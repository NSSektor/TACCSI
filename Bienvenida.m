//
//  Bienvenida.m
//  Pet Locator
//
//  Created by Angel Rivas on 6/9/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import "Bienvenida.h"
#import "Reachability.h"

int contador_bienvenida;
extern NSString* DeviceToken;
extern NSString* GlobalUsu;
extern NSString* GlobalPass;
extern NSString* GlobalID;
extern NSString* GlobalNombre;
extern NSString* GlobalApaterno;
extern NSString* GlobalAmaterno;
extern BOOL usuario_logueado;
extern NSString* GlobalTelefono;
extern NSString* GlobalCorreo;
extern NSString* Globalfoto_perfil;
extern NSString* GlobalString;
extern NSString* documentsDirectory;
extern NSString* dispositivo;

@interface Bienvenida (){
    SYSoapTool *soapTool;
    BOOL reachable;
    UIDatePicker *birthDatePicker;
    UIAlertView *setBirthDate;
    NSDateFormatter *birthDateFormatter;
    UITextField *birthDateInput;
    NSDate *fecha_;
    NSString* metodo_;

}

@end

@implementation Bienvenida

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    GlobalUsu = @"";
    GlobalPass = @"";
    GlobalID = @"";
    GlobalNombre = @"";
    GlobalApaterno = @"";
    GlobalAmaterno = @"";
    GlobalTelefono = @"";
    GlobalCorreo = @"";
    Globalfoto_perfil = @"";

    contador_bienvenida = 1;
    
    contadorTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(actualizarimagen:) userInfo:nil repeats:YES];
    soapTool = [[SYSoapTool alloc]init];
    soapTool.delegate = self;
    
    NSString* img_1 = @"fondo_login1_320x380";
    NSString* img_2 = @"fondo_login2_320x380";
    NSString* img_3 = @"fondo_login3_320x380";
    
    if ([dispositivo isEqualToString:@"iPhone5"]) {
        img_1 = @"fondo_login1_320x468";
        img_2 = @"fondo_login2_320x468";
        img_3 = @"fondo_login3_320x468";
    }
    if ([dispositivo isEqualToString:@"iPhone6"]) {
        img_1 = @"fondo_login1_375x567";
        img_2 = @"fondo_login2_375x567";
        img_3 = @"fondo_login3_375x567";
    }
    if ([dispositivo isEqualToString:@"iPhone6plus"]) {
        img_1 = @"fondo_login1_414x636";
        img_2 = @"fondo_login2_414x636";
        img_3 = @"fondo_login3_414x636";
    }
    if ([dispositivo isEqualToString:@"iPad"]) {
        img_1 = @"fondo_login1_768x924";
        img_2 = @"fondo_login2_768x924";
        img_3 = @"fondo_login3_768x924";
    }
    
    
    
    img_presentation1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 100)];
    img_presentation1.image = [UIImage imageNamed:img_1];
    [self.view addSubview:img_presentation1];
    
    img_presentation2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 50, self.view.frame.size.width, self.view.frame.size.height - 100)];
    img_presentation2.image = [UIImage imageNamed:img_2];
    [self.view addSubview:img_presentation2];
    
    img_presentation3 = [[UIImageView alloc] initWithFrame:CGRectMake(- self.view.frame.size.width, 50, self.view.frame.size.width, self.view.frame.size.height - 100)];
    img_presentation3.image = [UIImage imageNamed:img_3];
    img_presentation3.hidden = YES;
    [self.view addSubview:img_presentation3];
    
    
    
    contenedor_login_fondo = [[UIView alloc]initWithFrame:self.view.frame];
    contenedor_login_fondo.backgroundColor = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:0.5];
    contenedor_login_fondo.hidden = YES;
    [self.view addSubview:contenedor_login_fondo];
    
    contenedor_login = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 160 , self
                                                                        .view.frame.size.height/2 - 130, 320, 260)];
    contenedor_login.backgroundColor = [UIColor whiteColor];
    [contenedor_login_fondo addSubview:contenedor_login];
    
    img_resumen_viaje = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contenedor_login.frame.size.width, 40)];
    img_resumen_viaje.image = [UIImage imageNamed:@"home_navbar_bg"];
    [contenedor_login addSubview:img_resumen_viaje];
    
    UILabel* lbl_titulo_login = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contenedor_login.frame.size.width, 40)];
    lbl_titulo_login.text = @"Login";
    lbl_titulo_login.font  = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    lbl_titulo_login.textAlignment = NSTextAlignmentCenter;
    lbl_titulo_login.textColor = [UIColor blackColor];
    
    [contenedor_login addSubview:lbl_titulo_login];
    
    btn_cerrar_login = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, 70, 30)];
    [btn_cerrar_login setTitle:@"Cancelar" forState:UIControlStateNormal];
    [btn_cerrar_login setTitleColor:[UIColor colorWithRed:100.0/255.0 green:108.0/255.0 blue:121.0/255.0 alpha:1]  forState:UIControlStateNormal ];
    btn_cerrar_login.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    [btn_cerrar_login addTarget:self action:@selector(ShowLogin:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_login addSubview:btn_cerrar_login];
    
    lbl_usuario = [[UILabel alloc] initWithFrame:CGRectMake(5, 80, 80, 21)];
    lbl_usuario.textColor = [UIColor blackColor];
    lbl_usuario.text = @"Usuario";
    lbl_usuario.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    [contenedor_login addSubview:lbl_usuario];
    
    txt_usuario = [[UITextField alloc] initWithFrame:CGRectMake(90, 78, 195, 25)];
    txt_usuario.delegate = self;
    txt_usuario.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txt_usuario.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    txt_usuario.placeholder = @"Usuario";
    txt_usuario.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_usuario.textAlignment = NSTextAlignmentRight;
    [txt_usuario setKeyboardType:UIKeyboardTypeEmailAddress];
    [contenedor_login addSubview:txt_usuario];
    
    lbl_pass = [[UILabel alloc] initWithFrame:CGRectMake(5, 122, 80, 21)];
    lbl_pass.textColor = [UIColor blackColor];
    lbl_pass.text = @"Contraseña";
    lbl_pass.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    [contenedor_login addSubview:lbl_pass];
    
    txt_pass = [[UITextField alloc] initWithFrame:CGRectMake(90, 120, 195, 25)];
    txt_pass.delegate = self;
    txt_pass.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    txt_pass.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_pass.placeholder = @"Contraseña";
    txt_pass.textAlignment = NSTextAlignmentRight;
    txt_pass.secureTextEntry = YES;
    [contenedor_login addSubview:txt_pass];
    
    btn_olvide_pass = [[UIButton alloc] initWithFrame:CGRectMake(0, 170, contenedor_login.frame.size.width, 30)];
    [btn_olvide_pass setTitle:@"Olvide mi contraseña" forState:UIControlStateNormal];
    [btn_olvide_pass setTitleColor:[UIColor colorWithRed:100.0/255.0 green:108.0/255.0 blue:121.0/255.0 alpha:1]  forState:UIControlStateNormal ];
    btn_olvide_pass.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
   // [btn_olvide_pass addTarget:self action:@selector(OlvidePass:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_login addSubview:btn_olvide_pass];

    
    
    btn_iniciar_sesion = [[UIButton alloc]initWithFrame:CGRectMake(0, 210, 320, 50)];
    /*   UIImageView* img_ = [[UIImageView alloc]initWithFrame:btn_pedir_taccsi.frame];
     img_.image = [UIImage imageNamed:@"payment_btn_cancel"];*/
    [btn_iniciar_sesion setTitle:@"Iniciar sesión" forState:UIControlStateNormal];
    [btn_iniciar_sesion setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal ];
    btn_iniciar_sesion.backgroundColor = [UIColor blackColor];
    btn_iniciar_sesion.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    [btn_iniciar_sesion addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_login addSubview:btn_iniciar_sesion];
    
    for (int i=0; i<8;i++) {
        UILabel* lbl =[[UILabel alloc]init];
        switch (i) {
            case 0:{lbl.frame = CGRectMake(0, 40, contenedor_login.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 1:{lbl.frame = CGRectMake(0 ,41, contenedor_login.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1];}
                break;
            case 2:{lbl.frame = CGRectMake(20, 104, 300, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 3:{lbl.frame = CGRectMake(20, 105, 300, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 4:{lbl.frame = CGRectMake(20, 147, 300, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 5:{lbl.frame = CGRectMake(20, 148, 300, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            default:
                break;
        }
        [contenedor_login addSubview:lbl];
    }

    contenedor_registro_fondo = [[UIView alloc]initWithFrame:self.view.frame];
    contenedor_registro_fondo.backgroundColor = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:0.5];
    contenedor_registro_fondo.hidden = YES;
    [self.view addSubview:contenedor_registro_fondo];
    
    CGRect size_object = CGRectMake(contenedor_registro_fondo.frame.size.width / 2 - 160 ,70, 320, 350);
    float size_font;
    
    if ([dispositivo isEqualToString:@"iPhone"])
        size_object = CGRectMake(contenedor_registro_fondo.frame.size.width / 2 - 160 ,30, 320, 295);
    
    contenedor_registro = [[UIView alloc] initWithFrame:size_object];
    contenedor_registro.backgroundColor = [UIColor whiteColor];
    [contenedor_registro_fondo addSubview:contenedor_registro];
    
    size_object = CGRectMake(0, 0, contenedor_registro.frame.size.width, 40);
    size_font = 18;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(0, 0, contenedor_registro.frame.size.width, 30);
        size_font = 16;
    }
    
    UIImageView* img_registro = [[UIImageView alloc] initWithFrame:size_object];
    img_resumen_viaje.image = [UIImage imageNamed:@"home_navbar_bg"];
    [contenedor_registro addSubview:img_registro];
    
    UILabel* lbl_titulo_registro = [[UILabel alloc] initWithFrame:size_object];
    lbl_titulo_registro.text = @"Registro";
    lbl_titulo_registro.font  = [UIFont fontWithName:@"HelveticaNeue-Light" size:size_font];
    lbl_titulo_registro.textAlignment = NSTextAlignmentCenter;
    lbl_titulo_registro.textColor = [UIColor blackColor];
    [contenedor_registro addSubview:lbl_titulo_registro];
    
    size_object = CGRectMake(5, 10, 70, 30);
    size_font = 15;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(5, 10, 70, 20);
        size_font = 14;
    }
    
    btn_cerrar_registro = [[UIButton alloc] initWithFrame:size_object];
    [btn_cerrar_registro setTitle:@"Cancelar" forState:UIControlStateNormal];
    [btn_cerrar_registro setTitleColor:[UIColor colorWithRed:100.0/255.0 green:108.0/255.0 blue:121.0/255.0 alpha:1]  forState:UIControlStateNormal ];
    btn_cerrar_registro.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:size_font];
    [btn_cerrar_registro addTarget:self action:@selector(ShowRegistro:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_registro addSubview:btn_cerrar_registro];
    
    size_object = CGRectMake(5, 42, 130, 24);
    size_font = 13;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(5, 32, 130, 20);
        size_font = 12;
    }
    
    lbl_nombre = [[UILabel alloc] initWithFrame:size_object];
    lbl_nombre.textColor = [UIColor blackColor];
    lbl_nombre.text = @"Nombre";
    lbl_nombre.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:size_font];
    [contenedor_registro addSubview:lbl_nombre];
    
    size_object = CGRectMake(135, 42, 180, 24);
    size_font = 14;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(135, 32, 180, 20);
        size_font = 13;
    }
    
    txt_nombre = [[UITextField alloc] initWithFrame:size_object];
    txt_nombre.delegate = self;
    txt_nombre.font = [UIFont fontWithName:@"HelveticaNeue" size:size_font];
    txt_nombre.placeholder = @"Nombre";
    txt_nombre.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_nombre.textAlignment = NSTextAlignmentRight;
    [contenedor_registro addSubview:txt_nombre];
    
    size_object = CGRectMake(5, 68, 130, 24);
    size_font = 13;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(5, 54, 130, 20);
        size_font = 12;
    }
    
    lbl_apaterno = [[UILabel alloc] initWithFrame:size_object];
    lbl_apaterno.textColor = [UIColor blackColor];
    lbl_apaterno.text = @"Apellido Paterno";
    lbl_apaterno.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:size_font];
    [contenedor_registro addSubview:lbl_apaterno];
    
    size_object = CGRectMake(135, 68, 180, 24);
    size_font = 14;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(135, 54, 180, 20);
        size_font = 13;
    }
    
    txt_apaterno = [[UITextField alloc] initWithFrame:size_object];
    txt_apaterno.delegate = self;
    txt_apaterno.font = [UIFont fontWithName:@"HelveticaNeue" size:size_font];
    txt_apaterno.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_apaterno.placeholder = @"Apellido Paterno";
    txt_apaterno.textAlignment = NSTextAlignmentRight;
    [contenedor_registro addSubview:txt_apaterno];
    
    size_object = CGRectMake(5, 94, 130, 24);
    size_font = 13;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(5, 76, 130, 20);
        size_font = 12;
    }
    
    lbl_amaterno = [[UILabel alloc] initWithFrame:size_object];
    lbl_amaterno.textColor = [UIColor blackColor];
    lbl_amaterno.text = @"Apellido Materno";
    lbl_amaterno.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:size_font];
    [contenedor_registro addSubview:lbl_amaterno];
    
    size_object = CGRectMake(135, 94, 180, 24);
    size_font = 14;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(135, 76, 180, 20);
        size_font = 13;
    }
    
    txt_amaterno = [[UITextField alloc] initWithFrame:size_object];
    txt_amaterno.delegate = self;
    txt_amaterno.font = [UIFont fontWithName:@"HelveticaNeue" size:size_font];
    txt_amaterno.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_amaterno.placeholder = @"Apellido Materno";
    txt_amaterno.textAlignment = NSTextAlignmentRight;
    [contenedor_registro addSubview:txt_amaterno];
    
    size_object = CGRectMake(5, 120, 130, 24);
    size_font = 13;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(5, 98, 130, 20);
        size_font = 12;
    }
    
    lbl_fecha_nacimiento = [[UILabel alloc] initWithFrame:size_object];
    lbl_fecha_nacimiento.textColor = [UIColor blackColor];
    lbl_fecha_nacimiento.text = @"Fecha de nacimiento";
    lbl_fecha_nacimiento.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:size_font];
    [contenedor_registro addSubview:lbl_fecha_nacimiento];
    
    size_object = CGRectMake(135, 120, 180, 24);
    size_font = 14;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(135, 98, 180, 20);
        size_font = 13;
    }
    
    txt_fecha_nacimiento = [[UITextField alloc] initWithFrame:size_object];
    txt_fecha_nacimiento.delegate = self;
    txt_fecha_nacimiento.enabled = NO;
    txt_fecha_nacimiento.font = [UIFont fontWithName:@"HelveticaNeue" size:size_font];
    txt_fecha_nacimiento.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_fecha_nacimiento.placeholder = @"Fecha de nacimiento";
    txt_fecha_nacimiento.textAlignment = NSTextAlignmentRight;
    [contenedor_registro addSubview:txt_fecha_nacimiento];
    
    size_object = CGRectMake(5, 120, 310, 24);
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(5, 98, 310, 20);
    }
    
    btn_fecha_nacimiento = [[UIButton alloc] initWithFrame:size_object];
    [btn_fecha_nacimiento setTitle:@"" forState:UIControlStateNormal];
    [btn_fecha_nacimiento addTarget:self action:@selector(ShowDate:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_registro addSubview:btn_fecha_nacimiento];
    
    size_object = CGRectMake(5, 146, 130, 24);
    size_font = 13;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(5, 120, 130, 20);
        size_font = 12;
    }

    lbl_telefono = [[UILabel alloc] initWithFrame:size_object];
    lbl_telefono.textColor = [UIColor blackColor];
    lbl_telefono.text = @"Teléfono";
    lbl_telefono.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:size_font];
    [contenedor_registro addSubview:lbl_telefono];
    
    size_object = CGRectMake(135, 146, 180, 24);
    size_font = 14;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(135, 120, 180, 20);
        size_font = 13;
    }
    
    txt_telefono = [[UITextField alloc] initWithFrame:size_object];
    txt_telefono.delegate = self;
    txt_telefono.font = [UIFont fontWithName:@"HelveticaNeue" size:size_font];
    txt_telefono.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_telefono.placeholder = @"Teléfono";
    txt_telefono.keyboardType = UIKeyboardTypePhonePad;
    txt_telefono.textAlignment = NSTextAlignmentRight;
    [contenedor_registro addSubview:txt_telefono];
    
    size_object = CGRectMake(5, 172, 130, 24);
    size_font = 13;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(5, 142, 130, 20);
        size_font = 12;
    }
    
    lbl_correo = [[UILabel alloc] initWithFrame:size_object];
    lbl_correo.textColor = [UIColor blackColor];
    lbl_correo.text = @"Correo";
    lbl_correo.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:size_font];
    [contenedor_registro addSubview:lbl_correo];
    
    size_object = CGRectMake(135, 172, 180, 24);
    size_font = 14;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(135, 142, 180, 20);
        size_font = 13;
    }
    
    txt_correo = [[UITextField alloc] initWithFrame:size_object];
    txt_correo.delegate = self;
    txt_correo.font = [UIFont fontWithName:@"HelveticaNeue" size:size_font];
    txt_correo.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_correo.placeholder = @"Correo";
    txt_correo.keyboardType = UIKeyboardTypeEmailAddress;
    txt_correo.textAlignment = NSTextAlignmentRight;
    [contenedor_registro addSubview:txt_correo];
    
    size_object = CGRectMake(5, 198, 130, 24);
    size_font = 13;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(5, 164, 130, 20);
        size_font = 12;
    }
    
    lbl_correo2 = [[UILabel alloc] initWithFrame:size_object];
    lbl_correo2.textColor = [UIColor blackColor];
    lbl_correo2.text = @"Confirmar correo";
    lbl_correo2.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:size_font];
    [contenedor_registro addSubview:lbl_correo2];
    
    size_object = CGRectMake(135, 198, 180, 24);
    size_font = 14;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(135, 164, 180, 20);
        size_font = 13;
    }
    
    txt_correo2 = [[UITextField alloc] initWithFrame:size_object];
    txt_correo2.delegate = self;
    txt_correo2.font = [UIFont fontWithName:@"HelveticaNeue" size:size_font];
    txt_correo2.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_correo2.placeholder = @"Correo";
    txt_correo2.keyboardType = UIKeyboardTypeEmailAddress;
    txt_correo2.textAlignment = NSTextAlignmentRight;
    [contenedor_registro addSubview:txt_correo2];
    
    size_object = CGRectMake(5, 224, 130, 24);
    size_font = 13;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(5, 186, 130, 20);
        size_font = 12;
    }
    
    lbl_pass_registro = [[UILabel alloc] initWithFrame:size_object];
    lbl_pass_registro.textColor = [UIColor blackColor];
    lbl_pass_registro.text = @"Contraseña";
    lbl_pass_registro.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:size_font];
    [contenedor_registro addSubview:lbl_pass_registro];
    
    size_object = CGRectMake(135, 224, 180, 24);
    size_font = 14;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(135, 186, 180, 20);
        size_font = 13;
    }
    
    txt_pass_registro = [[UITextField alloc] initWithFrame:size_object];
    txt_pass_registro.delegate = self;
    txt_pass_registro.font = [UIFont fontWithName:@"HelveticaNeue" size:size_font];
    txt_pass_registro.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_pass_registro.placeholder = @"Contraseña";
    txt_pass_registro.secureTextEntry = YES;
    txt_pass_registro.textAlignment = NSTextAlignmentRight;
    [contenedor_registro addSubview:txt_pass_registro];
    
    size_object = CGRectMake(5, 250, 130, 24);
    size_font = 13;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(5, 208, 130, 20);
        size_font = 12;
    }
    
    lbl_pass_registro2 = [[UILabel alloc] initWithFrame:size_object];
    lbl_pass_registro2.textColor = [UIColor blackColor];
    lbl_pass_registro2.text = @"Confirmar contraseña";
    lbl_pass_registro2.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:size_font];
    [contenedor_registro addSubview:lbl_pass_registro2];
    
    size_object = CGRectMake(135, 250, 180, 24);
    size_font = 14;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(135, 208, 180, 20);
        size_font = 13;
    }
    
    txt_pass_registro2 = [[UITextField alloc] initWithFrame:size_object];
    txt_pass_registro2.delegate = self;
    txt_pass_registro2.font = [UIFont fontWithName:@"HelveticaNeue" size:size_font];
    txt_pass_registro2.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_pass_registro2.placeholder = @"Contraseña";
    txt_pass_registro2.secureTextEntry = YES;
    txt_pass_registro2.textAlignment = NSTextAlignmentRight;
    [contenedor_registro addSubview:txt_pass_registro2];
    
    size_object = CGRectMake(5, 278, 310, 35);
    size_font = 13;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(5, 230, 310, 30);
        size_font = 11;
    }
    
    UILabel* lbl_condiciones = [[UILabel alloc] initWithFrame:size_object];
    lbl_condiciones.textColor = [UIColor blackColor];
    lbl_condiciones.text = @"Al registrarse acepta nuestros términos y condiciones, y politicas de privacidad";
    lbl_condiciones.numberOfLines = 2;
    lbl_condiciones.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:size_font];
    lbl_condiciones.textAlignment = NSTextAlignmentCenter;
    [contenedor_registro addSubview:lbl_condiciones];
    
    btn_condiciones = [[UIButton alloc] initWithFrame:size_object];
    btn_condiciones.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    //[btn_condiciones addTarget:self action:@selector(ShowCondiciones:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_registro addSubview:btn_condiciones];
    
    size_object = CGRectMake(0, 315, 320, 35);
    size_font = 18;
    if ([dispositivo isEqualToString:@"iPhone"]){
        size_object = CGRectMake(0, 265, 320, 30);
        size_font = 16;
    }
    
    btn_iniciar_registro = [[UIButton alloc] initWithFrame:size_object];
    [btn_iniciar_registro setTitle:@"Registrar" forState:UIControlStateNormal];
    [btn_iniciar_registro setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal ];
    btn_iniciar_registro.backgroundColor = [UIColor blackColor];
    btn_iniciar_registro.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:size_font];
    [btn_iniciar_registro addTarget:self action:@selector(Registro:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_registro addSubview:btn_iniciar_registro];
    
    for (int i=0; i<22;i++) {
        UILabel* lbl =[[UILabel alloc]init];
        CGFloat y_ = 40;
        switch (i) {
            case 0:{
                if ([dispositivo isEqualToString:@"iPhone"]){
                    y_ = 30;
                }
                lbl.frame = CGRectMake(0, y_, contenedor_registro.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 1:{
                y_ = 41;
                if ([dispositivo isEqualToString:@"iPhone"]){
                    y_ = 31;
                }
                lbl.frame = CGRectMake(0 ,y_, contenedor_registro.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1];}
                break;
            case 4:{
                y_ = 66;
                if ([dispositivo isEqualToString:@"iPhone"]){
                    y_ = 52;
                }
                lbl.frame = CGRectMake(20, y_, 300, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 5:{
                y_ = 67;
                if ([dispositivo isEqualToString:@"iPhone"]){
                    y_ = 53;
                }lbl.frame = CGRectMake(20, y_, 300, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 6:{y_ = 92;
                if ([dispositivo isEqualToString:@"iPhone"]){
                    y_ = 74;
                }
                lbl.frame = CGRectMake(20, y_, 300, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 7:{
                y_ = 93;
                if ([dispositivo isEqualToString:@"iPhone"]){
                    y_ = 75;
                }lbl.frame = CGRectMake(20, y_, 300, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 8:{y_ = 118;
                if ([dispositivo isEqualToString:@"iPhone"]){
                    y_ = 96;
                }lbl.frame = CGRectMake(20, y_, 300, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 9:{
                y_ = 119;
                if ([dispositivo isEqualToString:@"iPhone"]){
                    y_ = 97;
                }lbl.frame = CGRectMake(20, y_, 300, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 10:{y_ = 144;
                if ([dispositivo isEqualToString:@"iPhone"]){
                    y_ = 118;
                }lbl.frame = CGRectMake(20, y_, 300, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 11:{y_ = 145;
                if ([dispositivo isEqualToString:@"iPhone"]){
                    y_ = 119;
                }lbl.frame = CGRectMake(20, y_, 300, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 12:{
                y_ = 170;
                if ([dispositivo isEqualToString:@"iPhone"]){
                    y_ = 140;
                }lbl.frame = CGRectMake(20, y_, 300, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 13:{
                y_ = 171;
                if ([dispositivo isEqualToString:@"iPhone"]){
                    y_ = 141;
                }lbl.frame = CGRectMake(20, y_, 300, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 14:{y_ = 196;
                if ([dispositivo isEqualToString:@"iPhone"]){
                    y_ = 162;
                }lbl.frame = CGRectMake(20, y_, 300, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 15:{
                y_ = 197;
                if ([dispositivo isEqualToString:@"iPhone"]){
                    y_ = 163;
                }lbl.frame = CGRectMake(20, y_, 300, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 16:{y_ = 222;
                if ([dispositivo isEqualToString:@"iPhone"]){
                    y_ = 184;
                }lbl.frame = CGRectMake(20, y_, 300, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 17:{
                y_ = 223;
                if ([dispositivo isEqualToString:@"iPhone"]){
                    y_ = 185;
                }lbl.frame = CGRectMake(20, y_, 300, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 18:{y_ = 248;
                if ([dispositivo isEqualToString:@"iPhone"]){
                    y_ = 206;
                }lbl.frame = CGRectMake(20, y_, 300, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 19:{
                y_ = 249;
                if ([dispositivo isEqualToString:@"iPhone"]){
                    y_ = 207;
                }lbl.frame = CGRectMake(20, y_, 300, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 20:{
                y_ = 274;
                if ([dispositivo isEqualToString:@"iPhone"]){
                    y_ = 228;
                }lbl.frame = CGRectMake(0, y_, contenedor_registro.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 21:{
                y_ = 275;
                if ([dispositivo isEqualToString:@"iPhone"]){
                    y_ = 229;
                }lbl.frame = CGRectMake(0 ,y_, contenedor_registro.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1];}
                break;
            default:
                break;
        }
        [contenedor_registro addSubview:lbl];
    }
    
    
    

    
    
    [btn_yasoyusuario addTarget:self action:@selector(ShowLogin:) forControlEvents:UIControlEventTouchUpInside];
    [btn_nuevousuario addTarget:self action:@selector(ShowRegistro:) forControlEvents:UIControlEventTouchUpInside];
    [btn_atras addTarget:self action:@selector(Atras:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
}

-(IBAction)actualizarimagen:(id)sender{
    contador_bienvenida++;
    CGRect frame_img_presentation1 = img_presentation1.frame;
    CGRect frame_img_presentation2= img_presentation2.frame;
    CGRect frame_img_presentation3 = img_presentation3.frame;
    switch(contador_bienvenida) {
        case 1:
            //do something;
            img_presentation2.hidden=YES;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                if (self.view.frame.size.width==375) {
                    frame_img_presentation1.origin.x = 0;
                    frame_img_presentation2.origin.x = 375;
                    frame_img_presentation3.origin.x = -375;
                }
                else if (self.view.frame.size.width==414){
                    frame_img_presentation1.origin.x = 0;
                    frame_img_presentation2.origin.x = 414;
                    frame_img_presentation3.origin.x = -414;
                }
                else{
                    frame_img_presentation1.origin.x = 0;
                    frame_img_presentation2.origin.x = 320;
                    frame_img_presentation3.origin.x = -320;
                }
            }
            else{
                frame_img_presentation1.origin.x = 0;
                frame_img_presentation2.origin.x = 768;
                frame_img_presentation3.origin.x = -768;
            }
            break;
        case 2:{
            // do something else;
            img_presentation2.hidden = NO;
            img_presentation3.hidden = YES;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                if (self.view.frame.size.width==375) {
                    frame_img_presentation1.origin.x = -375;
                    frame_img_presentation2.origin.x = 0;
                    frame_img_presentation3.origin.x = 375;
                }
                else if (self.view.frame.size.width==414){
                    frame_img_presentation1.origin.x = -414;
                    frame_img_presentation2.origin.x = 0;
                    frame_img_presentation3.origin.x = 414;
                }
                else{
                    frame_img_presentation1.origin.x = -320;
                    frame_img_presentation2.origin.x = 0;
                    frame_img_presentation3.origin.x = 320;
                }
            }
            else{
                frame_img_presentation1.origin.x = -768;
                frame_img_presentation2.origin.x = 0;
                frame_img_presentation3.origin.x = 768;
            }
        }
            
            break;
        case 3:{
            contador_bienvenida = 0;
            img_presentation3.hidden = NO;
             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                 if (self.view.frame.size.width==375) {
                     frame_img_presentation1.origin.x = 375;
                     frame_img_presentation2.origin.x = -375;
                     frame_img_presentation3.origin.x = 0;
                 }
                 else if (self.view.frame.size.width==414){
                     frame_img_presentation1.origin.x = 414;
                     frame_img_presentation2.origin.x = -414;
                     frame_img_presentation3.origin.x = 0;
                 }
                 else{
                     frame_img_presentation1.origin.x = 320;
                     frame_img_presentation2.origin.x = -320;
                     frame_img_presentation3.origin.x = 0;
                 }
             }
             else{
                 frame_img_presentation1.origin.x = 768;
                 frame_img_presentation2.origin.x = -768;
                 frame_img_presentation3.origin.x = 0;
             }

        }
            break;
        default:
            break;
            
            // do something by default;
    }
    [UIView beginAnimations:Nil context:nil];
    [UIView setAnimationDuration:0.9];
    img_presentation1.frame = frame_img_presentation1;
    img_presentation2.frame = frame_img_presentation2;
    img_presentation3.frame = frame_img_presentation3;
    [UIView commitAnimations];
}

-(IBAction)Atras:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)ShowLogin:(id)sender{
    if ([contenedor_login_fondo isHidden]){
        contenedor_login_fondo.hidden = NO;
    }
    else{
        [txt_usuario resignFirstResponder];
        [txt_pass resignFirstResponder];
        contenedor_login_fondo.hidden = YES;
    }
    
}
-(IBAction)ShowRegistro:(id)sender{
    if ([contenedor_registro_fondo isHidden]){
        contenedor_registro_fondo.hidden = NO;
    }
    else{
        [txt_nombre resignFirstResponder];
        [txt_apaterno resignFirstResponder];
        [txt_amaterno resignFirstResponder];
        [txt_telefono resignFirstResponder];
        [txt_correo resignFirstResponder];
        [txt_correo2 resignFirstResponder];
        [txt_pass_registro resignFirstResponder];
        [txt_pass_registro2 resignFirstResponder];
        contenedor_registro_fondo.hidden = YES;
    }
}

-(IBAction)Login:(id)sender{
    NSString* error_ = @"";
    
    [txt_pass resignFirstResponder];
    [txt_usuario resignFirstResponder];
 /*   if (!reachable) {
         error_ =  @"Sin conexión valida a internet";
    }*/
    
    if ([[txt_pass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        error_ = @"Debe escribir una contraseña válida";
        [txt_pass becomeFirstResponder];
    }
    if ([[txt_usuario.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        error_ = @"Debe escribir un usuario válido";
        [txt_usuario becomeFirstResponder];
    }
    if ([error_ isEqualToString:@""]) {
        
        metodo_ = @"Login";
        
        NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"usuario", @"password", @"tipo",@"dispositivo", @"push_token", @"so", nil];
        NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:txt_usuario.text ,txt_pass.text, @"U", DeviceToken, DeviceToken, @"I",  nil];
        
        [soapTool callSoapServiceWithParameters__functionName:@"Login" tags:tags vars:vars wsdlURL:@"http://201.131.96.45/wbs/wbs_taccsi.php?wsdl"];
        [self Animacion:1];
        
    }
    else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"TACCSI" message:error_ delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(IBAction)Registro:(id)sender{
    
    
    [txt_amaterno resignFirstResponder];
    [txt_telefono resignFirstResponder];
    [txt_correo resignFirstResponder];
    [txt_correo2 resignFirstResponder];
    [txt_pass_registro resignFirstResponder];
    [txt_pass_registro2 resignFirstResponder];
    
    
    NSString* error_ = @"";
    

    if ([[txt_pass_registro.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || [[txt_pass_registro2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || ![[txt_pass_registro.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:[txt_pass_registro2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] ) {
        error_ = @"Debe escribir contraseñas válidas e iguales";
        [txt_pass_registro becomeFirstResponder];
    }
    
    if ([[txt_correo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || ![self validateEmail:[txt_correo text]]) {
        error_ = @"Debe escribir correo electrónico válido";
        [txt_correo becomeFirstResponder];
    }
    
    if ([[txt_telefono.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || [self getLength:txt_telefono.text]!=10) {
        error_ = @"Debe escribir su teléfono a 10 digítos";
        [txt_telefono becomeFirstResponder];
    }
    
    if ([txt_fecha_nacimiento.text isEqualToString:@""]){
        error_ = @"Debe definir su fecha de nacimiento";
        [self ShowDate:self];
    }
    
    if ([[txt_apaterno.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        error_ = @"Debe escribir su apellido paterno";
        [txt_apaterno becomeFirstResponder];
    }
    
    if ([[txt_nombre.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        error_ = @"Debe escribir su(s) nombre(s) completo(s)";
        [txt_nombre becomeFirstResponder];
    }
    
    if ([error_ isEqualToString:@""]) {
        
        metodo_ = @"RegistraUsuario";
        
        NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"nombre", @"apaterno", @"amaterno",@"movil", @"email", @"password", @"dispositivo", @"push_token", @"so", nil];
        NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:txt_nombre.text ,txt_apaterno.text, txt_amaterno.text, [self formatNumber:txt_telefono.text],  txt_correo.text, txt_pass_registro.text,DeviceToken, DeviceToken, @"I", nil];
        
        [soapTool callSoapServiceWithParameters__functionName:@"RegistraUsuario" tags:tags vars:vars wsdlURL:@"http://201.131.96.45/wbs/wbs_taccsi.php?wsdl"];
        [self Animacion:1];
    }
    else{
        UIAlertView* alerta = [[UIAlertView alloc] initWithTitle:@"TACCSI" message:error_ delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alerta show];
    }
}

- (void)didReceiveMemoryWarning
{
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

-(void)retriveFromSYSoapTool:(NSMutableArray *)_data{
    StringCode = @"";
    StringMsg = @"";
    StringCode = @"-10";
    GlobalUsu = @"";
    GlobalID = @"";
    GlobalNombre = @"";
    GlobalApaterno = @"";
    GlobalAmaterno = @"";
    GlobalTelefono = @"";
    GlobalCorreo = @"";
    Globalfoto_perfil = @"";
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
    if ([elementName isEqualToString:@"response"]) {
        [currentElementData removeAllObjects];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //Take the string inside an element (e.g. <tag>string</tag>) and save it in a property
    [currentElementString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"code"])
        StringCode = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([elementName isEqualToString:@"msg"])
        StringMsg = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([elementName isEqualToString:@"id"])
        GlobalID = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([elementName isEqualToString:@"nombre"])
        GlobalNombre = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([elementName isEqualToString:@"apaterno"])
        GlobalApaterno = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([elementName isEqualToString:@"amaterno"])
        GlobalAmaterno = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([elementName isEqualToString:@"telefono"])
        GlobalTelefono = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([elementName isEqualToString:@"correo"])
        GlobalCorreo = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([elementName isEqualToString:@"foto_perfil"])
        Globalfoto_perfil = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    //Document has been parsed. It's time to fire some new methods off!
    [self FillArray];
}

-(void)FillArray{
    
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
        
        if ([metodo_ isEqualToString:@"RegistraUsuario"]) {
            GlobalPass = txt_pass_registro.text;
            GlobalCorreo = txt_correo.text;
        }
        else{
            GlobalPass = txt_pass.text;
        }
        
        self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"taccsi_bd.sql"];
        
        NSString *query = [NSString stringWithFormat:@"delete from TABLE_USUARIOS"];
        [self.dbManager executeQuery:query];
        if (self.dbManager.affectedRows != 0)
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        else
            NSLog(@"Could not execute the query.");
        
        NSInteger id_usuario = [GlobalID integerValue];
        
        query = [NSString stringWithFormat:@"insert into TABLE_USUARIOS values(%ld, '%@', '%@' , '%@' , '%@' , '%@' , '%@')", (long)id_usuario, Globalfoto_perfil, GlobalNombre, GlobalApaterno, GlobalAmaterno, GlobalTelefono, GlobalCorreo];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // If the query was successfully executed then pop the view controller.
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        }
        else{
            NSLog(@"Could not execute the query.");
        }
        
        NSString* FileName = [NSString stringWithFormat:@"%@/Pass.txt", documentsDirectory];
        NSString* DataMobilePass = [NSString stringWithFormat:@"%@", GlobalPass];
        
        
        [DataMobilePass writeToFile:FileName atomically:NO encoding:NSStringEncodingConversionExternalRepresentation error:nil];
        
        NSArray* datos_usuario = [[NSArray alloc] initWithObjects:GlobalID, Globalfoto_perfil, GlobalNombre, GlobalApaterno,GlobalAmaterno,GlobalTelefono,GlobalCorreo, nil];
        FileName = [NSString stringWithFormat:@"%@/Usuario.txt", documentsDirectory];
        [datos_usuario writeToFile:FileName atomically:YES];
        
        usuario_logueado = YES;
        [self Atras:self];
    }
}


-(void)Animacion:(int)Code{
    if (Code==1) {
        btn_nuevousuario.enabled = NO;
        btn_yasoyusuario.enabled = NO;
        btn_olvide_pass.enabled = NO;
        btn_cerrar_login.enabled = NO;
        btn_atras.enabled = NO;
        btn_iniciar_sesion.enabled = NO;
        actividad.hidesWhenStopped = TRUE;
        [actividad startAnimating];
    }
    else {
        btn_nuevousuario.enabled = YES;
        btn_yasoyusuario.enabled = YES;
        btn_olvide_pass.enabled = YES;
        btn_cerrar_login.enabled = YES;
        btn_atras.enabled = YES;
        btn_iniciar_sesion.enabled = YES;
        [actividad stopAnimating];
        [actividad hidesWhenStopped];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    if (textField == txt_nombre || textField == txt_apaterno || textField == txt_amaterno) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ áéíóúñ"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    
    else if (textField == txt_pass_registro || textField == txt_pass_registro2) {
        
      /*  if (textField.text.length >= 8 && range.length == 0)
        {
            return NO; // return NO to not change text
        }
        else
        {
        }*/
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
        
        return YES;
        
    }
    
    
    else if (textField == txt_telefono){
        NSUInteger length = [self getLength:textField.text];
        //NSLog(@"Length  =  %d ",length);
        
        NSString *num = [self formatNumber:textField.text];
        if (length == 2) {
            NSString* parte1 = [NSString stringWithFormat:@"%@", [num substringToIndex:2]];
            if ([parte1 isEqualToString:@"55"] || [parte1 isEqualToString:@"33"] || [parte1 isEqualToString:@"81"]) {
                textField.text = [NSString stringWithFormat:@"(%@) ",num];
                if(range.length > 0)
                    textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:2]];
            }
        }
        
        
        if(length == 3)
        {
            NSString* parte1 = [NSString stringWithFormat:@"%@", [num substringToIndex:2]];
            if (![parte1 isEqualToString:@"55"] && ![parte1 isEqualToString:@"33"] && ![parte1 isEqualToString:@"81"]) {
                textField.text = [NSString stringWithFormat:@"(%@) ",num];
                if(range.length > 0)
                    textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
            }
            
        }
        else if(length == 6)
        {
            NSString *num = [self formatNumber:textField.text];
            
            NSString* parte1 = [NSString stringWithFormat:@"%@", [num substringToIndex:2]];
            if ([parte1 isEqualToString:@"55"] || [parte1 isEqualToString:@"33"] || [parte1 isEqualToString:@"81"]) {
                textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:2],[num substringFromIndex:2]];
                if(range.length > 0)
                    textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:2],[num substringFromIndex:2]];
            }
            else{
                textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
                if(range.length > 0)
                    textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
            }
            
            
        }
        if(length == 10){
            if(range.length == 0)
                return NO;
        }
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    
    return YES;
}

-(NSString*)formatNumber:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSUInteger length = [mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        
    }
    
    
    return mobileNumber;
}

-(NSUInteger)getLength:(NSString*)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSUInteger length = [mobileNumber length];
    
    return length;
    
}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

-(IBAction)ShowDate:(id)sender{
    [self.view endEditing:YES];
    //create the alertview
    setBirthDate = [[UIAlertView alloc] initWithTitle:@"Fecha de nacimiento"
                                              message:nil
                                             delegate:self
                                    cancelButtonTitle:@"Aceptar"
                                    otherButtonTitles:nil, nil];
    setBirthDate.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    //create the datepicker
    birthDatePicker = [[UIDatePicker alloc] init];
    [birthDatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    birthDatePicker.datePickerMode = UIDatePickerModeDate;
    birthDatePicker.date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-100];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    comps = [[NSDateComponents alloc] init];
    [comps setYear:-18];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [birthDatePicker setMaximumDate:maxDate];
    [birthDatePicker setMinimumDate:minDate];
    
    
    //get the textfield provided in the plain text alertview
    birthDateInput = [setBirthDate textFieldAtIndex:0];
    //change the textfields inputView to the date picker
    birthDateInput.inputView = birthDatePicker;
    [birthDateInput setTextAlignment:NSTextAlignmentCenter];
    //create a date formatter to suitably show the date
    birthDateFormatter = [[NSDateFormatter alloc] init];
    [birthDateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [birthDateFormatter setDateFormat:@"dd-MM-yyyy"];
    //set the current date into the textfield
    if (fecha_ == nil) {
        fecha_ = maxDate;
    }
    birthDateInput.text = [self ConvierteFecha:fecha_];
    txt_fecha_nacimiento.text = [self ConvierteFecha:fecha_];
    [birthDatePicker setDate:fecha_];
    //show the alert view and activate the textfield
    [setBirthDate show];
    // [birthDateInput becomeFirstResponder];
    
}
- (void) dateChanged:(id)sender{
    UIDatePicker *birthDatePicker_ = (UIDatePicker *)sender;
    birthDateFormatter = [[NSDateFormatter alloc] init];
    [birthDateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [birthDateFormatter setDateFormat:@"dd-MM-yyyy"];
    fecha_ = birthDatePicker_.date;
    
    birthDateInput.text = [self ConvierteFecha:fecha_];
    txt_fecha_nacimiento.text = [self ConvierteFecha:fecha_];
}


-(NSString*)ConvierteFecha:(NSDate*)Fecha{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:fecha_];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger year = [components year];
    NSString* month_ = @"";
    switch (month) {
        case 1:
            month_ = @"Enero";
            break;
        case 2:
            month_ = @"Febrero";
            break;
        case 3:
            month_ = @"Marzo";
            break;
        case 4:
            month_ = @"Abril";
            break;
        case 5:
            month_ = @"Mayo";
            break;
        case 6:
            month_ = @"Junio";
            break;
        case 7:
            month_ = @"Julio";
            break;
        case 8:
            month_ = @"Agosto";
            break;
        case 9:
            month_ = @"Septiembre";
            break;
        case 10:
            month_ = @"Octubre";
            break;
        case 11:
            month_ = @"Noviembre";
            break;
        case 12:
            month_ = @"Diciembre";
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"%ld - %@ - %ld", (long)day, month_, (long)year];
}



@end
