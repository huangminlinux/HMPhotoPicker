//
//  HMPhotoBrowserViewController.h
//  photosFramework
//
//  Created by HuminiOS on 15/11/12.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface HMPhotoBrowserViewController : UIViewController
@property (strong, nonatomic)PHCollection *photoCollection;
@property (strong, nonatomic)PHCachingImageManager *imageManager;
@property (strong, nonatomic)PHFetchResult *allFetchResult;
//@property (strong, nonatomic)NSMutableArray *selectedPhotoArr;
@property (strong, nonatomic)NSMutableArray *allPhotoArr;
@property (assign, nonatomic)NSIndexPath *currentIndex;
@end
//HMPhotoBrowserViewController