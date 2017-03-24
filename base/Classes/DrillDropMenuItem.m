//
//  DrilldropMenuItem.m
//  base
//
//  Created by Demi on 24/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "DrilldropMenuItem.h"

@implementation DrilldropMenuItem

@synthesize didClickSignal = _didClickSignal;

- (instancetype)initWithTitle:(NSString *)title options:(NSArray<NSString *> *)options image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    return [self initWithTitle:title options:options image:image selectedImage:selectedImage initialOptionIndex:0];
}

- (instancetype)initWithTitle:(NSString *)title options:(NSArray<NSString *> *)options image:(UIImage *)image selectedImage:(UIImage *)selectedImage initialOptionIndex:(NSUInteger)initialOptionIndex
{
    self = [super init];
    if (self)
    {
        _title = [title copy];
        _options = [options copy];
        _image = image;
        _selectedImage = selectedImage;
        _selectedOptionIndex = initialOptionIndex;
    }
    return self;
}

- (RACSignal<DrilldropMenuItem *> *)didClickSignal
{
    if (!_didClickSignal)
    {
        _didClickSignal = [RACSubject subject];
    }
    return _didClickSignal;
}

@end
