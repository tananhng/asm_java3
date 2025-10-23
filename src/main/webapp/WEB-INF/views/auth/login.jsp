<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="<fmt:message key='nav.login'/>" />

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<main class="container" style="max-width:720px">
  <h1 style="margin:16px 0 8px"><fmt:message key="login.title"/></h1>
  <p style="opacity:.75;margin:0 0 20px"><fmt:message key="login.subtitle"/></p>

  <!-- thông báo lỗi/thành công từ Servlet -->
  <c:if test="${not empty message}">
    <div class="alert" style="margin:12px 0 16px;padding:12px;border:1px solid #fde68a;background:#fef3c7;border-radius:8px">
      ${message}
    </div>
  </c:if>

  <form action="<c:url value='/login'/>" method="post" style="display:grid;gap:12px">
    <label for="idAuthor"><fmt:message key="login.username"/></label>
    <input id="idAuthor" name="idAuthor" type="text"
           placeholder="<fmt:message key='login.username'/>"
           required
           style="padding:10px 12px;border:1px solid #e5e7eb;border-radius:10px" />

    <label for="password"><fmt:message key="login.password"/></label>
    <input id="password" name="password" type="password"
           placeholder="<fmt:message key='login.password'/>"
           required
           style="padding:10px 12px;border:1px solid #e5e7eb;border-radius:10px" />

    <button type="submit" class="btn" style="width:max-content">
      <fmt:message key="login.submit"/>
    </button>
  </form>

  <p style="margin-top:16px">
    <a href="<c:url value='/users'><c:param name='view' value='list'/></c:url>">
      <fmt:message key="login.backHome"/>
    </a>
  </p>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
