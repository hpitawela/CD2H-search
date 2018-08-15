<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="vivo" scope="request" value="vivo" />
<c:set var="aggregated" scope="request" value="vivo_aggregated" />
<c:set var="bd2k" scope="request" value="bd2k" />
<c:set var="analytics" scope="request" value="analytics" />
<c:set var="exporter" scope="request" value="nih_exporter" />
<c:set var="medline" scope="request" value="medline16" />

<c:set var="institutions_offset" scope="request" value="${0+7}" />
<c:set var="community_steps" scope="request" value="0.01 0.1 1 10 100" />
