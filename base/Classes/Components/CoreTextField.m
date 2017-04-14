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

@interface CoreTextField ()

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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self configureDefaultStyle];
    [self addCustomPlaceholderLabel];
    [self configureKVO];
    
    @weakify(self);
    
    
    [[self rac_signalForControlEvents:UIControlEventEditingChanged | UIControlEventEditingDidBegin] subscribeNext:^(UITextField *textField){
        @strongify(self);
        self.invalid = NO;
        [self updateRaiseWithAnimated:YES];
    }];
    
    [self updateStyle];
}

#pragma mark - configure views and update styles

- (void)configureDefaultStyle
{
    self.font = [UIFont systemFontOfSize:UIFontSmallSize];
    
    self.originalTextColor = [UIColor tx_colorWithHex:TextColorHex];
    
    _animationTranslation = 20.f;
    _invalidPlaceholderTextColor = [UIColor redColor];
    
    _placeholderFont = [UIFont systemFontOfSize:UIFontSmallSize];
    _placeholderTextColor = [UIColor tx_colorWithHex:LightTextColorHex];
    
    _raisedPlaceholderTextColor = self.placeholderTextColor;
    _raisedPlaceholderFont = [UIFont boldSystemFontOfSize:UIFontExtraSmallSize];
}

- (void)addCustomPlaceholderLabel
{
    UILabel *customPlaceholderLabel = [[UILabel alloc] init];
    _customPlaceholderLabel = customPlaceholderLabel;
    [self addSubview:customPlaceholderLabel];
    
    [customPlaceholderLabel mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)updateStyle
{
    if (_raised)
    {
        self.customPlaceholderLabel.transform = CGAffineTransformMakeTranslation(0, -self.animationTranslation);
        self.customPlaceholderLabel.font = self.raisedPlaceholderFont;
        self.customPlaceholderLabel.textColor = self.raisedPlaceholderTextColor;
    }
    else
    {
        self.customPlaceholderLabel.transform = CGAffineTransformIdentity;
        self.customPlaceholderLabel.font = self.placeholderFont;
        self.customPlaceholderLabel.textColor = self.isInvalid ? self.invalidPlaceholderTextColor : self.placeholderTextColor;
    }
    
    if (self.isInvalid)
    {
        self.textColor = [UIColor clearColor];
    }
    else
    {
        self.textColor = self.originalTextColor;
    }
}


#pragma mark - KVO

- (void)configureKVO
{
    @weakify(self);
//    RAC(self, customPlaceholderLabel.text) = [[RACObserve(self, customPlaceholder) skip:1] filter:^BOOL(id  _Nullable value) {
//        @strongify(self);
//        return !self.isInvalid;
//    }];
    
//    RAC(self, customPlaceholderLabel.text) = [[RACObserve(self, invalidPlaceholder) skip:1] filter:^BOOL(id  _Nullable value) {
//        @strongify(self);
//        return self.isInvalid;
//    }];
    
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
        [self updateRaiseWithAnimated:NO];
    }] map:^id _Nullable(NSNumber *  _Nullable value) {
        @strongify(self);
        return value.boolValue ? self.invalidPlaceholder : self.customPlaceholder;
    }];
    
    RAC(self, customPlaceholderLabel.text) = [RACSignal merge:@[customPlaceholderSignal, invalidPlaceholderSignal, invalidSignal]];
    
//    [[RACObserve(self, invalid) skip:1] subscribeNext:^(NSNumber *  _Nullable x) {
//        @strongify(self);
//        BOOL invalid = x.boolValue;
//        if (invalid)
//        {
//            self.customPlaceholderLabel.text = self.invalidPlaceholder;
//        }
//        else
//        {
//            self.customPlaceholderLabel.text = self.customPlaceholder;
//        }
//        [self updateRaiseWithAnimated:NO];
//    }];
}

#pragma mark - override setter

- (void)setText:(NSString *)text
{
    [self setText:text animated:NO];
}

- (void)setText:(NSString *)text animated:(BOOL)animted
{
    [super setText:text];
    [self updateRaiseWithAnimated:animted];
}

#pragma mark - raise

- (void)setRaised:(BOOL)raised animated:(BOOL)animated
{
    if (_raised != raised)
    {
        _raised = raised;
        if (animated)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self updateStyle];
            }];
        }
        else
        {
            [self updateStyle];
        }
    }
}

- (void)updateRaiseWithAnimated:(BOOL)animated
{
    if (self.isInvalid)
    {
        [self setRaised:NO animated:animated];
    }
    else
    {
        [self setRaised:self.text.length > 0 animated:animated];
    }
}

#pragma mark - override styling methods

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    if (_hidesCaret)
    {
        return CGRectZero;
    }
    return [super caretRectForPosition:position];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (_disablesActionMenu)
    {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

@end
