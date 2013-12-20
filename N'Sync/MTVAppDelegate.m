//
//  MTVAppDelegate.m
//  N'Sync
//
//  Created by Michael Cantrell on 12/14/13.
//
//

#import "MTVAppDelegate.h"

#import "MTVSyncOperation.h"

@interface MTVAppDelegate () {
	NSOperationQueue *operationQueue;
	MTVSyncOperation *syncOperation;
	
	void (^fetchCompletionHandler)(UIBackgroundFetchResult);
}

@end

@implementation MTVAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	[[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
	
	operationQueue = [[NSOperationQueue alloc] init];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncWithServer) name:@"SyncStart" object:nil];
	
	return YES;
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
	
	fetchCompletionHandler = completionHandler;
	
	NSLog(@"Background Fetch Called");
	
	// Call Sync Operation
	[self syncWithServer];
}

-(void)syncWithServer {
	// Make sure we don't start a sync if one is in progress
	if (syncOperation) {
		return;
	}
	// Start
	syncOperation = [[MTVSyncOperation alloc] init];
	[syncOperation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
	[operationQueue addOperation:syncOperation];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"isFinished"]) {
		BOOL finished = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
		if (finished) {
			NSLog(@"Background Fetch Finished");
			[syncOperation removeObserver:self forKeyPath:keyPath];
			
			// If running in the background
			double delayInSeconds = 1.0;
			dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
			dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
				if (fetchCompletionHandler) {
					if (syncOperation.newData) {
						fetchCompletionHandler(UIBackgroundFetchResultNewData);
					} else if (syncOperation.successful) {
						fetchCompletionHandler(UIBackgroundFetchResultNoData);
					} else {
						fetchCompletionHandler(UIBackgroundFetchResultFailed);
					}
					
					// Clear completion handler
					fetchCompletionHandler = nil;
				}
			});
			
			syncOperation = nil;
		}
	}
}


@end


/**

 ************************** Step 1 - Set fetch interval
 [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
 
 
 
 ************************** Step 2 - Set up needed properties
 @interface MTVAppDelegate () {
 NSOperationQueue *operationQueue;
 MTVSyncOperation *syncOperation;
 
 void (^fetchCompletionHandler)(UIBackgroundFetchResult);
 }
 
 @end
 
 
 
 ************************** Step 3 - Set up operation queue
 operationQueue = [[NSOperationQueue alloc] init];
 
 
 
 
 ************************** Step 4 - Perform Fetch
 -(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
 
 fetchCompletionHandler = completionHandler;
 
 NSLog(@"Background Fetch Called");
 
 // Call Sync Operation
 [self syncWithServer];
 }
 
 -(void)syncWithServer {
 // Make sure we don't start a sync if one is in progress
 if (syncOperation) {
 return;
 }
 
 // Start
 syncOperation = [[MTVSyncOperation alloc] init];
 [syncOperation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
 [operationQueue addOperation:syncOperation];
 }
 
 
 
 ************************** Step 5 - KVO
 -(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
 if ([keyPath isEqualToString:@"isFinished"]) {
 BOOL finished = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
 if (finished) {
 NSLog(@"Background Fetch Finished");
 [syncOperation removeObserver:self forKeyPath:keyPath];
 
 // If running in the background
 double delayInSeconds = 1.0;
 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
 if (fetchCompletionHandler) {
 if (syncOperation.newData) {
 fetchCompletionHandler(UIBackgroundFetchResultNewData);
 } else if (syncOperation.successful) {
 fetchCompletionHandler(UIBackgroundFetchResultNoData);
 } else {
 fetchCompletionHandler(UIBackgroundFetchResultFailed);
 }
 
 // Clear completion handler
 fetchCompletionHandler = nil;
 }
 });
 
 syncOperation = nil;
 }
 }
 }
 
 
 
 ************************** Step 6 - Bonus, hook into pull to refresh
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncWithServer) name:@"SyncStart" object:nil];

*/

