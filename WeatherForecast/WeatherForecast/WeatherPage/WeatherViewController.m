//
//  WeatherViewController.m
//  WeatherForecast
//
//  Created by 张博添 on 2021/8/9.
//

#import "WeatherViewController.h"
#import "WeatherTableViewCell.h"

#define selfWidth self.view.bounds.size.width
#define selfHeight self.view.bounds.size.height
#define tabBarHeight self.tabBarController.tabBar.bounds.size.height
#define navigationBarHeight self.navigationController.navigationBar.bounds.size.height
#define statusBarHeight [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height
#define toolBarHeight self.navigationController.toolbar.bounds.size.height

@interface WeatherViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
NSURLSessionDelegate
>

@end

@implementation WeatherViewController

- (void)viewWillAppear:(BOOL)animated {
    _weekArray = [[NSMutableArray alloc] init];
    _highTempArray = [[NSMutableArray alloc] init];
    _lowTempArray = [[NSMutableArray alloc] init];
    _hourArray = [[NSMutableArray alloc] init];
    _hourStatusImageArray = [[NSMutableArray alloc] init];
    _hourTempArray = [[NSMutableArray alloc] init];
    _dayStatusImageArray = [[NSMutableArray alloc] init];
    _nightStatusImageArray = [[NSMutableArray alloc] init];
    [self creatUrl];
    [self creatUrlSecond];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",_cityName);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatAddButton];
    [self creatBackButton];
    
    _cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, selfWidth, 50)];
    [self.view addSubview:_cityNameLabel];
    _cityNameLabel.font = [UIFont systemFontOfSize:32];
    _cityNameLabel.textAlignment = NSTextAlignmentCenter;
    
    _leftTitleArray = [NSArray arrayWithObjects:@"日出",@"风向",@"能见度",@"气压", nil];
    _rightTitleArray = [NSArray arrayWithObjects:@"日落",@"风力等级",@"湿度",@"空气质量", nil];
    
    _leftInfoArray = [[NSMutableArray alloc] init];
    _rightInfoArray = [[NSMutableArray alloc] init];
    
    [self creatTableView];

}

- (void)creatBackButton {
    _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:_backButton];
    _backButton.frame = CGRectMake(10, 0, 50, 40);
    _backButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [_backButton setTitle:@"取消" forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
}

- (void)creatAddButton {
    _addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:_addButton];
    _addButton.frame = CGRectMake(selfWidth - 60, 0, 50, 40);
    _addButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [_addButton setTitle:@"添加" forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(pressAdd) forControlEvents:UIControlEventTouchUpInside];
}

- (void)creatTableView {
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, selfWidth, selfHeight - 90) style:UITableViewStyleGrouped];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.sectionFooterHeight = 0.01;
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mainTableView];
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

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WeatherTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"cellFirst" forIndexPath:indexPath];
        if (_weatherDictionary) {
            cell.currentDayLabel.text = _weekArray[0];
            cell.highTempLabel.text = _highTempArray[0];
            cell.lowTempLabel.text = _lowTempArray[0];
            
            cell.lowTempLabel.frame = CGRectMake(selfWidth - 140, 0, 60, 60);
            cell.highTempLabel.frame = CGRectMake(selfWidth - 80, 0, 60, 60);
        }
        return cell;
    } else if (indexPath.section == 1) {
        WeatherTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"cellSecond" forIndexPath:indexPath];
        if (_weatherDictionary) {
            
            cell.hourScrollView.frame = CGRectMake(0, 0, selfWidth, 120);
            cell.hourScrollView.contentSize = CGSizeMake(90 * _hourArray.count, 120);
            
            while ([cell.hourScrollView.subviews lastObject] != nil) {
                [(UIView *)[cell.hourScrollView.subviews lastObject] removeFromSuperview];
            }
            
            for (int i = 0; i < _hourArray.count; ++i) {
                UILabel * hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(90 * i + 20, 0, 50, 20)];
                hourLabel.text = _hourArray[i];
                hourLabel.textAlignment = NSTextAlignmentCenter;
                [cell.hourScrollView addSubview:hourLabel];
                
                UILabel * tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(90 * i + 20, 98, 50, 20)];
                tempLabel.text = _hourTempArray[i];
                tempLabel.textAlignment = NSTextAlignmentCenter;
                tempLabel.font = [UIFont systemFontOfSize:17];
                [cell.hourScrollView addSubview:tempLabel];
                
                UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(90 * i + 29, 48, 32, 32)];
                image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",_hourStatusImageArray[i]]];
                [cell.hourScrollView addSubview:image];
                
            }
            
        }
        return cell;
    } else if (indexPath.section == 2) {
        WeatherTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"cellThird" forIndexPath:indexPath];
        if (_weatherDictionary) {
            cell.dayLabel.text = _weekArray[indexPath.row + 1];
            cell.highTempLabel.text = _highTempArray[indexPath.row + 1];
            cell.lowTempLabel.text = _lowTempArray[indexPath.row + 1];
            
            cell.lowTempLabel.frame = CGRectMake(selfWidth - 140, 0, 60, 60);
            cell.highTempLabel.frame = CGRectMake(selfWidth - 80, 0, 60, 60);
            
            cell.dayStatusImageView.frame = CGRectMake(selfWidth / 2 - 50, 12, 36, 36);
            cell.dayStatusImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", _dayStatusImageArray[indexPath.row + 1]]];
            
            cell.nightStatusImageView.frame = CGRectMake(selfWidth / 2 - 5, 12, 36, 36);
            cell.nightStatusImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", _nightStatusImageArray[indexPath.row + 1]]];
        }
        return cell;
    } else if (indexPath.section == 3) {
        WeatherTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"cellFourth" forIndexPath:indexPath];
        if (_weatherDictionary) {
            cell.tipLabel.frame = CGRectMake(20, 0, selfWidth - 40, 60);
            cell.tipLabel.numberOfLines = 0;
            cell.tipLabel.text = _weatherDictionary[@"data"][0][@"air_tips"];
            cell.textLabel.font = [UIFont systemFontOfSize:18];
        }
        return cell;
    } else {
        WeatherTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"cellFifth" forIndexPath:indexPath];
        if (_weatherDictionary) {
            
            cell.titleLabelFirst.frame = CGRectMake(20, 0, selfWidth / 2 - 40, 30);
            cell.infoLabelFirst.frame = CGRectMake(20, 30, selfWidth / 2 - 40, 60);
            cell.infoLabelFirst.font = [UIFont systemFontOfSize:40];
            
            cell.titleLabelFirst.text = _leftTitleArray[indexPath.row];
            cell.infoLabelFirst.text = _leftInfoArray[indexPath.row];
            
            cell.titleLabelSecond.frame = CGRectMake(selfWidth / 2 + 20, 0, selfWidth / 2 - 40, 30);
            cell.infoLabelSecond.frame = CGRectMake(selfWidth / 2 +20, 30, selfWidth / 2 - 40, 60);
            cell.infoLabelSecond.font =[UIFont systemFontOfSize:40];
            
            cell.titleLabelSecond.text = _rightTitleArray[indexPath.row];
            cell.infoLabelSecond.text = _rightInfoArray[indexPath.row];
        }
        return cell;
    }
}

