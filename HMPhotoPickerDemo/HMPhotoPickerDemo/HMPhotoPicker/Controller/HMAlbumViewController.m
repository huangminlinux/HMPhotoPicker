//
//  HMAlbumViewController.m
//  photosFramework
//
//  Created by HuminiOS on 15/11/11.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "HMAlbumViewController.h"
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
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
  PHFetchResult *albumResult = _albumArr[0];
  HMPhotoSelectViewController *pickerImageView = [[HMPhotoSelectViewController alloc] init];
    pickerImageView.allFetchResult = albumResult;
  pickerImageView.photoDelegate = _photoDelegate;
  
  [self.navigationController pushViewController:pickerImageView animated:NO];
}

- (void)cancel{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _albumArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger numberOfRows = 0;
  
  if (section == 0) {
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
    [cell setDataWithAlbumResult:albumResult];
    return cell;
  }
  [cell setDataWithAlbumCollection:(PHCollection *)albumResult[indexPath.row]];
  return cell;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  PHFetchResult *albumResult = _albumArr[indexPath.section];
  PHCollection *photoCollection = albumResult[indexPath.row];
  HMPhotoSelectViewController *pickerImageView = [[HMPhotoSelectViewController alloc] init];
  if (indexPath.section == 0) {
    pickerImageView.allFetchResult = albumResult;
  } else {
    pickerImageView.photoCollection = photoCollection;
  }
  pickerImageView.photoDelegate = _photoDelegate;
  [self.navigationController pushViewController:pickerImageView animated:NO];
  
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
