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

@property NSNumber *levelSelect;    // 接收SelectLevel傳來的level

@property (weak, nonatomic) IBOutlet UILabel *lblA;
@property (weak, nonatomic) IBOutlet UILabel *lblB;

@end
