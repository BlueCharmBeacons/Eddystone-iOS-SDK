//
//  AXADataManager.m
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/4.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import "AXADataManager.h"

@interface AXADataManager()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;

@property (nonatomic, strong) EddystoneModel *eddystone;

@property (nonatomic, strong) NSArray *urlArray;

@property (nonatomic, copy) SendPasswordSuccessBlock sendPasswordSuccessBlock;
@property (nonatomic, copy) SendPasswordFailureBlock sendPasswordFailureBlock;

@end

@implementation AXADataManager

+ (instancetype)sharedManager {
    static AXADataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return  nil;
    }
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:nil];
    self.urlArray = @[@".com/", @".org/", @".edu/", @".net/", @".info/", @".biz/", @".gov/", @".com", @".org", @".edu", @".net", @".info", @".biz", @".gov"];

    return self;
}



- (void)startFindBleDevicesWithServices:(NSArray<CBUUID *> *)serviceUUIDs WithAllowDuplicatesKey:(BOOL)duplicate {
    if (self.centralManager.state == CBCentralManagerStatePoweredOn) {
        [self.centralManager scanForPeripheralsWithServices:serviceUUIDs options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @(duplicate)}];
    }
}

- (void)stopFindBleDevices {
    [self.centralManager stopScan];
}

- (void)connectBleDevices:(EddystoneModel *)eddystone {
    self.eddystone = eddystone;
    [self.centralManager connectPeripheral:eddystone.peripheral options:nil];
}

