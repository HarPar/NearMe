//
//  SettingController.h
//  NearMe
//
//  Created by Harshil Parikh on 2017-02-28.
//  Copyright © 2017 Harshil Parikh. All rights reserved.
//

#import "ViewController.h"

@interface SettingController : ViewController{
}

@property (nonatomic, strong) NSNumber *rad;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UISlider *distanceSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSegmentedIndex;
- (IBAction)distanceSliderMoved:(id)sender;

@end
