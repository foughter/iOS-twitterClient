//
//  TimelineViewController.h
//  Twitter
//
//  Created by Li Li on 7/6/14.
//  Copyright (c) 2014 Li Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import "TweetViewController.h"

@interface TimelineViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, CustomCellDelegate, TweetViewControllerDelegate>

- (id)initWithTweets: (NSArray*) tweets;

@end
