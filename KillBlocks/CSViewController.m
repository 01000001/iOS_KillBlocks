//
//  CSViewController.m
//  KillBlocks
//
//  Created by Attila Csala on 12/3/13.
//  Copyright (c) 2013 Attila Csala. All rights reserved.
//

#import "CSViewController.h"
#import "CSMyScene.h"
#import <KiiSDK/Kii.h>

@implementation CSViewController

-(void) viewDidAppear:(BOOL)animated{
    
    if (![KiiUser loggedIn]) {
        
        KTLoginViewController *loginView = [[KTLoginViewController alloc] init];
        [self presentViewController:loginView animated:TRUE completion:nil];
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [CSMyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
