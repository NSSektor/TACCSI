//
//  ComoFunciona.h
//  TACCSI
//
//  Created by Angel Rivas on 3/6/15.
//  Copyright (c) 2015 Tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYIntroductionView.h"

@interface ComoFunciona : UIViewController<MYIntroductionDelegate>{
    UIImageView* navbar;
    UILabel*          lbl_navbar;
    UIButton*        btn_home_navbar;
    UIView*           contenedor_ayuda;
}

-(IBAction)Atras:(id)sender;

@end
