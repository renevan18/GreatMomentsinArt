//
//  BoschSt2.m
//  GMIA1
//
//  Created by Rene Van Meeuwen on 12/2/18.
//  Copyright © 2018 Rene Van Meeuwen. All rights reserved.
//

#import "BoschSt2.h"
#import "BoschSceneStart.h"
#import "BoschSceneOne.h"
#import "BoschSceneTwo.h"

@implementation BoschSt2



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if (touches) {
        SKView *skView = (SKView *)self.view;
        
        BoschSceneTwo *scene = [BoschSceneTwo nodeWithFileNamed:@"BoschSceneTwo"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        [skView presentScene:scene];
        
        
    }
}
@end
