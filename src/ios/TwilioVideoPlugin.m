/********* TwilioVideo.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "TwilioVideoViewController.h"

@interface TwilioVideoPlugin : CDVPlugin

@property (nonatomic, copy) NSString* callbackId;

@end

@implementation TwilioVideoPlugin

- (void)openRoom:(CDVInvokedUrlCommand*)command {
    NSString* token = command.arguments[0];
    NSString* room = command.arguments[1];

    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"TwilioVideo" bundle:nil];
        TwilioVideoViewController *vc = [sb instantiateViewControllerWithIdentifier:@"TwilioVideoViewController"];

        //vc.accessToken = token;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [vc.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissTwilioVideoController)]];


        [self.viewController presentViewController:nav animated:YES completion:^{
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"];
            [pluginResult setKeepCallbackAsBool:YES];

            [vc connectToRoom:room token:token];

            self.callbackId = command.callbackId;
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
        }];
    });

}

- (void) dismissTwilioVideoController {
    [self.viewController dismissViewControllerAnimated:YES completion:nil];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"DONE"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

@end
