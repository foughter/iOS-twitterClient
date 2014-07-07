//
//  ComposeViewController.m
//  Twitter
//
//  Created by Li Li on 7/6/14.
//  Copyright (c) 2014 Li Li. All rights reserved.
//

#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"

#define TWEET_MAX_CHARACTERS 140

@interface ComposeViewController ()
@property (strong) UILabel* charNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
//@property (strong) NSDictionary* userDict;
@property (strong) NSString* screenName;
@end

@implementation ComposeViewController

int textLengthRemaining;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.userNameLabel.text = @"abcd";
    
    [[TwitterClient instance] getAccountSettingsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.screenName = [responseObject objectForKey:@"screen_name"];
        NSLog(@"account/settings success! screen_name:%@", self.screenName);
        
        [[TwitterClient instance] userShowWithScreenName:self.screenName Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"userShow success! user: %@", responseObject);
            [self.profileImageView setImageWithURL:[NSURL URLWithString:responseObject[@"profile_image_url"] ]];
            self.nameLabel.text = responseObject[@"name"];
            self.userNameLabel.text = [NSString stringWithFormat:@"@%@",self.screenName];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"userShow error!");
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"account/settings error!");
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStyleBordered target:self action:@selector(tweet)];
    
    self.charNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 200, 30)];
    textLengthRemaining = TWEET_MAX_CHARACTERS;
    self.charNumLabel.text = [NSString stringWithFormat:@"%d", textLengthRemaining];
    self.charNumLabel.textAlignment = NSTextAlignmentRight;
    self.navigationItem.titleView = self.charNumLabel;
  /*
    [self.profileImageView setImageWithURL:self.userDict[@"profile_image_url"]];
    self.nameLabel.text = self.userDict[@"name"];
    self.userNameLabel.text = self.userDict[@"screen_name"];
    */
    self.textView.delegate = (id)self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tweet
{
    NSLog(@"ComposeViewController: user hit Tweet!");
    if (self.textView.text.length == 0)
    {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Errr" message:@"Tweet can't be empty..." delegate:nil cancelButtonTitle:@"Got it" otherButtonTitles:nil];
        [av show];
        return;
    }
    [[TwitterClient instance] composeTextTweet:self.textView.text WithSuccess:
        ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"compose success!");
         
         // THIS IS KINDA HACKY
         // I pop the current viewcontroller before posting an alert view, which makes me a bit nervous... but it seems to work
         [self.navigationController popViewControllerAnimated:YES];
         UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Congrats" message:@"You just posted one tweet!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
         [av show];
     }
    failure:
     ^(AFHTTPRequestOperation *operation, NSError *error)
     {NSLog(@"compose failed. error:%@", error);}
     ];
}

-(void)cancel
{
    NSLog(@"ComposeViewController: user hit Cancel!");
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    textLengthRemaining = TWEET_MAX_CHARACTERS - textView.text.length;
    self.charNumLabel.text = [NSString stringWithFormat:@"%d", textLengthRemaining];
    
    if (textLengthRemaining > 0 || [text length] == 0) // when backspace is pressed, string.length is 0
        return YES;
    return NO;
}

@end
