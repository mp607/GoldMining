//
//  GoldMiningSelectLevel.m
//  GoldMining
//
//  Created by 機器 王 on 12/7/4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GoldMiningSelectLevel.h"

@interface GoldMiningSelectLevel ()

@end

@implementation GoldMiningSelectLevel
@synthesize level;

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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)levelSelectPressed:(UIButton *)sender 
{
    level = [[NSNumber alloc] initWithInt:sender.tag];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //將page2設定成Storyboard Segue的目標UIViewController
    id page2 = segue.destinationViewController;
    
    //將值透過Storyboard Segue帶給頁面2的string變數
    [page2 setValue:level forKey:@"levelSelect"];
}

@end
