//
//  UIFont+LQFont.m
//  Pods
//
//  Created by Jocer on 2018/1/10.
//

#import "UIFont+LQFont.h"
#import "util.h"
#import <CoreText/CTFontManager.h>
@implementation UIFont (LQFont)

+ (UIFont *)dynamic_fontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    if (!font) {
        [UIFont dynamicallyLoadFontNamed:fontName];
        font = [UIFont fontWithName:fontName size:fontSize];
        if (!font) font = [UIFont systemFontOfSize:fontSize];
    }
    return font;
}

+ (void)dynamicallyLoadFontNamed:(NSString *)name {
    NSString *resourcePath = BasePathForResource(name, @"ttf");
    NSURL *url = [NSURL fileURLWithPath:resourcePath];
    NSData *fontData = [NSData dataWithContentsOfURL:url];
    if (fontData) {
        CFErrorRef error;
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            NSLog(@"Failed to load font: %@", errorDescription);
            CFRelease(errorDescription);
        }
        CFRelease(font);
        CFRelease(provider);
    }
}

@end
