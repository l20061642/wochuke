//
//  UserView.m
//  Wochuke
//
//  Created by he songhang on 13-7-5.
//  Copyright (c) 2013年 he songhang. All rights reserved.
//

#import "UserView.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "MyWebImgView.h"
#import <Guide.h>
#import "NSObject+Notification.h"

@implementation UserView

@end

@implementation UserCell

+ (CGSize)sizeInBound:(CGSize)bound forData:(NSObject *)data
{
	return bound;
}

- (void)layoutInBound:(CGSize)bound forCell:(BeeUIGridCell *)cell
{
    iv_heard.frame = CGRectMake(5, 5, bound.height -10, bound.height -10);
    lb_name.frame = CGRectMake(bound.height, 5, bound.width - 60, (bound.height-10)/2);
    lb_guides.frame = CGRectMake(bound.height, (bound.height-10)/2, 60, (bound.height-10)/2);
    lb_fav.frame = CGRectMake(bound.height + 70, (bound.height-10)/2, 60, (bound.height-10)/2);
    btn_following.frame = CGRectMake(bound.width - 80, 10, 70, bound.height-20);
}

- (void)dataDidChanged
{
    if (self.cellData) {
        JCUser *user = self.cellData;
        [iv_heard setImageWithURL:[NSURL URLWithString:user.avatar.url] placeholderImage:[UIImage imageNamed:@"ic_user_top"]];
        lb_name.text = user.name;
        lb_guides.text = [NSString stringWithFormat:@"%d上传",user.guideCount];
        lb_fav.text = [NSString stringWithFormat:@"%d收藏",user.favoriteCount];
        [btn_following setTitle:user.followState==1||user.followState==3?@"取消关注":@"添加关注" forState:UIControlStateNormal];
    }
}

- (void)load
{
    iv_heard = [[[MyWebImgView alloc]init]autorelease];
    iv_heard.contentMode = UIViewContentModeScaleAspectFill;
    iv_heard.layer.cornerRadius = 6;
    iv_heard.layer.masksToBounds = YES;
    
    lb_name = [[[UILabel alloc]init]autorelease];
    lb_name.font = [UIFont boldSystemFontOfSize:12];
    lb_name.backgroundColor = [UIColor clearColor];
    lb_name.textColor = [UIColor darkTextColor];
    lb_name.textAlignment = UITextAlignmentLeft;
    lb_name.numberOfLines = 2;
    
    lb_guides = [[[UILabel alloc]init]autorelease];
    lb_guides.font = [UIFont boldSystemFontOfSize:12];
    lb_guides.backgroundColor = [UIColor clearColor];
    lb_guides.textColor = [UIColor darkTextColor];
    lb_guides.textAlignment = UITextAlignmentLeft;
    
    btn_following = [[[UIButton alloc]init]autorelease];
    UIImage *backImage = [[UIImage imageNamed:@"btn_grad"]resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12) ];
//    [btn_following setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [btn_following setBackgroundImage:backImage forState:UIControlStateNormal];
    [btn_following setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btn_following.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn_following addTarget:self action:@selector(followBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:iv_heard];
    [self addSubview:lb_name];
    [self addSubview:lb_guides];
    [self addSubview:btn_following];
    
    [self observeNotification:NOTIFICATION_FOLLOWSTATECHANGE];
}

-(void)unload{
    [super unload];
    [self unobserveNotification:NOTIFICATION_FOLLOWSTATECHANGE];
}

-(void)handleNotification:(NSNotification *)notification{
    if ([notification.name isEqual:NOTIFICATION_FOLLOWSTATECHANGE]) {
        JCUser *user = (JCUser *)self.cellData;
        if (user) {
            [btn_following setTitle:user.followState==1||user.followState==3?@"取消关注":@"添加关注" forState:UIControlStateNormal];
        }
    }
}

-(void)followBtnClicked{
    if (_delegate && [_delegate respondsToSelector:@selector(followUser:)]) {
        [_delegate followUser:self.cellData];
    }
}

@end
