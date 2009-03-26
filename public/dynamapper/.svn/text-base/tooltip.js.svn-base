/**
 * @author Marco Alionso Ramirez, marco@onemarco.com
 */

var IS_IE = false;
var IS_LT_IE7;
//@cc_on IS_IE = true;
//@cc_on IS_LT_IE7 = @_jscript_version < 5.7;

/**
 * @param {Object} e A JSON Object literal representing a DOM node and optionally,
 * its children
 * @return {HTMLElement}
 */
function jsonToDom(e){
	if(null != e.txt) return document.createTextNode(e.txt);
	if(null == e.el) return null;
	var node = document.createElement(e.el.toUpperCase());
	if(null != e.att){
		for(var i in e.att){
			if(IS_IE){		
				node = applyAttribute(node,i,e.att[i]);
			}else{
				applyAttribute(node,i,e.att[i]);
			}
		}
	}
	if(null != e.ch){
		for(var j in e.ch){
			var childNode = jsonToDom(e.ch[j]);
			if(null !== childNode) node.appendChild(childNode);
		}
	}
	return node;
}

/**
 * @param {HTMLElement} node
 * @param {string} attribute
 * @param {string} value
 * @return {HTMLElement}
 */
function applyAttribute(node,attribute,value){
	if(IS_IE){
		return ieApplyAttribute(node,attribute,value);
	}else{
		node.setAttribute(attribute,value);
	}	
}

/**
 * @param {HTMLElement} node
 * @param {String} attribute
 * @param {String} value
 * @return {HTMLElement}
 */
function ieApplyAttribute(node,attribute,value){
	switch(attribute.toLowerCase()){
		case 'for':
			node.htmlFor = value;
			break;
		case 'class':
			node.className = value;
			break;
		case 'style':
			node.style.textCss = value;
			break;
		case 'name':
			node = document.createElement(node.outerHTML.replace(">"," name=" + value + ">"));
			break;
		default:
			node.setAttribute(attribute,value);
	}
	return node;
}

/**
 * @param {HTMLElement} element
 * @param {String} className
 */
function addClassToElement(element, className){
	if((new RegExp('\\b' + className + '\\b')).test(element.className)) return;
	element.className += ' ' + className;
}

/**
 * @param {HTMLElement} element
 * @param {String} className
 */
function removeClassFromElement(element, className){
	element.className = element.className.replace(
		new RegExp('(\\W+)?\\b' + className + '\\b(\\W+)?','g'),' ');
}

/**
 * @param {HTMLElement} node
 */
function clearChildren(node){
	while(node.childNodes.length > 0){
		node.removeChild(node.childNodes[0]);
	}
}

/**
 * @param {Object} args
 */
function argsToArray(args){
	var ret = [];
	for(var i = 0; i < args.length; i++){
		ret.push(args[i]);
	}
	return ret;
}

/**
 * @param {Object} evt
 */
function standardizeEvent(evt){
	if(!evt) evt = window.event;
	if(evt.srcElement) evt.target = evt.srcElement;
	if(!evt.stopPropagation) evt.stopPropagation = function(){this.cancelBubble = true};
	if(!evt.preventDefault) evt.preventDefault = function(){this.returnValue = false;};
	return evt;
}

function createPngElement(src){
	var img = document.createElement('img');
	img.setAttribute('src',src);	
	if(IS_IE && IS_LT_IE7){
		img.style.visibility = 'hidden';
		var div = document.createElement('div');
		div.appendChild(img);
		div.style.filter = 'progid:DXImageTransform.Microsoft.AlphaImageLoader(src=\'' + src + '\',sizingMethod=\'crop\')';
		return div;
	}
	return img;	
}

/**
 * @constructor
 * @param {GMarker} marker
 * @param {String} content
 * @param {Number} padding
 */
function Tooltip(marker, content, padding){
	this.marker = marker;
	this.content = content;
	this.padding = padding;
	this.div = null;
	this.map = null;
}

Tooltip.prototype = new GOverlay();

Tooltip.prototype.initialize = function(map){
	
	this.div = document.createElement("div");
	var innerContainer = this.div.cloneNode(false);
	this.div.appendChild(innerContainer);
	this.div.style.position = 'absolute';
	this.div.style.visibility = 'hidden';
	
	this.shadowQuadrants = [{},{},{},{}]
	this.shadowQuadrants[0].div = document.createElement('div');
	this.shadowQuadrants[0].div.style.position = 'absolute';	
	this.shadowQuadrants[0].div.style.overflow = 'hidden';
	this.shadowQuadrants[0].img = createPngElement('/images/dynamap/tooltip_shadow.png');
	this.shadowQuadrants[0].img.style.position = 'absolute';
	this.shadowQuadrants[0].div.appendChild(this.shadowQuadrants[0].img);
	this.shadowQuadrants[1].div = this.shadowQuadrants[0].div.cloneNode(false);
	this.shadowQuadrants[1].img = this.shadowQuadrants[0].img.cloneNode(true);
	this.shadowQuadrants[1].div.appendChild(this.shadowQuadrants[1].img);
	this.shadowQuadrants[2].div = this.shadowQuadrants[0].div.cloneNode(false);
	this.shadowQuadrants[2].img = this.shadowQuadrants[0].img.cloneNode(true);
	this.shadowQuadrants[2].div.appendChild(this.shadowQuadrants[2].img);
	this.shadowQuadrants[3].div = this.shadowQuadrants[0].div.cloneNode(false);
	this.shadowQuadrants[3].img = this.shadowQuadrants[0].img.cloneNode(true);
	this.shadowQuadrants[3].div.appendChild(this.shadowQuadrants[3].img);
	
	this.shadowQuadrants[0].div.style.right = '0px';	
	this.shadowQuadrants[0].div.style.top = '0px';
	this.shadowQuadrants[0].img.style.top = '0px';
	this.shadowQuadrants[0].img.style.right = '0px';
	this.shadowQuadrants[1].div.style.left = '0px';
	this.shadowQuadrants[1].div.style.top = '0px';
	this.shadowQuadrants[1].img.style.top = '0px';
	this.shadowQuadrants[2].div.style.left = '0px';
	this.shadowQuadrants[2].div.style.bottom = '0px';
	this.shadowQuadrants[2].img.style.bottom = '0px';
	this.shadowQuadrants[2].img.style.left = '0px';
	this.shadowQuadrants[3].div.style.right = '0px';
	this.shadowQuadrants[3].div.style.bottom = '0px';
	this.shadowQuadrants[3].img.style.bottom = '0px';	
	
	this.shadow = this.div.cloneNode(false);
	this.shadow.appendChild(this.shadowQuadrants[0].div);
	this.shadow.appendChild(this.shadowQuadrants[1].div);
	this.shadow.appendChild(this.shadowQuadrants[2].div);
	this.shadow.appendChild(this.shadowQuadrants[3].div);
	
	innerContainer.className = 'tooltip';
	
	var child = typeof this.content == 'string' ? 
		document.createTextNode(this.content) :
		this.content;
	innerContainer.appendChild(child);
	map.getPane(G_MAP_FLOAT_PANE).appendChild(this.div);
	map.getPane(G_MAP_MARKER_SHADOW_PANE).appendChild(this.shadow);
	this.map = map;
}

