//
//  ComoFunciona.m
//  TACCSI
//
//  Created by Angel Rivas on 3/6/15.
//  Copyright (c) 2015 Tecnologizame. All rights reserved.
//

#import "ComoFunciona.h"



extern NSString* dispositivo;

@interface ComoFunciona ()

@end

@implementation ComoFunciona

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    fondo_pantalla = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    fondo_pantalla.image = [UIImage imageNamed:@"fondo_taccsitas_1536x2048"];
    [self.view addSubview:fondo_pantalla];
    
    navbar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    navbar.image = [UIImage imageNamed:@"home_navbar_bg"];
    //navbar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:navbar];
    
    lbl_navbar = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 20)];
    lbl_navbar.text = @"Como funciona";
    lbl_navbar.textAlignment = NSTextAlignmentCenter;
    lbl_navbar.textColor = [UIColor blackColor];
    lbl_navbar.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    [self.view addSubview:lbl_navbar];
    
    btn_home_navbar = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, 18, 30)];
    [btn_home_navbar setImage:[UIImage imageNamed:@"icono_back_100x100"] forState:UIControlStateNormal];
    [btn_home_navbar addTarget:self action:@selector(Atras:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_home_navbar];

    
    _ghView = [[GHWalkThroughView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60)];
    [_ghView setDataSource:self];
    [_ghView setWalkThroughDirection:GHWalkThroughViewDirectionHorizontal];
    self.ghView.isfixedBackground =  NO;
    [self.view addSubview:_ghView];
    
    
    img_descripcion = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_0025"]];
    
    
    if ([dispositivo isEqualToString:@"iPhone"]){
        img_descripcion.frame = CGRectMake(self.view.frame.size.width / 2 - 80, 70, 160, 284);
    }else if ([dispositivo isEqualToString:@"iPhone5"]){
        img_descripcion.frame = CGRectMake(self.view.frame.size.width / 2 - 96, 70, 192, 341);
    }else if ([dispositivo isEqualToString:@"iPhone6"]){
        img_descripcion.frame = CGRectMake(self.view.frame.size.width / 2 - 128, 70, 256, 455);
    }else if ([dispositivo isEqualToString:@"iPhone6plus"]){
        img_descripcion.frame = CGRectMake(self.view.frame.size.width / 2 - 160, 70, 320, 568);
    }else if ([dispositivo isEqualToString:@"iPad"]){
        img_descripcion.frame = CGRectMake(self.view.frame.size.width / 2 - 224, 70, 448, 796);
    }
    
    [self.view addSubview:img_descripcion];
    pg_control = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 30, self.view.frame.size.width, 20)];
    
    //Set defersCurrentPageDisplay to YES to prevent page control jerking when switching pages with page control. This prevents page control from instant change of page indication.
    
    pg_control.currentPageIndicatorTintColor = [UIColor whiteColor];
    pg_control.pageIndicatorTintColor = [UIColor grayColor];
    pg_control.numberOfPages = 6;
    [self.view addSubview:pg_control];
    

}

#pragma mark - GHDataSource

-(NSInteger) numberOfPages
{
    return 6;
}

- (void) configurePage:(GHWalkThroughPageCell *)cell atIndex:(NSInteger)index
{
    pg_control.currentPage = index;
    
    if (index == 0)
        img_descripcion.image = [UIImage imageNamed:@"IMG_0025"];
    else if (index == 1)
        img_descripcion.image = [UIImage imageNamed:@"IMG_0027"];
    else if (index == 2)
        img_descripcion.image = [UIImage imageNamed:@"IMG_0076"];
    else if (index == 3)
        img_descripcion.image = [UIImage imageNamed:@"IMG_0079"];
    else if (index == 4)
        img_descripcion.image = [UIImage imageNamed:@"IMG_0080"];
    else if (index == 5)
        img_descripcion.image = [UIImage imageNamed:@"IMG_0081"];
    
    cell.title = [NSString stringWithFormat:@"Titulo %ld", index+1];
    cell.titleImage = [UIImage imageNamed:[NSString stringWithFormat:@"Titulo %ld", index+1]];
    cell.desc = [NSString stringWithFormat:@"Descripción %ld", index+1];
}

- (UIImage*) bgImageforPage:(NSInteger)index
{
    NSString* imageName =[NSString stringWithFormat:@"bg_0%ld.jpg", index+1];
    UIImage* image = [UIImage imageNamed:imageName];
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)Atras:(id)sender{
     [self dismissViewControllerAnimated:YES completion:nil];
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
