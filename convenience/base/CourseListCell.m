//
//  CourseListCell.m
//  student
//
//  Created by fallen.ink on 29/04/2017.
//  Copyright © 2017 alliance. All rights reserved.
//

#import "CourseListCell.h"
#import "student-precomplie.h"
#import "RateView.h"

@interface CourseListCell () {
    UIImageView *_iconImageView;
    
    UILabel *_nameLabel;
    UILabel *_descLabel;
    UILabel *_locateLabel;
    UILabel *_distanceLabel;
    
    RateView *_rateView;
    
    UIView *_tagView;
}

@end

@implementation CourseListCell

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark -

#define IconHeight 56
#define IconWidth  72

+ (CGFloat)cellHeight {
    return 100;
}

- (void)setup {
    _iconImageView = [UIImageView new];
    [self addSubview:_iconImageView];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(margin_m);
        make.top.equalTo(self.mas_top).offset(margin_m);
        //        make.bottom.equalTo(s elf.mas_bottom).offset(margin_m);;
        //        make.width.mas_equalTo(_iconImageView.height).multipliedBy(1.5f);
        make.height.mas_equalTo(IconHeight);
        make.width.mas_equalTo(IconWidth);
    }];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor = font_gray_3;
    [self addSubview:_nameLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_iconImageView.mas_trailing).offset(margin_s);
        make.top.equalTo(_iconImageView.mas_top);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    _descLabel = [UILabel instanceWithFont:font_s color:font_gray_2];
    [self addSubview:_descLabel];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_iconImageView.mas_trailing).offset(margin_s);
        make.bottom.equalTo(_iconImageView.mas_bottom);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    _locateLabel = [UILabel instanceWithFont:font_s color:font_gray_2 alignment:NSTextAlignmentRight];
    [self addSubview:_locateLabel];
    
    [_locateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-margin_m);
        make.centerY.equalTo(_iconImageView.mas_centerY);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(80);
    }];
    
    _distanceLabel = [UILabel instanceWithFont:font_s color:font_gray_2 alignment:NSTextAlignmentRight];
    [self addSubview:_distanceLabel];
    
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-margin_m);
        make.bottom.equalTo(_iconImageView.mas_bottom);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(80);
    }];
    
    _rateView = [[RateView alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 180.0f, 60.0f)];
    _rateView.max = 5;
    _rateView.allowHalf = NO;
    [_rateView setOnImage:image_named(@"star_yellow") offImage:image_named(@"star_gray")];
    [self addSubview:_rateView];
    
    [_rateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_iconImageView.mas_trailing).offset(margin_s);
        make.centerY.equalTo(_iconImageView.mas_centerY);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(80);
    }];
}

- (void)setdown:(id)model {
    [_iconImageView sd_setHeadImageWithPath:nil];
    
    _nameLabel.text = @"美国柯蒂斯威学科英语校区";
    
    {
        // 是否
    }
    
    _descLabel.text = @"2岁以上 英语";
    
    _locateLabel.text = @"南京西路";
    
    _distanceLabel.text = @"1.2km";
    
    _rateView.value = 4;
}

@end
