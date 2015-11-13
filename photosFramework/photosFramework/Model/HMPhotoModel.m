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

- (void)setDataWithAsset:(PHAsset *)asset {
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

@end
