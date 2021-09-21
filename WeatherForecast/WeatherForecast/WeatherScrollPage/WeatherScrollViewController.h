//
//  WeatherScrollViewController.h
//  WeatherForecast
//
//  Created by 张博添 on 2021/8/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherScrollViewController : UIViewController

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UITableView *cityTableView;

@property (nonatomic, copy) NSMutableArray *cityArray;

@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *indexArray;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UITableView *mainTableView;

//@property (nonatomic, copy) NSString *cityName;
//@property (nonatomic, copy) NSString *cityId;

@property (nonatomic, strong) NSMutableData *weatherData;
@property (nonatomic, strong) NSMutableData *currentWeatherData;

@property (nonatomic, strong) UILabel *cityNameLabel;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) NSDictionary *weatherDictionary;
@property (nonatomic, strong) NSDictionary *currentWeatherDictionary;

@property (nonatomic, strong) NSMutableArray *allWeatherDictionary;
@property (nonatomic, strong) NSMutableArray *allCurrentWeatherDictionary;

@property (nonatomic, strong) NSURLSessionDataTask *dataTaskFirst;
@property (nonatomic, strong) NSURLSessionDataTask *dataTaskCurrent;


//DATA
//@property (nonatomic, copy) NSString *currentCityName;
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

@property (nonatomic, strong) NSMutableArray *allWeekArray;
@property (nonatomic, strong) NSMutableArray *allHighTempArray;
@property (nonatomic, strong) NSMutableArray *allLowTempArray;
@property (nonatomic, strong) NSMutableArray *allDayStatusImageArray;
@property (nonatomic, strong) NSMutableArray *allNightStatusImageArray;
@property (nonatomic, strong) NSMutableArray *allHourStatusImageArray;
@property (nonatomic, strong) NSMutableArray *allHourArray;
@property (nonatomic, strong) NSMutableArray *allHourTempArray;
//@property (nonatomic, strong) NSArray *allLeftTitleArray;
//@property (nonatomic, strong) NSArray *allRightTitleArray;
@property (nonatomic, strong) NSMutableArray *allLeftInfoArray;
@property (nonatomic, strong) NSMutableArray *allRightInfoArray;

- (void)creatUrl;

@end

NS_ASSUME_NONNULL_END
