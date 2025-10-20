<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<c:set var="cp" value="${pageContext.request.contextPath}" />

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<%-- ================= Chuẩn hoá nguồn dữ liệu ================= --%>
<%-- Hero: ưu tiên Trang nhất mới nhất; fallback: list → latestAll --%>
<c:set var="hero"
       value="${not empty homeLatest
                 ? homeLatest
                 : (not empty list ? list : latestAll)}" />

<%-- Sidebar Hot: ưu tiên Trang nhất xem nhiều; fallback: mostAll --%>
<c:set var="hotSrc"
       value="${not empty homeMost
                 ? homeMost
                 : mostAll}" />

<%-- Sidebar New: ưu tiên Trang nhất mới nhất; fallback: latestAll --%>
<c:set var="newSrc"
       value="${not empty homeLatest
                 ? homeLatest
                 : latestAll}" />

<main class="container">
  <c:if test="${not empty message}">
    <div class="alert" style="margin:10px 0; padding:10px; border:1px solid #e5e7eb; background:#fef3c7">
      ${message}
    </div>
  </c:if>

  <!-- ================= HERO (tối đa 12 bài) ================= -->
  <section class="hero">
    <h2><fmt:message key="home.welcome"/></h2>

    <c:choose>
      <c:when test="${empty hero}">
        <p><em><fmt:message key="home.hero.empty"/></em></p>
      </c:when>
      <c:otherwise>
        <div class="cards">
          <c:forEach var="n" items="${hero}" varStatus="st">
            <c:if test="${st.index < 12}">
              <c:url var="detailUrl" value="/users">
                <c:param name="view" value="detail"/>
                <c:param name="id"   value="${n.id}"/>
              </c:url>

              <article class="card">
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
                <h3 style="margin:.5rem 0 0">
                  <a href="${detailUrl}">${n.title}</a>
                </h3>
              </article>
            </c:if>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>
  </section>

  <!-- ================= 3 CỘT SIDEBAR ================= -->
  <section class="grid-3" style="margin-top:1.25rem">
    <!-- Hot nhất -->
    <div>
      <h3><fmt:message key="home.hotTop5"/></h3>
      <ol class="list">
        <c:choose>
          <c:when test="${empty hotSrc}">
            <li><em><fmt:message key="home.empty"/></em></li>
          </c:when>
          <c:otherwise>
            <c:forEach var="n" items="${hotSrc}" varStatus="st">
              <c:if test="${st.index < 5}">
                <c:url var="detailUrl" value="/users">
                  <c:param name="view" value="detail"/>
                  <c:param name="id"   value="${n.id}"/>
                </c:url>
                <li>
                  <a href="${detailUrl}">${n.title}</a>
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
      <h3><fmt:message key="home.latestTop5"/></h3>
      <ul class="list">
        <c:choose>
          <c:when test="${empty newSrc}">
            <li><em><fmt:message key="home.empty"/></em></li>
          </c:when>
          <c:otherwise>
            <c:forEach var="n" items="${newSrc}" varStatus="st">
              <c:if test="${st.index < 5}">
                <c:url var="detailUrl" value="/users">
                  <c:param name="view" value="detail"/>
                  <c:param name="id"   value="${n.id}"/>
                </c:url>
                <li>
                  <a href="${detailUrl}">${n.title}</a>
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
      <h3><fmt:message key="home.recent"/></h3>
      <ul class="list">
        <c:choose>
          <c:when test="${empty recent}">
            <li><em><fmt:message key="home.recent.empty"/></em></li>
          </c:when>
          <c:otherwise>
            <c:forEach var="n" items="${recent}">
              <c:url var="detailUrl" value="/users">
                <c:param name="view" value="detail"/>
                <c:param name="id"   value="${n.id}"/>
              </c:url>
              <li><a href="${detailUrl}">${n.title}</a></li>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </section>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
