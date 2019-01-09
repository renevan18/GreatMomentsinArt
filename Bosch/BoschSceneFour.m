//
//  BoschSceneFour.m
//  GMIA1
//
//  Created by Rene Van Meeuwen on 14/2/18.
//  Copyright © 2018 Rene Van Meeuwen. All rights reserved.
//

#import "BoschViewController.h"
#import "BoschSceneOne.h"
#import "BoschSceneStart.h"
#import "BoschSt2.h"
#import "BoschGameOver.h"
#import "BoschSceneFour.h"


static const CGFloat kTrackPointsPerSecond = 1000;

static const wint_t category_fence      = 0x1 << 4;
static const wint_t category_eve        = 0x1 << 3;
static const wint_t category_adam       = 0x1 << 2;
static const wint_t category_bird2      = 0x1 << 1;
static const wint_t category_apple      = 0x1 << 0;

@interface BoschSceneFour () <SKPhysicsContactDelegate>

@property (nonatomic, strong, nullable) UITouch *motivatingTouch;
@property (strong, nonatomic)  NSMutableArray *birdFrames;
@property (assign, nonatomic) int birdsBusted;
@property (assign, nonatomic) int eveBusted;
@property (assign, nonatomic) BOOL busted10Birds;
@property (nonatomic, strong) UILabel *scoreLabel;
@property(readonly) int intValue;
@property NSUInteger score;
@property CGFloat shipHealth;


#define kScoreHudName @"scoreHud"
#define kHealthHudName @"healthHud"


@end

