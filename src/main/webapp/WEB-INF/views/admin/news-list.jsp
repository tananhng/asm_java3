<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<c:set var="isAdmin" value="${requestScope.isAdmin}" />

<div class="layout-admin">
  <%@ include file="/WEB-INF/views/layout/sidebar.jsp" %>

  <section class="page">
    <h2><fmt:message key="admin.news.title"/></h2>

    <c:if test="${not empty message}">
      <div class="alert" style="margin:10px 0; padding:10px; border:1px solid #e5e7eb; background:#fef3c7">
        ${message}
      </div>
    </c:if>

    <c:if test="${not isAdmin}">
      <p style="margin:6px 0 14px; font-size:13px; opacity:.8">
        <fmt:message key="admin.news.onlyMine"/>
      </p>
    </c:if>

    <p>
      <c:url var="addUrl" value="/admin"><c:param name="action" value="news-edit"/></c:url>
      <a class="btn" href="${addUrl}">+ <fmt:message key="admin.quick.addNews"/></a>
    </p>

    <table class="table">
      <thead>
      <tr>
        <th><fmt:message key="admin.table.id"/></th>
        <th><fmt:message key="admin.table.title"/></th>
        <th><fmt:message key="admin.news.author"/></th>
        <th><fmt:message key="admin.table.category"/></th>
        <th><fmt:message key="admin.table.home"/></th>
        <th><fmt:message key="admin.table.views"/></th>
        <th><fmt:message key="admin.table.date"/></th>
        <th><fmt:message key="admin.table.actions"/></th>
      </tr>
      </thead>
      <tbody>
      <c:choose>
        <c:when test="${empty newsList}">
          <tr><td colspan="8"><em><fmt:message key="admin.news.empty"/></em></td></tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="n" items="${newsList}">
            <tr>
              <td>${n.id}</td>
              <td style="max-width:420px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap">${n.title}</td>
              <td>${n.idAuthor}</td>
              <td>${empty n.categoryName ? n.categoryId : n.categoryName}</td>
              <td><c:if test="${n.home}">✓</c:if></td>
              <td>${n.viewCount != null ? n.viewCount : 0}</td>
              <td>
                <c:choose>
                  <c:when test="${not empty n.postedDate}">
                    <fmt:formatDate value="${n.postedDate}" pattern="dd/MM/yyyy HH:mm" />
                  </c:when>
                  <c:otherwise>—</c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:url var="editRowUrl" value="/admin">
                  <c:param name="action" value="edit"/>
                  <c:param name="id" value="${n.id}"/>
                </c:url>
                <c:url var="delUrl" value="/admin">
                  <c:param name="action" value="delete"/>
                  <c:param name="id" value="${n.id}"/>
                </c:url>
                <c:url var="viewUrl" value="/users">
                  <c:param name="view" value="detail"/>
                  <c:param name="id" value="${n.id}"/>
                </c:url>
                <a href="${editRowUrl}"><fmt:message key="common.edit"/></a> |
                <a href="${delUrl}" onclick="return confirm('<fmt:message key="admin.news.confirmDelete"><fmt:param value="${n.id}"/></fmt:message>');">
                  <fmt:message key="common.delete"/>
                </a> |
                <a href="${viewUrl}" target="_blank"><fmt:message key="common.view"/></a>
              </td>
            </tr>
          </c:forEach>
        </c:otherwise>
      </c:choose>
      </tbody>
    </table>
  </section>
</div>

<%@ include file="/WEB-INF/views/layout/footer.jsp" %>
