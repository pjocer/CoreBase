//
//  CustomNavigationBarViewController.h
//  mobile
//
//  Created by Demi on 13/03/2017.
//  Copyright © 2017 azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavigationBarViewController : UIViewController

/// A navigationItem pushed yet.
@property (nonatomic, readonly, strong) UINavigationBar *navigationBar;

- (void)backlizeLeftBarButtonItem;



@end
