//
//  ModifyCell.h
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/5.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModifyCell;

@protocol ModifyCellDelegate <NSObject>

@optional
- (void)modifyCell:(ModifyCell *)cell clickModifyBtn:(UIButton *)button;

@end

@interface ModifyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
@property (nonatomic, weak) id<ModifyCellDelegate> delegate;

- (IBAction)clickModifyBtn:(id)sender;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
