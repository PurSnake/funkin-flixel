package flixel.system;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class FlxBGSprite extends FlxSprite
{
	public function new()
	{
		super();
		// TODO: Use unique:false, now that we're not editing the pixels
		makeGraphic(1, 1, FlxColor.WHITE, true, FlxG.bitmap.getUniqueKey("bg_graphic_"));
		scrollFactor.set();
	}

	/**
	 * Called by game loop, updates then blits or renders current frame of animation to the screen
	 */
	@:access(flixel.FlxCamera)
	override public function draw():Void
	{
		checkEmptyFrame();
		if (alpha == 0.0 || _frame.type == flixel.graphics.frames.FlxFrame.FlxFrameType.EMPTY)
			return;

		if (dirty) // rarely
			calcFrame(useFramePixels);

		var _frame = frame;
		var sourceSize = _frame.sourceSize;
		for (camera in getCamerasLegacy())
		{
			if (!camera.visible || !camera.exists)
			{
				continue;
			}

			// _matrix.identity();
			_frame.prepareMatrix(_matrix, flixel.graphics.frames.FlxFrame.FlxFrameAngle.ANGLE_0, checkFlipX(), checkFlipY());

			camera.getViewMarginRect(_rect);

			_matrix.scale(_rect.width / frameWidth, _rect.height / frameHeight);
			_matrix.translate(_rect.x, _rect.y);
			_matrix.translate(-offset.x, -offset.y);

			camera.drawPixels(_frame, _matrix, colorTransform, blend, antialiasing, shader);

			#if FLX_DEBUG
			FlxBasic.visibleCount++;
			#end
		}
	}
}
