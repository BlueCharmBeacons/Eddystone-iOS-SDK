//
//  PowerCell.m
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/17.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import "PowerCell.h"

@implementation PowerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"PowerCell";
    PowerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PowerCell" owner:nil options:nil] lastObject];
    } else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    return cell;
}

- (void)setEddystoneVM:(EddystoneViewModel *)eddystoneVM {
    _eddystoneVM = eddystoneVM;
    if (eddystoneVM.powerText) {
        self.label.text = @"Power:";
        self.textyField.text = eddystoneVM.powerText;
        self.segmentControl.selectedSegmentIndex = [eddystoneVM.powerText integerValue];
    }
}
- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    NSLog(@"segmentValueChanged:%ld", sender.selectedSegmentIndex);
    if ([self.delegate respondsToSelector:@selector(powerCell:selectedSegmentIndex:)]) {
        [self.delegate powerCell:self selectedSegmentIndex:sender.selectedSegmentIndex];
    }
}

@end
