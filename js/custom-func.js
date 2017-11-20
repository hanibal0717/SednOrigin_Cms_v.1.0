
/*
	jquery-ui datepicker 확장
*/
jQuery.fn.calendar = function(options) {
	jQuery(this).css("width", "80px");
	jQuery(this).attr("maxLength", "10");
	jQuery(this).attr("readonly", true);
	
	var dateObj = jQuery(this);
	var dpImg = "/images/btn_cha.gif";
	
	options = jQuery.extend(true, {
		maxObj : null,
		minObj : null,
		maxDate : null,
		minDate : null
	}, options);
	
	var dpParams = {
			buttonImage:  dpImg,
			buttonImageOnly: false,
			showOn: "button",
			changeMonth: true,
			changeYear: true,
			showButtonPanel: true,
			showOtherMonths: true,
			selectOtherMonths: true,
			minDate: null,
			maxDate: null,
			dateFormat: "yy-mm-dd",
			onClose: null
	};

	if (options.maxObj) {
		dpParams.maxDate = jQuery.datepicker.parseDate(jQuery.datepicker._defaults.dateFormat , jQuery(options.maxObj).val());
		dpParams.onClose = function(date, inst) {
			jQuery(options.maxObj).datepicker('option', 'minDate', jQuery.datepicker.parseDate(jQuery.datepicker._defaults.dateFormat , jQuery(this).val()));
		};
		jQuery(this).change(function(){
			jQuery(options.maxObj).datepicker('option', 'minDate', jQuery.datepicker.parseDate(jQuery.datepicker._defaults.dateFormat , jQuery(this).val()));
		});
	}
	
	if (options.minObj) {
		dpParams.minDate = jQuery.datepicker.parseDate(jQuery.datepicker._defaults.dateFormat , jQuery(options.minObj).val());
		dpParams.onClose = function() {
			jQuery(options.minObj).datepicker('option', 'maxDate', jQuery.datepicker.parseDate(jQuery.datepicker._defaults.dateFormat , jQuery(this).val()));
		};
		jQuery(this).change(function(){
			jQuery(options.minObj).datepicker('option', 'maxDate', jQuery.datepicker.parseDate(jQuery.datepicker._defaults.dateFormat , jQuery(this).val()));
		});
	}

	
	if (options.maxDate) {
		var maxDate;
		try {
			maxDate = jQuery.datepicker.parseDate(jQuery.datepicker._defaults.dateFormat , options.maxDate);
		} catch(err) {
			maxDate = options.maxDate;
		}
		dpParams.maxDate = maxDate;
	}
	
	if (options.minDate) {
		dpParams.minDate = jQuery.datepicker.parseDate(jQuery.datepicker._defaults.dateFormat , options.minDate);
	}

	var datepickerObj = dateObj.datepicker( dpParams );
};

jQuery.calendar = function(obj, options) {
	
	obj.attr("size", "10");
	obj.attr("maxLength", "10");
	obj.attr("readonly", true);
	
	options = jQuery.extend(true, {
		maxObj : null,
		minObj : null,
		maxDate : null,
		minDate : null
	}, options);
	
	var dpParams = {
			showOn: "button",
			buttonImage:  "btn_cha.gif",
			buttonImageOnly: true,
			changeMonth: true,
			changeYear: true,
			showButtonPanel: true,
			showOtherMonths: true,
			selectOtherMonths: true,
			minDate: null,
			maxDate: null,
			onClose:null
	};

	/*
	if (options.maxObj) {
		dpParams.maxDate = jQuery.datepicker.parseDate(jQuery.datepicker._defaults.dateFormat , jQuery(options.maxObj).val());
		dpParams.onClose = function() {
			jQuery(options.maxObj).datepicker('option', 'minDate', jQuery.datepicker.parseDate(jQuery.datepicker._defaults.dateFormat , jQuery(this).val()));
		};
	}
	
	if (options.minObj) {
		dpParams.minDate = jQuery.datepicker.parseDate(jQuery.datepicker._defaults.dateFormat , jQuery(options.minObj).val());
		dpParams.onClose = function() {
			jQuery(options.minObj).datepicker('option', 'maxDate', jQuery.datepicker.parseDate(jQuery.datepicker._defaults.dateFormat , jQuery(this).val()));
		};
	}
	*/
	
	if (options.maxDate) {
		var maxDate;
		try {
			maxDate = jQuery.datepicker.parseDate(jQuery.datepicker._defaults.dateFormat , options.maxDate);
		} catch(err) {
			maxDate = options.maxDate;
		}
		dpParams.maxDate = maxDate;
	}
	
	if (options.minDate) {
		dpParams.minDate = jQuery.datepicker.parseDate(jQuery.datepicker._defaults.dateFormat , options.minDate);
	}	

	obj.datepicker( dpParams );
};

