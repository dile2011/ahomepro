//
//  ASetting.h
//  AtHomeApp
//
//  Created by dilei liu on 14-8-23.
//  Copyright (c) 2014年 ushome. All rights reserved.
//

#import "ASetting.h"

@implementation ASetting

+ (id)sharedInstance {
    static ASetting *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ASetting alloc] init];
        
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    return self;
}

- (NSString*)getDeviceToken {
    return [_userDefaults objectForKey:@"DeviceToken"];
}

- (void)setDeviceToken:(NSString*)token {
    [_userDefaults setObject:token forKey:@"DeviceToken"];
    [_userDefaults synchronize];
}


@end
