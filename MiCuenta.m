//
//  MiCuenta.m
//  TACCSI
//
//  Created by Angel Rivas on 9/1/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import "MiCuenta.h"
//#import "MisLugares.h"
#import "Portada.h"
#import "Reachability.h"

extern NSString* documentsDirectory;
extern NSString* GlobalUsu;
extern NSString* GlobalPass;
extern NSString* GlobalNombre;
extern NSString* GlobalApaterno;
extern NSString* GlobalAmaterno;
extern NSString* GlobalTelefono;
extern NSString* GlobalCorreo;
extern NSString* GlobalID;
extern NSString* GlobalString;
extern NSString* Globalfoto_perfil;
extern NSString* dispositivo;
@interface MiCuenta (){
    BOOL Show;
    NSString* FileName;
    NSString *imagePaths;
    SYSoapTool *soapTool;
    BOOL editar_txt;
    NSData *imageData;
    NSString *mediaType;
    UIImage *editedImage;
    BOOL reachable;
    NSString* imagen_usuario;
}

@end

@implementation MiCuenta

#pragma mark -
#pragma mark Notification Handling
- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    
    if ([reachability isReachable]) {
        NSLog(@"Reachable");
        reachable = YES;
    } else {
        NSLog(@"Unreachable");
        reachable = NO;
    }
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
        
        self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"taccsi.sql"];
        
        NSString *query = [NSString stringWithFormat:@"delete from TABLE_USUARIOS"];
        [self.dbManager executeQuery:query];
        if (self.dbManager.affectedRows != 0)
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        else
            NSLog(@"Could not execute the query.");
        
        NSInteger id_usuario = [GlobalID integerValue];
        
        query = [NSString stringWithFormat:@"insert into TABLE_USUARIOS values(%d, '%@', '%@' , '%@' , '%@' , '%@' , '%@')", id_usuario, Globalfoto_perfil, GlobalNombre, GlobalApaterno, GlobalAmaterno, GlobalTelefono, GlobalCorreo];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // If the query was successfully executed then pop the view controller.
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            NSString* FileNames = [NSString stringWithFormat:@"%@/Pass.txt", documentsDirectory];
            NSString* DataMobilePass = [NSString stringWithFormat:@"%@", GlobalPass];
            [DataMobilePass writeToFile:FileNames atomically:NO encoding:NSStringEncodingConversionExternalRepresentation error:nil];
        }
        else{
            NSLog(@"Could not execute the query.");
        }
        
        [self Cancelar:self];
    }
}

#pragma mark - Animacion

