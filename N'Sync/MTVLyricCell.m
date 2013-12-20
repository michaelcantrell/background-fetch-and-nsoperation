//
//  MTVLyricCell.m
//  N'Sync
//
//  Created by Michael Cantrell on 12/16/13.
//
//

#import "MTVLyricCell.h"

@implementation MTVLyricCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		[self setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		_lyricLabel = [[UILabel alloc] init];
		[_lyricLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
		[_lyricLabel setFont:[UIFont systemFontOfSize:16]];
		[_lyricLabel setNumberOfLines:0];
		[_lyricLabel setPreferredMaxLayoutWidth:280];
		[self.contentView addSubview:_lyricLabel];
		[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lyricLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:20]];
		[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lyricLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-20]];
		[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lyricLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:20]];
		[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lyricLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-20]];
		
	}
	return self;
}

+(CGFloat)calculateHeightForLyric:(NSString*)lyric {
	CGSize size = [lyric sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(280, 500)];
	
	return size.height + 50;
}

@end
