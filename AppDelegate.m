//
//  AppDelegate.m
//  TACCSI
//
//  Created by Angel Rivas on 2/12/15.
//  Copyright (c) 2015 Tecnologizame. All rights reserved.
//

#import "AppDelegate.h"

#import <GoogleMaps/GoogleMaps.h>

#import "PayPalMobile.h"

//sdfjdklfjdslkf

#import "Portada.h"
#import "ViewController.h"
#import "Login.h"

#import "Bienvenida.h"

NSString* dispositivo;
NSMutableArray* MAtaccsistas;
NSMutableArray* MAid_taccsistas;
NSMutableArray* MAconductor_taccsistas;
NSMutableArray* MAplacas_taccsistas;
NSMutableArray* MAestatus_taccsistas;
NSMutableArray* MAlatitud_taccsistas;
NSMutableArray* MAlongitud_taccsistas;
NSMutableArray* MAdistancia_taccsistas;
NSMutableArray* MAfoto_taccsistas;
NSMutableArray* MApuntos_taccsistas;
NSMutableArray* MAservicios_taccsistas;
NSString* lat_origen;
NSString* lon_origen;
BOOL usar_ubicacion_actual;
BOOL actualizar_origen;
NSString* direccion_origen;
NSString* lat_destino;
NSString* lon_destino;
BOOL usar_ubicacion_actual_destino;
BOOL actualizar_destino;
NSString* lat_destino;
NSString* lon_destino;
NSString* direccion_destino;
BOOL tengo_destino;
NSString* GlobalUsu;
NSString* GlobalPass;
NSString* GlobalID;
NSString* GlobalNombre;
NSString* GlobalApaterno;
NSString* GlobalAmaterno;
NSString* GlobalTelefono;
NSString* GlobalCorreo;
NSString* Globalfoto_perfil;
NSString* id_taccsista;
NSString* GlobalString;
NSString* DeviceToken;
NSString* documentsDirectory;
NSInteger estatus_viaje;
BOOL usuario_logueado;
BOOL PushLLego;

NSString* lat_favorito;
NSString* lon_favorito;
NSString* direccion_favorito;
BOOL actualizar_favorito;
BOOL usar_ubicacion_actual_favorito;

NSString* razon_cancelacion_viaje_taccsista;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    razon_cancelacion_viaje_taccsista = @"";
    
    [MTReachabilityManager sharedManager];
    [GMSServices provideAPIKey:@"AIzaSyApBVTsc5pwI4cwDbjyHntUN8c47IuvG7I"];
    
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"YOUR_CLIENT_ID_FOR_PRODUCTION",
                                                           PayPalEnvironmentSandbox : @"AWla0RAgvorRuI8iVGUoSMSsRBtHurcw32q2vJX0x9Qg6L1eKxgOk4O7Dzzt"}];
    [GMSServices provideAPIKey:@"AIzaSyApBVTsc5pwI4cwDbjyHntUN8c47IuvG7I"];
    
    UAConfig *config = [UAConfig defaultConfig];
    
    
    // You can also programmatically override the plist values:
    // config.developmentAppKey = @"YourKey";
    // etc.
    
    // Call takeOff (which creates the UAirship singleton)
    [UAirship takeOff:config];
    
    [UAPush shared].userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationActivationModeBackground |
                                             UIUserNotificationTypeBadge |
                                             UIUserNotificationActivationModeForeground |
                                             UIUserNotificationTypeSound);
    
    [UAPush shared].userPushNotificationsEnabled = YES;
    [UAPush shared].pushNotificationDelegate = self;
    
    DeviceToken = [[[UAirship shared] deviceToken] capitalizedString];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    MAtaccsistas = [[NSMutableArray alloc] init];
    MAid_taccsistas = [[NSMutableArray alloc] init];
    MAconductor_taccsistas = [[NSMutableArray alloc] init];
    MAplacas_taccsistas = [[NSMutableArray alloc] init];
    MAestatus_taccsistas = [[NSMutableArray alloc] init];
    MAlatitud_taccsistas = [[NSMutableArray alloc] init];
    MAlongitud_taccsistas = [[NSMutableArray alloc] init];
    MAdistancia_taccsistas = [[NSMutableArray alloc] init];
    MAfoto_taccsistas = [[NSMutableArray alloc] init];
    MApuntos_taccsistas = [[NSMutableArray alloc] init];
    MAservicios_taccsistas = [[NSMutableArray alloc] init];
    lat_origen =  @"19.64";
    lon_origen = @"-99.19";
    actualizar_origen = YES;
    usar_ubicacion_actual = YES;
    direccion_origen = @"";
    
    lat_destino =  @"19.64";
    lon_destino = @"-99.19";
    actualizar_destino = YES;
    usar_ubicacion_actual_destino = YES;
    direccion_destino = @"";
    tengo_destino = NO;
    GlobalString = @"";
    GlobalUsu = @"";
    GlobalPass = @"";
    GlobalID = @"";
    GlobalNombre = @"";
    GlobalApaterno = @"";
    GlobalAmaterno = @"";
    GlobalTelefono = @"";
    GlobalCorreo = @"";
    id_taccsista = @"";
    
    estatus_viaje = 0;
    
    
    [self IRPortada];
    
    [self.window makeKeyAndVisible];
    

    return YES;
}

