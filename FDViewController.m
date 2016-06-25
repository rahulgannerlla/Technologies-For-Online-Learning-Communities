//
//  FDViewController.m
//  Firebase Drawing
//
//  Created by Jonny Dimond on 8/14/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import "FDViewController.h"

#import <Firebase/Firebase.h>
#import "FDDrawView.h"
#import "FDColorPickController.h"

// Replace this with your own Firebase
static NSString * const kFirebaseURL = @"https://drawtexteditor.firebaseIO.com";

@interface FDViewController ()

// The firebase this demo uses
@property (nonatomic, strong) Firebase *firebase;

// The current state of the paths drawn
@property (nonatomic, strong) NSMutableArray *paths;

// A view the user can draw on
@property (nonatomic, strong) FDDrawView *drawView;

// A button to choose a new color
@property (nonatomic, strong) UIButton *colorButton;

// A set of paths by this user that have not been acknowlegded by the server yet
@property (nonatomic, strong) NSMutableSet *outstandingPaths;

// The handle that was returned for observing child events
@property (nonatomic) FirebaseHandle childAddedHandle;

@end

@implementation FDViewController

- (id)init
{
    self = [super init];
    if (self != nil) {
        
        
        self.title=@"Touch";
        red = 148.0/255.0;
        green = 250.0/255.0;
        blue = 10.0/255.0;
        brush = 4.0;
        opacity = 1.0;
        
        // initialize the firebase that is used for this sample
        self.firebase = [[Firebase alloc] initWithUrl:kFirebaseURL];

        // setup the state variables
        self.paths = [NSMutableArray array];
        self.outstandingPaths = [NSMutableSet set];

        // get a weak reference so we don't cause any retain cycles in tha callback block
        __weak FDViewController *weakSelf = self;

        // New drawings will appear as child added events
        self.childAddedHandle = [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            if ([weakSelf.outstandingPaths containsObject:snapshot.name]) {
                // this was drawn by this device and already taken care of by our draw view, ignore
            } else {
                // parse the path into our internal format
                FDPath *path = [FDPath parse:snapshot.value];
                if (path != nil) {
                    // the parse was successful, add it to our view
                    if (weakSelf.drawView != nil) {
                        [weakSelf.drawView addPath:path];
                    }
                    // keep track of the paths so far
                    [weakSelf.paths addObject:path];
                } else {
                    // there was an error parsing the snapshot, log an error
                    NSLog(@"Not a valid path: %@ -> %@", snapshot.name, snapshot.value);
                }
            }
        }];
    }
    return self;
}

- (void)dealloc
{
    // make sure there are no outstanding observers
    [self.firebase removeObserverWithHandle:self.childAddedHandle];
}

-(UIImage *)getScreenShot{
    CGRect rect=[[UIScreen mainScreen]bounds];
    
    NSMutableArray *screenshots=[[NSMutableArray alloc] initWithObjects: nil];
    UIGraphicsBeginImageContext(rect.size);
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGRect screenshotFrame;
    screenshotFrame.origin.x = 0;
    screenshotFrame.origin.y = 0;
    screenshotFrame.size.height = rect.size.height-44;
    screenshotFrame.size.width =rect.size.width;
    /* Crop the region */
    CGImageRef screenshotRef = CGImageCreateWithImageInRect(viewImage1.CGImage, screenshotFrame);
    UIImage * screenshot = [UIImage imageWithCGImage:screenshotRef];
    
    
    CFRelease(screenshotRef);
    if (screenshot!=Nil) {
        [screenshots addObject:screenshot];
    }else{
        
    }
    return screenshot;
}


- (void)colorButtonPressed
{
    [self.delegate hideRealTimeViewAndCaptureWithImage:[self getScreenShot]];
}

- (void)colorPicker:(FDColorPickController *)colorPicker didPickColor:(UIColor *)color
{
    // the user chose a new color, update the drawing view
    self.drawView.drawColor = color;
}

- (void)drawView:(FDDrawView *)view didFinishDrawingPath:(FDPath *)path
{
    // the user finished drawing a path
    Firebase *pathRef = [self.firebase childByAutoId];

    // get the name of this path which serves as a global id
    NSString *name = pathRef.name;

    // remember that this path was drawn by this user so it's not drawn twice
    [self.outstandingPaths addObject:name];

    // save the path to Firebase
    [pathRef setValue:[path serialize] withCompletionBlock:^(NSError *error, Firebase *ref) {
        // The path was successfully saved and can now be removed from the outstanding paths
        [self.outstandingPaths removeObject:name];
    }];
}

