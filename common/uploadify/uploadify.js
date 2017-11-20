var uploadFileInfo = '';
function jsCheckCss() {
	var uploadify_css = $( "#uploadify_css" ).attr("href");
	uploadify_css = uploadify_css + "";
	
	if (uploadify_css == "undefined") {
		$("head").append("<link id='uploadify_css' rel='stylesheet' type='text/css' href='/common/uploadify/uploadify_step.css'>");
		$("head").append("<script src='/common/uploadify/jquery.uploadify.js'>");
	}
}

function jsDrawSingleUpload(ELEMENT_ID, CATE, FILE_EXTS, FILE_SIZE_LIMIT) {
	$(document).ready(function() {
		jsCheckCss();
		
		$('#' + ELEMENT_ID).uploadify({
			'swf' : '/common/uploadify/uploadify.swf',
			'uploader' : '/file/upload.do',
			'buttonImage' : '/common/uploadify/images/bt_addfile_s.jpg',
			'button_image_url' : '/common/uploadify/images/bt_addfile_s.jpg',
			'width' : 70,
			'height' : 20, 
			'multi': false,
			'fileTypeExts' : FILE_EXTS,
			'fileSizeLimit' : FILE_SIZE_LIMIT,
			'formData' : {'FILE_GUBUN': ELEMENT_ID},
			'onSWFReady' : function(instance) {
				var img_count = $("#" + ELEMENT_ID + "_IMAGE_LIST li").length;
				var file_count = $("#" + ELEMENT_ID + "_FILE_LIST li").length;
				
				if (img_count > 0 || file_count > 0) {
					jsFileUploadElementDisplay(ELEMENT_ID, "HIDE");
				}
	        },
			'onUploadError' : function(file, errorCode, errorMsg, errorString) {
				alert(file.name + ' 업로드가 불가능 합니다. \n불가사유\n' + errorString);
			},
			'onUploadSuccess' : function(file, data, response) {
				uploadFileInfo = "/upload/"+ELEMENT_ID;
				jsUploadSuccess(ELEMENT_ID, CATE, data);
				
				jsFileUploadElementDisplay(ELEMENT_ID, "HIDE");
			}
		});
	});
}

function jsFileUploadElementDisplay(ELEMENT_ID, DIVISION) {
	if (DIVISION == "SHOW") {
		$('#' + ELEMENT_ID).uploadify('settings', 'width', 70);
		$('#' + ELEMENT_ID).uploadify('settings', 'height', 20);
		$('#' + ELEMENT_ID).unbind("click");
	} else {
		$('#' + ELEMENT_ID).uploadify('settings', 'width', 0);
		$('#' + ELEMENT_ID).uploadify('settings', 'height', 0);
		$('#' + ELEMENT_ID).unbind("click");
		
		$('#' + ELEMENT_ID).click(function() {
			alert('한개의 파일만 첨부 가능합니다.');
		});
	}
}

function jsDrawMultiUpload(ELEMENT_ID, CATE, FILE_EXTS, FILE_SIZE_LIMIT) {
	$(document).ready(function() {
		jsCheckCss();
		
		$('#' + ELEMENT_ID).uploadify({
			'swf' : '/common/uploadify/uploadify.swf',
			'uploader' : '/file/upload.do',
			'buttonImage' : '/common/uploadify/images/bt_addfile_s.jpg',
			'button_image_url' : '/common/uploadify/images/bt_addfile_s.jpg',
			'width' : 70,
			'height' : 20,
			'multi': true,
			'fileTypeExts' : FILE_EXTS,
			'fileSizeLimit' : FILE_SIZE_LIMIT,
			'formData' : {'FILE_GUBUN': ELEMENT_ID},
			'onUploadError' : function(file, errorCode, errorMsg, errorString) {
				alert(file.name + ' 업로드가 불가능 합니다. \n불가사유\n' + errorString);
			},
			'onUploadSuccess' : function(file, data, response) {
				jsUploadSuccess(ELEMENT_ID, CATE, data);
			}
		});
	});
}

