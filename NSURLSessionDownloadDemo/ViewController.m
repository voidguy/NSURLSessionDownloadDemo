//
//  ViewController.m
//  NSURLSessionDownloadDemo
//
//  Created by wtwo on 16/7/16.
//  Copyright © 2016年 wtwo. All rights reserved.
//

#import "ViewController.h"

static NSString *kRequestURL = @"https://github.com/rs/SDWebImage/archive/master.zip";

@interface ViewController ()<NSURLSessionDownloadDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView.progress = 0.0;
}

- (IBAction)startDownload:(id)sender {
    NSURL *url = [NSURL URLWithString:kRequestURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration delegate:self delegateQueue:NSOperationQueue.mainQueue];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    [task resume];
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
 totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"接受数据, 当前接受：%lld，已经接受：%lld，总接受：%lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    self.progressView.progress = 1.0f * totalBytesWritten / totalBytesExpectedToWrite;
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didFinishDownloadingToURL:(NSURL *)location {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"document: %@", documentPath);
    NSString *filePath = [documentPath stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    [NSFileManager.defaultManager moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:nil];
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
              didCompleteWithError:(NSError *)error {
    if (!error) {
        NSLog(@"请求完成");
    } else {
        NSLog(@"请求失败");
    }
}

@end
