//
//  SearchCityViewController.m
//  WeatherForecast
//
//  Created by 张博添 on 2021/8/9.
//

#import "SearchCityViewController.h"

#define selfWidth self.view.bounds.size.width
#define selfHeight self.view.bounds.size.height
#define tabBarHeight self.tabBarController.tabBar.bounds.size.height
#define navigationBarHeight self.navigationController.navigationBar.bounds.size.height
#define statusBarHeight [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height
#define toolBarHeight self.navigationController.toolbar.bounds.size.height

@interface SearchCityViewController ()
<
UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource,
NSURLSessionDelegate
>

@end

@implementation SearchCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.95];
    
    [self creatTitleLabel];
    [self creatSearchTextField];
    [self creatTableView];
}

- (void)creatTitleLabel {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, selfWidth, 20)];
    _titleLabel.text = @"输入城市或省份";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_titleLabel];
}

- (void)creatSearchTextField {
    _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 30, selfWidth - 90, 40)];
    _searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    _searchTextField.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.93];
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextField.keyboardType = UIKeyboardTypeDefault;
    _searchTextField.delegate = self;
    UIView *searchLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _searchTextField.frame.size.height, _searchTextField.frame.size.height)];
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 7, _searchTextField.frame.size.height - 14, _searchTextField.frame.size.height - 14)];
    leftImage.image = [UIImage imageNamed:@"fangdajing.png"];
    [searchLeftView addSubview:leftImage];
    _searchTextField.leftView = searchLeftView;
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_searchTextField];
    [self creatCancelButton];
}

- (void)creatCancelButton {
    _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _cancelButton.frame = CGRectMake(selfWidth - 60, 30, 40, 40);
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTintColor:[UIColor systemRedColor]];
    [_cancelButton addTarget:self action:@selector(pressCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
}

- (void)creatTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, selfWidth, selfHeight - 70) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.sectionHeaderHeight = 0.01;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到view上
    [_tableView addGestureRecognizer:tapGestureRecognizer];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  50;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    while ([cell.contentView.subviews lastObject] != nil) {
        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    cell.textLabel.text = _cityArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_searchTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    _cityArray = [[NSMutableArray alloc] init];
    _cityNameArray = [[NSMutableArray alloc] init];
    _cityIdArray = [[NSMutableArray alloc] init];
    [self creatUrl];
    [_searchTextField resignFirstResponder];
    return YES;
}

- (void)creatUrl {
    NSString *urlString = [NSString stringWithFormat:@"https://geoapi.qweather.com/v2/city/lookup?location=%@&key=4d439403f8064f67a3893bdfe17afa79",_searchTextField.text];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self  delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    if(self.data == nil){
        self.data = [[NSMutableData alloc] init];
    } else {
        self.data.length = 0;
    }
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:( NSURLSessionDataTask *)dataTask didReceiveData:( NSData *)data {
    [self.data appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:( NSURLSessionTask *)task didCompleteWithError:( NSError *)error {
    if (error == nil) {
        NSDictionary *secondDictionary = [NSJSONSerialization JSONObjectWithData:_data options:kNilOptions error:nil];
        NSMutableArray *timeArray = [[NSMutableArray alloc] init];
        timeArray = secondDictionary[@"location"];
        for (int i = 0; i < timeArray.count; i++) {
            if ([timeArray[i][@"name"] isEqualToString:timeArray[i][@"adm2"]]) {
                NSMutableString *str = [NSMutableString stringWithFormat:@"%@-%@",timeArray[i][@"name"],timeArray[i][@"adm1"]];
                [_cityArray addObject: str];
                [_cityNameArray addObject:timeArray[i][@"name"]];
                [_cityIdArray addObject:timeArray[i][@"id"]];
            } else {
                NSMutableString *str = [NSMutableString stringWithFormat:@"%@-%@-%@",timeArray[i][@"name"],timeArray[i][@"adm2"],timeArray[i][@"adm1"]];
                [_cityArray addObject: str];
                [_cityNameArray addObject:timeArray[i][@"name"]];
                [_cityIdArray addObject:timeArray[i][@"id"]];
            }
        }
    } else {
        //NSLog(@"error = %@", error);
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self->_tableView reloadData];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _weatherPage.cityName = _cityNameArray[indexPath.row];
    _weatherPage.cityId = _cityIdArray[indexPath.row];
    
    [self presentViewController:_weatherPage animated:YES completion:nil];
    
}

- (void)pressCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_searchTextField resignFirstResponder];
}

@end
