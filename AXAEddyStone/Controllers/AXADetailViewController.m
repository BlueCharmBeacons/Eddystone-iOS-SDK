//
//  AXADetailViewController.m
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/5.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import "AXADetailViewController.h"
#import "DetailCell.h"
#import "ModifyCell.h"
#import "PowerCell.h"
#import "EddystoneViewModel.h"
#import "AXACellArrayModel.h"
#import "ModifyTypeViewController.h"
#import "ModifyPasswordViewController.h"

@interface AXADetailViewController ()<UITableViewDelegate, UITableViewDataSource, ModifyCellDelegate, PowerCellDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) AXADataManager *axa_dataManager;
@property (nonatomic, strong) EddystoneViewModel *esViewModel;

@property (nonatomic, strong) NSArray *ESModelTagArr;

@property (nonatomic, strong) UITextField *id1Field;
@property (nonatomic, strong) UITextField *id2Field;
@property (nonatomic, strong) UITextField *periodField;
@property (nonatomic, strong) UITextField *powerField;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *urlField;
@property (nonatomic, strong) UITextField *minorField;
@property (nonatomic, strong) UITextField *majorField;
@property (nonatomic, strong) UITextField *uuidField;

@end

@implementation AXADetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"esModel:%@", self.ESModel);
    self.axa_dataManager = [AXADataManager sharedManager];


    [self setUpUI];
    [self setNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.esViewModel = [[EddystoneViewModel alloc] initWithEddystoneModel:self.ESModel];
     self.ESModelTagArr = [AXACellArrayModel getArrayWithType:self.ESModel.modelType];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)setUpUI {
    [self.view addSubview:self.tableView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(clickLeftItme)];

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setImage:[UIImage imageNamed:@"passwordicon"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)clickRightBtn {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    ModifyPasswordViewController *modifyPasswordVC = [storyBoard instantiateViewControllerWithIdentifier:@"ModifyPasswordViewController"];
    [self.navigationController pushViewController:modifyPasswordVC animated:YES];
}

- (void)clickLeftItme {
    [self.axa_dataManager disconnectBleDevices:self.ESModel];
}

- (void)setNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotify:) name:noti_BLE_CM_DidDisconnect object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotify:) name:noti_BLE_PE_DidUpdateValue object:nil];
}



- (void)removeNotification {

}

- (void)handleNotify:(NSNotification *)notification {
    if ([notification.name isEqualToString:noti_BLE_CM_DidDisconnect]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([notification.name isEqualToString:noti_BLE_PE_DidUpdateValue]) {
        NSDictionary *userInfo = notification.userInfo;
        EddystoneModel *eddystone = userInfo[kEddystone];
        self.esViewModel.eddystone = eddystone;
        [self.tableView reloadData];
    }
}

- (BOOL)checkFormat {
    if ([_periodField.text intValue] > 9000 || [_periodField.text intValue] < 100 ) {
        [self.view makeToast:@"period must be 100 to 9000" duration:TOAST_DURATION position:CSToastPositionCenter];
        return NO;
    }
    if (self.ESModel.modelType == EddystoneModelTypeUID) {
        if (_id1Field.text.length != 20) {
            [self.view makeToast:@"length of id1 must be 20" duration:TOAST_DURATION position:CSToastPositionCenter];
            return NO;
        }
        if (_id2Field.text.length != 12) {
            [self.view makeToast:@"length of id2 must be 12" duration:TOAST_DURATION position:CSToastPositionCenter];
            return NO;
        }
        if ([_periodField.text hasChinese] || [_id1Field.text hasChinese] || [_id2Field.text hasChinese]) {
            [self.view makeToast:@"there is Chinese" duration:TOAST_DURATION position:CSToastPositionCenter];
            return NO;
        }
    }
    if (self.ESModel.modelType == EddystoneModelTypeURL) {
        if (![self urlIsRight]) {
            [self.view makeToast:@"Remove a portion of prefixes and suffixes can not be more than 16 characters" duration:TOAST_DURATION position:CSToastPositionCenter];
            return NO;
        }
        if ([_periodField.text hasChinese] || [_urlField.text hasChinese]) {
            [self.view makeToast:@"there is Chinese" duration:TOAST_DURATION position:CSToastPositionCenter];
            return NO;
        }
    }
    if (self.ESModel.modelType == EddystoneModelTypeBeacon) {
        if (_uuidField.text.length != 32) {
            [self.view makeToast:@"length of uuid must be 32" duration:TOAST_DURATION position:CSToastPositionCenter];
            return NO;
        }
        if ([_majorField.text intValue] > 65535 || [_majorField.text intValue] < 0) {
            [self.view makeToast:@"major must be 0 to 65535" duration:TOAST_DURATION position:CSToastPositionCenter];
            return NO;
        }
        if ([_minorField.text intValue] > 65535 || [_minorField.text intValue] < 0) {
            [self.view makeToast:@"minor must be 0 to 65535" duration:TOAST_DURATION position:CSToastPositionCenter];
            return NO;
        }
        if ([_periodField.text hasChinese] || [_minorField.text hasChinese] || [_majorField.text hasChinese] || [_uuidField.text hasChinese]) {
            [self.view makeToast:@"there is Chinese" duration:TOAST_DURATION position:CSToastPositionCenter];
            return NO;
        }
    }
    if (_nameField.text.length) {
        if (_nameField.text.length >= 12) {
            [self.view makeToast:@"length of name must be less than 12" duration:TOAST_DURATION position:CSToastPositionCenter];
            return NO;
        }
        if ([_nameField.text hasChinese]) {
            [self.view makeToast:@"there is chinese" duration:TOAST_DURATION position:CSToastPositionCenter];
            return NO;
        }
    }

    return YES;
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ESModelTagArr.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.ESModelTagArr.count) {
        ModifyCell *cell = [ModifyCell cellWithTableView:tableView];
        cell.delegate = self;
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }
        return cell;
    } else if (indexPath.row == self.ESModelTagArr.count-3) {
        PowerCell *cell = [PowerCell cellWithTableView:tableView];
        cell.eddystoneVM = self.esViewModel;
        self.powerField = cell.textyField;
        self.powerField.delegate = self;
        cell.delegate = self;
        return cell;
    }

    else {
        DetailCell *cell = [DetailCell cellWithTableView:tableView];
        cell.tag = [self.ESModelTagArr[indexPath.row] integerValue];
        cell.eddystoneVM = self.esViewModel;
        [self configFieldWithCell:cell];
        return cell;
    }
}

