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
        Ngày đăng:
        <c:choose>
          <c:when test="${not empty news.postedDate}">
            <fmt:formatDate value="${news.postedDate}" pattern="dd/MM/yyyy HH:mm" />
          </c:when>
          <c:otherwise>—</c:otherwise>
        </c:choose>
        · Lượt xem: ${news.viewCount}
      </small>
    </p>

    <c:if test="${not empty news.image}">
      <img class="cover" src="${cp}/${news.image}" alt="${news.title}" style="max-width:100%;height:auto;">
    </c:if>

    <div class="content">
      <!-- Nếu content là HTML đã sanitize, cho phép render HTML -->
      <c:out value="${news.content}" escapeXml="false"/>
    </div>
  </article>

  <aside class="sidebar" style="margin-top:2rem">
    <h3>Bài hot</h3>
    <ul>
      <c:forEach var="n" items="${listTop5View}">
        <li><a href="${cp}/users?view=detail&id=${n.id}">${n.title}</a></li>
      </c:forEach>
      <c:if test="${empty listTop5View}">
        <li><em>Chưa có dữ liệu</em></li>
      </c:if>
    </ul>

    <h3>Mới nhất</h3>
    <ul>
      <c:forEach var="n" items="${listTop5Date}">
        <li><a href="${cp}/users?view=detail&id=${n.id}">${n.title}</a></li>
      </c:forEach>
      <c:if test="${empty listTop5Date}">
        <li><em>Chưa có dữ liệu</em></li>
      </c:if>
    </ul>
  </aside>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
