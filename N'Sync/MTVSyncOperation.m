//
//  MTVSyncOperation.m
//  N'Sync
//
//  Created by Michael Cantrell on 12/15/13.
//
//

#import "MTVSyncOperation.h"

#import "MTVAPI.h"
#import "MTVDatastore.h"

@interface MTVSyncOperation () {
	BOOL isExecuting, isFinished;
}

// Rewrite, so we can modify
@property (assign, readwrite) BOOL successful, newData;

@end

@implementation MTVSyncOperation

-(void)syncWithServer {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	__block NSInteger lastSync = [[defaults objectForKey:@"LastSync"] integerValue];
	
	__weak id weakself = self;
	
	[MTVAPI fetchUpdatedSince:lastSync onComplete:^(NSArray *items) {
		
		[MTVDatastore saveEntries:items];
		
		if (items.count > 0) {
			[weakself setNewData:YES];
		}
		
		lastSync++;
		[defaults setObject:[NSNumber numberWithInt:lastSync] forKey:@"LastSync"];
		[defaults synchronize];
		
		[weakself syncSucceeded];
		
	} onError:^(NSError *error) {
		[weakself syncFailed];
	}];
}

-(void)syncSucceeded {
	[self setSuccessful:YES];
	[self syncFinished];
}

-(void)syncFailed {
	[self setSuccessful:NO];
	[self syncFinished];
}

-(void)syncFinished {
	[self setIsExecuting:NO];
	[self setIsFinished:YES];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SyncFinished" object:nil];
}

#pragma mark - NSOperation
-(id)init {
	self = [super init];
	if (self) {
		isExecuting = NO;
		isFinished = NO;
		
	}
	return self;
}

-(void)start {
	if (self.isCancelled) {
		[self setIsExecuting:NO];
		[self setIsFinished:YES];
		return;
	}
	
	_successful = NO;
	_newData = NO;
	
	[self setIsExecuting:YES];
	[self setIsFinished:NO];
	
	// Start asynchronous work
	[self syncWithServer];
}

-(BOOL)isConcurrent {
	return YES;
}

#pragma mark - KVO compliance
-(void)setIsExecuting:(BOOL)newValue {
	if (newValue != isExecuting) {
		[self willChangeValueForKey:@"isExecuting"];
		isExecuting = newValue;
		[self didChangeValueForKey:@"isExecuting"];
	}
}

-(BOOL)isExecuting {
	return isExecuting;
}

-(void)setIsFinished:(BOOL)newValue {
	if (newValue != isFinished) {
		[self willChangeValueForKey:@"isFinished"];
		isFinished = newValue;
		[self didChangeValueForKey:@"isFinished"];
	}
}

-(BOOL)isFinished {
	return isFinished;
}

@end



/**

 *********************************** Step 1 - Add Success and newData properties
 @property (assign, readonly) BOOL successful, newData;
 
 // Rewrite, so we can modify
 @property (assign, readwrite) BOOL successful, newData;
 
 _successful = NO;
 _newData = NO;
 
 
 
 
 *********************************** Step 2 - Add Success, Failed, and Finished methods
 -(void)syncSucceeded {
 [self setSuccessful:YES];
 [self syncFinished];
 }
 
 -(void)syncFailed {
 [self setSuccessful:NO];
 [self syncFinished];
 }
 
 -(void)syncFinished {
 [self setIsExecuting:NO];
 [self setIsFinished:YES];
 
 [[NSNotificationCenter defaultCenter] postNotificationName:@"SyncFinished" object:nil];
 }
 
 
 
 *********************************** Step 3 - Sync code with server
 -(void)syncWithServer {
 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 __block NSInteger lastSync = [[defaults objectForKey:@"LastSync"] integerValue];
 
 __weak id weakself = self;
 
 [MTVAPI fetchUpdatedSince:lastSync onComplete:^(NSArray *items) {
 
 [MTVDatastore saveEntries:items];
 
 if (items.count > 0) {
 [weakself setNewData:YES];
 }
 
 lastSync++;
 [defaults setObject:[NSNumber numberWithInt:lastSync] forKey:@"LastSync"];
 [defaults synchronize];
 
 [weakself syncSucceeded];
 
 } onError:^(NSError *error) {
 [weakself syncFailed];
 }];
 }
 
 *********************************** Step 4 - Start sync
 // Start asynchronous work
 [self syncWithServer];

*/

