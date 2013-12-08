//
//  CSMyScene.m
//  KillBlocks
//
//  Created by Attila Csala on 12/3/13.
//  Copyright (c) 2013 Attila Csala. All rights reserved.
//

#import "CSMyScene.h"
#import "BlockNode.h"
#import "LeaderboardViewController.h"

#define COLUMNS         6
#define ROWS            6
#define MIN_BLOCK_BUST  2
#define LEVEL_TIME      05.0f

typedef enum {
    STOPPED,
    STARTING,
    PLAYING
} GameState;

@interface CSMyScene(){
    NSArray *_colors;
    
    SKLabelNode *_scoreLabel;
    SKLabelNode *_timerLabel;
    
    NSUInteger _score;
    
    GameState _gameState;
    CFTimeInterval _startedTime;
}

@end

@implementation CSMyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        // set up physics
        self.physicsWorld.gravity = CGVectorMake(0, -8.0f);
        
        _colors = @[[UIColor greenColor], [UIColor blueColor], [UIColor yellowColor], [UIColor purpleColor]];
        
        SKSpriteNode *floor = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(320, 40)];
        floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
        // floor.physicsBody.restitution = 0.f;
        floor.physicsBody.dynamic = FALSE;
        
        floor.position = CGPointMake(160, 20);
        [self addChild:floor];
        
        // initialize _scoreLabel
        _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        _scoreLabel.text = @"Score: 0";
        _scoreLabel.fontColor = [UIColor whiteColor];
        _scoreLabel.fontSize = 24.0f;
        _scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        _scoreLabel.position = CGPointMake(10, 10);
        
        [self.scene addChild:_scoreLabel];
        
        // initialize _timerLabel
        _timerLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        _timerLabel.text = @"Time: 0";
        _timerLabel.fontColor = [UIColor whiteColor];
        _timerLabel.fontSize = 24.0f;
        _timerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        _timerLabel.position = CGPointMake(310, 10);
        
        [self.scene addChild:_timerLabel];
        
        for (int row = 0; row < ROWS; row++) {
            for (int col= 0; col < COLUMNS; col++) {
                
                CGFloat dimension = 320 / COLUMNS;
                
                // array of colors
                
                NSUInteger colorIndex = arc4random() % _colors.count;
                
                // create block
                BlockNode *node = [[BlockNode alloc] initWithRow:row
                                                       andColumn:col
                                                       withColor:[_colors objectAtIndex:colorIndex]
                                                         andSize:CGSizeMake(dimension, dimension)];
                
                [self.scene addChild:node];
  
            }
        }


    }
    return self;
}

// method to get all the nodes on screne
-(NSArray*) getAllBlocks{
    
    NSMutableArray *blocks = [NSMutableArray array];
    
    for (SKNode *childNode in self.scene.children ) {
        
        if ([childNode isKindOfClass:[BlockNode class]]) {
           
            [blocks addObject:childNode];
        }
        
    }
    
    return [NSArray arrayWithArray:blocks];
    
}

- (BOOL) inRage:(BlockNode*)testNode of:(BlockNode*)baseNode{
    
    BOOL isRow = (baseNode.row == testNode.row);
    BOOL isCol = (baseNode.column == testNode.column);
    
    BOOL oneOfCol = (baseNode.column +1 == testNode.column || baseNode.column -1 == testNode.column);
    BOOL oneOfRow = (baseNode.row +1 == testNode.row || baseNode.row -1 == testNode.row);
    
    BOOL sameColor = [baseNode.color isEqual:testNode.color];
    
    
    return ( (isRow && oneOfCol) || (isCol && oneOfRow) ) && sameColor;
}

