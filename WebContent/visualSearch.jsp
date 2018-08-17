<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="lucene" uri="http://icts.uiowa.edu/lucene"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="rdf" uri="http://icts.uiowa.edu/RDFUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

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
                document.queryForm.action = 'visualSearch.jsp';
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
			<h2>Visualize Investigators from ${count_institutions} Institutions Related to Your Search Terms</h2>
			
			<c:set var="query_suffix" value=""/>
			<c:choose>
				<c:when test="${param.detectionAlg == 'site'}">
					<c:set var="detectionAlg" value="site"/>
					<c:set var="query_suffix" value="${query_suffix}&detectionAlg=site"/>
				</c:when>
				<c:when test="${param.detectionAlg == 'Louvain'}">
					<c:set var="detectionAlg" value="Louvain"/>
					<c:set var="query_suffix" value="${query_suffix}&detectionAlg=Louvain"/>
				</c:when>
				<c:when test="${param.detectionAlg == 'LouvainMultilevelRefinement'}">
					<c:set var="detectionAlg" value="LouvainMultilevelRefinement"/>
					<c:set var="query_suffix" value="${query_suffix}&detectionAlg=LouvainMultilevelRefinement"/>
				</c:when>
				<c:when test="${param.detectionAlg == 'SmartLocalMoving'}">
					<c:set var="detectionAlg" value="SmartLocalMoving"/>
					<c:set var="query_suffix" value="${query_suffix}&detectionAlg=SmartLocalMoving"/>
				</c:when>
				<c:otherwise>
					<c:set var="detectionAlg" value="site"/>
					<c:set var="query_suffix" value="${query_suffix}&detectionAlg=site"/>
				</c:otherwise>
			</c:choose>
			<c:choose>
				<c:when test="${not empty param.resolution}">
					<c:set var="resolution" value="${param.resolution}"/>
					<c:set var="query_suffix" value="${query_suffix}&resolution=${param.resolution}"/>
				</c:when>
				<c:otherwise>
					<c:set var="resolution" value="0.5"/>
					<c:set var="query_suffix" value="${query_suffix}&resolution=0.5"/>
				</c:otherwise>
			</c:choose>
			<c:choose>
				<c:when test="${param.mode == 'text'}">
					<c:set var="mode" value="text"/>
					<c:set var="query_suffix" value="${query_suffix}&mode=text"/>
				</c:when>
				<c:when test="${param.mode == 'mixed'}">
					<c:set var="mode" value="mixed"/>
					<c:set var="query_suffix" value="${query_suffix}&mode=mixed"/>
				</c:when>
				<c:otherwise>
					<c:set var="mode" value="concept"/>
					<c:set var="query_suffix" value="${query_suffix}&mode=concept"/>
				</c:otherwise>
			</c:choose>			
			
			<form method='GET' action='visualSearch.jsp'>
			<table>
				<tr>
					<td><fieldset><legend>Handling of query terms?</legend>
						<input type="radio" name="mode" value="text" <c:if test="${mode == 'text'}">checked</c:if> > Text only<br>
						<input type="radio" name="mode" value="concept" <c:if test="${mode == 'concept'}">checked</c:if> > UMLS concepts (including support for boolean search using &amp;, |, and !)<br>
					</fieldset></td>
				</tr>
				<tr>
					<td><fieldset><legend>Query?</legend>
						<input name="query" value="${param.query}" size=50> <input type=submit name=submitButton value=Search>
					</fieldset></td>
				</tr>
			</table>
			</form>
			<c:if test="${not empty param.query}">
				<c:choose>
					<c:when test="${param.mode == 'mixed'}">
						<h3>UMLS concepts recognized in your query:</h3>
						<c:set var="queryString" value="${param.query}"/>
						<c:set var="displayString" value="${param.query}"/>
						<ol class="bulletedList">
						<rdf:foreachConcept var="x" queryString="${param.query}">
							<rdf:concept>
								<li><a href="visualSearch.jsp?query=<rdf:conceptCUI/>"><rdf:conceptCUI/></a> - <rdf:conceptPhrase/>
							</rdf:concept>
						</rdf:foreachConcept>
						</ol>
					</c:when>
					<c:when test="${param.mode == 'concept'}">
						<jsp:include page="conceptHierarchy.jsp" flush="true">
							<jsp:param name="target_page" value="visualSearch.jsp" />
						</jsp:include>
					</c:when>
					<c:otherwise>
						<c:set var="queryString" value="${param.query}" scope="session"/>
						<c:set var="displayString" value="${param.query}"/>
					</c:otherwise>
				</c:choose>
				<c:url var="encodedURL" value="textSearch.jsp">
					<c:param name="mode" value="${param.mode}"/>
					<c:param name="query" value="${param.query}"/>
				</c:url>
				<h3><a href="${encodedURL}">Table view of this query</a></h3><p/>
				<c:set var="host"><util:requestingHost/></c:set>
				<util:Log line="" message="requesting host: ${host}" page="visualSearch" level="INFO"></util:Log>
				<util:Log line="" message="query: ${displayString}" page="visualSearch" level="INFO"></util:Log>
				<h3>Coauthorship amongst the most relevant investigators matching your query.</h3>
				<p>Node colors and symbols correspond to institutional affiliations (legend at left).
				Node size corresponds proportionally to the node's search score.
				Edge thickness corresponds to number of shared papers.
				<b>Hover</b> over a node to see that investigator's name.
				<b>Double click</b> on a node to go to the institutional profile for that investigator.
				<b>Drag</b> a node to reposition it and its neighbors.</p>
				<p><i><b>Note:</b> search terms with large numbers of subconcepts (e.g., cancer) currently must truncate the list of subconcepts due to protocol limitations.
				Graphs with large (&gt;200) nodes will have singleton nodes pruned.</i></p>

            <div id="content">
                <div id="graph"></div>
            </div>
				<c:url var="encodedMapURL" value="visualSearchData.jsp">
					<c:param name="detectionAlg" value="site"/>
					<c:param name="resolution" value="1"/>
					<c:param name="mode" value="${param.mode}"/>
					<c:param name="query" value="${param.query}"/>
					<c:param name="selectedNode" value="${param.selectedNode}"/>
					<c:param name="radius" value="${param.radius}"/>
				</c:url>
				<jsp:include page="graphs/forceGraph.jsp" flush="true">
					<jsp:param name="charge" value="-50" />
					<jsp:param name="ld" value="30" />
					<jsp:param name="data_page" value="${encodedMapURL}" />
					<jsp:param name="detectionAlg" value="${param.detectionAlg}"/>
				</jsp:include>
			</c:if>
        <jsp:include page="footer.jsp" flush="true" />
    </div>
</body>

</html>
