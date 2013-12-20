//
//  MTVDatastore.m
//  N'Sync
//
//  Created by Michael Cantrell on 12/16/13.
//
//

#import "MTVDatastore.h"

@implementation MTVDatastore

+(void)saveEntries:(NSArray*)newEntries {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSArray *existing = [userDefaults objectForKey:@"Data"];
	if (existing) {
		newEntries = [newEntries arrayByAddingObjectsFromArray:existing];
	}
	
	[userDefaults setObject:newEntries forKey:@"Data"];
	[userDefaults synchronize];
}

+(NSArray*)fetchEntries {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSArray *existing = [userDefaults objectForKey:@"Data"];
	if (existing) {
		return existing;
	}
	
	return @[];
}

+(void)clearEntries {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	[userDefaults removeObjectForKey:@"Data"];
	[userDefaults synchronize];
}

@end
