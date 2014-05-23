//
//  SCLoginViewController.h
//  Stofkat.org
//
//  Created by Stofkat on 08-05-14.
//
//

#import <UIKit/UIKit.h>

@interface SCLoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic)  NSString *scToken;
@property (strong, nonatomic)  NSString *scCode;
@property id soundCloudDelegate;
@end
