//
//  DetailCell.m
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/5.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import "DetailCell.h"

@implementation DetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"DetailCell";
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailCell" owner:nil options:nil] lastObject];
    } else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    return cell;
}

- (void)setEddystoneVM:(EddystoneViewModel *)eddystoneVM {
    _eddystoneVM = eddystoneVM;
    if (self.tag == AXADetailTypeCellTag) {
        self.label.text = @"Broadcasting:";
        self.label.adjustsFontSizeToFitWidth = YES;
        self.textField.text = eddystoneVM.typeNameText;
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.userInteractionEnabled = NO;
    }
    if (self.tag == AXADetailID1CellTag) {
        self.label.text = @"id1:";
        self.textField.text = eddystoneVM.id1Text;
    }
    else if (self.tag == AXADetailID2CellTag) {
        self.label.text = @"id2:";
        self.textField.text = eddystoneVM.id2Text;
    }
    else if (self.tag == AXADetailPeriodCellTag) {
        self.label.text = @"Period:";
        self.textField.text = eddystoneVM.periodText;
    }
    else if (self.tag == AXADetailPowerCellTag) {
        self.label.text = @"Power:";
        self.textField.text = eddystoneVM.powerText;
    }
    else if (self.tag == AXADetailNameCellTag) {
        self.label.text = @"Name:";
        self.textField.text = eddystoneVM.nameText;
    }
    else if (self.tag == AXADetailPasswordCellTag) {
        self.label.text = @"Password:";
        self.textField.text = eddystoneVM.passwordText;
    }
    else if (self.tag == AXADetailURLCellTag) {
        self.label.text = @"URL:";
        self.textField.text = eddystoneVM.urlText;
    }
    else if (self.tag == AXADetailMinorCellTag) {
        self.label.text = @"Minor:";
        self.textField.text = eddystoneVM.minorText;
    }
    else if (self.tag == AXADetailMajorCellTag) {
        self.label.text = @"Major:";
        self.textField.text = eddystoneVM.majorText;
    }
    else if (self.tag == AXADetailUUIDCellTag) {
        self.label.text = @"UUID";
        self.textField.text = eddystoneVM.uuidText;
    }

}
@end