- (void)disconnectBleDevices:(EddystoneModel *)eddystone {
    [self.centralManager cancelPeripheralConnection:eddystone.peripheral];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {

    if (central.state == CBCentralManagerStatePoweredOn) {
        // 发送蓝牙开启的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:noti_BLE_CM_PowerOn object:central];
    } else {
        // 发送蓝牙关闭的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:noti_BLE_CM_PowerOff object:central];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if ([RSSI intValue] == 127) {
        return;
    }
    NSString *name = advertisementData[CBAdvertisementDataLocalNameKey];
    if (!name) {
        return;
    }
    NSNumber *connectable = advertisementData[CBAdvertisementDataIsConnectable];
    NSDictionary *serviceData = advertisementData[CBAdvertisementDataServiceDataKey];
    NSData *data = serviceData[[CBUUID UUIDWithString:@"FEAA"]];
//    NSLog(@"peripheral:%@ --- advertisementData:%@", peripheral,advertisementData);
    if (data.length == 0) {
        // beacon
        NSDictionary *userInfo = @{ES_MODELTYPE : @2, ES_NAME : name, ES_RSSI : RSSI, ES_CONNECTABLE : connectable};
        [[NSNotificationCenter defaultCenter] postNotificationName:noti_Discover_ES_Beacon object:peripheral userInfo:userInfo];
    }
    if (data == nil) {
        return;
    }
    const unsigned char *cData = [data bytes];
    if (*cData == 0x00) {
        // UID
        Byte byte[20];
        [data getBytes:byte length:20];
        NSString *id1 = [NSString stringWithFormat:@"%02x", byte[2]];
        for (int i = 3; i < 12; i++) {
            id1 = [id1 stringByAppendingString:[NSString stringWithFormat:@"%02x", byte[i]]];;
        }
        NSString *id2 = [NSString stringWithFormat:@"%02x", byte[12]];
        for (int j = 13; j < 18; j++) {
            id2 = [id2 stringByAppendingString:[NSString stringWithFormat:@"%02x", byte[j]]];
        }
        NSDictionary *userInfo = @{ES_MODELTYPE : @0, ES_NAME : name, ES_RSSI : RSSI, ES_CONNECTABLE : connectable, ES_ID1 : id1, ES_ID2 : id2};
        [[NSNotificationCenter defaultCenter] postNotificationName:noti_Discover_ES_UID object:peripheral userInfo:userInfo];

    }
    else if (*cData == 0x10) {
        // URL
        Byte byte[20];
        [data getBytes:byte length:20];
        NSString *urlScheme = [self getUrlscheme:byte[2]];
        NSString *url = urlScheme;
        for (int i = 3; i < data.length; i++) {
            url = [url stringByAppendingString:[self getEncodedString:byte[i]]];
        }
        NSDictionary *userInfo = @{ES_MODELTYPE : @1, ES_NAME : name, ES_RSSI : RSSI, ES_CONNECTABLE : connectable, ES_URL : url};
        [[NSNotificationCenter defaultCenter] postNotificationName:noti_Discover_ES_URL object:peripheral userInfo:userInfo];
    }
    else {
        // beacon
    }


    NSDictionary *userInfo = @{kAdvertisementData : advertisementData, kRSSI : RSSI};

    [[NSNotificationCenter defaultCenter] postNotificationName:noti_BLE_CM_DidDiscover object:peripheral userInfo:userInfo];
    // 把数据通知出去
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {

    [[NSNotificationCenter defaultCenter] postNotificationName:noti_BLE_CM_DidConnect object:peripheral];
    self.eddystone.peripheral.delegate = self;
    [self.eddystone.peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:noti_BLE_CM_DidFailToConnect object:peripheral];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {

    [[NSNotificationCenter defaultCenter] postNotificationName:noti_BLE_CM_DidDisconnect object:peripheral];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {

    for (CBService *service in peripheral.services) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:SERVICE_UUID]]) {
            [self.eddystone.peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {

    [self setNotificationForPeripheral:peripheral serviceUUIDString:SERVICE_UUID characteristicUUIDString:CHARAC_NOTIFY_UUID enable:YES];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {

//    NSLog(@"receiveData:%@", characteristic.value);
    Byte byte[20];
    [characteristic.value getBytes:byte length:characteristic.value.length];
    if (byte[0] == 0x11) {
        if (self.eddystone.modelType == EddystoneModelTypeUID) {
            NSString *id1 = [NSString stringWithFormat:@"%02x", byte[1]];
            for (int i = 2; i < 11; i++) {
                id1 = [id1 stringByAppendingString:[NSString stringWithFormat:@"%02x", byte[i]]];
            }
            self.eddystone.id1 = id1;
            NSString *id2 = [NSString stringWithFormat:@"%02x", byte[11]];
            for (int i = 12; i < 17; i++) {
                id2 = [id2 stringByAppendingString:[NSString stringWithFormat:@"%02x", byte[i]]];
            }
            self.eddystone.id2 = id2;
        }
        else if (self.eddystone.modelType == EddystoneModelTypeURL) {
            NSString *url = [self getUrlscheme:byte[2]];
            for (int i = 0; i < byte[1] - 1; i++) {
                url = [url stringByAppendingString:[self getEncodedString:byte[i + 3]]];
            }
            self.eddystone.url = url;
        }
        else if (self.eddystone.modelType == EddystoneModelTypeBeacon) {
            NSString *uuid = [NSString stringWithFormat:@"%02x", byte[1]];
            for (int i = 2; i < 17; i++) {
                uuid = [uuid stringByAppendingString:[NSString stringWithFormat:@"%02x", byte[i]]];
            }
            self.eddystone.uuid = uuid;
        }
    }
    else if (byte[0] == 0x12) {
        if (self.eddystone.modelType == EddystoneModelTypeUID) {
            self.eddystone.period = [NSString stringWithFormat:@"%d", byte[1] * 256 + byte[2]];
            self.eddystone.power = [NSString stringWithFormat:@"%d", byte[3]];
        }
        else if (self.eddystone.modelType == EddystoneModelTypeURL) {
            self.eddystone.period = [NSString stringWithFormat:@"%d", byte[1] * 256 + byte[2]];
            self.eddystone.power = [NSString stringWithFormat:@"%d", byte[3]];
        }
        else if (self.eddystone.modelType == EddystoneModelTypeBeacon) {
            self.eddystone.major = [NSString stringWithFormat:@"%d", byte[1] * 256 + byte[2]];
            self.eddystone.minor = [NSString stringWithFormat:@"%d", byte[3] * 256 + byte[4]];
            self.eddystone.period = [NSString stringWithFormat:@"%d", byte[5] * 256 + byte[6]];
            self.eddystone.power = [NSString stringWithFormat:@"%d", byte[7]];
        }
    }
    else if (byte[0] == 0x05) { // 密码正确
        if (self.sendPasswordSuccessBlock) {
            self.sendPasswordSuccessBlock(peripheral);
        }
        return;
    }
    else if (byte[0] == 0x06) { // 密码错误
        if (self.sendPasswordFailureBlock) {
            self.sendPasswordFailureBlock(peripheral);
        }
        return;
    }
    else if (byte[0] == 0x07) {
        return;
    }
    NSDictionary *userInfo = @{kCharacteristic : characteristic, kEddystone : self.eddystone};
    [[NSNotificationCenter defaultCenter] postNotificationName:noti_BLE_PE_DidUpdateValue object:peripheral userInfo:userInfo];
}

// 发送命令
- (void)sendCommand:(NSData *)data toPeripheral:(CBPeripheral *)peripheral {
    [self writeData:data toPeripheral:peripheral serviceUUIDString:SERVICE_UUID characteristicUUIDString:CHARAC_WRITE_UUID];
}

// 写入数据
- (void)writeData:(NSData *)data toPeripheral:(CBPeripheral *)peripheral serviceUUIDString:(NSString *)sUUID characteristicUUIDString:(NSString *)cUUID {
    for (CBService *service in peripheral.services) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:sUUID]]) {
            for (CBCharacteristic *characteristic in service.characteristics) {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:cUUID]]) {
                    if (characteristic.properties | CBCharacteristicPropertyWrite) {
                        [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                    }
                }
            }
        }
    }
}

