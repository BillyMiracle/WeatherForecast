//
//  WeatherScrollViewController.m
//  WeatherForecast
//
//  Created by 张博添 on 2021/8/9.
//

#import "WeatherScrollViewController.h"
#import "WeatherTableViewCell.h"

#define selfWidth self.view.bounds.size.width
#define selfHeight self.view.bounds.size.height
#define tabBarHeight self.tabBarController.tabBar.bounds.size.height
#define navigationBarHeight self.navigationController.navigationBar.bounds.size.height
#define statusBarHeight [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height
#define toolBarHeight self.navigationController.toolbar.bounds.size.height

@interface WeatherScrollViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
NSURLSessionDelegate,
UIScrollViewDelegate
>
@end

@implementation WeatherScrollViewController

- (void)viewWillAppear:(BOOL)animated {
    _cityNameLabel.text = _cityArray[_position];
    
    
    
    if (_cityArray.count == _allWeatherDictionary.count) {
        for (_index = _indexArray.count; _index < _cityArray.count; ++_index) {
            [self creatTableView];
            [_indexArray addObject:@"1"];
        }
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    _index = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _leftTitleArray = [NSArray arrayWithObjects:@"日出",@"风向",@"能见度",@"气压", nil];
    _rightTitleArray = [NSArray arrayWithObjects:@"日落",@"风力等级",@"湿度",@"空气质量", nil];
    
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.delegate = self;
    
//    [self creatUrl];
    
    [self creatCityNameLabel];
    [self creatBackButton];
    
    
    
}

- (void)creatCityNameLabel {
    _cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, statusBarHeight, selfWidth - 120, 50)];
    [self.view addSubview:_cityNameLabel];
    _cityNameLabel.font = [UIFont systemFontOfSize:32];
    _cityNameLabel.textAlignment = NSTextAlignmentCenter;
    _cityNameLabel.text = _cityArray[_position];
}

- (void)creatBackButton {
    _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:_backButton];
    _backButton.frame = CGRectMake(10, statusBarHeight, 50, 40);
    _backButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [_backButton setImage:[UIImage imageNamed:@"iconfont-left.png"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pressBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)creatUrl {

    NSLog(@"%ld",_index);
    NSString *urlString = [NSString stringWithFormat:@"https://tianqiapi.com/api?version=v1&appid=28845343&appsecret=zPNqw1IO&city=%@",_cityArray[_index]];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self  delegateQueue:[NSOperationQueue mainQueue]];
    _dataTaskFirst = [session dataTaskWithRequest:request];
    [_dataTaskFirst resume];
    
}

- (void)creatUrlSecond {
    NSString *urlString = [NSString stringWithFormat:@"https://www.tianqiapi.com/free/day?appid=28845343&appsecret=zPNqw1IO&city=%@", _cityArray[_index]];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self  delegateQueue:[NSOperationQueue mainQueue]];
    _dataTaskCurrent = [session dataTaskWithRequest:request];
    [_dataTaskCurrent resume];
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    if (dataTask == _dataTaskFirst) {

        if(self.weatherData == nil){
            self.weatherData = [[NSMutableData alloc] init];
        } else {
            self.weatherData.length = 0;
        }

    } else {

        if(self.currentWeatherData == nil){
            self.currentWeatherData = [[NSMutableData alloc] init];
        } else {
            self.currentWeatherData.length = 0;
        }

    }
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:( NSURLSessionDataTask *)dataTask didReceiveData:( NSData *)data {
    if (dataTask == _dataTaskFirst) {

        [self.weatherData appendData:data];

    } else {

        [self.currentWeatherData appendData:data];

    }
}

