<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="cp" value="${pageContext.request.contextPath}" />
<c:set var="categoryName" value="Chuyên mục" />
<c:if test="${not empty list}">
  <c:set var="categoryName" value="${list[0].categoryName}" />
</c:if>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<main class="container">
  <%-- Hiển thị tên chuyên mục một cách động --%>
  <h2>Tin tức chuyên mục: <em>${categoryName}</em></h2>

  <c:choose>
    <%-- Nếu danh sách tin tức (list) rỗng --%>
    <c:when test="${empty list}">
      <p style="margin-top: 2rem;"><em>Chưa có bài viết nào trong chuyên mục này.</em></p>
    </c:when>

    <%-- Nếu có tin tức, dùng vòng lặp để hiển thị --%>
    <c:otherwise>
      <div class="cards" style="margin-top: 1.5rem;">
        <c:forEach var="n" items="${list}">
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
      </div>
    </c:otherwise>
  </c:choose>

  <%-- Link quay về trang chủ --%>
  <p style="margin-top: 2rem;">
    <a href="<c:url value='/users'><c:param name='view' value='list'/></c:url>">← Quay về trang chủ</a>
  </p>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />