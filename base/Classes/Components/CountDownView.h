//
//  CountDownView.h
//  mobile
//
//  Created by Jocer on 2018/6/15.
//  Copyright © 2018年 azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CountDownViewDelegate;

@interface CountDownView : UIView

@property (nonatomic, assign) NSTimeInterval countDownTimeInterval;

@property (nonatomic) UIColor *textColor;

@property (nonatomic) UIImage *backgroundImage;

@property (nonatomic) UIColor *themeColor;

@property (nonatomic) UIColor *colonColor;

@property (nonatomic) UIFont *textFont;

@property (nonatomic) UIColor *labelBorderColor;

@property (nonatomic, weak) id <CountDownViewDelegate> delegate;

@property (nonatomic, assign) BOOL recoderTimeIntervalDidInBackground;

- (void)stopCountDown;
@end

@protocol CountDownViewDelegate <NSObject>

- (void)countDownDidFinished;

@end
