//
//  ComoFunciona.h
//  TACCSI
//
//  Created by Angel Rivas on 3/6/15.
//  Copyright (c) 2015 Tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHWalkThroughView.h"

@interface ComoFunciona : UIViewController<GHWalkThroughViewDataSource>{
    UIImageView* navbar;
    UILabel*          lbl_navbar;
    UIButton*        btn_home_navbar;
    UIImageView* fondo_pantalla;
    UIImageView* img_descripcion;
    UIPageControl* pg_control;
}

-(IBAction)Atras:(id)sender;

@property (nonatomic, strong) GHWalkThroughView* ghView ;


@end
