<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<c:set var="cp" value="${pageContext.request.contextPath}" />

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<main class="container">
<section class="hero">
  <h2>Chào mừng đến với ABC News</h2>
  <div class="cards">
    <c:if test="${not empty list}">
      <c:forEach var="n" items="${list}" begin="0" end="2">
        <article class="card">
          <a href="${cp}/users?view=detail&id=${n.id}">
            <c:choose>
              <c:when test="${not empty n.image}">
                <img src="${cp}/${n.image}" alt="${n.title}">
              </c:when>
              <c:otherwise>
                <img src="${cp}/assets/img/placeholder.jpg" alt="${n.title}">
              </c:otherwise>
            </c:choose>
          </a>
          <h3><a href="${cp}/users?view=detail&id=${n.id}">${n.title}</a></h3>
        </article>
      </c:forEach>
    </c:if>
  </div>
</section>

<section class="grid-3" style="margin-top:1.25rem">
  <div>
    <h3>Hot nhất (Top 5)</h3>
    <ol class="list">
      <c:forEach var="n" items="${listTop5View}">
        <li>
          <a href="${cp}/users?view=detail&id=${n.id}">${n.title}</a>
          <small> — <fmt:formatDate value="${n.postedDate}" pattern="dd/MM/yyyy"/></small>
        </li>
      </c:forEach>
      <c:if test="${empty listTop5View}">
        <li><em>Chưa có dữ liệu</em></li>
      </c:if>
    </ol>
  </div>

  <div>
    <h3>Mới nhất (Top 5)</h3>
    <ul class="list">
      <c:forEach var="n" items="${listTop5Date}">
        <li>
          <a href="${cp}/users?view=detail&id=${n.id}">${n.title}</a>
          <small> — <fmt:formatDate value="${n.postedDate}" pattern="dd/MM/yyyy"/></small>
        </li>
      </c:forEach>
      <c:if test="${empty listTop5Date}">
        <li><em>Chưa có dữ liệu</em></li>
      </c:if>
    </ul>
  </div>

  <div>
    <h3>Đã xem gần đây</h3>
    <ul class="list">
      <c:choose>
        <c:when test="${empty recent}">
          <li><em>Chưa có bài nào</em></li>
        </c:when>
        <c:otherwise>
          <c:forEach var="n" items="${recent}">
            <li><a href="${cp}/users?view=detail&id=${n.id}">${n.title}</a></li>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </ul>
  </div>
</section>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
