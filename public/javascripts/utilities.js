var XML_read = false;
var xmlDoc ;
var evenodd = true;
//alert("loading utilities.js");

function gup( name ) {
  var regexS = "[\\?&]"+name+"=([^&#]*)";
  var regex = new RegExp( regexS );
  var tmpURL = window.location.href;
  var results = regex.exec( tmpURL );
  if( results == null ) { return ""; } else { return results[1]; }
}

function apply_search_filter(mode,term) {
  location.href = "/?search="+term+"&m="+gup("m");
}

// SETTING AND GETTING COOKIES
function setCookie(name, value, expires, path, domain, secure) {
  var path = "/";
  var curCookie = name + "=" + escape(value) +
      ((expires) ? "; expires=" + expires.toGMTString() : "") +
      ((path) ? "; path=" + path : "") +
      ((domain) ? "; domain=" + domain : "") +
      ((secure) ? "; secure" : "");
  document.cookie = curCookie;  
  //alert("setting cookie " + name + " " + value);
}

/*
  name - name of the desired cookie
  return string containing value of specified cookie or null
  if cookie does not exist
*/

function getCookie(name) {
  var dc = document.cookie;
  var prefix = name + "=";
  var begin = dc.indexOf("; " + prefix);
  if (begin == -1) {
    begin = dc.indexOf(prefix);
    if (begin != 0) return null;
  } else
    begin += 2;
  var end = document.cookie.indexOf(";", begin);
  if (end == -1)
    end = dc.length;
    //alert("getting cookie " + name + " " + unescape(dc.substring(begin + prefix.length, end)));
  return unescape(dc.substring(begin + prefix.length, end));
}

// END COOKIES

// Swapping divs

function showDiv(object) { object = document.getElementById(object);	if(!object) return;	object.style.display='block';	 object.style.visibility='visible';	}	
function hideDiv(object) {	object = document.getElementById(object);	if(!object) return;	object.style.visibility='hidden';	object.style.display='none';	}

function hideMultipleDivs(divs) {
var tbs = divs.split('|'); 
for (var j=0; j<tbs.length; j ++) { 	
hideDiv(tbs[j]); 
removeClass(tbs[j].replace("-div","-tab"),"selected"); //assumes tab named like div 
} 
} 

function set_tab_selected (tabname, classname) {
	var tab = document.getElementById(tabname);
	if (tab) tab.setAttribute("class", classname);
}

function removeClass(objname, classnm) {
	var obj=document.getElementById(objname);
	if (!obj) return ;
	var clss = obj.className;
	if (clss) obj.className = clss.replace(classnm,"");
}

// END of Swapping divs



//Image swapping utilities 
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

// END of Image swapping utilities


// RELATIVE OVERLAY


function setLyr(obj,lyr, xoff, yoff)
{
	//lyr needs to have style "position: absolute;"
	var coors = findPos(obj);
	coors[1] += yoff;
	coors[0] += xoff;
	var x = document.getElementById(lyr);
	x.style.top = coors[1] + 'px';
	x.style.left = coors[0] + 'px';
	//alert("x = " + coors[0] + " y=" + coors[1] );
}

function findPos(objname)
{
	var obj = document.getElementById(objname);
	var curleft = curtop = 0;
	if (obj.offsetParent) {
		curleft = obj.offsetLeft
		curtop = obj.offsetTop
		while (obj = obj.offsetParent) {
			curleft += obj.offsetLeft
			curtop += obj.offsetTop
		}
	}
	return [curleft,curtop];
}
//END OF RELATIVE OVERLAY

function getElementsByClassName(node,searchClass,tag) {
  var classElements = new Array();
  var els = node.getElementsByTagName(tag);
  var elsLen = els.length;
  //alert(elsLen);
  var pattern = new RegExp("\b"+searchClass+"\b");
  for (i = 0, j = 0; i < elsLen; i++) {
  	//if ( pattern.test(els[i].className) ) { // tests for inclusion in multiple classes
	if ( els[i].className == searchClass ) {
      classElements[j] = els[i];
      j++;
    }
  }
return classElements;
}
/* var cards = getElementsByClassName(document, "card-image", "div");for (var i=0; i<cards.length; i++) {cards[i].innerHTML = 'foo';}*/


