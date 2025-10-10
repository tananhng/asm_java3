<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="isLoggedIn" value="${not empty sessionScope.user}" />
<c:set var="isAdmin"    value="${isLoggedIn and sessionScope.user.role}" />

<!-- URLs dùng chung -->
<c:url var="homeUrl" value="/users">
  <c:param name="view" value="list"/>
</c:url>
<c:url var="newsListUrl" value="/admin">
  <c:param name="action" value="list"/>
</c:url>
<c:url var="dashboardUrl" value="/admin">
  <c:param name="action" value="dashboard"/>
</c:url>
<c:url var="categoriesUrl" value="/admin">
  <c:param name="action" value="categories"/>
</c:url>
<c:url var="usersUrl" value="/admin">
  <c:param name="action" value="users"/>
</c:url>
<c:url var="newsletterUrl" value="/admin">
  <c:param name="action" value="newsletters"/>
</c:url>
<c:url var="addNewsUrl" value="/admin">
  <c:param name="action" value="edit"/>
</c:url>
<c:url var="loginUrl" value="/login" />
<c:url var="logoutUrl" value="/logout" />

<aside class="sidebar">
  <nav>
    <ul>
      <li><a href="${homeUrl}">Trang chủ (Độc giả)</a></li>
      <li><a href="${newsListUrl}">Tin tức</a></li>
    </ul>

    <!-- Khu quản trị -->
    <c:if test="${isLoggedIn}">
      <hr/>
      <ul>
        <!-- Admin -->
        <c:if test="${isAdmin}">
          <li><a href="${dashboardUrl}">Bảng điều khiển</a></li>
          <li><a href="${newsListUrl}">Quản lý tin tức</a></li>
          <li><a href="${categoriesUrl}">Loại tin</a></li>
          <li><a href="${usersUrl}">Người dùng</a></li>
          <li><a href="${newsletterUrl}">Newsletters</a></li>
        </c:if>

        <!-- Phóng viên -->
        <c:if test="${not isAdmin}">
          <li><a href="${newsListUrl}">Bài của tôi</a></li>
          <li><a href="${addNewsUrl}">+ Thêm bản tin</a></li>
        </c:if>
      </ul>
    </c:if>
  </nav>

  <div class="user-info" style="margin-top:12px; opacity:.9">
    <small>
      <c:choose>
        <c:when test="${isLoggedIn}">
          Xin chào: <strong>${sessionScope.user.fullname}</strong>
          · <a href="${logoutUrl}">Đăng xuất</a>
        </c:when>
        <c:otherwise>
          Bạn đang là <strong>Khách</strong> · <a href="${loginUrl}">Đăng nhập</a>
        </c:otherwise>
      </c:choose>
    </small>
  </div>
</aside>
