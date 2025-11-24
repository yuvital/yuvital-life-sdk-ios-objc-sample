#import "RootViewController.h"

@import UIKit;
#import "Yuvital_Life_SDK_Sample-Swift.h"

#pragma mark - YuvitalCardConfig

@interface YuvitalCardConfig : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign, getter=isPrimary) BOOL primary;
@property (nonatomic, copy, nullable) void (^action)(void);

- (instancetype)initWithTitle:(NSString *)title
                    imageName:(NSString *)imageName
                    isPrimary:(BOOL)isPrimary
                       action:(void (^_Nullable)(void))action;

@end

@implementation YuvitalCardConfig

- (instancetype)initWithTitle:(NSString *)title
                    imageName:(NSString *)imageName
                    isPrimary:(BOOL)isPrimary
                       action:(void (^_Nullable)(void))action {
    self = [super init];
    if (self) {
        _title = [title copy];
        _imageName = [imageName copy];
        _primary = isPrimary;
        _action = [action copy];
    }
    return self;
}

@end


#pragma mark - YuvitalCardCell

@interface YuvitalCardCell : UICollectionViewCell

@property (class, nonatomic, readonly) NSString *reuseIdentifier;

- (void)configureWithConfig:(YuvitalCardConfig *)config;

@end

@interface YuvitalCardCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YuvitalCardCell

+ (NSString *)reuseIdentifier {
    return @"YuvitalCardCell";
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.contentView.backgroundColor = UIColor.clearColor;

    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.containerView.layer.cornerRadius = 18.0;
    self.containerView.layer.masksToBounds = NO;
    self.containerView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.15].CGColor;
    self.containerView.layer.shadowOpacity = 1.0;
    self.containerView.layer.shadowRadius = 6.0;
    self.containerView.layer.shadowOffset = CGSizeMake(0.0, 3.0);

    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold];
    self.titleLabel.textColor = UIColor.whiteColor;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 2;

    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[ self.imageView, self.titleLabel ]];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 16.0;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.containerView addSubview:stackView];
    [self.contentView addSubview:self.containerView];

    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.containerView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.containerView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],

        [self.imageView.widthAnchor constraintEqualToConstant:44.0],
        [self.imageView.heightAnchor constraintEqualToConstant:44.0],

        [stackView.centerXAnchor constraintEqualToAnchor:self.containerView.centerXAnchor],
        [stackView.centerYAnchor constraintEqualToAnchor:self.containerView.centerYAnchor],
        [stackView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.containerView.leadingAnchor constant:16.0],
        [stackView.trailingAnchor constraintLessThanOrEqualToAnchor:self.containerView.trailingAnchor constant:-16.0],
    ]];
}

- (void)configureWithConfig:(YuvitalCardConfig *)config {
    if (config.isPrimary) {
        self.containerView.backgroundColor = [UIColor colorWithRed:0.40
                                                             green:0.45
                                                              blue:0.88
                                                             alpha:1.0];
    } else {
        self.containerView.backgroundColor = [UIColor colorWithRed:0.09
                                                             green:0.09
                                                              blue:0.12
                                                             alpha:1.0];
    }
    self.imageView.image = [UIImage imageNamed:config.imageName];
    self.titleLabel.text = config.title;
    self.userInteractionEnabled = (config.action != nil);
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];

    CGFloat scale = highlighted ? 0.96 : 1.0;
    CGFloat alpha = highlighted ? 0.8 : 1.0;

    [UIView animateWithDuration:0.12
                          delay:0
                        options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         self.containerView.transform = CGAffineTransformMakeScale(scale, scale);
                         self.containerView.alpha = alpha;
                     }
                     completion:nil];
}

@end


#pragma mark - RootViewController

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<YuvitalCardConfig *> *cards;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.whiteColor;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 12.0;
    layout.minimumLineSpacing = 12.0;
    layout.sectionInset = UIEdgeInsetsMake(16.0, 16.0, 16.0, 16.0);

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.showsVerticalScrollIndicator = YES;
    self.collectionView.backgroundColor = UIColor.whiteColor;

    [self.collectionView registerClass:[YuvitalCardCell class] forCellWithReuseIdentifier:YuvitalCardCell.reuseIdentifier];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    [self.view addSubview:self.collectionView];

    [NSLayoutConstraint activateConstraints:@[
        [self.collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];

    __weak typeof(self) weakSelf = self;

    YuvitalCardConfig *openSdkConfig =
        [[YuvitalCardConfig alloc] initWithTitle:@"Open Yuvital Life"
                                       imageName:@"yuvital_life"
                                       isPrimary:YES
                                          action:^{
                                              __strong typeof(weakSelf) strongSelf = weakSelf;
                                              if (!strongSelf) { return; }
                                              [strongSelf openYuvitalLifeSdkTapped];
                                          }];

    YuvitalCardConfig *heartConfig =
        [[YuvitalCardConfig alloc] initWithTitle:@"Heart rate"
                                       imageName:@"heart_metric_icon"
                                       isPrimary:NO
                                          action:nil];

    YuvitalCardConfig *nutritionConfig =
        [[YuvitalCardConfig alloc] initWithTitle:@"Nutrition"
                                       imageName:@"nutrition_metric_icon"
                                       isPrimary:NO
                                          action:nil];

    YuvitalCardConfig *sleepConfig =
        [[YuvitalCardConfig alloc] initWithTitle:@"Sleep"
                                       imageName:@"sleep_metric_icon"
                                       isPrimary:NO
                                          action:nil];

    YuvitalCardConfig *mindfulnessConfig =
        [[YuvitalCardConfig alloc] initWithTitle:@"Mindfulness"
                                       imageName:@"mindfulness_metric_icon"
                                       isPrimary:NO
                                          action:nil];

    YuvitalCardConfig *walkingConfig =
        [[YuvitalCardConfig alloc] initWithTitle:@"Walking"
                                       imageName:@"walking_metric_icon"
                                       isPrimary:NO
                                          action:nil];

    self.cards = @[
        openSdkConfig,
        heartConfig,
        nutritionConfig,
        sleepConfig,
        mindfulnessConfig,
        walkingConfig,
    ];
}

- (void)openYuvitalLifeSdkTapped {
    UIViewController *sdkWrapper = [YuvitalLifeSdkBridge makeYuvitalSdkViewController];
    [self.navigationController pushViewController:sdkWrapper animated:YES];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cards.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                          cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YuvitalCardCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:YuvitalCardCell.reuseIdentifier
                                                  forIndexPath:indexPath];
    if (![cell isKindOfClass:[YuvitalCardCell class]]) {
        return [[UICollectionViewCell alloc] init];
    }

    YuvitalCardConfig *config = self.cards[indexPath.item];
    [cell configureWithConfig:config];
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YuvitalCardConfig *config = self.cards[indexPath.item];
    if (config.action) {
        config.action();
    }
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        return CGSizeMake(100.0, 100.0);
    }

    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    CGFloat totalHorizontalInset = layout.sectionInset.left + layout.sectionInset.right;
    CGFloat totalSpacing = layout.minimumInteritemSpacing;
    CGFloat availableWidth = collectionView.bounds.size.width - totalHorizontalInset - totalSpacing;
    CGFloat itemWidth = floor(availableWidth / 2.0);
    return CGSizeMake(itemWidth, itemWidth);
}

@end


