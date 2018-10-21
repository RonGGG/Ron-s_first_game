//
//  ScoresListTableViewCell.m
//  Ron's_first_game
//
//  Created by 郭梓榕 on 2018/10/21.
//  Copyright © 2018  Ron. All rights reserved.
//

#import "ScoresListTableViewCell.h"
@interface ScoresListTableViewCell()
@property (weak,nonatomic) UIImageView * imgView;
@property (weak,nonatomic) UILabel * nickname;
@property (weak,nonatomic) UILabel * highestScore;
@end
@implementation ScoresListTableViewCell
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
//
//}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        //名次
        UILabel * rank_label = [[UILabel alloc]init];
        self.rank_label = rank_label;
        rank_label.text = @"23";
        rank_label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:rank_label];
        //头像
        UIImageView * imgView = [[UIImageView alloc]init];
        self.imgView = imgView;
        imgView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:imgView];
        //nickname
        UILabel * nickname = [[UILabel alloc]init];
        self.nickname = nickname;
        nickname.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:nickname];
        //最高分
        UILabel * highestScore = [[UILabel alloc]init];
        self.highestScore = highestScore;
        highestScore.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:highestScore];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    //名次
    CGFloat rankLabel_wid = 50;
    CGFloat rankLabel_hei = self.frame.size.height-10;
    CGFloat rankLabel_x = 0;
    self.rank_label.frame = CGRectMake(rankLabel_x, 5, rankLabel_wid, rankLabel_hei);
    self.rank_label.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:rankLabel_hei*17/30];
//    NSLog(@"height:%f",self.frame.size.height);
//    NSLog(@"text:%@,font:%@",self.rank_label.text,self.rank_label.font);
    
    //头像
    CGFloat avatar_wid = self.frame.size.height-10;
    self.imgView.frame = CGRectMake(rankLabel_x+rankLabel_wid, 5, avatar_wid, avatar_wid);
    self.imgView.backgroundColor = [UIColor grayColor];
    
    //nickname
    CGFloat nickname_wid = 100;
    CGFloat nickname_hei = self.frame.size.height-10;
    self.nickname.frame = CGRectMake(115, 5, nickname_wid, nickname_hei);
    self.nickname.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:nickname_hei*17/30];
    
    //最高分
    CGFloat highestScore_hei = self.frame.size.height-10;
    CGFloat highestScore_wid = self.frame.size.width-115-nickname_wid-5;
    self.highestScore.frame = CGRectMake(115+nickname_wid+5, 5, highestScore_wid, highestScore_hei);
    self.highestScore.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:highestScore_hei*17/30];
    
    //颜色
    if (self.words_hue!=0) {
        self.rank_label.textColor = [UIColor colorWithHue:self.words_hue saturation:0.5 brightness:1.0 alpha:1.0];
        self.nickname.textColor = [UIColor colorWithHue:self.words_hue saturation:0.5 brightness:1.0 alpha:1.0];
        self.highestScore.textColor = [UIColor colorWithHue:self.words_hue saturation:0.5 brightness:1.0 alpha:1.0];
    }else{
        self.rank_label.textColor = [UIColor blackColor];
        self.nickname.textColor = [UIColor blackColor];
        self.highestScore.textColor = [UIColor blackColor];
    }
    //填入数据：
    [self loadModels];
}
-(void)loadModels{
    if (self.content!=nil) {
        self.nickname.text = [NSString stringWithFormat:@"%@",self.content.nickname];
        self.highestScore.text = [NSString stringWithFormat:@"%@",self.content.highestScore];
    }else{
        self.nickname.text = nil;
        self.highestScore.text = nil;
    }
}
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    self.backgroundColor = [UIColor blueColor];
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