function jsDrawMultiUpload_front(ELEMENT_ID, CATE, FILE_EXTS, FILE_SIZE_LIMIT) {
	$(document).ready(function() {
		jsCheckCss();
		
		$('#' + ELEMENT_ID).uploadify({
			'swf' : '/common/uploadify/uploadify.swf',
			'uploader' : '/file/upload.do',
			'buttonImage' : '/common/uploadify/images/btn_search.png',
			'button_image_url' : '/common/uploadify/images/btn_search.png',
			'width' : 80,
			'height' : 37,
			'multi': true,
			'fileTypeExts' : FILE_EXTS,
			'fileSizeLimit' : FILE_SIZE_LIMIT,
			'onUploadError' : function(file, errorCode, errorMsg, errorString) {
				alert(file.name + ' 업로드가 불가능 합니다. \n불가사유\n' + errorString);
			},
			'onUploadSuccess' : function(file, data, response) {
				jsUploadSuccess(ELEMENT_ID, CATE, data);
			}
		});
	});
}

function jsUploadSuccess(ELEMENT_ID, CATE, serverData) {
	serverData = serverData.replace(/^[ /\n/\r]/g,"");
	var result = eval( "("+ serverData + ")" );
	var dispFileNM = decodeURIComponent(result.DISP_FILE_NM);
	
	if (dispFileNM != null && dispFileNM != "") {
		jsAddFile(ELEMENT_ID, CATE, dispFileNM, result.FILE_NM, result.FILE_SIZE, result.FILE_TYPE, result.FILE_TYPE, result.FILE_PATH);
	}
}

function jsAddFile(ELEMENT_ID, CATE, dispFileNm, fileNm, fileSize, fileType, fileTypeOrg, filePath, fileSeq) {
	if (fileType == "IMG") {
		jsDrawImageFile(ELEMENT_ID, dispFileNm, fileNm, fileSize, fileSeq);
	} else {
		jsDrawFile(ELEMENT_ID, dispFileNm, fileNm, fileSize, fileTypeOrg, fileSeq);
	}
	
	jsAddInput(ELEMENT_ID, CATE, dispFileNm, fileNm, fileSize, fileType, fileTypeOrg, filePath, fileSeq);
}

function jsDisplayElement(ELEMENT_ID) {
	var count = $("#" + ELEMENT_ID + " li").length;
	
	if (count > 0) {
		$('#' + ELEMENT_ID).show();		
	} else {
		$('#' + ELEMENT_ID).hide();
	}
}

function jsDrawImageFile(ELEMENT_ID, dispFileNm, fileNm, fileSize, fileSeq, imgUrl, mainImgYn) {
	var IMAGE_ELEMENT_ID = ELEMENT_ID + "_IMAGE_LIST";
	
	var upload_type = $("#" + IMAGE_ELEMENT_ID).attr("upload_type");
			
	var count = $("#" + IMAGE_ELEMENT_ID + " li").length;
	count = count + 1;
	
	var objLi = document.createElement("li");
	objLi.id = "file_" + fileNm;
	objLi.DISP_FILE_NM = dispFileNm;
	objLi.FILE_NM = fileNm;
	objLi.FILE_SEQ = fileSeq;
	
	var objDiv = document.createElement("div");
	objDiv.setAttribute("class", "top");
	objDiv.id="file_" + fileNm + "_div"; 
	
	if (upload_type == "multi") {
		var mainRadio = $("<input/>");
		$(mainRadio).attr({
			type: "radio",
			name: "MAIN_IMG_FILE_NM",
			value: fileNm,
			notNull: "",
			dispName: "대표 이미지 여부"
		});
		
		$(objDiv).append(mainRadio);
	}
	
	$(objDiv).append("<span>" + dispFileNm + "</span>");
		
	// 삭제 버튼
	objImg = document.createElement("img");
	objImg.setAttribute("src", "/common/uploadify/images/bt_del_s.gif");
	objImg.setAttribute("alt", "삭제");
	objImg.setAttribute("style", "padding-right:2px");
	objImg.style.cursor = "pointer";
	if (fileSeq == null || fileSeq == "") {
		objImg.onclick = function () {
			jsDeleteTempFile(IMAGE_ELEMENT_ID, dispFileNm, fileNm, 'IMG');
			if (upload_type == "single") {
				jsFileUploadElementDisplay(ELEMENT_ID, "SHOW");
			}
		};
	} else {
		objImg.onclick = function () {
			jsDeleteFile(IMAGE_ELEMENT_ID, dispFileNm, fileNm, 'IMG', fileSeq);
			if (upload_type == "single") {
				jsFileUploadElementDisplay(ELEMENT_ID, "SHOW");
			}
		};
	}
	objDiv.appendChild(objImg);
	
	objLi.appendChild(objDiv);
	
	// 이미지
	var objImg = document.createElement("img");
	objImg.setAttribute("class", "images");
	
	objImg.style.width = "120px";
	objImg.style.height = "80px";
	
	objImg.style.cursor = "pointer";
	 
	if(imgUrl == null || imgUrl == '') {
		objImg.src = "/UPLOAD/" + ELEMENT_ID + "/" + fileNm;
		//objImg.src = "/CommFileDownLoad.do?eleId="+ELEMENT_ID+"&fileNm="+fileNm;
	} else if (imgUrl.indexOf(".") > -1) {
		objImg.src = imgUrl;
	} else {
		objImg.src = "/UPLOAD/" + ELEMENT_ID + "/" + fileNm;	
		//objImg.src = "/CommFileDownLoad.do?eleId="+ELEMENT_ID+"&fileNm="+fileNm;
	}
	
	objImg.onclick = function () {
		popWin(objImg.src, "img_preview", 800, 600, true);
	};
	
	objImg.setAttribute("title", dispFileNm);
	
	objLi.appendChild(objImg);

	document.getElementById(IMAGE_ELEMENT_ID).appendChild(objLi);

	if (mainImgYn == "Y") {
		setValue(mainRadio, fileNm);
	}
	
	if (typeof mainImgYn == "undefined") {
		setValue(mainRadio, fileNm);		
	}
	
	jsDisplayElement(IMAGE_ELEMENT_ID);
}