- (void)configFieldWithCell:(DetailCell *)cell {
    if (cell.tag == AXADetailTypeCellTag) {
//        cell.textField.text = self.ESModel.typeName;
    }
    if (cell.tag == AXADetailID1CellTag) {
        self.id1Field = cell.textField;
        self.id1Field.delegate = self;
    } else if (cell.tag == AXADetailID2CellTag) {
        self.id2Field = cell.textField;
        self.id2Field.delegate = self;
    } else if (cell.tag == AXADetailPeriodCellTag) {
        self.periodField = cell.textField;
        self.periodField.delegate = self;
    } else if (cell.tag == AXADetailPowerCellTag) {
        self.powerField = cell.textField;
        self.powerField.delegate = self;
    } else if (cell.tag == AXADetailNameCellTag) {
        self.nameField = cell.textField;
        self.nameField.delegate = self;
    } else if (cell.tag == AXADetailPasswordCellTag) {
        self.passwordField = cell.textField;
        self.passwordField.secureTextEntry = YES;
        self.passwordField.delegate = self;
    } else if (cell.tag == AXADetailURLCellTag) {
        self.urlField = cell.textField;
        self.urlField.delegate = self;
    } else if (cell.tag == AXADetailMinorCellTag) {
        self.minorField = cell.textField;
        self.minorField.delegate = self;
    } else if (cell.tag == AXADetailMajorCellTag) {
        self.majorField = cell.textField;
        self.majorField.delegate = self;
    } else if (cell.tag == AXADetailUUIDCellTag) {
        self.uuidField = cell.textField;
        self.uuidField.delegate = self;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        /*
        ModifyTypeViewController *modifyTypeVC = [ModifyTypeViewController new];
        modifyTypeVC.ESModel = self.ESModel;
        [self.navigationController pushViewController:modifyTypeVC animated:YES];
         */
    }
}


