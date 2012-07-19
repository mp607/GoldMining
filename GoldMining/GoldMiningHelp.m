//
//  GoldMiningHelp.m
//  GoldMining
//
//  Created by 王 機器 on 12/7/19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GoldMiningHelp.h"

@interface GoldMiningHelp ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation GoldMiningHelp
@synthesize webView;

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
	// 不允許捲動`
	[(UIScrollView *)[[webView subviews] objectAtIndex:0]    setBounces:NO];
	
	// 取得檔案路徑 
    NSString *path = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"html"];

	
	if ( [[NSFileManager defaultManager] fileExistsAtPath:path] )
	{
	
		//htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
		[webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
	}
	else {
		NSString *htmlString = @"<H1>404 Not Found</H1>";
		[webView loadHTMLString:htmlString baseURL:nil];
	}
	
	[super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
	[self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)homeBtnPressed:(id)sender 
{
	// bake to Home
	[self dismissModalViewControllerAnimated:YES];
}

@end
