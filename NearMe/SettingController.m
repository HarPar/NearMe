//
//  SettingController.m
//  NearMe
//
//  Created by Harshil Parikh on 2017-02-28.
//  Copyright © 2017 Harshil Parikh. All rights reserved.
//


// NOTE: SEGMENTED CONTROL CURRENTLY IS NOT CODED

#import "SettingController.h"
#import "ViewController.h"

@interface SettingController ()


@end

@implementation SettingController
double maxDist;
@synthesize rad;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Max Radius
    maxDist = 50000;
    
    // Set the value of slider and string for label
    [_distanceSlider setValue:[rad doubleValue]/maxDist animated: NO];
    _distanceLabel.text = [NSString stringWithFormat:@"%.01fkm", [rad doubleValue]/1000];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // Pass rad back to ViewController
    ViewController *destViewController = segue.destinationViewController;
    destViewController.updateRad = rad;
}


- (IBAction)distanceSliderMoved:(id)sender {
    // When slider is moved updated rad and label
    rad = [NSNumber numberWithDouble: _distanceSlider.value * maxDist];
    _distanceLabel.text = [NSString stringWithFormat:@"%.01fkm", [rad doubleValue]/1000];
}
@end