- (void)URLSession:(NSURLSession *)session task:( NSURLSessionTask *)task didCompleteWithError:( NSError *)error {
    if (task == _dataTaskFirst) {

        if (error == nil) {
            
            _weatherDictionary = [NSJSONSerialization JSONObjectWithData:_weatherData options:kNilOptions error:nil];
            
            [_allWeatherDictionary addObject:_weatherDictionary];
            
            _weekArray = [[NSMutableArray alloc] init];
            _highTempArray = [[NSMutableArray alloc] init];
            _lowTempArray = [[NSMutableArray alloc] init];
            _hourArray = [[NSMutableArray alloc] init];
            _hourStatusImageArray = [[NSMutableArray alloc] init];
            _hourTempArray = [[NSMutableArray alloc] init];
            _dayStatusImageArray = [[NSMutableArray alloc] init];
            _nightStatusImageArray = [[NSMutableArray alloc] init];
            _leftInfoArray = [[NSMutableArray alloc] init];
            _rightInfoArray = [[NSMutableArray alloc] init];

            for (NSDictionary *dict in _weatherDictionary[@"data"]) {
                [_weekArray addObject:dict[@"week"]];
                [_highTempArray addObject:dict[@"tem1"]];
                [_lowTempArray addObject:dict[@"tem2"]];
                [_dayStatusImageArray addObject:dict[@"wea_day_img"]];
                [_nightStatusImageArray addObject:dict[@"wea_night_img"]];
            }

            for (NSDictionary *dict in _weatherDictionary[@"data"][0][@"hours"]) {
                [_hourArray addObject:dict[@"hours"]];
                [_hourTempArray addObject:dict[@"tem"]];
                [_hourStatusImageArray addObject:dict[@"wea_img"]];
            }

            [_leftInfoArray addObject:_weatherDictionary[@"data"][0][@"sunrise"]];
            [_leftInfoArray addObject:_weatherDictionary[@"data"][0][@"win"][0]];
            [_leftInfoArray addObject:_weatherDictionary[@"data"][0][@"visibility"]];
            [_leftInfoArray addObject:_weatherDictionary[@"data"][0][@"pressure"]];

            [_rightInfoArray addObject:_weatherDictionary[@"data"][0][@"sunset"]];
            [_rightInfoArray addObject:_weatherDictionary[@"data"][0][@"win_speed"]];
            [_rightInfoArray addObject:_weatherDictionary[@"data"][0][@"humidity"]];
            [_rightInfoArray addObject:_weatherDictionary[@"data"][0][@"air"]];
            
            [_allWeekArray addObject:_weekArray];
            [_allHighTempArray addObject:_highTempArray];
            [_allLowTempArray addObject:_lowTempArray];
            [_allHourArray addObject:_hourArray];
            [_allHourStatusImageArray addObject:_hourStatusImageArray];
            [_allHourTempArray addObject:_hourTempArray];
            [_allDayStatusImageArray addObject:_dayStatusImageArray];
            [_allNightStatusImageArray addObject:_nightStatusImageArray];
            [_allLeftInfoArray addObject:_leftInfoArray];
            [_allRightInfoArray addObject:_rightInfoArray];
            [self creatUrlSecond];
        } else {
            //NSLog(@"error = %@", error);
        }
        
    } else {
        
        if (error == nil) {
            _currentWeatherDictionary = [NSJSONSerialization JSONObjectWithData:_currentWeatherData options:kNilOptions error:nil];
            
            [_allCurrentWeatherDictionary addObject:_currentWeatherDictionary];
            [_mainTableView reloadData];

//
//            [self creatTableView];
//
            
            if (_index < _cityArray.count - 1) {
                _index ++;
                [self creatUrl];
            } else {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self->_mainTableView reloadData];
                }];
            }
            
        } else {
            //NSLog(@"error = %@", error);
        }
        
        
    }
}

- (void)creatTableView {
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(selfWidth * _index, 0, selfWidth, selfHeight - 50 - statusBarHeight) style:UITableViewStyleGrouped];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.sectionFooterHeight = 0.01;
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.tag = _index;
    [_mainScrollView addSubview:_mainTableView];
    [_mainTableView registerClass:[WeatherTableViewCell class] forCellReuseIdentifier:@"cellFirst"];
    [_mainTableView registerClass:[WeatherTableViewCell class] forCellReuseIdentifier:@"cellSecond"];
    [_mainTableView registerClass:[WeatherTableViewCell class] forCellReuseIdentifier:@"cellThird"];
    [_mainTableView registerClass:[WeatherTableViewCell class] forCellReuseIdentifier:@"cellFourth"];
    [_mainTableView registerClass:[WeatherTableViewCell class] forCellReuseIdentifier:@"cellFifth"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 6;
    } else if (section == 3) {
        return 1;
    } else {
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return  60;
    } else if (indexPath.section == 1) {
        return 120;
    } else if (indexPath.section == 2) {
        return 60;
    } else if (indexPath.section == 3) {
        return 60;
    } else {
        return 90;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 150;
    } else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 4) {
        return 40;
    } else {
        return 0.01;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        [self creatHeaderView:tableView];
        return _headerView;
    } else {
        return nil;
    }
}

- (void)creatHeaderView:(UITableView*)tableView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfWidth, 150)];
    UILabel * tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, selfWidth, 110)];
    [_headerView addSubview: tempLabel];
    tempLabel.textAlignment = NSTextAlignmentCenter;
    tempLabel.font = [UIFont systemFontOfSize:70];

    UILabel * weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, selfWidth, 40)];
    [_headerView addSubview: weatherLabel];
    weatherLabel.textAlignment = NSTextAlignmentCenter;
    weatherLabel.font = [UIFont systemFontOfSize:20];

    
    tempLabel.text = _allCurrentWeatherDictionary[tableView.tag][@"tem"];
    weatherLabel.text = _allWeatherDictionary[tableView.tag][@"data"][0][@"wea"];
    
    
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WeatherTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"cellFirst"];
//        if (_index == _cityArray.count - 1) {
            
            cell.currentDayLabel.text = _allWeekArray[tableView.tag][0];
            cell.highTempLabel.text = _allHighTempArray[tableView.tag][0];
            cell.lowTempLabel.text = _allLowTempArray[tableView.tag][0];

            cell.lowTempLabel.frame = CGRectMake(selfWidth - 140, 0, 60, 60);
            cell.highTempLabel.frame = CGRectMake(selfWidth - 80, 0, 60, 60);
