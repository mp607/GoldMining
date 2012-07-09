//
//  GoldMiningPlayGame.h
//  GoldMining
//
//  Created by 機器 王 on 12/7/4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoldMiningPlayGame : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
- (IBAction)clickGamePause:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblA;

@end
