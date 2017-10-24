

#import "StoryPartViewController.h"

@interface StoryPartViewController () <UIImagePickerControllerDelegate>

@property (nonatomic) NSString *path;

@end

@implementation StoryPartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    
    self.imageView.image = self.pageModel.image;

    NSArray* allPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    NSString *fileName = [NSString stringWithFormat:@"myAudio%lu.m4a", (unsigned long)self.pageIndex];

    
    NSString* myPath = [[allPaths objectAtIndex:0] stringByAppendingPathComponent: fileName];
    
    NSFileManager *myManager = [NSFileManager defaultManager];
    
    
    
    self.path = myPath;
    self.pageModel.audioFile = [NSURL URLWithString:self.path];
    NSLog(@"My path sis : %@", myPath);
    
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    
    [recordSetting setValue:[NSNumber numberWithInt: kAudioFormatMPEG4AAC] forKey: AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat: 44100.0] forKey: AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey: AVNumberOfChannelsKey];
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:self.pageModel.audioFile
                                            settings:recordSetting
                                               error:NULL];




    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playAudio:)];
    [self.imageView addGestureRecognizer:tapGesture];
    
    
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    
    _recorder.delegate = self;
    _recorder.meteringEnabled = YES;
}

-(void)playAudio:(UITapGestureRecognizer*)sender {

    if (_recorder.recording)
       return;

       
    if ( self.path == nil)
        return;
    

    
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.pageModel.audioFile error:nil];
    [_player setDelegate:self];
    [_player play];

    
}


- (IBAction)recordAction:(UIButton *)sender {
   
    // THIS OVERWRITES THE EXISTING AUDIO FILE AT THE EXISTING PATH EVERYTIME YOU CALL IT!!!!
    [_recorder prepareToRecord];

    
    if (_player.playing) {
        [_player stop];
    }
    
    if (!_recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [_recorder record];
        [_recordButton setTitle:@"Stop" forState:UIControlStateNormal];
        [_recordButton setBackgroundColor:[UIColor redColor]];
        
    } else {
        // stop recording
        [_recorder stop];

    }

}
    

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [_recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [_recordButton setBackgroundColor:[UIColor purpleColor]];

    
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Done"
                                                                   message:@"That's it folks"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    
    [self presentViewController:alert animated:true completion:nil];
}

- (IBAction)cameraPrompt:(UIButton *)sender {
    
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"So you want a new image, hey?"
                                                                      message:@""
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Take Photo"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    
        {
            /** What we write here???????? **/
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
            
            // call method whatever u need
        }];
        
        UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Select Photo"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
        {
            /** What we write here???????? **/
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:picker animated:YES completion:NULL];
            
            // call method whatever u need
        }];
        
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                             handler:nil];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        [alert addAction:cancelButton];
                                       
        
        [self presentViewController:alert animated:YES completion:nil];

    }
        
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    self.imageView.image = chosenImage;
    self.pageModel.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
