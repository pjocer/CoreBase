//
//  CoreTextField.m
//  CoreUser
//
//  Created by Demi on 10/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "CoreTextField.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <TXFire/TXFire.h>
#import <Masonry/Masonry.h>
#import "UIFont+BaseStyle.h"
#import "UIColor+BaseStyle.h"

@interface CoreTextField () <UITextFieldDelegate>
@property (nonatomic, strong) UIColor *originalTextColor;
@property (nonatomic, weak) UILabel *customPlaceholderLabel;
@property (nonatomic, assign) CGFloat animationTranslation;
@property (nonatomic, assign, readonly, getter=isRaised) BOOL raised;
@property (nonatomic, strong) UIColor *placeholderTextColor;
@property (nonatomic, strong) UIFont *placeholderFont;
@property (nonatomic, strong) UIColor *raisedPlaceholderTextColor;
@property (nonatomic, strong) UIFont *raisedPlaceholderFont;
@property (nonatomic, strong) UIColor *invalidPlaceholderTextColor;
@end

@implementation CoreTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self.configureDefaultStyle.addCustomPlaceholderLabel.subscribe updateStyle];
}

#pragma mark - configure views and update styles

- (instancetype)configureDefaultStyle {
    self.font = [UIFont systemFontOfSize:UIFontSmallSize];
    self.delegate = self;
    self.originalTextColor = [UIColor tx_colorWithHex:TextColorHex];
    _animationTranslation = 20.f;
    _invalidPlaceholderTextColor = [UIColor redColor];
    _placeholderFont = [UIFont systemFontOfSize:UIFontSmallSize];
    _placeholderTextColor = [UIColor tx_colorWithHex:LightTextColorHex];
    _raisedPlaceholderTextColor = self.placeholderTextColor;
    _raisedPlaceholderFont = [UIFont boldSystemFontOfSize:UIFontExtraSmallSize];
    return self;
}

- (instancetype)addCustomPlaceholderLabel {
    UILabel *customPlaceholderLabel = [[UILabel alloc] init];
    _customPlaceholderLabel = customPlaceholderLabel;
    _customPlaceholderLabel.numberOfLines = 0;
    [self addSubview:customPlaceholderLabel];
    
    [customPlaceholderLabel mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.left.mas_equalTo(3);
        maker.right.equalTo(self);
        maker.bottom.mas_equalTo(-3);
    }];
    return self;
}

- (void)updateStyle {
    if (_raised) {
        self.customPlaceholderLabel.transform = CGAffineTransformMakeTranslation(-3, -self.animationTranslation);
        self.customPlaceholderLabel.font = self.raisedPlaceholderFont;
        self.customPlaceholderLabel.textColor = self.raisedPlaceholderTextColor;
    } else {
        self.customPlaceholderLabel.transform = CGAffineTransformIdentity;
        self.customPlaceholderLabel.font = self.placeholderFont;
        self.customPlaceholderLabel.textColor = self.isInvalid ? self.invalidPlaceholderTextColor : self.placeholderTextColor;
    }
    
    if (self.isInvalid) {
        self.textColor = [UIColor clearColor];
    } else {
        self.textColor = self.originalTextColor;
    }
}


#pragma mark - KVO

- (instancetype)subscribe {
    @weakify(self);
    RACSignal *customPlaceholderSignal = [[RACObserve(self, customPlaceholder) skip:1] filter:^BOOL(id  _Nullable value) {
        @strongify(self);
        return !self.isInvalid;
    }];
    RACSignal *invalidPlaceholderSignal = [[RACObserve(self, invalidPlaceholder) skip:1] filter:^BOOL(id  _Nullable value) {
        @strongify(self);
        return self.isInvalid;
    }];
    
    RACSignal *invalidSignal = [[[RACObserve(self, invalid) skip:1] doNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            [self resignFirstResponder];
        }
        [self updateRaiseWithAnimated:YES];
    }] map:^id _Nullable(NSNumber *  _Nullable value) {
        @strongify(self);
        return value.boolValue ? self.invalidPlaceholder : self.customPlaceholder;
    }];
    
    RAC(self, customPlaceholderLabel.text) = [RACSignal merge:@[customPlaceholderSignal, invalidPlaceholderSignal, invalidSignal]];
    
    [[self rac_signalForControlEvents:UIControlEventEditingChanged | UIControlEventEditingDidBegin] subscribeNext:^(UITextField *textField){
        @strongify(self);
        self.invalid = NO;
    }];
    return self;
}

#pragma mark - override setter

- (void)setText:(NSString *)text {
    [self setText:text animated:YES];
}

- (void)setText:(NSString *)text animated:(BOOL)animted {
    [super setText:text];
    [self updateRaiseWithAnimated:animted];
}

#pragma mark - raise

- (void)setRaised:(BOOL)raised animated:(BOOL)animated {
    if (_raised != raised && animated) {
        _raised = raised;
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut animations:^{
            [self updateStyle];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [self updateStyle];
    }
}

- (void)updateRaiseWithAnimated:(BOOL)animated {
    if (self.isInvalid) {
        [self setRaised:NO animated:animated];
    } else {
        [self setRaised:self.text.length > 0 animated:animated];
    }
}

#pragma mark - override styling methods

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    if (_hidesCaret) {
        return CGRectZero;
    }
    return [super caretRectForPosition:position];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (_disablesActionMenu) {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

#pragma mark - UITextFiledDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByAppendingString:string];
    text = [text substringToIndex:text.length-range.length];
    [self setText:text animated:text.length == 0 || textField.text.length == 0];
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