var $alertDiv,$confirmDiv;
jQuery(window).resize(function(){
	if ($alertDiv){
	    $alertDiv.dialog("option","position","center");
	}

	if ($confirmDiv){
	    $confirmDiv.dialog("option","position","center");
	}
});
/*
	jquery-ui dialog 확장
*/
jQuery.alert = function(msg, options) {

	//$.ui.dialog.defaults.bgiframe = true;
	
	options = jQuery.extend(true, {
		title: '알림',
		btn : '확인'
	}, options);
	
	//var doc = (options.target) ? window.parent : window;
	var doc = (options.target) ? window.top : window;
		
	// 로딩바가 있을 경우 숨긴다.
	try {
		if (jQuery.isFunction( doc.fnLoadBarClose() )) {
			doc.fnLoadBarClose();
		} else {
			doc.jQuery(document.body).hideLoading();
		}
	} catch (exception) {
		doc.jQuery(document.body).hideLoading();
	}
	
	if ($(".ui-icon-alert").length > 0) return;
	
	
	$alertDiv = doc.jQuery('<div/>', {html:'<span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 50px 0;"></span>' + msg});
	
	$alertDiv.dialog({
		modal: true,
		zIndex:5000,
		minHeight: 160,
		maxnHeight: 400,
		minWidth: 280,
		maxWidth: 600,
		width: (options.width) ? options.width : 280,
		height: (options.height) ? options.height : 'auto',
		resizable: false,
		draggable: false,
		// title: '<span class="ui-icon ui-icon-alert" style="float:left;"></span> ' + options.title,
		title: options.title,
		buttons: [
			{
				text: options.btn,
				click: function() {
					//$alertDiv.dialog('close');
					//$(this).dialog('close');
					
					if (!options.func) {
						$alertDiv.dialog('destroy');
						$alertDiv.remove();
						$alertDiv = null;
					} else {
						$alertDiv.dialog('close');
					}
					/*
					if(jQuery.isFunction(options.func)) {
						options.func();
					} else {
						eval(options.func);
					}
					*/
					return;
				}
			}
		],
		close: function() {
			//$alertDiv.remove();
			$alertDiv.dialog('destroy');
			$alertDiv.remove();

			if(jQuery.isFunction(options.func)) {
				options.func();
			} else {
				eval(options.func);
			}

			$alertDiv = null;

			return;
		}
	});
	
	if (options.height) {
		$alertDiv.find(".ui-icon-alert").css("margin-bottom", options.height-110 + "px");
	}
	
	return;	
};

/*
	jquery-ui dialog 확장
*/
jQuery.confirm = function(msg, options) {
	options = jQuery.extend(true, {
		title: '확인',
		btnConfirm : '확인',
		btnCancel : '취소'
	}, options);
	
	//var doc = (options.target) ? window.parent : window;
	var doc = (options.target) ? window.top : window;
	
	$confirmDiv = doc.jQuery('<div/>', {html:'<span class="ui-icon ui-icon-circle-check" style="float:left; margin:0 7px 50px 0;"></span>' + msg});

		
	$confirmDiv.dialog({
		modal: true,
		minHeight: 150,
		maxnHeight: 400,
		minWidth: 300,
		maxWidth: 600,
		resizable: false,
		draggable: false,
		// title: '<span class="ui-icon ui-icon-alert" style="float:left;"></span> ' + options.title,
		title: options.title,
		buttons: [
			{
				text: options.btnConfirm,
				click: function() {
					//$confirmDiv.dialog('close');
					$confirmDiv.remove();
					if(jQuery.isFunction(options.func_yes)) {
						options.func_yes();
					} else {
						doc.eval(options.func_yes);
					}
					$confirmDiv = null;
					return;
				}
			},
			{
				text: options.btnCancel,
				click: function() {
					$confirmDiv.dialog('close');
					/*
					$confirmDiv.remove();
					if(jQuery.isFunction(options.func_no)) {
						options.func_no();
					} else {
						doc.eval(options.func_no);
					}
					*/
					return;
				}
			}
		],
		close: function() {
			
			$confirmDiv.remove();
			if(jQuery.isFunction(options.func_no)) {
				options.func_no();
			} else {
				doc.eval(options.func_no);
			}
			$confirmDiv = null;
			return;
		}
	});
	
	if (options.height) {
		$confirmDiv.dialog( "option", "height", options.height );
		$confirmDiv.find(".ui-icon-circle-check").css("margin-bottom", options.height-110 + "px");
	}
	
	if (options.width) {
		$confirmDiv.dialog( "option", "width", options.width );
	}

	
	return;
};

