#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "HMRMenuTitleView.h"

@class HMRScrollFeedView;

//UITableViewDataSource
//UITableViewDelegate

//--------------------------------------------------
#pragma mark - HMRScrollFeedViewDataSource
//--------------------------------------------------
@protocol HMRScrollFeedViewDataSource <NSObject>

@required

/**
 *  メニュー数を返却する
 *
 *  @param scrollFeedView HMRScrollFeedView
 *
 *  @return メニュー数
 */
- (NSInteger)numberOfPages:(HMRScrollFeedView *)scrollFeedView;

/**
 *  メニューの縦幅を返却する
 *
 *  @param scrollFeedView HMRScrollFeedView
 *
 *  @return 縦幅
 */
- (CGFloat)heightOfMenuView:(HMRScrollFeedView *)scrollFeedView;

/**
 *  メニューを返却する
 *
 *  @param scrollFeedView HMRScrollFeedView
 *  @param index          NSInteger
 *
 *  @return メニュー
 */
- (HMRMenuTitleView*)scrollFeedView:(HMRScrollFeedView*)scrollFeedView titleViewAtIndex:(NSInteger)index;

- (NSArray *)viewsForMenuView:(HMRScrollFeedView *)scrollFeedView;
- (NSArray *)viewsForFeedView:(HMRScrollFeedView *)scrollFeedView;

@end

@protocol HMRScrollFeedViewDelegate <NSObject>

/**
 *  各メニューの横幅を返却する
 *
 *  @param scrollFeedView HMRScrollFeedView
 *  @param index          NSInteger
 *
 *  @return 横幅
 */
- (CGFloat)scrollFeedView:(HMRScrollFeedView *)scrollFeedView widthForMenuViewAtIndex:(NSInteger)index;

- (void)scrollFeedView:(HMRScrollFeedView *)scrollFeedView didChangeCurrentPage:(NSInteger)page;

@end


@interface HMRScrollFeedView : UIView

@property (nonatomic, weak) id<HMRScrollFeedViewDataSource> hmrDataSource;
@property (nonatomic, weak) id<HMRScrollFeedViewDelegate> hmrDelegate;

@property (nonatomic, readonly) NSInteger currentPageIndex;
@property (nonatomic, readonly) UIPageViewControllerTransitionStyle transitionStyle;

- (id)initWithStyle:(UIPageViewControllerTransitionStyle)transitionStyle;
- (id)initWithFrame:(CGRect)frame
              style:(UIPageViewControllerTransitionStyle)transitionStyle;

- (void)reloadData;

@end
