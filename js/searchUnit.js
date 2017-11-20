function getSelectLclasBox(code){
	$('#ncsLclas').empty();$('#ncsMclas').empty();$('#ncsSclas').empty();$('#ncsSubd').empty();
	$('#sqlId').val('ncsunitfactr.selectNCS_LCLAS')
	$.ajax({
    url:'/biz/getAjaxList.do',
    type:'POST',
    data: $('#frm').serialize(),
    dataType: 'json',
    success: function( json ) {
        //console.log(json)
         $('#ncsLclas').append($('<option>').text('').prop('value', ''));
    	$.each(json.list, function(i, row) {
            $('#ncsLclas').append($('<option>').text(row.ncsLclas+'.'+row.ncsClasNm).prop('value', row.ncsLclas)
            );
        });
    	if(code) {
    		$('#ncsLclas').val(code.substring(0,2));
    		getSelectMclasBox(code)
    	}
    }
	});
}
function getSelectMclasBox(code){
	$('#ncsMclas').empty();$('#ncsSclas').empty();$('#ncsSubd').empty();
	$('#sqlId').val('ncsunitfactr.selectNCS_MCLAS')
	$.ajax({
    url:'/biz/getAjaxList.do',
    type:'POST',
    data: $('#frm').serialize(),
    dataType: 'json',
    success: function( json ) {
        //console.log(json)
         $('#ncsMclas').append($('<option>').text('').prop('value', ''));
    	$.each(json.list, function(i, row) {
            $('#ncsMclas').append($('<option>').text(row.ncsMclas+'.'+row.ncsClasNm).prop('value', row.ncsMclas)
            );
        });
    	if(code) {
    		$('#ncsMclas').val(code.substring(2,4));
    		getSelectSclasBox(code)
    	}
    }
	});
}
function getSelectSclasBox(code){
	$('#ncsSclas').empty();$('#ncsSubd').empty();
	$('#sqlId').val('ncsunitfactr.selectNCS_SCLAS')
	$.ajax({
    url:'/biz/getAjaxList.do',
    type:'POST',
    data: $('#frm').serialize(),
    dataType: 'json',
    success: function( json ) {
        //console.log(json)
         $('#ncsSclas').append($('<option>').text('').prop('value', ''));
    	$.each(json.list, function(i, row) {
            $('#ncsSclas').append($('<option>').text(row.ncsSclas+'.'+row.ncsClasNm).prop('value', row.ncsSclas)
            );
        });
    	if(code) {
    		$('#ncsSclas').val(code.substring(4,6));
    		getSelectSubdBox(code)
    	}
    }
	});
}
function getSelectSubdBox(code){
	$('#ncsSubd').empty();
	$('#sqlId').val('ncsunitfactr.selectNCS_SUBD')
	$.ajax({
    url:'/biz/getAjaxList.do',
    type:'POST',
    data: $('#frm').serialize(),
    dataType: 'json',
    success: function( json ) {
        //console.log(json)
         $('#ncsSubd').append($('<option>').text('').prop('value', ''));
    	$.each(json.list, function(i, row) {
            $('#ncsSubd').append($('<option>').text(row.ncsSubd+'.'+row.ncsClasNm).prop('value', row.ncsSubd)
            );
        });
    	if(code) {
    		$('#ncsSubd').val(code.substring(6,8));
    		getSelectUnitBox(code)
    	}
    }
	});
}
function getSelectUnitBox(code){
	$('#unitCd').empty(); $('#unitClCd').val(''); $('#pNcsGb').val('');
	$('#sqlId').val('ncsunitfactr.selectNCS_UNIT')
	var clid = $('#ncsLclas').val()+$('#ncsMclas').val()+$('#ncsSclas').val()+$('#ncsSubd').val();
	if(clid.length < 8) return;
	$('#ncsClCd').val(clid)
	
	$.ajax({
    url:'/biz/getAjaxList.do',
    type:'POST',
    data: $('#frm').serialize(),
    dataType: 'json',
    success: function( json ) {
        //console.log(json)
         $('#unitCd').append($('<option>').text('').prop('value', ''));
    	$.each(json.list, function(i, row) {
            $('#unitCd').append($('<option>').text(row.unitCd+'.'+row.unitName).prop('value', row.unitCd).prop('unitClCd', row.unitClCd).prop('ncsGb', row.ncsGb).prop('unitName', row.unitName)
            );
        });
    	if(code) {
    		$('#unitCd').val(code.substring(8,10)).change();
    	}
    }
	});
}

