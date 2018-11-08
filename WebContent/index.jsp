<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<%@include file="statisticsLoad.jsp"%>
<!DOCTYPE html>
<html lang="en-US">
<jsp:include page="head.jsp" flush="true">
	<jsp:param name="title" value="CTSAsearch" />
</jsp:include>
<style type="text/css" media="all">
@import "resources/layout.css";
</style>

<body class="home page-template-default page page-id-6 CD2H">
<script type="text/javascript">
	var pressed = false;
	
	function alterAction() {
		if (pressed)
			document.queryForm.action= 'visualSearch.jsp';
		else
			document.queryForm.action = 'textSearch.jsp';
		return true;
	}
</script>
		<jsp:include page="header.jsp" flush="true" />

    <div class="container pl-0 pr-0">
    <br/>
    <br/>
    <br/>
    <br/>
    <br/>
<div class="container-fluid">

<h2>What is CTSAsearch?</h2>


		<p>CTSAsearch is a federated search engine using Linked Open Data
			published by members of the CTSA Consortium and other interested
			parties. To try it out, use the form below.</p>
			
			<p>The CD2H faceted search prototype is available <a href="facetSearch.jsp">here.</a></p>

<c:set var="displayMode" value="bar"/>
<c:if test="${not empty param.mode}">
	<c:set var="displayMode" value="${param.mode}"/>	
</c:if>


<h2>Search for Investigators at ${count_institutions} Institutions</h2>
<form name="queryForm" method='POST' onsubmit="return alterAction();">
	<input type="hidden" name="detectionAlg" value="site" />
	<table border="0">
		<tr>
			<td>
				<fieldset><legend>Visualize?</legend>
				<input type="checkbox" id="checker" name="checker" onclick="pressed = !pressed;" /> Display graph&nbsp;&nbsp;&nbsp;
				</fieldset>
			</td>
			<td>
				<fieldset><legend>Handling of query terms?</legend>
				<input type="radio" name="mode" value="text" checked> Text only<br>
				<input type="radio" name="mode" value="concept"> UMLS concepts (including support for boolean search using &amp;,|, and !)
				</fieldset>
			</td>
		</tr>
		<tr>
			<td colspan=2>
				<fieldset><legend>Query?</legend>
				<input name="query" value="${param.query}" size=50> <input type=submit name=submitButton value=Search>
				</fieldset>
			</td>
		</tr>
	</table>
</form>
			</div>
		<jsp:include page="footer.jsp" flush="true" />
</body>

</html>
