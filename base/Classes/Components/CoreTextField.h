//
//  CoreTextField.h
//  CoreUser
//
//  Created by Demi on 10/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoreTextField : UITextField
@property (nonatomic, assign, getter=isInvalid) BOOL invalid;
@property (nonatomic, copy) NSString *customPlaceholder;
@property (nonatomic, copy) NSString *invalidPlaceholder;

- (void)setText:(NSString *)text animated:(BOOL)animted;

@end

@class RACSubject;
@interface CoreTextField (Helper)
@property (nonatomic, assign) BOOL hidesCaret;
@property (nonatomic, assign) BOOL disablesActionMenu;
@property (nonatomic, assign) BOOL disableChangeCharacters;
@property (nonatomic, readonly) RACSubject *didClickedReturn;
@end
