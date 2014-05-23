//
//  ViewViewController.m
//  LibSoundCloud

//  Created by Stofkat.org on 23-05-14.
//  Copyright (c) 2014 Stofkat. All rights reserved.
//

#import "MainViewController.h"
#import "SoundCloud.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.soundCloud =[[SoundCloud alloc]init];
    
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)btnSearchClicked:(id)sender {
    
    [self.soundCloud searchForTracksWithQuery:self.txtSearchField.text];
    
}
- (IBAction)btnStreamClicked:(id)sender {
    
   NSData *data =[self.soundCloud downloadTrackData:self.txtURLField.text];
    
    self.audioPlayer = [[AVAudioPlayer alloc]initWithData:data error:nil];
    [self.audioPlayer play];
}
- (IBAction)btnGetUserSongsClicked:(id)sender {
    
    [self.soundCloud getUserTracks];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
