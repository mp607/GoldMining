//
//  GoldMiningPlayGame.m
//  GoldMining
//
//  Created by 機器 王 on 12/7/4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GoldMiningPlayGame.h"

#import <Foundation/NSObject.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSString.h>
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSValue.h>

#define MAXPRIME 50;  //定義MAXPRIME為最大的質數50
#define dieNum 5;      // 踩到幾個大便遊戲結束
#define goldScore 10; // 黃金得分
#define shitScore 10; // 大便扣分

int Row = 12,       // 列數
Col = 9,       // 行數
btnSize = 33,   // 按鈕大小
goldNum = 10,   // 黃金數量
shitNum = 20,   // 大便數量
die = 0,        // 死了幾次
level = 1,      // 第幾關
score = 0,      // 累積分數
goldCount = 0;  // 挖到黃金數

NSMutableArray *buttonMapping;
UIView *pauseView;
@interface GoldMiningPlayGame ()
{
    Boolean isPause;
    int time_count;
}
- (void)setGame ;    // 初始化
- (void)putTimer ;   // 設定Timer
- (void)putButton ;  // 放按鈕
- (IBAction)clickGamePause:(id)sender ; //按下暫停按鈕

- (void)updateTimer:(NSTimer *)theTimer ;  // UpdateTimer
- (IBAction) buttonClicked:(id)sender ;  // 踩踩樂

- (void)putPauseView ;  // 放置PauseView
- (IBAction)backBtnPressed:(id)sender ;
- (IBAction)levelBtnPressed:(id)sender ;
- (IBAction)rePlayBtnPressed:(id)sender ;

- (void)gameOver:(int)result ;  // 顯示成績之類
- (void)allOver ;   // 三關結束後做的事
- (void)saveScore:(NSString *)name ;    // 記錄成績

@property NSTimer *timer;

@end

@implementation GoldMiningPlayGame
@synthesize lblA;
@synthesize lblB;
@synthesize timerLabel;
@synthesize timer;

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
    [self setGame];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

