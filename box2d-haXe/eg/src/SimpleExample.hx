
import box2D.collision.B2AABB;
import box2D.collision.shapes.B2PolygonDef;
import box2D.collision.shapes.B2Shape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2DebugDraw;	
import box2D.dynamics.B2World;
import box2D.dynamics.B2BodyDef;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;

class SimpleExample {
	
	var canvas:Sprite;
	var logo:Logo;
	var logoBody:B2Body;
	
	var world:B2World;
	
	var scale:Float;
	var iterations:Int;
	var timeStep:Null<Float>;
	
	function new() {
		
		flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE; 
		
		canvas = flash.Lib.current;
		logo = new Logo();
		canvas.addChild(logo);
		
		scale = 30.;
		iterations = 30;
		
		var initAABB = new B2AABB();
		initAABB.lowerBound.Set(-1000 / scale, -1000 / scale);
		initAABB.upperBound.Set(1000/ scale, 1000 / scale);
		var initGravity = new B2Vec2(0, 40);
		timeStep = 1 / 50;
		
		world = new B2World(initAABB, initGravity, true);
		
		var dbgDraw = new B2DebugDraw();
		dbgDraw.m_sprite = canvas;
		dbgDraw.m_fillAlpha = .3;
		dbgDraw.m_lineThickness = 1;
		dbgDraw.m_xformScale = 1;
		dbgDraw.m_drawScale = scale;
		dbgDraw.m_drawFlags = B2DebugDraw.e_shapeBit | B2DebugDraw.e_jointBit  | B2DebugDraw.e_centerOfMassBit;
		
		world.SetDebugDraw(dbgDraw);
		
		//use the generated PhysicsEditor file
		var dat = new PhysicsData();
		//create the logo body
		logoBody = dat.createBody("haxe", world, {});
		//logoBody.m_linearVelocity.x = 10;
		logoBody.SetXForm(new B2Vec2(5,3),0);
		logoBody.SetMassFromShapes();
		
		//create a floor
		var floorBodyDef = new B2BodyDef();
		floorBodyDef.position.Set(8.5, 13);
		var floorPolyDef = new B2PolygonDef();
		floorPolyDef.SetAsBox(8.5, 0.5);
		floorPolyDef.friction=0.3;
		floorPolyDef.density=0;
		var	floor= world.CreateBody(floorBodyDef);
		floor.CreateShape(floorPolyDef);
		floor.SetMassFromShapes();
			
		//create game loop
		canvas.addEventListener(Event.ENTER_FRAME, loop);
		
	}
	
	function loop(e) {
		
		world.Step( 1/30, iterations );
		
		sync(logo, logoBody);
		
	}
	
	inline function sync( gfx:DisplayObject, body:B2Body ) {
		
		var position:B2Vec2 = body.GetPosition();
		var gfx = cast gfx;
		gfx.x = position.x * scale;            
		gfx.y = position.y * scale;
		gfx.rotation = body.GetXForm().R.GetAngle() * 180 / Math.PI;
		
	}
	
	static function main() {
		
		new SimpleExample();
		
	}

}

class Logo extends Sprite {
	
	public function new() {
		super();
		
		var loader = new flash.display.Loader();
	   	loader.load (new flash.net.URLRequest ("haxe.png"));
		addChild(loader);
	   
	}
}