@implementation BoschSceneFour


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    self.birdsBusted = 0;
    self.busted10Birds = NO;
    

    self.name = @"Fence";
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = category_fence;
    self.physicsBody.collisionBitMask = 0x0;
    self.physicsBody.contactTestBitMask = 0x0;
    self.physicsWorld.contactDelegate = self;
    [self setupHud];
    
    
    SKSpriteNode *background = (SKSpriteNode *) [self childNodeWithName:@"Background"];
    background.zPosition = 0;
    background.lightingBitMask = 0x1;
    
    SKSpriteNode *appleTwo = (SKSpriteNode *) [self childNodeWithName:@"apple2"];
    appleTwo.name = @"apple2";
    
    appleTwo.physicsBody.dynamic = YES;
    appleTwo.position = CGPointMake(60, 30);
    appleTwo.physicsBody.friction = 0.0;
    appleTwo.physicsBody.restitution = 0.9;
    appleTwo.physicsBody.linearDamping = 0.5;
    appleTwo.physicsBody.angularDamping = 0.5;
    appleTwo.physicsBody.allowsRotation = YES;
    appleTwo.physicsBody.mass = 1;
    appleTwo.physicsBody.affectedByGravity = NO;
    appleTwo.physicsBody.velocity = CGVectorMake(200.0, 200.0);
    appleTwo.zPosition = 1;
    appleTwo.physicsBody.categoryBitMask = category_apple;
    appleTwo.physicsBody.collisionBitMask = category_fence | category_bird2 | category_apple | category_adam;
    appleTwo.physicsBody.contactTestBitMask = category_fence | category_bird2;
    appleTwo.physicsBody.usesPreciseCollisionDetection = YES;
    
    
    self.birdFrames = [NSMutableArray array];
    
    SKTextureAtlas *birdAni = [SKTextureAtlas atlasNamed:@"bird2.atlas"];
    unsigned long numImages = birdAni.textureNames.count;
    for (int i=0; i< numImages; i++) {
        NSString *textureName = [NSString stringWithFormat:@"bird2%02d", i];
        SKTexture *temp = [birdAni textureNamed:textureName];
        [self.birdFrames addObject:temp];
        
    }
    
    SKSpriteNode *bird2 = [SKSpriteNode spriteNodeWithTexture:self.birdFrames[0]];
    bird2.scale = 0.2;
    
    CGFloat kBlockWidth = bird2.size.width;
    CGFloat kBlockHorizSpace = 20.0f;
    int kBlocksPerRow = (self.size.width / (kBlockWidth+kBlockHorizSpace));
    
    //Top Row
    for (int i = 0; i < kBlocksPerRow; i++){
        bird2 = [SKSpriteNode spriteNodeWithTexture:self.birdFrames[0]];
        bird2.scale = 0.2;
        bird2.name = @"bird2";
        bird2.position = CGPointMake(kBlockHorizSpace/2 + kBlockWidth/2+ i*(kBlockWidth) + i*kBlockHorizSpace, self.size.height - 90);
        bird2.zPosition = 1;
        bird2.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:bird2.size.width/2];
        bird2.physicsBody.dynamic = NO;
        bird2.physicsBody.friction = 0.0;
        bird2.physicsBody.restitution = 1.0;
        bird2.physicsBody.linearDamping = 0.0;
        bird2.physicsBody.angularDamping = 0.0;
        bird2.physicsBody.allowsRotation = YES;
        bird2.physicsBody.mass = 1.0;
        bird2.physicsBody.velocity = CGVectorMake(0.0,0.0);
        bird2.zPosition = 1;
        bird2.physicsBody.categoryBitMask = category_bird2;
        bird2.physicsBody.collisionBitMask = 0x0;
        bird2.physicsBody.contactTestBitMask = category_apple;
        bird2.physicsBody.usesPreciseCollisionDetection = NO;
        bird2.lightingBitMask = 0x1;
        
        [self addChild:bird2];
        
    }
    
    //Second Row
    
    kBlocksPerRow = (self.size.width / (kBlockWidth+kBlockHorizSpace)) -1;
    
    for (int i = 0; i < kBlocksPerRow; i++){
        bird2 = [SKSpriteNode spriteNodeWithTexture:self.birdFrames[0]];
        bird2.scale = 0.2;
        bird2.name = @"bird2";
        bird2.position = CGPointMake(kBlockHorizSpace + kBlockWidth + i*(kBlockWidth) + i*kBlockHorizSpace, self.size.height - 80 - (2 * kBlockHorizSpace));
        bird2.zPosition = 1;
        bird2.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:bird2.size.width/2];
        bird2.physicsBody.dynamic = NO;
        bird2.physicsBody.friction = 0.0;
        bird2.physicsBody.restitution = 1.0;
        bird2.physicsBody.linearDamping = 0.0;
        bird2.physicsBody.angularDamping = 0.0;
        bird2.physicsBody.allowsRotation = YES;
        bird2.physicsBody.mass = 1.0;
        bird2.physicsBody.velocity = CGVectorMake(0.0,0.0);
        bird2.zPosition = 1;
        bird2.physicsBody.categoryBitMask = category_bird2;
        bird2.physicsBody.collisionBitMask = 0x0;
        bird2.physicsBody.contactTestBitMask = category_apple;
        bird2.physicsBody.usesPreciseCollisionDetection = NO;
        
        [self addChild:bird2];
        
    }
    
    //Bottom Row
    for (int i = 0; i < kBlocksPerRow; i++){
        bird2 = [SKSpriteNode spriteNodeWithTexture:self.birdFrames[0]];
        bird2.scale = 0.2;
        bird2.name = @"bird2";
        bird2.position = CGPointMake(kBlockHorizSpace/2 + kBlockWidth/2+ i*(kBlockWidth) + i*kBlockHorizSpace, self.size.height - 80 - (4 * kBlockHorizSpace));;
        bird2.zPosition = 1;
        bird2.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:bird2.size.width/2];
        bird2.physicsBody.dynamic = NO;
        bird2.physicsBody.friction = 0.0;
        bird2.physicsBody.restitution = 1.0;
        bird2.physicsBody.linearDamping = 0.0;
        bird2.physicsBody.angularDamping = 0.0;
        bird2.physicsBody.allowsRotation = YES;
        bird2.physicsBody.mass = 1.0;
        bird2.physicsBody.velocity = CGVectorMake(0.0,0.0);
        bird2.zPosition = 1;
        bird2.physicsBody.categoryBitMask = category_bird2;
        bird2.physicsBody.collisionBitMask = 0x0;
        bird2.physicsBody.contactTestBitMask = category_apple;
        bird2.physicsBody.usesPreciseCollisionDetection = NO;
        
        [self addChild:bird2];
        
    }
    
    
    SKSpriteNode *adam = [SKSpriteNode spriteNodeWithImageNamed:@"adam.png"];
    adam.name = @"adam";
    adam.xScale = 0.7;
    adam.yScale = 0.7;
    adam.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(adam.size.height , adam.size.width)];
    adam.physicsBody.dynamic = NO;
    adam.position = CGPointMake(self.size.width/2,30);
    adam.physicsBody.friction = 0.0;
    adam.physicsBody.restitution = 1.0;
    adam.physicsBody.linearDamping = 0.0;
    adam.physicsBody.angularDamping = 0.0;
    adam.physicsBody.allowsRotation = YES;
    adam.physicsBody.mass = 1.0;
    adam.physicsBody.velocity = CGVectorMake(0.0,0.0);
    adam.zPosition = 1;
    adam.physicsBody.categoryBitMask = category_adam;
    adam.physicsBody.collisionBitMask = 0x0;
    adam.physicsBody.contactTestBitMask = category_apple;
    adam.physicsBody.usesPreciseCollisionDetection = YES;
    adam.lightingBitMask = 0x1;
    self.shipHealth = 1.0f;
    
    [self addChild:adam];
    
    SKSpriteNode *eve2 = [SKSpriteNode spriteNodeWithImageNamed:@"eve"];
    eve2.name = @"eve2";
    eve2.xScale = 0.6;
    eve2.yScale = 0.6;
    eve2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(eve2.size.height, eve2.size.width)];
    eve2.physicsBody.dynamic = NO;
    eve2.zPosition = 1;
    eve2.physicsBody.categoryBitMask = category_eve;
    eve2.physicsBody.collisionBitMask = 0x0;
    eve2.physicsBody.contactTestBitMask = category_apple;
    eve2.physicsBody.usesPreciseCollisionDetection = YES;
    eve2.lightingBitMask = 0x1;
    

    
}

