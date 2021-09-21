//
//  WeatherViewController.h
//  WeatherForecast
//
//  Created by 张博添 on 2021/8/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WeatherDelegate <NSObject>

- (void)doAdd:(NSString *)cityName infoFirst:(NSDictionary*)weatherDictionary infoSecond:(NSDictionary*)currentWeatherDictionary;

@end

@interface WeatherViewController : UIViewController

@property id<WeatherDelegate> delegate;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *cityId;

@property (nonatomic, strong) NSMutableData *weatherData;
@property (nonatomic, strong) NSMutableData *currentWeatherData;

@property (nonatomic, strong) UILabel *cityNameLabel;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) NSDictionary *weatherDictionary;
@property (nonatomic, strong) NSDictionary *currentWeatherDictionary;

@property (nonatomic, strong) NSURLSessionDataTask *dataTaskFirst;
@property (nonatomic, strong) NSURLSessionDataTask *dataTaskCurrent;


//DATA
@property (nonatomic, copy) NSString *currentCityName;
@property (nonatomic, strong) NSMutableArray *weekArray;
@property (nonatomic, strong) NSMutableArray *highTempArray;
@property (nonatomic, strong) NSMutableArray *lowTempArray;
@property (nonatomic, strong) NSMutableArray *dayStatusImageArray;
@property (nonatomic, strong) NSMutableArray *nightStatusImageArray;
@property (nonatomic, strong) NSMutableArray *hourStatusImageArray;
@property (nonatomic, strong) NSMutableArray *hourArray;
@property (nonatomic, strong) NSMutableArray *hourTempArray;
@property (nonatomic, strong) NSArray *leftTitleArray;
@property (nonatomic, strong) NSArray *rightTitleArray;
@property (nonatomic, strong) NSMutableArray *leftInfoArray;
@property (nonatomic, strong) NSMutableArray *rightInfoArray;

@end

NS_ASSUME_NONNULL_END
