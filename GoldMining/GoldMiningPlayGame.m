//
//  GoldMiningPlayGame.m
//  GoldMining
//
//  Created by 機器 王 on 12/7/4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GoldMiningPlayGame.h"

@interface GoldMiningPlayGame ()

@end

@implementation GoldMiningPlayGame

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

int Row = 10, Col = 13, btnSize = 30;

- (void)viewDidLoad
{
    for(int i = 0; i < Row; i++)
    {
        for(int j = 0; j < Col; j++)
        {
            //动态添加一个按钮
            CGRect frame = CGRectMake(i * btnSize + 10, j * btnSize + 50, btnSize, btnSize);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = frame;
            [button setTitle:@"？" forState: UIControlStateNormal];  
            button.backgroundColor = [UIColor clearColor];  
            button.tag = (j + 1) * 10000 + (i + 1) * 100;
            [button setImage:[UIImage imageNamed:@"b.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];}
    }
    
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

//这个是新按钮的响应函数
-(IBAction) buttonClicked:(id)sender {
    UIButton* btn = sender;
    NSString* strA = @"你已經死了";
    NSString* strB = [NSString stringWithFormat:@"%@\n%d", strA, btn.tag];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"遊戲結束" message:strB delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];  
    [alert show];
    
}

@end
