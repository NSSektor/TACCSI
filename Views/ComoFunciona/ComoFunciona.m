//
//  ComoFunciona.m
//  TACCSI
//
//  Created by Angel Rivas on 3/6/15.
//  Copyright (c) 2015 Tecnologizame. All rights reserved.
//

#import "ComoFunciona.h"

@interface ComoFunciona ()

@end

@implementation ComoFunciona

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    navbar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    navbar.image = [UIImage imageNamed:@"home_navbar_bg"];
    //navbar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:navbar];
    
    lbl_navbar = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 20)];
    lbl_navbar.text = @"Mis viajes";
    lbl_navbar.textAlignment = NSTextAlignmentCenter;
    lbl_navbar.textColor = [UIColor blackColor];
    lbl_navbar.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    [self.view addSubview:lbl_navbar];
    
    btn_home_navbar = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, 18, 30)];
    [btn_home_navbar setImage:[UIImage imageNamed:@"icono_back_100x100"] forState:UIControlStateNormal];
    [btn_home_navbar addTarget:self action:@selector(Atras:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_home_navbar];
    
    
    contenedor_ayuda = [[UIView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height -60)];
    [self.view addSubview:contenedor_ayuda];
    
    
    //STEP 1 Construct Panels
    MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"IMG_0025"] title:@"Solicitar Taccsi" description:@""];
    
    //You may also add in a title for each panel
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"IMG_0027"] title:@"Ingresar datos"  description:@""];
    
    //STEP 2 Create IntroductionView
    /*A standard version*/
    //MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerImage:[UIImage imageNamed:@"SampleHeaderImage.png"] panels:@[panel, panel2]];
    
    /*A version with no header (ala "Path")*/
    // MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) panels:@[panel, panel2]];
    
    /*A more customized version*/
    MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerText:@"TACCSI" panels:@[panel, panel2] languageDirection:MYLanguageDirectionLeftToRight];
    [introductionView setBackgroundImage:[UIImage imageNamed:@"fondo_taccsitas_1536x2048"]];
    
    /*
     MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) headerText:@"MYIntroductionView" panels:@[panel, panel2] languageDirection:MYLanguageDirectionLeftToRight];
     
     [introductionView setBackgroundColor:[UIColor colorWithRed:37.0/255 green:104.0/255 blue:154.0/255 alpha:1.0]];  */
    
    [introductionView.BackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [introductionView.HeaderImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [introductionView.HeaderLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [introductionView.HeaderView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [introductionView.PageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [introductionView.SkipButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    
    
    
    //Set delegate to self for callbacks (optional)
    introductionView.delegate = self;
    
    //STEP 3: Show introduction view
    [introductionView showInView:contenedor_ayuda animateDuration:0.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)Atras:(id)sender{
     [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Sample Delegate Methods

-(void)introductionDidFinishWithType:(MYFinishType)finishType{
    if (finishType == MYFinishTypeSkipButton) {
        NSLog(@"Did Finish Introduction By Skipping It");
    }
    else if (finishType == MYFinishTypeSwipeOut){
        NSLog(@"Did Finish Introduction By Swiping Out");
    }
    
  //
}

@end
