//
//  MainViewController.h
//  WeatherForecast
//
//  Created by 张博添 on 2021/8/8.
//

#import <UIKit/UIKit.h>
#import "MainTableViewCell.h"
#import "SearchCityViewController.h"
#import "WeatherViewController.h"
#import "WeatherScrollViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface MainViewController : UIViewController

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableArray *tempArray;

@property (nonatomic, strong) NSMutableData *dataFirst;
@property (nonatomic, strong) NSMutableData *dataSecond;

@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) NSURLSessionDataTask *dataTaskFirst;
@property (nonatomic, strong) NSURLSessionDataTask *dataTaskSecond;

@property (nonatomic, assign) int index;

@property (nonatomic, strong) SearchCityViewController *searchPage;

@property (nonatomic, strong) WeatherScrollViewController *weatherScrollPage;

@end

NS_ASSUME_NONNULL_END
