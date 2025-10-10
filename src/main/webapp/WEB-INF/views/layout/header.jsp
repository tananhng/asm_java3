<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>


<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title><c:out value="${pageTitle != null ? pageTitle : 'ABC News'}"/></title>
  <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
</head>
<body>

<header class="site-header">
  <div class="container bar">
    <div class="logo">
      <c:url var="homeUrl" value="/users"><c:param name="view" value="list"/></c:url>
      <a href="${homeUrl}">ABC News</a>
    </div>

    <nav class="main-nav">
      <ul>
        <li>
          <a href="${homeUrl}" class="${param.view eq 'list' ? 'active' : ''}">Trang chủ</a>
        </li>
        <li>
          <c:url var="tsUrl" value="/users">
            <c:param name="view" value="category"/>
            <c:param name="cat"  value="thoi-su"/>
          </c:url>
          <a href="${tsUrl}">Thời sự</a>
        </li>
        <li>
          <c:url var="thethaoUrl" value="/users">
            <c:param name="view" value="category"/>
            <c:param name="cat"  value="the-thao"/>
          </c:url>
          <a href="${thethaoUrl}">Thể thao</a>
        </li>
        <li>
          <c:url var="cnUrl" value="/users">
            <c:param name="view" value="category"/>
            <c:param name="cat"  value="cong-nghe"/>
          </c:url>
          <a href="${cnUrl}">Công nghệ</a>
        </li>
        <li>
          <c:url var="newsletterUrl" value="/users"><c:param name="view" value="newsletter"/></c:url>
          <a href="${newsletterUrl}" class="${param.view eq 'newsletter' ? 'active' : ''}">Bản tin</a>
        </li>

        <c:choose>
          <c:when test="${empty sessionScope.user}">
            <li><a href="<c:url value='/login'/>">Đăng nhập</a></li>
          </c:when>
          <c:otherwise>
            <li>
              <c:url var="adminUrl" value="/admin"><c:param name="action" value="list"/></c:url>
              <a href="${adminUrl}">
                <c:choose>
                  <c:when test="${sessionScope.user.role}">Quản trị</c:when>
                  <c:otherwise>Tin của tôi</c:otherwise>
                </c:choose>
              </a>
            </li>
            <li><span style="opacity:.7">Xin chào, ${sessionScope.user.fullname}</span></li>
            <li><a href="<c:url value='/logout'/>">Đăng xuất</a></li>
          </c:otherwise>
        </c:choose>
      </ul>
    </nav>
  </div>
</header>
