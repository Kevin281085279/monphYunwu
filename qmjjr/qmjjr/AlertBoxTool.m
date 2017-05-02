//
//  AlertBoxTool.m
//  zhuna2.0
//
//  Created by zyj on 14-5-9.
//  Copyright (c) 2014年 zhuna. All rights reserved.
//

#import "AlertBoxTool.h"

@interface AlertBoxTool ()<UITextFieldDelegate>
@property (nonatomic,copy)void (^AlertBoxBack) ();

@end
@implementation AlertBoxTool
- (id)init
{
    self = [super init];
    if (self) {
        

        
    }
    return self;
    
    

}
-(void)dealloc{
    NSLog(@"---AlertBoxTool-----dealloc--");
    [super dealloc];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (_AlertBoxBack) {
        self.AlertBoxBack(alertView,buttonIndex);

    }
    [self release];
}
+(void)AlertWithTitle:(NSString*)string
              message:(NSString*)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSString *)otherButtonTitles
            alertView:(void (^)( UIAlertView *alertView, NSInteger buttonIndex))alertView{
    
    AlertBoxTool *A = [AlertBoxTool new];
    A.AlertBoxBack = alertView;

    
    
    UIAlertView *asdf=[[UIAlertView alloc]initWithTitle:string
                                                message:message
                                               delegate:alertView==nil ? nil : A
                                      cancelButtonTitle:cancelButtonTitle
                                      otherButtonTitles:otherButtonTitles, nil];
    
    
    [asdf show];
    
    
}
+(void)AlertWithTitle:(NSString*)string
              message:(NSString*)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSString *)otherButtonTitles
    otherButtonTitles1:(NSString *)otherButtonTitles1
            alertView:(void (^)( UIAlertView *alertView, NSInteger buttonIndex))alertView{
    
    AlertBoxTool *A = [AlertBoxTool new];
    A.AlertBoxBack = alertView;
    
    
    
    UIAlertView *asdf=[[UIAlertView alloc]initWithTitle:string
                                                message:message
                                               delegate:alertView==nil ? nil : A
                                      cancelButtonTitle:cancelButtonTitle
                                      otherButtonTitles:otherButtonTitles,otherButtonTitles1, nil];
    
    
    [asdf show];
    
    
}
+(void)AlertWithTitle:(NSString*)string
              message:(NSString*)message
                 style:(UIAlertViewStyle)style
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSString *)otherButtonTitles
            alertView:(void (^)( UIAlertView *alertView, NSInteger buttonIndex))alertView{
    
    AlertBoxTool *A = [AlertBoxTool new];
    A.AlertBoxBack = alertView;
    
    
    
    UIAlertView *asdf=[[UIAlertView alloc]initWithTitle:string
                                                message:message
                                               delegate:alertView==nil ? nil : A
                                      cancelButtonTitle:cancelButtonTitle
                                      otherButtonTitles:otherButtonTitles, nil];
    
    asdf.alertViewStyle = style;
    if (style == UIAlertViewStylePlainTextInput) {
        UITextField *tf=[asdf textFieldAtIndex:0];
        tf.delegate = A;
    }
    [asdf show];
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{
//    NSLog(@"改变了值000");
//    NSLog(@"改变了值%@",[[UITextInputMode currentInputMode] primaryLanguage]);
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
//        NSLog(@"改变了值222");
        return NO;
    }
    return YES;
}
@end
