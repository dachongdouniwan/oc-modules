//
//  QRCodePresentVC.m
//  hairdresser
//
//  Created by fallen on 16/10/26.
//
//

#import "QRCodePresentVC.h"
#import "SRActionSheet.h"
#import "QRCodeReaderViewController.h"
#import "AssetsService.h"

@interface QRCodePresentVC () {
    // user profile view
    
    
    
    // qrcode view
    UIImageView *_qrcodeImageView;
    
    UILabel *_qrcodeMessagelabel;
}

@end

@implementation QRCodePresentVC

#pragma mark - Initialize

- (void)initViews {
    CGFloat qrcodeMessageLabelHeight = 24.f;
    CGFloat qrcodeMessageLabelTopSpaces = 40.f;
    
    CGFloat qrcodeImageWidth = 180.f;
    CGFloat qrcodeImageTopSpaces = (screen_height - qrcodeImageWidth - qrcodeMessageLabelTopSpaces - qrcodeMessageLabelHeight - status_bar_height - navigation_bar_height) / 2 - 30.f;
    _qrcodeImageView = [[UIImageView alloc] initWithImage:image_named(self.qrcodeUrl)];
    [self.view addSubview:_qrcodeImageView];
    
    [_qrcodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(qrcodeImageWidth);
        make.height.mas_equalTo(qrcodeImageWidth);
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).mas_offset(qrcodeImageTopSpaces);
    }];
    
    _qrcodeMessagelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _qrcodeMessagelabel.text = self.qrcodeMessage;
    _qrcodeMessagelabel.textColor = font_gray_3;
    _qrcodeMessagelabel.font = font_m;
    _qrcodeMessagelabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_qrcodeMessagelabel];
    
    [_qrcodeMessagelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_qrcodeImageView.mas_bottom).mas_offset(qrcodeMessageLabelTopSpaces);
        make.width.equalTo(self.view.mas_width);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(qrcodeMessageLabelHeight);
    }];
}

- (void)initNavigationBar {
    [self setNavRightItemWithImage:@"qrcode_dot" target:self action:@selector(onMore)];
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    
    [self initNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action handler

- (void)onMore {
    [SRActionSheet sr_showActionSheetViewWithTitle:nil
                                 cancelButtonTitle:@"取消"
                            destructiveButtonTitle:nil
                                 otherButtonTitles:@[@"保存图片", @"扫描二维码"]
                                  selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger actionIndex) {
                                      if (actionIndex == 0) {
                                          [self onStorePhoto];
                                      } else if (actionIndex == 1) {
                                          [self onScanQRCode];
                                      }
                                  }];
}

- (void)onStorePhoto {
    if ([[AssetsService sharedInstance] configWith:app_display_name]) {
        [[AssetsService sharedInstance] saveImage:_qrcodeImageView.image toAlbum:app_display_name completion:^(NSURL *assetURL, NSError *error) {
            [self showToastWithText:@"保存图片成功!"];
        } failure:nil];
    }
}

- (void)onScanQRCode {
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *reader = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            reader = [QRCodeReaderViewController new];
        });
        
        @weakify(self)
        [reader setCompletionWithBlock:^(NSString * _Nullable resultAsString) {
            @strongify(self)
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            LOG(@"result = %@", resultAsString);
        }];
        
        [self presentViewController:reader animated:YES completion:NULL];
    }
}

#pragma mark -


@end