-(NSMutableArray*) nodesToRemove:(NSMutableArray*)removedNodes aroundNode:(BlockNode*)baseNode{
    
    
    [removedNodes addObject:baseNode];
    
    for (BlockNode *childNode in [self getAllBlocks]){
        
        if ([self inRage:childNode of:baseNode]){
            
            if (![removedNodes containsObject:childNode]) {
                removedNodes = [self nodesToRemove:removedNodes aroundNode:childNode];
            }
        }
    }
    
    return removedNodes;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node isKindOfClass:[BlockNode class]]) {
        
        BlockNode *clickBlock = (BlockNode*)node;
        
        NSLog(@"Node clicked: %@ ==> %d, %d" , clickBlock, clickBlock.row, clickBlock.column);
        
        NSMutableArray *objectsToRemove = [self nodesToRemove:[NSMutableArray array] aroundNode:clickBlock];
        
        if (objectsToRemove.count >=  MIN_BLOCK_BUST) {
            
            // set gamestate to start
            if (_gameState == STOPPED) {
                _gameState = STARTING;
            }
            
            for (BlockNode *deleteNode in objectsToRemove){
                [deleteNode removeFromParent];
                
                // update rows and columns
                for (BlockNode *testNode in [self getAllBlocks]){
                    if (deleteNode.column == testNode.column && (deleteNode.row < testNode.row)){
                        --testNode.row;
                        
                    }
                }
                
                ++_score;
                
                _scoreLabel.text = [NSString stringWithFormat:@"Score: %d", _score];
                
                
            }
            
            NSUInteger totalRows[COLUMNS];
            for (int i = 0; i < COLUMNS; i++){
                totalRows[i] = 0;
            }
            
            for (BlockNode *node in [self getAllBlocks]){
                if (node.row > totalRows[node.column]){
                    totalRows[node.column] = node.row;
                }
            }
            
            for (int col=0; col < COLUMNS; col++){
                NSLog(@"Rows[%d] = %d", col, totalRows[col]);
                
                while (totalRows[col] < ROWS - 1) {
                    
                        CGFloat dimension = 320 / COLUMNS;
                        
                        NSUInteger colorIndex = arc4random() % _colors.count;
                        
                        // create block
                        BlockNode *node = [[BlockNode alloc] initWithRow:totalRows[col]+1
                                                               andColumn:col
                                                               withColor:[_colors objectAtIndex:colorIndex]
                                                                 andSize:CGSizeMake(dimension, dimension) ];
                        
                        [self.scene addChild:node];
                        
                        ++totalRows[col];

                    
                
                }
            }
        }
    }
}

-(void)showLeaderboard{
    
    LeaderboardViewController *lvc = [[LeaderboardViewController alloc] init];
    
    lvc.bucket = [Kii bucketWithName:@"scores"];
    lvc.userScore = _score;
    
    
    KiiQuery *query = [KiiQuery queryWithClause:nil];
    [query sortByDesc:@"score"];
    [query setLimit:20];
    
    lvc.query = query;
    
    [self.parentViewController presentViewController:lvc animated:TRUE completion:nil];
    
    [lvc refreshQuery];
    
    
    // reset the score
    _score = 0;
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    [KTLoader showLoader:@"Uploading the score..."];
    
    // KiiObject is a json object, bucket is a container for the json object
    KiiObject *scoreObject = [[Kii bucketWithName:@"scores"]  createObject];
    [scoreObject setObject:[NSNumber numberWithInt:_score] forKey:@"score"];
    [scoreObject setObject:[KiiUser currentUser].username forKey:@"username"];
    
    // asynchronous call, uploading the object to the cloud and the block happens ones the object is uploaded
    [scoreObject saveWithBlock:^(KiiObject *object, NSError *error) {
        if (error == nil) {
            
            [KTLoader hideLoader]; 
            [self showLeaderboard];
            //[KTLoader showLoader:@"Score saved!" animated:TRUE withIndicator:KTLoaderIndicatorSuccess andHideInterval:KTLoaderDurationAuto];
        } else {
            [KTLoader showLoader:@"Error saving!" animated:TRUE withIndicator:KTLoaderIndicatorError andHideInterval:KTLoaderDurationAuto];
        }
    }];
    
}

-(void)gameEnded{
    _gameState = STOPPED;
    
    NSString *message = [NSString stringWithFormat:@"You scored %d this time", _score];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Game over!"
                                                 message:message delegate:self
                                       cancelButtonTitle:@"Ok"
                                       otherButtonTitles:nil];
    
    [av show];

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    if (_gameState == STARTING) {
        _startedTime = currentTime;
        _gameState = PLAYING;
    }
    
    if (_gameState == PLAYING) {
        int timeLeftRounded = ceil(LEVEL_TIME + ( _startedTime - currentTime ));
        _timerLabel.text = [NSString stringWithFormat:@"Time: %d", timeLeftRounded];
        
        if (timeLeftRounded == 0) {
            
            [self gameEnded];
        }
    }
    
    for (SKNode *node in self.scene.children) {
        
        node.position = CGPointMake(roundf(node.position.x), roundf(node.position.y));
    }
    
}

@end
