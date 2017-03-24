//
//  DrilldropMenuView.m
//  base
//
//  Created by Demi on 24/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "DrilldropMenuView.h"
#import <TXFire/TXFire.h>
#import "UIView+SeparatorLine.h"
#import "NSString+Base.h"
#import <Masonry/Masonry.h>
#import "UIColor+BaseStyle.h"
#import "UIFont+BaseStyle.h"
#import "util.h"

const CGFloat DrilldropMenuViewExpectedHeight = 40.f;

#define DRILLDROP_ANIMATION_DURATION 0.3f

@interface DrilldropMenuView () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, copy) NSArray<UIButton *> *buttons;

@property (nonatomic, weak) UITapGestureRecognizer *tableViewTapGestureRecognizer;

@end

@implementation DrilldropMenuView

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
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.currentIndex = NSNotFound;
    self.backgroundColor = [UIColor whiteColor];
    self.separatorLinePosition = TXViewPositionTop | TXViewPositionBottom;
    @weakify(self);
    [[RACObserve(self, items) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self dismissDrilldropWithAnimated:NO];
        [self configureSubviews];
    }];
}

#pragma mark - utils

- (nullable DrilldropMenuItem *)currentItem
{
    if (_currentIndex == NSNotFound)
    {
        return nil;
    }
    return _items[_currentIndex];
}

- (void)configureSubviews
{
    NSUInteger count = _items.count;
    [_buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (count == 0)
    {
        return;
    }
    UIButton *lastButton = nil;
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:count];
    for (DrilldropMenuItem *item in _items)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted = NO;
        button.adjustsImageWhenDisabled = NO;
        
        [self configureButton:button forItem:item];
        /// layout
        [self addSubview:button];
        if (lastButton)
        {
            [button mas_makeConstraints:^(MASConstraintMaker *maker){
                maker.leading.equalTo(lastButton.mas_trailing);
                maker.top.and.bottom.equalTo(self);
                maker.width.equalTo(self).dividedBy(count);
            }];
            button.separatorLinePosition = TXViewPositionLeft;
        }
        else
        {
            [button mas_makeConstraints:^(MASConstraintMaker *maker){
                maker.leading.equalTo(self);
                maker.top.and.bottom.equalTo(self);
                maker.width.equalTo(self).dividedBy(count);
            }];
        }
        lastButton = button;
        [buttons addObject:button];
    }
    _buttons = buttons.copy;
}

- (void)configureButton:(UIButton *)button forItem:(DrilldropMenuItem *)item
{
    [button setAttributedTitle:[self createButtonTitleWithString:item.title] forState:UIControlStateNormal];
    [button setImage:item.image forState:UIControlStateNormal];
    [button setImage:item.selectedImage forState:UIControlStateSelected];
    
    @weakify(item, self, button);
    RAC(button, selected) = RACObserve(item, selected);
    [[[[RACObserve(item, selectedOptionIndex) skip:1] filter:^BOOL(id  _Nullable value) {
        @strongify(item);
        return item.usingOptionAsTitle;
    }] map:^id _Nullable(NSNumber *index) {
        @strongify(item);
        return item.options[index.integerValue].firstWord;
    }] subscribeNext:^(NSString *title) {
        @strongify(button, self);
        [button setAttributedTitle:[self createButtonTitleWithString:title] forState:UIControlStateNormal];
        [self layoutContentForButton:button];
    }];
    
    [self layoutContentForButton:button];
    
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
        @strongify(self);
        NSUInteger idx = [self.buttons indexOfObject:x];
        NSCAssert(idx != NSNotFound, @"cann't find index of button in self.buttons, maybe wrongs for setup self.buttons");
    
        [(RACSubject *)self.items[idx].didClickSignal sendNext:self.items[idx]];
        
        if (self.currentIndex == idx) // click same, do cancel
        {
            self.currentIndex = NSNotFound;
            [self setDrilldropHidden:YES animated:YES completion:NULL];
            return;
        }
        
        void(^action)(void) = ^{
            @strongify(self);
            self.currentIndex = idx;
            if (self.currentItem.options.count > 0)
            {
                [self.tableView reloadData];
                [self setDrilldropHidden:NO animated:YES completion:NULL];
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentItem.selectedOptionIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        };
        
        if (self.currentIndex != NSNotFound) // dismiss before
        {
            [self setDrilldropHidden:YES animated:YES completion:^(BOOL finished) {
                action();
            }];
        }
        else
        {
            action();
        }
    }];
}

- (NSAttributedString *)createButtonTitleWithString:(NSString *)string
{
    return [[NSAttributedString alloc] initWithString:string
                                           attributes:@{NSForegroundColorAttributeName: [UIColor tx_colorWithHex:TextColorHex],
                                                        NSFontAttributeName: [UIFont systemFontOfSize:UIFontNormalSize]}];
}

- (void)layoutContentForButton:(UIButton *)button
{
    CGFloat offset = 3.f;
    
    button.contentEdgeInsets = UIEdgeInsetsMake(0, offset, 0, offset);
    
    CGFloat textWidth = button.titleLabel.intrinsicContentSize.width + offset;
    CGFloat imageWidth = button.imageView.intrinsicContentSize.width + offset;
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0.f, - imageWidth, 0.f, imageWidth);
    button.imageEdgeInsets = UIEdgeInsetsMake(0.f, textWidth , 0.f, -textWidth);
}

