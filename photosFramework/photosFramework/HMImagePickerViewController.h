//
//  HMImagePickerViewController.h
//  photosFramework
//
//  Created by HuminiOS on 15/11/11.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface HMImagePickerViewController : UIViewController
@property (strong, nonatomic)PHCollection *photoCollection;

@end
