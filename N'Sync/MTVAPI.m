//
//  MTVAPI.m
//  N'Sync
//
//  Created by Michael Cantrell on 12/15/13.
//
//

#import "MTVAPI.h"

@implementation MTVAPI

+(void)fetchUpdatedSince:(NSInteger)lastUpdate onComplete:(void (^)(NSArray *items))completion onError:(void (^)(NSError *error))error {
	NSArray *data;
	switch (lastUpdate) {
		case 0:
		case 8:
		case 16:
			data = @[
					 @"I've drove myself insane wishing I could touch your face but the truth, remains...You're gone..",
					 @"It's tearin' up my heart when I'm with you but when we are apart, I feel it too. And no matter what I do, I feel the pain with or without you.",
					 @"Baby I don't understand. Just why we can't be lovers. Things are getting out of hand. Trying too much, but baby we can't win.",
					 @"Let it go. If you want me girl, let me know. I am down, on my knees, I can't take it anymore.",
					 @"Lying in your arms. So close together. Didn't know just what I had."
					 ];
			break;
			
		case 1:
		case 9:
		case 17:
			data = @[
					 @"I lie awake, I drive myself crazy, Drive myself crazy, Thinking of you",
					 @"Made a mistake when I let you go baby. I drive myself crazy. Wanting you the way that I do.",
					 @"Won't you be my girlfriend? I'll treat you good. I know you hear your friends when they say you should."
					 ];
			break;
			
		case 2:
		case 10:
		case 18:
			data = @[
					 @"'Cause if you were my girlfriend, I'd be your shining star. The one to show you where you are. Girl you should be my girlfriend."
					 ];
			break;
			
		case 3:
		case 11:
		case 19:
			data = @[
					 @"The thing you got to realize what we doing is not a trend. We got the gift of melody. We gonna bring it till the end.",
					 @"It doesn't matter 'Bout the car I drive or what I wear around my neck. All that matters Is that you recognize that it's just about respect."
					 ];
			break;
			
		case 4:
		case 12:
		case 20:
			data = @[
					 @"Do you ever wonder why, this music gets you high? It takes you on a ride"
					 ];
			break;
			
		case 5:
		case 13:
		case 21:
			data = @[
					 @"Feel it when your body starts to rock. Baby you can't stop and the music's all you got. Come on now this must be, pop."
					 ];
			break;
			
		case 6:
		case 14:
		case 22:
			data = @[
					 @"Was it something I said To make you turn away? To make you walk out and leave me cold."
					 ];
			break;
			
		case 7:
		case 15:
		case 23:
			data = @[
					 @"If I could just find a way to make it so that you were right here. But right now...",
					 @"I've been sitting here. Can't get you off my mind. I've tried my best to be a man and be strong."
					 ];
			break;
			
		default:
			data = @[];
			break;
	}
	
	double delayInSeconds = 2.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		completion(data);
	});
}

@end