function jsDrawFile(ELEMENT_ID, dispFileNm, fileNm, fileSize, fileTypeOrg, fileSeq) { 
	var FILE_ELEMENT_ID = ELEMENT_ID + "_FILE_LIST";
	
	var upload_type = $("#" + FILE_ELEMENT_ID).attr("upload_type");
	
	// 전체 li
	var objLi = document.createElement("li");
	objLi.id = "file_" + fileNm;
	objLi.DISP_FILE_NM = dispFileNm;
	objLi.FILE_NM = fileNm;
	objLi.FILE_SEQ = fileSeq;

	// 파일 아이콘
	var objImg = document.createElement("img");
	objImg.setAttribute("src", "/common/uploadify/images/ico_file_def.gif");
	objImg.setAttribute("style", "padding-right:5px");
	objLi.appendChild(objImg);
	
	// 파일명
	var objSpan = document.createElement("span");
	objSpan.setAttribute("style", "padding-right:10px");
	
	objSpan.innerHTML = dispFileNm;
	objLi.appendChild(objSpan);

	// 삭제 버튼
	objImg = document.createElement("img");
	objImg.setAttribute("src", "/common/uploadify/images/bt_del_s.gif");
	objImg.setAttribute("alt", "삭제");
	objImg.setAttribute("style", "padding-right:2px");
	
	objImg.style.cursor = "pointer";
	if (fileSeq == null || fileSeq == "") {
		objImg.onclick = function () {
			jsDeleteTempFile(FILE_ELEMENT_ID, dispFileNm, fileNm, 'FILE');
			if (upload_type == "single") {
				jsFileUploadElementDisplay(ELEMENT_ID, "SHOW");
			}
		};
	} else {
		objImg.onclick = function () {
			jsDeleteFile(FILE_ELEMENT_ID, dispFileNm, fileNm, 'FILE', fileSeq);
			if (upload_type == "single") {
				jsFileUploadElementDisplay(ELEMENT_ID, "SHOW");
			}
		};
	}
	objLi.appendChild(objImg);
	
	document.getElementById(FILE_ELEMENT_ID).appendChild(objLi);
	
	jsDisplayElement(FILE_ELEMENT_ID);
}