-(void)IRPortada{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    NSString* ViewName = @"ViewController";
    dispositivo = @"iPhone";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height == 568.0f) {
            ViewName = [ViewName stringByAppendingString:@"_iPhone5"];
            dispositivo = @"iPhone5";
        }
        if (screenSize.height == 667.0f) {
            ViewName = [ViewName stringByAppendingString:@"_iPhone6"];
            dispositivo = @"iPhone6";
        }
        if (screenSize.height == 736.0f) {
            ViewName = [ViewName stringByAppendingString:@"_iPhone6plus"];
            dispositivo = @"iPhone6plus";
        }
    } else {
        //Do iPad stuff here.
        ViewName = [ViewName stringByAppendingString:@"_iPad"];
        dispositivo = @"iPad";
        
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    ViewController*  viewController = [[ViewController alloc] initWithNibName:ViewName bundle:nil];
    self.window.rootViewController = viewController;
}

-(void)ActualizaEstatusViaje:(NSDictionary*)UserInfo{
    
    if ([UserInfo objectForKey:@"aps"]) {
        
        ViewController* portada = [[ViewController alloc] init];
        NSArray* datos_viaje = [portada DameInfoVIaje];
        if ([datos_viaje count]>0) {
            estatus_viaje = [[datos_viaje objectAtIndex:0] integerValue];
            switch (estatus_viaje) {
                case 1:{
                    NSArray *array_ = [[[UserInfo objectForKey:@"aps"] objectForKey:@"sound"] componentsSeparatedByString:@","];
                    if ([array_ count]==2) {
                        if ([[array_ objectAtIndex:0] isEqualToString:@"Su TACCSI va en camino"]) {
                            NSArray* datos_ = [[array_ objectAtIndex:1] componentsSeparatedByString:@"@"];
                            if ([datos_ count]==2) {

                                estatus_viaje = 2;
                                [portada EscribeArchivo_id_estatus_viaje:@"2" id_viaje:[datos_viaje objectAtIndex:1] lat_origen:[datos_viaje objectAtIndex:2] lon_origen:[datos_viaje objectAtIndex:3] lat_destino:[datos_viaje objectAtIndex:4] lon_destino:[datos_viaje objectAtIndex:5] id_taccsista:[datos_ objectAtIndex:1] clave_confirmacion:[datos_ objectAtIndex:0]  foto_taccsista:[datos_viaje objectAtIndex:8] nombre_taccsista:[datos_viaje objectAtIndex:9] apaterno_taccsista:[datos_viaje objectAtIndex:10] amaterno_taccsista:[datos_viaje objectAtIndex:11] telefono:[datos_viaje objectAtIndex:12] marca:[datos_viaje objectAtIndex:13] modelo:[datos_viaje objectAtIndex:14] placas:[datos_viaje objectAtIndex:15] eco:[datos_viaje objectAtIndex:16] foto_taccsi:[datos_viaje objectAtIndex:17] direccion_origen:[datos_viaje objectAtIndex:18] forma_pago:[datos_viaje objectAtIndex:19] importe:[datos_viaje objectAtIndex:20] direccion_destino:[datos_viaje objectAtIndex:21] pasajeros:[datos_viaje objectAtIndex:22]];
                                
                                PushLLego = YES;
                                
                            }
                        }
                    }
                }
                    
                    break;
                case 2:{
                    NSArray *array_ = [[[UserInfo objectForKey:@"aps"] objectForKey:@"sound"] componentsSeparatedByString:@"@"];
                    if ([array_ count]==2) {
                        if ([[array_ objectAtIndex:0] isEqualToString:@"Su viaje ha iniciado."]) {
                            estatus_viaje = 5;
                            [portada EscribeArchivo_id_estatus_viaje:@"5" id_viaje:[datos_viaje objectAtIndex:1] lat_origen:[datos_viaje objectAtIndex:2] lon_origen:[datos_viaje objectAtIndex:3] lat_destino:[datos_viaje objectAtIndex:4] lon_destino:[datos_viaje objectAtIndex:5] id_taccsista:[datos_viaje objectAtIndex:6] clave_confirmacion:[datos_viaje objectAtIndex:7] foto_taccsista:[datos_viaje objectAtIndex:8] nombre_taccsista:[datos_viaje objectAtIndex:9] apaterno_taccsista:[datos_viaje objectAtIndex:10] amaterno_taccsista:[datos_viaje objectAtIndex:11] telefono:[datos_viaje objectAtIndex:12] marca:[datos_viaje objectAtIndex:13] modelo:[datos_viaje objectAtIndex:14] placas:[datos_viaje objectAtIndex:15] eco:[datos_viaje objectAtIndex:16] foto_taccsi:[datos_viaje objectAtIndex:17] direccion_origen:[datos_viaje objectAtIndex:18] forma_pago:[datos_viaje objectAtIndex:19] importe:[datos_viaje objectAtIndex:20] direccion_destino:[datos_viaje objectAtIndex:21] pasajeros:[datos_viaje objectAtIndex:22]];
                            
                            PushLLego = YES;
                        }
                    }
                    if ([array_ count] == 3) {
                        if ([[array_ objectAtIndex:0] isEqualToString:@"El TACCSISTA ha cancelado el viaje."]) {
                             estatus_viaje = -1;
                            razon_cancelacion_viaje_taccsista = [array_ objectAtIndex:2];
                            [portada EscribeArchivo_id_estatus_viaje:@"-1" id_viaje:[datos_viaje objectAtIndex:1] lat_origen:[datos_viaje objectAtIndex:2] lon_origen:[datos_viaje objectAtIndex:3] lat_destino:[datos_viaje objectAtIndex:4] lon_destino:[datos_viaje objectAtIndex:5] id_taccsista:[datos_viaje objectAtIndex:6] clave_confirmacion:[datos_viaje objectAtIndex:7] foto_taccsista:[datos_viaje objectAtIndex:8] nombre_taccsista:[datos_viaje objectAtIndex:9] apaterno_taccsista:[datos_viaje objectAtIndex:10] amaterno_taccsista:[datos_viaje objectAtIndex:11] telefono:[datos_viaje objectAtIndex:12] marca:[datos_viaje objectAtIndex:13] modelo:[datos_viaje objectAtIndex:14] placas:[datos_viaje objectAtIndex:15] eco:[datos_viaje objectAtIndex:16] foto_taccsi:[datos_viaje objectAtIndex:17] direccion_origen:[datos_viaje objectAtIndex:18] forma_pago:[datos_viaje objectAtIndex:19] importe:[datos_viaje objectAtIndex:20] direccion_destino:[datos_viaje objectAtIndex:21] pasajeros:[datos_viaje objectAtIndex:22]];
                            PushLLego = YES;
                        }
                    }
                }
                    break;
                case 5:{
                    NSArray *array_ = [[[UserInfo objectForKey:@"aps"] objectForKey:@"sound"] componentsSeparatedByString:@"@"];
                    if ([array_ count]==4) {
                        if ([[array_ objectAtIndex:0] isEqualToString:@"Su viaje ha concluido. Su TACCSISTA ha enviado una solicitud de pago."]) {
                            estatus_viaje = 3;
                            [portada EscribeArchivo_id_estatus_viaje:@"5" id_viaje:[datos_viaje objectAtIndex:1] lat_origen:[datos_viaje objectAtIndex:2] lon_origen:[datos_viaje objectAtIndex:3] lat_destino:[datos_viaje objectAtIndex:4] lon_destino:[datos_viaje objectAtIndex:5] id_taccsista:[datos_viaje objectAtIndex:6] clave_confirmacion:[datos_viaje objectAtIndex:7] foto_taccsista:[datos_viaje objectAtIndex:8] nombre_taccsista:[datos_viaje objectAtIndex:9] apaterno_taccsista:[datos_viaje objectAtIndex:10] amaterno_taccsista:[datos_viaje objectAtIndex:11] telefono:[datos_viaje objectAtIndex:12] marca:[datos_viaje objectAtIndex:13] modelo:[datos_viaje objectAtIndex:14] placas:[datos_viaje objectAtIndex:15] eco:[datos_viaje objectAtIndex:16] foto_taccsi:[datos_viaje objectAtIndex:17] direccion_origen:[datos_viaje objectAtIndex:18] forma_pago:[datos_viaje objectAtIndex:19] importe:[array_ objectAtIndex:1] direccion_destino:[datos_viaje objectAtIndex:21] pasajeros:[datos_viaje objectAtIndex:22]];
                            
                            PushLLego = YES;
                        }
                    }
                }
                    break;

                    
                default:
                    break;
            }
       //     [self IRPortada];
        }
        
    }
    
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    UA_LINFO(@"Received remote notification (in appDelegate): %@", userInfo);
    if (application.applicationState != UIApplicationStateBackground) {
        [[UAPush shared] resetBadge];
    }
    
    completionHandler(UIBackgroundFetchResultNoData);
    
    [self ActualizaEstatusViaje:userInfo];
    
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())handler {
    UA_LINFO(@"Received remote notification button interaction: %@ notification: %@", identifier, userInfo);
    [[UAPush shared] appReceivedActionWithIdentifier:identifier notification:userInfo applicationState:application.applicationState completionHandler:handler];
     [self ActualizaEstatusViaje:userInfo];
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
}

