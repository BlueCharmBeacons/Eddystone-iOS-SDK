//
//  AXAScanViewController.m
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/4.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import "AXAScanViewController.h"
#import "EddystoneViewModel.h"
#import "EddystoneUIDCell.h"
#import "EddystoneURLCell.h"
#import "EddystoneBeaconCell.h"
#import "AXADetailViewController.h"
#import "AXADetailViewController.h"

@interface AXAScanViewController ()<UITableViewDelegate, UITableViewDataSource>
{

    NSTimer *_reloadTimer;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) AXADataManager *axa_dataManager;

@property (nonatomic, strong) NSMutableArray *save_ES_UID_VMList;
@property (nonatomic, strong) NSMutableArray *save_ES_URL_VMList;
@property (nonatomic, strong) NSMutableArray *save_ES_Beacon_VMList;

@property (nonatomic, strong) UIButton *customBtn;

@property (nonatomic, strong) EddystoneModel *connectESModel;

@end

@implementation AXAScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpUI];

    [self.view addSubview:self.tableView];

    self.axa_dataManager = [AXADataManager sharedManager];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setNotification];
    [self.save_ES_UID_VMList removeAllObjects];
    [self.save_ES_URL_VMList removeAllObjects];
    [self.save_ES_Beacon_VMList removeAllObjects];
    [self.axa_dataManager startFindBleDevicesWithServices:nil WithAllowDuplicatesKey:YES];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.save_ES_UID_VMList removeAllObjects];
    [self.save_ES_URL_VMList removeAllObjects];
    [self.save_ES_Beacon_VMList removeAllObjects];
    [self.tableView reloadData];
    [self removeNotification];
}

- (void)setUpUI {
    self.navigationItem.title = @"Eddystone";

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"titleView"] forBarMetrics:UIBarMetricsDefault];

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};

    _customBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [_customBtn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [_customBtn addTarget:self action:@selector(pressRight:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_customBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    [self scanAnimation];
}

- (void)scanAnimation {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.delegate = self;
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue = @(2 * M_PI);
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;
    [_customBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self scanAnimation];
}

- (void)pressRight:(id)sender {

    [self.save_ES_UID_VMList removeAllObjects];
    [self.save_ES_URL_VMList removeAllObjects];
    [self.save_ES_Beacon_VMList removeAllObjects];
    [self.axa_dataManager startFindBleDevicesWithServices:nil WithAllowDuplicatesKey:YES];
    [self.tableView reloadData];
}

- (void)setNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotify:) name:noti_BLE_CM_PowerOn object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotify:) name:noti_BLE_CM_PowerOff object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotify:) name:noti_BLE_CM_DidConnect object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotify:) name:noti_Discover_ES_UID object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotify:) name:noti_Discover_ES_URL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotify:) name:noti_Discover_ES_Beacon object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadTableView {
    [self.tableView reloadData];
}

