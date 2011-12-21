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

			ptm_ratio = {{global.ptm_ratio}};

			dict = new Hash();

{% for body in bodies %}
			dict.set("{{body.name}}",  [
{% for fixture in body.fixtures %}{% if not forloop.first %} ,{% endif %}
									[
										// density, friction, restitution
	                                    {{fixture.density}}, {{fixture.friction}}, {{fixture.restitution}},
	                                    // categoryBits, maskBits, groupIndex, isSensor
										{{fixture.filter_categoryBits}}, {{fixture.filter_maskBits}}, {{fixture.filter_groupIndex}}, {% if fixture.isSensor %}true{% else %}false{% endif %},
										'{{fixture.type}}',
											[
{% for polygon in fixture.polygons %}{% if not forloop.first %} ,{% endif %}
												[ {% for point in polygon %} {% if not forloop.first %}, {% endif %} [{{point.x}}/ptm_ratio, {{point.y}}/ptm_ratio] {% endfor %} ]{% endfor %}

											]
									]
{% endfor %}
								] );
{% endfor %}
	}
	

		
}