function jsAddInput(ELEMENT_ID, CATE, dispFileNm, fileNm, fileSize, fileType, fileTypeOrg, filePath, fileSeq) {
	var fileDiv = document.getElementById("file_" + fileNm);

	var newInput = document.createElement("input");
	newInput.type = "hidden";
	newInput.name = "GUBUN";
	newInput.value = CATE;
	fileDiv.appendChild(newInput);
	
	newInput = document.createElement("input");
	newInput.type = "hidden";
	newInput.name = "FILE_GUBUN";
	newInput.value = ELEMENT_ID;
	fileDiv.appendChild(newInput);
	
	newInput = document.createElement("input");
	newInput.type = "hidden";
	newInput.name = "ORG_FILE_NM";
	newInput.value = dispFileNm;
	fileDiv.appendChild(newInput);

	newInput = document.createElement("input");
	newInput.type = "hidden";
	newInput.name = "FILE_NM";
	newInput.value = fileNm;
	fileDiv.appendChild(newInput);

	newInput = document.createElement("input");
	newInput.type = "hidden";
	newInput.name = "FILE_SIZE";
	newInput.value = fileSize;
	fileDiv.appendChild(newInput);

	newInput = document.createElement("input");
	newInput.type = "hidden";
	newInput.name = "FILE_TYPE";
	newInput.value = fileType;
	fileDiv.appendChild(newInput);

	newInput = document.createElement("input");
	newInput.type = "hidden";
	newInput.name = "FILE_TYPE_ORG";
	newInput.value = fileTypeOrg;
	fileDiv.appendChild(newInput);

	newInput = document.createElement("input");
	newInput.type = "hidden";
	newInput.name = "FILE_PATH";
	newInput.value = filePath;
	fileDiv.appendChild(newInput);
	
	newInput = document.createElement("input");
	newInput.type = "hidden";
	newInput.name = "FILE_SEQ";
	newInput.value = (fileSeq == null ? "" : fileSeq);
	
	fileDiv.appendChild(newInput);
}

function jsDeleteFile(ELEMENT_ID, dispFileNm, fileNm, fileType, fileSeq) {
	if (confirm("삭제하시겠습니까?")) {
		document.getElementById(ELEMENT_ID).removeChild(document.getElementById('file_' + fileNm));

		var newInput = document.createElement("input");
		newInput.type = "hidden";
		newInput.name = "DELETE_DATA_IDX";
		newInput.value = fileSeq;
		document.getElementById(ELEMENT_ID).appendChild(newInput);
		
		newInput = document.createElement("input");
		newInput.type = "hidden";
		newInput.name = "DELETE_FILENM";
		newInput.value = fileNm;
		document.getElementById(ELEMENT_ID).appendChild(newInput);
		
		newInput = document.createElement("input");
		newInput.type = "hidden";
		newInput.name = "DELETE_FILE_GUBUN";
		newInput.value = ELEMENT_ID;
		document.getElementById(ELEMENT_ID).appendChild(newInput);
		
		jsDisplayElement(ELEMENT_ID);
	}
}

function jsDeleteTempFile(ELEMENT_ID, dispFileNm, fileNm, fileType) {
	if (confirm("삭제하시겠습니까?")) {
		$.ajax({
		    url:'/file/removeTemp.do',
		    type:'POST',
		    data: {FILE_NM:fileNm, DISP_FILE_NM:dispFileNm, FILE_TYPE:fileType, FILE_AREA_ID:ELEMENT_ID},
		    dataType: 'json',
		    success: function( data) {
		    	alert(data.msg);
		    	if (data.result == "success") {
		    		document.getElementById(data.FILE_AREA_ID).removeChild(document.getElementById('file_' + data.FILE_NM));
					
					jsDisplayElement(data.FILE_AREA_ID);
		    	}
		    }
		});
	}
}

function jsDrawImageFileDownload(ELEMENT_ID, dispFileNm, fileNm, fileSize, fileSeq, imgUrl, mainImgYn) {
	jsCheckCss();
	
	var IMAGE_ELEMENT_ID = ELEMENT_ID + "_IMAGE_LIST";
	
	var count = $("#" + IMAGE_ELEMENT_ID + " li").length;
	count = count + 1;
	
	var objLi = document.createElement("li");
	objLi.id = "file_" + fileNm;
	objLi.DISP_FILE_NM = dispFileNm;
	objLi.FILE_NM = fileNm;
	objLi.FILE_SEQ = fileSeq;
	
	var objDiv = document.createElement("div");
	objDiv.setAttribute("class", "top");
	objDiv.id="file_" + fileNm + "_div"; 
		
	$(objDiv).append("<span>" + dispFileNm + "</span>");
		
	//다운로드
	objImg = document.createElement("img");
	objImg.setAttribute("src", "/common/uploadify/images/bt_down_s.gif");
	objImg.setAttribute("alt", "다운로드");
	objImg.setAttribute("style", "padding-right:2px");
	
	objImg.style.cursor = "pointer";
	objImg.onclick = function () {
		downFile(fileNm);
	};
	objDiv.appendChild(objImg);
	
	objLi.appendChild(objDiv);
	
	// 이미지
	var objImg = document.createElement("img");
	objImg.setAttribute("class", "images");
	
	objImg.style.width = "120px";
	objImg.style.height = "80px";
	
	objImg.style.cursor = "pointer";
	
	objImg.src = imgUrl + fileNm;
	
	objImg.onclick = function () {
		popWin(objImg.src, "img_preview", 800, 600, true);
	};
	
	objImg.setAttribute("title", dispFileNm);
	
	objLi.appendChild(objImg);

	document.getElementById(IMAGE_ELEMENT_ID).appendChild(objLi);
	
	jsDisplayElement(IMAGE_ELEMENT_ID);
}

