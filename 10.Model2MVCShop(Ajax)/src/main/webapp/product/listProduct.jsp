<%@ page contentType="text/html; charset=EUC-KR" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<title>상품 목록조회</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<link rel="stylesheet" href="//code.jquery.com/ui/1.13.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-3.6.0.js"></script>
<script src="https://code.jquery.com/ui/1.13.1/jquery-ui.js"></script>

<script type="text/javascript">

	// 검색 / page 두가지 경우 모두 Form 전송을 위해 JavaScript 이용
	function fncGetList(currentPage){
		$("#currentPage").val(currentPage);
		$("form").attr("method", "POST").attr("action", "/product/listProduct").submit();
	}
	
	$(function(){
				
		$("td.ct_btn01:contains('검색')").on("click", function(){
			fncGetList(1);
		});
		
		$(".ct_list_pop td:nth-child(3)").on("click", function(){
			
			var pageLink = ($("input[name='menu']").val() == "manage") ? "/product/updateProduct" : "/product/getProduct" ;	
			console.log($(this).attr("value"));
			
			self.location = pageLink + "?prodNo=" + $(this).attr("value") + "&menu=" + $("input[name='menu']").val();
		});
		
		$(".ct_list_pop td:nth-child(3)").css("color" , "blue");
		
		$(".ct_list_pop:nth-child(4n+6)").css("background-color" , "whitesmoke");
		
		$("#keyword").autocomplete({
			source: function(request, response){
				$.ajax({
					url : "/product/json/productNameList/" + $("#keyword").val(),
					type : "GET",
					success : function(data){
						response(
							$.map(data, function(item){
								console.log("item : " + item);
								return{
									label : item,
									value : item
									
								};
							})		
						);
					},
					error : function(){
						console.log("error");
					}
					
				});
			},
			minLength : 1,
	        select : function(evt, ui) {
	            console.log("전체 data: " + JSON.stringify(ui));
	            console.log("db Index : " + ui.item.idx);
	            console.log("검색 데이터 : " + ui.item.value);
	        }, 
	        focus : function(evt, ui) {
	            return false;
	        },
	        close : function(evt) {
	        }
	    });
		
	});

</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width:98%; margin-left:10px;">

<form name="detailForm">

<input type="hidden" name="menu" value="${ menu }" />

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37">
			<img src="/images/ct_ttl_img01.gif" width="15" height="37"/>
		</td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left:10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">
						${ ! empty menu && menu == "manage" ? "상품 관리" : "상품 목록조회" }					
					</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37">
			<img src="/images/ct_ttl_img03.gif" width="12" height="37"/>
		</td>
	</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="right">
			<select name="searchCondition" class="ct_input_g" style="width:80px">
				<option value="0" ${ ! empty search.searchCondition && search.searchCondition==0 ? "selected" : "" }>상품번호</option>
				<option value="1" ${ ! empty search.searchCondition && search.searchCondition==1 ? "selected" : "" }>상품명</option>
				<option value="2" ${ ! empty search.searchCondition && search.searchCondition==2 ? "selected" : "" }>상품가격</option>
			</select>
			<input type="text" id="keyword" name="searchKeyword" 
						value="${! empty search.searchKeyword ? search.searchKeyword : ""}"  
						class="ct_input_g" style="width:200px; height:20px" > 
		</td>
		<td align="right" width="70">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="17" height="23">
						<img src="/images/ct_btnbg01.gif" width="17" height="23">
					</td>
					<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top:3px;">
						<!--  <a href="javascript:fncGetProductList('1');">검색</a> -->
						검색
					</td>
					<td width="14" height="23">
						<img src="/images/ct_btnbg03.gif" width="14" height="23">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td colspan="11" >전체 ${ resultPage.totalCount } 건수, 현재 ${ resultPage.currentPage } 페이지</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">상품명</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">가격</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">등록일</td>	
		<td class="ct_line02"></td>
		<td class="ct_list_b">현재상태</td>	
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>
	<c:set var="i" value="0" />
	<c:forEach var="product"  items="${ list }">
		<c:set var="i" value="${ i+1 }" />
		<tr class="ct_list_pop">			
			<td align="center">${ i }</td>
			<td></td>
			<td align="left" value="${ product.prodNo }">
			<!-- 
				<a href="${ menu == 'manage' ? '/product/updateProduct' : '/product/getProduct'}?prodNo=${  product.prodNo }&menu=${ menu }">
					${ product.prodName }
				</a>
			 -->
			 	<!-- <input type="hidden" name="prodNo" value="${ product.prodNo }"> -->			 	
				${ product.prodName }
			</td>
			<td></td>
			<td align="left">${ product.price }</td>
			<td></td>
			<td align="left">${ product.regDate }</td>
			<td></td>
			<td align="left">
				<c:choose>
					<c:when test="${ product.proTranCode != '001' }">
						판매 완료
					</c:when>
					<c:otherwise>
						판매중
					</c:otherwise>
				</c:choose>		
			</td>	
		</tr>	
		<tr>
			<td colspan="11" bgcolor="D6D7D6" height="1"></td>
		</tr>	
	</c:forEach>		
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="center">
			<input type="hidden" id="currentPage" name="currentPage" value=""/>
	
			<jsp:include page="../common/pageNavigator.jsp"/>
    	</td>
	</tr>
</table>
<!--  페이지 Navigator 끝 -->

</form>
</div>

</body>
</html>