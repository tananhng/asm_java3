<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>


<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<h2>Đăng nhập</h2>

<!-- Thông báo lỗi (nếu Servlet đặt thuộc tính "message") -->
<c:if test="${not empty message}">
  <div class="alert error" style="margin:.5rem 0 1rem;color:#c0392b;">
    ${message}
  </div>
</c:if>

<form class="pure-form" action="${pageContext.request.contextPath}/login" method="post" autocomplete="on">
  <label for="idAuthor">Tài khoản</label>
  <input id="idAuthor" name="idAuthor" type="text" required value="${param.idAuthor}"/>

  <label for="password">Mật khẩu</label>
  <input id="password" name="password" type="password" required/>

  <button type="submit">Đăng nhập</button>
</form>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
