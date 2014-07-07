//
//  TwitterClient.m
//  Twitter
//
//  Created by Li Li on 6/29/14.
//  Copyright (c) 2014 Li Li. All rights reserved.
//

#import "TwitterClient.h"

@implementation TwitterClient

+ (TwitterClient*) instance {
    static TwitterClient *instance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"]  consumerKey:@"IVgITVjvrHh5XebNcZZZEC94E" consumerSecret:@"tG6OZ5erOJ1ZXvEbvJKrrzsGwHiU3yf050CP4POw1Ojt7DVxGy"];
    });
    
    return instance;
}

- (void) login{
    
    [self.requestSerializer removeAccessToken];
    
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"cptwitter://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"got request token!");
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
    
    } failure:^(NSError *error) {
        NSLog(@"request token failure");
        NSLog(@"error = %@", error);
    }];
    
    /*
    BDBOAuthToken* accessToken = [BDBOAuthToken tokenWithToken:@"2595847627-R6u0QKehYKIiMUYDF09TvWxu4fuVun0i4leWJlG" secret:@"EbHFksSxQ7uXDzqj0NnHlDEehp0uai9MaTP4wRw9pQjtW" expiration:nil];
    [self.requestSerializer saveAccessToken:accessToken];
    
    [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
    }];
     */
    /*[self HomeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
    }];*/
}

- (void) logout
{
    [self.requestSerializer removeAccessToken];
}

- (AFHTTPRequestOperation*) HomeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation*) composeTextTweet:(NSString*)text WithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary* params = [NSDictionary dictionaryWithObject:text forKey:@"status"];
    
    return [self POST:@"1.1/statuses/update.json" parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation*) getAccountSettingsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    return [self GET:@"1.1/account/settings.json" parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation*) userShowWithScreenName:(NSString*)screenName Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary* params = [NSDictionary dictionaryWithObject:screenName forKey:@"screen_name"];
    return [self GET:@"1.1/users/show.json" parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation*) favoriteCreateWithTweetId:(NSString*)tweetId Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary* params = [NSDictionary dictionaryWithObject:tweetId forKey:@"id"];
    return [self POST:@"1.1/favorites/create.json" parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation*) favoriteDestroyWithTweetId:(NSString*)tweetId Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary* params = [NSDictionary dictionaryWithObject:tweetId forKey:@"id"];
    return [self POST:@"1.1/favorites/destroy.json" parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation*) statusesRetweetWithTweetId:(NSString*)tweetId Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString* urlStr = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId];
    return [self POST:urlStr parameters:nil success:success failure:failure];
}



@end
