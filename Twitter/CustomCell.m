//
//  CustomCell.m
//  Twitter
//
//  Created by Li Li on 7/6/14.
//  Copyright (c) 2014 Li Li. All rights reserved.
//

#import "CustomCell.h"

@interface CustomCell ()
- (IBAction)favouriteButtonTouchUpInside:(id)sender;
- (IBAction)replyButtonTouchUpInside:(id)sender;
- (IBAction)retweetButtonTouchUpInside:(id)sender;


@end

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)favouriteButtonTouchUpInside:(id)sender {
    [self.delegate favouriteButtonTapForIndexPath:self.indexPath];
}
- (IBAction)replyButtonTouchUpInside:(id)sender
{
    [self.delegate replyButtonTapForIndexPath:self.indexPath];
    
}
- (IBAction)retweetButtonTouchUpInside:(id)sender
{
    [self.delegate retweetButtonTapForIndexPath:self.indexPath];

}
@end