function getElementsByClass(searchClass,tagType, testType, startDiv) {
	//testType = 0 => exact match, =1 => contains
  var classElements = new Array();
  var startObj = document;
  if (startDiv && startDiv != document) startObj = document.getElementById(startDiv);
  //if (tagType == 'a') alert(startDiv + " " + startObj);
  if (startObj) {
	  var els = startObj.getElementsByTagName(tagType);
	  var elsLen = els.length;
	  //if (tagType == 'a') alert(elsLen);
	  var pattern = new RegExp("\b"+searchClass+"\b");
	  for (i = 0, j = 0; i < elsLen; i++) {
	  	//if ( pattern.test(els[i].className) ) { // tests for inclusion in multiple classes
		match = (!testType || testType == 0) && els[i].className == searchClass;
		match = match || (testType == 1) && els[i].className.indexOf(searchClass) >= 0;
		if (match ) {
	      classElements[j] = els[i];
	      j++;
	    }
	  }
  }
return classElements;
}

function getLinksByHref(searchHref) {
  var Elements = new Array();
  var els = document.getElementsByTagName("a");
  var elsLen = els.length;
  //alert(elsLen);
  var pattern = new RegExp("\b"+searchHref+"\b");
  //alert(pattern);
  for (i = 0, j = 0; i < elsLen; i++) {
  	//if ( pattern.test(els[i].className) ) { // tests for inclusion in multiple classes
	//if ( els[i].href.indexOf(searchHref) >= 0 ) 
	//alert (els[i].href);
	if ( els[i].href.indexOf(searchHref) >=0 ) {
      Elements[j] = els[i];
      j++;
    } 
  }
return Elements;
}

function Beneficiary(nickname, displayname, guidestar, ein, website, logo, groups) 
{ this.nickname = nickname;
  //this.matchstringname = matchstringname;
  //this.domainname = domainname;
  this.displayname = displayname;
  this.guidestar = guidestar;
  this.ein = ein;
  this.website = website;
  this.logo = logo;
  this.groups = groups;
}

function importXML(file)
{
	if (document.implementation && document.implementation.createDocument)
	{
		xmlDoc = document.implementation.createDocument("", "", null);
		xmlDoc.onload = notify_done;
		
	}
	else if (window.ActiveXObject)
	{
		xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		//alert(xmlDoc);
		xmlDoc.onreadystatechange = function () {
			if (xmlDoc.readyState == 4) notify_done();
		};
 	}
	else
	{
		alert('Your browser can\'t handle this script');
		return;
	}
	//alert("loading" + file);
	xmlDoc.load(file);
}

function notify_done() {
	XML_read = true;
//alert("notify" + XML_read);
}

