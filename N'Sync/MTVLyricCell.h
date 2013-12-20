//
//  MTVLyricCell.h
//  N'Sync
//
//  Created by Michael Cantrell on 12/16/13.
//
//

#import <UIKit/UIKit.h>

@interface MTVLyricCell : UITableViewCell

@property (strong, readonly, nonatomic) UILabel *lyricLabel;

+(CGFloat)calculateHeightForLyric:(NSString*)lyric;

@end
