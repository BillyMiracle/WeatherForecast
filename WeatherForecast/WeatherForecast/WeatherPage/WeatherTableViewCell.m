//
//  WeatherTableViewCell.m
//  WeatherForecast
//
//  Created by 张博添 on 2021/8/9.
//

#import "WeatherTableViewCell.h"

@implementation WeatherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([reuseIdentifier isEqualToString:@"cellFirst"]) {
        
        _currentDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 60)];
        [self.contentView addSubview:_currentDayLabel];
        
        _highTempLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_highTempLabel];
        
        _lowTempLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_lowTempLabel];
        
    } else if ([reuseIdentifier isEqualToString:@"cellSecond"]) {
        
        _hourScrollView = [[UIScrollView alloc] init];
        [self.contentView addSubview:_hourScrollView];
        
    } else if ([reuseIdentifier isEqualToString:@"cellThird"]) {
        
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 60)];
        [self.contentView addSubview:_dayLabel];
        
        _highTempLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_highTempLabel];
        
        _lowTempLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_lowTempLabel];
        
        _dayStatusImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_dayStatusImageView];
        
        _nightStatusImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_nightStatusImageView];
        
    } else if ([reuseIdentifier isEqualToString:@"cellFourth"]) {
        
        _tipLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_tipLabel];
        
    } else {
        
        _titleLabelFirst = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabelFirst];
        
        _titleLabelSecond =[[UILabel alloc] init];
        [self.contentView addSubview:_titleLabelSecond];
        
        _infoLabelFirst = [[UILabel alloc] init];
        [self.contentView addSubview:_infoLabelFirst];
        
        _infoLabelSecond =[[UILabel alloc] init];
        [self.contentView addSubview:_infoLabelSecond];
        
    }
    return self;
}

- (void)layoutSubviews {
    _currentDayLabel.font = [UIFont systemFontOfSize:20];
    _dayLabel.font = [UIFont systemFontOfSize:20];
    _highTempLabel.font = [UIFont systemFontOfSize:20];
    _highTempLabel.textColor = [UIColor systemRedColor];
    _lowTempLabel.textColor = [UIColor systemGreenColor];
    _lowTempLabel.font = [UIFont systemFontOfSize:20];
    _hourScrollView.showsHorizontalScrollIndicator = NO;
    _hourScrollView.bounces = NO;
}

@end
