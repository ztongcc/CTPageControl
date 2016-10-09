//
//  ViewController.m
//  CTPageControlDemo
//
//  Created by Admin on 16/10/9.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "ViewController.h"
#import "CTPageControl.h"

@interface ViewController ()<UIScrollViewDelegate, CTPageControlDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet CTPageControl *pageControl;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    for (int i=0; i<3; i++)
    {
        CGRect frame = CGRectMake(width * i,
                                  0,
                                  width,
                                  353);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:144.0];
        label.text = [NSString stringWithFormat:@"%d", i];
        
        [self.scrollView addSubview:label];
    }
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(width * 3, 353);
    
    self.scrollView.delegate = self;
    
    _pageControl.highlightedWidth = 16;
    [_pageControl setImage:[UIImage imageNamed:@"pageControl_dot_icon"]
          highlightedImage:[UIImage imageNamed:@"pageControl_H_dot_icon"]
                    forKey:@"a"];
    [_pageControl setPattern:@"aaa"];
    _pageControl.delegate = self;
}

- (void)updatePager
{
    _pageControl.currentPage = floorf(_scrollView.contentOffset.x / _scrollView.frame.size.width);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePager];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self updatePager];
    }
}

- (void)pageControl:(CTPageControl *)pageControl didUpdateToPage:(NSInteger)newPage
{
    CGPoint offset = CGPointMake(_scrollView.frame.size.width * pageControl.currentPage, 0);
    [_scrollView setContentOffset:offset animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
