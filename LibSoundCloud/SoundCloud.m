//
//  SoundCloud.m
//  Stofkat.org
//
// First basic version of my custom SoundCloud library
// The one from SoundCloud has 5 dependancy projects just
// for some very basic funtionality. This project only uses
// JSONKit as an aditional library and should be much easier
// to implement in your own projects
// if you have any questions you can mail me at stofkat@gmail.com

//  Created by Stofkat.org on 23-05-14.
//  Copyright (c) 2014 Stofkat. All rights reserved.
//



#import "SoundCloud.h"
#import "JSONKit.h"
@implementation SoundCloud
{

    BOOL hasBeenLoggedIn;
}

//Logon to SoundCloud with the users account
-(BOOL) login {
    
    //check if we have the token stored in userprefs
    self.scToken=[[NSUserDefaults standardUserDefaults] objectForKey:SC_TOKEN];
    if(self.scToken && self.scToken.length>0) {
        //we are already logged in
        return true;
    }
    else {
        
        self.scCode=[[NSUserDefaults standardUserDefaults] objectForKey:SC_CODE];
        if(self.scCode)
        {
            [self doOauthWithCode:self.scCode];
            return true;
        }
        else
        {
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           //[self openLoginViewController];
                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://soundcloud.com/connect?client_id=%@&redirect_uri=%@&response_type=code",CLIENT_ID,REDIRECT_URI]]];
                       });
        return false;
        }
    }
    
}


- (void)doOauthWithCode: (NSString *)code {
    
    NSURL *url = [NSURL URLWithString:@"https://api.soundcloud.com/oauth2/token/"];
    NSString *postString =[NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",CLIENT_ID,CLIENT_SECRET,REDIRECT_URI,code];
    NSLog(@"post string: %@",postString);
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d", postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    NSString *responseBody = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"response body; %@",responseBody);
    
    NSMutableDictionary *resultJSON =[responseBody objectFromJSONString];
    self.scToken=[resultJSON objectForKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] setObject:self.scToken forKey:SC_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}




-(void) loginCallback :(NSString *) token
{
    if(token !=nil)
    {
        hasBeenLoggedIn=true;
        self.scToken = token;
    }
    
}

//Get list with full user tracks
-(NSMutableArray *) getUserTracks {
    
    NSString *jsonString =[NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.soundcloud.com/me/tracks.json?oauth_token=%@",self.scToken]] encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *musicArray =[jsonString objectFromJSONString];
    NSMutableArray *returnArray = [[NSMutableArray alloc]init];
    NSLog(@"%@",jsonString);

    self.scTrackResultList = [[NSMutableArray alloc]init];
    for(int i=0; i< musicArray.count;i++)
    {
        NSMutableDictionary *result = [musicArray objectAtIndex:i];
        if([[result objectForKey:@"kind" ] isEqualToString:@"track"])
        {
            [returnArray addObject:result];
        }
    }
    
    return returnArray;
}



//Search for music with the given query
-(NSMutableArray *) searchForTracksWithQuery: (NSString *) query {
    
    if(!self.scToken)
    {
        if(![self login])
        {
            return nil;
        }
    }
    if(query.length >0)
    query = [query stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *jsonString =[NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/tracks.json?oauth_token=%@&client_id=%@&q=%@",SC_API_URL,self.scToken,CLIENT_ID,query]] encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",jsonString);
    NSMutableArray *musicArray =[jsonString objectFromJSONString];
    self.scTrackResultList = [[NSMutableArray alloc]init];
    
    NSMutableArray *returnArray = [[NSMutableArray alloc]init];
    
    for(int i=0; i< musicArray.count;i++)
    {
        NSMutableDictionary *result = [musicArray objectAtIndex:i];
        if([[result objectForKey:@"kind" ] isEqualToString:@"track"])
        {
            [returnArray addObject:result];
        
        }
    }
    return returnArray;
}



//Return the data from the selected track url
//This can be directly played in an AVAudioPlayer without any modification
-(NSData *) downloadTrackData :(NSString *)songURL {
    
            NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?oauth_token=%@",songURL, self.scToken]]];
    
            return data;
            //NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            //[data writeToFile:[NSString stringWithFormat:@"%@/%@.mp3",documentsPath,songURL] atomically:YES];
}

@end
