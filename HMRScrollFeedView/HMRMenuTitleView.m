//
//  HMRMenuTitleView.m
//  HMRScrollFeedView
//
//  Created by kuniorock on 2014/08/08.
//  Copyright (c) 2014年 himara2. All rights reserved.
//

#import "HMRMenuTitleView.h"

static const NSInteger HMR_TITLE_VIEW_HEIGHT = 20;

@implementation HMRMenuTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _titleLabel.text = title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _activeView = [[UIView alloc] initWithFrame:CGRectMake(5, frame.size.height-4, frame.size.width-10, 4)];
        _activeView.backgroundColor = [UIColor blackColor];
        _activeView.alpha = 0;
        [self addSubview:_activeView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (UIFont*)titleFont
{
    UIFont* font = [UIFont fontWithName:@"HiraKakuProN-W3" size:14];
    return font;
}

@end
