//
//  ZZHfallCollectionViewCell.m
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/31.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHfallCollectionViewCell.h"

@interface ZZHfallCollectionViewCell ()
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UITextView *textView;
@end

@implementation ZZHfallCollectionViewCell

- (void)dealloc
{
    [_textView release];
    [_imageView release];
    [_sub release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
        _imageView.backgroundColor = [UIColor redColor];
        [_imageView release];
        
        self.textView = [[UITextView alloc]init];
        self.textView.backgroundColor = [UIColor blackColor];
        self.textView.textColor = [UIColor whiteColor];
        self.textView.editable = NO;
        [self.contentView addSubview:_textView];
        [_textView release];
    }
    return self;
}

- (void)setSub:(ZZHSUb *)sub
{
    if (_sub != sub) {
        [_sub release];
        _sub = [sub retain];
    }
    
    CGFloat fImage = 0;
    if ([_sub.image_width integerValue] != 0 && [_sub.image_height integerValue] != 0 && ![_sub.image_url isEqualToString:@""]) {
        
        fImage = (CGFloat)[_sub.image_height floatValue] / [_sub.image_width floatValue] * self.contentView.frame.size.width;
    }
    
    NSLog(@"%f", fImage);
    
    if (fImage > 0) {
        
        _imageView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, fImage);
    }else{
        _imageView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 300 *SCREEN_Y);
    }_imageView.center = self.contentView.center;
    _textView.frame = CGRectMake(0, self.contentView.frame.size.height - 200 *SCREEN_Y, self.contentView.frame.size.width, 200 *SCREEN_Y - 49);
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:sub.image_url] placeholderImage:[UIImage imageNamed:@"占位图"]];
    
    _textView.text = sub.myDescription;
    
}


@end
