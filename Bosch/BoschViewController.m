//
//  BorchViewController.m
//  GMIA1
//
//  Created by Rene Van Meeuwen on 8/11/2016.
//  Copyright © 2016 Rene Van Meeuwen. All rights reserved.
//

#import "BoschViewController.h"
#import "BoschSceneStart.h"


@interface BoschViewController ()


@end


@implementation BoschViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: Check leaderboard access?
    /*
    GKLocalPlayer *playa = [GKLocalPlayer localPlayer];
    [playa setAuthenticateHandler:^(UIViewController * _Nullable viewController, NSError * _Nullable error){
        //SKView * skView = (SKView *)self.view;
        //[skView setPaused:YES];
        if(error){
            NSLog(@"error here fool %@", error);
        }
        if(viewController){
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }];
    */
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    BoschSceneStart *scene = [BoschSceneStart nodeWithFileNamed:@"BoschSceneStart"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}




- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
