//
//  MainViewController.m
//  WeatherForecast
//
//  Created by 张博添 on 2021/8/8.
//

#import "MainViewController.h"

#define selfWidth self.view.bounds.size.width
#define selfHeight self.view.bounds.size.height
#define tabBarHeight self.tabBarController.tabBar.bounds.size.height
#define navigationBarHeight self.navigationController.navigationBar.bounds.size.height
#define statusBarHeight [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height
#define toolBarHeight self.navigationController.toolbar.bounds.size.height

@interface MainViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
NSURLSessionDelegate,
WeatherDelegate
>
@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receive:) name:@"send" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatCityArray];
    
    _index = 0;
    
    _weatherScrollPage = [[WeatherScrollViewController alloc] init];
    _weatherScrollPage.mainScrollView = [[UIScrollView alloc] init];
    [_weatherScrollPage.view addSubview:_weatherScrollPage.mainScrollView];
    _weatherScrollPage.mainScrollView.frame = CGRectMake(0, statusBarHeight + 50, selfWidth, selfHeight - statusBarHeight - 50);
    
    _weatherScrollPage.indexArray = [[NSMutableArray alloc] init];
    _weatherScrollPage.allWeekArray = [[NSMutableArray alloc] init];
    _weatherScrollPage.allHighTempArray = [[NSMutableArray alloc] init];
    _weatherScrollPage.allLowTempArray = [[NSMutableArray alloc] init];
    _weatherScrollPage.allHourArray = [[NSMutableArray alloc] init];
    _weatherScrollPage.allHourStatusImageArray = [[NSMutableArray alloc] init];
    _weatherScrollPage.allHourTempArray = [[NSMutableArray alloc] init];
    _weatherScrollPage.allDayStatusImageArray = [[NSMutableArray alloc] init];
    _weatherScrollPage.allNightStatusImageArray = [[NSMutableArray alloc] init];
    _weatherScrollPage.allWeatherDictionary = [[NSMutableArray alloc] init];
    _weatherScrollPage.allCurrentWeatherDictionary = [[NSMutableArray alloc] init];
    _weatherScrollPage.allLeftInfoArray = [[NSMutableArray alloc] init];
    _weatherScrollPage.allRightInfoArray = [[NSMutableArray alloc] init];
    
    [_weatherScrollPage creatUrl];
    
}

- (void)creatMainTableView {
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusBarHeight, selfWidth, selfHeight - statusBarHeight) style:UITableViewStyleGrouped];
    _mainTableView.sectionHeaderHeight = 0.01;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainTableView];
    [_mainTableView registerClass:[MainTableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)creatCityArray {
    _cityArray = [[NSMutableArray alloc] initWithObjects:@"沈阳",@"北京", nil];
    NSString *stringFirst = [NSString stringWithFormat:@"https://tianqiapi.com/api?version=v1&appid=28845343&appsecret=zPNqw1IO"];
    stringFirst = [stringFirst stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *urlFirst = [NSURL URLWithString:stringFirst];
    NSURLRequest *requestFirst = [NSURLRequest requestWithURL:urlFirst];
    NSURLSessionConfiguration *configFirst = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *sessionFirst = [NSURLSession sessionWithConfiguration:configFirst delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    _dataTaskFirst = [sessionFirst dataTaskWithRequest:requestFirst];
    [_dataTaskFirst resume];
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    if (dataTask == _dataTaskFirst) {
        if(self.dataFirst == nil){
            self.dataFirst = [[NSMutableData alloc] init];
        } else {
            self.dataFirst.length = 0;
        }
        completionHandler(NSURLSessionResponseAllow);
    } else if (dataTask == _dataTaskSecond) {
        if(self.dataSecond == nil){
            self.dataSecond = [[NSMutableData alloc] init];
        } else {
            self.dataSecond.length = 0;
        }
        completionHandler(NSURLSessionResponseAllow);
    }
    
}

- (void)URLSession:(NSURLSession *)session dataTask:( NSURLSessionDataTask *)dataTask didReceiveData:( NSData *)data {
    if (dataTask == _dataTaskFirst) {
        [self.dataFirst appendData:data];
    } else if (dataTask == _dataTaskSecond) {
        [self.dataSecond appendData:data];
    }
}

- (void)URLSession:(NSURLSession *)session task:( NSURLSessionTask *)task didCompleteWithError:( NSError *)error {
    if (task == _dataTaskFirst) {
        if (error == nil) {
            NSDictionary *dictFirst = [NSJSONSerialization JSONObjectWithData:_dataFirst options:kNilOptions error:nil];
//            NSLog(@"%@",dictFirst);
            [_cityArray insertObject:[NSString stringWithFormat:@"%@",dictFirst[@"city"]] atIndex:0];
            _weatherScrollPage.cityArray = [NSMutableArray arrayWithArray:_cityArray];
        } else {
            //NSLog(@"error = %@", error);
        }
//        [self creatMainTableView];
        _tempArray = [[NSMutableArray alloc] init];
        [self creatTempArray];
        
        //[[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //[self->_mainTableView reloadData];
        //}];
    } else if (task == _dataTaskSecond) {
        if (error == nil) {
            NSDictionary *dictSecond = [NSJSONSerialization JSONObjectWithData:_dataSecond options:kNilOptions error:nil];
//            NSLog(@"%@",dictSecond);
            [_tempArray addObject:dictSecond[@"tem"]];
            if (_index < _cityArray.count) {
                [self creatTempArray];
            } else {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self creatMainTableView];
                }];
            }
        } else {
            //NSLog(@"error = %@", error);
        }
    }
    
}