#pragma mark - CellDelegate
- (void)modifyCell:(ModifyCell *)cell clickModifyBtn:(UIButton *)button {
    NSLog(@"%s", __func__);
    __weak __typeof(self) weakSelf = self;
    [self.axa_dataManager sendPassword:self.passwordField.text success:^(CBPeripheral *peripheral) {
        if (![weakSelf checkFormat]) {
            return;
        }
        if (weakSelf.ESModel.modelType == EddystoneModelTypeUID) {//UID
            [weakSelf.axa_dataManager sendHexString:[_id1Field.text stringByAppendingString:_id2Field.text]];
            [weakSelf.axa_dataManager sendPeriod:_periodField.text Power:_powerField.text];
        } else if (weakSelf.ESModel.modelType == EddystoneModelTypeURL) {//URL
            [weakSelf.axa_dataManager sendUrl:_urlField.text];
            [weakSelf.axa_dataManager sendPeriod:_periodField.text Power:_powerField.text];
        } else {//Beacon
            [weakSelf.axa_dataManager sendHexString:_uuidField.text];
            [weakSelf.axa_dataManager sendPeriod:_periodField.text Power:_powerField.text Major:_majorField.text Minor:_minorField.text];
        }
        if (_nameField.text.length > 0) {
            [weakSelf.axa_dataManager sendName:_nameField.text];
        }
        [weakSelf.axa_dataManager sendTurnOffDevice];
    } failure:^(CBPeripheral *peripheral) {
        // 密码错误
    }];
}

- (void)powerCell:(PowerCell *)cell selectedSegmentIndex:(NSInteger)index {
    self.powerField.text = [NSString stringWithFormat:@"%ld", index];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    NSLog(@"%s",__func__);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSLog(@"%s",__func__);
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.passwordField]) {
        NSString *updateText = [self.passwordField.text stringByReplacingCharactersInRange:range withString:string];
        if (updateText.length > 6) {
            return NO;
        }
    }
    if ([textField isEqual:self.uuidField]) {
        NSString *updateText = [self.uuidField.text stringByReplacingCharactersInRange:range withString:string];
        if (updateText.length > 32) {
            return NO;
        }
    }
    if ([textField isEqual:self.id1Field]) {
        NSString *updateText = [self.id1Field.text stringByReplacingCharactersInRange:range withString:string];
        if (updateText.length > 20) {
            return NO;
        }
    }
    if ([textField isEqual:self.id2Field]) {
        NSString *updateText = [self.id2Field.text stringByReplacingCharactersInRange:range withString:string];
        if (updateText.length > 12) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Setter and Getter
- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, KSCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (BOOL)urlCheckDetailWithLength:(NSUInteger)lenth {
    if ([_urlField.text rangeOfString:@".info/"].location != NSNotFound) {
        if (_urlField.text.length > 34 - lenth) {
            return NO;
        } else {
            return YES;
        }
    }
    else if ([_urlField.text rangeOfString:@".com/"].location != NSNotFound || [_urlField.text rangeOfString:@".org/"].location != NSNotFound || [_urlField.text rangeOfString:@".edu/"].location != NSNotFound || [_urlField.text rangeOfString:@".net/"].location != NSNotFound || [_urlField.text rangeOfString:@".biz/"].location != NSNotFound || [_urlField.text rangeOfString:@".gov/"].location != NSNotFound || [_urlField.text rangeOfString:@".info"].location != NSNotFound) { // 5
        if (_urlField.text.length > 33 - lenth) {
            return NO;
        } else {
            return YES;
        }
    }

    else if ([_urlField.text rangeOfString:@".com"].location != NSNotFound || [_urlField.text rangeOfString:@".org"].location != NSNotFound || [_urlField.text rangeOfString:@".edu"].location != NSNotFound || [_urlField.text rangeOfString:@".net"].location != NSNotFound || [_urlField.text rangeOfString:@".biz"].location != NSNotFound || [_urlField.text rangeOfString:@".gov"].location != NSNotFound ) {// 4
        if (_urlField.text.length > 32 - lenth) {
            return NO;
        } else {
            return YES;
        }
    }
    else {
        if (_urlField.text.length > 28 - lenth) {
            return NO;
        } else {
            return YES;
        }
    }
}

- (BOOL)urlIsRight {
    if ([_urlField.text rangeOfString:@"https://www."].location != NSNotFound) { // 12
        return [self urlCheckDetailWithLength:0];
    }
    else if ([_urlField.text rangeOfString:@"http://www."].location != NSNotFound) {// 11
        return [self urlCheckDetailWithLength:1];
    }
    else if ([_urlField.text rangeOfString:@"https://"].location != NSNotFound) {//8
        return [self urlCheckDetailWithLength:4];
    }
    else if ([_urlField.text rangeOfString:@"http://"].location != NSNotFound) {//7
        return [self urlCheckDetailWithLength:5];
    }
    return YES;
}
@end
