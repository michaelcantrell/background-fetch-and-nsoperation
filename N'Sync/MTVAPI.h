//
//  MTVAPI.h
//  N'Sync
//
//  Created by Michael Cantrell on 12/15/13.
//
//

#import <Foundation/Foundation.h>

@interface MTVAPI : NSObject

+(void)fetchUpdatedSince:(NSInteger)lastUpdate onComplete:(void (^)(NSArray *items))completion onError:(void (^)(NSError *error))error;

@end
