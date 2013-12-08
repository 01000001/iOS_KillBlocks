//
//  BlockNode.m
//  KillBlocks
//
//  Created by Attila Csala on 12/5/13.
//  Copyright (c) 2013 Attila Csala. All rights reserved.
//

#import "BlockNode.h"

@implementation BlockNode

-(BlockNode*) initWithRow:(NSUInteger)row
                andColumn:(NSUInteger)column
                withColor:(UIColor*)color
                  andSize:(CGSize)size{
    
    self = [super initWithColor:color size:size];
    
    if (self) {
        
        _row = row;
        _column = column;
        
        // make sure gravity effects block, give blocks a phisics body with the size of itself
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(size.width - 2, size.height - 2)];
        self.physicsBody.restitution = 0.f;
        self.physicsBody.allowsRotation = FALSE;
        
        // lining up the blocks horizontally so they are all sitting next to each other on the screen
        CGFloat xPosition = (size.width / 2) + _column * size.width ;
        CGFloat yPosition = 400 + ( (size.height / 2) +  _row * size.height  );
        
        // add block to our scene
        self.position = CGPointMake(xPosition, yPosition);
        
    }
    
    return self;
    
}

@end
