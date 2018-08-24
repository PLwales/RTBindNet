//
//  RTAddDeviceTableCell.m
//  StoryToy
//
//  Created by baxiang on 2017/12/4.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import "RTAddDeviceTableCell.h"

@implementation RTAddDeviceTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorHex(0x7290ff);
        self.layer.cornerRadius = 10;
        UIImageView *photoImgeView = [UIImageView new];
        [self.contentView addSubview:photoImgeView];
        photoImgeView.contentMode = UIViewContentModeScaleAspectFit;
        photoImgeView.image = [UIImage imageNamed:@"photo_story_machine"];
        [photoImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.height.mas_equalTo(70);
        }];
        
        UILabel *nameLable = [UILabel new];
        [self.contentView addSubview:nameLable];
        nameLable.textColor = [UIColor whiteColor];
        nameLable.text = @"机器人";
        nameLable.font = [UIFont systemFontOfSize:24];
        [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(photoImgeView.mas_right).offset(25);
            make.centerY.mas_equalTo(photoImgeView.mas_centerY);
        }];
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    frame.origin.y += 20;
    frame.size.height -= 20;
    frame.origin.x = 20;
    frame.size.width -= 2 * 20;
    [super setFrame:frame];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
