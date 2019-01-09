//
//  BoschSt3.m
//  GMIA1
//
//  Created by Rene Van Meeuwen on 14/2/18.
//  Copyright © 2018 Rene Van Meeuwen. All rights reserved.
//

#import "BoschSt3.h"
#import "BoschSceneStart.h"
#import "BoschSceneOne.h"
#import "BoschSceneTwo.h"
#import "BoschSceneThree.h"

@implementation BoschSt3

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if (touches) {
        SKView *skView = (SKView *)self.view;
        
        BoschSceneThree *scene = [BoschSceneThree nodeWithFileNamed:@"BoschSceneThree"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        [skView presentScene:scene];
        
        
    }
}


@end
