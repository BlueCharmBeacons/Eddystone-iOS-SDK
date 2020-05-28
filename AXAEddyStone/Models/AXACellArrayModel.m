//
//  AXACellArrayModel.m
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/8.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import "AXACellArrayModel.h"


@implementation AXACellArrayModel

+ (NSArray *)getArrayWithType:(EddystoneModelType)type {
    if (type == EddystoneModelTypeUID) {
        return @[@(AXADetailTypeCellTag),
                 @(AXADetailID1CellTag),
                 @(AXADetailID2CellTag),
                 @(AXADetailPeriodCellTag),
                 @(AXADetailPowerCellTag),
                 @(AXADetailNameCellTag),
                 @(AXADetailPasswordCellTag)];
    }
    else if (type == EddystoneModelTypeURL) {
        return @[@(AXADetailTypeCellTag),
                 @(AXADetailURLCellTag),
                 @(AXADetailPeriodCellTag),
                 @(AXADetailPowerCellTag),
                 @(AXADetailNameCellTag),
                 @(AXADetailPasswordCellTag)];
    }
    else if (type == EddystoneModelTypeBeacon) {
        return @[@(AXADetailTypeCellTag),
                 @(AXADetailUUIDCellTag),
                 @(AXADetailMajorCellTag),
                 @(AXADetailMinorCellTag),
                 @(AXADetailPeriodCellTag),
                 @(AXADetailPowerCellTag),
                 @(AXADetailNameCellTag),
                 @(AXADetailPasswordCellTag)];
    } else {
        return nil;
    }
}

@end
