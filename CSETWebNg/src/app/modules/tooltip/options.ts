export const defaultOptions = {
	'placement': 'top',
	'autoPlacement': true,
	'contentType': 'string',
	'showDelay': 0,
	'hideDelay': 300,
	'hideDelayMobile': 0,
	'hideDelayTouchscreen': 0,
	'zIndex': 0,
	'animationDuration': 300,
	'animationDurationDefault': 300,
	'trigger': 'hover',
	'tooltipClass': '',
	'display': true,
	'displayMobile': true,
	'displayTouchscreen': true,
	'shadow': true,
	'theme': 'dark',
	'offset': 8,
	'maxWidth': '',
	'id': false,
	'hideDelayAfterClick': 2000
}

export const backwardCompatibilityOptions:any = {
    'delay': 'showDelay',
    'show-delay': 'showDelay',
    'hide-delay': 'hideDelay',
    'hide-delay-mobile': 'hideDelayTouchscreen',
    'hideDelayMobile': 'hideDelayTouchscreen',
    'z-index': 'zIndex',
    'animation-duration': 'animationDuration',
    'animation-duration-default': 'animationDurationDefault',
    'tooltip-class': 'tooltipClass',
    'display-mobile': 'displayTouchscreen',
    'displayMobile': 'displayTouchscreen',
    'max-width': 'maxWidth'
}