var lastone = "";
function Salesforce_Acct(obj) 
{ 
	fls = "Account_Name|Tax_ID|Guidestar|BuyBlue|MerchantCategory|ROVR_Beneficiary_Groups|Website|MerchantLogo|Logo|MerchantLink|Name|BillingStreet|BillingCity|BusinessCategoriesSub|BusinessDistrict|AM_rebate_percentage";
	fld_array = fls.split("|");
	for (m=0; m<fld_array.length; m++) {
		var foo = fld_array[m];
		//alert(foo);
		this[foo] = getAccountField(obj, foo);
		
	}

	//alert(this.Account_Name);
	this.Nickname = this.Account_Name.toLowerCase().replace(/ /g, "");
	
	this.Type = "merchant";
	
	if (this.ROVR_beneficiary_groups) {
		this.ROVR_beneficiary_groups = this.ROVR_beneficiary_groups.toLowerCase().replace(/ /g, "");
		this.Type = "beneficiary";
	}
	
	if (this.Website) {
		var value = this.Website.replace(/http:\/\//,"");
		value = value.replace(/www./, "");
		//stored minus "http://www."
		this.Website = "http://www." + value;
	}

	if (!this.Logo) this.Logo = this.MerchantLogo;

	if (this.MerchantLink) {
		//Merchants have special link that creates a commission session. Use it for the linked name, and extract the URL from it as the Website
		this.LinkedName = this.MerchantLink; // link with name and affiliate code embedded
		//extract the url from the link string, for later use
		var regexp=/(https:\/\/|http:\/\/|ftp:\/\/|www.)([^"]*)/gi ;
		var this_url = this.MerchantLink.match(regexp);
		if (this_url && this_url[0]) this.Website = this_url[0];
	}
		
	this.LinkedName = '<a href="' + this.Website + '" target="_blank">' + this.Account_Name + '</a>';
	this.NameLink = '<a href="' + this.Website + '" target="_blank">' + this.Name + '</a>'; //PSCC name link uses a different named field
//alert( this.Name + " | " + this.Website + " | " + this.NameLink);
	this.LinkedLogo = '<a href="' + this.Website + '" target="_blank"><img src="' + this.MerchantLogo + '" border=0/></a>';
	this.SiteName = this.Website.replace("http://", "");
	this.SiteName = this.SiteName.replace("www.", "");
	this.SiteNameLinked = '<a href="' + this.Website + '" target="_blank">' + this.SiteName + '</a>';
	this.NameAndSite = this.Name + " " + this.SiteNameLinked;

	this.BusinessCategoriesSub = this.BusinessCategoriesSub.replace(/;/g," ; ");
	lastone = this.Name;
	var padded = PadDigits(this.AM_rebate_percentage,3);
	this.AM_formatted_offer='<span style="visibility: hidden; display: none;">' + padded + "</span>" ;
	this.AM_formatted_offer += formatBusinessOffering(obj) ;
	ndone += 1;
}

function formatBusinessOffering (entry) {
	  	var percent = entry.getAttribute("AM_rebate_percentage");
		if (percent) percent=percent.substring(0, percent.indexOf("."));
		var minimum = entry.getAttribute("AM_minimum_purchase");
		var maximum = entry.getAttribute("AM_maximum_rebate");
		var fixed_rebate = entry.getAttribute("AM_fixed_rebate");
		var other_promotions = entry.getAttribute("AM_other_promotions");
		var out = "";
		if (percent) {
			out = percent + "% rebate";
			if (minimum && parseInt(minimum) > 0) out += " on a minimum purchase of $" + dollarize(minimum);
			else if (minimum && parseInt(minimum) <= 0) out += " on all purchases";
			if (maximum) out += ", to a maximum of $" + dollarize(maximum) + " total rebate.";
			else out += ".";
			}
		if (fixed_rebate) out = "$" + dollarize(fixed_rebate) + " rebate for each transaction.";
		if (other_promotions) out += " " + other_promotions;
		//entry.setAttribute("AM_formatted_offer", out);
		//return entry;
		return out;
		}
	
  function dollarize(str) {
  	var val = parseFloat(str);
	if (isNaN(val)) return str; // not a number
	var out = val + "";
	if (out.indexOf(".") >0) out = out.substring(0,out.indexOf("."));
	/*
	var decindx = out.indexOf(".");
  	if (decindx == -1) out += ".00";
	else if (decindx == (out.length -2)) out += "0";
	else if (decindx == (out.length -1)) out += "00";
	else out = out.substring(0,decindx+3);
	*/
	//alert(str + " " + out);

	return out;
	}
	
	
	var ndone=0;
	function PadDigits(n, totalDigits) 
    {  //pads zeros for a total of totalDigits left of the decimal

		if (n.indexOf("&nbsp;") >= 0) return "000";
        //n = n.toString(); 
		var dec = n.indexOf(".");
		var right = "";
		if (dec >= 0) {
			right = n.substring(dec);
			n = n.substring(0, dec);
		}
		//alert("PadDigits: n.length=" + n.length + " total=" + totalDigits + " n = " + n + " " + (totalDigits-n.length) + " counter= " + ndone + "  acct=" + lastone);
        var pd = ''; 

            for (var i=0; i < (totalDigits-n.length); i++) 
            { 
                pd += '0'; 
            } 
		//if (ndone <20) alert(pd + n.toString() + right);
        return pd + n.toString() + right; 
    } 


function getAccountField (obj, fieldname) {
	value = obj.getElementsByTagName(fieldname);
	//if (first) alert("getAccountField: field = " + fieldname + " val=" + value + "|");
	if (value[0]) {
		cntnts = value[0].textContent;  // Firefox
		if (!cntnts) cntnts = value[0].text; // IE
		value = cntnts;
		}
	else value="&nbsp;";	
	if (!value || value=="&nbsp;") value = obj.getAttribute(fieldname);
	if (!value || value.length <1 || value == "<none>") value="&nbsp;";
	return value;
}

function zebra_table_new(objects,headers,fields) {

	// parses the objects, writes out one <tr></tr> for each, with one <td> </td> for each field listed
	// headers forms the thead. headers and fields need to be the same length
       if (!headers || !fields || !objects) return;
//alert("zebra: " + objects + " " + objects[0].typeof);
	    x = '';
		hdrs = headers.split("|");
		flds = fields.split("|");
		var current_status = evenodd; evenodd=true;
		x=x+ '<thead><tr>'
		for (i=0;i<hdrs.length;i++) {
			hdr= hdrs[i];
			if (hdr != "Details" || special ) x=x+ '<th><a href="#" class="sortheader" onclick="ts_resortTable(this);return false;">' + hdr + '<span class="sortarrow"></span></a></th>'
		}
		x=x+ '</tr></thead><tbody>'

		for (i=0; i<objects.length; i++) {
			obj = objects[i];
			//alert(getAccountField(obj,"Account_Name"));
			//if (i == 0) alert(obj);
			var acct = new Salesforce_Acct(obj);
			
			// check if filtered
			//alert (group);
			if (group && group.toLowerCase() != "all") { //filter by group
				grps = acct.ROVR_Beneficiary_Groups;
				if (!grps || grps.indexOf(group.toLowerCase()) < 0) {
					//alert (grps + " | " +  grps.indexOf(group) );
					continue;
					}
			}
			//objtyp = obj.class.to_s
			evenodd = !evenodd;  
			if (evenodd) x=x+ '<tr class="evenrow">'; 
			else x=x+ '<tr class="oddrow">';
			//x = x+ "<td>" + acct + "</td>";
			for (j=0; j<flds.length; j++) { 
				fld = flds[j];
				x=x+ '<td valign="top">';
							
				x=x + acct[fld];
				x=x+ '</td>';
				
			}
			x=x+ '</tr>'
		}
		x=x+ '</tbody>';
		evenodd = current_status ;

		return x;
    }
		
function zebra_table(objects,headers,fields) {
	// parses the objects, writes out one <tr></tr> for each, with one <td> </td> for each field listed
	// headers forms the thead. headers and fields need to be the same length
       if (!headers || !fields || !objects) return;

	    x = '';
		hdrs = headers.split("|");
		flds = fields.split("|");
		var current_status = evenodd; evenodd=true;
		x=x+ '<thead><tr>'
		for (i=0;i<hdrs.length;i++) {
			hdr= hdrs[i];
			if (hdr != "Details" || special ) x=x+ '<th><a href="#" class="sortheader" onclick="ts_resortTable(this);return false;">' + hdr + '<span class="sortarrow"></span></a></th>'
		}
		x=x+ '</tr></thead><tbody>'
		for (i=0; i<objects.length; i++) {
			obj = objects[i];
			// check if filtered
			//alert (group);
			if (group && group.toLowerCase() != "all") { //filter by group
				grps = obj.getElementsByTagName("ROVR_Beneficiary_Groups");
				if (grps) grps=grps[0].textContent;
				//alert (grps);
				if (!grps || grps.toLowerCase().indexOf(group.toLowerCase()) < 0) {
					//alert (grps + " | " +  grps.indexOf(group) );
					continue;
					}
			}
			//objtyp = obj.class.to_s
			evenodd = !evenodd;  
			if (evenodd) x=x+ '<tr class="evenrow">'; 
			else x=x+ '<tr class="oddrow">';
			//x=x+"<td>" + obj + "</td>";
			var this_ones_url = "";
			
			for (j=0; j<flds.length; j++) { 
				fld = flds[j];
				
				if (fld == "details") {
				     if (special)  x=x+ '<td valign="center" width="100px">';
  					}
				else  x=x+ '<td valign="top">';
				
				value = obj.getElementsByTagName(fld);
				
				if (value[0]) {
					cntnts = value[0].textContent; 
					if (!cntnts) cntnts = value[0].text; 
					value = cntnts;
					}
				else value="&nbsp;";
				if (!value || value.length <1 || value == "<none>") value="&nbsp;";

				//if (fld=="Member_ID") alert ("value = |" + value +"|");
				if (true) {
					if (fld == "BuyBlue") {
						 x = x+ '<a href="http://www.buyblue.org/node/' + value + '/view/summary" target="_blank">' + value +'</a>';
					}
					else if (fld == "Guidestar") {
						 x = x+ '<a href="http://www.guidestar.org/pqShowGsReport.do?partner=networkforgood&npoId=' + value + '"  target="_blank">' + value +'</a>';
					}
					else if (fld == "Tax_ID") {
						 x = x+ '<a href="http://www.guidestar.org/pqShowGsReport.do?partner=networkforgood&ein=' + value + '"  target="_blank">' + value +'</a>';
					}
					else if (fld == "MerchantLink" ) {
						//extract the url from the link string, for later use
						var url_start = value.indexOf('href="');
						if (url_start >= 0) {
							var url = value.substring(url_start + 6);
							var url_end = url.indexOf('"');
							if (url_end >=0) this_ones_url = url.substring(0, url_end);
						}
						x = x+value;
					}
					else if (fld == "Website" ) {
						value = value.replace(/http:\/\//,"");
						value = value.replace(/www./, "");
						//stored minus "http://www."
						this_ones_url = "http://www." + value;
						//don't display, use it to make links out of later fields
						//x = x+this_ones_url;
					}
					else if (fld == "Transaction_Time" ||fld == "Process_Time") {
						if (value.indexOf(":") == 1) value = "0" + value;
						x = x+ value;
						}
					else if (fld == "MerchantLogo" ) {
						if (value.length > 10) {
							var img_str = '<img src="' + value + '" border=0 />';
							if (this_ones_url.length > 0 ) x = x+ '<a href="' + this_ones_url + '" target = "_blank">' + img_str + '</a>';
							else x = x + img_str;
							}
						else x = x +"&nbsp;";
						}
					else if (fld == "Account_Name" ) {
							if (this_ones_url.length > 0 ) x = x+ '<a href="' + this_ones_url + '" target = "_blank">' + value + '</a>';
							else x = x + value;
							}
					else if (fld == "Transaction_Date" ||fld == "Process_Date") {
						var weekday = value.match(/day/);
						//Linkshare Ind. Item Report
						if (weekday) {
							var yr = value.match(/200[0-9]/);
							var mo = value.match(/-([a-zA-Z]{3})-/);
							mo = mo[1].toLowerCase();

							if (mo == "jan") mo = "01";
							else if (mo == "feb") mo = "02"; 
							else if (mo == "mar") mo = "03"; 
							else if (mo == "apr") mo = "04"; 
							else if (mo == "may") mo = "05"; 
							else if (mo == "jun") mo = "06"; 
							else if (mo == "jul") mo = "07"; 
							else if (mo == "aug") mo = "08"; 
							else if (mo == "sep") mo = "09"; 
							else if (mo == "oct") mo = "10"; 
							else if (mo == "nov") mo = "11"; 
							else if (mo == "dec") mo = "12"; 
							
							var day = value.match(/ ([0-9]{2})-/);
							x=x+yr + "-" + mo+ "-" + day[1];
							}
						//Linkshare Member_ID Report
						else {
							yr = value.substring(value.lastIndexOf("/")+1);
							value = value.substring(0,value.lastIndexOf("/"));
							day = value.substring(value.lastIndexOf("/")+1);
							if (day.length == 1) day ="0" + day;
							mo = value.substring(0,value.lastIndexOf("/"));
							if (mo.length == 1) mo ="0" + mo;
							x = x+ yr + "/" + mo + "/" + day;
							}
						}
					else  x=x+value ;
				}

				x=x+ '</td>'
			}
			x=x+ '</tr>'
		}
		x=x+ '</tbody>';
		evenodd = current_status ;
		
		//document.write(x);
		//document.getElementById('writeroot').innerHTML = x;
		return x;
    }
	
	

	
	
	var path="/";
	var parameters_array = null;		// parsed parameters on url
	var urlbase = null;					// domain name
	var urlpath = "";					// path portion after domain name without parameters
	var fullpath = "";					// full portion after domain name 
	var visiting = "";					// first segment of path portion
	var username = null;				// peek at cookies to get user name
	var domainname = "";				// domain name stripped from url
	var subdomain = "";					// www or whatever prefix
	var parameter_str = "";				// portion after ?

    function startsWith(alpha,beta) {
            if( alpha && beta && alpha.length >= beta.length ) {
                    if( alpha.substr(0,beta.length) == beta ) {
                            return true;
                    }
            }
            return false;
    }
		

	function get_URLParts() {

		// convert to string
		var a = "" + location.href;
		
		// remove the http part
		if( startsWith(a, "http://") ) {
			a = a.substring(7,a.length);
		}
		
		//split off domain name 
		var i = a.indexOf('/');
		if( i >= 0 ) {
			fullpath = a.substring( i, a.length );
			domainname = a.substring(0,i);
		} else {
			fullpath = a;
			domainname = a;
		}
		subdomain = domainname.split(".")[0];

		// remove the parameters and  get them into an index
		i = fullpath.indexOf('?');
		if( i >= 0 ) {
			b = fullpath.substring(0,i);
			parameter_str = fullpath.substring(i+1,fullpath.length);
			parameters_array = parameter_str.split('&');
			
		} else {
			b = fullpath;
		}

		// strip off the domain and hold onto the portion *after* the domain
		urlpath = b;

		i = urlpath.indexOf('/');
		if( i >= 0 ) {
			urlpath = b.substring( i, b.length );
		} else {
			urlpath = b;
		}

		// get the domain and the first path (the user being visited)
		var c = b.split("/");
		if( c.length > 0 ) {
			urlbase = c[0];
		}
		if( c.length > 1 ) {
			visiting = c[1];
		}
	}

	function get_Parameter(name) {
		var i = 0;
		if( parameters_array != null ) {
			while( i < parameters_array.length ) {
				var sp2 = parameters_array[i].indexOf('=');
				if( sp2 == -1 ) {
					if( name == parameters_array[i] ) {
						return "true";
					}
				}
				else if( name == parameters_array[i].substring(0,sp2) ) {
					return parameters_array[i].substring(sp2+1,parameters_array[i].length);
				}
				i = i + 1;
			}
		}
		return null;
	}
	
	
		
	// names for ajax divs
	var Toggles = new Array;
	function make_toggle_link (divName, linkText) {
		//returns HTML for a link that opens and closes a div
		var out = '<a href="#" onclick="javascript:var divName=\'' + divName +'\'; Toggles[divName] = !Toggles[divName] ; if (Toggles[divName] )  showDiv(\''+ divName + '\'); else hideDiv(\''+ divName + '\');">' + linkText + '</a>';
		return out; 
	}
	
	function make_toggle_arrow (divName, linkText) {
		var out = '<a href="#" onclick=\'javascript: Toggles["' + divName + '"] = !Toggles["' + divName + '"] ; var arrow = "";  if (Toggles["' + divName + '"]) {showDiv("' + divName + '");   arrow = "_down"; } else { hideDiv("' + divName + '"); arrow = ""; } document.getElementById("' + divName + '-arrow").src = "http://www.interraproject.org/images/categoryToggleArrow"+arrow+".gif"; return false; \'><img id="' + divName + '-arrow" src="http://www.interraproject.org/images/categoryToggleArrow.gif" border="0"></a>';
		return out;
	}
	
function mouseX(evt) {
if (evt.pageX) return evt.pageX;
else if (evt.clientX)
   return evt.clientX + (document.documentElement.scrollLeft ?
   document.documentElement.scrollLeft :
   document.body.scrollLeft);
else return null;
}
function mouseY(evt) {
if (evt.pageY) return evt.pageY;
else if (evt.clientY)
   return evt.clientY + (document.documentElement.scrollTop ?
   document.documentElement.scrollTop :
   document.body.scrollTop);
else return null;
}

	