//
//  RegiterViewController.m
//  Wochuke
//
//  Created by he songhang on 13-6-27.
//  Copyright (c) 2013年 he songhang. All rights reserved.
//

#import "RegiterViewController.h"
#import <Ice/Ice.h>
#import <Guide.h>
#import "ICETool.h"
#import "ShareVaule.h"

@interface RegiterViewController ()

@end

@implementation RegiterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *backImage = [[UIImage imageNamed:@"bg_register&login_card"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
    [_iv_back setImage:backImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToMyViewController
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void)regiterWithEmail:(NSString *)email password:(NSString *)password confirm:(NSString *)confirm nickname:(NSString *)nickname
{
    JCUser *user = [[JCUser alloc] init];
    user.email = email;
    user.password = password;
    user.name = nickname;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        @try {
            id<JCAppIntfPrx> proxy = [[ICETool shareInstance] createProxy];
            @try {
                JCUser *userInfo = [proxy saveUser:user];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (userInfo.id_) {
                        [ShareVaule shareInstance].userId = userInfo.id_;
                        [ShareVaule shareInstance].user = userInfo;
                        [self backToMyViewController];
                    } else {
                        
                    }
                });
            }
            @catch (NSException *exception) {
                if ([exception isKindOfClass:[JCGuideException class]]) {
                    JCGuideException *_exception = (JCGuideException *)exception;
                    if (_exception.reason_) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:_exception.reason_ delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                            [alert show];
                            [alert release];
                        });
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:ERROR_MESSAGE delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                            [alert show];
                            [alert release];
                        });
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:ERROR_MESSAGE delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alert show];
                        [alert release];
                    });
                }
            }
            @finally {
                
            }
        }@catch (ICEException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:ERROR_MESSAGE delegate:nil cancelButtonTitle:@"服务访问异常" otherButtonTitles: nil];
                [alert show];
                [alert release];
            });
        }
        
    });
}

- (void)regiter
{
    if ([_tf_mail.text length] == 0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                     message:@"请输入邮箱"
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
        [av release];
        return;
    }
    if (![self isValidateEmail:_tf_mail.text]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                     message:@"邮箱格式不正确，请重新输入"
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
        [av release];
        return;
    }
    if ([_tf_password.text length] == 0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                     message:@"请输入密码"
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
        [av release];
        return;
    }
    if ([_tf_confirm.text length] == 0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                     message:@"请输入密码"
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
        [av release];
        return;
    }
    if (![_tf_password.text isEqualToString:_tf_confirm.text]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                     message:@"密码不一致，请重新输入"
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
        [av release];
        return;
    }
    if ([_tf_nickname.text length] == 0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                     message:@"请输入昵称"
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
        [av release];
        return;
    }
    [self regiterWithEmail:_tf_mail.text password:_tf_password.text confirm:_tf_confirm.text nickname:_tf_nickname.text];
}

#pragma mark - IBAction

- (IBAction)backAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)regiterAction:(id)sender {
    [self regiter];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, -70, self.view.frame.size.width, self.view.frame.size.height);
    }];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == _tf_nickname) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _tf_mail) {
        [_tf_password becomeFirstResponder];
    }else if (textField == _tf_password){
        [_tf_confirm becomeFirstResponder];
    }else if (textField == _tf_confirm){
        [_tf_nickname becomeFirstResponder];
    }else if (textField == _tf_nickname){
        [_tf_nickname resignFirstResponder];
        [self regiter];
    }
    return YES;
}

- (void)dealloc {
    [_tf_mail release];
    [_tf_password release];
    [_tf_confirm release];
    [_tf_nickname release];
    [_iv_back release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTf_mail:nil];
    [self setTf_password:nil];
    [self setTf_confirm:nil];
    [self setTf_nickname:nil];
    [self setIv_back:nil];
    [super viewDidUnload];
}
@end
