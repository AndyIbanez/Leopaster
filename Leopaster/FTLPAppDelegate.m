//
//  FTLPAppDelegate.m
//  Leopaster
//
//  Created by Sergio Andrés Ibañez Kautsch on 1/1/14.
//  Copyright (c) 2014 Fairese Technologies. All rights reserved.
//

#import "FTLPAppDelegate.h"
#import "NSMenuItem+Font.h"

@implementation FTLPAppDelegate

static NSString *expiringDefaults = @"com.fairese.ios.Leopaster.defaults.Expiration";

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    
    self.leopasterItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];
    [self.leopasterItem setImage:[NSImage imageNamed:@"leopaster"]];
    [self.leopasterItem setTitle:@"Leopaster"];
    [self.leopasterItem setHighlightMode:YES];
    
    self.pasterMenu = [[NSMenu alloc] initWithTitle:@"Leopaster"];
    //NSDictionary *languages = [NSUnarchiver unarchiveObjectWithFile:];
    
    //It's likely the languages list may or may not be updated frequently, so we are just going to download it when the app launches, if we don't already have a copy of it.
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *applicationSupportDirectory = [paths objectAtIndex:0];
    NSString *inLibraryPath = [NSString stringWithFormat:@"%@/Leopaster/com.fairese.ios.Leopaster.languagesList", applicationSupportDirectory];
    if(![[NSFileManager defaultManager] fileExistsAtPath:inLibraryPath])
    {
        NSMenuItem *downloadingItem = [[NSMenuItem alloc] initWithTitle:@"Downloading Languages..." action:nil keyEquivalent:@""];
        [self.pasterMenu addItem:downloadingItem];
        
        [self.leopasterItem setMenu:self.pasterMenu];
        NSMenuItem *aboutItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"About This App", nil)
                                                           action:@selector(aboutThisApp)
                                                    keyEquivalent:@""];
        
        NSMenuItem *refreshItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Refresh Languages", nil)
                                                             action:@selector(refreshLanguages)
                                                      keyEquivalent:@""];
        
        [self.pasterMenu addItem:aboutItem];
        [self.pasterMenu addItem:refreshItem];
        [self.pasterMenu addItem:[NSMenuItem separatorItem]];
        [self downloadLanguages:^(NSDictionary *languagesDir, NSError *error) {
            if(error != nil)
            {
                NSUserNotification *errorNotif = [[NSUserNotification alloc] init];
                errorNotif.title = NSLocalizedString(@"Languages Error", nil);
                errorNotif.informativeText = NSLocalizedString(@"An error has occured downloading the available languages list. Please refresh the list to try again.", nil);
                errorNotif.deliveryDate = [NSDate dateWithTimeInterval:3 sinceDate:[NSDate date]];
                [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:errorNotif];
            }else
            {
                [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/Leopaster", applicationSupportDirectory, nil]
                                          withIntermediateDirectories:YES
                                                           attributes:nil
                                                                error:nil];
                languages = languagesDir;
                [NSKeyedArchiver archiveRootObject:languages toFile:inLibraryPath];
                [self refreshMenu];
            }
        }];
    }else
    {
        languages = [NSKeyedUnarchiver unarchiveObjectWithFile:inLibraryPath];
        [self refreshMenu];
    }
    
}

-(void)clickSelectedLanguage:(id)sender
{

}

-(void)downloadLanguages:(void (^)(NSDictionary *languagesDir, NSError *error))completion;
{
    NSURL *languagesUrl = [NSURL URLWithString:@"https://ghostbin.com/languages.json"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:languagesUrl];
    [req setHTTPMethod:@"GET"];
    NSOperationQueue *conQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:conQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        NSError *error = nil;
        NSDictionary *jsonDir = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        completion(jsonDir, error);
    }];
}

-(void)setExpirationWithSender:(id)sender
{
    NSMenuItem *sndr = (NSMenuItem *)sender;
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:expiringDefaults] isEqualToString:sndr.title])
    {
        [[NSUserDefaults standardUserDefaults] setObject:sndr.title forKey:expiringDefaults];
        [self refreshMenu];
    }
}

