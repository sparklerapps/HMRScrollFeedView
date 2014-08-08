#import "HMRViewController.h"
#import "HMRScrollFeedView.h"
#import "HMRSampleViewController.h"
#import "HMRColorPalette.h"
#import "HMRMenuTitleView.h"

static const NSInteger MenuWidth = 80;
static const NSInteger MenuHeight = 45;

@interface HMRViewController ()
<HMRScrollFeedViewDelegate, HMRScrollFeedViewDataSource>

@property (nonatomic) HMRScrollFeedView *feedView;

@property (nonatomic) NSArray *titles;

@end


@implementation HMRViewController

- (void)loadView {
    
    self.titles = @[@"1",
                    @"12",
                    @"123",
                    @"1234",
                    @"12345",
                    @"123456",
                    @"1234567",
                    @"12345678",
                    @"123456789",
                    @"1234567890"];
    
    self.view = self.feedView;
}

- (HMRScrollFeedView *)feedView {
    if (_feedView == nil) {
        self.feedView = [[HMRScrollFeedView alloc] initWithStyle:UIPageViewControllerTransitionStylePageCurl];
        _feedView.hmrDataSource = self;
        _feedView.hmrDelegate = self;
        [_feedView reloadData];
    }
    return _feedView;
}

//--------------------------------------------------
#pragma mark - Delegate
//--------------------------------------------------
#pragma mark === HMRScrollFeedViewDataSource ===
//--------------------------------------------------
- (NSInteger)numberOfPages:(HMRScrollFeedView *)scrollFeedView {
    return [_titles count];
}

- (CGFloat)heightOfMenuView:(HMRScrollFeedView *)scrollFeedView
{
    return MenuHeight;
}

- (HMRMenuTitleView*)scrollFeedView:(HMRScrollFeedView*)scrollFeedView titleViewAtIndex:(NSInteger)index
{
    CGFloat marginWidth = 10;
    NSString* title = _titles[index];
    CGSize size = [title sizeWithFont:[HMRMenuTitleView titleFont]];
    if( size.width < 50 ){
        size.width = 50;
    }
    
    size.width += marginWidth;
    
    HMRMenuTitleView* v = [[HMRMenuTitleView alloc] initWithFrame:CGRectMake(0, 0, size.width, MenuHeight) title:_titles[index]];
    v.backgroundColor = [HMRColorPalette colorWithIndex:index];
    
    return v;
}

//--------------------------------------------------
#pragma mark === HMRScrollFeedViewDelegate ===
//--------------------------------------------------
- (CGFloat)scrollFeedView:(HMRScrollFeedView *)scrollFeedView widthForMenuViewAtIndex:(NSInteger)index
{
    CGFloat marginWidth = 10;
    NSString* title = _titles[index];
    CGSize size = [title sizeWithFont:[HMRMenuTitleView titleFont]];
    if( size.width < 50 ){
        size.width = 50;
    }
    
    size.width += marginWidth;
    
    return size.width;
}

- (NSArray *)viewsForMenuView:(HMRScrollFeedView *)scrollFeedView {
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<[_titles count]; i++) {
        // create view controller
//        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MenuWidth, MenuHeight)];
        
        
        CGFloat marginWidth = 10;
        NSString* title = _titles[i];
        CGSize size = [title sizeWithFont:[HMRMenuTitleView titleFont]];
        if( size.width < 50 ){
            size.width = 50;
        }
        
        size.width += marginWidth;
        
        HMRMenuTitleView* v = [[HMRMenuTitleView alloc] initWithFrame:CGRectMake(0, 0, size.width, MenuHeight) title:_titles[i]];
        v.titleLabel.text = _titles[i];
        v.backgroundColor = [HMRColorPalette colorWithIndex:i];
        [array addObject:v];
    }
    
    return [array copy];
}

- (NSArray *)viewsForFeedView:(HMRScrollFeedView *)scrollFeedView {
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<[_titles count]; i++) {
        // create rview controller
        HMRSampleViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SampleViewController"];
        [vc view];
        vc.titleLabel.text = [NSString stringWithFormat:@"%d", i];
        vc.view.backgroundColor = [HMRColorPalette colorWithIndex:i];
                
        [array addObject:vc];
    }
    
    return [array copy];
}


#pragma mark - HMRScrollFeedViewDelegate

- (void)scrollFeedView:(HMRScrollFeedView *)scrollFeedView didChangeCurrentPage:(NSInteger)page {
    NSLog(@"ページ遷移Done. page: %ld", page);
}



#pragma mark - Status bar hidden

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
