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
	<jsp:include page="header.jsp" flush="true" />

	<div class="container pl-0 pr-0">
		<br /> <br /> <br /> <br /> <br />
		<div class="container-fluid">
			<h3>Faceted Search</h3>
			<div id=form>
				<form method='POST' action='facetSearch.jsp'>
					<table>
						<tr>
							<td><fieldset>
									<legend>Query?</legend>
									<input name="query" value="${param.query}" size=50> <input type=submit name=submitButton value=Search>
								</fieldset></td>
						</tr>
					</table>
				</form>
				<a href="facetSearch.jsp">reset</a>
			</div>
			<br />
			<c:choose>
			<c:when test="${not empty param.query}">
				<p />
				<c:set var="host"><util:requestingHost /></c:set>
				<util:Log line="" message="requesting host: ${host}" page="ctsaSearch" level="INFO"></util:Log>
				<util:Log line="" message="query: ${param.query}"	page="ctsaSearch" level="INFO"></util:Log>
				<h3>Search Results:	<c:out value="${displayString}" /></h3>

				<lucene:taxonomy taxonomyPath="/usr/local/CD2H/lucene/facet_test_tax">
					<lucene:countFacetRequest categoryPath="Source" depth="3" />
					<lucene:countFacetRequest categoryPath="Entity" depth="3" />
					<lucene:countFacetRequest categoryPath="Site" depth="3" />
					<lucene:countFacetRequest categoryPath="CTSA" />
                    <lucene:countFacetRequest categoryPath="Learning Level" />
                    <lucene:countFacetRequest categoryPath="Assessment Method" />
                    <lucene:countFacetRequest categoryPath="Competency Domain" />
                    <lucene:countFacetRequest categoryPath="Delivery Method" />
                    <lucene:countFacetRequest categoryPath="Status" />
                    <lucene:countFacetRequest categoryPath="Phase" />
                    <lucene:countFacetRequest categoryPath="Type" />
                    <lucene:countFacetRequest categoryPath="Condition" />
					
					<c:set var="drillDownList"><lucene:drillDownProcessor categoryPaths="${param.drillDown}" drillUpCategory="${param.drillUp}" drillOutCategory="${param.drillOut}" /></c:set>

					<lucene:search lucenePath="/usr/local/CD2H/lucene/facet_test" label="content" queryParserName="boolean" queryString="${param.query}" useConjunctionByDefault="true">
						<div style="with: 100%">
							<div style="width: 40%; padding: 0px 120px 0px 0px; float: left">
								<h5>Facets:</h5>
								<ol class="bulletedList">
									<lucene:facetIterator>
										<c:set var="facet1"><lucene:facet label="content" /></c:set>
										<li><lucene:facet label="content"> (<lucene:facet label="count" />)
                                            <ol class="bulletedList">
													<lucene:facetIterator>
														<c:set var="facet2path">${facet1}/<lucene:facet	label="content" /></c:set>
														<c:set var="facet2"><lucene:facet label="content" /></c:set>
														<lucene:facet label="none">
															<c:choose>
																<c:when	test="${fn:contains(drillDownList, facet2path.concat('|'))}">
																	<li><lucene:facet label="content" /> <a	href="facetSearch.jsp?query=${param.query}&drillDown=${drillDownList}&drillUp=${facet2path}">x</a>
																</c:when>
																<c:when test="${fn:contains(drillDownList, facet2path)}">
																	<li><lucene:facet label="content" />
																</c:when>
																<c:otherwise>
																	<li><a href="facetSearch.jsp?query=${param.query}&drillDown=${drillDownList}${facet2path}">${facet2}</a> (<lucene:facet label="count" />)
																</c:otherwise>
															</c:choose>
															<ol class="bulletedList">
																<lucene:facetIterator>
																	<c:set var="facet3path">${facet2path}/<lucene:facet	label="content" /></c:set>
																	<c:set var="facet3"><lucene:facet label="content" /></c:set>
																	<lucene:facet label="none">
																		<c:choose>
																			<c:when	test="${fn:contains(drillDownList, facet3path.concat('|'))}">
																				<li><lucene:facet label="content" />
																				<a	href="facetSearch.jsp?query=${param.query}&drillDown=${drillDownList}&drillOut=${facet3path}">&larr;</a>
		                                                                      <a  href="facetSearch.jsp?query=${param.query}&drillDown=${drillDownList}&drillUp=${facet3path}">x</a>
        																	</c:when>
																			<c:when	test="${fn:contains(drillDownList, facet3path)}">
																				<li><lucene:facet label="content" />
																			</c:when>
																			<c:otherwise>
																				<li><a	href="facetSearch.jsp?query=${param.query}&drillDown=${drillDownList}${facet3path}">${facet3}</a> (<lucene:facet label="count" />)
																			</c:otherwise>
																		</c:choose></li>
										                              </lucene:facet>
									                           </lucene:facetIterator>
								                            </ol>
								                            </li>
								                        </lucene:facet>
								                    </lucene:facetIterator>
								                </ol>
								                    </lucene:facet>
								                </li>
								        </lucene:facetIterator>
								</ol>
							</div>
							<div style="width: 60%; float: left">
								<p>Result Count: <lucene:count /></p>
								<ol class="bulletedList">
									<lucene:searchIterator>
										<li><a href="<lucene:hit label="uri" />"><lucene:hit label="label" /></a> [<lucene:hit label="source" />]</li>
									</lucene:searchIterator>
								</ol>
							</div>
						</div>
					</lucene:search>
				</lucene:taxonomy>
			</c:when>
			<c:otherwise>
				This proof-of-concept explores multi-faceted search across multiple federated sources, both internal to CD2H and the CTSA Consortium and more broadly across the entire informatics community.
				Comments and questions are welcome! We are particularly interested in feedback regarding the nature and organization of the facets used to filter search results. The facet taxonomy is readily
				restructured as we index data.
				<p>
				<h4>Sources and Entity Types</h4>
				<ol class="bulletedList">
					<li>ClinicalTrials.gov <i>(241,633 entries)</i>
					<ol class="bulletedList">
						<li>Clinical Trial
						<li>Official Contact
					</ol>
					<li>CTSAsearch <i>(650,112 entries)</i>
					<ol class="bulletedList">
						<li>Person
					</ol>
					<li>DataMed.org (bioCADDIE) <i>(1,252,785 entries)</i>
					<ol class="bulletedList">
						<li>Data Set
					</ol>
					<li>GitHub <i>(1,235 entries)</i>
					<ol class="bulletedList">
						<li>User
						<li>Organization
						<li>Repository
					</ol>
					<li>N-Lighten <i>(66 entries)</i>
					<ol class="bulletedList">
						<li>User
						<li>Organization
						<li>Educational Resource
					</ol>
					<li>DIAMOND <i>(95 entries)</i>
					<ol class="bulletedList">
						<li>Assessment
						<li>Training Material
					</ol>
					<li>NIH Funding Opportunity Announcements <i>(1,220 entries)</i>
					<ol class="bulletedList">
						<li>FOA
					</ol>
				</ol>
			</c:otherwise>
			</c:choose>
		</div>
	</div>
</body>

</html>
