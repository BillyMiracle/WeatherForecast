//
//  WeatherTableViewCell.h
//  WeatherForecast
//
//  Created by 张博添 on 2021/8/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherTableViewCell : UITableViewCell

//First
@property (nonatomic, strong) UILabel *currentDayLabel;
@property (nonatomic, strong) UILabel *highTempLabel;
@property (nonatomic, strong) UILabel *lowTempLabel;

//Second
@property (nonatomic, strong) UIScrollView *hourScrollView;

//Third
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UIImageView *dayStatusImageView;
@property (nonatomic, strong) UIImageView *nightStatusImageView;
/*同上
@property (nonatomic, strong) UILabel *highTempLabel;
@property (nonatomic, strong) UILabel *lowTempLabel;
*/

//Fourth
@property (nonatomic, strong) UILabel *tipLabel;

//Fifth
@property (nonatomic, strong) UILabel *titleLabelFirst;
@property (nonatomic, strong) UILabel *infoLabelFirst;
@property (nonatomic, strong) UILabel *titleLabelSecond;
@property (nonatomic, strong) UILabel *infoLabelSecond;

@end

NS_ASSUME_NONNULL_END
