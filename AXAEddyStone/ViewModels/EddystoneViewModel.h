//
//  EddystoneViewModel.h
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/5.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EddystoneViewModel : NSObject

@property (nonatomic, strong) NSString *nameText;
@property (nonatomic, strong) NSString *rssiText;
@property (nonatomic, strong) NSString *connectableText;
@property (nonatomic, strong) NSString *id1Text;
@property (nonatomic, strong) NSString *id2Text;
@property (nonatomic, strong) NSString *urlText;
@property (nonatomic, strong) NSString *typeNameText;
@property (nonatomic, strong) NSString *periodText;
@property (nonatomic, strong) NSString *powerText;
@property (nonatomic, strong) NSString *uuidText;
@property (nonatomic, strong) NSString *majorText;
@property (nonatomic, strong) NSString *minorText;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *passwordText;

@property (nonatomic, strong) EddystoneModel *eddystone;

- (instancetype)initWithEddystoneModel:(EddystoneModel *)eddystone;


@end
