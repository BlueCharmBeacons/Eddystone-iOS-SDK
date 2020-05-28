//
//  EddystoneModel.h
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/4.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSInteger, EddystoneModelType) {
    EddystoneModelTypeUID,
    EddystoneModelTypeURL,
    EddystoneModelTypeBeacon
};


@interface EddystoneModel : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSNumber *rssi;

@property (nonatomic, strong) NSNumber *connectable;

@property (nonatomic, strong) NSString *period;

@property (nonatomic, strong) NSString *power;

@property (nonatomic, strong) NSString *password;

@property (nonatomic, assign) EddystoneModelType modelType;

@property (nonatomic, strong, readonly) NSString *typeName;

@property (nonatomic, strong) CBPeripheral *peripheral;


@property (nonatomic, strong) NSString *id1;

@property (nonatomic, strong) NSString *id2;


@property (nonatomic, strong) NSString *url;


@property (nonatomic, strong) NSString *uuid;

@property (nonatomic, strong) NSString *major;

@property (nonatomic, strong) NSString *minor;

@end
