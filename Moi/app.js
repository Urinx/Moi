"use strict";

window.addEventListener('DOMContentLoaded', function(){
	var weather = document.querySelectorAll('div.weather');
	for (var i = 0; i < weather.length; i++) {
		var showup = (function(i){
			return function(){
				if (!weather[i].classList.contains('active')) {
					document.querySelector('.active').classList.remove('active');
					weather[i].classList.add('active');
				}
			};
		})(i);
		weather[i].addEventListener('touchend',showup);
		weather[i].addEventListener('touchmove',showup);
	};
});