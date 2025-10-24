<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>

<%-- URLs chung --%>
<c:url var="homeUrl" value="/users"><c:param name="view" value="list"/></c:url>
<c:url var="tsUrl" value="/users"><c:param name="view" value="category"/><c:param name="cat" value="thoi-su"/></c:url>
<c:url var="sportUrl" value="/users"><c:param name="view" value="category"/><c:param name="cat" value="the-thao"/></c:url>
<c:url var="techUrl" value="/users"><c:param name="view" value="category"/><c:param name="cat" value="cong-nghe"/></c:url>
<c:url var="newsletterUrl" value="/users"><c:param name="view" value="newsletter"/></c:url>

<%-- Build URL chuyển ngôn ngữ --%>
<c:set var="currentView" value="${empty param.view ? 'list' : param.view}" />
<c:url var="switchVi" value="/users">
  <c:param name="view" value="${currentView}"/>
  <c:if test="${not empty param.cat}"><c:param name="cat" value="${param.cat}"/></c:if>
  <c:if test="${not empty param.id}"><c:param name="id" value="${param.id}"/></c:if>
  <c:param name="lang" value="vi"/>
</c:url>
<c:url var="switchEn" value="/users">
  <c:param name="view" value="${currentView}"/>
  <c:if test="${not empty param.cat}"><c:param name="cat" value="${param.cat}"/></c:if>
  <c:if test="${not empty param.id}"><c:param name="id" value="${param.id}"/></c:if>
  <c:param name="lang" value="en"/>
</c:url>

<!DOCTYPE html>
<html lang="${currentLang}">
<head>
  <meta charset="UTF-8">
  <title><c:out value="${pageTitle != null ? pageTitle : 'ABC News'}"/></title>
  <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
</head>
<body>

<header class="site-header">
  <div class="container bar">
    <!-- Logo -->
    <div class="logo"><a href="${homeUrl}">ABC News</a></div>

    <!-- Menu -->
    <nav class="main-nav">
      <ul>
        <li><a href="${homeUrl}" class="${param.view eq 'list' ? 'active' : ''}"><fmt:message key="nav.home"/></a></li>
        <li><a href="${tsUrl}"><fmt:message key="nav.currentAffairs"/></a></li>
        <li><a href="${sportUrl}"><fmt:message key="nav.sports"/></a></li>
        <li><a href="${techUrl}"><fmt:message key="nav.tech"/></a></li>
        <li><a href="${newsletterUrl}" class="${param.view eq 'newsletter' ? 'active' : ''}"><fmt:message key="nav.newsletter"/></a></li>
        <c:if test="${empty sessionScope.user}">
          <li><a href="<c:url value='/login'/>"><fmt:message key="nav.login"/></a></li>
        </c:if>
      </ul>
    </nav>

    <!-- Khu vực tài khoản -->
    <div class="right-zone">
      <c:if test="${not empty sessionScope.user}">
        <c:set var="fullName" value="${sessionScope.user.fullname}" />
        <c:set var="nameMax" value="24" />
        <c:url var="adminUrl" value="/admin"><c:param name="action" value="list"/></c:url>

        <div class="account" title="${fullName}">
          <!-- Hàng 1 -->
          <div class="account-top">
            <span class="hello"><fmt:message key="nav.hello"/></span>
            <span class="user-name">
              <c:choose>
                <c:when test="${fn:length(fullName) > nameMax}">
                  <c:out value="${fn:substring(fullName, 0, nameMax)}"/>…
                </c:when>
                <c:otherwise><c:out value="${fullName}"/></c:otherwise>
              </c:choose>
            </span>
            <a href="<c:url value='/logout'/>" class="logout"><fmt:message key="nav.logout"/></a>
          </div>

          <!-- Hàng 2: Quản trị/Tin của tôi + VI|EN -->
          <div class="account-bottom">
            <a href="${adminUrl}" class="account-link">
              <c:choose>
                <c:when test="${sessionScope.user.role}">
                  <fmt:message key="nav.admin"/>
                </c:when>
                <c:otherwise>
                  <fmt:message key="nav.myNews"/>
                </c:otherwise>
              </c:choose>
            </a>

            <div class="lang-switch">
              <a href="${switchVi}" class="${currentLang eq 'vi' ? 'active' : ''}">VI</a>
              <span class="sep">|</span>
              <a href="${switchEn}" class="${currentLang eq 'en' ? 'active' : ''}">EN</a>
            </div>
          </div>
        </div>
      </c:if>
    </div>
  </div>
</header>

</body>
</html>
