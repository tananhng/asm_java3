<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<c:set var="cp" value="${pageContext.request.contextPath}" />

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<main class="container">
  <article class="news-detail">
    <h1>${news.title}</h1>

    <p class="meta">
      <small>
        <fmt:message key="detail.date"/>:
        <c:choose>
          <c:when test="${not empty news.postedDate}">
            <fmt:formatDate value="${news.postedDate}" pattern="dd/MM/yyyy HH:mm" />
          </c:when>
          <c:otherwise>—</c:otherwise>
        </c:choose>
        · <fmt:message key="detail.views"/>: ${news.viewCount}
      </small>
    </p>

    <c:if test="${not empty news.image}">
      <img class="cover" src="${cp}/${news.image}" alt="${news.title}" style="max-width:100%;height:auto;">
    </c:if>

    <div class="content">
      <!-- Nếu content đã được sanitize thì cho phép render HTML -->
      <c:out value="${news.content}" escapeXml="false"/>
    </div>
  </article>

  <aside class="sidebar" style="margin-top:2rem">
    <!-- Bài hot -->
    <h3><fmt:message key="detail.hot"/></h3>
    <ul>
      <c:choose>
        <c:when test="${not empty homeMost}">
          <c:forEach var="n" items="${homeMost}">
            <c:url var="detailUrl" value="/users">
              <c:param name="view" value="detail"/>
              <c:param name="id"   value="${n.id}"/>
            </c:url>
            <li><a href="${detailUrl}">${n.title}</a></li>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <li><em><fmt:message key="home.empty"/></em></li>
        </c:otherwise>
      </c:choose>
    </ul>

    <!-- Mới nhất -->
    <h3><fmt:message key="detail.latest"/></h3>
    <ul>
      <c:choose>
        <c:when test="${not empty homeLatest}">
          <c:forEach var="n" items="${homeLatest}">
            <c:url var="detailUrl" value="/users">
              <c:param name="view" value="detail"/>
              <c:param name="id"   value="${n.id}"/>
            </c:url>
            <li><a href="${detailUrl}">${n.title}</a></li>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <li><em><fmt:message key="home.empty"/></em></li>
        </c:otherwise>
      </c:choose>
    </ul>
  </aside>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
