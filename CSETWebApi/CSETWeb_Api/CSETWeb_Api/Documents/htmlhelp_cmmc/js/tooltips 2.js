var constShowTimeout = 300;
var constHideTimeout = 750;
var ShowNum = 0;
var HideNum = 0;
var TShowTime = new Array();
var THideTime = new Array();
var Positioned = new Array();
var divRightPadding = 100;
var epsilon = 30;
var eventClientX, eventClientY, eventPageX, eventPageY;

function clearTooltipHideIfNecessary(objid) {
	if (HideNum == objid) {
		window.clearTimeout(THideTime[HideNum]);
		THideTime[HideNum] = null;
		HideNum = 0;
	}
}

function TMouseOverF(objid) {
	clearTooltipHideIfNecessary(objid);
}

function TMouseOutF(objid) {
	TooltipHide(objid);
}

function getAreaSize(el) {
	var curBrowser = getBrowserType();
	var area = new Object;
	if (curBrowser.indexOf('MSIE') != -1) {
		area.width = el.scrollWidth;
		area.height = el.scrollHeight;
	}

	if (curBrowser.indexOf('Nav6') != -1) {
		area.width = el.offsetWidth;
		area.height = el.offsetHeight;
	}

	if (curBrowser.indexOf('Opera') != -1) {
		area.width = el.offsetWidth;
		area.height = el.offsetHeight;
	}

	return area;
}

function getVisibleArea() {
	var curBrowser = getBrowserType();
	var visArea = new Object;
	if (curBrowser.indexOf('MSIE') != -1) {
		visArea.left = document.documentElement.scrollLeft;
		visArea.top = document.documentElement.scrollTop;
		visArea.width = document.documentElement.offsetWidth;
		visArea.height = document.documentElement.offsetHeight;
	}

	if (curBrowser.indexOf('Nav6') != -1) {
		visArea.left = document.documentElement.scrollLeft;
		visArea.top = document.documentElement.scrollTop;
		visArea.width = window.innerWidth;
		visArea.height = window.innerHeight;
	}

	if (curBrowser.indexOf('Opera') != -1) {
		visArea.left = document.body.scrollLeft;
		visArea.top = document.body.scrollTop;
		visArea.width = window.innerWidth;
		visArea.height = window.innerHeight;
	}

	visArea.right = visArea.left + visArea.width;
	visArea.bottom = visArea.top + visArea.height;

	return visArea;
}

document.showItem = function(objid) {
	var curobj = document.getElementById('Tooltip_' + objid);
	var x = -1;
	var dx = 20;
	var y = -1;
	var dy = 20;

	if (eventPageX) {
		x = eventPageX;
	} else if (eventClientX) {
		x = eventClientX + (document.documentElement.scrollLeft ? document.documentElement.scrollLeft : document.body.scrollLeft);
	} else {
		x = 0;
	}

	if (eventPageY) {
		y = eventPageY;
	} else if (eventClientY) {
		y = eventClientY + (document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop);
	} else {
		y = 0;
	}

	var isRtl = document.documentElement.getAttribute('dir') === 'rtl';

	var visArea = getVisibleArea();

	curobj.style.left = x + dx + 'px';
	curobj.style.right = 'auto';
	curobj.style.top = y + dy + 'px';
	curobj.style.display = 'block';

	var divArea = getAreaSize(curobj);

	if (isRtl) {
		divArea.right = x - dx;
		divArea.left = divArea.right - divArea.width;
	} else {
		divArea.left = x + dx;
		divArea.right = divArea.left + divArea.width;
	}

	divArea.top = y + dy;
	divArea.bottom = divArea.top + divArea.height;

	if (isRtl) {
		var extraL = visArea.left - divArea.left;
		if (extraL >= 0) {
			divArea.right += extraL + 10;
		}

		var extraR = divArea.right - visArea.right;
		if (extraR >= 0) {
			divArea.right -= extraR + 16;
		}
	} else {
		var extraR = divArea.right - visArea.right;
		if (extraR >= 0) {
			divArea.left -= extraR + 16;
		}
		var extraL = visArea.left - divArea.left;
		if (extraL >= 0) {
			divArea.left += extraL + 10;
		}
	}
	var extraB = divArea.bottom - visArea.bottom;
	if (extraB > 0) {
		divArea.top -= extraB + 16;
	}
	var extraT = visArea.top - divArea.top;
	if (extraT > 0) {
		divArea.top += extraT + 10;
	}

	var oTable = document.getElementById(curobj.id + 'table');
	oTable.style.width = $(curobj).width() + 'px';
	if (isRtl) {
		curobj.style.right = visArea.width - divArea.right + 'px';
		curobj.style.left = 'auto';
	} else {
		curobj.style.left = divArea.left + 'px';
		curobj.style.right = 'auto';
	}
	curobj.style.top = divArea.top + 'px';

	Positioned[objid] = true;
	TShowTime[objid] = null;
}

function ShowItem(event, objid) {
	eventClientX = event.clientX;
	eventClientY = event.clientY;
	eventPageX = event.pageX;
	eventPageY = event.pageY;

	document.showItem(objid);

	ShowNum = objid;
	THideTime[objid] = null;
}

function HideTooltipById(objid) {
	var curobj = document.getElementById("Tooltip_"+objid);
	curobj.style.display = "none";
	var oTable = document.getElementById(curobj.id + "table");
	oTable.style.width = "100%";
}

