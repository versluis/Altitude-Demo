//
//  ViewController.m
//  Altitude Test
//
//  Created by Jay Versluis on 28/10/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import "ViewController.h"
@import CoreMotion;

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (strong, nonatomic) CMAltimeter *altimeter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // populate labels
    self.label1.text = nil;
    self.label2.text = nil;
    self.label3.text = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CMAltimeter *)altimeter {
    
    if (!_altimeter) {
        _altimeter = [[CMAltimeter alloc]init];
    }
    return _altimeter;
}

- (IBAction)trackAltitude {
    
    // check if the barometer is available
    if (![CMAltimeter isRelativeAltitudeAvailable]) {
        
        NSLog(@"Barometer is not available on this device. Sorry!");
        [self noBarometerAlert];
        return;
    
    } else {
        
        NSLog(@"Barometer is available.");
    }
    
    // start altitude tracking
    [self.altimeter startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData * _Nullable altitudeData, NSError * _Nullable error) {
        
        // this block is called every time there's an update
        
        NSString *timeInterval = [NSString stringWithFormat:@"%f", altitudeData.timestamp];
        NSString *altitude = [NSString stringWithFormat:@"%@", altitudeData.relativeAltitude];
        NSString *pressure = [NSString stringWithFormat:@"%@", altitudeData.pressure];
        
        self.label1.text = [NSString stringWithFormat:@"Time Interval: %@", timeInterval];
        self.label2.text = [NSString stringWithFormat:@"Relative Altitude: %@", altitude];
        self.label3.text = [NSString stringWithFormat:@"Air Pressure: %@", pressure];
        
    }];
}

- (IBAction)stopTracking:(id)sender {
    
    // switch of altitude tracking
    [self.altimeter stopRelativeAltitudeUpdates];
}

- (void)noBarometerAlert {
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"No Barometer" message:@"This device doesn'y have a barometer, so we can't track how high you're flying here. Sorry, Cap'm!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Damn Technology!" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
