//
//  PowerCell.h
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/17.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EddystoneViewModel.h"

@class PowerCell;

@protocol PowerCellDelegate <NSObject>

@optional
- (void)powerCell:(PowerCell *)cell selectedSegmentIndex:(NSInteger)index;

@end

@interface PowerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UITextField *textyField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (nonatomic, weak) id<PowerCellDelegate> delegate;

@property (nonatomic, strong) EddystoneViewModel *eddystoneVM;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
