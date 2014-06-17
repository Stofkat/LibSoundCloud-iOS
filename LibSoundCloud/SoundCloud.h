//
//  SoundCloud.h
//  Stofkat.org
//
// First basic version of my custom SoundCloud library
// The one from SoundCloud has 5 dependancy projects just
// for some very basic funtionality. This project only uses
// JSONKit as an aditional library and should be much easier
// to implement in your own projects
// if you have any questions you can mail me at stofkat@gmail.com
//  Created by Stofkat on 08-05-14.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface SoundCloud : NSObject

//Change these to your own apps values
#define CLIENT_ID @"ab91a50019b2954d03cad204bd6ace99"
#define CLIENT_SECRET @"f7e8588e40c22510686d80a198331774"
#define REDIRECT_URI @"yourappname://oauth"//don't forget to change this in Info.plist as well

#define SC_API_URL @"https://api.soundcloud.com"
#define SC_TOKEN @"SC_TOKEN"
#define SC_CODE @"SC_CODE"

@property (strong, nonatomic)  NSMutableArray *scTrackResultList;
@property (nonatomic,retain) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic)  NSString *scToken;
@property (strong, nonatomic)  NSString *scCode;


-(NSMutableArray *) searchForTracksWithQuery: (NSString *) query;
-(NSData *) downloadTrackData :(NSString *)songURL;
-(NSMutableArray *) getUserTracks;
-(BOOL) login;
@end
