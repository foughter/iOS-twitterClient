//
//  CustomCell.h
//  Twitter
//
//  Created by Li Li on 7/6/14.
//  Copyright (c) 2014 Li Li. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CustomCellDelegate <NSObject>
- (void) favouriteButtonTapForIndexPath:(NSIndexPath*) indexPath;
- (void) retweetButtonTapForIndexPath:(NSIndexPath*) indexPath;
- (void) replyButtonTapForIndexPath:(NSIndexPath*) indexPath;
@end


@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *faviouriteButton;
@property (strong) NSIndexPath* indexPath;
@property (nonatomic, weak) id <CustomCellDelegate> delegate;
@end
