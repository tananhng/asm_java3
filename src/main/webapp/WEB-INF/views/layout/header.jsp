<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>


<%-- common URLs --%>
<c:url var="homeUrl" value="/users"><c:param name="view" value="list"/></c:url>
<c:url var="tsUrl"   value="/users"><c:param name="view" value="category"/><c:param name="cat" value="thoi-su"/></c:url>
<c:url var="sportUrl" value="/users"><c:param name="view" value="category"/><c:param name="cat" value="the-thao"/></c:url>
<c:url var="techUrl" value="/users"><c:param name="view" value="category"/><c:param name="cat" value="cong-nghe"/></c:url>
<c:url var="newsletterUrl" value="/users"><c:param name="view" value="newsletter"/></c:url>

<%-- build language switch URLs that preserve current view + params --%>
<c:set var="currentView" value="${empty param.view ? 'list' : param.view}" />

<c:url var="switchVi" value="/users">
  <c:param name="view" value="${currentView}"/>
  <c:if test="${not empty param.cat}">
    <c:param name="cat" value="${param.cat}"/>
  </c:if>
  <c:if test="${not empty param.id}">
    <c:param name="id" value="${param.id}"/>
  </c:if>
  <c:param name="lang" value="vi"/>
</c:url>

<c:url var="switchEn" value="/users">
  <c:param name="view" value="${currentView}"/>
  <c:if test="${not empty param.cat}">
    <c:param name="cat" value="${param.cat}"/>
  </c:if>
  <c:if test="${not empty param.id}">
    <c:param name="id" value="${param.id}"/>
  </c:if>
  <c:param name="lang" value="en"/>
</c:url>

<!DOCTYPE html>
<html lang="${currentLang}">
<head>
  <meta charset="UTF-8">
  <title><c:out value="${pageTitle != null ? pageTitle : 'ABC News'}"/></title>
  <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
  <style>
    .site-header .bar{display:flex;align-items:center;gap:16px}
    .main-nav{flex:1}
    .lang-switch{display:flex;gap:8px;align-items:center}
    .lang-switch a{padding:4px 8px;border-radius:6px}
    .lang-switch a.active{font-weight:600;border:1px solid #e5e7eb;background:#f9fafb}
  </style>
</head>
<body>

<header class="site-header">
  <div class="container bar">
    <!-- Logo -->
    <div class="logo" style="margin-right:16px">
      <a href="${homeUrl}">ABC News</a>
    </div>

    <!-- Menu -->
    <nav class="main-nav">
      <ul>
        <li><a href="${homeUrl}" class="${param.view eq 'list' ? 'active' : ''}"><fmt:message key="nav.home"/></a></li>
        <li><a href="${tsUrl}"><fmt:message key="nav.currentAffairs"/></a></li>
        <li><a href="${sportUrl}"><fmt:message key="nav.sports"/></a></li>
        <li><a href="${techUrl}"><fmt:message key="nav.tech"/></a></li>
        <li>
          <a href="${newsletterUrl}" class="${param.view eq 'newsletter' ? 'active' : ''}">
            <fmt:message key="nav.newsletter"/>
          </a>
        </li>

        <c:choose>
          <c:when test="${empty sessionScope.user}">
            <li><a href="<c:url value='/login'/>"><fmt:message key="nav.login"/></a></li>
          </c:when>
          <c:otherwise>
            <li>
              <c:url var="adminUrl" value="/admin"><c:param name="action" value="list"/></c:url>
              <a href="${adminUrl}">
                <c:choose>
                  <c:when test="${sessionScope.user.role}"><fmt:message key="nav.admin"/></c:when>
                  <c:otherwise><fmt:message key="nav.myNews"/></c:otherwise>
                </c:choose>
              </a>
            </li>
            <li><span style="opacity:.7"><fmt:message key="nav.hello"/> ${sessionScope.user.fullname}</span></li>
            <li><a href="<c:url value='/logout'/>"><fmt:message key="nav.logout"/></a></li>
          </c:otherwise>
        </c:choose>
      </ul>
    </nav>

    <!-- Language switcher (right-most) -->
    <div class="lang-switch">
      <a href="${switchVi}" class="${currentLang eq 'vi' ? 'active' : ''}">VI</a>
      <span style="opacity:.5">|</span>
      <a href="${switchEn}" class="${currentLang eq 'en' ? 'active' : ''}">EN</a>
    </div>
  </div>
</header>