- (void)handleNotify:(NSNotification *)notification {
    if ([notification.name isEqualToString:noti_BLE_CM_PowerOn]) {
        [self.axa_dataManager startFindBleDevicesWithServices:nil WithAllowDuplicatesKey:YES];
        _reloadTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadTableView) userInfo:nil repeats:YES];
    }
    else if ([notification.name isEqualToString:noti_BLE_CM_PowerOff]) {

    }
    else if ([notification.name isEqualToString:noti_BLE_CM_DidConnect]) {
        CBPeripheral *peripheral = notification.object;
        [self.axa_dataManager stopFindBleDevices];
        if ([self.connectESModel.peripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            AXADetailViewController *_DetailVC = [[AXADetailViewController alloc] init];
            _DetailVC.ESModel = self.connectESModel;
            [self.navigationController pushViewController:_DetailVC animated:YES];
        }
    }
    else if ([notification.name isEqualToString:noti_Discover_ES_UID]) {
        CBPeripheral *peripheral = notification.object;
        NSDictionary *notiData = notification.userInfo;
        EddystoneModel *eddystone = [[EddystoneModel alloc] init];
        eddystone.peripheral = peripheral;
        eddystone.name = notiData[ES_NAME];
        eddystone.rssi = notiData[ES_RSSI];
        eddystone.modelType = [notiData[ES_MODELTYPE] integerValue];
        eddystone.connectable = notiData[ES_CONNECTABLE];
        eddystone.id1 = notiData[ES_ID1];
        eddystone.id2 = notiData[ES_ID2];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", peripheral.identifier.UUIDString];
        NSArray *uidArr = [self.save_ES_UID_VMList filteredArrayUsingPredicate:predicate];
        NSArray *urlArr = [self.save_ES_URL_VMList filteredArrayUsingPredicate:predicate];
        NSArray *beaconArr = [self.save_ES_Beacon_VMList filteredArrayUsingPredicate:predicate];
        if (urlArr.count) {
            [self.save_ES_URL_VMList removeObject:urlArr.lastObject];
        }
        if (beaconArr.count) {
            [self.save_ES_Beacon_VMList removeObject:beaconArr.lastObject];
        }
        if (uidArr.count) {
            EddystoneViewModel *vm = uidArr.lastObject;
            vm.eddystone = eddystone;
        } else {
            EddystoneViewModel *vm = [[EddystoneViewModel alloc] initWithEddystoneModel:eddystone];
            [self.save_ES_UID_VMList addObject:vm];
        }
        self.save_ES_UID_VMList = [self sortedArrayByRSSIWithArray:self.save_ES_UID_VMList];
    }
    else if ([notification.name isEqualToString:noti_Discover_ES_URL]) {
        CBPeripheral *peripheral = notification.object;
        NSDictionary *notiData = notification.userInfo;
        EddystoneModel *eddystone = [[EddystoneModel alloc] init];
        eddystone.peripheral = peripheral;
        eddystone.name = notiData[ES_NAME];
        eddystone.rssi = notiData[ES_RSSI];
        eddystone.modelType = [notiData[ES_MODELTYPE] integerValue];
        eddystone.connectable = notiData[ES_CONNECTABLE];
        eddystone.url = notiData[ES_URL];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", peripheral.identifier.UUIDString];
        NSArray *uidArr = [self.save_ES_UID_VMList filteredArrayUsingPredicate:predicate];
        NSArray *urlArr = [self.save_ES_URL_VMList filteredArrayUsingPredicate:predicate];
        NSArray *beaconArr = [self.save_ES_Beacon_VMList filteredArrayUsingPredicate:predicate];
        if (uidArr.count) {
            [self.save_ES_UID_VMList removeObject:uidArr.lastObject];
        }
        if (beaconArr.count) {
            [self.save_ES_Beacon_VMList removeObject:beaconArr.lastObject];
        }
        if (urlArr.count) {
            EddystoneViewModel *vm = urlArr.lastObject;
            vm.eddystone = eddystone;
        } else {
            EddystoneViewModel *vm = [[EddystoneViewModel alloc] initWithEddystoneModel:eddystone];
            [self.save_ES_URL_VMList addObject:vm];
        }
        self.save_ES_URL_VMList = [self sortedArrayByRSSIWithArray:self.save_ES_URL_VMList];
    }
    else if ([notification.name isEqualToString:noti_Discover_ES_Beacon]) {
        CBPeripheral *peripheral = notification.object;
        NSDictionary *notiData = notification.userInfo;
        EddystoneModel *eddystone = [[EddystoneModel alloc] init];
        eddystone.peripheral = peripheral;
        eddystone.name = notiData[ES_NAME];
        eddystone.rssi = notiData[ES_RSSI];
        eddystone.modelType = [notiData[ES_MODELTYPE] integerValue];
        eddystone.connectable = notiData[ES_CONNECTABLE];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", peripheral.identifier.UUIDString];
        NSArray *uidArr = [self.save_ES_UID_VMList filteredArrayUsingPredicate:predicate];
        NSArray *urlArr = [self.save_ES_URL_VMList filteredArrayUsingPredicate:predicate];
        NSArray *beaconArr = [self.save_ES_Beacon_VMList filteredArrayUsingPredicate:predicate];
        if (uidArr.count) {
            [self.save_ES_UID_VMList removeObject:uidArr.lastObject];
        }
        if (urlArr.count) {
            [self.save_ES_URL_VMList removeObject:urlArr.lastObject];
        }
        if (beaconArr.count) {
            EddystoneViewModel *vm = beaconArr.lastObject;
            vm.eddystone = eddystone;
        } else {
            EddystoneViewModel *vm = [[EddystoneViewModel alloc] initWithEddystoneModel:eddystone];
            [self.save_ES_Beacon_VMList addObject:vm];
        }
        self.save_ES_Beacon_VMList = [self sortedArrayByRSSIWithArray:self.save_ES_Beacon_VMList];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.save_ES_UID_VMList.count;
    }
    else if (section == 1) {
        return self.save_ES_URL_VMList.count;
    }
    else {
        return self.save_ES_Beacon_VMList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        EddystoneUIDCell *cell = [EddystoneUIDCell cellWithTableView:tableView];
        cell.eddystoneVM = self.save_ES_UID_VMList[indexPath.row];
        return cell;
    }
    else if (indexPath.section == 1) {
        EddystoneURLCell *cell = [EddystoneURLCell cellWithTableView:tableView];
        cell.eddystoneVM = self.save_ES_URL_VMList[indexPath.row];
        return cell;
    }
    else {
        EddystoneBeaconCell *cell = [EddystoneBeaconCell cellWithTableView:tableView];
        cell.eddystoneVM = self.save_ES_Beacon_VMList[indexPath.row];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 125;
    }
    else if (indexPath.section == 1) {
        return 100;
    }
    else {
        return 75;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EddystoneViewModel *vm;
    if (indexPath.section == 0) {
        vm = self.save_ES_UID_VMList[indexPath.row];
    }
    else if (indexPath.section == 1) {
        vm = self.save_ES_URL_VMList[indexPath.row];
    }
    else {
        vm = self.save_ES_Beacon_VMList[indexPath.row];
    }
    [self.axa_dataManager connectBleDevices:vm.eddystone];
    self.connectESModel = vm.eddystone;
}

#pragma mark - private method
- (NSMutableArray *)sortedArrayByRSSIWithArray:(NSMutableArray *)array {
    NSArray *sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        EddystoneViewModel *vm1 = obj1;
        EddystoneViewModel *vm2 = obj2;
        return [[NSNumber numberWithInteger:[vm2.rssiText integerValue]] compare:[NSNumber numberWithInteger:[vm1.rssiText integerValue]]];
    }];
    return [NSMutableArray arrayWithArray:sortedArray];
}


#pragma mark - 懒加载
- (NSMutableArray *)save_ES_UID_VMList {
    if (!_save_ES_UID_VMList) {
        self.save_ES_UID_VMList = [NSMutableArray array];
    }
    return _save_ES_UID_VMList;
}

- (NSMutableArray *)save_ES_URL_VMList {
    if (!_save_ES_URL_VMList) {
        self.save_ES_URL_VMList = [NSMutableArray array];
    }
    return _save_ES_URL_VMList;
}

- (NSMutableArray *)save_ES_Beacon_VMList {
    if (!_save_ES_Beacon_VMList) {
        self.save_ES_Beacon_VMList = [NSMutableArray array];
    }
    return _save_ES_Beacon_VMList;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