-(void)Animacion:(int)Code{
    if (Code==1) {
        btn_cancelar.enabled = NO;
        btn_editar.enabled = NO;
        btn_guardar.enabled = NO;
        actividad.hidesWhenStopped = TRUE;
        [actividad startAnimating];
        editar_txt = NO;
    }
    else {
        editar_txt = YES;
        btn_cancelar.enabled = YES;
        btn_editar.enabled = YES;
        btn_guardar.enabled = YES;
        [actividad stopAnimating];
        [actividad hidesWhenStopped];
    }
}

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    editar_txt = YES;
    soapTool = [[SYSoapTool alloc]init];
    soapTool.delegate = self;
     imageData = nil;
    Show = NO;
    
    img_foto.image = [UIImage imageNamed:@"sin_foto_perfil"];
    CALayer *imageLayer = img_foto.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [img_foto.layer setCornerRadius:img_foto.frame.size.width/2];
    [imageLayer setMasksToBounds:YES];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"taccsi.sql"];
    //SELECT ID FROM TABLE_USUARIOS  LIMIT 1
    NSString *query = [NSString stringWithFormat:@"select * from TABLE_USUARIOS LIMIT 1"];
    NSArray* datos_usuario = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    if ([datos_usuario count]>0) {
        NSArray* datos_usuario_ = [[NSArray alloc]init];
        datos_usuario_ = [datos_usuario objectAtIndex:0];
        if ([datos_usuario_ count]>6) {
            GlobalUsu = [datos_usuario_ objectAtIndex:6];
            GlobalCorreo = [datos_usuario_ objectAtIndex:6];
            Globalfoto_perfil = [datos_usuario_ objectAtIndex:1];
            GlobalID = [datos_usuario_ objectAtIndex:0];
            GlobalNombre = [datos_usuario_ objectAtIndex:2];
            GlobalApaterno = [datos_usuario_ objectAtIndex:3];
            GlobalAmaterno = [datos_usuario_ objectAtIndex:4];
            GlobalTelefono = [datos_usuario_ objectAtIndex:5];
            
            txt_nombre.text = GlobalNombre;
            txt_apaterno.text = GlobalApaterno;
            txt_amaterno.text = GlobalAmaterno;
            lbl_nombre.text = [NSString stringWithFormat:@"%@ %@ %@", GlobalNombre, GlobalApaterno, GlobalAmaterno];
            txt_telefono.text = GlobalTelefono;
            lbl_telefono.text = GlobalTelefono;
            txt_correo.text = GlobalCorreo;
            lbl_correo.text = GlobalCorreo;
            
            NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            imagen_usuario = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[GlobalID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@".png"]];
            UIImage *pImage;
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imagen_usuario];
            if (!fileExists) {
                pImage = [UIImage imageNamed:@"sin_foto.png"];
            }
            else
                pImage = [UIImage imageWithContentsOfFile:imagen_usuario];
            if (pImage != nil || pImage != Nil) {
                img_foto.image = pImage;
            }
            else{
                img_foto.image = [UIImage imageNamed:@"sin_foto.png"];
            }
        }
        
    }
    FileName = [NSString stringWithFormat:@"%@/Pass.txt", documentsDirectory];
    NSString *contents = [[NSString alloc] initWithContentsOfFile:FileName usedEncoding:nil error:nil];
    if (contents != nil && ![contents isEqualToString:@"Error"] && ![contents isEqualToString:@"(null)|(null)|(null)|(null)|(null)|(null)|(null)"]) {
        GlobalPass = contents;
        NSString* pass_ = @"";
        for (int i = 0 ; i<GlobalPass.length; i++) {
            pass_ = [pass_ stringByAppendingString:@"*"];
        }
        lbl_pass.text = pass_;
        txt_pass.text = GlobalPass;
        txt_pass1.text = GlobalPass;
    }
    txt_correo.enabled = NO;
    txt_nombre.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_apaterno.delegate = self;
    txt_apaterno.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_amaterno.delegate = self;
    txt_amaterno.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_telefono.delegate = self;
    txt_telefono.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSString *num = [self formatNumber:txt_telefono.text];
    NSString *s1;
    NSString *s2;
    NSString *s3;
    NSString* parte1 = [NSString stringWithFormat:@"%@", [num substringToIndex:2]];
    if ([parte1 isEqualToString:@"55"] || [parte1 isEqualToString:@"33"] || [parte1 isEqualToString:@"81"]) {
        s1 = [num substringWithRange: NSMakeRange(0, 2)];
        s2 = [num substringWithRange: NSMakeRange(2, 4)];
    }
    else{
        s1 = [num substringWithRange: NSMakeRange(0, 3)];
        s2 = [num substringWithRange: NSMakeRange(3, 3)];
    }
    s3 = [num substringWithRange: NSMakeRange(6, 4)];
    txt_telefono.text = [NSString stringWithFormat:@"(%@) %@-%@", s1,s2,s3];
    lbl_telefono.text = [NSString stringWithFormat:@"(%@) %@-%@", s1,s2,s3];
    
    txt_pass.delegate = self;
    txt_pass.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_pass1.delegate = self;
    txt_pass1.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_correo.delegate = self;
    txt_correo.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [btn_guardar addTarget:self action:@selector(Guardar:) forControlEvents:UIControlEventTouchUpInside];
    [btn_editar addTarget:self action:@selector(ShowEditar:) forControlEvents:UIControlEventTouchUpInside];
    [btn_cancelar addTarget:self action:@selector(Cancelar:) forControlEvents:UIControlEventTouchUpInside];
    [btn_lugares addTarget:self action:@selector(Lugares:) forControlEvents:UIControlEventTouchUpInside];
    [btn_foto addTarget:self action:@selector(foto:) forControlEvents:UIControlEventTouchUpInside];
    NSString* FileNames = [NSString stringWithFormat:@"%@/%@_Favoritos.txt", documentsDirectory, GlobalID];
    NSMutableArray* MAFavoritos = [[NSMutableArray alloc] initWithContentsOfFile:FileNames];
    lbl_lugares.text = [NSString stringWithFormat:@"%lu", (unsigned long)[MAFavoritos count]];
    btn_guardar.hidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)foto:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Escoger foto", @"Tomar Foto", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else if(buttonIndex==1){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    img_foto.image = chosenImage;
    //extracting image from the picker and saving it
    mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    imageData = UIImageJPEGRepresentation(chosenImage, 30);
    mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if ([mediaType isEqualToString:@"public.image"]){
        editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        NSData *webData = UIImagePNGRepresentation(editedImage);
        [webData writeToFile:imagen_usuario atomically:YES];
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)generateBoundaryString
{
    // generate boundary string
    //
    // adapted from http://developer.apple.com/library/ios/#samplecode/SimpleURLConnections
    
    CFUUIDRef  uuid;
    NSString  *uuidStr;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
    assert(uuidStr != NULL);
    
    CFRelease(uuid);
    
    return [NSString stringWithFormat:@"Boundary-%@", uuidStr];
}

