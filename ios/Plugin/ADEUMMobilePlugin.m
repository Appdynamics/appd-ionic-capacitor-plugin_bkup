//
//  Copyright (c) 2018 AppDynamics Technologies. All rights reserved.
//

/********* ADEUMMobilePlugin.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <ADEUMInstrumentation/ADEumInstrumentation.h>
#import <ADEUMInstrumentation/ADEumHTTPRequestTracker.h>
#import <ADEUMInstrumentation/ADEumServerCorrelationHeaders.h>
#import <ADEUMInstrumentation/ADEumSessionFrame.h>
#import "ADEUMPluginVersion.h"

@interface ADEUMMobilePlugin : CDVPlugin
@property (nonatomic, strong) ADEumAgentConfiguration *config;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *keymap;
@end

@implementation ADEUMMobilePlugin

// Manage keymap store
- (void)pluginInitialize {
    self.keymap = [[NSMutableDictionary alloc] initWithCapacity:0];
    // Load Agent configuration settings from info.plist
    NSDictionary *adeumSettings = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"ADEUM_Settings"];
    NSString *appKey = [adeumSettings objectForKey:@"ADEUM_APP_KEY"];
    NSString *collectorUrl = [adeumSettings objectForKey:@"ADEUM_COLLECTOR_URL"];
    NSString *screenshotUrl = [adeumSettings objectForKey:@"ADEUM_SCREENSHOT_URL"];
    NSString *screenshotsEnabled = [adeumSettings objectForKey:@"ADEUM_SCREENSHOTS_ENABLED"];
    NSNumber *loggingLevel = @([[adeumSettings objectForKey:@"ADEUM_LOGGING_LEVEL"] intValue]);
    NSString *reachabilityHost = [adeumSettings objectForKey:@"ADEUM_REACHABILITY_HOST"];
    NSNumber *interactionCaptureMode = @([[adeumSettings objectForKey:@"ADEUM_INTERACTION_CAPTURE_MODE"] intValue]);

    if (appKey) {
        // If appKey malformed this will throw exception.
        self.config = [[ADEumAgentConfiguration alloc] initWithAppKey:appKey];

        if (![self setCollectorUrl:collectorUrl]) {
            NSLog(@"Agent failed to start due to bad COLLECTOR_URL param.");
            return;
        }

        if (![self setLoggingLevel:loggingLevel]) {
            NSLog(@"Agent failed to start due to bad LOGGING_LEVEL param.");
            return;
        }

        if (![self setScreenshotsEnabled:screenshotsEnabled]) {
            NSLog(@"Agent failed to start due to bad SCREENSHOTS_ENABLED param.");
            return;
        }

        if (![self setScreenshotUrl:screenshotUrl]) {
            NSLog(@"Agent failed to start due to bad SCREENSHOT_URL param.");
            return;
        }

        if (![self setInteractionCaptureMode:interactionCaptureMode]) {
            NSLog(@"Agent failed to start due to bad INTERACTION_CAPTURE_MODE param.");
            return;
        }

        if (![self setReachabilityHostName:reachabilityHost]) {
            NSLog(@"Agent failed to start due to bad REACHABILITY_HOST param.");
            return;
        }

        [ADEumInstrumentation initWithConfiguration:_config a:ADEumPluginHybridAgentType b:ADEumPluginHybridAgentVersion];
        // Force generation of "App Start" beacon if API call is available
        SEL gabsSelector = NSSelectorFromString(@"generateAppStartBeacon");
        if ([ADEumInstrumentation respondsToSelector:gabsSelector]) {
            [ADEumInstrumentation performSelector:gabsSelector];
        } 
    }
}

- (void)dispose {
    [self.keymap removeAllObjects];
}

- (void)onAppTerminate {
    [self.keymap removeAllObjects];
}

- (void)onReset {
    [self.keymap removeAllObjects];
}

// Local Methods
- (void)getVersion:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *result = [self finalizeSuccessfulResult:ADEumPluginHybridAgentVersion];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

// Mobile Agent JS API interface
- (void)initWithConfiguration:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *result;

    @try {
        if ([command.arguments count] != 1) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C initWithConfiguration called -- bad command");
        } else {
            NSDictionary *settings = [command argumentAtIndex:0 withDefault:nil andClass:[NSDictionary class]];

            NSString *appKey = settings[@"appKey"];
            if (appKey) {
                // If appKey malformed this will throw exception.
                self.config = [[ADEumAgentConfiguration alloc] initWithAppKey:appKey];

                if (![self setCollectorUrl:settings[@"collectorUrl"]]) {
                    [self malformedArgument:@"collectorUrl" command:command];
                    return;
                }

                if (![self setLoggingLevel:settings[@"loggingLevel"]]) {
                    [self malformedArgument:@"loggingLevel" command:command];
                    return;
                }

                if (![self setScreenshotsEnabled:settings[@"screenshots"]]) {
                    [self malformedArgument:@"screenshotsEnabled" command:command];
                    return;
                }

                if (![self setScreenshotUrl:settings[@"screenshotUrl"]]) {
                    [self malformedArgument:@"screenshotUrl" command:command];
                    return;
                }

                if (![self setInteractionCaptureMode:settings[@"interactionCaptureMode"]]) {
                    [self malformedArgument:@"interactionCaptureMode" command:command];
                    return;
                }

                if (![self setReachabilityHostName:settings[@"reachabilityHostName"]]) {
                    [self malformedArgument:@"reachabilityHostName" command:command];
                    return;
                }

                [ADEumInstrumentation initWithConfiguration:_config a:ADEumPluginHybridAgentType b:ADEumPluginHybridAgentVersion];

                // Force generation of "App Start" beacon if API call is available
                SEL gabsSelector = NSSelectorFromString(@"generateAppStartBeacon");
                if ([ADEumInstrumentation respondsToSelector:gabsSelector]) {
                    [ADEumInstrumentation performSelector:gabsSelector];
                }

                result = [self finalizeSuccessfulResult:nil];
            }
        }

        NSLog(@"Obj-C initWithConfiguration called:%@", command.arguments);
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)initWithAppKey:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *result;

    @try {
        if ([command.arguments count] != 1) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C initWithAppKey called -- bad command");
        } else {
            NSString *appKey = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            if (appKey) {
                // If appKey malformed this will throw exception.
                self.config = [[ADEumAgentConfiguration alloc] initWithAppKey:appKey];
                [ADEumInstrumentation initWithConfiguration:_config a:ADEumPluginHybridAgentType b:ADEumPluginHybridAgentVersion];
                // Force generation of "App Start" beacon if API call is available
                SEL gabsSelector = NSSelectorFromString(@"generateAppStartBeacon");
                if ([ADEumInstrumentation respondsToSelector:gabsSelector]) {
                    [ADEumInstrumentation performSelector:gabsSelector];
                } 
                result = [self finalizeSuccessfulResult:nil];
            }
        }

        NSLog(@"Obj-C initWithAppKey called:%@", command.arguments);
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)changeAppKey:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *result;
    @try {
        if ([command.arguments count] != 1) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C changeAppKey called -- bad command");
        } else {
            NSString *appKey = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            if (appKey) {
                [ADEumInstrumentation changeAppKey:appKey];
                result = [self finalizeSuccessfulResult:nil];
            }
        }

        NSLog(@"Obj-C changeAppKey called:%@", command.arguments);
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)startTimerWithName:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *result;
    @try {
        if ([command.arguments count] != 1) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C startTimerWithName called -- bad command");
        } else {
            NSString *name = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            if (name) {
                [ADEumInstrumentation startTimerWithName:name];
                result = [self finalizeSuccessfulResult:nil];
            }
        }

        NSLog(@"Obj-C startTimerWithName called:%@", command.arguments);
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)stopTimerWithName:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *result;
    @try {
        if ([command.arguments count] != 1) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C stopTimerWithName called -- bad command");
        } else {
            NSString *name = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            if (name) {
                [ADEumInstrumentation stopTimerWithName:name];
                result = [self finalizeSuccessfulResult:nil];
            }
        }

        NSLog(@"Obj-C stopTimerWithName called:%@", command.arguments);
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)reportMetricWithName:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *result;
    @try {
        if ([command.arguments count] != 2) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C reportMetricWithName called -- bad command");
        } else {
            NSString *name = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            NSNumber *value = [command argumentAtIndex:1 withDefault:nil andClass:[NSNumber class]];
            if (name && value) {
                [ADEumInstrumentation reportMetricWithName:name value:[value longLongValue]];
                result = [self finalizeSuccessfulResult:nil];
            }
        }

        NSLog(@"Obj-C reportMetricWithName called:%@", command.arguments);
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)leaveBreadcrumb:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *result;
    @try {
        if ([command.arguments count] != 2) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C leaveBreadcrumb called -- bad command");
        } else {
            NSString *breadcrumb = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            NSNumber *mode = [command argumentAtIndex:1 withDefault:nil andClass:[NSNumber class]];
            if (breadcrumb && mode) {
                [ADEumInstrumentation leaveBreadcrumb:breadcrumb mode:[mode integerValue]];
                result = [self finalizeSuccessfulResult:nil];
            }
        }

        NSLog(@"Obj-C leaveBreadcrumb called:%@", command.arguments);
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)setUserData:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *result;
    @try {
        if ([command.arguments count] != 2) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C setUserData called -- bad command");
        } else {
            NSString *key = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            NSString *value = [command argumentAtIndex:1 withDefault:nil andClass:[NSString class]];
            if (key && value) {
                [ADEumInstrumentation setUserData:key value:value];
                result = [self finalizeSuccessfulResult:nil];
            }
        }

        NSLog(@"Obj-C setUserData called:%@", command.arguments);
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)removeUserData:(CDVInvokedUrlCommand *)command {
    NSLog(@"Obj-C removeUserData called:" );
    CDVPluginResult *result;
    @try {
        if ([command.arguments count] != 1) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C removeUserData called -- bad command");
        } else {
            NSString *key = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            if (key) {
                [ADEumInstrumentation removeUserData:key];
                result = [self finalizeSuccessfulResult:nil];
            }
        }

        NSLog(@"Obj-C removeUserData called:%@", command.arguments);
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)takeScreenshot:(CDVInvokedUrlCommand *)command {
    NSLog(@"Obj-C takeScreenshot called:" );
    [ADEumInstrumentation takeScreenshot];

    CDVPluginResult *result = [self finalizeSuccessfulResult:nil];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)beginCall:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *result;

    @try {
        if ([command.arguments count] != 3) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C beginCall called -- bad command");
        } else {
            NSString *name = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            NSString *selName = [command argumentAtIndex:1 withDefault:nil andClass:[NSString class]];

            NSInteger additionalArgumentCount = [[command arguments] count] - 2;
            NSArray *additionalArguments = nil;
            if (additionalArgumentCount > 0) {
                additionalArguments = [[command arguments] subarrayWithRange:NSMakeRange(2, additionalArgumentCount)];
            }

            // Generate tracking key
            NSString *key = [self generateKey];
            NSLog(@"beginCall with key:%@ name:%@ selector:%@", key, name, selName);

            SEL sel = NSSelectorFromString(selName);

            if ([name length] > 0 && [selName length] > 0) {
                id tracker = [ADEumInstrumentation beginCall:name selector:sel withArguments:additionalArguments];
                self.keymap[key] = tracker;
                result = [self finalizeSuccessfulResult:key];
            } else {
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Name or method missing or invalid"];
            }
        }
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)endCall:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *result;
    @try {
        if ([command.arguments count] < 1) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C endCall called -- bad command");
        } else if ([command.arguments count] >= 1) {
            NSString *key = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            if ([key length] > 0) {
                id tracker = [self.keymap objectForKey:key];
                if (tracker != nil) {
                    NSString *value = nil;
                    if ([command.arguments count] == 2) {
                        value = [command argumentAtIndex:1 withDefault:nil andClass:[NSString class]];
                        [ADEumInstrumentation endCall:tracker withValue:value];
                        NSLog(@"endCall %@ withValue:%@", key, value);
                    } else {
                        [ADEumInstrumentation endCall:tracker];
                        NSLog(@"endCall %@", key);
                    }

                    [self.keymap removeObjectForKey:key];
                    result = [self finalizeSuccessfulResult:nil];
                } else {
                    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Tracker not found"];
                }
            } else {
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Invalid tracker object"];
            }
        }
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)beginHttpRequest:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *result;
    @try {
        if ([command.arguments count] != 1) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C beginHttpRequest called -- bad command");
        } else {
            NSString *url = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            NSLog(@"beginHttpRequest %@", url);

            // get UUID for key
            NSString *key = [self generateKey];
            NSURL *nsurl = [[NSURL alloc] initWithString:url]; // new url from string

            if ([url length] > 0 && nsurl != nil) {
                ADEumHTTPRequestTracker *tracker = [ADEumHTTPRequestTracker requestTrackerWithURL:nsurl];
                self.keymap[key] = tracker;
                result = [self finalizeSuccessfulResult:key];
            } else {
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR  messageAsString:@"Missing or invalid URL"];
            }
        }
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)reportDone:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *result;
    @try {
        if ([command.arguments count] != 1) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C reportDone called -- bad command");
        } else {
            NSString *key = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];

            if ([key length] > 0) {
                ADEumHTTPRequestTracker *tracker = [self.keymap objectForKey:key];
                if (tracker != nil) {
                    [self.keymap removeObjectForKey:key];
                    [tracker reportDone];
                    result = [self finalizeSuccessfulResult:nil];

                } else {
                    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Tracker not found"];
                }
            } else {
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Invalid tracker object"];
            }
        }
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)getCorrelationHeaders:(CDVInvokedUrlCommand *)command {
    NSDictionary *headers = [ADEumServerCorrelationHeaders generate];

    CDVPluginResult *result = [self finalizeSuccessfulResult:headers];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

/*
 * Note: Invoking any of the following methods with missing or null arguments
 * will return CDVCommandStatus_ERROR without updating underlying parameters.
 * - (void)withResponseCode:(CDVInvokedUrlCommand*)command;
 * - (void)withResponseContentLength:(CDVInvokedUrlCommand*)command;
 * - (void)withRequestContentLength:(CDVInvokedUrlCommand*)command;
 * - (void)withInstrumentationSource:(CDVInvokedUrlCommand*)command;
 * - (void)withResponseHeaderFields:(CDVInvokedUrlCommand*)command;
 * - (void)withRequestHeaderFields:(CDVInvokedUrlCommand*)command;
 * - (void)withErrorMessage:(CDVInvokedUrlCommand*)command;
 */

