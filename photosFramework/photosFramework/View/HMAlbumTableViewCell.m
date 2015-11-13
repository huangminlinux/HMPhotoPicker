//
//  AlbumTableViewCell.m
//  photosFramework
//
//  Created by HuminiOS on 15/11/11.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "HMAlbumTableViewCell.h"

@implementation HMAlbumTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDataWithAlbumResult:(PHCollection *)albumCollection {
  _albumTittle.text = albumCollection.localizedTitle;
  PHFetchResult *albumImagaAssert = [PHAsset fetchAssetsInAssetCollection:albumCollection options:nil];
//  [PHFetchResult ]
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