/*
	checkbox all checked
*/
var checkboxAllCheckedBoolean = true;
jQuery.checked = function(cName, cBln) {

	if (cBln == null ) {
		cBln = checkboxAllCheckedBoolean;
		checkboxAllCheckedBoolean = !checkboxAllCheckedBoolean;
	}

	jQuery("input[type=checkbox][id*=" + cName + "]").prop("checked", cBln);
	
};


/*************************************************************************
함수명: maxLength
설  명: Textarea의 글자수 제한
인  자: options (옵션)
			maxLen (최대 글자수)
			textAlign (byte 표시 text align ==> left, right)
			textType
리  턴: 없음 
사용예:
jQuery('textarea').maxLength({maxLen:2000});
***************************************************************************/
var byteLength = 2;
jQuery.fn.maxLength = function(options) {
	
	var defaultStr = "";
	
	options = jQuery.extend(true,
				{
	    			maxLen:100,
	    			textAlign:'right',
	    			textType:'UTF-8'
				},options);
	  
	return this.each(function(index) {
		var $this = jQuery(this);
		/*		
		var $remaining = jQuery('<div/>').attr("style", "padding-top:5px;text-align:"+options.textAlign+";").insertAfter($this);
		var $text = jQuery('<span/>', {text:' byte', css:{textAlign:options.textAlign}}).prependTo($remaining);
	    var $count = jQuery('<span/>', {text:options.maxLen, css:{fontWeight:'bold'}}).prependTo($remaining);
	    */
		var $text = null;
		
		if (jQuery(".commentInfo", $this.parent().parent()).length > 0) {
			defaultStr = '/' + options.maxLen;
			$text = jQuery('<span/>', {text:'0' + defaultStr}).prependTo(jQuery(".commentInfo", $this.parent().parent()));
		} else {
			defaultStr = ' / ' + options.maxLen + "자";
			//$text = jQuery('<span/>', {text:'0' + defaultStr}).addClass("text-limited").insertAfter($this);
			$text = jQuery('<span/>', {text:'0' + defaultStr}).css("float", "right").insertAfter($this);
		}
		
	    var update = function() {
	    
	    	var val = $this.val();
	    	var len = val.length;
	    	var c;
	    	var count = 0;
	    	
	    	if (options.textType == "UTF-8") {
		    	for(var i=0; i<len; i++) {
		    		c = val.charAt(i);
		    		if(escape(c).length > 4)
		    			count += byteLength;
		    		else if(c == '\r')
		    			count += 2;
		    		else if(c == '\n')
		    			count += 2;
		    		else
		    			count++;
		    	}
	    	} else {
	    		count = len;
	    	}

	    	if (count > options.maxLen) {
	    		$text.html('<font color="red">' + count + '</font>' + defaultStr);
            } else {
            	$text.html(count + defaultStr);
	        }
	    };
	      
	    $this.bind('input keyup paste', function () { update(); });

	    update();
	      
	});
};

/*************************************************************************
함수명: getLength
설  명: 글자수 리턴
인  자: $obj (입력 Object (jQuery Object))
        type default UTF-8
리  턴: count (글자수) 
사용예:
jQuery.getLength(jQuery('textarea'));
***************************************************************************/
jQuery.getLength = function($obj, type) {
	var val = $obj.val();
	var len = val.length;
	var c;
	var count = 0;
	
	if (!type) type = "UTF-8";
	
	if (type == "UTF-8") {
		for(var i=0; i<len; i++) {
			c = val.charAt(i);
			if(escape(c).length > 4)
				count += byteLength;
			else if(c == '\r')
				count += 2;
			else if(c == '\n')
				count += 2;
			else
				count++;
		}
	} else {
		count = len;
	}
	
	return count;
};

