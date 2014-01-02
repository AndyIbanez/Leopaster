//
//  UIColor+HexString.h
//  Leopaster
//
//  Created by Sergio Andrés Ibañez Kautsch on 1/2/14.
//  Copyright (c) 2014 Fairese Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSColor (HexString)

+ (NSColor *)colorFromHexString:(NSString *)hexString;

@end
