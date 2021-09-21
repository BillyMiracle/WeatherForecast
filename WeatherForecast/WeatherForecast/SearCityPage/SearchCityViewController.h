//
//  SearchCityViewController.h
//  WeatherForecast
//
//  Created by 张博添 on 2021/8/9.
//

#import <UIKit/UIKit.h>
#import "WeatherViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchCityViewController : UIViewController

@property (nonatomic, strong) UITextField *searchTextField;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableData *data;

@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableArray *cityNameArray;
@property (nonatomic, strong) NSMutableArray *cityIdArray;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) WeatherViewController *weatherPage;

@end

NS_ASSUME_NONNULL_END
