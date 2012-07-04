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
@synthesize timerLabel;
@synthesize GamePauseBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

int Row = 10, Col = 13, btnSize = 30;

#define START_TOP 100
#define START_LEFT 10

-(IBAction)clickGamePause:(id)sender//按下暫停按鈕
{
    ispause = YES;
}
- (void)updateCounter:(NSTimer *)theTimer {
	//static int count = 120;
    if(time_count==0||ispause!=NO)
    {
    //時間到暫停遊戲
    }
    else
    {
	time_count--;
	NSString *s = [[NSString alloc]
                   initWithFormat:@"\t%d:\t%d", time_count/60 ,time_count%60];
	self.timerLabel.text = s;
    }
	
}

- (void)viewDidLoad
{
    /*timer*/
    
    self.timerLabel.text = @"\t2:\t00";
    ispause=NO;
    time_count=120;
	[NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(updateCounter:)
                                   userInfo:nil
                                    repeats:YES];
    /*timer end*/
    for(int i = 0; i < Row; i++)
    {
        for(int j = 0; j < Col; j++)
        {
            //动态添加一个按钮
            CGRect frame = CGRectMake(i * btnSize + START_LEFT, j * btnSize + START_TOP, btnSize, btnSize);
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
    [self setTimerLabel:nil];
    [self setGamePauseBtn:nil];
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
