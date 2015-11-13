//
//  ViewController.m
//  photosFramework
//
//  Created by HuminiOS on 15/11/11.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import "HMAlbumViewController.h"
@interface ViewController ()
{
  PHCachingImageManager *imageManage ;
  __weak IBOutlet UIImageView *theImageView;
}
@end

@implementation ViewController
- (IBAction)clicktoDoSomething:(id)sender {
//  HMAlbumViewController *nextcontroller = [[HMAlbumViewController alloc] init];

  //  [self pushViewController:nextcontroller animated:YES];
//  [self.navigationController pushViewController:nextcontroller animated:YES];
  
  UIViewController *nextcontroller = [[UIViewController alloc] init];
  nextcontroller.view.backgroundColor = [UIColor yellowColor];
  [self.navigationController pushViewController:nextcontroller animated:NO];
  return;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
//  AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//  if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied ||authStatus == 0)
//  {
//    NSLog(@" 没有访问相机权限");
//    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//  } else {
//
//  }
  
  self.view.backgroundColor = [UIColor yellowColor];
  PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
  NSLog(@"the cout %d",smartAlbums.count);
  PHCollection * theobject = smartAlbums[1];
  PHFetchResult *theFetch = [PHAsset fetchAssetsInAssetCollection:theobject options:nil];
  PHAsset *theassert = theFetch[1];
  
  NSLog(@"theassert  %@",theobject);
  imageManage = [[PHCachingImageManager alloc] init];
  [imageManage requestImageForAsset:theassert targetSize:theImageView.frame.size contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
    theImageView.image = result;
  }];

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
