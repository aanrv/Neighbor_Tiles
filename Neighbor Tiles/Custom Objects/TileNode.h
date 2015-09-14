//
//  TileNode.h
//  Pattern Matching
//
//  Created by Varan on 7/11/14.
//
//

#import <SpriteKit/SpriteKit.h>

/**
 * @enum TileState
 * Enumerated value [0,1] to represent current tile state (0 = TileStateBlack, 1 = TileStateWhite)
 */
typedef enum {
    TileStateBlack,
    TileStateWhite
} TileState ;

/**
 * @enum WhiteTileColor
 * Enumerated value [0,8] to represent current tile color.
 */
typedef enum {
    WhiteTileColorWhite,
    WhiteTileColorBlue,
    WhiteTileColorYellow,
    WhiteTileColorGreen,
    WhiteTileColorCyan,
    WhiteTileColorPurple,
    WhiteTileColorOrange,
    WhiteTileColorMagenta,
    WhiteTileColorRed
} WhiteTileColor;

@interface TileNode : SKSpriteNode

/**
 * @property currentState
 * Current state of tile (black or white)
 */
@property (nonatomic) TileState currentState;
/**
 * @property tileColor
 * Color of tile.
 */
@property (nonatomic) WhiteTileColor tileColor;

/**
 * @property correspondingColoredTileNames
 * Array of tiles and corresponding tile color image names. (WhiteTileColor used as index for array).
 */
@property (nonatomic) NSArray* correspondingColoredTileNames;
/**
 * @property whiteTileImageName
 * Image name of "white" tile (can be other colors besides white).
 */
@property (nonatomic) NSString* whiteTileImageName;
/**
 * @property whiteTileSelectedImageName
 * Image name of "white" tile when it selected.
 */
@property (nonatomic) NSString* whiteTileSelectedImageName;
/**
 * @property blackTileImageName
 * Image name of black tile.
 */
@property (nonatomic) NSString* blackTileImageName;
/**
 * @property blackTileSelectedImageName
 * Image name of black tile when it is selected.
 */
@property (nonatomic) NSString* blackTileSelectedImageName;

/**
 * @property row
 * Row of tile.
 */
@property (nonatomic) NSUInteger row;
/**
 * @property col
 * Column of tile.
 */
@property (nonatomic) NSUInteger col;

/**
 * @property isSelected
 * Indicates whether or not tile is selected.
 */
@property (nonatomic) BOOL isSelected;

/**
 * Initializer.
 * @param state Enumerated value indicating current state (0 -> black, 1 -> white)
 * @param color Enumerated value indicating current white tile color.
 * @param r Row of tile in grid.
 * @param c Column of tile in grid.
 * @param size Size of node.
 * @return TileNode instance type.
 */
- (instancetype) initWithState:(TileState) state
                whiteTileColor:(WhiteTileColor) color
                           row:(NSInteger) r
                           col:(NSInteger) c
                          size:(CGSize) size; 

/**
 * Toggles state of tile.
 */
- (void) toggleTileState;

/**
 * Sets tile to selected.
 */
- (void) setToSelected;
/**
 * Sets tile to default (deselected)
 */
- (void) setToDefault;

@end
