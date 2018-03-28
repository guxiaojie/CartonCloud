//
//  ViewController.m
//  CartonCloudOC
//
//  Created by Guxiaojie on 28/03/2018.
//  Copyright © 2018 SageGu. All rights reserved.
//

#import "ViewController.h"
#import <React/RCTRootView.h>
#import "WeatherRequest.h"

@interface ViewController ()
@property(nonatomic, strong) UIActivityIndicatorView *indicatorView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Show Weather" style:UIBarButtonItemStylePlain target:self action:@selector(loadData)];

    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.indicatorView];
    self.indicatorView.center = self.view.center;
    self.indicatorView.hidesWhenStopped = YES;
}


- (void)loadData {
    [self.indicatorView startAnimating];
    
    __weak typeof(self) weakself = self;
    [WeatherRequest sendRequest:^(NSArray *elements, NSError *error) {
        if(error == nil) {
            dispatch_sync( dispatch_get_main_queue(), ^ {
                
                [weakself loadWeather:elements];
                [weakself.indicatorView stopAnimating];
            });
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadWeather:(NSArray *)array {
    NSURL *jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.bundle?platform=ios"];
    
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL: jsCodeLocation
                                                        moduleName: @"RNWeather"
                                                 initialProperties: @{@"weather" : array}
                                                     launchOptions: nil];
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view = rootView;
    vc.title = @"Brisbane";
    [self.navigationController pushViewController:vc animated:YES];
//    [self presentViewController:vc animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
