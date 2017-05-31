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


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
//    NSLog(@"textField text: %@", textField.text);
//    NSLog(@"shouldChangeCharactersInRange: %@", NSStringFromRange(range));
//    NSLog(@"string: %@", string);
    
    
//    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@" ,"];
//    NSCharacterSet *set = [[NSCharacterSet decimalDigitCharacterSet] invertedSet]; // используем все кроме цифр (invertedSet инвертирует)
//    NSArray *words = [resultString componentsSeparatedByString:@" "];
//    NSArray *words = [resultString componentsSeparatedByCharactersInSet:set];
//    NSLog(@"words: %@", words);
//    return [resultString length] <= 10; // ограничение на вводимые символы

    
    NSCharacterSet *validSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray *components = [string componentsSeparatedByCharactersInSet:validSet];
    if ([components count] > 1) {
        return NO;
    } else {
        NSLog(@"VALID");
    }
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"new String fixed: %@", newString);

    NSArray *validComponents = [newString componentsSeparatedByCharactersInSet:validSet];
    newString = [validComponents componentsJoinedByString:@""];
    // создаем константы
    static const int localNumberMaxLenght = 7;
    static const int areaCodeMaxLenght = 3;
    static const int countryCodeMaxLenght = 3;
    
    if ([newString length] > localNumberMaxLenght + areaCodeMaxLenght + countryCodeMaxLenght) {
        return  NO;
    }
    
    NSMutableString *resultString = [NSMutableString new];
    
    NSInteger localNumberLenght = MIN([newString length], localNumberMaxLenght);
    if (localNumberLenght > 0) {
        NSString *number = [newString substringFromIndex:(int)[newString length] - localNumberLenght];
        [resultString appendString:number];
        if ([resultString length] > 3) {
            [resultString insertString:@"-" atIndex:3];
        }
    }
    if ([newString length] > localNumberMaxLenght) {
        NSInteger areaCodeLenght = MIN((int)[newString length] - localNumberMaxLenght, localNumberMaxLenght);
        NSRange areaRange = NSMakeRange((int)[newString length] - localNumberMaxLenght - areaCodeLenght, areaCodeLenght);
        NSString *area = [newString substringWithRange:areaRange];
        area = [NSString stringWithFormat:@"(%@) ", area];
        [resultString insertString:area atIndex:0];
    }
    if ([newString length] > localNumberMaxLenght + areaCodeMaxLenght) {
        NSInteger countryCodeLenght = MIN((int)[newString length] - localNumberMaxLenght - areaCodeMaxLenght, countryCodeMaxLenght);
        NSRange countryCodeRange = NSMakeRange(0, countryCodeLenght);
        NSString *countryCode = [newString substringWithRange:countryCodeRange];
        countryCode = [NSString stringWithFormat:@"+%@ ", countryCode];
        [resultString insertString:countryCode atIndex:0];
    }
    
    textField.text = resultString;
    
    return NO;
}



#pragma mark - Notification

- (void)notificationTextDidBeginEditing:(NSNotification *)notification {
//    NSLog(@"notificationTextDidBeginEditing");
}

- (void)notificationTextDidEndEditing:(NSNotification *)notification {
//    NSLog(@"notificationTextDidEndEditing");
}

- (void)notificationTextDidChang:(NSNotification *)notification {
//    NSLog(@"notificationTextDidChang");
}

@end