function jsDrawFileDownload(ELEMENT_ID, dispFileNm, fileNm, fileSize, fileTypeOrg, fileSeq) {
	jsCheckCss();
	
	var FILE_ELEMENT_ID = ELEMENT_ID + "_FILE_LIST";
	
	// 전체 li
	var objLi = document.createElement("li");
	objLi.id = "file_" + fileNm;
	objLi.DISP_FILE_NM = dispFileNm;
	objLi.FILE_NM = fileNm;
	objLi.FILE_SEQ = fileSeq;

	// 파일 아이콘
	var objImg = document.createElement("img");
	objImg.setAttribute("src", "/common/uploadify/images/ico_file_def.gif");
	objImg.setAttribute("style", "padding-right:5px");
	objLi.appendChild(objImg);
	
	// 파일명
	var objSpan = document.createElement("span");
	objSpan.setAttribute("style", "padding-right:10px");
	
	objSpan.innerHTML = dispFileNm;
	objLi.appendChild(objSpan);

	//다운로드
	objImg = document.createElement("img");
	objImg.setAttribute("src", "/common/uploadify/images/bt_down_s.gif");
	objImg.setAttribute("alt", "다운로드");
	objImg.setAttribute("style", "padding-right:2px");
	
	objImg.style.cursor = "pointer";
	objImg.onclick = function () {
		downFile(fileNm);
	};
	
	objLi.appendChild(objImg);
	
	document.getElementById(FILE_ELEMENT_ID).appendChild(objLi);
	
	jsDisplayElement(FILE_ELEMENT_ID);
}

function jsDrawSeUpload(ELEMENT_ID, CATE, EDITOR_ELEMENT_ID) {
	$(document).ready(function() {
		jsCheckCss();

		$("#" + EDITOR_ELEMENT_ID).parent().append("<input id='" + ELEMENT_ID + "' name='" + ELEMENT_ID + "' type='file' multiple='true'>");
		
		//$(".CTNT").append("<input id='" + ELEMENT_ID + "' name='" + ELEMENT_ID + "' type='file' multiple='true'>");
		
		$('#' + ELEMENT_ID).uploadify({
			'swf' : '/com/uploadify/uploadify.swf',
			'uploader' : '/services/file/se_upload/',
			'buttonImage' : '/com/images/step_application/btn/bt_con_add.jpg',
			'button_image_url' : '/com/images/step_application/btn/bt_con_add.jpg',
			'width' : 70,
			'height' : 20,
			'multi': true,
			'fileTypeDesc' : 'Image Files',
	        'fileTypeExts' : '*.gif; *.jpg; *.png',
			'onUploadError'  : function(file, errorCode, errorMsg, errorString) {
				alert(file.name + ' 업로드가 불가능 합니다. \n불가사유\n' + errorString);
			},
			'onUploadSuccess': function(file, data, response) 
			{
				data = data.replace(/^[ /\n/\r]/g,"");
				data = eval( "("+ data + ")" );
				
				jsLoadImage(EDITOR_ELEMENT_ID, data.IMG_URL, data.FILE_NM);
			},
			'onInit': function(instance) {
				$("#" + ELEMENT_ID).hide();
				$("#" + ELEMENT_ID + "-queue").hide(); 
	        }
		});
	});
}