#pragma mark - public method
// 注册通知
- (void)setNotificationForPeripheral:(CBPeripheral *)peripheral serviceUUIDString:(NSString *)sUUID characteristicUUIDString:(NSString *)cUUID enable:(BOOL)enable {
    for (CBService *service in peripheral.services) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:sUUID]]) {
            for (CBCharacteristic *characteristic in service.characteristics) {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:cUUID]]) {
                    if (characteristic.properties | CBCharacteristicPropertyNotify) {
                        [peripheral setNotifyValue:enable forCharacteristic:characteristic];
                    }
                }
            }
        }
    }
}

- (void)sendHexString:(NSString *)hex {
    Byte byte[17];

    byte[0] = 0x01;
    for (int ix = 0; ix < 16; ix++) {
        NSRange range = NSMakeRange(2*ix, 2);
        NSString *subStr = [hex substringWithRange:range];
        NSScanner *scanner = [NSScanner scannerWithString:subStr];
        unsigned int hex;
        [scanner scanHexInt:&hex];
        byte[ix + 1] = hex;
    }

    NSData *data = [[NSData alloc] initWithBytes:byte length:20];
    [self sendCommand:data toPeripheral:self.eddystone.peripheral];
}

- (Byte)getUrlschemeByte:(NSString *)url {
    if ([url hasPrefix:@"http://www."]) {
        return 0x00;
    }
    else if ([url hasPrefix:@"https://www."]) {
        return 0x01;
    }
    else if ([url hasPrefix:@"http://"]) {
        return 0x02;
    }
    else if ([url hasPrefix:@"https://"]) {
        return 0x03;
    }
    return 0;
}

- (void)sendUrl:(NSString *)url {
    Byte byte[40];
    byte[0] = 0x01;
    byte[2] = [self getUrlschemeByte:url];
    url = [url stringByReplacingOccurrencesOfString:[self getUrlscheme:[self getUrlschemeByte:url]] withString:@""];

    NSString *temp;
    NSRange tempRange;
    BOOL hasTempRange = NO;
    for (NSString *str in _urlArray) {
        NSRange range = [url rangeOfString:str];
        if (range.location != NSNotFound) {
            byte[range.location + 3] = [_urlArray indexOfObject:str];
            temp = str;
            tempRange = range;
            hasTempRange = YES;
            break;
        }
    }
    NSString *tempUrl;
    if (temp) {
        tempUrl = [url stringByReplacingOccurrencesOfString:temp withString:@""];
        byte[1] = tempUrl.length + 2;
    }
    else {
        tempUrl = url;
        byte[1] = tempUrl.length + 1;
        //        NSLog(@"byte[1] = %hhu", byte[1]);
    }

    //    byte[1] = tempUrl.length + 2;
    const char *ch = [tempUrl cStringUsingEncoding:NSASCIIStringEncoding];

    if (hasTempRange) {
        for (int i = 0; i < tempRange.location; i++) {
            byte[i + 3] = ch[i];
        }
        for (int j = 0; j < tempUrl.length - tempRange.location; j++) {
            byte[tempRange.location + j + 4] = ch[tempRange.location + j];
        }
        NSData *data = [[NSData alloc] initWithBytes:byte length:tempUrl.length + 4];
        //        NSLog(@"data -- %@", data);
        [self sendCommand:data toPeripheral:self.eddystone.peripheral];
    } else {
        for (int i = 0; i < tempUrl.length; i++) {
            byte[i + 3] = ch[i];
            //            NSLog(@"byte[%d] = %hhu", i + 3, byte[i + 3]);
        }
        NSData *data = [[NSData alloc] initWithBytes:byte length:tempUrl.length + 3];
        //        NSLog(@"data -- %@", data);
        [self sendCommand:data toPeripheral:self.eddystone.peripheral];
    }
}

