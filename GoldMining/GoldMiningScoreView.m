//
//  GoldMiningScoreView.m
//  GoldMining
//
//  Created by iMac on 12/7/9.
//
//

#import "GoldMiningScoreView.h"

@interface GoldMiningScoreView ()

@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSMutableArray *labelArray;
@end

@implementation GoldMiningScoreView
@synthesize scoreView;
@synthesize dataSource;
@synthesize labelArray;

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
	[self setLabel];
}

- (void)viewDidUnload
{
	[self setScoreView:nil];
	[super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
	// 載入分數
	[self loadScore];
}

- (void)viewDidDisappear:(BOOL)animated
{
	// 清掉資料
	[self setLabelArray:nil];
	[self setDataSource:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadScore
{
	// 取得檔案路徑
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"score.plist"];
	
	if ( [[NSFileManager defaultManager] fileExistsAtPath:plistPath] )
	{
		// 讀出檔案
		dataSource = [[NSArray alloc] initWithContentsOfFile:plistPath];

		NSString *ranking, *name, *score, *date;
		
		// 格式化時間
		NSDateFormatter *formatrer = [[NSDateFormatter alloc] init];
		[formatrer setDateFormat:@"YY-MM-dd hh:mm:ss"];
		
		int i = 1;
		for (NSDictionary *dictionary in dataSource) {
			ranking = [NSString stringWithFormat:@"%d", i];
			[[[labelArray objectAtIndex:i] objectForKey:@"ranking"] setText:ranking];
			
			name = [dictionary objectForKey:@"name"];
			[[[labelArray objectAtIndex:i] objectForKey:@"name"] setText:name];
			
			score = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"score"]];
			[[[labelArray objectAtIndex:i] objectForKey:@"score"] setText:score];
			
			date = [formatrer stringFromDate:[dictionary objectForKey:@"date"]];
			[[[labelArray objectAtIndex:i] objectForKey:@"date"] setText:date];
			
			i++;
		}
	}
	else
	{
		// 沒有資料
		NSLog(@"no file score.plist");
	}
}

- (void)setLabel
{
	labelArray = [NSMutableArray array];
	double height = scoreView.frame.size.height * 0.09;

	for (int i=0; i<11; i++) {
		// 排名
		UILabel *rLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, i * height, scoreView.frame.size.width * 0.1, height)];
		[rLabel setTextAlignment:UITextAlignmentCenter];
		[scoreView addSubview:rLabel];
		
		// name
		UILabel *nLabel = [[UILabel alloc] initWithFrame:CGRectMake(rLabel.frame.size.width, i * height, scoreView.frame.size.width * 0.2, height)];
		[nLabel setTextAlignment:UITextAlignmentRight];
		[scoreView addSubview:nLabel];

		// score
		UILabel *sLabel = [[UILabel alloc] initWithFrame:CGRectMake(rLabel.frame.size.width + nLabel.frame.size.width, i * height, scoreView.frame.size.width * 0.2, height)];
		[sLabel setTextAlignment:UITextAlignmentRight];
		[scoreView addSubview:sLabel];

		// date
		UILabel *dLabel = [[UILabel alloc] initWithFrame:CGRectMake(rLabel.frame.size.width + nLabel.frame.size.width + sLabel.frame.size.width, i * height, scoreView.frame.size.width * 0.5, height)];
		[dLabel setTextAlignment:UITextAlignmentCenter];
		[scoreView addSubview:dLabel];
		

		[labelArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:rLabel, @"ranking", nLabel, @"name", sLabel, @"score", dLabel, @"date", nil]];
	}
	
	[[[labelArray objectAtIndex:0] objectForKey:@"ranking"] setAdjustsFontSizeToFitWidth:YES];
	[[[labelArray objectAtIndex:0] objectForKey:@"ranking"] setText:@"名次"];
	[[[labelArray objectAtIndex:0] objectForKey:@"name"] setText:@"姓名"];
	[[[labelArray objectAtIndex:0] objectForKey:@"score"] setText:@"分數"];
	[[[labelArray objectAtIndex:0] objectForKey:@"date"] setText:@"時間"];
}

- (IBAction)clearBtnPressed:(id)sender 
{	
	UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Would you want to delete?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Yes, delete it!" otherButtonTitles:nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if (buttonIndex == 0) {
		// 取得檔案路徑
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsPath = [paths objectAtIndex:0];
		NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"score.plist"];
		
		if ( [[NSFileManager defaultManager] fileExistsAtPath:plistPath] )
			[[NSFileManager defaultManager] removeItemAtPath:plistPath error:NULL];
		
		for (int i=1; i<labelArray.count; i++) {
			[[[labelArray objectAtIndex:i] objectForKey:@"ranking"] setText:nil];
			[[[labelArray objectAtIndex:i] objectForKey:@"name"] setText:nil];
			[[[labelArray objectAtIndex:i] objectForKey:@"score"] setText:nil];
			[[[labelArray objectAtIndex:i] objectForKey:@"date"] setText:nil];
		}
		
	}
}



@end