-(void)refreshMenu
{
    [self.pasterMenu removeAllItems];
    
    NSMenuItem *aboutItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"About This App", nil)
                                                   action:@selector(aboutThisApp)
                                            keyEquivalent:@""];
    
    NSMenuItem *refreshItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Refresh Languages", nil)
                                                         action:@selector(refreshLanguages)
                                                  keyEquivalent:@""];
    
    NSMenuItem *expirationTitle = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Expire", nil)
                                                             action:nil
                                                      keyEquivalent:@""];
    [expirationTitle setBoldStyle:YES];
    
    NSMenuItem *undefined = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Undefined", nil)
                                                      action:@selector(setExpirationWithSender:)
                                               keyEquivalent:@""];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:expiringDefaults] == nil)
    {
        [undefined setState:NSOnState];
        [[NSUserDefaults standardUserDefaults] setObject:NSLocalizedString(@"Undefined", nil) forKey:expiringDefaults];
    }
    
    NSMenuItem *fiveMins = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"5 Minutes", nil)
                                                      action:@selector(setExpirationWithSender:)
                                               keyEquivalent:@""];
    
    NSMenuItem *fifteenMins = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"15 Minutes", nil)
                                                      action:@selector(setExpirationWithSender:)
                                               keyEquivalent:@""];
    
    NSMenuItem *thirteenMins = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"30 Minutes", nil)
                                                         action:@selector(setExpirationWithSender:)
                                                  keyEquivalent:@""];
    
    NSMenuItem *anHour = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"1 Hour", nil)
                                                          action:@selector(setExpirationWithSender:)
                                                   keyEquivalent:@""];
    
    NSMenuItem *twoHour = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"2 Hours", nil)
                                                    action:@selector(setExpirationWithSender:)
                                             keyEquivalent:@""];
    
    NSMenuItem *sixHour = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"6 Hours", nil)
                                                     action:@selector(setExpirationWithSender:)
                                              keyEquivalent:@""];
    
    NSMenuItem *oneDay = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"1 Day", nil)
                                                     action:@selector(setExpirationWithSender:)
                                              keyEquivalent:@""];
    
    NSMenu *expiryMenu = [[NSMenu alloc] initWithTitle:NSLocalizedString(@"Expire In...", nil)];
    
    [self.pasterMenu addItem:aboutItem];
    [self.pasterMenu addItem:refreshItem];
    [self.pasterMenu addItem:[NSMenuItem separatorItem]];
    
    [self.pasterMenu addItem:expirationTitle];
    [expirationTitle setSubmenu:expiryMenu];
    
    [expiryMenu addItem:undefined];
    [expiryMenu addItem:fiveMins];
    [expiryMenu addItem:fifteenMins];
    [expiryMenu addItem:thirteenMins];
    [expiryMenu addItem:anHour];
    [expiryMenu addItem:twoHour];
    [expiryMenu addItem:sixHour];
    [expiryMenu addItem:oneDay];
    
    //Mark the expiration we are currently using.
    for(NSMenuItem *exp in expiryMenu.itemArray)
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:expiringDefaults] isEqualToString:exp.title])
        {
            [exp setState:NSOnState];
            break;
        }
    }
    
    [self.pasterMenu addItem:[NSMenuItem separatorItem]];
    
    for(NSDictionary *item in languages)
    {
        NSMenuItem *category = [[NSMenuItem alloc] initWithTitle:item[@"name"]
                                                          action:nil
                                                   keyEquivalent:@""];
        [category setBoldStyle:YES];
        
        NSMenu *languagesForCategory = [[NSMenu alloc] initWithTitle:item[@"name"]];
        
        for(NSDictionary *lang in item[@"languages"])
        {
            NSMenuItem *languageItem = [[NSMenuItem alloc] initWithTitle:lang[@"name"]
                                                                  action:@selector(clickSelectedLanguage:)
                                                           keyEquivalent:@""];
            [languagesForCategory addItem:languageItem];
        }
        [self.pasterMenu addItem:category];
        [category setSubmenu:languagesForCategory];
    }
    [self.leopasterItem setMenu:self.pasterMenu];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

@end
