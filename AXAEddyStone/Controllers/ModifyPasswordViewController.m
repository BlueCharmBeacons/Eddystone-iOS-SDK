//
//  ModifyPasswordViewController.m
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/18.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) AXADataManager *axa_dataManager;

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *nPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _oldPasswordField.delegate = self;
    _nPasswordField.delegate = self;
    _confirmPasswordField.delegate = self;

    self.axa_dataManager = [AXADataManager sharedManager];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftItem)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotify:) name:noti_BLE_CM_DidDisconnect object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clickLeftItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleNotify:(NSNotification *)notification {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)checkFormat {
    if (_oldPasswordField.text.length != 6) {
        [self.view makeToast:@"length of old password must be 6"duration:TOAST_DURATION position:CSToastPositionCenter];
        return NO;
    }
    if (_nPasswordField.text.length != 6) {
        [self.view makeToast:@"length of new password must be 6"duration:TOAST_DURATION position:CSToastPositionCenter];
        return NO;
    }
    if (![_confirmPasswordField.text isEqualToString:_nPasswordField.text]) {
        [self.view makeToast:@"confirm password is not equal to new password"duration:TOAST_DURATION position:CSToastPositionCenter];
        return NO;
    }
    if ([_oldPasswordField.text hasChinese] || [_nPasswordField.text hasChinese] || [_confirmPasswordField.text hasChinese]) {
        [self.view makeToast:@"there is chinese"duration:TOAST_DURATION position:CSToastPositionCenter];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_oldPasswordField resignFirstResponder];
    [_nPasswordField resignFirstResponder];
    [_confirmPasswordField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *updateText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (updateText.length > 6) {
        return NO;
    }
    return YES;
}

- (IBAction)sureBtnClick:(id)sender {
    if (![self checkFormat]) {
        return;
    }
     __weak __typeof(self) weakSelf = self;
    [self.axa_dataManager sendPassword:self.oldPasswordField.text success:^(CBPeripheral *peripheral) {
        [weakSelf.axa_dataManager sendOldConfirmPassword:[_oldPasswordField.text stringByAppendingString:_nPasswordField.text]];
        [weakSelf.axa_dataManager sendTurnOffDevice];
    } failure:^(CBPeripheral *peripheral) {

    }];
}


@end
