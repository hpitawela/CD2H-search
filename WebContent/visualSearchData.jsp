<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="lucene" uri="http://icts.uiowa.edu/lucene"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="rdf" uri="http://icts.uiowa.edu/RDFUtil"%>
<%@ taglib prefix="graph" uri="http://slis.uiowa.edu/graphtaglib"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@include file="statisticsLoad.jsp"%>

<c:choose>
	<c:when test="${param.mode == 'mixed'}">
		<c:set var="queryString" value="${param.query}" />
		<rdf:foreachConcept var="x" queryString="${param.query}">
			<rdf:concept>
				<c:set var="cui" scope="request"><rdf:conceptCUI /></c:set>
				<c:set var="queryString" value="${queryString} ${cui}" />
				<rdf:foreachSubconcept var="y">
					<c:set var="subcui" scope="request"><rdf:subconceptCUI /></c:set>
					<c:set var="queryString" value="${queryString} ${subcui}" />
				</rdf:foreachSubconcept>
			</rdf:concept>
		</rdf:foreachConcept>
		<c:set var="queryString" value="${fn:substring(queryString,0,4000)}"/>
	</c:when>
	<c:otherwise>
		<c:set var="queryString" value="${param.query}"/>
	</c:otherwise>
</c:choose>


<graph:graph>
	<lucene:search lucenePath="/usr/local/CD2H/lucene/federated_search" label="content" queryParserName="${param.mode}" queryString="${queryString}">
		<c:set var="count"><lucene:count /></c:set>
		<lucene:searchIterator limitCriteria="500">
			<c:set var="uri"><lucene:hit label="url"/></c:set>
			<c:set var="site"><lucene:hit label="site"/></c:set>
			<c:set var="first_name"><lucene:hit label="first_name" /></c:set>
			<c:set var="last_name"><lucene:hit label="last_name" /></c:set>
			<c:set var="label" value="${first_name} ${last_name}"/>
			<c:set var="score"><lucene:hit label="score"/></c:set>
			<graph:node uri="${uri}" label="${label}" group="${site}" score="${score}"/>
		</lucene:searchIterator>
	</lucene:search>
	
	<graph:edgeLookupFilter source="java:/comp/env/jdbc/VIVOTagLib" method="edu.uiowa.slis.graphtaglib.filters.ImplicitEdgeLookup" />
	    <c:forEach var="step" items="${fn:split(community_steps, ' ')}">
			<graph:graphColorer auxdouble="${step}" algorithm="edu.uiowa.slis.graphtaglib.CommunityDetection.LouvainWrapper"/>
			<graph:graphColorer auxdouble="${step}" algorithm="edu.uiowa.slis.graphtaglib.CommunityDetection.LouvainMultilevelRefinementWrapper"/>
			<graph:graphColorer auxdouble="${step}" algorithm="edu.uiowa.slis.graphtaglib.CommunityDetection.SmartLocalMovingWrapper"/>
	    </c:forEach>
	
	<c:choose>
		<c:when test="${empty param.radius}">
			<c:set var="param.radius" value="7000"/>
		</c:when>
	</c:choose>
	<c:choose>
		<c:when test="${not empty param.selectedNode}">
			<graph:nodeDistanceFilter source="java:/comp/env/jdbc/VIVOTagLib" radius="${param.radius}" selectedNode="${param.selectedNode}" />
		</c:when>
	</c:choose>
		
	{
	  "nodes":[
		<graph:foreachNode pruneOrphanThreshold="100" > 
			<graph:node auxDouble="${param.resolution}" coloring="${param.detectionAlg}">
			    {"url":"<graph:nodeUri/>","name":"<graph:nodeLabel/>","group":<graph:nodeGroup/>,"score":<graph:nodeScore/>,
			</graph:node>
			<graph:node auxDouble="${param.resolution}" coloring="site">
			    "site":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="0.01" coloring="Louvain">,
			    "Louvain001":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="0.1" coloring="Louvain">,
			    "Louvain01":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="1" coloring="Louvain">,
			    "Louvain1":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="10" coloring="Louvain">,
			    "Louvain10":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="100" coloring="Louvain">,
			    "Louvain100":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="0.01" coloring="LouvainMultilevelRefinement">,
			    "LouvainMultilevelRefinement001":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="0.1" coloring="LouvainMultilevelRefinement">,
			    "LouvainMultilevelRefinement01":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="1" coloring="LouvainMultilevelRefinement">,
			    "LouvainMultilevelRefinement1":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="10" coloring="LouvainMultilevelRefinement">,
			    "LouvainMultilevelRefinement10":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="100" coloring="LouvainMultilevelRefinement">,
			    "LouvainMultilevelRefinement100":<graph:nodeGroup/>
			</graph:node>
					<graph:node auxDouble="0.01" coloring="SmartLocalMoving">,
			    "SmartLocalMoving001":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="0.1" coloring="SmartLocalMoving">,
			    "SmartLocalMoving01":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="1" coloring="SmartLocalMoving">,
			    "SmartLocalMoving1":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="10" coloring="SmartLocalMoving">,
			    "SmartLocalMoving10":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="100" coloring="SmartLocalMoving">,
			    "SmartLocalMoving100":<graph:nodeGroup/>}<c:if test="${ ! isLastNode }">,</c:if>
			</graph:node>
		</graph:foreachNode>
		],
	  "links":[
	  	<graph:foreachEdge>
	  		<graph:edge>
			    {"source":<graph:edgeSource/>,"target":<graph:edgeTarget/>,"value":<graph:edgeWeight/>}<c:if test="${ ! isLastEdge }">,</c:if>
	  		</graph:edge>
	  	</graph:foreachEdge>
	  ],
	  "sites":[
		<graph:foreachSiteID>
			{"id":<graph:SiteID/>, "label":"<graph:SiteName/>"}<c:if test="${!isLastID}">,</c:if>
		</graph:foreachSiteID>
		]
	}
	
	
</graph:graph>
