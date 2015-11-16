//
//  ViewController.m
//  HMPhotoPickerDemo
//
//  Created by HuminiOS on 15/11/16.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "ViewController.h"
#import "HMAlbumViewController.h"
#import "HMPhotoSelectViewController.h"
#import "HMPhotoPickerViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)clickToPickPhoto:(id)sender {
  HMAlbumViewController *albumVC = [[HMAlbumViewController alloc] init];
  albumVC.photoDelegate = self;
//  HMPhotoSelectViewController *pickVC = [[HMPhotoSelectViewController alloc] init];
//  [self presentViewController:albumVC animated:YES completion:NULL];
  
  HMPhotoPickerViewController *photoPickerVC = [[HMPhotoPickerViewController alloc] init];
  
  [self presentViewController:photoPickerVC animated:YES completion:NULL];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
