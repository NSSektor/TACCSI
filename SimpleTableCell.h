//
//  SimpleTableCell.h
//  Tracking
//
//  Created by Angel Rivas on 21/01/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel     *nombre_taccsista;
@property (nonatomic, weak) IBOutlet UILabel     *distancia_taccsista;
@property (nonatomic, weak) IBOutlet UILabel     *vehiculo_placas_taccsista;
@property (nonatomic, weak) IBOutlet UILabel     *evaluaciones_taccsista;
@property (nonatomic, weak) IBOutlet UILabel     *estrellas_taccsista;
@property (nonatomic, weak) IBOutlet UIImageView *img_taccsista;
@property (nonatomic, weak) IBOutlet UIImageView *img_estrellas;
@property (nonatomic, weak) IBOutlet UIImageView  *img_menu;
@property (nonatomic, weak) IBOutlet UILabel     *lbl_menu;
@property (nonatomic, weak) IBOutlet UILabel     *nombre_taccsista_viaje;
@property (nonatomic, weak) IBOutlet UILabel     *fecha_taccsista_viaje;
@property (nonatomic, weak) IBOutlet UILabel     *vehiculo_taccsista_viaje;
@property (nonatomic, weak) IBOutlet UILabel     *monto_taccsista_viaje;




@end
