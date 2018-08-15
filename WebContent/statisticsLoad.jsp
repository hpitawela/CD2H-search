<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<jsp:include page="resources/jdbc_environment.jsp" />

<sql:query var="nodes" dataSource="jdbc/RDFUtil">
		select 'count_'||metric as metric,count from ${aggregated}.statistics;
</sql:query>
<c:forEach items="${nodes.rows}" var="row" varStatus="rowCounter">
	<c:if test="${row.metric == 'count_systems'}">
		<c:set var="count_systems" value="${row.count}"/>
	</c:if>
	<c:if test="${row.metric == 'count_sparql'}">
		<c:set var="count_sparql" value="${row.count}"/>
	</c:if>
	<c:if test="${row.metric == 'count_crawled'}">
		<c:set var="count_crawled" value="${row.count}"/>
	</c:if>
	<c:if test="${row.metric == 'count_institutions'}">
		<c:set var="count_institutions" value="${row.count + institutions_offset}"/>
	</c:if>
	<c:if test="${row.metric == 'count_persons'}">
		<c:set var="count_persons" value="${row.count}"/>
	</c:if>
	<c:if test="${row.metric == 'count_lower_profiles'}">
		<c:set var="count_lower_profiles" value="${row.count}"/>
	</c:if>
	<c:if test="${row.metric == 'count_upper_profiles'}">
		<c:set var="count_upper_profiles" value="${row.count}"/>
	</c:if>
	<c:if test="${row.metric == 'count_publications'}">
		<c:set var="count_publications" value="${row.count}"/>
	</c:if>
	<c:if test="${row.metric == 'count_authorships'}">
		<c:set var="count_authorships" value="${row.count}"/>
	</c:if>
	<c:if test="${row.metric == 'count_coauthorships'}">
		<c:set var="count_coauthorships" value="${row.count}"/>
	</c:if>
	<c:if test="${row.metric == 'count_ctsas'}">
		<c:set var="count_ctsas" value="${row.count}"/>
	</c:if>
</c:forEach>
