//
//  ViewViewController.h
//  LibSoundCloud
//
//  Created by Stofkat.org on 23-05-14.
//  Copyright (c) 2014 Stofkat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundCloud.h"
#import <AVFoundation/AVFoundation.h>
@interface MainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *txtSearchField;
@property (strong, nonatomic) IBOutlet UITextField *txtURLField;
@property (nonatomic, retain) SoundCloud *soundCloud;

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

@end
