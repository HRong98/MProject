<%@ tag language="java" pageEncoding="UTF-8"%>
							<!-- 주소 검색 버튼 및 입력 필드 -->
<input type="button" onclick="sample2_execDaumPostcode()" value="우편번호 찾기"><br> 
<input type="text" id="sample2_postcode" placeholder="우편번호"><br> 
<input type="text" id="sample2_address" name="storeAddress" value="${storeData.storeDefaultAddress}" placeholder="주소"><br> 
<input type="text" id="storeAddressDetail" name="storeAddressDetail" value="${storeData.storeDetailAddress}" placeholder="상세 주소"><br>

<!-- iOS에서는 position:fixed 버그가 있음, 적용하는 사이트에 맞게 position:absolute 등을 이용하여 top,left값 조정 필요 -->
<div id="layer"
    style="display: none; position: fixed; overflow: hidden; z-index: 1; -webkit-overflow-scrolling: touch;">
    <img src="//t1.daumcdn.net/postcode/resource/images/close.png"
        id="btnCloseLayer"
        style="cursor: pointer; position: absolute; right: -3px; top: -3px; z-index: 1"
        onclick="closeDaumPostcode()" alt="닫기 버튼">
</div>

<!-- 다음 우편번호 API 스크립트 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    var element_layer = document.getElementById('layer');

    function closeDaumPostcode() {
        element_layer.style.display = 'none';
    }

    function sample2_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                // 주소 유형에 따라 처리
                if (data.userSelectedType === 'R') { 
                    addr = data.roadAddress;
                } else { 
                    addr = data.jibunAddress;
                }

                // 도로명 주소일 때 참고 항목 추가
                if (data.userSelectedType === 'R') {
                    if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
                        extraAddr += data.bname;
                    }
                    if (data.buildingName !== '' && data.apartment === 'Y') {
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    if (extraAddr !== '') {
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    document.getElementById("sample2_extraAddress").value = extraAddr;
                } else {
                    document.getElementById("sample2_extraAddress").value = '';
                }

                // 우편번호와 주소 입력
                document.getElementById('sample2_postcode').value = data.zonecode;
                document.getElementById("sample2_address").value = addr;
                document.getElementById("storeAddressDetail").focus();

                // 레이어 닫기
                element_layer.style.display = 'none';
            },
            width: '100%',
            height: '100%',
            maxSuggestItems: 5
        }).embed(element_layer);

        // 레이어 보이기
        element_layer.style.display = 'block';
        initLayerPosition();
    }

    // 레이어 중앙 배치 함수
    function initLayerPosition(){
        var width = 800; 
        var height = 400; 
        var borderWidth = 5; 

        element_layer.style.width = width + 'px';
        element_layer.style.height = height + 'px';
        element_layer.style.border = borderWidth + 'px solid';

        element_layer.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width)/2 - borderWidth) + 'px';
        element_layer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height)/2 - borderWidth) + 'px';
    }
</script>