- (NSString *)mimeTypeForPath:(NSString *)path
{
    // get a mime type for an extension using MobileCoreServices.framework
    
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    assert(UTI != NULL);
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    assert(mimetype != NULL);
    
    CFRelease(UTI);
    
    return mimetype;
}

- (void)uploadFileAtPath:(NSString *)imagePath
                forField:(NSString *)fieldName
                     URL:(NSURL*)url
              parameters:(NSDictionary *)parameters
{
    //NSString *filename = [imagePath lastPathComponent];
    imageData = [NSData dataWithContentsOfFile:imagePath];
    
    NSMutableData *httpBody = [NSMutableData data];
    NSString *boundary = [self generateBoundaryString];
    NSString *mimetype = [self mimeTypeForPath:imagePath];
    
    // configure the request
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set content type
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // add params (all params are strings)
    
    /*    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
     [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"name"] dataUsingEncoding:NSUTF8StringEncoding]];
     [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
     }];
     
     NSString* file_name = [NSString stringWithFormat:@"%@%@", @"uploadedfile;filename=", fotografia_perro ];
     [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", file_name] dataUsingEncoding:NSUTF8StringEncoding]];*/
    
    //dos.writeBytes("Content-Disposition: form-data; name=\"uploadedfile\";filename=\""+ ruta_archivo + "\"" + lineEnd);
    
    // add image data
    
    if (imageData) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fotografia_perro, fotografia_perro] dataUsingEncoding:NSUTF8StringEncoding]];
        //   ["Content-Disposition: form-data; name=\"uploadedfile\";filename=\"%@\" \r\n\r\n"];
        //     NSString* file_name = [NSString stringWithFormat:@"%@%@", id_mascota, @".png"];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadedfile\";filename=\"%@\" \r\n", imagePath] dataUsingEncoding:NSUTF8StringEncoding]];
        //    [httpBody appendData:[@"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"27.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:imageData];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    
    [request setHTTPBody:httpBody];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError)
        {
            NSLog(@"sendAsynchronousRequest error=%@", connectionError);
            return;
        }
        
        NSString *string = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSLog(@"Success: %@", string);
    }];
}


-(IBAction)onUploadDone:(id)sender{
    NSLog(@"QUe chingon");
}

