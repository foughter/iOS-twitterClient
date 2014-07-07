//
//  TweetViewController.m
//  Twitter
//
//  Created by Li Li on 7/6/14.
//  Copyright (c) 2014 Li Li. All rights reserved.
//

#import "TweetViewController.h"
#import "UIImageView+AFNetworking.h"

@interface TweetViewController ()
@property (strong) NSDictionary* tweet;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favButton;

- (IBAction)replyButtonTouchUpInside:(id)sender;
- (IBAction)retweetButtonTouchUpInside:(id)sender;
- (IBAction)favButtonTouchUpInside:(id)sender;

// Data Model
@property (assign) BOOL faved;
@property (assign) BOOL retweeted;
@property (assign) int numFav;
@property (assign) int numRetweeted;
@property (strong) NSIndexPath* indexPath;
@end

@implementation TweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithTweet:(NSDictionary*)tweet AndIndexPath:(NSIndexPath*) indexPath
{
    self = [super init];
    if (self){
        self.tweet = tweet;
        self.indexPath = indexPath;
        [self updateAllModels];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStyleBordered target:self action:@selector(reply)];
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.tweet[@"user"][@"profile_image_url"]]];
    self.nameLabel.text = self.tweet[@"user"][@"name"];
    self.userNameLabel.text = [NSString stringWithFormat: @"@%@",self.tweet[@"user"][@"screen_name"]];
    
    self.textLabel.text = self.tweet[@"text"];
    
    [self updateViewsFromModels];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reply
{
    NSLog(@"TweetViewController: user hit Reply!");
}

- (void) updateAllModels
{
    if ([self.tweet[@"retweeted"] intValue]==0)
        self.retweeted = false;
    else self.retweeted = true;
    
    if ([self.tweet[@"favorited"] intValue]==0)
        self.faved = false;
    else self.faved = true;
    
    self.numFav =[self.tweet[@"favorite_count"] intValue];
    self.numRetweeted = [self.tweet[@"retweet_count"] intValue];
}

-(void) updateViewsFromModels
{
    if (self.faved == NO)
        [self.favButton setBackgroundImage:[UIImage imageNamed:@"favourite.png"] forState:UIControlStateNormal];
    else [self.favButton setBackgroundImage:[UIImage imageNamed:@"favourited.png"] forState:UIControlStateNormal];
    
    if (self.retweeted == NO)
        [self.retweetButton setBackgroundImage:[UIImage imageNamed:@"retweet.png" ] forState:UIControlStateNormal];
    else [self.retweetButton setBackgroundImage:[UIImage imageNamed:@"retweeted.png" ] forState:UIControlStateNormal];
    
    [self.replyButton setBackgroundImage:[UIImage imageNamed:@"reply.png" ] forState:UIControlStateNormal];
    
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.numRetweeted];
    self.favCountLabel.text = [NSString stringWithFormat:@"%d", self.numFav];
    
}

- (IBAction)replyButtonTouchUpInside:(id)sender {
    [self.delegate replyButtonTapForIndexPath:self.indexPath];
    
    [self updateViewsFromModels];
}

- (IBAction)retweetButtonTouchUpInside:(id)sender {
    [self.delegate retweetButtonTapForIndexPath:self.indexPath];
    
    self.retweeted = YES;
    
    // may not be that efficient since it's updating all buttons
    [self updateViewsFromModels];
}

- (IBAction)favButtonTouchUpInside:(id)sender {
    [self.delegate favouriteButtonTapForIndexPath:self.indexPath];
    
    // THIS IS HACKY. At this point I don't know whether the request is successful yet
    if (self.faved)
        self.numFav--;
    else self.numFav++;
    self.faved = !self.faved;
    
    // may not be that efficient since it's updating all buttons
    [self updateViewsFromModels];
}
@end
