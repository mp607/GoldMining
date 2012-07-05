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
int Row = 20, Col = 15, btnSize = 20, goldNum = 30, shitNum = 30;   // 暫存，依據level改變難度

@interface GoldMiningPlayGame ()

- (void)setGame:(int)level ;    // 初始化
- (void)putTimer:(int)level ;   // 設定Timer
- (void)putButton:(int)level ;  // 放按鈕
- (IBAction)clickGamePause:(id)sender ; //按下暫停按鈕

- (void)updateTimer:(NSTimer *)theTimer ;  // UpdateTimer
- (IBAction) buttonClicked:(id)sender ;  // 踩踩樂

- (void)gameOver:(int)score ;  // 顯示成績之類
- (void)saveScore:(NSString *)name: (int)score ;    // 記錄成績

@end

@implementation GoldMiningPlayGame
@synthesize lblA;
@synthesize lblB;
@synthesize timerLabel;
@synthesize GamePauseBtn;
@synthesize levelSelect;

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
    [self setGame:[levelSelect intValue]];  // 設定難度
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTimerLabel:nil];
    [self setGamePauseBtn:nil];
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

- (void)setGame:(int)level
{
    [self putTimer:level];  // 放TImer
    [self putButton:level]; // 放Button
}

- (void)putTimer:(int)level
{
    self.timerLabel.text = @"\t2:\t00";
    ispause=NO;
    time_count=120;
	[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
}

- (void)putButton:(int)level
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
                self.lblA.text = [NSString stringWithFormat:@"%@ %d", self.lblA.text, [((NSNumber*)[arrGold objectAtIndex:i]) intValue]];
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
                self.lblB.text = [NSString stringWithFormat:@"%@ %d", self.lblB.text, [((NSNumber*)[arrShit objectAtIndex:i]) intValue]];
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
    for (int i = 0; i < [arrGold count]; i++)
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
    
    // 印出陣列
    for (int i = 0; i < [arrGame count]; i++)
    {
        NSLog(@"Game: %@ / %d", [arrGame objectAtIndex:i], Row * Col);
    }
    
    int k = 0;
    
    //////////// 動態產生按鈕
#define START_TOP 100   /* 按鈕開始高度 */
#define START_LEFT 10   /* 按鈕開始寬度 */
    
    for (int i = 0; i < Row; i++)
    {
        for (int j = 0; j < Col; j++)
        {
            CGRect frame = CGRectMake(j * btnSize + START_LEFT, i * btnSize + START_TOP, btnSize, btnSize);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = frame;
            //[button setTitle:[arrGame objectAtIndex:k] forState: UIControlStateNormal];
            [button setTitle:@" " forState: UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            button.tag = (j + 1) * 10000 + (i + 1) * 100 + [((NSNumber*)[arrGame objectAtIndex:k]) intValue];   // Y座標 X座標 ?
            /*
             switch ([((NSNumber*)[arrGame objectAtIndex:k]) intValue]) {
             case 11:
             [button se tImage:[UIImage imageNamed:@"f1.png"] forState:UIControlStateNormal];
             break;
             
             case 12:
             [button setImage:[UIImage imageNamed:@"f2.png"] forState:UIControlStateNormal];
             break;
             
             case 13:
             [button setImage:[UIImage imageNamed:@"f3.png"] forState:UIControlStateNormal];
             break;
             
             case 14:
             [button setImage:[UIImage imageNamed:@"f4.png"] forState:UIControlStateNormal];
             break;
             
             case 15:
             [button setImage:[UIImage imageNamed:@"f5.png"] forState:UIControlStateNormal];
             break;
             
             case 16:
             [button setImage:[UIImage imageNamed:@"f6.png"] forState:UIControlStateNormal];
             break;
             
             case 17:
             [button setImage:[UIImage imageNamed:@"f7.png"] forState:UIControlStateNormal];
             break;
             
             case 18:
             [button setImage:[UIImage imageNamed:@"f8.png"] forState:UIControlStateNormal];
             break;
             
             case 21:
             [button setImage:[UIImage imageNamed:@"r1.png"] forState:UIControlStateNormal];
             break;
             
             case 22:
             [button setImage:[UIImage imageNamed:@"r2.png"] forState:UIControlStateNormal];
             break;
             
             case 23:
             [button setImage:[UIImage imageNamed:@"r3.png"] forState:UIControlStateNormal];
             break;
             
             case 24:
             [button setImage:[UIImage imageNamed:@"r4.png"] forState:UIControlStateNormal];
             break;
             
             case 25:
             [button setImage:[UIImage imageNamed:@"r5.png"] forState:UIControlStateNormal];
             break;
             
             case 26:
             [button setImage:[UIImage imageNamed:@"r6.png"] forState:UIControlStateNormal];
             break;
             
             case 27:
             [button setImage:[UIImage imageNamed:@"r7.png"] forState:UIControlStateNormal];
             break;
             
             case 28:
             [button setImage:[UIImage imageNamed:@"r8.png"] forState:UIControlStateNormal];
             break;
             
             case 31:
             [button setImage:[UIImage imageNamed:@"b1.png"] forState:UIControlStateNormal];
             break;
             
             case 32:
             [button setImage:[UIImage imageNamed:@"b2.png"] forState:UIControlStateNormal];
             break;
             
             case 33:
             [button setImage:[UIImage imageNamed:@"b3.png"] forState:UIControlStateNormal];
             break;
             
             case 34:
             [button setImage:[UIImage imageNamed:@"b4.png"] forState:UIControlStateNormal];
             break;
             
             case 35:
             [button setImage:[UIImage imageNamed:@"b5.png"] forState:UIControlStateNormal];
             break;
             
             case 36:
             [button setImage:[UIImage imageNamed:@"b6.png"] forState:UIControlStateNormal];
             break;
             
             case 37:
             [button setImage:[UIImage imageNamed:@"b7.png"] forState:UIControlStateNormal];
             break;
             
             case 38:
             [button setImage:[UIImage imageNamed:@"b8.png"] forState:UIControlStateNormal];
             break;
             
             case 41:
             [button setImage:[UIImage imageNamed:@"g.png"] forState:UIControlStateNormal];
             break;
             
             case 51:
             [button setImage:[UIImage imageNamed:@"m.png"] forState:UIControlStateNormal];
             break;
             
             case 99:
             [button setImage:[UIImage imageNamed:@"images-1.jpeg"] forState:UIControlStateNormal];
             break;
             
             default:
             break;
             }*/
            
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
            
            k++;
        }
    }
    
    
}

- (IBAction)clickGamePause:(id)sender//按下暫停按鈕
{
    ispause = YES;
    // addSubView 繼續 選難度 重來
    // 繼續 -> 清掉subview 計時器繼續
    // 選難度 -> 回到SelectLevel 並清掉此View所有產生的東西
    // 重來 -> 清掉所有產生的東西 重新配置
}

- (void)updateTimer:(NSTimer *)theTimer {
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

// 按鈕事件
- (IBAction) buttonClicked:(id)sender {
    UIButton* btn = sender;
    NSString* strA = @"你已經死了";
    NSString* strB = [NSString stringWithFormat:@"%@\n%d", strA, btn.tag];
    
    switch (btn.tag % 100)
    {
        case 11:
            [btn setImage:[UIImage imageNamed:@"f1.png"] forState:UIControlStateNormal];
            break;
            
        case 12:
            [btn setImage:[UIImage imageNamed:@"f2.png"] forState:UIControlStateNormal];
            break;
            
        case 13:
            [btn setImage:[UIImage imageNamed:@"f3.png"] forState:UIControlStateNormal];
            break;
            
        case 14:
            [btn setImage:[UIImage imageNamed:@"f4.png"] forState:UIControlStateNormal];
            break;
            
        case 15:
            [btn setImage:[UIImage imageNamed:@"f5.png"] forState:UIControlStateNormal];
            break;
            
        case 16:
            [btn setImage:[UIImage imageNamed:@"f6.png"] forState:UIControlStateNormal];
            break;
            
        case 17:
            [btn setImage:[UIImage imageNamed:@"f7.png"] forState:UIControlStateNormal];
            break;
            
        case 18:
            [btn setImage:[UIImage imageNamed:@"f8.png"] forState:UIControlStateNormal];
            break;
            
        case 21:
            [btn setImage:[UIImage imageNamed:@"r1.png"] forState:UIControlStateNormal];
            break;
            
        case 22:
            [btn setImage:[UIImage imageNamed:@"r2.png"] forState:UIControlStateNormal];
            break;
            
        case 23:
            [btn setImage:[UIImage imageNamed:@"r3.png"] forState:UIControlStateNormal];
            break;
            
        case 24:
            [btn setImage:[UIImage imageNamed:@"r4.png"] forState:UIControlStateNormal];
            break;
            
        case 25:
            [btn setImage:[UIImage imageNamed:@"r5.png"] forState:UIControlStateNormal];
            break;
            
        case 26:
            [btn setImage:[UIImage imageNamed:@"r6.png"] forState:UIControlStateNormal];
            break;
            
        case 27:
            [btn setImage:[UIImage imageNamed:@"r7.png"] forState:UIControlStateNormal];
            break;
            
        case 28:
            [btn setImage:[UIImage imageNamed:@"r8.png"] forState:UIControlStateNormal];
            break;
            
        case 31:
            [btn setImage:[UIImage imageNamed:@"b1.png"] forState:UIControlStateNormal];
            break;
            
        case 32:
            [btn setImage:[UIImage imageNamed:@"b2.png"] forState:UIControlStateNormal];
            break;
            
        case 33:
            [btn setImage:[UIImage imageNamed:@"b3.png"] forState:UIControlStateNormal];
            break;
            
        case 34:
            [btn setImage:[UIImage imageNamed:@"b4.png"] forState:UIControlStateNormal];
            break;
            
        case 35:
            [btn setImage:[UIImage imageNamed:@"b5.png"] forState:UIControlStateNormal];
            break;
            
        case 36:
            [btn setImage:[UIImage imageNamed:@"b6.png"] forState:UIControlStateNormal];
            break;
            
        case 37:
            [btn setImage:[UIImage imageNamed:@"b7.png"] forState:UIControlStateNormal];
            break;
            
        case 38:
            [btn setImage:[UIImage imageNamed:@"b8.png"] forState:UIControlStateNormal];
            break;
            
        case 41:
            [btn setImage:[UIImage imageNamed:@"g.png"] forState:UIControlStateNormal];
            break;
            
        case 51:
            [btn setImage:[UIImage imageNamed:@"m.png"] forState:UIControlStateNormal];
            break;
            
        case 99:
            [btn setImage:[UIImage imageNamed:@"images-1.jpeg"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    //[[[UIAlertView alloc] initWithTitle:@"遊戲結束" message:strB delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil] show];        // GameOver Alert
}

- (void)gameOver:(int)score
{
    // 顯示成績 儲存成績之類
    // addSubView (?) 打星星
    // 主畫面 選難度 下一難度
}

- (void)saveScore:(NSString *)name: (int)score
{
    // 成績扔到SQLite
}

@end
