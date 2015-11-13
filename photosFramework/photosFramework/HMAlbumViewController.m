//
//  HMAlbumViewController.m
//  photosFramework
//
//  Created by HuminiOS on 15/11/11.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "HMAlbumViewController.h"
#import "HMImagePickerViewController.h"
#import "HMAlbumTableViewCell.h"
#import <Photos/Photos.h>

@interface HMAlbumViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *albumTable;

@property (strong,nonatomic)NSArray *albumArr;
@end

@implementation HMAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
  allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
  PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
  
  PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
  
  PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];

  _albumArr = @[allPhotos, smartAlbums, topLevelUserCollections];
  [_albumTable registerNib:[UINib nibWithNibName:@"HMAlbumTableViewCell" bundle:nil] forCellReuseIdentifier:@"HMAlbumTableViewCell"];
  
  _albumTable.delegate = self;
  _albumTable.dataSource = self;
  
  self.title = @"相簿";
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _albumArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger numberOfRows = 0;
  
  if (section == 0) {
    // The "All Photos" section only ever has a single row.
    numberOfRows = 1;
  } else {
    PHFetchResult *fetchResult = _albumArr[section];
    numberOfRows = fetchResult.count;
  }
  return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *albumCellIdentify = @"HMAlbumTableViewCell";
  HMAlbumTableViewCell *cell = (HMAlbumTableViewCell *)[_albumTable dequeueReusableCellWithIdentifier:albumCellIdentify];
  PHFetchResult *albumResult = _albumArr[indexPath.section];
  if (indexPath.section == 0) {
    return cell;
  }
  [cell setDataWithAlbumResult:(PHCollection *)albumResult[indexPath.row]];
  return cell;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  PHFetchResult *albumResult = _albumArr[indexPath.section];
  PHCollection *photoCollection = albumResult[indexPath.row];
  HMImagePickerViewController *pickerImageView = [[HMImagePickerViewController alloc] init];
  pickerImageView.photoCollection = photoCollection;
  [self.navigationController pushViewController:pickerImageView animated:YES];
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