#pragma mark - gesture recognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    for (UIView *cell in self.tableView.visibleCells)
    {
        if ([cell pointInside:[touch locationInView:cell] withEvent:nil])
        {
            return NO;
        }
    }
    return YES;
}

#pragma mark - drop

/// will setup self.currentIndex
- (void)dismissDrilldropWithAnimated:(BOOL)aniamted
{
    self.currentIndex = NSNotFound;
    [self hideDrilldropWithAnimated:aniamted completion:NULL];
}

- (void)hideDrilldropWithAnimated:(BOOL)animated completion:(void(^)(BOOL finished))completion
{
    if (!_tableView || !_tableView.superview)
    {
        if (completion) completion(YES);
        return;
    }
    
    if (animated)
    {
        [UIView animateWithDuration:DRILLDROP_ANIMATION_DURATION
                         animations:^{
                             self.tableView.tx_height = 0.f;
                             self.maskView.alpha = 0.f;
                         } completion:^(BOOL finished) {
                             [self.tableView removeFromSuperview];
                             [self.maskView removeFromSuperview];
                             if (completion)
                             {
                                 completion(finished);
                             }
                         }];
    }
    else
    {
        [self.tableView removeFromSuperview];
        [self.maskView removeFromSuperview];
        if (completion) completion(YES);
    }
}

- (void)showDrilldropWithAnimated:(BOOL)animated completion:(void(^)(BOOL finished))completion
{
    if (!self.window)
    {
        if (completion) completion(NO);
        return;
    }
    CGRect selfFrame = [self.window convertRect:self.bounds fromView:self];
    CGRect finalFrame;
    {
        finalFrame.origin.x = 0;
        finalFrame.origin.y = CGRectGetMaxY(selfFrame) - 1; // -1 for hides the UITableView separator
        finalFrame.size.width = self.window.tx_width;
        finalFrame.size.height = self.window.tx_height - finalFrame.origin.y;
    }
    
    {
        if (!_maskView)
        {
            UIView *maskView = [[UIView alloc] initWithFrame:finalFrame];
            maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
            _maskView = maskView;
        }
        _maskView.frame = finalFrame;
        _maskView.alpha = 0.f;
        if (!_maskView.superview)
        {
            [self.window addSubview:_maskView];
        }
    }
    {
        CGRect initialFrame = finalFrame;
        initialFrame.size.height = 0.f;
        if (!_tableView)
        {
            UITableView *tableView = [[UITableView alloc] initWithFrame:initialFrame style:UITableViewStyleGrouped];
            tableView.scrollsToTop = NO;
            tableView.alwaysBounceVertical = NO;
            UITapGestureRecognizer *tap = tableView.tx_tapGestureRecognizer;
            self.tableViewTapGestureRecognizer = tap;
            tap.delegate = self;
            [tap addTarget:self action:@selector(handleTap:)];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.delegate = self;
            tableView.dataSource = self;
            _tableView = tableView;
        }
        _tableView.frame = initialFrame;
        if (!_tableView.superview)
        {
            [self.window addSubview:_tableView];
        }
    }
    
    if (animated)
    {
        [UIView animateWithDuration:DRILLDROP_ANIMATION_DURATION
                         animations:^{
                             self.tableView.frame = finalFrame;
                             self.maskView.alpha = 1.f;
                         } completion:^(BOOL finished) {
                             if (completion) completion(finished);
                         }];
    }
    else
    {
        self.tableView.frame = finalFrame;
        self.maskView.alpha = 1.f;
        if (completion) completion(YES);
    }
}

- (void)setDrilldropHidden:(BOOL)hidden animated:(BOOL)animated completion:(void(^)(BOOL finished))completion
{
    if (hidden)
    {
        [self hideDrilldropWithAnimated:animated completion:completion];
    }
    else
    {
        [self showDrilldropWithAnimated:animated completion:completion];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    [self dismissDrilldropWithAnimated:YES];
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentItem.options.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const kReuseId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseId];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReuseId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        cell.textLabel.font = [UIFont systemFontOfSize:UIFontNormalSize];
        [RACObserve(cell, selected) subscribeNext:^(NSNumber *selected) {
            if (selected.boolValue)
            {
                cell.textLabel.textColor = [UIColor tx_colorWithHex:AzazieColorHex];
                cell.accessoryView = [[UIImageView alloc] initWithImage:BaseImageWithNamed(@"checkmark")];
            }
            else
            {
                cell.textLabel.textColor = [UIColor tx_colorWithHex:TextColorHex];
                cell.accessoryView = nil;
            }
        }];
    }
    DrilldropMenuItem *item = self.currentItem;
    cell.textLabel.text = item.options[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DrilldropMenuItem *item = _items[_currentIndex];
    [item setValue:@(indexPath.row) forKey:@keypath(item, selectedOptionIndex)];
    [tableView cellForRowAtIndexPath:indexPath].selected = YES;
    
    [self dismissDrilldropWithAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
}

@end
