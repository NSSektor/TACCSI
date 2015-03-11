//
//  Login.m
//  TACCSI
//
//  Created by Angel Rivas on 2/16/15.
//  Copyright (c) 2015 Tecnologizame. All rights reserved.
//

#import "Login.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>

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


@interface Login (){
    BOOL reachable;
     SYSoapTool *soapTool;
}

@end

@implementation Login


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
    
    //DeviceToken = [[UAirship shared] deviceToken];
    
    contenedor_vista = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:contenedor_vista];
    
    float height_img =  (224 / (800 / contenedor_vista.frame.size.width));
    float espacio = self.view.frame.size.height - height_img - 228;
    float espacio_objetos = (espacio / 3) / 5;
    
    
    contenedor_imagen = [[UIView alloc] initWithFrame:CGRectMake(0, espacio / 3, self.view.frame.size.width, height_img)];
    [contenedor_vista addSubview:contenedor_imagen];
    img_taccsi = [[UIImageView alloc] initWithFrame:CGRectMake(0,  0 , contenedor_imagen.frame.size.width, 224 / (800 / contenedor_imagen.frame.size.width))];
    img_taccsi.image = [UIImage imageNamed:@"img_menu"];
    [contenedor_imagen addSubview:img_taccsi];
    
    contenedor_txt = [[UIView alloc] initWithFrame:CGRectMake(0, contenedor_imagen.frame.origin.y + contenedor_imagen.frame.size.height + espacio_objetos,self.view.frame.size.width,228 + espacio_objetos *4)];
    [contenedor_vista addSubview:contenedor_txt];
    for (int i=0; i<6;i++) {
        UILabel* lbl =[[UILabel alloc]init];
        switch (i) {
            case 0:{lbl.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 1:{lbl.frame = CGRectMake(0, 1, self.view.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1];}
                break;
            case 2:{lbl.frame = CGRectMake(15, 48, self.view.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 3:{lbl.frame = CGRectMake(15, 49, self.view.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1];}
                break;
            case 4:{lbl.frame = CGRectMake(0, 96, self.view.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];}
                break;
            case 5:{lbl.frame = CGRectMake(0, 97, self.view.frame.size.width, 1);lbl.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1];}
                break;
                
            default:
                break;
        }
        [contenedor_txt addSubview:lbl];
    }
    lbl_usuario = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 85, 21)];
    lbl_usuario.textColor = [UIColor blackColor];
    lbl_usuario.text = @"Usuario";
    lbl_usuario.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    [contenedor_txt addSubview:lbl_usuario];
    
    txt_usuario = [[UITextField alloc] initWithFrame:CGRectMake(90, 10, contenedor_txt.frame.size.width - 100, 26)];
    txt_usuario.delegate = self;
    txt_usuario.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_usuario.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    txt_usuario.textAlignment = NSTextAlignmentCenter;
    [contenedor_txt addSubview:txt_usuario];
    
    lbl_pass = [[UILabel alloc] initWithFrame:CGRectMake(5, 60, 85, 21)];
    lbl_pass.textColor = [UIColor blackColor];
    lbl_pass.text = @"Contraseña";
    lbl_pass.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    [contenedor_txt addSubview:lbl_pass];
    
    txt_pass = [[UITextField alloc] initWithFrame:CGRectMake(90, 60, contenedor_txt.frame.size.width - 100, 26)];
    txt_pass.delegate = self;
    txt_pass.secureTextEntry = YES;
    txt_pass.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_pass.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    txt_pass.textAlignment = NSTextAlignmentCenter;
    [contenedor_txt addSubview:txt_pass];
    
    
    
    btn_iniciar = [[UIButton alloc]initWithFrame:CGRectMake(contenedor_txt.frame.size.width - contenedor_txt.frame.size.width + 20, 98 + espacio_objetos , contenedor_txt.frame.size.width - 40, 35)];
    [btn_iniciar setTitle:@"Iniciar sesión" forState:UIControlStateNormal];
    [btn_iniciar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    btn_iniciar.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1];
    btn_iniciar.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    [btn_iniciar addTarget:self action:@selector(Enviar:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_txt addSubview:btn_iniciar];
    
    btn_cancelar = [[UIButton alloc]initWithFrame:CGRectMake(contenedor_txt.frame.size.width - contenedor_txt.frame.size.width + 20, 133 + espacio_objetos *2 , contenedor_txt.frame.size.width - 40, 35)];
    [btn_cancelar setTitle:@"Cancelar" forState:UIControlStateNormal];
    [btn_cancelar setTitleColor:[UIColor colorWithRed:250.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1] forState:UIControlStateNormal ];
    btn_cancelar.backgroundColor = [UIColor blackColor];
    btn_cancelar.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    [btn_cancelar addTarget:self action:@selector(Cancelar:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_txt addSubview:btn_cancelar];
    
    btn_registro = [[UIButton alloc]initWithFrame:CGRectMake(contenedor_txt.frame.size.width - contenedor_txt.frame.size.width + 20, 168 + espacio_objetos * 3 , contenedor_txt.frame.size.width - 40, 30)];
    [btn_registro setTitle:@"Soy usuario nuevo" forState:UIControlStateNormal];
    [btn_registro setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    btn_registro.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    [btn_registro addTarget:self action:@selector(Registro:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_txt addSubview:btn_registro];
    
    btn_ayuda = [[UIButton alloc]initWithFrame:CGRectMake(contenedor_txt.frame.size.width - contenedor_txt.frame.size.width + 20, 198 + espacio_objetos * 4 , contenedor_txt.frame.size.width - 40, 30)];
    [btn_ayuda setTitle:@"Ayuda" forState:UIControlStateNormal];
    [btn_ayuda setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    btn_ayuda.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    //  [btn_pedir_taccsi addTarget:self action:@selector(ShowResumenViaje:) forControlEvents:UIControlEventTouchUpInside];
    [contenedor_txt addSubview:btn_ayuda];
    
    actividad = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    actividad.color = [UIColor colorWithRed:254.0/255.0 green:214.0/255.0 blue:0.0/255.0 alpha:1.0];
    actividad.hidesWhenStopped = TRUE;
    CGRect newFrames = actividad.frame;
    newFrames.origin.x = (contenedor_vista.frame.size.width / 2) -13;
    newFrames.origin.y = (contenedor_vista.frame.size.height / 2) - 13;
    actividad.frame = newFrames;
    actividad.backgroundColor = [UIColor clearColor];
    actividad.hidden = YES;
    [contenedor_vista addSubview:actividad];
    
    soapTool = [[SYSoapTool alloc]init];
    soapTool.delegate = self;
    txt_usuario.text = @"angel.sektor@gmail.com";
    txt_pass.text = @"modest";
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
        
        GlobalPass = [NSString stringWithFormat:@"%@", txt_pass.text];
        
        self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"taccsi_bd.sql"];
        
        NSString *query = [NSString stringWithFormat:@"delete from TABLE_USUARIOS"];
        [self.dbManager executeQuery:query];
        if (self.dbManager.affectedRows != 0)
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        else
            NSLog(@"Could not execute the query.");
       
     //   NSInteger id_usuario = [GlobalID integerValue];
        
   //     query = [NSString stringWithFormat:@"insert into TABLE_USUARIOS values(%d, '%@', '%@' , '%@' , '%@' , '%@' , '%@')", id_usuario, Globalfoto_perfil, GlobalNombre, GlobalApaterno, GlobalAmaterno, GlobalTelefono, GlobalCorreo];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // If the query was successfully executed then pop the view controller.
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        }
        else{
            NSLog(@"Could not execute the query.");
        }
        
        usuario_logueado = YES;
        [self Cancelar:self];
        /*
        NSString* FileName = [NSString stringWithFormat:@"%@/ConfigFile.txt", documentsDirectory];
        GlobalUsu = txt_usuario.text;
        GlobalPass = txt_pass.text;
        NSString* DataMobileUser = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@", GlobalUsu, @"|", GlobalPass, @"|", GlobalNombre, @"|", GlobalApaterno, @"|" , GlobalAmaterno, @"|",GlobalTelefono, @"|",GlobalCorreo];
        [DataMobileUser writeToFile:FileName atomically:NO encoding:NSStringEncodingConversionExternalRepresentation error:nil];
        usuario_logueado = YES;
        [self Cancelar:self];*/
    }
}

-(IBAction)Enviar:(id)sender{
    NSString* error_ = @"";
    if ([[txt_pass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        error_ = @"Debe escribir una contraseña válida";
        [txt_pass becomeFirstResponder];
    }
    if ([[txt_usuario.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        error_ = @"Debe escribir un usuario válido";
        [txt_usuario becomeFirstResponder];
    }
    if ([error_ isEqualToString:@""]) {
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

-(IBAction)Cancelar:(id)sender{
  /*  MAid_taccsistas               = [[NSMutableArray alloc]init];
    MAconductor_taccsistas  = [[NSMutableArray alloc]init];
    MAplacas_taccsistas        = [[NSMutableArray alloc]init];
    MAestatus_taccsistas       = [[NSMutableArray alloc]init];
    MAlatitud_taccsistas         = [[NSMutableArray alloc]init];
    MAlongitud_taccsistas      = [[NSMutableArray alloc]init];
    MAdistancia_taccsistas     = [[NSMutableArray alloc]init];
    MAfoto_taccsistas             = [[NSMutableArray alloc]init];
    MApuntos_taccsistas        = [[NSMutableArray alloc]init];
    MAservicios_taccsistas      = [[NSMutableArray alloc]init];*/
    
}

-(IBAction)Registro:(id)sender{
    NSString* view_name = @"RegistroNuevo";
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
}

#pragma mark - Animacion

-(void)Animacion:(int)Code{
    if (Code==1) {
        btn_iniciar.enabled = NO;
        btn_cancelar.enabled = NO;
        actividad.hidesWhenStopped = TRUE;
        [actividad startAnimating];
    }
    else {
        btn_iniciar.enabled = YES;
        btn_cancelar.enabled = YES;
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

- (NSUInteger)supportedInterfaceOrientations {
    
    NSUInteger retorno;
    //  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    retorno = UIInterfaceOrientationMaskPortrait;
    // else
    //   retorno = UIInterfaceOrientationMaskLandscape;
    return retorno;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