Tooltip.prototype.remove = function(){
	this.div.parentNode.removeChild(this.div);
}

Tooltip.prototype.copy = function(){
	var content = typeof this.content == 'string' ? this.content : this.content.cloneNode(true);
	return new Tooltip(this.marker,content,this.padding);
}

Tooltip.prototype.redraw = function(force){
	if (!force) return;
	
	//draw tooltip
	var markerPos = this.map.fromLatLngToDivPixel(this.marker.getPoint());
	var iconAnchor = this.marker.getIcon().iconAnchor;
	var xPos = Math.round(markerPos.x - this.div.clientWidth / 2);
	var yPos = markerPos.y - iconAnchor.y - this.div.clientHeight - this.padding;
	this.div.style.top = yPos + 'px';
	this.div.style.left = xPos + 'px';
	
	//draw shadow
	//calculate shadow location
	shadowAnchor = new GPoint(
		markerPos.x + Math.round((this.marker.getIcon().iconSize.height + this.padding) / 2) ,
		markerPos.y - Math.round((this.marker.getIcon().iconSize.height + this.padding) / 2) + 4);
	
	//calculate shadow dimenstions
	var shadowSize = new GSize(this.div.clientWidth + Math.round(this.div.clientHeight / 2) + 8,
		Math.round(this.div.clientHeight / 2) + 10);
	if(shadowSize.width % 2 == 1) shadowSize.width--;
	if(shadowSize.height % 2 == 1) shadowSize.height--;
	
	//apply shodaw location and dimensions
	this.shadow.style.left = (shadowAnchor.x - (shadowSize.width - shadowSize.height - 10 )/ 2) + 'px';
	this.shadow.style.top = (shadowAnchor.y - shadowSize.height) + 'px';
	this.shadow.style.width = (shadowSize.width) + 'px';
	this.shadow.style.height =  shadowSize.height + 'px';	
	
	//get quadrant dimensions
	var qHeight = shadowSize.height / 2;
	var qOddWidth = shadowSize.height > shadowSize.width ?
		shadowSize.height / 2:
		(shadowSize.width) / 2;
	var qEvenWidth = shadowSize.width - qOddWidth;
	
	//apply quadrant dimensions, calculate and apply Q2 and Q4 image offsets
	this.shadowQuadrants[0].div.style.width = qOddWidth + 'px';
	this.shadowQuadrants[0].div.style.height = qHeight + 'px';
	
	this.shadowQuadrants[1].div.style.width = qEvenWidth + 'px';
	this.shadowQuadrants[1].div.style.height = qHeight + 'px';
	this.shadowQuadrants[1].img.style.left = -(160 - shadowSize.height) + 'px';
	
	this.shadowQuadrants[2].div.style.width = qOddWidth + 'px';
	this.shadowQuadrants[2].div.style.height = qHeight + 'px';
	
	this.shadowQuadrants[3].div.style.width = qEvenWidth + 'px';
	this.shadowQuadrants[3].div.style.height = qHeight + 'px';
	this.shadowQuadrants[3].img.style.right = -(160 - shadowSize.height) +'px';	
}

Tooltip.prototype.show = function(){
	this.div.style.visibility = 'visible';
	this.shadow.style.visibility = 'visible';
}

Tooltip.prototype.hide = function(){
	this.div.style.visibility = 'hidden';
	this.shadow.style.visibility = 'hidden';
}

//utility function for png compatibility in IE6
var IS_IE = false;
var IS_LT_IE7;
//@cc_on IS_IE = true;
//@cc_on IS_LT_IE7 = @_jscript_version < 5.7;

function createPngElement(src){
	var img = document.createElement('img');
	img.setAttribute('src',src);	
	if(IS_IE && IS_LT_IE7){
		img.style.visibility = 'hidden';
		var div = document.createElement('div');
		div.appendChild(img);
		div.style.filter = 'progid:DXImageTransform.Microsoft.AlphaImageLoader(src=\'' + src + '\',sizingMethod=\'crop\')';
		return div;
	}
	return img;	
}
