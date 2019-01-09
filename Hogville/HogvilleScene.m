//
//  MyScene.m
//  Hogville
//
//  Created by Main Account on 3/1/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "HogvilleScene.h"
#import "Pig.h"

@interface HogvilleScene () <SKPhysicsContactDelegate>
 
@end

@implementation HogvilleScene
{
  Pig *_movingPig;
  NSTimeInterval _lastUpdateTime;
  NSTimeInterval _dt;
  NSTimeInterval _currentSpawnTime;
  BOOL _gameOver;
}

-(id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    self.physicsWorld.contactDelegate = self;
    [self loadLevel];
    [self spawnAnimal];
  }
  return self;
}

- (void)loadLevel {
  //1
  SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"bg_2_grassy"];
  bg.anchorPoint = CGPointZero;
  [self addChild:bg];
 
  //2
  SKSpriteNode *foodNode = [SKSpriteNode spriteNodeWithImageNamed:@"trough_3_full"];
  foodNode.name = @"food";
  foodNode.zPosition = 0;
  foodNode.position = CGPointMake(250.0f, 200.0f);
  // More code later
  foodNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:foodNode.size];
  foodNode.physicsBody.categoryBitMask = LDPhysicsCategoryFood;
  foodNode.physicsBody.dynamic = NO;
 
  [self addChild:foodNode];
 
  //3
  self.homeNode = [SKSpriteNode spriteNodeWithImageNamed:@"barn"];
  self.homeNode.name = @"home";
  self.homeNode.zPosition = 0;
  self.homeNode.position = CGPointMake(380.0f, 20.0f);
  [self addChild:self.homeNode];
  _currentSpawnTime = 5.0;
}

- (void)spawnAnimal {
  if(_gameOver) {
    return;
  }

  //1
  _currentSpawnTime -= 0.2;
 
  //2
  if(_currentSpawnTime < 1.0) {
    _currentSpawnTime = 1.0;
  }
 
  //3
  Pig *pig = [[Pig alloc] initWithImageNamed:@"pig_1"];
  pig.position = CGPointMake(20.0f, arc4random() % 300);
  pig.name = @"pig";
  pig.zPosition = 1;
 
  [self addChild:pig];
  [pig moveRandom];
  
  //4
  [self runAction:
   [SKAction sequence:@[[SKAction waitForDuration:_currentSpawnTime], 
                        [SKAction performSelector:@selector(spawnAnimal) onTarget:self]]]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

  if(_gameOver) {
    [self restartGame];
  }

  CGPoint touchPoint = [[touches anyObject] locationInNode:self.scene];

  SKNode *node = [self nodeAtPoint:touchPoint];
   
  if([node.name isEqualToString:@"pig"]) {
    [(Pig *)node addPointToMove:touchPoint];
    [(Pig *)node clearWayPoints];
    _movingPig = (Pig *)node;
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  CGPoint touchPoint = [[touches anyObject] locationInNode:self.scene];

  if(_movingPig) {
    [_movingPig addPointToMove:touchPoint];
  }
}

-(void)update:(CFTimeInterval)currentTime {
  if (!_gameOver) {
    _dt = currentTime - _lastUpdateTime;
    _lastUpdateTime = currentTime;
     
    [self enumerateChildNodesWithName:@"pig" usingBlock:^(SKNode *pig, BOOL *stop) {
      [(Pig *)pig move:@(_dt)];
    }];
      
    [self drawLines];
  }
}

- (void)drawLines {
  //1

  NSMutableArray *temp = [NSMutableArray array];
  for(CALayer *layer in self.view.layer.sublayers) {
    if([layer.name isEqualToString:@"line"]) {
      [temp addObject:layer];
    }
  }
    
  [temp makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
  //2
  [self enumerateChildNodesWithName:@"pig" usingBlock:^(SKNode *node, BOOL *stop) {
    //3
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.name = @"line";
    lineLayer.strokeColor = [UIColor grayColor].CGColor;
    lineLayer.fillColor = nil;
    
    //4
    CGPathRef path = [(Pig *)node createPathToMove];
    lineLayer.path = path;
    CGPathRelease(path);
    [self.view.layer addSublayer:lineLayer];
  }];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
  //1
  SKNode *firstNode = contact.bodyA.node;
  SKNode *secondNode = contact.bodyB.node;
 
  //2
  uint32_t collision = firstNode.physicsBody.categoryBitMask | secondNode.physicsBody.categoryBitMask;
 
  //3
  if(collision == (LDPhysicsCategoryAnimal | LDPhysicsCategoryAnimal)) {
    NSLog(@"Animal collision detected");
    [self handleAnimalCollision];
  } else if(collision == (LDPhysicsCategoryAnimal | LDPhysicsCategoryFood)) {
    NSLog(@"Food collision detected.");
    if([firstNode.name isEqualToString:@"pig"]) {
      [(Pig *)firstNode eat];
    } else {
      [(Pig *)secondNode eat];
    }
  } else {
    NSLog(@"Error: Unknown collision category %d", collision);
  }
}

- (void)handleAnimalCollision {
  _gameOver = YES;
 
  SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Thonburi-Bold"];
  gameOverLabel.text = @"Game Over!";
  gameOverLabel.name = @"label";
  gameOverLabel.fontSize = 35.0f;
  gameOverLabel.position = CGPointMake(self.size.width / 2.0f, self.size.height / 2.0f + 20.0f);
  gameOverLabel.zPosition = 5;
 
  SKLabelNode *tapLabel = [SKLabelNode labelNodeWithFontNamed:@"Thonburi-Bold"];
  tapLabel.text = @"Tap to restart.";
  tapLabel.name = @"label";
  tapLabel.fontSize = 25.0f;
  tapLabel.position = CGPointMake(self.size.width / 2.0f, self.size.height / 2.0f - 20.0f);
  tapLabel.zPosition = 5;
  [self addChild:gameOverLabel];
  [self addChild:tapLabel];
}

- (void)restartGame {
  [self enumerateChildNodesWithName:@"line" usingBlock:^(SKNode *node, BOOL *stop) {
    [node removeFromParent];
  }];
 
  [self enumerateChildNodesWithName:@"pig" usingBlock:^(SKNode *node, BOOL *stop) {
    [node removeFromParent];
  }];
 
  [self enumerateChildNodesWithName:@"label" usingBlock:^(SKNode *node, BOOL *stop) {
    [node removeFromParent];
  }];
 
  _currentSpawnTime = 5.0f;
  _gameOver = NO;
  [self spawnAnimal];
}

@end
