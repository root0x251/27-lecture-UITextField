//
//  ViewController.m
//  27.UITextField
//
//  Created by Slava on 26.05.17.
//  Copyright © 2017 Slava. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()  <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
- (IBAction)loginText:(UIButton *)sender;
- (IBAction)textChangetAction:(UITextField *)sender;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameTextField.placeholder = @"Имя";
    self.nameTextField.textAlignment = NSTextAlignmentLeft;
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.nameTextField becomeFirstResponder];
    
    self.lastNameTextField.placeholder = @"Фамилия";
    self.lastNameTextField.textAlignment = NSTextAlignmentLeft;
    self.lastNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(notificationTextDidBeginEditing:)
                               name:UITextFieldTextDidBeginEditingNotification
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(notificationTextDidEndEditing:)
                               name:UITextFieldTextDidEndEditingNotification
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(notificationTextDidChang:)
                               name:UITextFieldTextDidChangeNotification
                             object:nil];

}
//+++++++++++++
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated. 
}


- (IBAction)loginText:(UIButton *)sender {
    NSLog(@"Имя: %@ \nФамилия: %@", self.nameTextField.text, self.lastNameTextField.text);
    if ([self.nameTextField isFirstResponder]) {
        [self.nameTextField resignFirstResponder];
    } else if ([self.lastNameTextField isFirstResponder]) {
        [self.lastNameTextField resignFirstResponder];
    }
}

- (IBAction)textChangetAction:(UITextField *)sender {
    NSLog(@"%@", sender.text);

}

#pragma mark - UITextFieldDelegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    return [textField isEqual:self.nameTextField];
//}
//
//- (BOOL)textFieldShouldClear:(UITextField *)textField {
//    return NO;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // becomeFirstResponder место где стоит курсор
    if ([textField isEqual:self.nameTextField]) {       // если курсор стоит на self.nameTextField
        [self.lastNameTextField becomeFirstResponder];  // при нажатии на клавишу next мы переключаемся на поле self.lastNameTextField
    } else {
        [textField resignFirstResponder];               // при нажатии на клавишу return закрываем клавиатуру (убираем курсор)
    }
    
    return YES;
}

#pragma mark - Notification

- (void)notificationTextDidBeginEditing:(NSNotification *)notification {
    NSLog(@"notificationTextDidBeginEditing");
}

- (void)notificationTextDidEndEditing:(NSNotification *)notification {
    NSLog(@"notificationTextDidEndEditing");
}

- (void)notificationTextDidChang:(NSNotification *)notification {
    NSLog(@"notificationTextDidChang");
}

@end
