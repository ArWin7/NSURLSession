//
//  ViewController.m
//  NSUrlSessionDemo
//
//  Created by ArWin on 9/14/15.
//  Copyright (c) 2015 ArWin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSURLSession *session;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURLSessionConfiguration *sessionConfigutation = [NSURLSessionConfiguration defaultSessionConfiguration];
     session = [NSURLSession sessionWithConfiguration:sessionConfigutation delegate:self delegateQueue:nil];
    
    [self getDataTask];
    [self postDataTask];
    [self downloadTask];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getDataTask {
    //A data task (get) to query iTunes api
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"https://itunes.apple.com/search?term=apple&media=software"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"Response from iTunes API: %@",json);
    }];
    
    [dataTask resume];

}

-(void)postDataTask {
    NSURL *url = [NSURL URLWithString:@"http://hayageek.com/examples/jquery/ajax-post/ajax-post.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *parameters = @"name=Ashwin&loc=CA&age=25&submit=true";
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(error == nil) {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Data is : %@",str);
        }
        else {
        NSLog(@"Response is : %@, with error %@ \n",response,error);
        }
    }];
    
    [postDataTask resume];
}

-(void)downloadTask {
    //A download task to download an image
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:@"http://cdn.wonderfulengineering.com/wp-content/uploads/2014/03/high-resolution-wallpapers-25.jpg"]];
    
    [downloadTask resume];
}

#pragma NSURLSession DownloadTask Delegate Methods

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressView setHidden:YES];
        [self.loadingLabel setHidden:YES];
        [self.imageView setImage:[UIImage imageWithData:data]];
    });
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    float progress = (double)totalBytesWritten / (double) totalBytesExpectedToWrite;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressView setProgress:progress];
    });
}

#pragma NSURLSession DataTask Delegate Methods

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSLog(@"Received Data Task response");
    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Received data is : %@", str);
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if(error == nil) {
        NSLog(@"Download is Done !!!");
    }
    else {
        NSLog(@"Error Occurred: %@",error);
    }
}

@end
