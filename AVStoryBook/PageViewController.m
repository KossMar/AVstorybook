

#import "PageViewController.h"


@interface PageViewController ()

@property (nonatomic) NSArray *pageModelArray;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.delegate = self;
    
    PageModel *pageModel1 = [PageModel new];
    PageModel *pageModel2 = [PageModel new];
    PageModel *pageModel3 = [PageModel new];
    PageModel *pageModel4 = [PageModel new];
    PageModel *pageModel5 = [PageModel new];
    
    self.pageModelArray = @[pageModel1,
                          pageModel2,
                          pageModel3,
                          pageModel4,
                          pageModel5];
    
    StoryPartViewController *initialVC = (StoryPartViewController *)[self viewControllerAtIndex:0];
    
    
    NSArray *viewControllers = [NSArray arrayWithObjects:initialVC, nil];
    
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
}

- (StoryPartViewController *) viewControllerAtIndex:(NSUInteger)index {

    StoryPartViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StoryPartViewController"];
    PageModel *modelProxy = self.pageModelArray[index];
    viewController.pageModel = modelProxy;
    viewController.pageIndex = index;
    return viewController;

}


- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerAfterViewController:(nonnull UIViewController *)viewController {
    
    NSUInteger index = ((StoryPartViewController*) viewController).pageIndex;



    if (index == NSNotFound){
        return nil;
    }
    index++;
    
    if (index == self.pageModelArray.count){
        return nil;
    }

    return [self viewControllerAtIndex:index];
    
}


- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController {
    
    
    
    NSUInteger index = ((StoryPartViewController*) viewController).pageIndex;

    
    if (index == 0 || index == NSNotFound){
        return nil;
    }
    index--;

        return [self viewControllerAtIndex:index];
    
}












@end