- (void)creatTempArray {
    NSString *city = _cityArray[_index];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSString *stringSecond = [NSString stringWithFormat:@"https://www.tianqiapi.com/free/day?appid=28845343&appsecret=zPNqw1IO&city=%@", city];
        stringSecond = [stringSecond stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *urlSecond = [NSURL URLWithString:stringSecond];
        NSURLRequest *requestSecond = [NSURLRequest requestWithURL:urlSecond];
        NSURLSessionConfiguration *configSecond = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *sessionSecond = [NSURLSession sessionWithConfiguration:configSecond delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        self->_dataTaskSecond = [sessionSecond dataTaskWithRequest:requestSecond];
        [self->_dataTaskSecond resume];
    }];
    _index ++;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  100;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.cityNameLabel.text = _cityArray[indexPath.row];
    
    cell.tempLabel.frame = CGRectMake(selfWidth - 120, 0, 100, 100);
    if (indexPath.row < _tempArray.count) {
        cell.tempLabel.text = _tempArray[indexPath.row];
    }
    
    
    cell.separatorLine.frame = CGRectMake(10, 99, selfWidth - 20, 1);
    
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    [self creatFooterView];
    return _footerView;
}

- (void)creatFooterView {
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfWidth, 40)];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addButton.frame = CGRectMake(selfWidth - 50, 10, 30, 30);
    [addButton setImage:[UIImage imageNamed:@"add1.png"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(pressAdd) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:addButton];
}

- (void)pressAdd {
    _searchPage = [[SearchCityViewController alloc] init];
    _searchPage.weatherPage = [[WeatherViewController alloc] init];
    _searchPage.weatherPage.delegate = self;
    [self presentViewController:_searchPage animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    _weatherScrollPage = [[WeatherScrollViewController alloc] init];
    _weatherScrollPage.position = indexPath.row;
//    _weatherScrollPage.cityArray = [NSMutableArray arrayWithArray:_cityArray];
//    _weatherScrollPage.mainScrollView = [[UIScrollView alloc] init];
//    [_weatherScrollPage.view addSubview:_weatherScrollPage.mainScrollView];
//    _weatherScrollPage.mainScrollView.frame = CGRectMake(0, statusBarHeight + 50, selfWidth, selfHeight - statusBarHeight - 50);
    _weatherScrollPage.mainScrollView.contentSize = CGSizeMake(selfWidth * _cityArray.count, selfHeight - statusBarHeight - 50);
    [_weatherScrollPage.mainScrollView setContentOffset:CGPointMake(selfWidth * indexPath.row, 0) animated:NO];
//
//    _weatherScrollPage.allWeekArray = [[NSMutableArray alloc] init];
//    _weatherScrollPage.allHighTempArray = [[NSMutableArray alloc] init];
//    _weatherScrollPage.allLowTempArray = [[NSMutableArray alloc] init];
//    _weatherScrollPage.allHourArray = [[NSMutableArray alloc] init];
//    _weatherScrollPage.allHourStatusImageArray = [[NSMutableArray alloc] init];
//    _weatherScrollPage.allHourTempArray = [[NSMutableArray alloc] init];
//    _weatherScrollPage.allDayStatusImageArray = [[NSMutableArray alloc] init];
//    _weatherScrollPage.allNightStatusImageArray = [[NSMutableArray alloc] init];
//    _weatherScrollPage.allWeatherDictionary = [[NSMutableArray alloc] init];
//    _weatherScrollPage.allCurrentWeatherDictionary = [[NSMutableArray alloc] init];
//    _weatherScrollPage.allLeftInfoArray = [[NSMutableArray alloc] init];
//    _weatherScrollPage.allRightInfoArray = [[NSMutableArray alloc] init];
//
//    [_weatherScrollPage creatUrl];
    
    _weatherScrollPage.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:_weatherScrollPage animated:YES completion:nil];
}

- (void)doAdd:(NSString *)cityName infoFirst:(NSDictionary*)weatherDictionary infoSecond:(NSDictionary*)currentWeatherDictionary {
    if (_searchPage) {
        [_searchPage dismissViewControllerAnimated:YES completion:nil];
    }
    if(![_cityArray containsObject:cityName]) {
        [_cityArray addObject:cityName];
        _weatherScrollPage.cityArray = [NSMutableArray arrayWithArray:_cityArray];
        [self creatTempArray];
        [_weatherScrollPage.allWeatherDictionary addObject:weatherDictionary];
        [_weatherScrollPage.allCurrentWeatherDictionary addObject:currentWeatherDictionary];
    }
}

- (void)receive:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    
    [_weatherScrollPage.allWeekArray addObject:dict[@"weekArray"]];
    
    [_weatherScrollPage.allHighTempArray addObject:dict[@"highTempArray"]];
    [_weatherScrollPage.allLowTempArray addObject:dict[@"lowTempArray"]];
    [_weatherScrollPage.allHourArray addObject:dict[@"hourArray"]];
    [_weatherScrollPage.allHourStatusImageArray addObject:dict[@"hourStatusImageArray"]];
    [_weatherScrollPage.allHourTempArray addObject:dict[@"hourTempArray"]];
    [_weatherScrollPage.allDayStatusImageArray addObject:dict[@"dayStatusImageArray"]];
    [_weatherScrollPage.allNightStatusImageArray addObject:dict[@"nightStatusImageArray"]];
    [_weatherScrollPage.allLeftInfoArray addObject:dict[@"leftInfoArray"]];
    [_weatherScrollPage.allRightInfoArray addObject:dict[@"rightInfoArray"]];
}

@end
