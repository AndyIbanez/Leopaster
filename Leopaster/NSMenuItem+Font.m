//
//  NSMenuItem+Font.m
//  Leopaster
//
//  Created by Sergio Andrés Ibañez Kautsch on 1/1/14.
//  Copyright (c) 2014 Fairese Technologies. All rights reserved.
//

#import "NSMenuItem+Font.h"

@implementation NSMenuItem (Font)

-(void)setBoldStyle:(bool)bBold
{
    NSString* title = [self title] ;
    
    NSFont *pFont = (bold)?[NSFont boldSystemFontOfSize:14]:[NSFont menuFontOfSize:12];
    
    NSDictionary* fontAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                   pFont, NSFontAttributeName,
                                   nil] ;
    
    NSMutableAttributedString* newTitle = [[NSMutableAttributedString alloc] initWithString:title
                                                                                 attributes:fontAttribute] ;
    
    [self setAttributedTitle:newTitle] ;
    
}
@end