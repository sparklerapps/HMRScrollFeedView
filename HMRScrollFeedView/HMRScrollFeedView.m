#import "HMRScrollFeedView.h"

@interface HMRScrollFeedView ()
<
UIPageViewControllerDataSource,
UIPageViewControllerDelegate,
UIScrollViewDelegate
>

@property (nonatomic) UIPageViewControllerTransitionStyle transitionStyle;

// for menu
@property (nonatomic) UIScrollView *menuScrollView;
//@property (nonatomic) CGSize menuSize;
@property (nonatomic) CGFloat menuHeight;
@property (nonatomic) NSMutableArray* menus;

// for feed
@property (nonatomic) NSArray *viewControllers;
@property (nonatomic) UIPageViewController *pageViewController;

@property (nonatomic,strong) UIView* activeView;

@property (nonatomic, readonly) NSInteger beforePageIndex;
@end


@implementation HMRScrollFeedView

- (id)init
{
    return [self initWithFrame:[UIScreen mainScreen].applicationFrame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithStyle:(UIPageViewControllerTransitionStyle)transitionStyle
{
    self = [self init];
    _transitionStyle = transitionStyle;
    
    if (self) {
        [self initialize];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
              style:(UIPageViewControllerTransitionStyle)transitionStyle
{
    self = [self initWithFrame:frame];
    _transitionStyle = transitionStyle;
    
    if (self) {
        [self initialize];
    }
    return self;
}


- (void)initialize
{
    self.menuScrollView = [[UIScrollView alloc] init];
    _menuScrollView.showsHorizontalScrollIndicator = NO;
    _menuScrollView.delegate = self;
    [self addSubview:_menuScrollView];
    
    self.pageViewController = [[UIPageViewController alloc]
                               initWithTransitionStyle:_transitionStyle
                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                               options:nil];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;

    [self insertSubview:_pageViewController.view belowSubview:_menuScrollView];
}

- (void)setHmrDataSource:(id<HMRScrollFeedViewDataSource>)hmrDataSource {
    _hmrDataSource = hmrDataSource;
//    [self reloadData];
}

- (void)reloadData {
//    _menuSize = [_hmrDataSource sizeOfMenuView:self];
    _menuHeight = [_hmrDataSource heightOfMenuView:self];
    _menuScrollView.frame = CGRectMake(self.frame.origin.x,
                                       self.frame.origin.x,
                                       self.frame.size.width,
                                       _menuHeight);
    [self layoutMenuScrollView];
    
    _pageViewController.view.frame = CGRectMake(self.frame.origin.x,
                                                _menuHeight,
                                                self.frame.size.width,
                                                self.frame.size.height - _menuHeight);
    
    self.viewControllers = [_hmrDataSource viewsForFeedView:self];
    if ([_viewControllers count] > 0) {
        [_pageViewController setViewControllers:@[_viewControllers[0]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    }
}

- (void)layoutMenuScrollView {
    NSInteger pageCount = [_hmrDataSource numberOfPages:self];
    
    if( _menus ){
        [_menus removeAllObjects];
    }
    else{
        _menus = [NSMutableArray new];
    }
    
    CGFloat margin = 0;
    
    CGFloat contentWidth = 0;
    for( NSInteger i1 = 0; i1 < pageCount; i1++ ){
        contentWidth += margin;
        CGFloat menuWidth = [_hmrDelegate scrollFeedView:self widthForMenuViewAtIndex:i1];
        HMRMenuTitleView* titleView = [_hmrDataSource scrollFeedView:self titleViewAtIndex:i1];
        titleView.frame = CGRectMake(contentWidth, 0, menuWidth, _menuHeight);
        titleView.tag = i1;
        titleView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(didTapMenuView:)];
        [titleView addGestureRecognizer:tapGesture];
        
        contentWidth += menuWidth;
        
        [_menus addObject:titleView];
        [_menuScrollView addSubview:titleView];
        
        if( i1 == 0 ){
            if( _activeView ){
                [_activeView removeFromSuperview];
            }
            _activeView = [[UIView alloc] initWithFrame:CGRectMake(titleView.frame.origin.x,
                                                                   titleView.frame.size.height-5,
                                                                   titleView.frame.size.width,
                                                                   5)];
            _activeView.backgroundColor = [UIColor whiteColor];
            _activeView.alpha = 1;
            [_menuScrollView addSubview:_activeView];
        }
    }
    
    [_menuScrollView bringSubviewToFront:_activeView];
    
    _menuScrollView.contentSize = CGSizeMake(contentWidth, _menuHeight);
}

- (UIPageViewControllerTransitionStyle)transitionStyle {
    return _pageViewController.transitionStyle;
}

- (UIPageViewControllerNavigationOrientation)navigationOrientation {
    return _pageViewController.navigationOrientation;
}


#pragma mark - UIPageViewControlDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSInteger page = [self indexOfViewController:viewController];

    if (page == NSNotFound) {
        return nil;
    }
    if (page == 0) {
        return nil;
    }
    
    page--;
    
    return _viewControllers[page];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
//    NSLog(@"viewControllerAfterViewController");
    NSInteger page = [self indexOfViewController:viewController];
    
    if (page == NSNotFound) {
        return nil;
    }
    if (page == [_hmrDataSource numberOfPages:self] - 1) {
        return nil;
    }
    page++;
    
    return _viewControllers[page];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    NSLog(@"willTransitionToViewControllers");
    if ([pendingViewControllers count] > 0) {
        NSInteger page = [self indexOfViewController:pendingViewControllers[0]];
//        NSLog(@"INDEX:%d",page);
        _beforePageIndex = _currentPageIndex;
        _currentPageIndex = page;
        
        
        [self moveToPageIndexInMenuScrollViewWithIndex:_currentPageIndex];
        
        HMRMenuTitleView* targetTitleView = _menus[_currentPageIndex];
        [UIView animateWithDuration:0.3f
                         animations:^{
                             _activeView.frame = CGRectMake(targetTitleView.frame.origin.x,
                                                            _activeView.frame.origin.y,
                                                            targetTitleView.frame.size.width,
                                                            _activeView.frame.size.height);
                         }];
    }
}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController
{
    return [_viewControllers indexOfObject:viewController];
}


#pragma mark - MenuScrollView Methods

- (void)moveToPageIndexInMenuScrollViewWithIndex:(NSInteger)index {
    
    CGFloat screenHalfWidth = _menuScrollView.frame.size.width/2;
    HMRMenuTitleView* targetTitleView = _menus[index];
    
    CGRect destFrame = CGRectMake(targetTitleView.frame.origin.x + targetTitleView.frame.size.width/2 - screenHalfWidth,
                                  0,
                                  _menuScrollView.frame.size.width,
                                  _menuScrollView.frame.size.height);
    [_menuScrollView scrollRectToVisible:destFrame animated:YES];
}

- (void)didTapMenuView:(UITapGestureRecognizer *)gesture {
    UIView *view = [gesture view];
    NSInteger destIndex = view.tag;
    
    if (_currentPageIndex == destIndex) {
        return;
    }
    
    UIPageViewControllerNavigationDirection direction;
    if (_currentPageIndex > destIndex) {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    else if (_currentPageIndex < destIndex) {
        direction = UIPageViewControllerNavigationDirectionForward;
    }
    
    __unsafe_unretained id _self = self;
    
    [_pageViewController setViewControllers:@[_viewControllers[destIndex]]
                                  direction:direction
                                   animated:YES
                                 completion:^(BOOL finished) {
                                     [_self didChangeCurrentPage];
                                 }];
    _currentPageIndex = destIndex;
    
    [self moveToPageIndexInMenuScrollViewWithIndex:destIndex];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    NSLog(@"didFinishAnimating  finished:%d completed:%d",finished,completed);
    if( completed ){
        [self didChangeCurrentPage];
    }
    else{
        _currentPageIndex = _beforePageIndex;
    }
    
    HMRMenuTitleView* targetTitleView = _menus[_currentPageIndex];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         _activeView.frame = CGRectMake(targetTitleView.frame.origin.x,
                                                        _activeView.frame.origin.y,
                                                        targetTitleView.frame.size.width,
                                                        _activeView.frame.size.height);
                     }];
    
}

- (void)didChangeCurrentPage {
    NSLog(@"didChangeCurrentPage    %d:",_currentPageIndex);
    if ([_hmrDelegate respondsToSelector:@selector(scrollFeedView:didChangeCurrentPage:)]) {
        [_hmrDelegate scrollFeedView:self didChangeCurrentPage:_currentPageIndex];
    }
}

@end
