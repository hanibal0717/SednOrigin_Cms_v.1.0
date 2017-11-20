
/*
	jquery-ui datepicker 확장
*/
jQuery.fn.calendar = function(options) {
	//console.log('ccccc')
	jQuery(this).css("width", "80px");
	jQuery(this).attr("maxLength", "10");
	jQuery(this).attr("readonly", true);
	//var objid = jQuery(this).attr("id");
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
			buttonText: 'Choose Date',
			changeMonth: true,
			changeYear: true,
			showButtonPanel: true,
			showOtherMonths: true,
			selectOtherMonths: true,
			yearRange: 'c-70:c+10',
			minDate: null,
			maxDate: null,
			dateFormat: "yy-mm-dd",
			onClose: null,
			beforeShow: function( input ) {
            setTimeout(function () {
            	$("button.ui-datepicker-current").hide()
            }, 100 );
        }
	};

	if(options.onSelect){
		dpParams.onSelect = options.onSelect 
		//console.log(options.onSelect);
	}
		
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

	var datepickerObj = dateObj.datepicker( dpParams ).focus(function() {var thisCalendar = $(this);  $('.ui-datepicker-close').click(function() {dateObj.val('');console.log('click')} )});
	datepickerObj.find(".ui-datepicker-current").hide();
};

jQuery.calendar = function(obj, options) {
	console.log('ccccc1')
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
			yearRange: 'c-50:c+10',
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
jQuery.fn.number = function(obj) {
	$(this).keyup(function(){
		$(this).val( $(this).val().replace(/[^(0-9, \.)]/gi,"") )
	});
}
jQuery.fn.nullText = function(obj) {
	if($(this).text() == 'null') $(this).text(''); 
}
jQuery.fn.searchBox = function(obj) {
	var _ta = 0;
	$( this ).autocomplete({
	 source: function (request, response) {
   	  	if(_ta == 1 ) return;
		var obj = {};
		obj.term = request.term;
		obj.sqlId = 'ncsunitfactr.getSearchBoxUnitClcd'
		obj.ncsGb = $('#ncsGb').val()
		obj.useYn = $('#useYn').val()
		$.ajax({
			url:'/biz/getAjaxList.do',
			type:'POST',
			data: obj,
			dataType: 'json',
	    success: function( json ) {
	        //console.log(json.list)
	        response(json.list);
	    }
		});	

      }, 
      minLength: 2,
      select: function( event, ui ) {
    	  //console.log(ui.item)
    	  _ta = 1;
    	  var row = ui.item;
    	  //$('#pNcsGb').val(row.ncsGb)
    	  //$('#unitClCd').val(row.unitClCd)
    	  //$('#unitCd').empty();
    	  //$('#unitCd').append($('<option>').text(row.unitCd+'.'+row.unitName).prop('value', row.unitCd).prop('unitClCd', row.unitClCd).prop('ncsGb', row.ncsGb).prop('leaModDepYn', row.leaModDepYn).prop('subdNm', row.subdNm)  );
    	  getSelectLclasBox(row.unitClCd);
      }
    });
	$(this).keyup(function(){
		_ta = 0;
	});

}
$(document).ready(function() {
	$(document).on("keyup", ".numberOnly", function() {
	    $(this).val($(this).val().replace(/[^0-9]/gi, ""));
	});
	
	$(document).on("keyup", ".numberDotOnly", function() {
		$(this).val($(this).val().replace(/[^0-9|.]/gi, ""));
		if ($(this).val().split(".").length > 2) {
		    $(this).val($(this).val().substring(0, ($(this).val().length - 1)));
		} else {
		    if ($(this).val().indexOf(".") == 0) {
			$(this).val("0" + $(this).val());
		    }
		}
	});
});

function setValue(obj, value) {
	if (obj) {
		//alert ( obj.type +"-----------" + value +"-----------"+ typeof(obj)  );
		if (obj.type == "text") {
			obj.value = value;
		} else if ((obj.type == "radio") || (obj.type == "checkbox")) {
			if (obj.value == value) {
				obj.checked = true;
			} else {
				obj.checked = false;
			}
		} else if (obj.tagName == "SELECT") {
			for ( var i = 0; i < obj.length; i++) {
				if (obj.options[i].value == value) {
					obj.options[i].selected = true;
					break;
				}
			}
		} else if (obj.tagName == "TEXTAREA") {
			obj.value = value;
		} else if (obj.length) { // 배열
			for ( var i = 0; i < obj.length; i++) {
				if ((obj[i].type == "radio") || (obj[i].type == "checkbox")) {
					if (obj[i].value == value) {
						obj[i].checked = true;
					}
				}
			}
		}
	}
}