-(IBAction)onUploadError:(id)sender{
    NSLog(@"QUe mal");
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)Lugares:(id)sender{
/*    formulario_atras_lugares = @"MiCuenta";
    NSString* view_name = @"MisLugares";
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
    } else {
        view_name = [view_name stringByAppendingString:@"_iPad"];
        
    }
   
    MisLugares *view = [[MisLugares alloc] initWithNibName:view_name bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];*/
}

-(IBAction)ShowEditar:(id)sender{
    
  //  CGRect frame = contenedor_txt.frame;
    if (Show) {
       btn_editar.hidden = NO;
        Show = NO;
        /*CGSize screenSize = [[UIScreen mainScreen] bounds].size;
                frame.origin.x = 320;
        if (screenSize.height == 667.0f) {
                    frame.origin.x = 375;
        }
        if (screenSize.height == 736.0f) {
                    frame.origin.x = 444;
        }*/
        contenedor_txt.hidden = YES;
        btn_guardar.hidden = YES;
    }
    else{
        btn_editar.hidden = YES;
        btn_guardar.hidden = NO;
        Show = YES;
        contenedor_txt.hidden = NO;
    }
  /*  [UIView beginAnimations:Nil context:nil];
    [UIView setAnimationDuration:0.1];
    contenedor_txt.frame = frame;
    [UIView commitAnimations];*/
}

-(IBAction)Cancelar:(id)sender{
    [self.view endEditing:YES];
    if (Show) {
        NSString* pass_ = @"";
        for (int i = 0 ; i<GlobalPass.length; i++) {
            pass_ = [pass_ stringByAppendingString:@"*"];
        }
    /*    lbl_pass.text = pass_;
        txt_pass.text = GlobalPass;
        txt_pass1.text = GlobalPass;
        txt_nombre.text = GlobalNombre;
        txt_apaterno.text = GlobalApaterno;
        txt_amaterno.text = GlobalAmaterno;
        lbl_nombre.text = [NSString stringWithFormat:@"%@ %@ %@", GlobalNombre, GlobalApaterno, GlobalAmaterno];
        txt_telefono.text = GlobalTelefono;
        lbl_telefono.text = GlobalTelefono;
        txt_correo.text = GlobalCorreo;
        lbl_correo.text = GlobalCorreo;*/
        [self ShowEditar:self];
    }
    else{
        [self Animacion:1];
        [self Atras:self];
    }
    
}

