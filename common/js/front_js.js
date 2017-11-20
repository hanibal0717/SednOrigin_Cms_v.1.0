var jsCreate = {	
	toggleList : function($obj){
		var obj = $obj[0];
		obj.reset = function(){
			obj.t = $obj.find(".tit"), obj.btn = obj.t.find(".trigger"), obj.v = $obj.find(".dtable");
			obj.v.eq(obj.v.length-1).addClass("last");
			if(obj.t.length==0) return;
			obj.btn.each(function(z){
				this.flag = (obj.t[z].className.match(/active/)) ? true : false;
				this.onclick = function(){
					var bThis = this;
					obj.t.each(function(i){
						if(z==i && !obj.btn[i].flag){
							obj.btn[i].flag = true, obj.btn[i].title = bThis.title.replace("열기","닫기");;
							obj.t.eq(i).addClass("active");
							obj.v.eq(i).addClass("active");
						}else{
							obj.btn[i].flag = false, obj.btn[i].title = bThis.title.replace("닫기","열기");
							obj.t.eq(i).removeClass("active");
							obj.v.eq(i).removeClass("active");
						}
					});
					return false;
				}
			});
		}
		obj.reset();
	}
}


$(document).ready(function(){
	if (!$("table").length) {
		return;
	}
	$("table tr:nth-child(even) td").addClass('even');
});