- (void)withResponseCode:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *result;
    @try {
        if ([command.arguments count] != 2) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C withResponseCode called -- bad command");
        } else {
            NSString *key = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            NSNumber *responseStatusCode = [command argumentAtIndex:1 withDefault:nil andClass:[NSNumber class]];
            NSLog(@"key:%@ withResponseCode:%@", key, responseStatusCode);

            if ([key length] > 0) {
                if (responseStatusCode) {
                    ADEumHTTPRequestTracker *tracker = [self.keymap objectForKey:key];
                    tracker.statusCode = responseStatusCode;
                    result = [self finalizeSuccessfulResult:key];
                } else {
                    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"StatusCode missing or invalid"];
                }
            }
        }
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)withResponseContentLength:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *result;
    @try {
        if ([command.arguments count] != 2) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C withResponseContentLength called -- bad command");
        } else {
            NSString *key = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            NSNumber *responseContentLength = [command argumentAtIndex:1 withDefault:nil andClass:[NSNumber class]];
            NSLog(@"key:%@ withResponseContentLength:%@", key, responseContentLength);

            if ([key length] > 0) {
                if (responseContentLength) {
                    ADEumHTTPRequestTracker *tracker = [self.keymap objectForKey:key];
                    NSMutableDictionary *tmpHeaders = [NSMutableDictionary dictionaryWithDictionary:tracker.allHeaderFields];
                    [tmpHeaders setValue:[responseContentLength stringValue] forKey:@"Content-Length"];
                    tracker.allHeaderFields = tmpHeaders;
                    result = [self finalizeSuccessfulResult:key];
                } else {
                    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Content-Length missing or invalid"];
                }
            }
        }
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)withRequestContentLength:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *result;
    @try {
        if ([command.arguments count] != 2) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C withRequestContentLength called -- bad command");
        } else {
            NSString *key = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            NSNumber *requestContentLength = [command argumentAtIndex:1 withDefault:nil andClass:[NSNumber class]];
            NSLog(@"key:%@ withRequestContentLength:%@", key, requestContentLength);

            if ([key length] > 0) {
                if (requestContentLength) {
                    ADEumHTTPRequestTracker *tracker = [self.keymap objectForKey:key];
                    NSMutableDictionary *tmpHeaders = [NSMutableDictionary dictionaryWithDictionary:tracker.allRequestHeaderFields];
                    [tmpHeaders setValue:[requestContentLength stringValue] forKey:@"Content-Length"];
                    tracker.allRequestHeaderFields = tmpHeaders;
                    result = [self finalizeSuccessfulResult:key];
                } else {
                    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Content-Length missing or invalid"];
                }
            }
        }
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)withResponseHeaderFields:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *result;
    @try {
        if ([command.arguments count] != 2) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C withResponseHeaderFields called -- bad command");
        } else {
            NSString *key = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            NSDictionary *headers = [command argumentAtIndex:1 withDefault:nil andClass:[NSDictionary class]];
            NSLog(@"key:%@ withResponseHeaderFields:%@", key, headers);

            if ([key length] > 0) {
                if ([headers count] > 0) {
                    ADEumHTTPRequestTracker *tracker = [self.keymap objectForKey:key];
                    tracker.allHeaderFields = [self updatedTrackerHeaders:tracker.allHeaderFields newHeaders:headers];
                    result = [self finalizeSuccessfulResult:key];
                } else {
                    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Headers missing or invalid"];
                }
            }
        }
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)withRequestHeaderFields:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *result;
    @try {
        if ([command.arguments count] != 2) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C withRequestHeaderFields called -- bad command");
        } else {
            NSString *key = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            NSDictionary *headers = [command argumentAtIndex:1 withDefault:nil andClass:[NSDictionary class]];
            NSLog(@"key:%@ withRequestHeaderFields:%@", key, headers);

            if ([key length] > 0) {
                if ([headers count] > 0) {
                    ADEumHTTPRequestTracker *tracker = [self.keymap objectForKey:key];
                    tracker.allRequestHeaderFields = [self updatedTrackerHeaders:tracker.allRequestHeaderFields newHeaders:headers];
                    result = [self finalizeSuccessfulResult:key];
                } else {
                    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Headers missing or invalid"];
                }
            }
        }
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)withInstrumentationSource:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *result;
    @try {
        if ([command.arguments count] != 2) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C withInstrumentationSource called -- bad command");
        } else {
            NSString *key = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            NSString *informationSource = [command argumentAtIndex:1 withDefault:nil andClass:[NSString class]];
            NSLog(@"key:%@ withInstrumentationSource:%@", key, informationSource);

            if ([key length] > 0) {
                if (informationSource) {
                    ADEumHTTPRequestTracker *tracker = [self.keymap objectForKey:key];
                    tracker.instrumentationSource = informationSource;
                    result = [self finalizeSuccessfulResult:key];
                } else {
                    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"InformationSource missing or invalid"];
                }
            }
        }
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)withErrorMessage:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *result;
    @try {
        if ([command.arguments count] != 2) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C withErrorMessage called -- bad command");
        } else {
            NSString *key = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            NSString *errorMessage = [command argumentAtIndex:1 withDefault:nil andClass:[NSString class]];
            NSLog(@"key:%@ withErrorMessage:%@", key, errorMessage);

            if ([key length] > 0) {
                if ([errorMessage length] > 0) {
                    ADEumHTTPRequestTracker *tracker = [self.keymap objectForKey:key];
                    if ([tracker isMemberOfClass:[ADEumHTTPRequestTracker class]]) {
                        NSError *error = [NSError errorWithDomain:@"com.appdynamics.cordova"
                                                             code:-100
                                                         userInfo:@{NSLocalizedDescriptionKey: errorMessage}];

                        tracker.error = error;
                        result = [self finalizeSuccessfulResult:key];
                    } else {
                        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Http tracker not found"];
                    }
                } else {
                    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Error message missing or invalid"];
                }
            }
        }
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)startNextSession:(CDVInvokedUrlCommand *)command {
    NSLog(@"Obj-C startNextSession called:" );
    [ADEumInstrumentation startNextSession];

    CDVPluginResult *result = [self finalizeSuccessfulResult:nil];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)unblockScreenshots:(CDVInvokedUrlCommand *)command {
    [ADEumInstrumentation unblockScreenshots];

    CDVPluginResult *result = [self finalizeSuccessfulResult:nil];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)blockScreenshots:(CDVInvokedUrlCommand *)command {
    [ADEumInstrumentation blockScreenshots];

    CDVPluginResult *result = [self finalizeSuccessfulResult:nil];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)screenshotsBlocked:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *result = [self finalizeSuccessfulResult:[NSNumber numberWithBool:[ADEumInstrumentation screenshotsBlocked]]];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)startSessionFrame:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *result;

    @try {
        if ([command.arguments count] < 1) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C startSessionFrame called with invalid arguments");
        } else {
            NSString *sessionFrameName = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            // Generate tracking key
            NSString *key = [self generateKey];

            if ([sessionFrameName length] > 0) {
                id sessionFrame = [ADEumInstrumentation startSessionFrame:sessionFrameName];
                self.keymap[key] = sessionFrame;
                result = [self finalizeSuccessfulResult:key];
            } else {
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"SessionFrameName is missing or invalid"];
            }
        }
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)endSessionFrame:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *result;
    @try {
        if ([command.arguments count] < 1) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C endSessionFrame called -- bad command");
        } else if ([command.arguments count] >= 1) {
            NSString *key = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            if ([key length] > 0) {
                ADEumSessionFrame *sessionFrame = [self.keymap objectForKey:key];
                if (sessionFrame != nil) {
                    [sessionFrame end];
                    NSLog(@"endSessionFrame %@", key);
                    [self.keymap removeObjectForKey:key];
                    result = [self finalizeSuccessfulResult:nil];
                } else {
                    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"SessionFrame not found"];
                }
            } else {
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Invalid SessionFrame object"];
            }
        }
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)updateSessionFrameName:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *result;
    @try {
        if ([command.arguments count] < 2) {
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"Obj-C updateSessionFrameName called -- bad command");
        } else if ([command.arguments count] >= 2) {
            NSString *key = [command argumentAtIndex:0 withDefault:nil andClass:[NSString class]];
            NSString *sessionFrameName = [command argumentAtIndex:1 withDefault:nil andClass:[NSString class]];
            if ([key length] > 0 && [sessionFrameName length] > 0) {
                ADEumSessionFrame *sessionFrame = [self.keymap objectForKey:key];
                if (sessionFrame != nil) {
                    [sessionFrame updateName:sessionFrameName];
                    NSLog(@"updateSessionFrameName %@, %@", key, sessionFrameName);
                    result = [self finalizeSuccessfulResult:nil];
                } else {
                    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"SessionFrame not found"];
                }
            } else {
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Invalid SessionFrame object"];
            }
        }
    } @catch (NSException *exception) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[exception reason]];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