- (void)pressBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pressAdd {
    [self dismissViewControllerAnimated:YES completion:^(void){
        [self.delegate doAdd:self->_cityNameLabel.text infoFirst:self->_weatherDictionary infoSecond:self->_currentWeatherDictionary];
    }];
    NSNotification *notification = [NSNotification notificationWithName:@"send" object:nil userInfo:@{@"weekArray":_weekArray,@"highTempArray":_highTempArray,@"lowTempArray":_lowTempArray,@"dayStatusImageArray":_dayStatusImageArray,@"nightStatusImageArray":_nightStatusImageArray,@"hourArray":_hourArray,@"hourTempArray":_hourTempArray,@"hourStatusImageArray":_hourStatusImageArray,@"leftInfoArray":_leftInfoArray,@"rightInfoArray":_rightInfoArray}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)creatUrl {
    NSString *urlString = [NSString stringWithFormat:@"https://tianqiapi.com/api?version=v1&appid=28845343&appsecret=zPNqw1IO&city=%@",_cityName];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self  delegateQueue:[NSOperationQueue mainQueue]];
    _dataTaskFirst = [session dataTaskWithRequest:request];
    [_dataTaskFirst resume];
}

- (void)creatUrlSecond {
    NSString *urlString = [NSString stringWithFormat:@"https://www.tianqiapi.com/free/day?appid=28845343&appsecret=zPNqw1IO&city=%@", _cityName];
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
            
            _cityNameLabel.text = _weatherDictionary[@"city"];
            
//            _weekArray = [[NSMutableArray alloc] init];
//            _highTempArray = [[NSMutableArray alloc] init];
//            _lowTempArray = [[NSMutableArray alloc] init];
//            _hourArray = [[NSMutableArray alloc] init];
//            _hourStatusImageArray = [[NSMutableArray alloc] init];
//            _hourTempArray = [[NSMutableArray alloc] init];
//            _dayStatusImageArray = [[NSMutableArray alloc] init];
//            _nightStatusImageArray = [[NSMutableArray alloc] init];
            
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
            
            
            
            
        } else {
            //NSLog(@"error = %@", error);
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self->_mainTableView reloadData];
        }];
        
    } else {
        if (error == nil) {
            _currentWeatherDictionary = [NSJSONSerialization JSONObjectWithData:_currentWeatherData options:kNilOptions error:nil];
        } else {
            //NSLog(@"error = %@", error);
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self->_mainTableView reloadData];
        }];
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        [self creatHeaderView];
        return _headerView;
    } else {
        return nil;
    }
}

- (void)creatHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfWidth, 150)];
    UILabel * tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, selfWidth, 110)];
    [_headerView addSubview: tempLabel];
    tempLabel.textAlignment = NSTextAlignmentCenter;
    tempLabel.font = [UIFont systemFontOfSize:70];
    
    UILabel * weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, selfWidth, 40)];
    [_headerView addSubview: weatherLabel];
    weatherLabel.textAlignment = NSTextAlignmentCenter;
    weatherLabel.font = [UIFont systemFontOfSize:20];
    
    if (_weatherDictionary && _currentWeatherDictionary) {
        tempLabel.text = _currentWeatherDictionary[@"tem"];
        weatherLabel.text = _weatherDictionary[@"data"][0][@"wea"];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _headerView.alpha = 1 - (scrollView.contentOffset.y / 150);
}

@end
