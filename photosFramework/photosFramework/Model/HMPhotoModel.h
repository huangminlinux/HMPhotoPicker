//
//  HMThumbImageModel.h
//  photosFramework
//
//  Created by HuminiOS on 15/11/11.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface HMPhotoModel : NSObject
@property(assign, nonatomic)NSInteger index;
@property(assign, nonatomic)BOOL isSelected;
@property(assign, nonatomic)BOOL isOriginPhoto;
@property(strong, nonatomic)PHAsset *photoAssert;
@property(strong, nonatomic)PHCachingImageManager *CachingManager;

@property(strong, nonatomic)UIImage *largeImage;
@property(assign, nonatomic)CGSize largeImageSize;
- (void)setDataWithAsset:(PHAsset *)asset ImageManager:(PHCachingImageManager *)imageManager;
- (UIImage *)getLargeImageWithImageManager:(PHCachingImageManager *)imageManager;
@end
