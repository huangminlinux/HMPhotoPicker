//
//  HMImagePickerViewController.h
//  photosFramework
//
//  Created by HuminiOS on 15/11/11.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@class HMPhotoPickerViewController;

@protocol HMPhotoPickerViewControllerDelegate <NSObject>

- (void)HMPhotoPickerViewController:(HMPhotoPickerViewController *)PhotoPickerVC selectedPhotoArray:(NSArray *)selected_photo_array;

@end

@interface HMPhotoPickerViewController : UIViewController
@property (weak, nonatomic)id<HMPhotoPickerViewControllerDelegate> photoDelegate;
@property (strong, nonatomic)PHCollection *photoCollection;

@end
