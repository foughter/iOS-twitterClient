//
//  TweetViewController.h
//  Twitter
//
//  Created by Li Li on 7/6/14.
//  Copyright (c) 2014 Li Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TweetViewControllerDelegate <NSObject>
- (void) favouriteButtonTapForIndexPath:(NSIndexPath*) indexPath;
- (void) retweetButtonTapForIndexPath:(NSIndexPath*) indexPath;
- (void) replyButtonTapForIndexPath:(NSIndexPath*) indexPath;
@end

@interface TweetViewController : UIViewController
-(id) initWithTweet:(NSDictionary*)tweet AndIndexPath:(NSIndexPath*) indexPath;
@property (nonatomic, weak) id <TweetViewControllerDelegate> delegate;
@end
