//
//  SKCardSelectionViewController.h
//  mbrace Case Study
//
//  Created by Simone Kalb on 14/06/14.
//  Copyright (c) 2014 http://simone.kalb.it. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SKCardSelectionViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *cardView;
@property (strong, nonatomic) IBOutlet UIButton *interestButton;
@property (strong, nonatomic) IBOutlet UIImageView *visualClueOverlayYES;
@property (strong, nonatomic) IBOutlet UIImageView *visualClueOverlayNO;

@end
