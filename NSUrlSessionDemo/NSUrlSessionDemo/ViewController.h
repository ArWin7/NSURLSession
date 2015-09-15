//
//  ViewController.h
//  NSUrlSessionDemo
//
//  Created by ArWin on 9/14/15.
//  Copyright (c) 2015 ArWin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSURLSessionDelegate,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;

@end

