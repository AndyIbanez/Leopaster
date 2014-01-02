//
//  UIColor+HexString.m
//  Leopaster
//
//  Created by Sergio Andrés Ibañez Kautsch on 1/2/14.
//  Copyright (c) 2014 Fairese Technologies. All rights reserved.
//

#import "NSColor+HexString.h"

@implementation NSColor (HexString)

// Assumes input like "#00FF00" (#RRGGBB).
+ (NSColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [NSColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
