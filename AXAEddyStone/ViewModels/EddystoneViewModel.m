//
//  EddystoneViewModel.m
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/5.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import "EddystoneViewModel.h"

@implementation EddystoneViewModel

- (instancetype)initWithEddystoneModel:(EddystoneModel *)eddystone {
    self = [super init];
    if (!self) {
        return  nil;
    }

    _eddystone = eddystone;
    if (eddystone.name) {
        _nameText = eddystone.name;
    }
    if (eddystone.rssi) {
        _rssiText = [NSString stringWithFormat:@"%@", eddystone.rssi];
    }
    _connectableText = [eddystone.connectable  isEqual: @1] ? @"YES" : @"NO";
    if (eddystone.id1) {
        _id1Text = eddystone.id1;
    }
    if (eddystone.id2) {
        _id2Text = eddystone.id2;
    }
    if (eddystone.url) {
        _urlText = eddystone.url;
    }
    if (eddystone.typeName) {
        _typeNameText = eddystone.typeName;
    }
    if (eddystone.period) {
        _periodText = eddystone.period;
    }
    if (eddystone.power) {
        _powerText = eddystone.power;
    }
    if (eddystone.uuid) {
        _uuidText = eddystone.uuid;
    }
    if (eddystone.major) {
        _majorText = eddystone.major;
    }
    if (eddystone.minor) {
        _minorText = eddystone.minor;
    }
    _identifier = eddystone.peripheral.identifier.UUIDString;
    if (eddystone.password) {
        _passwordText = eddystone.password;
    }

    return self;
}

- (void)setEddystone:(EddystoneModel *)eddystone {
    _eddystone = eddystone;
    if (eddystone.name) {
        _nameText = eddystone.name;
    }
    if (eddystone.rssi) {
        _rssiText = [NSString stringWithFormat:@"%@", eddystone.rssi];
    }
    _connectableText = [eddystone.connectable  isEqual: @1] ? @"YES" : @"NO";
    if (eddystone.id1) {
        _id1Text = eddystone.id1;
    }
    if (eddystone.id2) {
        _id2Text = eddystone.id2;
    }
    if (eddystone.url) {
        _urlText = eddystone.url;
    }
    if (eddystone.typeName) {
        _typeNameText = eddystone.typeName;
    }
    if (eddystone.period) {
        _periodText = eddystone.period;
    }
    if (eddystone.power) {
        _powerText = eddystone.power;
    }
    if (eddystone.uuid) {
        _uuidText = eddystone.uuid;
    }
    if (eddystone.major) {
        _majorText = eddystone.major;
    }
    if (eddystone.minor) {
        _minorText = eddystone.minor;
    }
    _identifier = eddystone.peripheral.identifier.UUIDString;
    if (eddystone.password) {
        _passwordText = eddystone.password;
    }
}

@end
