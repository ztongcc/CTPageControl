//
//  CTPageControl.h
//  CTPageControl
//
//  Created by Admin on 16/10/8.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CTPageControlDidUpdateNotification @"CTPageControlDidUpdate"

@protocol CTPageControlDelegate;

@interface CTPageControl : UIView

@property (nonatomic, assign ) CGFloat                 normalWidth;
@property (nonatomic, assign ) CGFloat                 highlightedWidth;
@property (nonatomic,assign  ) CGFloat                 space;
@property (nonatomic,assign  ) NSInteger               currentPage;
@property (nonatomic,readonly) NSInteger               numberOfPages;
@property (nonatomic,copy    ) NSString              * pattern;
@property (nonatomic,assign  ) id<CTPageControlDelegate> delegate;

- (void)setImage:(UIImage *)normalImage
highlightedImage:(UIImage *)highlightedImage
          forKey:(NSString *)key;

@end

@protocol CTPageControlDelegate <NSObject>

@optional
- (BOOL)pageControl:(CTPageControl *)pageControl shouldUpdateToPage:(NSInteger)newPage;
- (void)pageControl:(CTPageControl *)pageControl didUpdateToPage:(NSInteger)newPage;

@end
