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
    [self resetLabels];
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
        self.label1.text = @"Gathering values...";
    }
    
    // start altitude tracking
    [self.altimeter startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData * _Nullable altitudeData, NSError * _Nullable error) {
        
        // this block is called every time there's an update
        [self updateLabels:altitudeData];
        
    }];
}

- (IBAction)stopTracking:(id)sender {
    
    // switch of altitude tracking
    [self.altimeter stopRelativeAltitudeUpdates];
    [self resetLabels];
}

- (void)noBarometerAlert {
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"No Barometer" message:@"This device doesn'y have a barometer, so we can't track how high you're flying here. Sorry, Cap'm!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Damn Technology!" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)resetLabels {
    
    // populate labels
    self.label1.text = @"Press Start to begin\nAltitude Tracking";
    self.label2.text = nil;
    self.label3.text = nil;
}

- (void)updateLabels:(CMAltitudeData *)altitudeData {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.maximumFractionDigits = 2;
    formatter.minimumIntegerDigits = 1;
    
    NSNumber *timestamp = [NSNumber numberWithDouble:altitudeData.timestamp];
    NSString *timeInterval = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:timestamp]];
    NSString *altitude = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:altitudeData.relativeAltitude]];
    NSString *pressure = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:altitudeData.pressure]];
    
    self.label1.text = [NSString stringWithFormat:@"Time Interval: \n%@", timeInterval];
    self.label2.text = [NSString stringWithFormat:@"Relative Altitude: \n%@", altitude];
    self.label3.text = [NSString stringWithFormat:@"Air Pressure: \n%@", pressure];
}

@end
