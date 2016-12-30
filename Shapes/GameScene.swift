/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import SpriteKit

class GameScene: SKScene {
  
  let colors = [SKColor.yellow, SKColor.red, SKColor.blue, SKColor.purple]
  let player = SKShapeNode(circleOfRadius: 40)
  
  struct PhysicsCategory {
    static let Player: UInt32 = 1
    static let Obstacle: UInt32 = 2
    static let Edge: UInt32 = 4
  }
  
  override func didMove(to view: SKView) {
    setupPlayerAndObstacles()
    
    let playerBody = SKPhysicsBody(circleOfRadius: 30)
    playerBody.mass = 1.5
    playerBody.categoryBitMask = PhysicsCategory.Player
    playerBody.collisionBitMask = 4
    player.physicsBody = playerBody
    
    let ledge = SKNode()
    ledge.position = CGPoint(x: size.width/2, y: 160)
    let ledgeBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 10))
    ledgeBody.isDynamic = false
    ledgeBody.categoryBitMask = PhysicsCategory.Edge
    ledge.physicsBody = ledgeBody
    addChild(ledge)
    
    // control the sink
    physicsWorld.gravity.dy = -22
  }
  
  func setupPlayerAndObstacles() {
    addObstacle()
    addPlayer()
  }
  
  func addPlayer() {
    player.fillColor = .blue
    player.strokeColor = player.fillColor
    player.position = CGPoint(x: size.width/2, y: 200)
    
    addChild(player)
  }
  
  func addObstacle() {
    addCircleObstacle()
  }
  
  func addCircleObstacle() {
    // 1
    let path = UIBezierPath()
    // 2
    path.move(to: CGPoint(x: 0, y: -200))
    // 3
    path.addLine(to: CGPoint(x: 0, y: -160))
    // 4
    path.addArc(withCenter: CGPoint.zero,
                radius: 160,
                startAngle: CGFloat(3.0 * M_PI_2),
                endAngle: CGFloat(0),
                clockwise: true)
    // 5
    path.addLine(to: CGPoint(x: 200, y: 0))
    path.addArc(withCenter: CGPoint.zero,
                radius: 200,
                startAngle: CGFloat(0),
                endAngle: CGFloat(3.0 * M_PI_2),
                clockwise: false)
    
    let obstacle = obstacleByDuplicatingPath(path, clockwise: true)
    obstacle.position = CGPoint(x: size.width/2, y: size.height/2)
    addChild(obstacle)
    
    let rotateAction = SKAction.rotate(byAngle: 2.0 * CGFloat(M_PI), duration: 8.0)
    obstacle.run(SKAction.repeatForever(rotateAction))
//    let section = SKShapeNode(path: path.cgPath)
//    section.position = CGPoint(x: size.width/2, y: size.height/2)
//    section.fillColor = .yellow
//    section.strokeColor = .yellow
//    addChild(section)
//    
//    let section2 = SKShapeNode(path: path.cgPath)
//    section2.position = CGPoint(x: size.width/2, y: size.height/2)
//    section2.fillColor = .red
//    section2.strokeColor = .red
//    section2.zRotation = CGFloat(M_PI_2)
//    addChild(section2)
  }
  
  func obstacleByDuplicatingPath(_ path: UIBezierPath, clockwise: Bool) -> SKNode {
    let container = SKNode()
    
    var rotationFactor = CGFloat(M_PI_2)
    if !clockwise {
      rotationFactor *= -1
    }
    
    for i in 0...3 {
      let section = SKShapeNode(path: path.cgPath)
      section.fillColor = colors[i]
      section.strokeColor = colors[i]
      section.zRotation = rotationFactor * CGFloat(i)
      
      container.addChild(section)
    }
    
    return container
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // control the jump
    player.physicsBody?.velocity.dy = 800.0
  }
}
