//
//  MainTableViewCell.h
//  WeatherForecast
//
//  Created by 张博添 on 2021/8/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *cityNameLabel;
@property (nonatomic, strong) UILabel *tempLabel;

@property (nonatomic, strong) UIImageView *separatorLine;

@end

NS_ASSUME_NONNULL_END
