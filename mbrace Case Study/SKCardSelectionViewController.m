//
//  SKCardSelectionViewController.m
//  mbrace Case Study
//
//  Created by Simone Kalb on 14/06/14.
//  Copyright (c) 2014 http://simone.kalb.it. All rights reserved.
//

#import "SKCardSelectionViewController.h"
#import <POP.h>

#define MAX_CARD_NAME 20

@interface SKCardSelectionViewController () <POPAnimationDelegate>

@property(nonatomic,strong) NSMutableArray *cardFileNames;
@property(nonatomic,strong) NSString *overlayFileName;

@end

@implementation SKCardSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initCardNames];
    [self setVisualClueOverlayYES:self.visualClueOverlayYES];
    [self setVisualClueOverlayNO:self.visualClueOverlayNO];
    [self addCardGestures];
}

#pragma mark - Initializing Methods
-(void)initCardNames {
    // This should be set in App Delegate
    if(!self.cardFileNames)
        self.cardFileNames = [[NSMutableArray alloc] initWithCapacity: MAX_CARD_NAME];
    for (int cardIndex = 1; cardIndex <= MAX_CARD_NAME ; cardIndex++) {
        NSString *currentCardName = [NSString stringWithFormat:@"card_%i", cardIndex];
        [self.cardFileNames addObject:currentCardName];
    }
}

// Setup visual clue Overlay's visibility to none at start time
-(void)setVisualClueOverlayNO:(UIImageView *)visualClueOverlayNO {
    visualClueOverlayNO.hidden = YES;
}

-(void)setVisualClueOverlayYES:(UIImageView *)visualClueOverlayYES {
    visualClueOverlayYES.hidden =YES;
}

-(void)addCardGestures {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePan:)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleTap:)];

    
    [self.cardView addGestureRecognizer:panGesture];
    [self.cardView addGestureRecognizer:tapGesture];
    
}
#pragma mark - Pop Delegate Methods
- (void)pop_animationDidApply:(POPDecayAnimation *)anim
{
    BOOL isDragViewOutsideOfSuperView = !CGRectContainsRect(self.view.frame, self.cardView.frame);
    if (isDragViewOutsideOfSuperView) {
        CGPoint currentVelocity = [[anim valueForKeyPath:@"velocity"] CGPointValue];
        CGPoint velocity = CGPointMake(currentVelocity.x, -currentVelocity.y);
        POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
        positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        positionAnimation.toValue = [NSValue valueWithCGPoint:self.view.center];
        [self.cardView.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    }
}



#pragma mark - Gesture and animation handling
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    [recognizer.view.layer pop_removeAllAnimations];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:self.view];
        POPDecayAnimation *positionAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
        positionAnimation.delegate = self;
        positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        [recognizer.view.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