// Adam Functions

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    const CGRect touchRegion = (CGRectMake(0, 0, self.size.width, self.size.height * 0.3));
    
    for (UITouch *touch in touches){
        CGPoint p = [touch locationInNode:self];
        
        if (CGRectContainsPoint(touchRegion, p)){
            self.motivatingTouch = touch;
            
        }
        
    }
    [self trackAdamToMotivatingTouches];
    
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self trackAdamToMotivatingTouches];
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([touches containsObject:self.motivatingTouch])
        self.motivatingTouch = nil;
    
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([touches containsObject:self.motivatingTouch])
        self.motivatingTouch = nil;
}

-(void)trackAdamToMotivatingTouches{
    
    SKNode *node = [self childNodeWithName:@"adam"];
    UITouch *touch = self.motivatingTouch;
    if(!touch)
        return;
    
    CGFloat xPos = [touch locationInNode:self].x;
    NSTimeInterval duration = ABS(xPos - node.position.x) / kTrackPointsPerSecond;
    [node runAction:[SKAction moveToX:xPos duration:duration]];
}

// Score Functions

-(void)setupHud {
    SKLabelNode* scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    //1
    scoreLabel.name = kScoreHudName;
    scoreLabel.fontSize = 15;
    //2
    scoreLabel.fontColor = [SKColor whiteColor];
    scoreLabel.text = [NSString stringWithFormat:@"Score: %04u", 0];
    //3
    scoreLabel.position = CGPointMake(20 + scoreLabel.frame.size.width/2, self.size.height - (20 + scoreLabel.frame.size.height/2));
    [self addChild:scoreLabel];
    scoreLabel.zPosition = 2;
    
    SKLabelNode* healthLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    //4
    healthLabel.name = kHealthHudName;
    healthLabel.fontSize = 15;
    //5
    healthLabel.fontColor = [SKColor whiteColor];
    healthLabel.text = [NSString stringWithFormat:@"Health: %.1f%%", 100.0f];
    //6
    healthLabel.position = CGPointMake(self.size.width - healthLabel.frame.size.width/2 - 20, self.size.height - (20 + healthLabel.frame.size.height/2));
    [self addChild:healthLabel];
    healthLabel.zPosition = 2;
}

// Physics Functions

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    static  const int kMaxSpeed = 600;
    static  const int kMinSpeed = 300;
    
    SKNode *apple = [self childNodeWithName:@"apple2"];
    
    float dx = (apple.physicsBody.velocity.dx);
    float dy = (apple.physicsBody.velocity.dy);
    
    float speed = sqrt(dx*dx + dy*dy);
    if (speed > kMaxSpeed){
        apple.physicsBody.linearDamping += 0.1f;
    }
    else if (speed < kMinSpeed){
        apple.physicsBody.linearDamping -= 0.1f;
    }
    else {
        apple.physicsBody.linearDamping = 0.0f;
    }
    
    
}

