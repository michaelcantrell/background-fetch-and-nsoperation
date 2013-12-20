//
//  MTVDatastore.h
//  N'Sync
//
//  Created by Michael Cantrell on 12/16/13.
//
//

#import <Foundation/Foundation.h>

@interface MTVDatastore : NSObject

+(void)saveEntries:(NSArray*)newEntries;
+(NSArray*)fetchEntries;

+(void)clearEntries;

@end
