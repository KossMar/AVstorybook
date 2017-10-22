

#import "PageModel.h"

@implementation PageModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _image = nil;
        _audioFile = nil;
    }
    return self;
}

@end
