//
//  StepView.m
//  Wochuke
//
//  Created by he songhang on 13-6-25.
//  Copyright (c) 2013年 he songhang. All rights reserved.
//

#import "StepView.h"
#import "UIImagePreView.h"
#import "NSObject+Notification.h"

@implementation StepView

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGSize size = [_step.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(frame.size.width -14, 1000)];
    btn_comment.frame = CGRectMake(7, frame.size.height - 7 - 20, 40, 20);
    lb_comment.frame = CGRectMake(52, frame.size.height - 7 - 20, 40, 20);
    
    if (_step.photo.url){
        imageView.frame = CGRectMake(7, 7, frame.size.width -14 , frame.size.height - 14 - 40 - size.height);
        lb_text.frame = CGRectMake(7, frame.size.height - 7 - 30 - size.height, size.width, size.height);
    }else{
        imageView.frame = CGRectZero;
        lb_text.frame = CGRectMake(7,  7 , frame.size.width - 14, frame.size.height - 14 - 40);
    }
}

-(void)imageTap{
    [UIImagePreView showInView:imageView image:imageView.image];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        imageView = [[[MyWebImgView alloc]init]autorelease];
        imageView.layer.cornerRadius = 6;
        imageView.layer.masksToBounds = YES;
        imageView.showProgress = YES;
        [self addSubview:imageView];
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [imageView addGestureRecognizer:singleRecognizer];
        
        
        lb_text = [[[UILabel alloc]init]autorelease];
        lb_text.font = [UIFont systemFontOfSize:14];
        lb_text.backgroundColor = [UIColor clearColor];
        lb_text.textColor = [UIColor darkTextColor];
        lb_text.numberOfLines = 100;
        
        [self addSubview:lb_text];
        
        btn_comment = [[[UIButton alloc]init]autorelease];
        btn_comment.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn_comment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:btn_comment];
        
        lb_comment = [[[UILabel alloc]init]autorelease];
        lb_comment.font = [UIFont systemFontOfSize:14];
        lb_comment.backgroundColor = [UIColor clearColor];
        lb_comment.textColor = [UIColor grayColor];
        lb_comment.text = @"评论";
        [self addSubview:lb_comment];
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
    }
    return self;
}

-(void)dealloc{
    [_step release];
    [super dealloc];
}

-(void)setStep:(JCStep *)step{
    if (_step) {
        [_step release];
        _step = nil;
    }
    _step = [step retain];
    [btn_comment setTitle: [NSString stringWithFormat:@"%d",_step.commentCount] forState:UIControlStateNormal];
    lb_text.text = step.text;
    if (_step.photo.url) {
        [imageView setImageWithURL:[NSURL URLWithString:_step.photo.url]];
        lb_text.font = [UIFont systemFontOfSize:14];
    }else{
        [imageView setImage:nil];
        lb_text.font = [UIFont systemFontOfSize:18];
    }
}

@end

@implementation StepMinView

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    btn_comment.frame = CGRectZero;
    lb_comment.frame = CGRectZero;
    if (self.step.photo.url){
        imageView.frame = CGRectMake(5, 5, frame.size.width -10 , frame.size.height - 40);
        lb_text.frame = CGRectMake(5, frame.size.height - 30 , frame.size.width -10, 25);
    }else{
        imageView.frame = CGRectZero;
        lb_text.frame = CGRectMake(5,  5 , frame.size.width - 14, frame.size.height - 14);
    }
}

-(void)setStep:(JCStep *)step{
    [super setStep:step];
    if (step.photo.url) {
        lb_text.font = [UIFont systemFontOfSize:11];
    }else{
        [imageView setImage:nil];
        lb_text.font = [UIFont systemFontOfSize:14];
    }
}

-(void)imageTap{
   
}

@end