//
//  ZZHHotTravelTableViewCell.m
//  TianYa Trip
//
//  Created by dlios on 15-5-16.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHHotTravelTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
@interface ZZHHotTravelTableViewCell ()
@property (nonatomic, retain) UIImageView *photoImage;
@property (nonatomic, retain) UILabel *myTextLabel;
@property (nonatomic, retain) UILabel *local_timeLabel;
@property (nonatomic, retain) UILabel *cityLabel;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSDictionary *photo_info;
@end

@implementation ZZHHotTravelTableViewCell

- (void)dealloc
{
    [_photoImage release];
    [_myTextLabel release];
    [_local_timeLabel release];
    [_cityLabel release];
    [_image release];
    [super dealloc];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.photoImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_photoImage];
        [_photoImage release];
        
        self.myTextLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.myTextLabel];
        [_myTextLabel release];
        _myTextLabel.numberOfLines = 0;
        _myTextLabel.font = [UIFont systemFontOfSize:15];
        
        self.local_timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_local_timeLabel];
        [_local_timeLabel release];
        
        self.cityLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_cityLabel];
        [_cityLabel release];
    }
    return self;
}



+ (CGFloat)getHeightWithText:(NSString *)text
{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil];
    CGSize size = CGSizeMake(SCREEN_WIDTH - 20, 1000);
    CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}

//+ (CGFloat)getHeightWithImage:(UIImage *)image
//{
//    if (image == nil) {
//        return 0;
//    }else
//    {
//    size_t width = CGImageGetWidth(image.CGImage);
//    size_t height = CGImageGetHeight(image.CGImage);
//    return  height / width * 375;
//}
//}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat f = [[self class] getHeightWithText:_myTextLabel.text];
    
//    CGFloat f1 = [[self class] getHeightWithImage:_photoImage.image];
//    if (self.photo_info == nil) {
//        fImage = 0;
//    }else{
    
//    }
    CGFloat fImage = 0;
    if (self.photo_info) {
        fImage = [[self.photo_info objectForKey:@"h"] integerValue] / (CGFloat)[[self.photo_info objectForKey:@"w"] integerValue] * self.contentView.frame.size.width - 20 *SCREEN_X;
    }
    NSLog(@"f1 = !!!%f", fImage);
    NSLog(@"%f", [[self.photo_info objectForKey:@"h"] integerValue] / (CGFloat)[[self.photo_info objectForKey:@"w"] integerValue]);
    _photoImage.frame = CGRectMake(10 *SCREEN_X, 0, self.contentView.frame.size.width - 20, fImage);
    [_photoImage sd_setImageWithURL:[NSURL URLWithString:_HotTravelNote.photo] placeholderImage:[UIImage imageNamed:@"placeholder"]];
 

    _myTextLabel.frame = CGRectMake(10 * SCREEN_X, fImage + 10 *SCREEN_X, self.contentView.frame.size.width - 20 *SCREEN_X, f);

}

- (void)setHotTravelNote:(ZZHHotTravelNote *)HotTravelNote
{
    if (_HotTravelNote != HotTravelNote) {
        [_HotTravelNote release];
        _HotTravelNote = [HotTravelNote retain];
    }
    _myTextLabel.text = HotTravelNote.text;
    _local_timeLabel.text = HotTravelNote.local_time;
    _cityLabel.text = HotTravelNote.city;
    self.photo_info = [NSDictionary dictionary];
    self.photo_info = HotTravelNote.photo_info;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