- (void)registrationSucceededForChannelID:(NSString *)channelID deviceToken:(NSString *)deviceToken{
    DeviceToken = [deviceToken capitalizedString];
}

- (BOOL)isRegisteredForRemoteNotifications{
    return YES;
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    UA_LTRACE(@"Application did register with user notification types %ld", (unsigned long)notificationSettings.types);
    [[UAPush shared] appRegisteredUserNotificationSettings];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    UA_LERR(@"Application failed to register for remote notifications with error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    UA_LINFO(@"Application received remote notification: %@", userInfo);
    [[UAPush shared] appReceivedRemoteNotification:userInfo applicationState:application.applicationState];
     [self ActualizaEstatusViaje:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[UAPush shared] resetBadge];
    [[UAPush shared] setBadgeNumber:0];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UAPush shared] resetBadge];
    DeviceToken = [[[UAirship shared] deviceToken] capitalizedString];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



- (void)displayNotificationAlert:(NSString *)alertMessage{
    
}

- (void)displayLocalizedNotificationAlert:(NSDictionary *)alertDict{
    
}


- (void)handleBadgeUpdate:(NSInteger)badgeNumber{
    
}

- (void)receivedForegroundNotification:(NSDictionary *)notification{
    
}

- (void)receivedForegroundNotification:(NSDictionary *)notification fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    
}

- (void)receivedBackgroundNotification:(NSDictionary *)notification{
    
}

- (void)receivedBackgroundNotification:(NSDictionary *)notification fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    
}

- (void)launchedFromNotification:(NSDictionary *)notification{
    
}


- (void)launchedFromNotification:(NSDictionary *)notification fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    
}

- (void)launchedFromNotification:(NSDictionary *)notification actionIdentifier:(NSString *)identifier completionHandler:(void (^)())completionHandler{
    
}


- (void)receivedBackgroundNotification:(NSDictionary *)notification actionIdentifier:(NSString *)identifier completionHandler:(void (^)())completionHandler{
    
}

- (void)appReceivedRemoteNotification:(NSDictionary *)notification applicationState:(UIApplicationState)state{
    
}

- (void)appReceivedRemoteNotification:(NSDictionary *)notification applicationState:(UIApplicationState)state fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    
}

- (void)appRegisteredForRemoteNotificationsWithDeviceToken:(NSData *)token{
    
}

- (void)appReceivedActionWithIdentifier:(NSString *)identifier notification:(NSDictionary *)notification applicationState:(UIApplicationState)state completionHandler:(void (^)())completionHandler{
    
}



@end