//
//  FlappyViewController.m
//  Flappy Felipe
//
//  Created by Main Account on 2/13/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "FlappyViewController.h"
#import "FlappyScene.h"

@interface FlappyViewController () <FlappySceneDelegate>
@end

@implementation FlappyViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Configure the view.
  SKView * skView = (SKView *)self.view;
  skView.showsFPS = NO;
  skView.showsNodeCount = NO;
  
  // Create and configure the scene.
  SKScene * scene = [[FlappyScene alloc] initWithSize:skView.bounds.size delegate:self state:GameStateMainMenu];
  scene.scaleMode = SKSceneScaleModeAspectFill;
  
  // Present the scene.
  [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
  return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
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

- (BOOL)prefersStatusBarHidden {
  return YES;
}

- (UIImage *)screenshot {
  UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 1.0);
  [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

- (void)shareString:(NSString *)string url:(NSURL*)url image:(UIImage *)image {
  UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[string, url, image] applicationActivities:nil];
  [self presentViewController:vc animated:YES completion:nil];

}

@end
