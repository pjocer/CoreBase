//
//  FontMacros.h
//  LPTemplate
//
//  Created by Jocer on 2018/1/3.
//  Copyright © 2018年 Jocer. All rights reserved.
//

#ifndef FontMacros_h
#define FontMacros_h
#define __font__(n,s) [UIFont fontWithName:@n size:s]
#ifdef UIFontMake
#undef UIFontMake
#endif
#define UIFontMake(s) __font__("FunctionPro-Book",s)
#ifdef UIFontBoldMake
#undef UIFontBoldMake
#endif
#define UIFontBoldMake(s) __font__("FunctionPro-Demi",s)
#define UIFontMediumBoldMake(s) __font__("FunctionPro-Medium",s)
#ifndef UIFontObliqueMake
#define UIFontObliqueMake(s) __font__("FunctionPro-BookOblique",s)
#endif
#ifndef UIFontBaskervilleMake
#define UIFontBaskervilleMake(s) __font__("LibreBaskerville-Regular",s)
#endif

#endif /* FontMacros_h */
