//
//  HMPhotoSelectViewController.m
//  HMPhotoPickerDemo
//
//  Created by HuminiOS on 15/11/16.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "HMPhotoSelectViewController.h"
#import "ThumbImageCollectionViewCell.h"
#import "HMPhotoBrowserViewController.h"
#import "HMPhotoModel.h"
#import "HMPhotoPickerConstants.h"

#define kPhotoGridViewFrame CGRectMake(0, 0, screenWidth,screenHeight - 45)
#define kBrowserBtnFrame CGRectMake(13, 10, 35, 16)
#define kSendBtnFrame CGRectMake(screenWidth - 45, 10, 35, 16)

@interface HMPhotoSelectViewController (){
  PHCachingImageManager *imageManager;
  NSMutableDictionary *selectedPhotoDic;// 已经选中的图片
  NSMutableArray *allPhotoArr;
  __weak IBOutlet UICollectionView *photoGridView;
  __weak IBOutlet UIButton *browserBtn;
  __weak IBOutlet UILabel *selectedPhotoLabel;
  __weak IBOutlet UIButton *sendBtn;
}



@end

@implementation HMPhotoSelectViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  selectedPhotoDic = @{}.mutableCopy;
  allPhotoArr = @[].mutableCopy;
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
  
  selectedPhotoLabel.layer.masksToBounds = YES;
  selectedPhotoLabel.layer.cornerRadius = selectedPhotoLabel.frame.size.height / 2;

  imageManager = [[PHCachingImageManager alloc] init];
  if (_allFetchResult == nil) {
    _allFetchResult = [PHAsset fetchAssetsInAssetCollection:_photoCollection options:nil];
  }
  self.title = _photoCollection.localizedTitle;
  NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
  [defaultCenter addObserver:self selector:@selector(didSelectStatusChange:) name:kSelectStatusChange object:nil];
  [defaultCenter addObserver:self selector:@selector(finshToSelectPhoto) name:kFinishToSelectPhoto object:nil];
  
  [self getAllPhoto];
  [self setUpCollectionView];

}

- (void)cancel{
  [self dismissViewControllerAnimated:YES completion:nil];
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
  photoGridView.minimumZoomScale = 0;
  photoGridView.contentOffset = CGPointMake(0, 64);
  [photoGridView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gradientCell"];
  [photoGridView registerNib:[UINib nibWithNibName:@"ThumbImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ThumbImageCollectionViewCell"];
  [self.view addSubview:photoGridView];
  photoGridView.backgroundColor = [UIColor whiteColor];
  photoGridView.delegate = self;
  photoGridView.dataSource = self;
  
}

- (IBAction)clickToBrowserSelectedPhotos:(id)sender {
  HMPhotoBrowserViewController *photoBrowserVC = [[HMPhotoBrowserViewController alloc] init];
  photoBrowserVC.photoCollection = _photoCollection;
  photoBrowserVC.imageManager = imageManager;
  photoBrowserVC.allFetchResult = _allFetchResult;
  photoBrowserVC.photoDelegate = _photoDelegate;
  photoBrowserVC.allPhotoArr = [selectedPhotoDic allValues];
  NSIndexPath *browserIndex= [NSIndexPath indexPathForItem:0 inSection:0];
  photoBrowserVC.currentIndex = browserIndex;
  [self.navigationController pushViewController:photoBrowserVC animated:YES];
}
- (IBAction)sendSelectedPhotos:(id)sender {
  [self finshToSelectPhoto];
}

- (void)finshToSelectPhoto {
  if ([_photoDelegate respondsToSelector:@selector(HMPhotoPickerViewController:selectedPhotoArray:)]){
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
  }
  [self dismissViewControllerAnimated:YES completion:NULL];
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
    selectedPhotoLabel.hidden = NO;
    selectedPhotoLabel.text = [NSString stringWithFormat:@"%ld",[selectedPhotoDic count]];
    sendBtn.enabled = YES;
  } else{
    browserBtn.enabled = NO;
    selectedPhotoLabel.hidden = YES;
    sendBtn.enabled = NO;
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [self.navigationController setNavigationBarHidden:NO];
  [photoGridView reloadData];
}

#pragma mark - CollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
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
  photoBrowserVC.photoDelegate = _photoDelegate;
  photoBrowserVC.currentIndex = indexPath;
  [self.navigationController pushViewController:photoBrowserVC animated:YES];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];

}



@end