/*************************************************************************
함수명: valueEmpty
설  명: input type value가 empty 인지 확인
리  턴: boolean 
사용예:
jQuery("#userid").valueEmpty();
***************************************************************************/
jQuery.fn.valueEmpty = function() {
	// 스마트 에디터 초기값이 "<br>"이라서 추가
	if (jQuery.trim(jQuery(this).val()).length < 1 || jQuery.trim(jQuery(this).val()) == "<br>") {
		return true;
	} else {
		return false;
	}
};

jQuery.fn.valuesEmpty = function() {
	var errObj;
	$(this).each(function(index){
		if($(this).valueEmpty()) {
			errObj = this;
			return false;
		}
	});
	
	return errObj;
};

jQuery.fn.allEmpty = function() {
	var tCnt = $(this).length;
	var eCnt = 0;
	
	$(this).each(function(index){
		if($(this).valueEmpty()) {
			eCnt++
		}
	});
	
	return tCnt == eCnt ? true : false;
};

jQuery.editorValueEmpty = function(val) {
	if(jQuery.trim(val) == "" || val == null || jQuery.trim(val) == '&nbsp;' || jQuery.trim(val).toLowerCase() == '<p>&nbsp;</p>' || jQuery.trim(val).toLowerCase() == '<br>') { 
        return true; 
	} else {
		return false;
	} 
};

/* 팝업창 높이 맞춤 */
function fnSetPopupHeigth() {
	var tempHeight = 0;
	tempHeight += Number(jQuery("#popup").css("border-top-width").replace("px", ""));
	tempHeight += Number(jQuery("#popup").css("border-bottom-width").replace("px", ""));
	
	tempHeight += Number(jQuery("#popupIn").css("padding-top").replace("px", ""));
	tempHeight += Number(jQuery("#popupIn").css("padding-bottom").replace("px", ""));
	tempHeight += Number(jQuery("#popupIn").css("border-top-width").replace("px", ""));
	tempHeight += Number(jQuery("#popupIn").css("border-bottom-width").replace("px", ""));

	jQuery("#popupIn").height(jQuery(document.body).height() - tempHeight);
}

/* jquery.alphanumeric.js 추가 */
(function($){
	$.fn.alphanumeric = function(p) { 
		p = $.extend({
			ichars: "!@#$%^&*()+=[]\\\';,/{}|\":<>?~`._- ",
			nchars: "",
			allow: ""
		  }, p);
		
		$(this).css('ime-mode', 'disabled');

		return this.each (
			function() {
				if (p.nocaps) p.nchars += "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
				if (p.allcaps) p.nchars += "abcdefghijklmnopqrstuvwxyz";
				
				var hangulExp = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/gi;
				
				s = p.allow.split('');
				for ( i=0;i<s.length;i++) if (p.ichars.indexOf(s[i]) != -1) s[i] = "\\" + s[i];
				p.allow = s.join('|');
				
				var reg = new RegExp(p.allow,'gi');
				var ch = p.ichars + p.nchars;
				ch = ch.replace(reg,'');

				$(this).bind("keypress", function (e) {
					if (!e.charCode) k = String.fromCharCode(e.which);
					else k = String.fromCharCode(e.charCode);
					
					if (ch.indexOf(k)!=-1) e.preventDefault();
				});

				$(this).bind("keydown keyup blur", function () {
					var obj = $(this);
					var valStr = obj.val();

					if (hangulExp.test(valStr)) {
						alert("한글은 입력불가능합니다.");
						obj.val(valStr.replace(hangulExp, ""));						
						obj.focus();
					}
				});
				
				$(this).bind('contextmenu',function () {return false;});
			}
		);
	};

	$.fn.numeric = function(p) {
		var az = "abcdefghijklmnopqrstuvwxyz";
		az += az.toUpperCase();

		p = $.extend({
			nchars: az
		  }, p);

		return this.each (function() {
			$(this).alphanumeric(p);
		});
			
	};
	
	$.fn.alpha = function(p) {
		var nm = "1234567890";

		p = $.extend({
			nchars: nm
		  }, p);	

		return this.each (function() {
			$(this).alphanumeric(p);
		});
	};
	
})(jQuery);

jQuery.fn.serializeObject = function() {
    var arrayData, objectData;
    arrayData = this.serializeArray();
    objectData = {};
    $.each(arrayData, function() {
        var value;
        if (this.value != null) {
            value = this.value;
        } else {
            value = '';
        }
        if (objectData[this.name] != null) {
            if (!objectData[this.name].push) {
                objectData[this.name] = [ objectData[this.name] ];
            }

            objectData[this.name].push(value);
        } else {
            objectData[this.name] = value;
        }
    });

    return objectData;
}; 