#pragma mark - HUD Helpers

-(void)adjustScoreBy:(NSUInteger)points {
    self.score += points;
    SKLabelNode* score = (SKLabelNode*)[self childNodeWithName:kScoreHudName];
    score.text = [NSString stringWithFormat:@"Score: %04lu", (unsigned long)self.score];
}

-(void)adjustShipHealthBy:(CGFloat)healthAdjustment {
    //1
    self.shipHealth = MAX(self.shipHealth + healthAdjustment, 0);
    
    SKLabelNode* health = (SKLabelNode*)[self childNodeWithName:kHealthHudName];
    health.text = [NSString stringWithFormat:@"Health: %.1f%%", self.shipHealth * 100];
}


-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    NSString *nameA = contact.bodyA.node.name;
    NSString *nameB = contact.bodyB.node.name;
    
    
    
    if(([nameA containsString:@"bird2"] && [nameB containsString:@"apple"]) || ([nameA containsString:@"apple"] && [nameB containsString:@"bird2"])){
        
        
        
        
        self.birdsBusted++;
        if((self.birdsBusted >=10) && (self.busted10Birds== NO)){
            
            self.busted10Birds = YES;
            [self reportbusted10Birds];
            
            
            
        }
        
// Bird Functions
        
        SKNode *birdHit;
        if ([nameA containsString:@"bird2"]) {
            birdHit = contact.bodyA.node;
        }
        else{
            birdHit = contact.bodyB.node;
        }
        
        SKAction *birdAudio = [SKAction playSoundFileNamed:@"applehit.mp3" waitForCompletion:NO];
        SKAction *birdAnima = [SKAction animateWithTextures:self.birdFrames timePerFrame:0.04f resize:NO restore:NO];
        
        
        
        
        NSString *birdPartPath = [[NSBundle mainBundle] pathForResource:@"birdGone" ofType:@"sks"];
        
        SKEmitterNode *birdPart = [NSKeyedUnarchiver unarchiveObjectWithFile:birdPartPath];
        birdPart.position = CGPointMake(0,0);
        birdPart.zPosition = 0;
        
        
        
        SKAction *actionBirdPart = [SKAction runBlock:^{
            [birdHit addChild:birdPart];
        }];
        
        SKAction *actionRampSequence = [SKAction group:@[birdAudio,birdAnima,actionBirdPart]];
        
        
        SKAction *actionAudioExplode = [SKAction playSoundFileNamed:@"birdau.mp3" waitForCompletion:NO];
        
        
        NSString *poofPartPath = [[NSBundle mainBundle] pathForResource:@"poof" ofType:@"sks"];
        
        SKEmitterNode *poofPart = [NSKeyedUnarchiver unarchiveObjectWithFile:poofPartPath];
        poofPart.position = CGPointMake(0,0);
        poofPart.zPosition = 0;
        
        SKAction *actionPoofPart = [SKAction runBlock:^{
            [birdHit addChild:poofPart];
        }];
        
        
        SKAction *actionRemoveBird = [SKAction removeFromParent];
        
        
        SKAction *birdExplosionSequence = [SKAction sequence:@[actionAudioExplode,actionPoofPart,[SKAction fadeInWithDuration:1]]];
        
        
        SKAction *checkGameOver = [SKAction runBlock:^{
            BOOL anyBirdsRemaining = ([self childNodeWithName:@"bird2"] !=nil);
            if (!anyBirdsRemaining){
                SKView *skView = (SKView *)self.view;
                [self removeFromParent];
                
                [self reportScore:(self.birdsBusted*100 +self.eveBusted*1000)];
                
                BoschSt2 *scene = [BoschSt2 nodeWithFileNamed:@"BoschSt2"];
                scene.scaleMode = SKSceneScaleModeAspectFit;
                [skView presentScene:scene];
            };
        }];
        
        
        
        [birdHit runAction:[SKAction sequence:@[actionRampSequence,birdExplosionSequence,actionRemoveBird,checkGameOver]]];
        [self adjustScoreBy:100];
        
        
    }
    
    // Apple Functions
    
    else if(([nameA containsString:@"Fence"] && [nameB containsString:@"apple"]) || ([nameA containsString:@"apple"] && [nameB containsString:@"Fence"])){
        
        SKAction *fenceAudio = [SKAction playSoundFileNamed:@"applehit.mp3" waitForCompletion:NO];
        [self runAction:fenceAudio];
    }
    
    else if(([nameA containsString:@"adam"] && [nameB containsString:@"apple"]) || ([nameA containsString:@"apple"] && [nameB containsString:@"adam"])){
        
        SKAction *adamAudio = [SKAction playSoundFileNamed:@"adamau.mp3" waitForCompletion:NO];
        [self runAction:adamAudio];
    }
    
    else if(([nameA containsString:@"eve2"] && [nameB containsString:@"apple"]) || ([nameA containsString:@"apple"] && [nameB containsString:@"eve2"])){
        
        
        
        SKAction *eveAudio = [SKAction playSoundFileNamed:@"eveSigh.mp3" waitForCompletion:NO];
        [self runAction:eveAudio];
        [self adjustScoreBy:1000];
    }
    
    
    
    if(contact.contactPoint.y < 10){
        
        [self adjustShipHealthBy:-0.20f];
        if (self.shipHealth <= 0.0f) {
            //2
            SKView * skView = (SKView *)self.view;
            [self removeFromParent];
            
            BoschGameOver *scene = [BoschGameOver nodeWithFileNamed:@"BoschGameOver"];
            scene.scaleMode = SKSceneScaleModeAspectFit;
            [skView presentScene:scene];
            
            
        } else {
            //3
            //                      SKNode* ship = [self childNodeWithName:adam];
            //                      ship.alpha = self.shipHealth;
            //                      if (contact.bodyA.node == ship) [contact.bodyB.node removeFromParent];
            //                      else [contact.bodyA.node removeFromParent];
        }
        
        //                SKView * skView = (SKView *)self.view;
        //                [self removeFromParent];
        //
        //
        //                GameOver *scene = [GameOver nodeWithFileNamed:@"GameOver"];
        //                scene.scaleMode = SKSceneScaleModeAspectFill;
        //
        //                [skView presentScene:scene];
    }
}

