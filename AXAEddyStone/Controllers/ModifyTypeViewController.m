//
//  ModifyTypeViewController.m
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/17.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import "ModifyTypeViewController.h"

@interface ModifyTypeViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, copy) NSString *selectPickerStr;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

@end

@implementation ModifyTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectPickerStr = @"iBeacon";// 初始位置
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;

    self.updateBtn.layer.cornerRadius = 30;
    self.updateBtn.layer.masksToBounds = YES;

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    if (row == 0) {
        title = @"iBeacon";
    } else if (row == 1) {
        title = @"Eddystone-UID";
    } else if (row == 2) {
        title = @"Eddystone-URL";
    }
    return title;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) {
        self.ESModel.modelType = EddystoneModelTypeBeacon;
    } else if (row == 1) {
        self.ESModel.modelType = EddystoneModelTypeUID;
    } else if (row == 2) {
        self.ESModel.modelType = EddystoneModelTypeURL;
    }
}


- (IBAction)tapUpdateBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
