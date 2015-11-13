//
//  CollectionViewCell.h
//  photosFramework
//
//  Created by HuminiOS on 15/11/11.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "HMImagePickerViewController.h"
#import "HMPhotoModel.h"
@interface ThumbImageCollectionViewCell : UICollectionViewCell
- (void)setDataWithModel:(HMPhotoModel *)model imageManager:(PHCachingImageManager *)imageManager;
@end
