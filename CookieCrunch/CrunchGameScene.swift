//
//  GameScene.swift
//  CookieCrunch
//
//  Created by Razeware on 13/04/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import SpriteKit

class CrunchGameScene: SKScene {
  
  // MARK: Properties
  
  // This is marked as ! because it will not initially have a value, but pretty
  // soon after the GameScene is created it will be given a Level object, and
  // from then on it will always have one (it will never be nil again).
  var level: Level!
  
  let TileWidth: CGFloat = 32.0
  let TileHeight: CGFloat = 36.0
  
  let gameLayer = SKNode()
  let cookiesLayer = SKNode()
  let tilesLayer = SKNode()
  
  
  // MARK: Init
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder) is not used in this app")
  }
  
  override init(size: CGSize) {
    super.init(size: size)
    
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
    // Put an image on the background. Because the scene's anchorPoint is
    // (0.5, 0.5), the background image will always be centered on the screen.
    let background = SKSpriteNode(imageNamed: "Background")
    background.size = size
    addChild(background)
    
    // Add a new node that is the container for all other layers on the playing
    // field. This gameLayer is also centered in the screen.
    addChild(gameLayer)
    
    let layerPosition = CGPoint(
      x: -TileWidth * CGFloat(NumColumns) / 2,
      y: -TileHeight * CGFloat(NumRows) / 2)
    
    // The tiles layer represents the shape of the level. It contains a sprite
    // node for each square that is filled in.
    tilesLayer.position = layerPosition
    gameLayer.addChild(tilesLayer)
    
    // This layer holds the Cookie sprites. The positions of these sprites
    // are relative to the cookiesLayer's bottom-left corner.
    cookiesLayer.position = layerPosition
    gameLayer.addChild(cookiesLayer)
  }
  
  
  // MARK: Level Setup
  
  func addTiles() {
    for row in 0..<NumRows {
      for column in 0..<NumColumns {
        // If there is a tile at this position, then create a new tile
        // sprite and add it to the mask layer.
        if level.tileAt(column: column, row: row) != nil {
          let tileNode = SKSpriteNode(imageNamed: "Tile")
          tileNode.size = CGSize(width: TileWidth, height: TileHeight)
          tileNode.position = pointFor(column: column, row: row)
          tilesLayer.addChild(tileNode)
        }
      }
    }
  }
  
  func addSprites(for cookies: Set<Cookie>) {
    for cookie in cookies {
      // Create a new sprite for the cookie and add it to the cookiesLayer.
      let sprite = SKSpriteNode(imageNamed: cookie.cookieType.spriteName)
      sprite.size = CGSize(width: TileWidth, height: TileHeight)
      sprite.position = pointFor(column: cookie.column, row: cookie.row)
      cookiesLayer.addChild(sprite)
      cookie.sprite = sprite
    }
  }
  
  
  // MARK: Point conversion
  
  // Converts a column,row pair into a CGPoint that is relative to the cookieLayer.
  func pointFor(column: Int, row: Int) -> CGPoint {
    return CGPoint(
      x: CGFloat(column)*TileWidth + TileWidth/2,
      y: CGFloat(row)*TileHeight + TileHeight/2)
  }

}
