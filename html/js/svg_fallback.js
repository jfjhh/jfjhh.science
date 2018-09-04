/**
 * Updates image src attributes from SVG to PNG images if the browser does not
 * suport SVG images.
 *
 * Copyright (c) 2017 Alex Striff.
 * This code is licensed under the MIT License.
 */

document.addEventListener("DOMContentLoaded", function() {
	if (!Modernizr.svgasimg) {
		for (img of document.getElementsByTagName("img")) {
			img.src = img.src.replace(/\.svg$/, "_fallback.png");
		}
	}
});

