//
//  GoldMiningViewController.m
//  GoldMining
//
//  Created by 機器 王 on 12/7/3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GoldMiningViewController.h"
#import <Twitter/Twitter.h>

@interface GoldMiningViewController ()

@end

@implementation GoldMiningViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)twitterPressed:(id)sender 
{
    //建立viewcontroller
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
        
    //設定推文的內容
    [twitter setInitialText:@"我最喜歡採黃金了>////<"];
        
    //顯示viewcontroller
    [self presentModalViewController:twitter animated:YES];
}

@end
