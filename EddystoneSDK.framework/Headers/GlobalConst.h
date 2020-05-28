//
//  GlobalConst.h
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/4.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalConst : NSObject

extern NSString *const SERVICE_UUID;
extern NSString *const CHARAC_WRITE_UUID;
extern NSString *const CHARAC_NOTIFY_UUID;

extern NSString *const noti_BLE_CM_PowerOn;
extern NSString *const noti_BLE_CM_PowerOff;
extern NSString *const noti_BLE_CM_DidConnect;
extern NSString *const noti_BLE_CM_DidDiscover;
extern NSString *const noti_BLE_CM_DidFailToConnect;
extern NSString *const noti_BLE_CM_DidDisconnect;
extern NSString *const noti_BLE_PE_DidUpdateValue;

extern NSString *const noti_Discover_ES_UID;
extern NSString *const noti_Discover_ES_URL;
extern NSString *const noti_Discover_ES_Beacon;

extern NSString *const kRSSI;
extern NSString *const kAdvertisementData;
extern NSString *const kCharacteristic;
extern NSString *const kEddystone;

extern NSString *const ES_MODELTYPE;
extern NSString *const ES_NAME;
extern NSString *const ES_RSSI;
extern NSString *const ES_CONNECTABLE;
extern NSString *const ES_ID1;
extern NSString *const ES_ID2;
extern NSString *const ES_URL;


@end
