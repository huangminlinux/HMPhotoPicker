//
//  CollectionViewCell.m
//  photosFramework
//
//  Created by HuminiOS on 15/11/11.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "ThumbImageCollectionViewCell.h"
#import "HMPhotoPickerConstants.h"

@interface ThumbImageCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbImage;
@property (weak, nonatomic) IBOutlet UIButton *seletStatusBtn;
@property (strong, nonatomic)HMPhotoModel *thumbImageModel;
@end

@implementation ThumbImageCollectionViewCell

- (void)awakeFromNib {
  _thumbImage.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setDataWithModel:(HMPhotoModel *)model {
  _thumbImageModel = model;
  _seletStatusBtn.selected = model.isSelected;
  PHAsset *asset = model.photoAssert;
  CGFloat scale = [UIScreen mainScreen].scale;
  CGSize imageSize = CGSizeMake(self.frame.size.width * scale, self.frame.size.width * scale);
  [model.CachingManager requestImageForAsset:asset
                               targetSize:imageSize
                              contentMode:PHImageContentModeAspectFill
                                  options:nil
                            resultHandler:^(UIImage *result, NSDictionary *info) {
                              // Set the cell's thumbnail image if it's still showing the same asset.
                              if ([_thumbImageModel.photoAssert.localIdentifier isEqualToString:asset.localIdentifier]) {
                                self.thumbImage.image = result;
                              }
                            }];
}
- (IBAction)selectedStatusChange:(id)sender {
  UIButton *selectBtn = (UIButton *)sender;
  selectBtn.selected = !selectBtn.selected;
  _thumbImageModel.isSelected = selectBtn.selected;
  [[NSNotificationCenter defaultCenter] postNotificationName:kSelectStatusChange object:_thumbImageModel];
}

@end
