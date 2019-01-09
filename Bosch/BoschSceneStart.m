//
//  BorschSceneOne.m
//  GMIA1
//
//  Created by Rene Van Meeuwen on 8/11/2016.
//  Copyright © 2016 Rene Van Meeuwen. All rights reserved.
//

#import "BoschSceneStart.h"
#import "BoschSceneOne.h"
#import "BoschSceneFour.h"

@implementation BoschSceneStart

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if (touches) {
        SKView *skView = (SKView *)self.view;
        
        BoschSceneFour *scene = [BoschSceneFour nodeWithFileNamed:@"BoschSceneFour"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        [skView presentScene:scene];
        
        
    }
}


@end