- (void)loadView
{
    // load and setup view
    

    // this is the main view and used to show drawing from other users and let the user draw
    self.drawView = [[FDDrawView alloc] initWithFrame:CGRectMake(0, 0, 320, 568-74)];

    // make sure it's resizable to fit any device size
    self.drawView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // add any paths that were already received from Firebase
    for (FDPath *path in self.paths) {
        [self.drawView addPath:path];
    }

    // make sure the user can draw on this view
    self.drawView.userInteractionEnabled = YES;

    // set the delegate of this view to self
    self.drawView.delegate = self;
    
    
    eraserButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    eraserButton.frame=CGRectMake(150, 10, 50, 30);
    eraserButton.layer.cornerRadius = 10;
    eraserButton.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9].CGColor;
    eraserButton.layer.borderColor = self.colorButton.tintColor.CGColor;
    eraserButton.layer.borderWidth = 1;
    [eraserButton setTitle:@"Eraser" forState:UIControlStateNormal];
    [eraserButton addTarget:self
                         action:@selector(eraserButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    eraserButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    
    
    self.colorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    // make button over 9000 beauty
    self.colorButton.layer.cornerRadius = 10;
    self.colorButton.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9].CGColor;
    self.colorButton.layer.borderColor = self.colorButton.tintColor.CGColor;
    self.colorButton.layer.borderWidth = 1;
    [self.colorButton setTitle:@"Use" forState:UIControlStateNormal];
    
    // make sure clicks on the button call our method
    [self.colorButton addTarget:self
                         action:@selector(colorButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    
    // ensure the button has the right size and position
    self.colorButton.frame = CGRectMake(210, 10, 90, 35);
    self.colorButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    
    // add the button to the draw view
    [self.drawView addSubview:self.colorButton];
   // [self.drawView addSubview:eraserButton];
    
        colorsView=[[UIView alloc]initWithFrame:CGRectMake(10, 568-74, 300, 74)];
        [colorsView setBackgroundColor:[UIColor lightGrayColor]];
        colorsView.layer.cornerRadius=8.0;
        colorsView.userInteractionEnabled=YES;
    
        colorScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 300, 74)];
        [colorScrollView setDelegate:self];
        colorScrollView.scrollEnabled=YES;
        colorScrollView.showsHorizontalScrollIndicator = YES;
        colorScrollView.userInteractionEnabled=YES;
    
        NSArray *colorsArray=[[NSArray alloc]initWithObjects:[UIColor greenColor],[UIColor magentaColor],[UIColor purpleColor],[UIColor orangeColor],[UIColor blueColor],[UIColor redColor],[UIColor whiteColor],[UIColor blackColor],[UIColor redColor],[UIColor redColor],nil];
    
        float x=10.0;
        for (int i=0; i<10; i++) {
            UIButton *colorButton=[[UIButton alloc]initWithFrame:CGRectMake(x, 15, 40, 44)];
            colorButton.tag=i;
            //[colorButton setBackgroundColor:[UIColor redColor]];
            [colorButton setBackgroundColor:[colorsArray objectAtIndex:i]];
            [colorButton addTarget:self action:@selector(colorButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [colorScrollView addSubview:colorButton];
            colorButton.layer.cornerRadius=6.0;
            x=x+60.0;
        }
        colorScrollView.contentSize=CGSizeMake(x+65.0, 74.0);

    // add the button to the draw view
    [self.drawView addSubview:self.colorButton];

    // finally set the view of this view controller to the draw view
    self.view = self.drawView;
    [self.drawView addSubview:colorsView];
    [colorsView addSubview:colorScrollView];
}

-(void)eraserButtonPressed{
    brush = 30.0;
    opacity = 1.0;
    red = 255.0/255.0;
    green = 255/255.0;
    blue = 255/255.0;
    [self.drawView setWidth:brush];
    
    self.drawView.drawColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}


-(void)colorButtonClicked:(UIButton*)colorButton{
    
    brush = 10.0;
    opacity = 1.0;
 //   [self.];
//    if (colorButton.tag==6) {
//        brush = 10.0;
//    }
//    else
//        brush = 4.0;
//    
   [self.drawView setWidth:brush];
    
    switch (colorButton.tag) {
        case 0:
            red = 51.0/255.0;
            green = 153.0/255.0;
            blue = 51.0/255.0;
            break;
            
        case 1:
            red = 255/255.0;
            green = 0.0/255.0;
            blue = 151.0/255.0;
            break;
            
        case 2:
            red = 162.0/255.0;
            green = 0.0/255.0;
            blue = 255.0/255.0;
            break;
            
        case 3:
            red = 240.0/255.0;
            green = 150.0/255.0;
            blue = 9.0/255.0;
            break;
            
        case 4:
            red = 27.0/255.0;
            green = 161.0/255.0;
            blue = 226.0/255.0;
            break;
            
        case 5:
            red = 229.0/255.0;
            green = 20.0/255.0;
            blue = 0.0/255.0;
            break;
            
        case 6:
            red = 255.0/255.0;
            green = 255.0/255.0;
            blue = 255.0/255.0;
            break;
            
        default:
            break;
    }
    
    self.drawView.drawColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && [self.view window] == nil) {
        self.view = nil;
        self.drawView = nil;
        self.colorButton = nil;
    }
}

@end
