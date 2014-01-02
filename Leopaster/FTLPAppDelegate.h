//
//  FTLPAppDelegate.h
//  Leopaster
//
//  Created by Sergio Andrés Ibañez Kautsch on 1/1/14.
//  Copyright (c) 2014 Fairese Technologies. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FTLPAppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate, NSUserNotificationCenterDelegate>
{
    NSDictionary *languages;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, strong) NSStatusItem *leopasterItem;
@property (nonatomic, strong) NSMenu *pasterMenu;
@property (nonatomic, strong) NSWindow *aboutWindow;

-(void)clickSelectedLanguage:(id)sender;
-(void)downloadLanguages:(void (^)(NSDictionary *languagesDir, NSError *error))completion;
-(void)refreshMenu;
-(void)setExpirationWithSender:(id)sender;

-(void)aboutThisApp;
-(void)refreshLanguages;

-(void)sendNotificationWithTitle:(NSString *)title andDescription:(NSString *)description;

@end
