<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="isLoggedIn" value="${not empty sessionScope.user}" />
<c:set var="isAdmin"    value="${isLoggedIn and sessionScope.user.role}" />

<!-- URLs dùng chung -->
<c:url var="homeUrl" value="/users"><c:param name="view" value="list"/></c:url>
<c:url var="newsListUrl" value="/admin"><c:param name="action" value="list"/></c:url>
<c:url var="dashboardUrl" value="/admin"><c:param name="action" value="dashboard"/></c:url>
<c:url var="categoriesUrl" value="/admin"><c:param name="action" value="categories"/></c:url>
<c:url var="usersUrl" value="/admin"><c:param name="action" value="users"/></c:url>
<c:url var="newsletterUrl" value="/admin"><c:param name="action" value="newsletters"/></c:url>
<c:url var="addNewsUrl" value="/admin"><c:param name="action" value="edit"/></c:url>
<c:url var="loginUrl" value="/login" />
<c:url var="logoutUrl" value="/logout" />

<aside class="sidebar">
  <nav>
    <ul>
      <li><a href="${homeUrl}"><fmt:message key="sidebar.readerHome"/></a></li>
      <li><a href="${newsListUrl}"><fmt:message key="sidebar.news"/></a></li>
    </ul>

    <c:if test="${isLoggedIn}">
      <hr/>
      <ul>
        <!-- Admin -->
        <c:if test="${isAdmin}">
          <li><a href="${dashboardUrl}"><fmt:message key="admin.dashboard"/></a></li>
          <li><a href="${newsListUrl}"><fmt:message key="admin.manageNews"/></a></li>
          <li><a href="${categoriesUrl}"><fmt:message key="admin.categories"/></a></li>
          <li><a href="${usersUrl}"><fmt:message key="admin.users"/></a></li>
          <li><a href="${newsletterUrl}"><fmt:message key="admin.newsletters"/></a></li>
        </c:if>

        <!-- Reporter -->
        <c:if test="${not isAdmin}">
          <li><a href="${newsListUrl}"><fmt:message key="sidebar.myArticles"/></a></li>
          <li><a href="${addNewsUrl}">+ <fmt:message key="sidebar.addNews"/></a></li>
        </c:if>
      </ul>
    </c:if>
  </nav>

  <div class="user-info" style="margin-top:12px; opacity:.9">
    <small>
      <c:choose>
        <c:when test="${isLoggedIn}">
          <fmt:message key="sidebar.greeting"/> <strong>${sessionScope.user.fullname}</strong>
          · <a href="${logoutUrl}"><fmt:message key="nav.logout"/></a>
        </c:when>
        <c:otherwise>
          <fmt:message key="sidebar.guest"/>
          · <a href="${loginUrl}"><fmt:message key="nav.login"/></a>
        </c:otherwise>
      </c:choose>
    </small>
  </div>
</aside>
