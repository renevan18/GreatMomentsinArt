//
//  MyScene.h
//  Flappy Felipe
//

//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(int, GameState) {
  GameStateMainMenu,
  GameStateTutorial,
  GameStatePlay,
  GameStateFalling,
  GameStateShowingScore,
  GameStateGameOver
};

@protocol FlappySceneDelegate
- (UIImage *)screenshot;
- (void)shareString:(NSString *)string url:(NSURL*)url image:(UIImage *)screenshot;
@end

@interface FlappyScene : SKScene

-(id)initWithSize:(CGSize)size delegate:(id<FlappySceneDelegate>)delegate state:(GameState)state;

@property (strong, nonatomic) id<FlappySceneDelegate> sceneDelegate;

@end
