<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<main class="container">
  <h2><fmt:message key="newsletter.title"/></h2>

  <!-- Thông báo từ ServletUsers.handleNewsletterSubmit -->
  <c:if test="${not empty message}">
    <div class="alert" style="margin:.75rem 0 1rem; padding:.75rem 1rem; border:1px solid #c7f0d7; background:#ecfdf5; color:#065f46; border-radius:8px;">
      ${message}
    </div>
  </c:if>

  <!-- Form đăng ký -->
  <form class="pure-form" action="<c:url value='/users'/>" method="post" style="display:grid; gap:12px; max-width:520px">
    <input type="hidden" name="view" value="newsletter"/>

    <label for="email"><fmt:message key="newsletter.email"/></label>
    <input id="email"
           name="email"
           type="email"
           placeholder="you@example.com"
           required
           autocomplete="email"
           style="padding:10px 12px; border:1px solid #e5e7eb; border-radius:10px" />

    <button type="submit" class="btn" style="width:max-content">
      <fmt:message key="newsletter.submit"/>
    </button>
  </form>

  <!-- Hiển thị các email đã đăng ký trong phiên (session 'subs') -->
  <c:if test="${not empty sessionScope.subs}">
    <section style="margin-top:24px">
      <h3><fmt:message key="newsletter.sessionTitle"/></h3>
      <ul class="list">
        <c:forEach var="e" items="${sessionScope.subs}">
          <li>${e}</li>
        </c:forEach>
      </ul>
    </section>
  </c:if>

  <!-- Link quay về trang chủ -->
  <c:url var="homeUrl" value="/users"><c:param name="view" value="list"/></c:url>
  <p style="margin-top:20px">
    <a href="${homeUrl}">← <fmt:message key="nav.home"/></a>
  </p>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