function jsDrawSetEditorUpload(ELEMENT_ID, CATE, EDITOR_ELEMENT_ID, INDEX) {
	$(document).ready(function() {
		jsCheckCss();

		$("#" + EDITOR_ELEMENT_ID).parent().append("<input id='" + ELEMENT_ID + "' name='" + ELEMENT_ID + "' type='file' multiple='true'>");
		
		//$(".CTNT").append("<input id='" + ELEMENT_ID + "' name='" + ELEMENT_ID + "' type='file' multiple='true'>");
		
		$('#' + ELEMENT_ID).uploadify({
			'swf' : '/com/uploadify/uploadify.swf',
			'uploader' : '/services/file/se_upload/',
			'buttonImage' : '/com/images/step_application/btn/bt_con_add.jpg',
			'button_image_url' : '/com/images/step_application/btn/bt_con_add.jpg',
			'width' : 70,
			'height' : 20,
			'multi': true,
			'fileTypeDesc' : 'Image Files',
	        'fileTypeExts' : '*.gif; *.jpg; *.png',
			'onUploadError'  : function(file, errorCode, errorMsg, errorString) {
				alert(file.name + ' 업로드가 불가능 합니다. \n불가사유\n' + errorString);
			},
			'onUploadSuccess': function(file, data, response) 
			{
				data = data.replace(/^[ /\n/\r]/g,"");
				data = eval( "("+ data + ")" );
				
				jsLoadEditorImage(EDITOR_ELEMENT_ID, data.IMG_URL, data.FILE_NM, INDEX);
			},
			'onInit': function(instance) {
				$("#" + ELEMENT_ID).hide();
				$("#" + ELEMENT_ID + "-queue").hide(); 
	        }
		});
	});
}

function jsLoadImage(EDITOR_ELEMENT_ID, imgUrl, file) {
	var FILE_NAME = imgUploadUrl + imgUrl + 'img_' + file;
	
	var image = new Image();
	image.src = FILE_NAME;
	
	if (image.complete) {
		jsPasteIMG(EDITOR_ELEMENT_ID, FILE_NAME, image);
      
      image.onload=function(){};
	} else {
		image.onload = function() {
			jsPasteIMG(EDITOR_ELEMENT_ID, FILE_NAME, image);
			
			// clear onLoad, IE behaves irratically with animated gifs otherwise
			image.onload=function(){};
		}
		image.onerror = function() {
			alert("Could not load image.");
		}
	}
}

function jsLoadEditorImage(EDITOR_ELEMENT_ID, imgUrl, file, INDEX) {
	var FILE_NAME = imgUploadUrl + imgUrl + 'img_' + file;
	
	var image = new Image();
	image.src = FILE_NAME;
	
	if (image.complete) {
		//alert("1 image.complete : " + image.complete);
		jsPasteEditorIMG(EDITOR_ELEMENT_ID, FILE_NAME, image, INDEX);
      
      image.onload=function(){};
	} else {
		image.onload = function() {
			//alert("2 image.complete : " + image.complete);
			// clear onLoad, IE behaves irratically with animated gifs otherwise
			image.onload=function(){};
			jsPasteEditorIMG(EDITOR_ELEMENT_ID, FILE_NAME, image, INDEX);
			
		}
		image.onerror = function() {
			alert("Could not load image.");
		}
	}
}

function jsPasteIMG(EDITOR_ELEMENT_ID, FILE_NAME, image) {
	var editor_width = eval(EDITOR_ELEMENT_ID + "_Editors").getById[EDITOR_ELEMENT_ID].getWYSIWYGDocument().body.scrollWidth;
	editor_width = Math.floor(editor_width * 0.7);
	
	var imgWidth = image.width;
	var imgHeight = image.height;

	var bxHeight = 0; // 가변
	var bxWidth = editor_width; // 기준이 되는 width 지정

	if ( imgWidth > bxWidth ) {
		bxHeight = ~~ ( imgHeight / imgWidth * bxWidth );
		
		imgWidth = bxWidth;
		imgHeight = bxHeight;
	}
	
	var IMG = '<img src="' + FILE_NAME + '" width="'+ imgWidth+ '" height="' + imgHeight + '"><br>';
	
	eval(EDITOR_ELEMENT_ID + "_Editors").getById[EDITOR_ELEMENT_ID].exec("PASTE_HTML", [IMG]);	
}

