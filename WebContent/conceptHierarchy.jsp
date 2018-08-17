<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="lucene" uri="http://icts.uiowa.edu/lucene"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="rdf" uri="http://icts.uiowa.edu/RDFUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="rewrittenQuery"	value="${fn:replace(param.query,'(', ' ( ')}" />
<c:set var="rewrittenQuery"	value="${fn:replace(rewrittenQuery,')', ' ) ')}" />
<c:set var="rewrittenQuery"	value="${fn:replace(rewrittenQuery,'&', ' & ')}" />
<c:set var="rewrittenQuery"	value="${fn:replace(rewrittenQuery,'|', ' | ')}" />
<c:set var="rewrittenQuery"	value="${fn:replace(rewrittenQuery,'!', ' ! ')}" />

<h3>UMLS concepts recognized in your query:</h3>

<ol class="bulletedList">
	<rdf:foreachConcept var="x" queryString="${rewrittenQuery}">
		<rdf:concept>
			<c:set var="concept"><rdf:conceptPhrase /></c:set>
			<c:set var="cui"><rdf:conceptCUI /></c:set>
			<li><a href="${param.target_page}?mode=concept&query=${fn:replace(fn:replace(param.query,'&','%26'), concept, cui)}${query_suffix}"><rdf:conceptCUI /></a>	- <rdf:conceptPhrase />
			<ol class="bulletedList">
				<li>Super concepts:
					<ol class="bulletedList">
						<rdf:foreachSuperconcept var="">
							<c:set var="supercui"><rdf:superconceptCUI /></c:set>
							<li><a href="${param.target_page}?mode=concept&query=${fn:replace(fn:replace(fn:replace(param.query,'&','%26'), concept, supercui), cui, supercui)}${query_suffix}"><rdf:superconceptCUI /></a> - <rdf:superconceptPhrase />
						</rdf:foreachSuperconcept>
					</ol>
				</li>
				<li>Sub concepts:
					<ol class="bulletedList">
						<rdf:foreachSubconcept var="">
							<c:set var="subcui"><rdf:subconceptCUI /></c:set>
							<li><a href="${param.target_page}?mode=concept&query=${fn:replace(fn:replace(fn:replace(param.query,'&','%26'), concept, subcui), cui, subcui)}${query_suffix}"><rdf:subconceptCUI /></a> - <rdf:subconceptPhrase />
						</rdf:foreachSubconcept>
					</ol>
				</li>
			</ol>
		</rdf:concept>
	</rdf:foreachConcept>
</ol>

<c:set var="queryString" value="${param.query}" scope="session" />
<c:set var="displayString" value="${param.query}" />
