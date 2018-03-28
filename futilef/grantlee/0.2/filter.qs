var Vector2 = function (x, y) {
	return { x: x, y: y };
};

var Rect = function (left, right, top, bottom) {
	return { left: left, right: right, top: top, bottom: bottom };
};

var jsonExport = function(tp) {
	var texture = tp.texture;
	var res = {};

	var frames = [];
	for (var i in texture.allSprites) {
		var sprite = texture.allSprites[i];
		var frame = {
			name: sprite.fullName,
			size: {
				x: sprite.untrimmedSize.width, 
				y: sprite.untrimmedSize.height,
			},
			pivot: {
				x: Math.round(sprite.pivotPoint.x + sprite.centerOffset.x),
				y: Math.round(sprite.untrimmedSize.height - sprite.pivotPoint.y + sprite.centerOffset.y),
			},
			// pivot: { x: sprite.pivotPoint.x, y: sprite.pivotPoint.x },
			// center: { x: sprite.centerOffset.x, y: sprite.centerOffset.y },
		};

		frame.quad = {
			left: sprite.sourceRect.x,
			right: sprite.sourceRect.x + sprite.sourceRect.width,
			top: sprite.untrimmedSize.height - (sprite.sourceRect.y),
			bottom: sprite.untrimmedSize.height - (sprite.sourceRect.y + sprite.sourceRect.height),
		};

		frame.quad.left -= frame.pivot.x;
		frame.quad.right -= frame.pivot.x;
		frame.quad.top -= frame.pivot.y;
		frame.quad.bottom -= frame.pivot.y;

		frame.rotated = sprite.rotated;
		frame.uv = {
			left: sprite.frameRect.x,
			right: (sprite.frameRect.x + sprite.frameRect.width),
			top: texture.size.height - sprite.frameRect.y,
			bottom: texture.size.height - (sprite.frameRect.y + sprite.frameRect.height),
		};

		frame.sliced = sprite.scale9Enabled;
		frame.border = {
			left: sprite.scale9Borders.x,
			right: sprite.untrimmedSize.width - (sprite.scale9Borders.x + sprite.scale9Borders.width),
			top: sprite.scale9Borders.y,
			bottom: sprite.untrimmedSize.height - (sprite.scale9Borders.y + sprite.scale9Borders.height),
		};

		frames.push(frame);
	}

	res.name = texture.fullName.replace(/\.bytes$/, '');
	res.size = { x: texture.size.width, y: texture.size.height };
	res.frames = frames;

	return tp.exporterProperties.prettyPrint ? JSON.stringify(res, null, '    ') : JSON.stringify(res);
};

jsonExport.filterName = 'jsonExport';

Library.addFilter('jsonExport');