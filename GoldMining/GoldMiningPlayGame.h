//
//  GoldMiningPlayGame.h
//  GoldMining
//
//  Created by 機器 王 on 12/7/4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoldMiningPlayGame : UIViewController
{
    Boolean ispause;
    int time_count;
}
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *GamePauseBtn;
-(IBAction)clickGamePause:(id)sender;

@end
