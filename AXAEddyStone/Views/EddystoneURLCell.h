//
//  EddystoneURLCell.h
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/5.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EddystoneViewModel.h"

@interface EddystoneURLCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@property (weak, nonatomic) IBOutlet UILabel *connectableLabel;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;

@property (nonatomic, strong) EddystoneViewModel *eddystoneVM;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
