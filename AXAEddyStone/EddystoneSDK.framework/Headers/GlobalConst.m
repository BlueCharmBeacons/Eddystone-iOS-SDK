//
//  GlobalConst.m
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/4.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import "GlobalConst.h"

@implementation GlobalConst

NSString *const SERVICE_UUID               = @"0xFFF0";
NSString *const CHARAC_WRITE_UUID          = @"0xFFF1";
NSString *const CHARAC_NOTIFY_UUID         = @"0xFFF2";

NSString *const noti_BLE_CM_PowerOn        = @"noti_BLE_PowerOn";
NSString *const noti_BLE_CM_PowerOff       = @"noti_BLE_PowerOff";
NSString *const noti_BLE_CM_DidConnect     = @"noti_BLE_CM_DidConnect";
NSString *const noti_BLE_CM_DidDiscover    = @"noti_BLE_CM_DidDiscover";
NSString *const noti_BLE_CM_DidFailToConnect = @"noti_BLE_CM_DidFailToConnect";
NSString *const noti_BLE_CM_DidDisconnect  = @"noti_BLE_CM_DidDisconnect";
NSString *const noti_BLE_PE_DidUpdateValue = @"noti_BLE_PE_DidUpdateValue";

NSString *const noti_Discover_ES_UID       = @"noti_Discover_ES_UID";
NSString *const noti_Discover_ES_URL       = @"noti_Discover_ES_URL";
NSString *const noti_Discover_ES_Beacon    = @"noti_Discover_ES_Beacon";

NSString *const kRSSI                      = @"kRSSI";
NSString *const kAdvertisementData         = @"kAdvertisementData";
NSString *const kCharacteristic            = @"kCharacteristic";
NSString *const kEddystone                 = @"kEddystone";

NSString *const ES_MODELTYPE               = @"ES_MODELTYPE";
NSString *const ES_NAME                    = @"ES_NAME";
NSString *const ES_RSSI                    = @"ES_RSSI";
NSString *const ES_CONNECTABLE             = @"ES_CONNECTABLE";
NSString *const ES_ID1                     = @"ES_ID1";
NSString *const ES_ID2                     = @"ES_ID2";
NSString *const ES_URL                     = @"ES_URL";

@end
