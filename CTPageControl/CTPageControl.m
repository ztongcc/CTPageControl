//
//  CTPageControl.m
//  CTPageControl
//
//  Created by Admin on 16/10/8.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "CTPageControl.h"

@implementation CTPageControl
{
    NSMutableDictionary *_images;
    NSMutableArray      *_pageViews;
}

- (void)commonInit
{
    _normalWidth = 7;
    _highlightedWidth = 7;
    _space = 5;
    _currentPage = 0;
    _pattern = @"";
    _images = [NSMutableDictionary dictionary];
    _pageViews = [NSMutableArray array];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    // Skip if delegate said "do not update"
    if ([_delegate respondsToSelector:@selector(pageControl:shouldUpdateToPage:)] &&
        ![_delegate pageControl:self shouldUpdateToPage:currentPage])
    {
        return;
    }
    
    _currentPage = currentPage;
    [self setNeedsLayout];
    
    // Inform delegate of the update
    if ([_delegate respondsToSelector:@selector(pageControl:didUpdateToPage:)])
    {
        [_delegate pageControl:self didUpdateToPage:currentPage];
    }
    
    // Send update notification
    [[NSNotificationCenter defaultCenter] postNotificationName:CTPageControlDidUpdateNotification object:self];
}

- (NSInteger)numberOfPages
{
    return _pattern.length;
}

- (void)tapped:(UITapGestureRecognizer *)recognizer
{
    self.currentPage = [_pageViews indexOfObject:recognizer.view];
}

- (UIImageView *)imageViewForKey:(NSString *)key
{
    NSDictionary *imageData = [_images objectForKey:key];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[imageData objectForKey:@"normal"] highlightedImage:[imageData objectForKey:@"highlighted"]];
    imageView.frame = CGRectMake(0, 0, _normalWidth, 7);
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeCenter;
    imageView.clipsToBounds = YES;
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [imageView addGestureRecognizer:tgr];
    
    return imageView;
}

- (void)layoutSubviews
{
    [_pageViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = obj;
        [view removeFromSuperview];
    }];
    [_pageViews removeAllObjects];
    
    NSInteger pages = self.numberOfPages;
    
    CGFloat xOffset = (CGRectGetWidth(self.frame) - (pages - 1) * (_normalWidth + _space) - _highlightedWidth)/2.0;
    for (int i = 0; i<pages; i++) {
        NSString *key = [_pattern substringWithRange:NSMakeRange(i, 1)];
        UIImageView *imageView = [self imageViewForKey:key];
        
        CGRect frame = imageView.frame;
        frame.origin.x = xOffset;
        if (i == self.currentPage)
        {
            imageView.highlighted = YES;
            frame.size.width = _highlightedWidth;
        }
        imageView.frame = frame;
        [self addSubview:imageView];
        [_pageViews addObject:imageView];
        
        xOffset = xOffset + frame.size.width + _space;
    }
}

- (void)setImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage forKey:(NSString *)key
{
    NSDictionary *imageData = [NSDictionary dictionaryWithObjectsAndKeys:image, @"normal", highlightedImage, @"highlighted", nil];
    [_images setObject:imageData forKey:key];
    [self setNeedsLayout];
}


@end
