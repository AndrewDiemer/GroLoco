//
//  GLMapAnnotation.h
//  GrocoLoco
//
//  Created by Mark Hall on 2015-10-19.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

@interface GLMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, strong) NSString *_id;
@property (nonatomic, assign) NSInteger tag;

@end