function TooltipShow(event, objid) {
	if (HideNum == objid) {
		window.clearTimeout(THideTime[HideNum]);
		THideTime[HideNum];
		HideNum = 0;
		return;
	}

	if (HideNum != 0) {
		var HideTimeout = THideTime[HideNum];
		window.clearTimeout(HideTimeout);
		HideTooltipById(HideNum);
		HideNum = 0;
		ShowItem(event, objid);
		return;
	}

	var ShowTimeout = null;
	if (ShowNum != 0)
		ShowTimeout = TShowTime[ShowNum];
	if (ShowTimeout != null) {
		window.clearTimeout(ShowTimeout);
		HideTooltipById(ShowNum);
		ShowItem(event, objid);
	} else {
		var TimeoutFunction = function(objid) {
			document.showItem(objid);
		};

		ShowNum = objid;
		eventClientX = event.clientX;
		eventClientY = event.clientY;
		eventPageX = event.pageX;
		eventPageY = event.pageY;
		TShowTime[objid] = window.setTimeout(function(){
			TimeoutFunction(objid);
		}, constShowTimeout);
	}
}

function TooltipHideTimed(objid, hideTimeout) {
	var ShowTimeout = null;
	if (ShowNum != 0)
		ShowTimeout = TShowTime[ShowNum];

	if (ShowTimeout != null && document.getElementById("Tooltip_"+ShowNum).style.display == "none") {
		window.clearTimeout(ShowTimeout);
		TShowTime[ShowNum] = null;
		ShowNum = 0;
		return;
	}

	var TimeoutFunction = function(objid) {
		HideTooltipById(objid);
		THideTime[objid] = null;
		HideNum = 0;
		ShowNum = 0;
	}

	THideTime[objid] = window.setTimeout(function(){
		TimeoutFunction(objid)
	}, hideTimeout);
	HideNum = objid;
}

function TooltipHide(objid) {
	TooltipHideTimed(objid, constHideTimeout);
}

function HideAndMove(objid) {
	TooltipHideTimed(objid, 0);
}

function getBrowserType() {
	var BODY_EL = (document.compatMode && document.compatMode != "BackCompat")?
	document.documentElement :
	document.body ? document.body : null;
	var user_Agent = navigator.userAgent.toLowerCase();
	var Agent_version = navigator.appVersion;
	var isOpera = !!(window.opera && document.getElementById);
	var isOpera6 = isOpera && !document.defaultView;
	var isOpera7 = isOpera && !isOpera6;
	var isMSIE = (user_Agent.indexOf("msie") != -1) && document.all && BODY_EL && !isOpera;
	var isMSIE6 = isMSIE && parseFloat(Agent_version.substring(Agent_version.indexOf("MSIE")+5)) >= 5.5;
	var isNN4 = (document.layers && typeof document.classes != "undefined");
	var isNN6 = (!isOpera && document.defaultView && typeof document.defaultView.getComputedStyle != "undefined");
	var isW3C_compatible = !isMSIE && !isNN6 && !isOpera && document.getElementById;
	if (isOpera6)return "Opera6";
	if (isOpera7)return "Opera7";
	if (isMSIE)return "MSIE";
	if (isMSIE6)return "MSIE6";
	if(isNN4)return "Nav4";
	if(isNN6)return "Nav6";
	if (isW3C_compatible) return "w3c";
	return null;
}

$(document).ready(function() {
	if (document.DrExplain_Make_Tooltips)
		return;
	if (!true)
		return;

	var wndImgs = $(".de_wndimg");

	if (!wndImgs || wndImgs.length == 0)
		return;

	wndImgs.prop("alt", "");

	$("area").each(function(){
		var curId = $(this).prop("href").substring($(this).prop("href").indexOf("#") + 1, $(this).prop("href").length);
		$(this).prop("id", "area_" + curId);
	});

	$(".de_ctrl").each(function(){
		var $anchors = $(this).find("a");
		if (!$anchors || $anchors.length < 2)
			return;
		var curId = $($anchors[0]).prop("id");
		if (curId == "top")
			return;
		var $curCtrlDiv = $(this);
		$("area[id=\"area_" + curId + "\"]").each(function(){
			$(this).mouseover(function(event) {
				TooltipShow(event, curId);
			});
			$(this).mouseout(function(event) {
				TooltipHide(curId);
			});
			$(this).click(function(event) {
				HideAndMove(curId);
			});

			var insertedDivs = $("div#Tooltip_" + curId);
			if (insertedDivs && insertedDivs.length == 1)
				return;

			var $curTooltip = $("<div></div>").append(
				$("<table></table>").append(
					$("<tr></tr>").append(
						$("<td></td>").append(
							$curCtrlDiv.clone()
						)
					)
				)
				.prop("id", "Tooltip_" + curId + "table")
				.addClass("b-tree__layout")
				.prop("cellSpacing", "0")
				.css({
					"border-style": "none",
					"width": "100%",
					"font-size": "10pt",
					"text-decoration": "none"
				})
			)
			.addClass("b-tree m-tree__contextMenu description_on_page cloned_node")
			.css({
				"position": "absolute",
				"display": "none",
				"z-index": "100"
			})
			.prop("id", "Tooltip_" + curId)
			.mouseover(function(event){TMouseOverF(curId);})
			.mouseout(function(event){TMouseOutF(curId);});

			//Remove [Top] links from divs
			$curTooltip.find(".topLinkRow").remove();
			$curTooltip.find(".de_ctrlbullet").remove();
			$curTooltip.find("p").each(function(){
				if ($(this).css("margin-left") == "50px")
					$(this).css("margin-left", "0px");
			});
			$("body").append($curTooltip);
		});
	});
	document.DrExplain_Make_Tooltips = "done";

	var app = DR_EXPLAIN;
	app.urlEncoder.doBindOpenNextPageWithEncodedStringToLinksInClonedNode();
});
