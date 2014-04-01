#import "HMRColorPalette.h"

@implementation HMRColorPalette

+ (UIColor *)colorWithIndex:(NSInteger)index {
    return [UIColor colorWithRed:0.8-index*30/255.0 green:0.4+index*15/255.0 blue:0.2+index*15/255.0 alpha:1.0];
}

@end
