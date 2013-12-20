//
//  MTVViewController.m
//  N'Sync
//
//  Created by Michael Cantrell on 12/14/13.
//
//

#import "MTVViewController.h"

#import "MTVLyricCell.h"
#import "MTVDatastore.h"

@interface MTVViewController () {
	NSArray *lyrics;
}

@end

@implementation MTVViewController

static NSString *Cell = @"Cell";

-(void)startSync {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SyncStart" object:nil];
}

-(void)syncFinished {
	lyrics = [MTVDatastore fetchEntries];
	
	__weak id weakself = self;
	
	dispatch_async(dispatch_get_main_queue(), ^() {
		if ([[weakself refreshControl] isRefreshing]) {
			[[weakself refreshControl] endRefreshing];
		}
		[[weakself tableView] reloadData];
	});
}

-(void)viewDidLoad {
	[super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncFinished) name:@"SyncFinished" object:nil];
	
	[self.tableView registerClass:[MTVLyricCell class] forCellReuseIdentifier:Cell];
	
	lyrics = [MTVDatastore fetchEntries];
	
	[self setRefreshControl:[[UIRefreshControl alloc] init]];
	[self.refreshControl addTarget:self action:@selector(startSync) forControlEvents:UIControlEventValueChanged];
	
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return lyrics.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [MTVLyricCell calculateHeightForLyric:[lyrics objectAtIndex:indexPath.row]];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MTVLyricCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
	if (!cell) {
		cell = [[MTVLyricCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell];
	}
	
	[cell.lyricLabel setText:[lyrics objectAtIndex:indexPath.row]];
	
	return cell;
}

@end
