/**
*  Works with this box2d port:
*  http://code.google.com/p/box2dhx/
*  
**/
package;

import box2D.collision.shapes.B2Shape;
import box2D.collision.shapes.B2ShapeDef;
import box2D.collision.shapes.B2PolygonShape;
import box2D.collision.shapes.B2PolygonDef;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2World;

class PhysicsData {

	// ptm ratio
    public var ptm_ratio:Float;
	
	// the physics data 
	var dict:Hash<Array<Array<Dynamic>>>;
	
	//
    // bodytype:
    //  b2_staticBody
    //  b2_kinematicBody
    //  b2_dynamicBody
		
	public function createBody(name:String, world:B2World, userData:Dynamic):B2Body {

		var shapes:Array<Array<Dynamic>> = dict.get(name);
	
	    var body:B2Body;

	    // prepare body def
	    var bodyDef:B2BodyDef = new B2BodyDef();
	    bodyDef.userData = userData;

	    // create the body
	    body = world.CreateBody(bodyDef);

	    // prepare fixtures
	    for(f in 0...shapes.length) {

	    	var shape:Array<Dynamic> = shapes[f];

	        var polys:Array<Array<Array<Float>>> = shape[8];

			for(points in polys) {

				var shapeDef:B2PolygonDef = new B2PolygonDef();

	            shapeDef.density=shape[0];
	            shapeDef.friction=shape[1];
	            shapeDef.restitution=shape[2];

	            shapeDef.filter.categoryBits = shape[3];
	            shapeDef.filter.maskBits = shape[4];
	            shapeDef.filter.groupIndex = shape[5];
	            shapeDef.isSensor = shape[6];

				shapeDef.vertexCount = points.length;

				for(i in 0...points.length) {
					shapeDef.vertices[i].Set( points[i][0], points[i][1]);
				}

				body.CreateShape(shapeDef);

			}

        }

	   	return body;
	}
	
	public function new():Void {

			ptm_ratio = 30;

			dict = new Hash();


			dict.set("haxe",  [

									[
										// density, friction, restitution
	                                    2, 0, 0,
	                                    // categoryBits, maskBits, groupIndex, isSensor
										1, 65535, 0, false,
										'POLYGON',
											[

												[   [94.5/ptm_ratio, 125.5/ptm_ratio]  ,  [61.5/ptm_ratio, 110.5/ptm_ratio]  ,  [13.5/ptm_ratio, 63.5/ptm_ratio]  ,  [-0.5/ptm_ratio, 30.5/ptm_ratio]  ,  [63.5/ptm_ratio, 14.5/ptm_ratio]  ,  [110.5/ptm_ratio, 61.5/ptm_ratio]  ,  [124.5/ptm_ratio, 94.5/ptm_ratio]  ,  [124.5/ptm_ratio, 124.5/ptm_ratio]  ] ,
												[   [30.5/ptm_ratio, -0.5/ptm_ratio]  ,  [63.5/ptm_ratio, 14.5/ptm_ratio]  ,  [-0.5/ptm_ratio, 30.5/ptm_ratio]  ,  [0.5/ptm_ratio, -0.5/ptm_ratio]  ] ,
												[   [-0.5/ptm_ratio, 93.5/ptm_ratio]  ,  [13.5/ptm_ratio, 63.5/ptm_ratio]  ,  [61.5/ptm_ratio, 110.5/ptm_ratio]  ,  [28.5/ptm_ratio, 125.5/ptm_ratio]  ,  [-0.5/ptm_ratio, 123.5/ptm_ratio]  ] ,
												[   [124.5/ptm_ratio, 31.5/ptm_ratio]  ,  [110.5/ptm_ratio, 61.5/ptm_ratio]  ,  [63.5/ptm_ratio, 14.5/ptm_ratio]  ,  [92.5/ptm_ratio, -0.5/ptm_ratio]  ,  [124.5/ptm_ratio, 1.5/ptm_ratio]  ]

											]
									]

								] );

	}
	

		
}
