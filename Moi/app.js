"use strict";

function $(el){
    return document.querySelector(el);
}
function $$(el){
    return document.querySelectorAll(el);
}

window.addEventListener('DOMContentLoaded', function(){
	var weather = $$('div.weather'),
        nowHour = new Date().getHours(),
        i = 0;

    // Morning 5-11
    // Day 11-18
    // Evening 18-22
    // Night 22-5
    if (nowHour >= 5 && nowHour < 11) {
        i = 0;
    }
    else if (nowHour >=11 && nowHour < 18) {
        i = 1;
    }
    else if (nowHour >=18 && nowHour < 22) {
        i = 2;
    }
    else {
        i = 3;
    }
    weather[i].classList.add('active');

	for (var i = 0; i < weather.length; i++) {
		var showup = (function(i){
			return function(){
				if (!weather[i].classList.contains('active')) {
					$('.active').classList.remove('active');
					weather[i].classList.add('active');
				}
			};
		})(i);
		weather[i].addEventListener('touchend',showup);
		weather[i].addEventListener('touchmove',showup);
	};
});

function setCity(city, country){
    $('.address').textContent = city+', '+country;
}

function setWeather(degrees, text, direction, speed, humidity){
    // text = [
    //      'Fair', 'Clear', 'Sunny', 'Mostly Sunny', 'Scattered Thunderstorms'
    //      'Partly Cloudy', 'PM Showers', 'AM Showers', 'PM Thunderstorms'
    //      'AM Fog/PM Sun', 'AM Clouds/PM Sun', 'Light Rain'
    //      ]
    direction = parseInt(direction);
    speed = parseInt(speed);
    text = text.split(' ').pop();
    var Direct = ['N','NE','E','SE','S','SW','W','NW'],
        h = new Date().getHours(),
        state = (h >= 19 || h < 5) ?'moon':'sun';

    if (['Fair','Clear','Sunny'].indexOf(text) > -1) {
        $('.active .icon').innerHTML = '<i class="'+state+'"></i>';
    }
    else if (['Cloudy','Fog'].indexOf(text) > -1) {
        $('.active .icon').innerHTML = '<i class="'+state+'"></i><i class="cloud"></i>';
    }
    else if (['Rain','Showers','Thunderstorms'].indexOf(text) > -1) {
        $('.active .icon').innerHTML = '<i class="cloud"></i><i class="sprinkles"></i><i class="sprinkles"></i><i class="sprinkles"></i><i class="sprinkles"></i>';
    }
    else if (['Snow'].indexOf(text) > -1) {
        $('.active .icon').innerHTML = '<i class="'+state+'"></i><i class="cloud"></i><div class="snowflakes"><i class="snowflake"></i><i class="snowflake"></i><i class="snowflake"></i><i class="snowflake"></i></div>';
    }
    else {
        $('.active .icon').innerHTML = '<i class="cloud"></i>';
    }
        
    $('.active .content .degrees').textContent = degrees;
    $('.active .content .data h2').textContent = text;
    $$('.active .content .data div')[0].textContent = 'Wind: '+Direct[ Math.floor(((direction+22.5)%360)/45) ]+' '+speed+' mph';
    $$('.active .content .data div')[1].textContent = 'Humidity: '+humidity+'%';
}