/*
- (void)viewDidLoad: (int) s setLevel: (int) l
{
    [self setGame:l];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
*/
- (void)viewDidUnload
{
    [self releaseGame];
    [self setTimerLabel:nil];
    // 記得清掉所有產生的button
    [self setLblA:nil];
    [self setLblB:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setGame
{
    die = dieNum;
    //score = s;
    //level = l;
    
    goldCount = 0;
    
    Row = level * 4;
    Col = level * 3;
    btnSize =  360 / Row;
    goldNum = (Row - Col) * 2 * level;
    shitNum = (Row - Col) * 2 * level;
    //self.lblScore.text = [NSString stringWithFormat:@"第%d關 %d / %d   得分：%d   剩餘生命：%d", level, goldCount, goldNum, score, die];
    [self putTimer];  // 放TImer
    [self putButton]; // 放Button
    [self putPauseView]; // 產生pauseView
}
/*
- (void)initGame:(int) l
{

}
*/
- (void)putTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    isPause = NO;
    // 依據level改變時間限制
    switch (level) {
        case 1:
            time_count = 120;
            break;
        case 2:
            time_count = 200;
        case 3:
            time_count = 300;
        default:
            break;
    }
    self.timerLabel.text = [[NSString alloc] initWithFormat:@"\t%d:\t%d", time_count/60 ,time_count%60];
}

- (void)putButton
{
    //http://vectus.wordpress.com/2012/01/07/objective-c-nsmutablearray-使用方法/
    
    //////////// 隨機產生黃金位置 1 ~ Row * Col
    NSMutableArray *arrGold = [NSMutableArray array];
    
    for (int i = 0; i < goldNum; i++)
    {
        int count = 0;
        
        while (true)
        {
            int goldRand = (arc4random() % (Row * Col)) + 1;
            count = 0;
            
            for(int j = 0; j < [arrGold count]; j++)
            {
                if (goldRand == [((NSNumber*)[arrGold objectAtIndex:j]) intValue])
                    count ++;
            }
            
            
            if (count == 0)
            {
                [arrGold addObject:[NSString stringWithFormat:@"%d", goldRand]];
                //NSLog(@"Gold: %@ / %d", [arrGold objectAtIndex:i], Row * Col);
                
                break;
            }
        }
    }
    
    //////////// 隨機產生大便位置 1 ~ Row * Col
    NSMutableArray *arrShit = [NSMutableArray array];
    
    for (int i = 0; i < shitNum; i++)
    {
        int count = 0;
        
        while (true)
        {
            int shitRand = (arc4random() % (Row * Col)) + 1;
            count = 0;
            
            for (int j = 0; j < [arrShit count]; j++)
            {
                if (shitRand == [((NSNumber*)[arrShit objectAtIndex:j]) intValue])
                    count ++;
                
                for(int k = 0; k < [arrGold count]; k++)
                {
                    if (shitRand == [((NSNumber*)[arrGold objectAtIndex:k]) intValue])
                        count ++;
                }
            }
            
            if (count == 0)
            {
                [arrShit addObject:[NSString stringWithFormat:@"%d", shitRand]];
                //NSLog(@"Shit: %@ / %d", [arrShit objectAtIndex:i], Row * Col);
                
                break;
            }
        }
    }
    
    //////////// 設置遊戲矩陣
    NSMutableArray *arrGame = [NSMutableArray array];
    
    //// 初始化陣列
    for (int i = 0; i < Row * Col; i++)
        [arrGame addObject:@"0"];
    
    //// 放置黃金
    for (int i = 0; i < [arrGold count]; i++)
    {
        int goldLoc = [((NSNumber*)[arrGold objectAtIndex:i]) intValue] - 1;
        [arrGame replaceObjectAtIndex:goldLoc withObject:@"41"];
    }
    
    //// 放置大便
    for (int i = 0; i < [arrShit count]; i++)
    {
        int shitLoc = [((NSNumber*)[arrShit objectAtIndex:i]) intValue] - 1;
        [arrGame replaceObjectAtIndex:shitLoc withObject:@"51"];
    }
    
    //// 放置數字
    int num = 0, countGold = 0, countShit = 0;
    
    // 左上角
    for (int n = 1; n <= 1; n++)
    {
        int i = 0;
        
        if ([((NSNumber*)[arrGame objectAtIndex:i]) intValue] == 0)
        {
            num = 0;
            countGold = 0;
            countShit = 0;
            
            // 四周黃金數
            if ([arrGame objectAtIndex:i + 1] == @"41") // 6
                countGold++;
            if ([arrGame objectAtIndex:i + 1 + Col] == @"41") // 3
                countGold++;
            if ([arrGame objectAtIndex:i + Col] == @"41") // 2
                countGold++;
            
            // 四周大便數
            if ([arrGame objectAtIndex:i + 1] == @"51") // 6
                countShit++;
            if ([arrGame objectAtIndex:i + 1 + Col] == @"51") // 3
                countShit++;
            if ([arrGame objectAtIndex:i + Col] == @"51") // 2
                countShit++;
            
            // 設置數值
            if (countGold != 0 && countShit != 0)
                num = 30 + countGold + countShit;
            else if (countGold != 0)
                num = 10 + countGold;
            else if (countShit != 0)
                num = 20 + countShit;
            else
                num = 99;
            
            [arrGame replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d", num]];
        }
    }
    
    // 右上角
    for (int n = 1; n <= 1; n++)
    {
        int i = Col - 1;
        
        if ([((NSNumber*)[arrGame objectAtIndex:i]) intValue] == 0)
        {
            num = 0;
            countGold = 0;
            countShit = 0;
            
            // 四周黃金數
            if ([arrGame objectAtIndex:i - 1] == @"41") // 4
                countGold++;
            if ([arrGame objectAtIndex:i - 1 + Col] == @"41") // 1
                countGold++;
            if ([arrGame objectAtIndex:i + Col] == @"41") // 2
                countGold++;
            
            // 四周大便數
            if ([arrGame objectAtIndex:i - 1] == @"51") // 4
                countShit++;
            if ([arrGame objectAtIndex:i - 1 + Col] == @"51") // 1
                countShit++;
            if ([arrGame objectAtIndex:i + Col] == @"51") // 2
                countShit++;
            
            // 設置數值
            if (countGold != 0 && countShit != 0)
                num = 30 + countGold + countShit;
            else if (countGold != 0)
                num = 10 + countGold;
            else if (countShit != 0)
                num = 20 + countShit;
            else
                num = 99;
            
            [arrGame replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d", num]];
        }
    }
    
    // 左下角
    for (int n = 1; n <= 1; n++)
    {
        int i = [arrGame count] - Col;
        
        if ([((NSNumber*)[arrGame objectAtIndex:i]) intValue] == 0)
        {
            num = 0;
            countGold = 0;
            countShit = 0;
            
            // 四周黃金數
            if ([arrGame objectAtIndex:i + 1] == @"41") // 6
                countGold++;
            if ([arrGame objectAtIndex:i + 1 - Col] == @"41") // 9
                countGold++;
            if ([arrGame objectAtIndex:i - Col] == @"41") // 8
                countGold++;
            
            // 四周大便數
            if ([arrGame objectAtIndex:i + 1] == @"51") // 6
                countShit++;
            if ([arrGame objectAtIndex:i + 1 - Col] == @"51") // 9
                countShit++;
            if ([arrGame objectAtIndex:i - Col] == @"51") // 8
                countShit++;
            
            // 設置數值
            if (countGold != 0 && countShit != 0)
                num = 30 + countGold + countShit;
            else if (countGold != 0)
                num = 10 + countGold;
            else if (countShit != 0)
                num = 20 + countShit;
            else
                num = 99;
            
            [arrGame replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d", num]];
        }
    }
    
    // 右下角
    for (int n = 1; n <= 1; n++)
    {
        int i = [arrGame count] - 1;
        
        if ([((NSNumber*)[arrGame objectAtIndex:i]) intValue] == 0)
        {
            num = 0;
            countGold = 0;
            countShit = 0;
            
            // 四周黃金數
            if ([arrGame objectAtIndex:i - 1] == @"41") // 4
                countGold++;
            if ([arrGame objectAtIndex:i - 1 - Col] == @"41") // 7
                countGold++;
            if ([arrGame objectAtIndex:i - Col] == @"41") // 8
                countGold++;
            
            // 四周大便數
            if ([arrGame objectAtIndex:i - 1] == @"51") // 4
                countShit++;
            if ([arrGame objectAtIndex:i - 1 - Col] == @"51") // 7
                countShit++;
            if ([arrGame objectAtIndex:i - Col] == @"51") // 8
                countShit++;
            
            // 設置數值
            if (countGold != 0 && countShit != 0)
                num = 30 + countGold + countShit;
            else if (countGold != 0)
                num = 10 + countGold;
            else if (countShit != 0)
                num = 20 + countShit;
            else
                num = 99;
            
            [arrGame replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d", num]];
        }
    }
    
    // 上邊界
    for (int n = 1; n < Col - 1; n++)
    {
        int i = n;
        
        if ([((NSNumber*)[arrGame objectAtIndex:i]) intValue] == 0)
        {
            num = 0;
            countGold = 0;
            countShit = 0;
            
            // 四周黃金數
            if ([arrGame objectAtIndex:i - 1] == @"41") // 4
                countGold++;
            if ([arrGame objectAtIndex:i + 1] == @"41") // 6
                countGold++;
            if ([arrGame objectAtIndex:i - 1 + Col] == @"41") // 1
                countGold++;
            if ([arrGame objectAtIndex:i + 1 + Col] == @"41") // 3
                countGold++;
            if ([arrGame objectAtIndex:i + Col] == @"41") // 2
                countGold++;
            
            // 四周大便數
            if ([arrGame objectAtIndex:i - 1] == @"51") // 4
                countShit++;
            if ([arrGame objectAtIndex:i + 1] == @"51") // 6
                countShit++;
            if ([arrGame objectAtIndex:i - 1 + Col] == @"51") // 1
                countShit++;
            if ([arrGame objectAtIndex:i + 1 + Col] == @"51") // 3
                countShit++;
            if ([arrGame objectAtIndex:i + Col] == @"51") // 2
                countShit++;
            
            // 設置數值
            if (countGold != 0 && countShit != 0)
                num = 30 + countGold + countShit;
            else if (countGold != 0)
                num = 10 + countGold;
            else if (countShit != 0)
                num = 20 + countShit;
            else
                num = 99;
            
            [arrGame replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d", num]];
        }
    }
    
    // 下邊界
    for (int n = 1; n < Col - 1; n++)
    {
        int i = [arrGame count] - Col + n;
        
        if ([((NSNumber*)[arrGame objectAtIndex:i]) intValue] == 0)
        {
            num = 0;
            countGold = 0;
            countShit = 0;
            
            // 四周黃金數
            if ([arrGame objectAtIndex:i - 1] == @"41") // 4
                countGold++;
            if ([arrGame objectAtIndex:i + 1] == @"41") // 6
                countGold++;
            if ([arrGame objectAtIndex:i - 1 - Col] == @"41") // 7
                countGold++;
            if ([arrGame objectAtIndex:i + 1 - Col] == @"41") // 9
                countGold++;
            if ([arrGame objectAtIndex:i - Col] == @"41") // 8
                countGold++;
            
            // 四周大便數
            if ([arrGame objectAtIndex:i - 1] == @"51") // 4
                countShit++;
            if ([arrGame objectAtIndex:i + 1] == @"51") // 6
                countShit++;
            if ([arrGame objectAtIndex:i - 1 - Col] == @"51") // 7
                countShit++;
            if ([arrGame objectAtIndex:i + 1 - Col] == @"51") // 9
                countShit++;
            if ([arrGame objectAtIndex:i - Col] == @"51") // 8
                countShit++;
            
            // 設置數值
            if (countGold != 0 && countShit != 0)
                num = 30 + countGold + countShit;
            else if (countGold != 0)
                num = 10 + countGold;
            else if (countShit != 0)
                num = 20 + countShit;
            else
                num = 99;
            
            [arrGame replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d", num]];
        }
    }
    
    // 左邊界
    for (int n = 1; n < Row - 1; n++)
    {
        int i = n * Col;
        
        if ([((NSNumber*)[arrGame objectAtIndex:i]) intValue] == 0)
        {
            num = 0;
            countGold = 0;
            countShit = 0;
            
            // 四周黃金數
            if ([arrGame objectAtIndex:i + 1] == @"41") // 6
                countGold++;
            if ([arrGame objectAtIndex:i + 1 + Col] == @"41") // 3
                countGold++;
            if ([arrGame objectAtIndex:i + Col] == @"41") // 2
                countGold++;
            if ([arrGame objectAtIndex:i + 1 - Col] == @"41") // 9
                countGold++;
            if ([arrGame objectAtIndex:i - Col] == @"41") // 8
                countGold++;
            
            // 四周大便數
            if ([arrGame objectAtIndex:i + 1] == @"51") // 6
                countShit++;
            if ([arrGame objectAtIndex:i + 1 + Col] == @"51") // 3
                countShit++;
            if ([arrGame objectAtIndex:i + Col] == @"51") // 2
                countShit++;
            if ([arrGame objectAtIndex:i + 1 - Col] == @"51") // 9
                countShit++;
            if ([arrGame objectAtIndex:i - Col] == @"51") // 3
                countShit++;
            
            // 設置數值
            if (countGold != 0 && countShit != 0)
                num = 30 + countGold + countShit;
            else if (countGold != 0)
                num = 10 + countGold;
            else if (countShit != 0)
                num = 20 + countShit;
            else
                num = 99;
            
            [arrGame replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d", num]];
        }
    }
    
    // 右邊界
    for (int n = 1; n < Row - 1; n++)
    {
        int i = (n + 1) * Col - 1;
        
        if ([((NSNumber*)[arrGame objectAtIndex:i]) intValue] == 0)
        {
            num = 0;
            countGold = 0;
            countShit = 0;
            
            // 四周黃金數
            if ([arrGame objectAtIndex:i - 1] == @"41") // 4
                countGold++;
            if ([arrGame objectAtIndex:i - 1 + Col] == @"41") // 1
                countGold++;
            if ([arrGame objectAtIndex:i + Col] == @"41") // 2
                countGold++;
            if ([arrGame objectAtIndex:i - 1 - Col] == @"41") // 7
                countGold++;
            if ([arrGame objectAtIndex:i - Col] == @"41") // 8
                countGold++;
            
            // 四周大便數
            if ([arrGame objectAtIndex:i - 1] == @"51") // 4
                countShit++;
            if ([arrGame objectAtIndex:i - 1 + Col] == @"51") // 1
                countShit++;
            if ([arrGame objectAtIndex:i + Col] == @"51") // 2
                countShit++;
            if ([arrGame objectAtIndex:i - 1 - Col] == @"51") // 7
                countShit++;
            if ([arrGame objectAtIndex:i - Col] == @"51") // 8
                countShit++;
            
            // 設置數值
            if (countGold != 0 && countShit != 0)
                num = 30 + countGold + countShit;
            else if (countGold != 0)
                num = 10 + countGold;
            else if (countShit != 0)
                num = 20 + countShit;
            else
                num = 99;
            
            [arrGame replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d", num]];
        }
    }
    
    // 中間區域
    for (int i = 0; i < [arrGame count]; i++)
    {
        if ([((NSNumber*)[arrGame objectAtIndex:i]) intValue] == 0)
        {
            num = 0;
            countGold = 0;
            countShit = 0;
            
            // 四周黃金數
            if ([arrGame objectAtIndex:i - 1] == @"41") // 4
                countGold++;
            if ([arrGame objectAtIndex:i + 1] == @"41") // 6
                countGold++;
            if ([arrGame objectAtIndex:i - 1 + Col] == @"41") // 1
                countGold++;
            if ([arrGame objectAtIndex:i + 1 + Col] == @"41") // 3
                countGold++;
            if ([arrGame objectAtIndex:i + Col] == @"41") // 2
                countGold++;
            if ([arrGame objectAtIndex:i - 1 - Col] == @"41") // 7
                countGold++;
            if ([arrGame objectAtIndex:i + 1 - Col] == @"41") // 9
                countGold++;
            if ([arrGame objectAtIndex:i - Col] == @"41") // 8
                countGold++;
            
            // 四周大便數
            if ([arrGame objectAtIndex:i - 1] == @"51") // 4
                countShit++;
            if ([arrGame objectAtIndex:i + 1] == @"51") // 6
                countShit++;
            if ([arrGame objectAtIndex:i - 1 + Col] == @"51") // 1
                countShit++;
            if ([arrGame objectAtIndex:i + 1 + Col] == @"51") // 3
                countShit++;
            if ([arrGame objectAtIndex:i + Col] == @"51") // 2
                countShit++;
            if ([arrGame objectAtIndex:i - 1 - Col] == @"51") // 7
                countShit++;
            if ([arrGame objectAtIndex:i + 1 - Col] == @"51") // 9
                countShit++;
            if ([arrGame objectAtIndex:i - Col] == @"51") // 8
                countShit++;
            
            // 設置數值
            if (countGold != 0 && countShit != 0)
                num = 30 + countGold + countShit;
            else if (countGold != 0)
                num = 10 + countGold;
            else if (countShit != 0)
                num = 20 + countShit;
            else
                num = 99;
            
            [arrGame replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d", num]];
        }
    }
    
    /*
     // 印出陣列
     for (int i = 0; i < [arrGame count]; i++)
     NSLog(@"Game: %@ / %d", [arrGame objectAtIndex:i], Row * Col);
     */
    
    buttonMapping = [[NSMutableArray alloc] init];
    
    int k = 0;
    //////////// 動態產生按鈕
    for (int i = 0; i < Row; i++)
    {
        for (int j = 0; j < Col; j++)
        {
            CGRect frame = CGRectMake(j * btnSize + 20, i * btnSize + 80, btnSize, btnSize);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = frame;
            //[button setTitle:[arrGame objectAtIndex:k] forState: UIControlStateNormal];
            //[button setTitle:@" " forState: UIControlStateNormal];
            //button.backgroundColor = [UIColor clearColor];
            //[button setBackgroundImage:[UIImage imageNamed:@"floor.png"] forState:UIControlStateNormal];
            button.alpha = 0.7;
            button.tag = (j + 1) * 100 + (i + 1) * 10000 + [((NSNumber*)[arrGame objectAtIndex:k]) intValue];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
            [buttonMapping addObject:button];
            k++;
        }
    }

}

- (IBAction)clickGamePause:(id)sender   //按下暫停按鈕
{
    isPause = YES;
    // 把 pauseView 叫出來
    [self.view addSubview:pauseView];
    // addSubView 繼續 選難度 重來
    // 繼續 -> 清掉subview 計時器繼續
    // 選難度 -> 回到SelectLevel 並清掉此View所有產生的東西
    // 重來 -> 清掉所有產生的東西 重新配置
}

- (void)updateTimer:(NSTimer *)theTimer {
	//static int count = 120;
    if(time_count == 0) {
        // Game Over
        [self gameOver:-1];
    } else if(!isPause){    // isPause == NO -> run
        time_count--;
        NSString *s = [[NSString alloc]
                       initWithFormat:@"\t%d:\t%d", time_count/60 ,time_count%60];
        self.timerLabel.text = s;
    }
	
}

// 按鈕事件
- (IBAction)buttonClicked:(UIButton *)btn
{
    [btn setAlpha:1.0]; // 無作用(?)
    btn.enabled = false;
    
    switch (btn.tag % 100)
    {
        case 11:
            [btn setBackgroundImage:[UIImage imageNamed:@"g1.png"] forState:UIControlStateNormal];
            break;
            
        case 12:
            [btn setBackgroundImage:[UIImage imageNamed:@"g2.png"] forState:UIControlStateNormal];
            break;
            
        case 13:
            [btn setBackgroundImage:[UIImage imageNamed:@"g3.png"] forState:UIControlStateNormal];
            break;
            
        case 14:
            [btn setBackgroundImage:[UIImage imageNamed:@"g4.png"] forState:UIControlStateNormal];
            break;
            
        case 15:
            [btn setBackgroundImage:[UIImage imageNamed:@"g5.png"] forState:UIControlStateNormal];
            break;
            
        case 16:
            [btn setBackgroundImage:[UIImage imageNamed:@"g6.png"] forState:UIControlStateNormal];
            break;
            
        case 17:
            [btn setBackgroundImage:[UIImage imageNamed:@"g7.png"] forState:UIControlStateNormal];
            break;
            
        case 18:
            [btn setBackgroundImage:[UIImage imageNamed:@"g8.png"] forState:UIControlStateNormal];
            break;
            
        case 21:
            [btn setBackgroundImage:[UIImage imageNamed:@"r1.png"] forState:UIControlStateNormal];
            break;
            
        case 22:
            [btn setBackgroundImage:[UIImage imageNamed:@"r2.png"] forState:UIControlStateNormal];
            break;
            
        case 23:
            [btn setBackgroundImage:[UIImage imageNamed:@"r3.png"] forState:UIControlStateNormal];
            break;
            
        case 24:
            [btn setBackgroundImage:[UIImage imageNamed:@"r4.png"] forState:UIControlStateNormal];
            break;
            
        case 25:
            [btn setBackgroundImage:[UIImage imageNamed:@"r5.png"] forState:UIControlStateNormal];
            break;
            
        case 26:
            [btn setBackgroundImage:[UIImage imageNamed:@"r6.png"] forState:UIControlStateNormal];
            break;
            
        case 27:
            [btn setBackgroundImage:[UIImage imageNamed:@"r7.png"] forState:UIControlStateNormal];
            break;
            
        case 28:
            [btn setBackgroundImage:[UIImage imageNamed:@"r8.png"] forState:UIControlStateNormal];
            break;
            
        case 31:
            [btn setBackgroundImage:[UIImage imageNamed:@"b1.png"] forState:UIControlStateNormal];
            break;
            
        case 32:
            [btn setBackgroundImage:[UIImage imageNamed:@"b2.png"] forState:UIControlStateNormal];
            break;
            
        case 33:
            [btn setBackgroundImage:[UIImage imageNamed:@"b3.png"] forState:UIControlStateNormal];
            break;
            
        case 34:
            [btn setBackgroundImage:[UIImage imageNamed:@"b4.png"] forState:UIControlStateNormal];
            break;
            
        case 35:
            [btn setBackgroundImage:[UIImage imageNamed:@"b5.png"] forState:UIControlStateNormal];
            break;
            
        case 36:
            [btn setBackgroundImage:[UIImage imageNamed:@"b6.png"] forState:UIControlStateNormal];
            break;
            
        case 37:
            [btn setBackgroundImage:[UIImage imageNamed:@"b7.png"] forState:UIControlStateNormal];
            break;
            
        case 38:
            [btn setBackgroundImage:[UIImage imageNamed:@"b8.png"] forState:UIControlStateNormal];
            break;
            
        case 41:
            [btn setBackgroundImage:[UIImage imageNamed:@"g.png"] forState:UIControlStateNormal];
            score += goldScore;
            goldCount++;
            break;
            
        case 51:
            [btn setBackgroundImage:[UIImage imageNamed:@"b.png"] forState:UIControlStateNormal];
            score -= shitScore;
            die--;
            break;
            
        case 99:
            [btn setBackgroundImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
            int btnLocX = btn.tag / 10000 , btnLocY = btn.tag / 100 % 100;
            int btnLocK = (btnLocX - 1) * Col + btnLocY - 1;
            
            if (btnLocY - 1 >= 1 && btnLocX - 1 >= 1) // 7
            {
                UIButton *b = [buttonMapping objectAtIndex:btnLocK - 1 - Col];
                if (b.enabled)
                    [self buttonClicked:b];
            }
            
            if (btnLocY + 1 <= Col && btnLocX - 1 >= 1) // 9
            {
                UIButton *b = [buttonMapping objectAtIndex:btnLocK + 1 - Col];
                if (b.enabled)
                    [self buttonClicked:b];
            }
            
            if (btnLocY - 1 >= 1 && btnLocX + 1 <= Row) // 1
            {
                UIButton *b = [buttonMapping objectAtIndex:btnLocK - 1 + Col];
                if (b.enabled)
                    [self buttonClicked:b];
            }
            
            if ( btnLocY + 1 <= Col && btnLocX + 1 <= Row) // 6
            {
                UIButton *b = [buttonMapping objectAtIndex:btnLocK + 1 + Col];
                if (b.enabled)
                    [self buttonClicked:b];
            }
            
            if (btnLocY - 1 >= 1) // 4
            {
                UIButton *b = [buttonMapping objectAtIndex:btnLocK - 1];
                if (b.enabled)
                    [self buttonClicked:b];
            }
            
            if (btnLocY + 1 <= Col) // 6
            {
                UIButton *b = [buttonMapping objectAtIndex:btnLocK + 1];
                if (b.enabled)
                    [self buttonClicked:b];
            }
            
            if (btnLocX - 1 >= 1) // 8
            {
                UIButton *b = [buttonMapping objectAtIndex:btnLocK - Col];
                if (b.enabled)
                    [self buttonClicked:b];
            }
            
            if (btnLocX + 1 <= Row) // 2
            {
                UIButton *b = [buttonMapping objectAtIndex:btnLocK + Col];
                if (b.enabled)
                    [self buttonClicked:b];
            }
            
            
            break;
            
        default:
            break;
    }
    
    //self.lblScore.text = [NSString stringWithFormat:@"第%d關 %d / %d   得分：%d   剩餘生命：%d", level, goldCount, goldNum, score, die];
    
    if (die <= 0)
    { 
        [self gameOver:1];
    }
    
    if (goldCount >= goldNum)
    {
        [self gameOver:2];
    }
}

- (void)putPauseView
{
    // pauseView
    CGRect pauseViewRect = CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height);
    pauseView = [[UIView alloc] initWithFrame:pauseViewRect];
    pauseView.opaque = NO;
    pauseView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    // backButton
    CGRect backBtnRect = CGRectMake(pauseView.frame.size.width * 0.25 - 24, pauseView.frame.size.height / 2 - 24, 48, 48);
    UIButton *backBtn = [[UIButton alloc] initWithFrame:backBtnRect];
    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [pauseView addSubview:backBtn];
    
    
    // levelButton
    CGRect levelBtnRect = CGRectMake(pauseView.frame.size.width * 0.5 - 24, pauseView.frame.size.height / 2 - 24, 48, 48);
    UIButton *levelBtn = [[UIButton alloc] initWithFrame:levelBtnRect];
    [levelBtn addTarget:self action:@selector(levelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    levelBtn.backgroundColor = [UIColor purpleColor];
    [pauseView addSubview:levelBtn];
    
    // rePlayBtn
    CGRect rePlayBtnRect = CGRectMake(pauseView.frame.size.width * 0.75 - 24, pauseView.frame.size.height / 2 - 24, 48, 48);
    UIButton *rePlayBtn = [[UIButton alloc] initWithFrame:rePlayBtnRect];
    [rePlayBtn addTarget:self action:@selector(rePlayBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    rePlayBtn.backgroundColor = [UIColor blueColor];
    [pauseView addSubview:rePlayBtn];
    
}

- (IBAction)backBtnPressed:(id)sender
{
    // remove pauseView
    [pauseView removeFromSuperview];
    
    // continue Timer
    isPause = NO;
}

- (IBAction)levelBtnPressed:(id)sender
{
    // 回到GoldMiningSelectLevel
    
}

- (IBAction)rePlayBtnPressed:(id)sender //待完成
{
    // 清掉所有值
    [self releaseGame];

    // 拿掉pauseView
    [pauseView removeFromSuperview];
    
    // 重新初始化
    level = 1;
    [self setGame];   // 回第一關
}

- (void)gameOver:(int)result
{
    [timer invalidate]; // 用不到了，清掉Timer
    NSString* strA;
    if (result == 1)
    {
        strA = @"你已經死了";
    }else if (result == 2)
    {
        strA = @"你贏了";
    }
    else
    {
        strA = @"時間到";
    }
    
    for (int i = 0; i < [buttonMapping count]; i++)
    {
        UIButton *b = [buttonMapping objectAtIndex:i];
        b.enabled = false;
    }
    NSString* strB = [NSString stringWithFormat:@"%@\n累計得分：%d", strA, score];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"遊戲結束" message:strB delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];
    
    [alert show];
    
    if (result == 2 && level <3) {  // Win this level
        [self releaseGame];
        level++;
        [self setGame];
    }else if (level >= 3) {
        [self allOver];
    }
    // 顯示成績 儲存成績之類
    // addSubView (?) 打星星
    // 主畫面 選難度 下一難度
}

- (void)allOver
{
    // 三關結束後做的事：要使用者輸入姓名 記錄成績
    NSLog(@"Ya!");
}

- (void)saveScore:(NSString *)name
{
    // 成績扔到SQLite
}

- (void)releaseGame
{
    //timer = nil;
    // 清Button
    [timer invalidate];
    
    // 清掉Button
    for (int i = 0; i< [buttonMapping count]; i++) {
        [[buttonMapping objectAtIndex:i] removeFromSuperview];
    }
}

@end
