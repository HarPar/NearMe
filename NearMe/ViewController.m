//
//  ViewController.m
//  NearMe
//
//  Created by Harshil Parikh on 2017-02-28.
//  Copyright © 2017 Harshil Parikh. All rights reserved.
//


// USING GOOOGLE PLACES API TO FIND PHOTOS NEAR THE USER

#import "ViewController.h"
#import "PlaceCell.h"
#import "SettingController.h"

@interface ViewController ()

@end

@implementation ViewController
double latitude, longitude, rad;
long int cellNumber;
NSString *apiKey;


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    // Amount of pictures in the array
    return [images count];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // The size of the Collection View Cell
    return CGSizeMake([UIScreen mainScreen].bounds.size.width/2-5,[UIScreen mainScreen].bounds.size.width/2-5);
}

// Updating the actual Cell in the CollectionView
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *) indexPath{
    
    // Create a Reuseable Cell with identifier: PlaceCell
    PlaceCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"PlaceCell" forIndexPath:indexPath];

    // Add image to the cell
    cell.placeImageView.image = [images objectAtIndex:indexPath.row];
    
    return cell;
}


// Checking when cell is clicked
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    cellNumber = indexPath.row;
    
    // Disable collection view and update button
    [_collectionView setUserInteractionEnabled:NO];
    [_settingsButton setTitle:@"Back" forState:UIControlStateNormal];
    
    // Update Map
    [self updateMap];
}


-(void)updateMap{
    
    // Setting up a Pin
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D pinLocation;
    pinLocation.latitude = [latitudes[cellNumber] doubleValue];
    pinLocation.longitude = [longitudes[cellNumber] doubleValue];
    [annotation setCoordinate:pinLocation];
    [annotation setTitle:locationNames[cellNumber]]; //You can set the subtitle too
    [_maps addAnnotation:annotation];
    
    // Updating the Map
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    CLLocationCoordinate2D userLocation;
    userLocation.latitude = latitude;
    userLocation.longitude = longitude;
    region.span = span;
    region.center = pinLocation;
    _maps.layer.zPosition = 1;
    _directionsButton.layer.zPosition = 1;
    [_maps setRegion:region animated:YES];
    [_maps selectAnnotation:annotation animated:YES];
    
}

// Get JSON Data of the pictures
-(NSData *)getData:(NSString*)urlString
{
    // Create a URL
    NSHTTPURLResponse *response = nil;
    NSString *jsonUrlString = [NSString stringWithFormat:@"%@", urlString];
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    // Request and get data from Internet
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    return responseData;
}


// Should an error when getting the location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


// Update the longitude and latitude
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        latitude = currentLocation.coordinate.latitude;
        longitude = currentLocation.coordinate.longitude;
    }
}

// Get the URL String needed for the pictures
-(NSString *)getURL
{
    // Base URL for Google Places API use
    NSString *baseURL = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?";
    
    // Formatting the URL to get JSON Data
    baseURL = [NSString stringWithFormat:@"%@location=%f,%f&radius=%f&key=%@", baseURL, latitude, longitude, rad, apiKey];
    
    return baseURL;
}


// Parsing JSON Data
-(void)loadImages:(NSData *)picturesData{
    
    // Converting JSON Data to a Dictionary
    NSError *error;
    NSMutableDictionary *responseDict=[[NSMutableDictionary alloc]init];
    responseDict=[NSJSONSerialization JSONObjectWithData:picturesData options:NSJSONReadingMutableLeaves error:&error];
    
    NSMutableArray *results, *photoReference;
    photoReference = [[NSMutableArray alloc] init];
    NSString *baseURL = @"https://maps.googleapis.com/maps/api/place/photo?";
    
    
    // Getting the various places 'results' from JSON  data
    for (id response in responseDict){
        if([response  isEqual: @"results"]){
            results=[responseDict objectForKey: response];
        }
    }
    
    // Creating an array of location names
    locationNames = [results valueForKey:@"name"];
    
    // Creating an array of locations
    latitudes = [[[results valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"];
    longitudes = [[[results valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"];
    
    // Creating an array of photo ID references
    photoReference = [[results valueForKey: @"photos"] valueForKey:@"photo_reference"];
    
    for (id photo in photoReference){
        if(!(photo==[NSNull null])){
            [images addObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@maxwidth=%d&maxheight=%d&photoreference=%@&key=%@", baseURL, (int)[UIScreen mainScreen].bounds.size.width/2-5, (int)[UIScreen mainScreen].bounds.size.width/2-5, photo[0], apiKey]]]]];
        }
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSData *picData;
    NSString *picURL;
    
    
    images = [[NSMutableArray alloc]init];
    
    // API KEY
    apiKey = @"AIzaSyAcD3-IOLAKUKd_mpRN69Zmu6ULy52u8eQ";
    
    
    // Update radius
    if ([_updateRad doubleValue] > 0){
        rad = [_updateRad doubleValue];
    } else{
        rad = 10000;
    }
    
    
    // Getting User Latitude and Longitude
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    CLLocation * currentLocation = [locationManager location];
    
    latitude = currentLocation.coordinate.latitude;
    longitude = currentLocation.coordinate.longitude;
    
    // Getting Images into images array
    picURL = [self getURL];
    picData = [self getData:picURL];
    [self loadImages:picData];
    
    // Show users location
    _maps.showsUserLocation = YES;
    
    
    // CollectionView Properties
    [_collectionView setShowsHorizontalScrollIndicator:NO];
    [_collectionView setShowsVerticalScrollIndicator:NO];
    _collectionView.backgroundColor = [UIColor clearColor];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)naviButton:(id)sender {
    
    // Check whether to go back or perform a segue
    if([_settingsButton.titleLabel.text isEqualToString: @"Back"]){
        // Bring the Map Back and re-enable UICollectionView
        _maps.layer.zPosition = 0;
        _directionsButton.layer.zPosition = 0;
        [_collectionView setUserInteractionEnabled:YES];
    
        // Update Button
        [_settingsButton setTitle:@"Settings" forState:UIControlStateNormal];
    } else{
        
        // Perform segue with SettingController
        [self performSegueWithIdentifier:@"launchSettings" sender:self];
    }
}

- (IBAction)getDirections:(id)sender {
    
    // Sends a request to Apple Maps to show directions
    NSString* directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f", latitude, longitude, [latitudes[cellNumber] doubleValue], [longitudes[cellNumber] doubleValue]];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: directionsURL] options:@{} completionHandler:^(BOOL success){
        //CAN do something when successfully found directions
    }];
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // Pass the rad to SettingController
    SettingController *destViewController = segue.destinationViewController;
    destViewController.rad = [NSNumber numberWithDouble:rad];
    
}
@end
