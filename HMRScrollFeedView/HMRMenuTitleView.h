//
//  HMRMenuTitleView.h
//  HMRScrollFeedView
//
//  Created by kuniorock on 2014/08/08.
//  Copyright (c) 2014年 himara2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMRMenuTitleView : UIView

@property(nonatomic) UILabel* titleLabel;

@property(nonatomic) CGFloat targetLeftPosition;
@property(nonatomic) UIView* activeView;

+ (UIFont*)titleFont;

- (id)initWithFrame:(CGRect)frame title:(NSString*)title;

@end