-(IBAction)Atras:(id)sender{
    
   
    
    NSString* error_ = @"";
    
    if (imageData!=nil) {
         [self Animacion:1];
        //NSString *urlString = @"http://petlocator.com.mx/images/mascotas/upload.php";
        NSString* url_ = [NSString stringWithFormat:@"%@%@%@%@%@",@"http://taccsi.com/images/taxis/upload.php?id=",GlobalID,@"&im=", GlobalID, @".png"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:url_]];
        [request setHTTPMethod:@"POST"];
        
        NSString* boundary = [NSString stringWithFormat:@"%@", @"---------------------------14737809831466499882746641449"];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        NSString* file_name_ = [NSString stringWithFormat:@"%@%@%@", @"Content-Disposition: form-data; name=\"userfile\"; filename=\"",GlobalID, @".png\"\r\n"];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[file_name_ dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        returnString = [returnString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"%@", returnString);
        
        if ([returnString isEqualToString:@"La foto fue actualizada correctamente."]) {
            imageData = nil;
            if ([mediaType isEqualToString:@"public.image"]){
                
                NSData *webData = UIImagePNGRepresentation(editedImage);
                [webData writeToFile:imagen_usuario  atomically:YES];
            }
        }
        else{
            error_ = returnString;
        }
    }
    
    [self Animacion:2];
    
    if ([error_ isEqualToString:@""]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        imageData = nil;
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"TACCSI" message:error_ delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    
}

-(IBAction)Guardar:(id)sender{
    
    NSString* error_ = @"";
    
    if (imageData!=nil) {
        
        //NSString *urlString = @"http://petlocator.com.mx/images/mascotas/upload.php";
        NSString* url_ = [NSString stringWithFormat:@"%@%@%@%@%@",@"http://taccsi.com/images/taxis/upload.php?id=",GlobalID,@"&im=", GlobalID, @".png"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:url_]];
        [request setHTTPMethod:@"POST"];
        
        NSString* boundary = [NSString stringWithFormat:@"%@", @"---------------------------14737809831466499882746641449"];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        NSString* file_name_ = [NSString stringWithFormat:@"%@%@%@", @"Content-Disposition: form-data; name=\"userfile\"; filename=\"",GlobalID, @".png\"\r\n"];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[file_name_ dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        returnString = [returnString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"%@", returnString);
        
        if ([returnString isEqualToString:@"La foto fue actualizada correctamente."]) {
            imageData = nil;
            if ([mediaType isEqualToString:@"public.image"]){
                
                NSData *webData = UIImagePNGRepresentation(editedImage);
                [webData writeToFile:imagePaths  atomically:YES];
            }
        }
        else{
            error_ = returnString;
        }
        
        
    }
    
    
    if ([[txt_nombre.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        error_ = @"Debe escribir su(s) nombre(s) completo(s)";
        [txt_nombre becomeFirstResponder];
    }
    if ([[txt_apaterno.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        error_ = @"Debe escribir su apellido paterno";
        [txt_apaterno becomeFirstResponder];
    }
    if ([[txt_telefono.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || [self getLength:txt_telefono.text]!=10) {
        error_ = @"Debe escribir su teléfono a10 digítos";
        [txt_telefono becomeFirstResponder];
    }
    if ([[txt_correo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || ![self validateEmail:[txt_correo text]]) {
        error_ = @"Debe escribir un correo electrónico válido";
        [txt_correo becomeFirstResponder];
    }
    if ([[txt_pass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || [[txt_pass1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || ![[txt_pass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:[txt_pass1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] ) {
        error_ = @"Debe escribir contraseñas válidas";
        [txt_pass becomeFirstResponder];
    }
    
    if ([error_ isEqualToString:@""]) {
        [self Cancelar:self];
        NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"usuario", @"password", @"tipo",@"dispositivo", @"push_token",   @"nombre",  @"Apellidop",  @"Apellidom",  @"telefono", @"correo", @"contrasena",  @"so",  nil];
        NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:txt_correo.text ,GlobalPass,  @"U", @"0", @"0", txt_nombre.text, txt_apaterno.text, txt_amaterno.text, [self formatNumber:txt_telefono.text], txt_correo.text, txt_pass.text, @"I", nil];
        [soapTool callSoapServiceWithParameters__functionName:@"Actualiza_user" tags:tags vars:vars wsdlURL:@"http://201.131.96.45/wbs/wbs_taccsi.php?wsdl"];
        [self Animacion:1];
    }
    else{
        UIAlertView* alerta = [[UIAlertView alloc] initWithTitle:@"TACCSI" message:error_ delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alerta show];
    }
}

/*Method to hidden keyboard*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
/*Method to hidden keyboard*/

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == txt_nombre || textField == txt_apaterno || textField == txt_amaterno) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ áéíóúñ"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    
    else if (textField == txt_pass || textField == txt_pass1) {
        
        if (textField.text.length >= 8 && range.length == 0)
        {
            return NO; // return NO to not change text
        }
        else
        {
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            
            return [string isEqualToString:filtered];
            
            return YES;
        }
        
    }
    
    
    else if (textField == txt_telefono){
        NSUInteger length = [self getLength:textField.text];
        //NSLog(@"Length  =  %d ",length);
        
        if(length == 10)
        {
            if(range.length == 0)
                return NO;
        }
        
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
    
    NSLog(@"%@", mobileNumber);
    
    NSUInteger length = [mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return editar_txt;
}

- (NSUInteger)supportedInterfaceOrientations {
    
    NSUInteger retorno;
    //  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    retorno = UIInterfaceOrientationMaskPortrait;
    // else
    //   retorno = UIInterfaceOrientationMaskLandscape;
    return retorno;
}

@end
