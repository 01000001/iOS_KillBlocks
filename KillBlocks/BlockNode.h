//
//  BlockNode.h
//  KillBlocks
//
//  Created by Attila Csala on 12/5/13.
//  Copyright (c) 2013 Attila Csala. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BlockNode : SKSpriteNode

@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, assign) NSUInteger column;

// initialization method

-(BlockNode*) initWithRow:(NSUInteger)row
                andColumn:(NSUInteger)column
                withColor:(UIColor*)color
                  andSize:(CGSize)size;



@end
