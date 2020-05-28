//
//  EddystoneURLCell.m
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/5.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import "EddystoneURLCell.h"

@implementation EddystoneURLCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"EddystoneURLCell";
    EddystoneURLCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EddystoneURLCell" owner:nil options:nil] lastObject];
    } else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    return cell;
}

- (void)setEddystoneVM:(EddystoneViewModel *)eddystoneVM {
    _eddystoneVM = eddystoneVM;
    self.deviceNameLabel.text = [NSString stringWithFormat:@"deviceName: %@ (%@)", eddystoneVM.nameText, eddystoneVM.typeNameText];
    self.rssiLabel.text = [NSString stringWithFormat:@"rssi: %@", eddystoneVM.rssiText];
    self.connectableLabel.text = [NSString stringWithFormat:@"connectable: %@", eddystoneVM.connectableText];
    self.urlLabel.text = [NSString stringWithFormat:@"url: %@", eddystoneVM.urlText];
    self.urlLabel.adjustsFontSizeToFitWidth = YES;
}

@end