// NSLog(@"what collided? %@ %@",nameA,nameB);

-(void)reportScore:(int)myScore{
    // TODO: Update Leaderboard
//    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:@"Highscore"];
//    score.value = myScore;
//
//    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error){
//        if(error !=nil){
//            NSLog(@"%@", [error localizedDescription]);
//        }
//    }];
}

//-(void)updateLeaderboardWithID:(NSString *)identifier score:(int64_t)score{
//    GKLeaderboard* leaderBoard = [[GKLeaderboard alloc]init];
//    leaderBoard.identifier = @"Highscore";
//    leaderBoard.timeScope = GKLeaderboardTimeScopeAllTime;
//    leaderBoard.range = NSMakeRange(1, 1);
//    [leaderBoard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^(void) {
//            GKScore *localScore = leaderBoard.localPlayerScore;
//            int64_t newValue = localScore.value + score;
//            localScore = [[GKScore alloc] initWithLeaderboardIdentifier:@"Highscore"];
//            localScore.value = newValue;
//            
//        }
//                       );
//    }];
//}


-(void)reportbustedBird{
    // TODO: Update Leaderboard
//    GKAchievement *scoreAchievement = [[GKAchievement alloc] initWithIdentifier:@"Busted_a_Bird"];
//    scoreAchievement.percentComplete = 100;
//    scoreAchievement.showsCompletionBanner = YES;
//    [GKAchievement reportAchievements:@[scoreAchievement] withCompletionHandler:^(NSError *error) {
//        if(error !=nil){
//            NSLog(@"%@", [error localizedDescription]);
//        }
//    }];
}

-(void)reportbusted10Birds{
    // TODO: Update Leaderboard
//    GKAchievement *scoreAchievement = [[GKAchievement alloc] initWithIdentifier:@"Busted_10_Birds"];
//    scoreAchievement.percentComplete = 100;
//    scoreAchievement.showsCompletionBanner = YES;
//    [GKAchievement reportAchievements:@[scoreAchievement] withCompletionHandler:^(NSError *error) {
//        if(error !=nil){
//            NSLog(@"%@", [error localizedDescription]);
//        }
//    }];
}



@end



