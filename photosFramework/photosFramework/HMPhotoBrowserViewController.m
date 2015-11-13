//
//  HMPhotoBrowserViewController.m
//  photosFramework
//
//  Created by HuminiOS on 15/11/12.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "HMPhotoBrowserViewController.h"
#import "HMPhotoBrowserCollectionViewCell.h"
#import "HMPhotoModel.h"
#import "HMPhotoPickerConstants.h"

@interface HMPhotoBrowserViewController ()<UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UIScrollViewDelegate>
{
  UICollectionView *collectionView;
  UIView *topBar;
  UIView *bottomBar;
  
  UIButton *selectStatusBtn;
}
@end

@implementation HMPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  [self.navigationController setNavigationBarHidden:YES];
  [self setupCollectionView];
  [self setupBarView];
}

- (void)viewWillAppear:(BOOL)animated {
  [self.view layoutIfNeeded];
  [collectionView scrollToItemAtIndexPath:_currentIndex atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)setupCollectionView {
  UICollectionViewFlowLayout *aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
  [aFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
  aFlowLayout.minimumInteritemSpacing = 0;
  aFlowLayout.minimumLineSpacing = 0;
  collectionView =[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:aFlowLayout];
  collectionView.pagingEnabled = YES;
  [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gradientCell"];
  [collectionView registerNib:[UINib nibWithNibName:@"HMPhotoBrowserCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HMPhotoBrowserCollectionViewCell"];
  [self.view addSubview:collectionView];
  collectionView.delegate = self;
  collectionView.dataSource = self;
  collectionView.userInteractionEnabled = YES;
  UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(tapContent:)];
  [collectionView addGestureRecognizer:gesture];
}

- (void)setupBarView {
// setup topBar
  topBar = [[UIView alloc] initWithFrame:topBarFrame];
  topBar.backgroundColor = BarColor;
  [self.view addSubview:topBar];
  selectStatusBtn = [[UIButton alloc] initWithFrame:selectBtnFrame];
  [selectStatusBtn addTarget:self action:@selector(clickToSelect:) forControlEvents:UIControlEventTouchUpInside];
  [selectStatusBtn setBackgroundImage:[UIImage imageNamed:@"image_no_picked@3x.png"] forState:UIControlStateNormal];
  [selectStatusBtn setBackgroundImage:[UIImage imageNamed:@"image_picked@3x.png"] forState:UIControlStateSelected];
  [topBar addSubview:selectStatusBtn];
  UIButton *backBtn = [[UIButton alloc] initWithFrame:backBtnFrame];
  [backBtn setTitle:@"返回" forState:UIControlStateNormal];
  backBtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
  [backBtn addTarget:self action:@selector(popCurrentVC) forControlEvents:UIControlEventTouchUpInside];
  [topBar addSubview:backBtn];
  
//  setup bottomBar
  bottomBar = [[UIView alloc] initWithFrame:bottomBarFrame];
  bottomBar.backgroundColor = BarColor;
  [self.view addSubview:bottomBar];
}

- (void)hidenAllBar {
  [UIView animateWithDuration:0.2 animations:^{
    topBar.hidden = !topBar.hidden;
    bottomBar.hidden = !bottomBar.hidden;
  }];
}

- (void)popCurrentVC {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickToSelect:(id)sender {
  UIButton *selectBtn = sender;
  selectBtn.selected = !selectBtn.selected;
  HMPhotoModel *currentPhotoModel = _allPhotoArr[[self currentIndex].item];
    NSLog(@"huangmin model   %@",currentPhotoModel);
  currentPhotoModel.isSelected = selectBtn.selected;
  [[NSNotificationCenter defaultCenter] postNotificationName:kSelectStatusChange object:currentPhotoModel];

}

- (NSIndexPath *)currentIndex {
  NSInteger itemIndex = collectionView.contentOffset.x / collectionView.frame.size.width;
  NSInteger sectionIndex = 0;
  _currentIndex = [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
  return _currentIndex;
}

- (void)tapContent:(UIGestureRecognizer *)gesture {
  [self hidenAllBar];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return _allPhotoArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
  
  return [[UIScreen mainScreen] bounds].size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"HMPhotoBrowserCollectionViewCell";
  HMPhotoBrowserCollectionViewCell *cell = (HMPhotoBrowserCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
  HMPhotoModel *currentPhotoModel = _allPhotoArr[indexPath.item];
  [cell setDataWithModel:currentPhotoModel imageManager:_imageManager];
  
  return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  NSIndexPath *currentIndex = [self currentIndex];
  HMPhotoModel *currentPhotoModel = _allPhotoArr[currentIndex.item];
  selectStatusBtn.selected = currentPhotoModel.isSelected;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
