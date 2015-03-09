//
//  AppDelegate.h
//  TACCSI
//
//  Created by Angel Rivas on 2/12/15.
//  Copyright (c) 2015 Tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "MTReachabilityManager.h"
#import <AirshipKit/AirshipKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UAPushNotificationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)ActualizaEstatusViaje:(NSDictionary*)UserInfo;

-(void)IRPortada;


@end

