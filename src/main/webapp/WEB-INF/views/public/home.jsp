<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<c:set var="cp" value="${pageContext.request.contextPath}" />

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<%-- =======================
     CHUẨN HOÁ NGUỒN DỮ LIỆU
     ======================= --%>
<%-- Hero: ưu tiên Trang nhất mới nhất; fallback: list (cũ) → latestAll --%>
<c:set var="hero"
       value="${not empty homeLatest
                 ? homeLatest
                 : (not empty list ? list : latestAll)}" />

<%-- Sidebar Hot: ưu tiên Trang nhất xem nhiều; fallback: listTop5View (cũ) → mostAll --%>
<c:set var="hotSrc"
       value="${not empty homeMost
                 ? homeMost
                 : (not empty listTop5View ? listTop5View : mostAll)}" />

<%-- Sidebar New: ưu tiên Trang nhất mới nhất; fallback: listTop5Date (cũ) → latestAll --%>
<c:set var="newSrc"
       value="${not empty homeLatest
                 ? homeLatest
                 : (not empty listTop5Date ? listTop5Date : latestAll)}" />

<main class="container">

  <c:if test="${not empty message}">
    <div class="alert" style="margin:10px 0; padding:10px; border:1px solid #e5e7eb; background:#fef3c7">
      ${message}
    </div>
  </c:if>

  <!-- ================= HERO (12 bài) ================= -->
  <section class="hero">
    <h2>Chào mừng đến với ABC News</h2>
    <div class="cards">
      <c:choose>
        <c:when test="${empty hero}">
          <p><em>Chưa có dữ liệu để hiển thị.</em></p>
        </c:when>
        <c:otherwise>
          <c:forEach var="n" items="${hero}" varStatus="st">
            <c:if test="${st.index < 12}">
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
                <h3 style="margin:.5rem 0 0">
                  <a href="${cp}/users?view=detail&id=${n.id}">${n.title}</a>
                </h3>
              </article>
            </c:if>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>
  </section>

  <!-- ================= 3 CỘT SIDEBAR ================= -->
  <section class="grid-3" style="margin-top:1.25rem">
    <!-- Hot nhất -->
    <div>
      <h3>Hot nhất (Top 5)</h3>
      <ol class="list">
        <c:choose>
          <c:when test="${empty hotSrc}">
            <li><em>Chưa có dữ liệu</em></li>
          </c:when>
          <c:otherwise>
            <c:forEach var="n" items="${hotSrc}" varStatus="st">
              <c:if test="${st.index < 5}">
                <li>
                  <a href="${cp}/users?view=detail&id=${n.id}">${n.title}</a>
                  <small> — <fmt:formatDate value="${n.postedDate}" pattern="dd/MM/yyyy"/></small>
                </li>
              </c:if>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </ol>
    </div>

    <!-- Mới nhất -->
    <div>
      <h3>Mới nhất (Top 5)</h3>
      <ul class="list">
        <c:choose>
          <c:when test="${empty newSrc}">
            <li><em>Chưa có dữ liệu</em></li>
          </c:when>
          <c:otherwise>
            <c:forEach var="n" items="${newSrc}" varStatus="st">
              <c:if test="${st.index < 5}">
                <li>
                  <a href="${cp}/users?view=detail&id=${n.id}">${n.title}</a>
                  <small> — <fmt:formatDate value="${n.postedDate}" pattern="dd/MM/yyyy"/></small>
                </li>
              </c:if>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>

    <!-- Đã xem gần đây -->
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
