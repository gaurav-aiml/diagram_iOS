// Extension to BezierPath to draw custom arrow path

import UIKit

extension UIBezierPath {
    
    class func arrow3(points: [CGPoint], tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> (UIBezierPath, CGPoint, Bool) {
        var (lines, midPoint, isHorizontal) = find_lines(points: points)
        
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        func signOf(_ num: CGFloat) -> CGFloat{ return num < 0 ? -1 : 1}
        var finalPoints1 = [CGPoint]()
        var finalPoints2 = [CGPoint]()
        finalPoints1.append(points[0])
        for (idx,line) in lines.enumerated(){
            let start = line[0]	
            let end = line[1]
            
            let dx = start.x - end.x
            let dy = start.y - end.y
            
            var nextLine = [CGPoint]()
            var nextEnd: CGPoint!
            var nextStart: CGPoint!
            var ddx: CGFloat!
            var ddy: CGFloat!
            
            if idx != lines.count - 1 {
                nextLine = lines[idx + 1]
                nextEnd = nextLine[1]
                nextStart = nextLine[0]
                ddx = end.x - nextEnd.x
                ddy = end.y - nextEnd.y
                
            }
            
            
            if idx == 0 && idx != lines.count - 1 {
                //print("start")
                if dx == 0{
                    finalPoints1.append(p(start.x + signOf(dy) * tailWidth, start.y))
                    finalPoints2.append(p(start.x - signOf(dy) * tailWidth, start.y))
                    finalPoints1.append(p(end.x + signOf(dy) * tailWidth, end.y - signOf(ddx)*tailWidth))
                    finalPoints2.append(p(end.x - signOf(dy) * tailWidth, end.y + signOf(ddx)*tailWidth))
                }
                
                if dy == 0{
                    finalPoints1.append(p(start.x, start.y - signOf(dx) * tailWidth))
                    finalPoints2.append(p(start.x, start.y + signOf(dx) * tailWidth))
                    finalPoints1.append(p(end.x + signOf(ddy)*tailWidth, end.y - signOf(dx) * tailWidth))
                    finalPoints2.append(p(end.x - signOf(ddy)*tailWidth, end.y + signOf(dx) * tailWidth))
                }
            }
            else if idx == 0 && idx == lines.count - 1{
                //print("only one line")
                if dx == 0{
                    finalPoints1.append(p(start.x + signOf(dy) * tailWidth, start.y))
                    finalPoints2.append(p(start.x - signOf(dy) * tailWidth, start.y))
                    finalPoints1.append(p(end.x + signOf(dy)*tailWidth, end.y + signOf(dy)*headLength))
                    finalPoints2.append(p(end.x - signOf(dy)*tailWidth, end.y + signOf(dy)*headLength))
                    finalPoints1.append(p(end.x + signOf(dy)*(tailWidth+headWidth), end.y + signOf(dy)*headLength))
                    finalPoints2.append(p(end.x - signOf(dy)*(tailWidth+headWidth), end.y + signOf(dy)*headLength))
                }
                
                if dy == 0{
                    finalPoints1.append(p(start.x, start.y - signOf(dx) * tailWidth))
                    finalPoints2.append(p(start.x, start.y + signOf(dx) * tailWidth))
                    finalPoints1.append(p(end.x + signOf(dx)*headLength, end.y - signOf(dx)*tailWidth))
                    finalPoints2.append(p(end.x + signOf(dx)*headLength, end.y + signOf(dx)*tailWidth))
                    finalPoints1.append(p(end.x + signOf(dx)*headLength, end.y - signOf(dx)*(tailWidth+headWidth)))
                    finalPoints2.append(p(end.x + signOf(dx)*headLength, end.y + signOf(dx)*(tailWidth+headWidth)))
                }
            }
            else if idx < lines.count - 1{
                //print("middle")
                if dx == 0{
                    //            finalPoints1.append(p(start.x + signOf(dy) * tailWidth, start.y - signOf(dy)*tailWidth))
                    //            finalPoints2.append(p(start.x - signOf(dy) * tailWidth, start.y + signOf(dy)*tailWidth))
                    finalPoints1.append(p(end.x + signOf(dy) * tailWidth, end.y - signOf(ddx)*tailWidth))
                    finalPoints2.append(p(end.x - signOf(dy) * tailWidth, end.y + signOf(ddx)*tailWidth))
                }
                
                if dy == 0{
                    //            finalPoints1.append(p(start.x + signOf(dx)*tailWidth, start.y - signOf(dx) * tailWidth))
                    //            finalPoints2.append(p(start.x - signOf(dx)*tailWidth, start.y + signOf(dx) * tailWidth))
                    finalPoints1.append(p(end.x + signOf(ddy)*tailWidth, end.y - signOf(dx) * tailWidth))
                    finalPoints2.append(p(end.x - signOf(ddy)*tailWidth, end.y + signOf(dx) * tailWidth))
                }
            }
            else{
                //print("end")
                if dx == 0{
                    //            finalPoints1.append(p(line[0].x + signOf(dy)*tailWidth, line[0].y))
                    //            finalPoints2.append(p(line[0].x - signOf(dy)*tailWidth, line[0].y))
                    finalPoints1.append(p(end.x + signOf(dy)*tailWidth, end.y + signOf(dy)*headLength))
                    finalPoints2.append(p(end.x - signOf(dy)*tailWidth, end.y + signOf(dy)*headLength))
                    finalPoints1.append(p(end.x + signOf(dy)*(tailWidth+headWidth), end.y + signOf(dy)*headLength))
                    finalPoints2.append(p(end.x - signOf(dy)*(tailWidth+headWidth), end.y + signOf(dy)*headLength))
                }
                
                if dy == 0{
                    //            finalPoints1.append(p(line[0].x, line[0].y - signOf(dx)*tailWidth))
                    //            finalPoints2.append(p(line[0].x, line[0].y + signOf(dx)*tailWidth))
                    finalPoints1.append(p(end.x + signOf(dx)*headLength, end.y - signOf(dx)*tailWidth))
                    finalPoints2.append(p(end.x + signOf(dx)*headLength, end.y + signOf(dx)*tailWidth))
                    finalPoints1.append(p(end.x + signOf(dx)*headLength, end.y - signOf(dx)*(tailWidth+headWidth)))
                    finalPoints2.append(p(end.x + signOf(dx)*headLength, end.y + signOf(dx)*(tailWidth+headWidth)))
                }
            }
            
            
            //    if dx == 0{
            //        finalPoints1.append(p(start.x + signOf(dy) * tailWidth, start.y))
            //        finalPoints2.append(p(start.x - signOf(dy) * tailWidth, start.y))
            //        finalPoints1.append(p(end.x + signOf(dy) * tailWidth, end.y))
            //        finalPoints2.append(p(end.x - signOf(dy) * tailWidth, end.y))
            //    }
            //
            //    if dy == 0{
            //        finalPoints1.append(p(start.x, start.y - signOf(dx) * tailWidth))
            //        finalPoints2.append(p(start.x, start.y + signOf(dx) * tailWidth))
            //        finalPoints1.append(p(end.x, end.y - signOf(dx) * tailWidth))
            //        finalPoints2.append(p(end.x, end.y + signOf(dx) * tailWidth))
            //    }
        }
        finalPoints2.append(points[points.count - 1])
        finalPoints2.reverse()
        finalPoints1.append(contentsOf: finalPoints2)
        
        
        
        //        let length = hypot(end.x - start.x, end.y - start.y)
        //        let tailLength = length - headLength
        //
        //        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        //        let points: [CGPoint] = [
        //            p(0, tailWidth / 2),
        //            p(tailLength, tailWidth / 2),
        //            p(tailLength, headWidth / 2),
        //            p(length, 0),
        //            p(tailLength, -headWidth / 2),
        //            p(tailLength, -tailWidth / 2),
        //            p(0, -tailWidth / 2)
        //        ]
        //
        //        let cosine = (end.x - start.x) / length
        //        let sine = (end.y - start.y) / length
        //        let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)
        //
        let path = CGMutablePath()
        path.addLines(between: finalPoints1)
        path.closeSubpath()
        return (self.init(cgPath: path), midPoint, isHorizontal)
    }
    
}

private func find_lines(points: [CGPoint]) -> ([[CGPoint]], CGPoint, Bool){
    var lines = [[CGPoint]]()
    var prev : CGPoint?
    var start: CGPoint?
    var end: CGPoint?
    var horizontal = false
    var vertical = false
    var midPoint: CGPoint!
    var isHorizontal: Bool!
    
    for point in points{
        if prev == nil{
            prev = point
            start = point
            end = point
            continue
        }
        
        if point.x == prev?.x && point.y == prev?.y{
            continue
        }
        if point.x == prev?.x && horizontal == false{
            if vertical == true{
                //print("took horizontal")
                end = prev
                lines.append([start!,end!])
                start = prev
            }
            horizontal = true
            //            end = point
            prev = point
            vertical = false
            continue
        }
        if point.y == prev?.y && vertical == false{
            if horizontal == true{
                //print("took vertical")
                end = prev
                lines.append([start!,end!])
                start = prev
            }
            vertical = true
            //            end = point
            prev = point
            horizontal = false
            continue
        }
        if point.x == prev?.x && horizontal == true{
            
        }
        prev = point
    }
    if lines.count == 0{
        lines.append([points[0],points[points.count-1]])
    }else{
        lines.append([start!,points[points.count - 1]])
    }
    
    if lines.count == 1 //|| lines.count % 2 == 0
    {
        midPoint = CGPoint(x: (lines[0][0].x + lines[0][1].x)/2, y: (lines[0][0].y + lines[0][1].y)/2)
        isHorizontal = lines[0][0].x == lines[0][1].x ? false : true
    }
    else{
        let num = lines.count/2
        midPoint = CGPoint(x: (lines[num][0].x + lines[num][1].x)/2, y: (lines[num][0].y + lines[num][1].y)/2)
        isHorizontal = lines[num][0].x == lines[num][1].x ? false : true
    }
    
    return (lines, midPoint, isHorizontal)
}
