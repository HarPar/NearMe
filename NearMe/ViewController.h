//
//  ViewController.h
//  NearMe
//
//  Created by Harshil Parikh on 2017-02-28.
//  Copyright © 2017 Harshil Parikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate>{
    NSMutableArray *images, *latitudes, *longitudes, *locationNames;
    CLLocationManager *locationManager;
    
}

- (IBAction)naviButton:(id)sender;
- (IBAction)getDirections:(id)sender;
@property (nonatomic, strong) NSNumber *updateRad;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet MKMapView *maps;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *directionsButton;

@end