//for internal testing only
- (void)crash:(CDVInvokedUrlCommand *)command {
    NSLog(@"Obj-C crash called:" );
    CDVPluginResult *result = [self finalizeSuccessfulResult:nil];

    [self crashme];

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)crashme {
    assert(NO);
}

#pragma mark - Support methods
- (CDVPluginResult *)finalizeSuccessfulResult:(id)key {
    [self flush:nil];

    if ([key isKindOfClass:[NSString class]]) {
        return [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:key];
    } else if ([key isKindOfClass:[NSDictionary class]]) {
        return [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:key];
    } else {
        return [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
}

- (NSString *)generateKey {
    return [[NSUUID alloc] init].UUIDString;
}

- (NSDictionary *)updatedTrackerHeaders:(NSDictionary *)oldHeader newHeaders:(NSDictionary *)newHeaders {
    NSMutableDictionary *mergedHeaders = [NSMutableDictionary dictionaryWithDictionary:oldHeader];
    for (NSString *key in newHeaders) {
        [mergedHeaders setValue:[newHeaders objectForKey:key] forKey:key];
    }
    return mergedHeaders;
}

- (void)malformedArgument:(NSString *)argument command:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:argument];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (BOOL)setCollectorUrl:(id)argument {
    BOOL ret = NO;
    if (!argument) { // Optional argument
        return YES;
    }

    if ([argument isKindOfClass:[NSString class]]) {
        if ([NSURL URLWithString:argument]) {
            self.config.collectorURL = argument;
            ret = YES;
        }
    }
    return ret;
}

- (BOOL)setLoggingLevel:(id)argument {
    BOOL ret = NO;
    if (!argument) { // Optional argument
        return YES;
    }

    if ([argument isKindOfClass:[NSNumber class]]) {
        NSInteger loggingLevel = [argument integerValue];
        if ((loggingLevel >= ADEumLoggingLevelOff) && (loggingLevel <= ADEumLoggingLevelAll)) {
            self.config.loggingLevel = [argument integerValue];
        }
        ret = YES;
    }
    return ret;
}

- (BOOL)setScreenshotsEnabled:(id)argument {
    BOOL ret = NO;

    if (!argument) { // Optional argument
        return YES;
    }

    if ([argument isKindOfClass:[NSNumber class]]) {
        self.config.screenshotsEnabled = [argument boolValue];
        ret = YES;
    } else if ([argument isKindOfClass:[NSString class]]) {
        if( [@"true" caseInsensitiveCompare:argument] == NSOrderedSame ) {
           self.config.screenshotsEnabled = YES;
        } else {
           self.config.screenshotsEnabled = NO;
        }
        ret = YES;
    }
    return ret;
}

- (BOOL)setScreenshotUrl:(id)argument {
    BOOL ret = NO;

    if (!argument) { // Optional argument
        return YES;
    }

    if ([argument isKindOfClass:[NSString class]]) {
        if ([NSURL URLWithString:argument]) {
            self.config.screenshotURL = argument;
            ret = YES;
        }
    }
    return ret;
}

- (BOOL)setInteractionCaptureMode:(id)argument {
    BOOL ret = NO;

    if (!argument) { // Optional argument
        return YES;
    }

    if ([argument isKindOfClass:[NSNumber class]]) {
        self.config.interactionCaptureMode = [argument integerValue];
        ret = YES;
    }
    return ret;
}

- (BOOL)setReachabilityHostName:(id)argument {
    BOOL ret = NO;

    if (!argument) { // Optional argument
        return YES;
    }

    if ([argument isKindOfClass:[NSString class]]) {
        self.config.reachabilityHostName = argument;
        ret = YES;
    }
    return ret;
}

- (void)flush:(CDVInvokedUrlCommand *)command {
   // If API call is available use it otherwise simulate flush via network call side effect
    SEL fbnSelector = NSSelectorFromString(@"flushBeaconsNow");
    if ([ADEumInstrumentation respondsToSelector:fbnSelector]) {
        [ADEumInstrumentation performSelector:fbnSelector];
    } else {
        ADEumHTTPRequestTracker *t = [ADEumHTTPRequestTracker requestTrackerWithURL:[NSURL URLWithString:@"http://flush-beacons.com"]];
        t.statusCode = @200;
        [t reportDone];
    }
}

@end
