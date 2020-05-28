//
//  AXADataManager.h
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/4.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "EddystoneModel.h"
#import "GlobalConst.h"

typedef void (^SendPasswordSuccessBlock) (CBPeripheral *peripheral);
typedef void(^SendPasswordFailureBlock) (CBPeripheral *peripheral);
@interface AXADataManager : NSObject

+ (instancetype)sharedManager;

/*
 *  Starts scanning for peripherals that are advertising any of the services listed in <i>serviceUUIDs</i>. Although strongly discouraged
 */
- (void)startFindBleDevicesWithServices:(NSArray<CBUUID *> *)serviceUUIDs WithAllowDuplicatesKey:(BOOL)duplicate;

/**
 *  Stops scanning for peripherals.
 */
- (void)stopFindBleDevices;

/**
 *  connect to the eddystone
 *
 *  @param eddystone eddystone
 */
- (void)connectBleDevices:(EddystoneModel *)eddystone;

/**
 *  disconnect to the eddystone
 *
 *  @param eddystone eddystone
 */
- (void)disconnectBleDevices:(EddystoneModel *)eddystone;

/**
 *  set notify
 *
 */
- (void)setNotificationForPeripheral:(CBPeripheral *)peripheral serviceUUIDString:(NSString *)sUUID characteristicUUIDString:(NSString *)cUUID enable:(BOOL)enable;

/**
 *  send the uuid command to the peripheral for modify the uuid, the service of the peripheral is serviceUUIDString which define in the GlobalConst.h, the characteristic of the service is writeUUIDString which define in the GlobalConst.h
 *
 *  @param hex uuid
 */
- (void)sendHexString:(NSString *)hex;

/**
 *  send the url command to the peripheral for modify the url;
 *
 *  @param url url
 */
- (void)sendUrl:(NSString *)url;

/**
 *  send the period and power to the peripheral(the EddystoneModelType is EddystoneModelTypeUID or EddystoneModelTypeURL ) for modify the period and power
 *
 *  @param period period
 *  @param power  power
 */
- (void)sendPeriod:(NSString *)period Power:(NSString *)power;

/**
 *  send the period, power, major, minor to the peripheral(the EddystoneModelType is EddystoneModelTypeBeacon) for modify them.
 *
 *  @param period period
 *  @param power  power
 *  @param major  major
 *  @param minor  minor
 */
- (void)sendPeriod:(NSString *)period Power:(NSString *)power Major:(NSString *)major Minor:(NSString *)minor;

/**
 *  send the command to turn off the peripheral
 */
- (void)sendTurnOffDevice;

/**
 *  send the password to peripheral , before modify others , you should send password first to get the root
 *
 *  @param password password
 */
- (void)sendPassword:(NSString *)password;

/**
 *  send the name to peripheral for modify the peripheral name
 *
 *  @param name name
 */
- (void)sendName:(NSString *)name;

/**
 *  send this command to the peripheral for confirm password
 *
 *  @param password password
 */
- (void)sendOldConfirmPassword:(NSString *)password;

/**
 *  send password block
 */
- (void)sendPassword:(NSString *)password success:(SendPasswordSuccessBlock)successBlock failure:(SendPasswordFailureBlock)failureBlock;

@end
