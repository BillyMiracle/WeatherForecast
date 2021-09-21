//
//  MainTableViewCell.m
//  WeatherForecast
//
//  Created by 张博添 on 2021/8/8.
//

#import "MainTableViewCell.h"

@implementation MainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cityNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_cityNameLabel];
        
        _tempLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_tempLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        
        _separatorLine = [[UIImageView alloc] init];
        _separatorLine.image = [self createImageWithColor:[UIColor grayColor]];
        [self.contentView addSubview:_separatorLine];
    }
    return self;
}

- (void)layoutSubviews {
    _cityNameLabel.frame = CGRectMake(20, 0, 200, 100);
    _cityNameLabel.font = [UIFont systemFontOfSize:22];
    
    _tempLabel.font = [UIFont systemFontOfSize:22];
    _tempLabel.textAlignment = NSTextAlignmentRight;
}

-(UIImage*) createImageWithColor:(UIColor*) color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
