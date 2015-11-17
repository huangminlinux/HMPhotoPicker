//
//  HMThumbImageModel.m
//  photosFramework
//
//  Created by HuminiOS on 15/11/11.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "HMPhotoModel.h"

@implementation HMPhotoModel
- (instancetype)init
{
  self = [super init];
  if (self) {
    _isSelected = NO;
    _isOriginPhoto = NO;
  }
  return self;
}

- (void)setDataWithAsset:(PHAsset *)asset ImageManager:(PHCachingImageManager *)imageManager {
  _CachingManager = imageManager;
  _photoAssert = asset;
  CGSize imgSize;
  
  if (_isOriginPhoto) {
    imgSize = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
  } else {
    imgSize = [[UIScreen mainScreen] bounds].size;
    CGFloat imgScale = [[UIScreen mainScreen] scale];
    imgSize = CGSizeMake(imgSize.width * imgScale, imgSize.height * imgScale);
  }
  
  _largeImageSize = imgSize;
}

- (void)setIsSelected:(BOOL)isSelected {
  _isSelected = isSelected;
  
  if (isSelected) {
    CGSize imgSize = CGSizeMake(_photoAssert.pixelHeight/2, _photoAssert.pixelWidth/2);
    _largeImageSize = imgSize;
    [_CachingManager requestImageForAsset:_photoAssert
                               targetSize:imgSize
                              contentMode:PHImageContentModeAspectFill
                                  options:nil
                            resultHandler:^(UIImage *result, NSDictionary *info) {
                              _largeImage = result;
                            }];
  } else {
    _largeImage = nil;
  }
}

- (void)setIsOriginPhoto:(BOOL)isOriginPhoto {
  _isOriginPhoto = isOriginPhoto;
  
  if (_isSelected) {
    CGSize imgSize = CGSizeMake(_photoAssert.pixelWidth, _photoAssert.pixelHeight);
    _largeImageSize = imgSize;
    [_CachingManager requestImageForAsset:_photoAssert
                               targetSize:imgSize
                              contentMode:PHImageContentModeAspectFill
                                  options:nil
                            resultHandler:^(UIImage *result, NSDictionary *info) {
                              _largeImage = result;
                            }];
  }
}

@end
