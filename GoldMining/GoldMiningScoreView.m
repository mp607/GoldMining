//
//  GoldMiningScoreView.m
//  GoldMining
//
//  Created by iMac on 12/7/9.
//
//

#import "GoldMiningScoreView.h"

@interface GoldMiningScoreView ()

@end

@implementation GoldMiningScoreView

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
    //if ([name isEqualToString:@""]) name = @"無名氏";
     NSLog(@"rrrrfgfdg");
    dataSource = [[NSMutableArray alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"my.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath] ) {
        NSMutableArray *data = [[NSArray alloc]initWithContentsOfFile:plistPath];
        NSLog(@"%@",[NSString stringWithFormat:@"%d",data.count]);
       
        
        
        
    } else{ 
        //[textView setText:@"沒有資料，讀取失敗！"];
        NSLog(@"沒有資料，讀取失敗！ init my.plist ");
        NSMutableArray *data = [[NSArray alloc] initWithObjects:@"Default,0", nil];
        
        [data writeToFile:plistPath atomically:YES];
        [dataSource addObjectsFromArray:data];
        
    }
    [super viewDidLoad];
    NSLog(@"fgfdg");

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setLabel
{
	int i;
	for (i=0; i<10; i++) {
		CGRect labelRect = CGRectMake(self.view.frame.size.width / 10, (self.view.frame.size.height / 12) * i, self.view.frame.size.width * 0.8, self.view.frame.size.height / 12);
		UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
		
		[self.view addSubview:label];
	}
}

@end
