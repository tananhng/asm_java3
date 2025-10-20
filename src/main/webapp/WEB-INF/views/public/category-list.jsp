<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="cp" value="${pageContext.request.contextPath}" />
<c:set var="categoryName" value="${empty list ? (empty param.cat ? 'Chuyên mục' : param.cat) : list[0].categoryName}" />

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<main class="container">
  <!-- Tiêu đề chuyên mục -->
  <h2>
    <fmt:message key="category.title">
      <fmt:param value="${categoryName}" />
    </fmt:message>
  </h2>

  <c:choose>
    <c:when test="${empty list}">
      <p style="margin-top: 2rem;">
        <em><fmt:message key="category.empty"/></em>
      </p>
    </c:when>

    <c:otherwise>
      <div class="cards" style="margin-top: 1.5rem;">
        <c:forEach var="n" items="${list}">
          <article class="card">
            <c:url var="detailUrl" value="/users">
              <c:param name="view" value="detail"/>
              <c:param name="id"   value="${n.id}"/>
            </c:url>

            <a href="${detailUrl}">
              <c:choose>
                <c:when test="${not empty n.image}">
                  <img src="${cp}/${n.image}" alt="${n.title}">
                </c:when>
                <c:otherwise>
                  <img src="${cp}/assets/img/placeholder.jpg" alt="${n.title}">
                </c:otherwise>
              </c:choose>
            </a>
            <h3><a href="${detailUrl}">${n.title}</a></h3>
          </article>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>

  <c:url var="backUrl" value="/users">
    <c:param name="view" value="list"/>
  </c:url>
  <p style="margin-top: 2rem;">
    <a href="${backUrl}">← <fmt:message key="nav.home"/></a>
  </p>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