//        }
        return cell;
    } else if (indexPath.section == 1) {
        WeatherTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"cellSecond"];
//        if (_index == _cityArray.count - 1) {

            cell.hourScrollView.frame = CGRectMake(0, 0, selfWidth, 120);
            cell.hourScrollView.contentSize = CGSizeMake(90 * _hourArray.count, 120);

            while ([cell.hourScrollView.subviews lastObject] != nil) {
                [(UIView *)[cell.hourScrollView.subviews lastObject] removeFromSuperview];
            }

            for (int i = 0; i < _hourArray.count; ++i) {
                UILabel * hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(90 * i + 20, 0, 50, 20)];
                hourLabel.text = _allHourArray[tableView.tag][i];
                hourLabel.textAlignment = NSTextAlignmentCenter;
                [cell.hourScrollView addSubview:hourLabel];

                UILabel * tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(90 * i + 20, 98, 50, 20)];
                tempLabel.text = _allHourTempArray[tableView.tag][i];
                tempLabel.textAlignment = NSTextAlignmentCenter;
                tempLabel.font = [UIFont systemFontOfSize:17];
                [cell.hourScrollView addSubview:tempLabel];

                UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(90 * i + 29, 48, 32, 32)];
                image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",_allHourStatusImageArray[tableView.tag][i]]];
                [cell.hourScrollView addSubview:image];

//            }

        }
        return cell;
    } else if (indexPath.section == 2) {
        WeatherTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"cellThird"];
//        if (_index == _cityArray.count - 1) {
            cell.dayLabel.text = _allWeekArray[tableView.tag][indexPath.row + 1];
            cell.highTempLabel.text = _allHighTempArray[tableView.tag][indexPath.row + 1];
            cell.lowTempLabel.text = _allLowTempArray[tableView.tag][indexPath.row + 1];

            cell.lowTempLabel.frame = CGRectMake(selfWidth - 140, 0, 60, 60);
            cell.highTempLabel.frame = CGRectMake(selfWidth - 80, 0, 60, 60);

            cell.dayStatusImageView.frame = CGRectMake(selfWidth / 2 - 50, 12, 36, 36);
            cell.dayStatusImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", _allDayStatusImageArray[tableView.tag][indexPath.row + 1]]];

            cell.nightStatusImageView.frame = CGRectMake(selfWidth / 2 - 5, 12, 36, 36);
            cell.nightStatusImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", _allNightStatusImageArray[tableView.tag][indexPath.row + 1]]];
//        }
        return cell;
    } else if (indexPath.section == 3) {
        WeatherTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"cellFourth"];
//        if (_index == _cityArray.count - 1) {
            cell.tipLabel.frame = CGRectMake(20, 0, selfWidth - 40, 60);
            cell.tipLabel.numberOfLines = 0;
            cell.tipLabel.text = _allWeatherDictionary[tableView.tag][@"data"][0][@"air_tips"];
            cell.textLabel.font = [UIFont systemFontOfSize:18];
//        }
        return cell;
    } else {
        WeatherTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"cellFifth"];
//        if (_index == _cityArray.count - 1) {

            cell.titleLabelFirst.frame = CGRectMake(20, 0, selfWidth / 2 - 40, 30);
            cell.infoLabelFirst.frame = CGRectMake(20, 30, selfWidth / 2 - 40, 60);
            cell.infoLabelFirst.font = [UIFont systemFontOfSize:40];

            cell.titleLabelFirst.text = _leftTitleArray[indexPath.row];
            cell.infoLabelFirst.text = _allLeftInfoArray[tableView.tag][indexPath.row];

            cell.titleLabelSecond.frame = CGRectMake(selfWidth / 2 + 20, 0, selfWidth / 2 - 40, 30);
            cell.infoLabelSecond.frame = CGRectMake(selfWidth / 2 +20, 30, selfWidth / 2 - 40, 60);
            cell.infoLabelSecond.font =[UIFont systemFontOfSize:40];

            cell.titleLabelSecond.text = _rightTitleArray[indexPath.row];
            cell.infoLabelSecond.text = _allRightInfoArray[tableView.tag][indexPath.row];
//        }
        return cell;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _mainScrollView) {
        _position = _mainScrollView.contentOffset.x / selfWidth;
        
        _cityNameLabel.text = _cityArray[_position];
        
        
    }
}

@end
