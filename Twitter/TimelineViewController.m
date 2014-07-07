//
//  TimelineViewController.m
//  Twitter
//
//  Created by Li Li on 7/6/14.
//  Copyright (c) 2014 Li Li. All rights reserved.
//

#import "TimelineViewController.h"
#import "CustomCell.h"
#import "ComposeViewController.h"
#import "TweetViewController.h"
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"
#import "CustomPullToRefresh.h"

@interface TimelineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong) NSArray* tweets;
@property (nonatomic, strong) UILabel* loadingLabel;
@property (nonatomic, strong) CustomPullToRefresh* ptr;

// The data model
@property (strong) NSMutableArray* favArray;
@property (strong) NSMutableArray* retweetArray;
@end

@implementation TimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTweets: (NSArray*) tweets
{
    self = [super init];
    if (self){
        self.tweets = tweets;
        
        self.favArray = [[NSMutableArray alloc] init];
        self.retweetArray = [[NSMutableArray alloc] init];
        [self updateDataModel];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // THIS IS A HACK.
    // Something wrong with the pullToRefresh stuff so that the first cell isn't on the top
    // Will need to fix it later
   [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.tableView setContentInset:UIEdgeInsetsZero];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //configure the nav bar
    
    UINavigationBar* naviBar = [[self navigationController] navigationBar];
    [naviBar setBackgroundColor:[UIColor blueColor]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStyleBordered target:self action:@selector(userSignOut)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStyleBordered target:self action:@selector(compose)];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:nil];
    

    self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)] ;
    self.loadingLabel.backgroundColor = [UIColor clearColor];
    self.loadingLabel.textColor = [UIColor lightGrayColor];
    self.loadingLabel.textAlignment = UITextAlignmentCenter;
    self.loadingLabel.font = [UIFont fontWithName:@"Champagne&Limousines-Bold" size:18];
    self.loadingLabel.text = @"Pull to refresh";
    self.tableView.tableHeaderView = self.loadingLabel;
    self.ptr = [[CustomPullToRefresh alloc] initWithScrollView:self.tableView delegate:self];
    
    // I tried the following the scroll the tableView but none of them is working.
    // The reason may be that viewDidLoad is the wrong place to do this
    //[self.tableView setContentOffset:CGPointMake(0, 40.0f)];
    //[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    //self.loadingLabel.text = @"Loading ...";
    //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView registerNib: [UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"MyCustomCell"];
    CustomCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MyCustomCell"];
    
    NSDictionary* tweet = self.tweets[indexPath.row];
    
    cell.delegate = self;
    cell.nameLabel.text = tweet[@"user"][@"name"];//@"David Jones";
    cell.userNameLabel.text = [NSString stringWithFormat:@"@%@",tweet[@"user"][@"screen_name"]];//@"@davidjones";
    cell.tweetTextLabel.text = tweet[@"text"];
    cell.postTimeLabel.text = @""; // TODO
    cell.indexPath = indexPath;
    
    [cell.replyButton setBackgroundImage:[UIImage imageNamed:@"reply.png"] forState:UIControlStateNormal];
    
    if ([self.favArray[indexPath.row] intValue]==0)
        [cell.faviouriteButton setBackgroundImage:[UIImage imageNamed:@"favourite.png"] forState:UIControlStateNormal];
    else [cell.faviouriteButton setBackgroundImage:[UIImage imageNamed:@"favourited.png"] forState:UIControlStateNormal];
    
    if ([self.retweetArray[indexPath.row] intValue]==0)
        [cell.retweetButton setBackgroundImage:[UIImage imageNamed:@"retweet.png" ] forState:UIControlStateNormal];
    else [cell.retweetButton setBackgroundImage:[UIImage imageNamed:@"retweeted.png" ] forState:UIControlStateNormal];
    
    cell.faviouriteButton.titleLabel.text = @"abcd" ;
    
    [cell.profileImageView setImageWithURL:[NSURL URLWithString:tweet[@"user"][@"profile_image_url"] ]];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TweetViewController* tvc = [[TweetViewController alloc] initWithTweet:self.tweets[indexPath.row] AndIndexPath:(NSIndexPath*) indexPath];
    tvc.delegate = self;
    [self.navigationController pushViewController:tvc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0f;
}

- (void) favouriteButtonTapForIndexPath:(NSIndexPath*) indexPath
{
    NSLog(@"favourite button tapped. IndexPath: %d", indexPath.row);
    if ([self.favArray[indexPath.row] intValue] == 0){
        NSLog(@"not favorited now");
        [[TwitterClient instance] favoriteCreateWithTweetId:self.tweets[indexPath.row][@"id_str"] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"fav create success");
            [self.favArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:1]];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"fav create error: %@", error);
        }];
    }
    else {
        NSLog(@"favorited now");
        [[TwitterClient instance] favoriteDestroyWithTweetId:self.tweets[indexPath.row][@"id_str"] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //[cell.faviouriteButton setBackgroundImage:[UIImage imageNamed:@"favourited.png"] forState:UIControlStateNormal];
            NSLog(@"fav destroy success");
            [self.favArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:0]];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"fav destroy error: %@", error);
        }];
    }
}

- (void) retweetButtonTapForIndexPath:(NSIndexPath*) indexPath
{
    NSLog(@"retweet button tapped. IndexPath: %d", indexPath.row);
    
    [[TwitterClient instance] statusesRetweetWithTweetId:self.tweets[indexPath.row][@"id_str"] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"retweet success");
        [self.retweetArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:1]];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"retweet error: %@", error);
    }];
}

- (void) replyButtonTapForIndexPath:(NSIndexPath*) indexPath
{
    NSLog(@"reply button tapped. IndexPath: %d", indexPath.row);
}

- (void) userSignOut
{
    NSLog(@"user hit sign out");
    [[TwitterClient instance] logout];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) compose
{
    NSLog(@"entering composeViewController!");
    ComposeViewController* cvc = [[ComposeViewController alloc] init];
    [self.navigationController pushViewController:cvc animated:YES];
    
}

-(void) refresh
{
    [[TwitterClient instance] HomeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
     
        NSArray *tweets = (NSArray*)responseObject;
        
        self.tweets = tweets;
        [self updateDataModel];
        
        [self.tableView reloadData];
        [self.ptr performSelectorOnMainThread:@selector(endRefresh) withObject:nil waitUntilDone:NO];
        NSLog(@"refresh HomeTimeline done!");

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"refresh HomeTimeline failed");
    }];
}

-(void) updateDataModel
{
    [self.favArray removeAllObjects];
    [self.retweetArray removeAllObjects];
    for (int i = 0; i< self.tweets.count; i++)
    {
        NSNumber* num = [NSNumber numberWithInt:[self.tweets[i][@"favorited"] intValue]];
        [self.favArray addObject:num];
        
        num = [NSNumber numberWithInt:[self.tweets[i][@"retweeted"] intValue]];
        [self.retweetArray addObject:num];
    }
}

#pragma mark - CustomPullToRefresh Delegate Methods
- (void) customPullToRefreshShouldRefresh:(CustomPullToRefresh *)ptr
{
    self.loadingLabel.text = @"Loading ...";
    [self performSelectorInBackground:@selector(refresh) withObject:nil];
}

- (void) customPullToRefreshEngageRefresh:(CustomPullToRefresh *)ptr {
    self.loadingLabel.text = @"Release to refresh";
}

- (void) customPullToRefreshDisengaged:(CustomPullToRefresh *)ptr {
    self.loadingLabel.text = @"Pull to refresh";
}

@end
