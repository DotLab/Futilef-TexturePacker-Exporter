var base64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

var jsonExport = function(tp) {
	res = [];

	// name
	res.push(tp.texture.trimmedName);
	// size
	res.push(tp.texture.size.width);
	res.push(tp.texture.size.height);
	// length
	res.push(tp.texture.allSprites.length);

	for (var i in tp.texture.allSprites) {
		var sprite = tp.texture.allSprites[i];
		// name
		res.push(sprite.trimmedName);
		// rotated
		res.push(sprite.rotated);
		// size
		res.push(sprite.untrimmedSize.width);
		res.push(sprite.untrimmedSize.height);
		// pivot
		res.push(sprite.pivotPoint.x);
		res.push(sprite.pivotPoint.y);
		// quad
		res.push(sprite.sourceRect.x);
		res.push(sprite.sourceRect.y);
		res.push(sprite.sourceRect.width);
		res.push(sprite.sourceRect.height);
		// uv
		res.push(sprite.frameRect.x);
		res.push(sprite.frameRect.y);
		res.push(sprite.frameRect.width);
		res.push(sprite.frameRect.height);
		// border
		res.push(sprite.scale9Borders.x);
		res.push(sprite.scale9Borders.y);
		res.push(sprite.scale9Borders.width);
		res.push(sprite.scale9Borders.height);
	}

	var ints = res.map(function(x) {
		if (typeof(x) === 'number') return Math.round(x);
		if (typeof(x) === 'boolean') return parseInt(x ? 1 : 0);
		if (typeof(x) === 'string') return parseInt(x.replace(/[^0-9]/g, ''));
	})
	
	if (tp.exporterProperties.base64) {
		var bytes = ints.reduce(function(acc, cur) {
			if (typeof(cur) === 'number') {
				acc.push(cur       & 0xff);
				acc.push(cur >> 8  & 0xff);
				acc.push(cur >> 16 & 0xff);
				acc.push(cur >> 24 & 0xff);
			}
			return acc;
		}, []);
	
		var str = '';
		for (var i = 0, len = bytes.length; i < len; i += 3) {
			var b1 = bytes[i];
			var b2 = i + 1 < len ? bytes[i + 1] : 0;
			var b3 = i + 2 < len ? bytes[i + 2] : 0;
			var a1 = b1 >> 2 & 63;
			var a2 = ((b1 & 3) << 4 | (b2 >> 4 & 15)) & 63;
			var a3 = ((b2 & 15) << 2 | (b3 >> 6 & 3)) & 63;
			var a4 = b3 & 63;
			str += base64[a1];
			str += base64[a2];
			if (i + 1 < len) str += base64[a3];
			if (i + 2 < len) str += base64[a4];
		}

		return str;
	}

	return ints.join(',');
};

jsonExport.filterName = 'jsonExport';

Library.addFilter('jsonExport');