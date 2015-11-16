//
//  HMImagePickerViewController.m
//  photosFramework
//
//  Created by HuminiOS on 15/11/11.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "HMPhotoPickerViewController.h"
#import "ThumbImageCollectionViewCell.h"
#import "HMPhotoBrowserViewController.h"
#import "HMPhotoModel.h"
#import "HMPhotoPickerConstants.h"

#define kPhotoGridViewFrame CGRectMake(0, 0, screenWidth,screenHeight - 45)
#define kBrowserBtnFrame CGRectMake(13, 10, 35, 16)
#define kSendBtnFrame CGRectMake(screenWidth - 45, 10, 35, 16)

@interface HMPhotoPickerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout>
{
  UICollectionView *photoGridView;
  PHCachingImageManager *imageManager;
  NSMutableDictionary *selectedPhotoDic;// 已经选中的图片
  
  NSMutableArray *allPhotoArr;
  UIButton *browserBtn;
}
@end

@implementation HMPhotoPickerViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  selectedPhotoDic = @{}.mutableCopy;
  allPhotoArr = @[].mutableCopy;

  imageManager = [[PHCachingImageManager alloc] init];
  if (_allFetchResult == nil) {
    _allFetchResult = [PHAsset fetchAssetsInAssetCollection:_photoCollection options:nil];
  }


  NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
  [defaultCenter addObserver:self selector:@selector(didSelectStatusChange:) name:kSelectStatusChange object:nil];
  [self getAllPhoto];
  [self setUpCollectionView];
  [self setupBottomBar];
  
}

- (void)getAllPhoto {
  PHFetchResult *allPhotoResult = _allFetchResult;
  for (int index = 0; index < [allPhotoResult count]; index ++) {
    PHAsset *asset = allPhotoResult[index];
    HMPhotoModel *model = [[HMPhotoModel alloc] init];
    [model setDataWithAsset:asset ImageManager:imageManager];
    [allPhotoArr addObject:model];
  }
  
}

- (void)setUpCollectionView {
  UICollectionViewFlowLayout *aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
  [aFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
  aFlowLayout.minimumInteritemSpacing = 0;
  aFlowLayout.minimumLineSpacing = 0;
//  photoGridView =[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:aFlowLayout];
  photoGridView =[[UICollectionView alloc] initWithFrame:kPhotoGridViewFrame collectionViewLayout:aFlowLayout];
  [photoGridView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gradientCell"];
  [photoGridView registerNib:[UINib nibWithNibName:@"ThumbImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ThumbImageCollectionViewCell"];
  [self.view addSubview:photoGridView];
  photoGridView.backgroundColor = [UIColor whiteColor];
  photoGridView.delegate = self;
  photoGridView.dataSource = self;
  
}

- (void)setupBottomBar {
  UIView *bottomBar = [[UIView alloc] initWithFrame:bottomBarFrame];
  [self.view addSubview:bottomBar];
  bottomBar.backgroundColor = [UIColor whiteColor];
  browserBtn = [[UIButton alloc] initWithFrame:kBrowserBtnFrame];
  [browserBtn setTitle:@"预览" forState:UIControlStateNormal];
  browserBtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
  [browserBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
  [browserBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [bottomBar addSubview:browserBtn];
  browserBtn.enabled = NO;
  [browserBtn addTarget:self action:@selector(clickToBrowserSelectedPhotos) forControlEvents:UIControlEventTouchUpInside];
  
  UIButton *sendBtn = [[UIButton alloc] initWithFrame:kSendBtnFrame];
  [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
  sendBtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
  [sendBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
  [sendBtn addTarget:self action:@selector(sendSelectedPhoto) forControlEvents:UIControlEventTouchUpInside];
  [bottomBar addSubview:sendBtn];

}

- (void)clickToBrowserSelectedPhotos {
  HMPhotoBrowserViewController *photoBrowserVC = [[HMPhotoBrowserViewController alloc] init];
  photoBrowserVC.photoCollection = _photoCollection;
  photoBrowserVC.imageManager = imageManager;
  photoBrowserVC.allFetchResult = _allFetchResult;
  photoBrowserVC.allPhotoArr = [selectedPhotoDic allValues];
  NSIndexPath *browserIndex= [NSIndexPath indexPathForItem:0 inSection:0];
  photoBrowserVC.currentIndex = browserIndex;
  [self.navigationController pushViewController:photoBrowserVC animated:YES];
}

- (void)sendSelectedPhoto {
//  if ([_photoDelegate respondsToSelector:@selector(HMPhotoPickerViewController:selectedPhotoArray:)]){
    __block NSMutableArray *selectedImageArr = @[].mutableCopy;
    for (NSString *key in selectedPhotoDic) {
      HMPhotoModel *photoModel = selectedPhotoDic[key];
      if (photoModel.largeImage == nil) {
        NSLog(@"fail to get large image");
        break;
      }
      [selectedImageArr addObject:photoModel.largeImage];
    }
  [_photoDelegate HMPhotoPickerViewController:self selectedPhotoArray:selectedImageArr];

//  }

}

- (void)didSelectStatusChange:(NSNotification *)notification {
  
  NSLog(@"get the notification %@",notification);

  HMPhotoModel *model = notification.object;
  NSLog(@"huangmin model  %@",model);  
  if (selectedPhotoDic[model.photoAssert] == nil) {

    [selectedPhotoDic setObject:model forKey:model.photoAssert];
  } else {
    [selectedPhotoDic removeObjectForKey:model.photoAssert];
  }
  
  if ([selectedPhotoDic count] > 0) {
    browserBtn.enabled = YES;
  } else{
    browserBtn.enabled = NO;
  }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
  [photoGridView reloadData];
}

#pragma mark - CollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//  PHFetchResult *allPhotoResult = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)_photoCollection options:nil];
//  return allPhotoResult.count;
  return allPhotoArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
  return CGSizeMake(80, 80);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"ThumbImageCollectionViewCell";
  ThumbImageCollectionViewCell *cell = (ThumbImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//  PHAsset *asset = allFetchResult[indexPath.item];
//  [cell setDataWithAssert:asset imageManager:imageManager];
  [cell setDataWithModel:allPhotoArr[indexPath.item]];
  return cell;
}

- (void)collectionView:(UICollectionView * _Nonnull)collectionView
didSelectItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
  HMPhotoBrowserViewController *photoBrowserVC = [[HMPhotoBrowserViewController alloc] init];
  photoBrowserVC.photoCollection = _photoCollection;
  photoBrowserVC.imageManager = imageManager;
  photoBrowserVC.allFetchResult = _allFetchResult;
  photoBrowserVC.allPhotoArr = allPhotoArr;
  photoBrowserVC.currentIndex = indexPath;
  [self.navigationController pushViewController:photoBrowserVC animated:YES];
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
