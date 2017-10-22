

#import "StoryPartViewController.h"

@interface StoryPartViewController () <UIImagePickerControllerDelegate>

@end

@implementation StoryPartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playAudio:)];
    [self.imageView addGestureRecognizer:tapGesture];
    
    // Set the audio file
    NSArray *path = [NSArray arrayWithObjects:
                     [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                      lastObject], @"myAudio.m4a",  nil];
    
    NSURL *filURL = [NSURL fileURLWithPathComponents:path];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt: kAudioFormatMPEG4AAC] forKey: AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat: 44100.0] forKey: AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey: AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    _recorder = [[AVAudioRecorder alloc] initWithURL:filURL
                                            settings:recordSetting
                                               error:NULL];
    _recorder.delegate = self;
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
}

-(void)playAudio:(UITapGestureRecognizer*)sender {

    if (!_recorder.recording){
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recorder.url error:nil];
        [_player setDelegate:self];
        [_player play];
    }
    
    
    // code to stop audio
    
//    [_recorder stop];
//
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    [audioSession setActive:NO error:nil];
    
}


- (IBAction)recordAction:(UIButton *)sender {
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
        // Pause recording
        [_recorder stop];
        [_recordButton setTitle:@"Record" forState:UIControlStateNormal];
        [_recordButton setBackgroundColor:[UIColor purpleColor]];
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
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