- (NSString *)getUrlscheme:(char)hexChar
{
    switch (hexChar) {
        case 0x00:
            return @"http://www.";
        case 0x01:
            return @"https://www.";
        case 0x02:
            return @"http://";
        case 0x03:
            return @"https://";
        default:
            return nil;
    }
}

- (NSString *)getEncodedString:(char)hexChar
{
    switch (hexChar) {

        case 0x00:
            return @".com/";
        case 0x01:
            return @".org/";
        case 0x02:
            return @".edu/";
        case 0x03:
            return @".net/";
        case 0x04:
            return @".info/";
        case 0x05:
            return @".biz/";
        case 0x06:
            return @".gov/";
        case 0x07:
            return @".com";
        case 0x08:
            return @".org";
        case 0x09:
            return @".edu";
        case 0x0a:
            return @".net";
        case 0x0b:
            return @".info";
        case 0x0c:
            return @".biz";
        case 0x0d:
            return @".gov";
        default:
            return [NSString stringWithFormat:@"%c", hexChar];
    }
}

- (void)sendPeriod:(NSString *)period Power:(NSString *)power {
    Byte byte[4];
    byte[0] = 0x2;
    byte[1] = [period intValue]/256;
    byte[2] = [period intValue]%256;
    byte[3] = [power intValue];
    NSData *data = [[NSData alloc] initWithBytes:byte length:4];
    [self sendCommand:data toPeripheral:self.eddystone.peripheral];
}

- (void)sendPeriod:(NSString *)period Power:(NSString *)power Major:(NSString *)major Minor:(NSString *)minor {
    Byte byte[8];
    byte[0] = 0x2;
    byte[1] = [major intValue]/256;
    byte[2] = [major intValue]%256;
    byte[3] = [minor intValue]/256;
    byte[4] = [minor intValue]%256;
    byte[5] = [period intValue]/256;
    byte[6] = [period intValue]%256;
    byte[7] = [power intValue];
    NSData *data = [[NSData alloc] initWithBytes:byte length:8];
    //    NSLog(@"%@", data);
    [self sendCommand:data toPeripheral:self.eddystone.peripheral];
}

- (void)sendTurnOffDevice {
    Byte byte[1];
    byte[0] = 0x03;
    NSData *data = [[NSData alloc] initWithBytes:byte length:1];
    [self sendCommand:data toPeripheral:self.eddystone.peripheral];
}


- (void)sendPassword:(NSString *)password {
    Byte byte[7];
    byte[0] = 0x04;
    const char *a = [password UTF8String];
    for (int i = 0; i < 6; i++) {
        byte[i+1] = a[i];
    }

    NSData *data = [[NSData alloc] initWithBytes:byte length:7];
    [self sendCommand:data toPeripheral:self.eddystone.peripheral];
}

- (void)sendName:(NSString *)name {
    Byte byte[20];
    byte[0] = 0x08;
    byte[1] = name.length;
    const char *a = [name UTF8String];
    for (int i = 0; i < name.length; i++) {
        byte[i+2] = a[i];
    }

    NSData *data = [[NSData alloc] initWithBytes:byte length:name.length + 2];
    [self sendCommand:data toPeripheral:self.eddystone.peripheral];
}

- (void)sendOldConfirmPassword:(NSString *)password {
    Byte byte[13];
    byte[0] = 0x09;
    const char *a = [password UTF8String];
    for (int i = 0; i < 12; i++) {
        byte[i+1] = a[i];
    }

    NSData *data = [[NSData alloc] initWithBytes:byte length:13];
    [self sendCommand:data toPeripheral:self.eddystone.peripheral];
}

- (void)sendPassword:(NSString *)password success:(SendPasswordSuccessBlock)successBlock failure:(SendPasswordFailureBlock)failureBlock {
    [self sendPassword:password];
    if (successBlock) {
        self.sendPasswordSuccessBlock = successBlock;
    }
    if (failureBlock) {
        self.sendPasswordFailureBlock = failureBlock;
    }
}


@end