function jsPasteEditorIMG(EDITOR_ELEMENT_ID, FILE_NAME, image, INDEX) {
	var editor_body = document.getElementById("innoditor_"+INDEX).contentWindow.document.body;
	var editor_width = editor_body.clientWidth;
	editor_width = Math.floor(editor_width * 0.7);
	
	var imgWidth = image.width;
	var imgHeight = image.height;

	var bxHeight = 0; // 가변
	var bxWidth = editor_width; // 기준이 되는 width 지정

	if ( imgWidth > bxWidth ) {
		bxHeight = ~~ ( imgHeight / imgWidth * bxWidth );
		
		imgWidth = bxWidth;
		imgHeight = bxHeight;
	}
	
	//var IMG = '<img src="' + FILE_NAME + '" "><br>';
	
	// createElement(tagName) : 요소 노드 생성
	var objElement = document.createElement('img');
	objElement.setAttribute('src', FILE_NAME);
	objElement.setAttribute('alt', FILE_NAME);
	objElement.setAttribute('width', imgWidth);
	objElement.setAttribute('height', imgHeight);
	objElement.setAttribute('border', 0);

	//$("#"+EDITOR_ELEMENT_ID).append(IMG);
	var IMG = '<img src="' + FILE_NAME + '" width="' + imgWidth + ' height="' + imgHeight + '" alt="' + FILE_NAME + '" border=0/><br />';
	//fnAddHTMLContent(IMG, null, 0, INDEX);
	parent.pasteImageToEditor(IMG, objElement, INDEX);
}

function downFile(fileNm) {
	document.location.href = "/file/download.do?FILE_NM=" + fileNm;
}

/*function jsPasteIMG(EDITOR_ELEMENT_ID, imgUrl, file) {
	var thum = document.getElementById('ID_THUM_BASKET');
	var PASTE_FLAG = false;
	var IMG = "";
	var FILE_NAME = "";

	FILE_NAME = imgUploadUrl + imgUrl + 'img_' + file;

	var $img = $('<img>').attr('src', FILE_NAME);
	var $imgWrap = $('<div>').html($img).css({'width': '0', 'height': '0', 'overflow': 'hidden'});
	
	$('body').append($imgWrap);
	$img.on({
		load: function(){
			if($img.width() < 1) {
				IMG = '<img src="' + imgUploadUrl + imgUrl + 'img_' + file + '">';
			}
			else {
				var imgWidth = $img.width();
				var imgHeight = $img.height();

				var bxHeight = 0; // 가변
				var bxWidth = 660; // 기준이 되는 width 지정

				if ( imgWidth > bxWidth ) {
					bxHeight = ~~ ( imgHeight / imgWidth * bxWidth );
					
					imgWidth = bxWidth;
					imgHeight = bxHeight;
				}

				IMG = '<img src="' + imgUploadUrl + imgUrl + 'img_' + file +  '" width="'+ imgWidth+ '" height="' + imgHeight + '">';
			}

			PASTE_FLAG = true;
			
			$imgWrap.remove();
		}
	});
	
	if (PASTE_FLAG == false) {
		if(navigator.userAgent.match(/msie/i) && $.browser.version != "9.0") {
			if($img.width() < 1) {
				IMG = '<img src="' + imgUploadUrl + imgUrl + 'img_' + file + '">';
			} else {
				var imgWidth = $img.width();
				var imgHeight = $img.height();
	
				var bxHeight = 0; // 가변
				var bxWidth = 660; // 기준이 되는 width 지정
	
				if ( imgWidth > bxWidth ) {
					bxHeight = ~~ ( imgHeight / imgWidth * bxWidth );
					
					imgWidth = bxWidth;
					imgHeight = bxHeight;
				}

				IMG = '<img src="' + imgUploadUrl + imgUrl + 'img_' + file +  '" width="'+ imgWidth+ '" height="' + imgHeight + '">';
			}
			
			PASTE_FLAG = true;
		}
	}
	
	if (PASTE_FLAG == false) {
		IMG = '<img src="' + imgUploadUrl + imgUrl + 'img_' + file + '">';
	}
	
	IMG = IMG + "<br>";
	
	try {
		eval(EDITOR_ELEMENT_ID + "_Editors").getById[EDITOR_ELEMENT_ID].exec("PASTE_HTML", [IMG]);
	} catch(e) {
		var TYPE = "EDITOR_AREA_CONTAINER";
		var editor = $("#"+TYPE).find("iframe").contents().find("body");
		var html = $(editor).html() + IMG;
		$(editor).html(html);
	}
}*/