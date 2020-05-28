//
//  EddystoneModel.m
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/4.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import "EddystoneModel.h"

@interface EddystoneModel()

@property (nonatomic, strong, readwrite) NSString *typeName;

@end

@implementation EddystoneModel

- (NSString *)typeName {
    switch (self.modelType) {
        case EddystoneModelTypeUID:
        {
            _typeName = @"Eddystone-UID";
            break;
        }
        case EddystoneModelTypeURL:
        {
            _typeName = @"Eddystone-URL";
            break;
        }
        case EddystoneModelTypeBeacon:
        {
            _typeName = @"iBeacon";
            break;
        }
        default:
            break;
    }
    return _typeName;
}

@end
