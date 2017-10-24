

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PageModel.h"


@interface StoryPartViewController : UIViewController <AVAudioRecorderDelegate,AVAudioPlayerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSURL *audioFile;
@property (nonatomic) NSUInteger pageIndex;
@property (nonatomic) PageModel *pageModel;

@end

