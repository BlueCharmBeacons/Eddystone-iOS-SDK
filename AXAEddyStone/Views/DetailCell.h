//
//  DetailCell.h
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/5.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EddystoneViewModel.h"

@interface DetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) EddystoneViewModel *eddystoneVM;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
