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

			quad: {
				x: sprite.sourceRect.x,
				y: sprite.sourceRect.y,
				w: sprite.sourceRect.width,
				h: sprite.sourceRect.height,
			},

			rotated: sprite.rotated,
			uv: {
				x: sprite.frameRect.x,
				y: sprite.frameRect.y,
				w: sprite.frameRect.width,
				h: sprite.frameRect.height,
			},

			sliced: sprite.scale9Enabled,
			border: {
				x: sprite.scale9Borders.x,
				y: sprite.scale9Borders.y,
				w: sprite.scale9Borders.width,
				h: sprite.scale9Borders.height,
			},
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