/* 팝업 공통 */
function fnPopupOpen(url, pName, width, height, left, top, scrollbars, resizable, toolbar, location, directories, status, menubar, copyhistory) {
	window.open(url, pName, 'width=' + width + ', ' + 
			'height=' + height + ', ' + 
			'left=' + ((left) ? left : '0') + ',' + 
			'top=' + ((top) ? top : '0') + ',' + 
			'resizable=' + ((resizable) ? resizable : 'no') + ',' + 
			'scrollbars=' + ((scrollbars) ? scrollbars : 'no') + ',' + 
			'toolbar=' + ((toolbar) ? toolbar : 'no') + ',' + 
			'location=' + ((location) ? location : 'no') + ',' + 
			'directories=' + ((directories) ? directories : 'no') + ',' + 
			'status=' + ((status) ? status : 'no') + ',' + 
			'menubar=' + ((menubar) ? menubar : 'no') + ',' + 
			'copyhistory=' + ((copyhistory) ? copyhistory : 'no')
	).focus();
}

/* 
 * 같은 값이 있는 열을 병합함
 */    
$.fn.rowspan = function(colIdx, isStats) {       
    return this.each(function(){      
        var that;     
        $('tr', this).each(function(row) {      
        	
        	//console.log('row='+row);
        	
            $('td:eq('+colIdx+')', this).filter(':visible').each(function(col) {
            	
            	
            	//console.log('colIdx='+$(this).html());
            	
                if ($(this).html() == $(that).html()
                    && (!isStats 
                            || isStats && $(this).prev().html() == $(that).prev().html()
                            )
                    ) {            
                    rowspan = $(that).attr("rowspan") || 1;
                    rowspan = Number(rowspan)+1;
 
                    $(that).attr("rowspan",rowspan);
                     
                    // do your action for the colspan cell here            
                    $(this).hide();
                     
                    //$(this).remove(); 
                    // do your action for the old cell here
                     
                } else {            
                    that = this;         
                }          
                 
                // set the that if not already set
                that = (that == null) ? this : that;      
            });     
        });    
    });  
}; 

/* 
 * SelectBox 의 선택된 값을 제외하고 나머지를 모두 지운다.
 */ 
function fnNotSelectRomove(selId){
	   $("#"+selId+" > option:not(:selected)").each(function() {       
		   $(this).remove();    
	   }); 
}


// 쿠기 SET
function fnSetCookie( name, value, expiredays ) {
    var todayDate = new Date();
    todayDate.setTime(todayDate.getTime()+1000*60*60*12*expiredays);
    document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";";
}

// 쿠기 GET
function fnGetCookie( name ) {
    var nameOfCookie = name + "=";
    var x = 0;
    while ( x <= document.cookie.length )
    {
        var y = (x+nameOfCookie.length);
        if ( document.cookie.substring( x, y ) == nameOfCookie ) {
            if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 )
            endOfCookie = document.cookie.length;
            return unescape( document.cookie.substring( y, endOfCookie ) );
        }
        x = document.cookie.indexOf( " ", x ) + 1;
        if ( x == 0 )
        break;
    }
    return "";
}


/*
 * jqgrid 멀티선택시 선택값을 key기준으로 ,로 연결하여 리턴함
 * s : $("#jqTable").getGridParam('selarrrow')
 * key : key값
 */
function multiKey(s, key){
    var selseq = "";

    s = ""+s;
    if (s==""){
    	return "";
    }
    
    sArr = s.split(",");
    
    for (var i=0; i<sArr.length;i++){
        selval = ($("#jqTable").getRowData(sArr[i]))[key];
        if (i==0){
            selseq = ""+selval;
        }else{
            selseq += ","+selval;
        }
    }
    
    return selseq;
}

function showAlert(msg, url){
	$('body').hideLoading();
	$.alert(msg);
	if(url != null && url.length > 0){
		location.href = url;
	}
}


jQuery.test = function(obj) {
	console.log('$test:'+obj);
}
jQuery.toDate = function(obj, str) {
	if(!str) str = '-'; 
	if(obj && obj.length == 8){
		return obj.substring(0, 4) + str + obj.substring(4, 6) +str +obj.substring(6, 8) 
	}
	return '';
}