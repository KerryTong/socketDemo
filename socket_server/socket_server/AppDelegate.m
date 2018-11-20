//
//  AppDelegate.m
//  socket_server
//
//  Created by 仝兴伟 on 2018/11/19.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@property (nonatomic, strong) OneViewController *one;


@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    [self checkViewController:self.one];
    
    
}

- (void)checkViewController:(NSViewController *)viewcontroller{
    NSWindow *loginWindow = [NSWindow windowWithContentViewController:viewcontroller];
    self.mainWindow = [[NSWindowController alloc]initWithWindow:loginWindow];
    viewcontroller.view.window.windowController = self.mainWindow;
    [self.mainWindow.window makeKeyAndOrderFront:self];
    [self.mainWindow.window center];
    [self.mainWindow showWindow:nil];
}


-(OneViewController *)one {
    if (!_one) {
        _one = [[OneViewController alloc]init];
    }
    return _one;
}

@end
