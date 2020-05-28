//
//  EddystoneUIDCell.m
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/5.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import "EddystoneUIDCell.h"

@implementation EddystoneUIDCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"EddystoneUIDCell";
    EddystoneUIDCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EddystoneUIDCell" owner:nil options:nil] lastObject];
    } else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    return cell;
}

- (void)setEddystoneVM:(EddystoneViewModel *)eddystoneVM {
    _eddystoneVM = eddystoneVM;
    self.deviceNameLabel.text = [NSString stringWithFormat:@"deviceName:%@ (%@)", eddystoneVM.nameText, eddystoneVM.typeNameText];
    self.rssiLabel.text = [NSString stringWithFormat:@"rssi:%@", eddystoneVM.rssiText];
    self.connectableLabel.text = [NSString stringWithFormat:@"connectable:%@", eddystoneVM.connectableText];
    self.id1Label.text = [NSString stringWithFormat:@"id1:%@", eddystoneVM.id1Text];
    self.id2Label.text = [NSString stringWithFormat:@"id2:%@",eddystoneVM.id2Text];
    self.id1Label.adjustsFontSizeToFitWidth = YES;
    self.id2Label.adjustsFontSizeToFitWidth = YES;
}

@end
