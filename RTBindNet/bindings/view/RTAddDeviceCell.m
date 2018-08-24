//
//  RTAddDeviceCell.m
//  StoryToy
//
//  Created by roobo on 2018/5/31.
//  Copyright © 2018年 roobo. All rights reserved.
//

#import "RTAddDeviceCell.h"

@interface RTAddDeviceCell()

@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *nameLabel;

@end

@implementation RTAddDeviceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        UIImageView *photoImgeView = [UIImageView new];
        [self.contentView addSubview:photoImgeView];
        photoImgeView.contentMode = UIViewContentModeScaleAspectFit;
        photoImgeView.image = [UIImage imageNamed:@"icon_ap_add"];
        [photoImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView).offset(12);
            make.width.mas_equalTo(346);
            make.height.mas_equalTo(108);
        }];
        
        UIImageView *iconView = [UIImageView new];
        [self.contentView addSubview:iconView];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        iconView.image = [UIImage imageNamed:@"icon_ap_xiaoyi"];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(photoImgeView).offset(36);
            make.bottom.mas_equalTo(photoImgeView).offset(-17);
        }];
        
        UILabel *nameLable = [UILabel new];
        [self.contentView addSubview:nameLable];
        nameLable.textColor = [UIColor whiteColor];
        nameLable.text = @"小忆机器人";
        nameLable.textColor = UIColorHex(0x4a4a4a);
        nameLable.font = [UIFont systemFontOfSize:18];
        [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(15);
            make.centerY.mas_equalTo(photoImgeView);
        }];
        
        _iconView = iconView;
        _nameLabel = nameLable;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    self.iconView.image = icon;
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
}

@end
