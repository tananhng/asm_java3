<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="layout-admin">
  <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

  <section class="page">
    <h2><fmt:message key="admin.nl.title"/></h2>

    <c:if test="${not empty message}">
      <div class="alert" style="margin:10px 0; padding:10px; border:1px solid #e5e7eb; background:#fef3c7">
        ${message}
      </div>
    </c:if>

    <p>
      <c:url var="addUrl" value="/admin"><c:param name="action" value="newsletters-edit"/></c:url>
      <a class="btn" href="${addUrl}">+ <fmt:message key="admin.nl.add"/></a>
    </p>

    <table class="table">
      <thead>
      <tr>
        <th><fmt:message key="admin.nl.email"/></th>
        <th><fmt:message key="admin.nl.status"/></th>
        <th><fmt:message key="admin.table.actions"/></th>
      </tr>
      </thead>
      <tbody>
      <c:choose>
        <c:when test="${empty subs}">
          <tr><td colspan="3"><em><fmt:message key="admin.nl.empty"/></em></td></tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="n" items="${subs}">
            <tr>
              <td>${n.email}</td>
              <td>
                <c:choose>
                  <c:when test="${n.enabled}"><fmt:message key="admin.nl.status.enabled"/></c:when>
                  <c:otherwise><fmt:message key="admin.nl.status.disabled"/></c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:url var="editUrl" value="/admin">
                  <c:param name="action" value="newsletters-edit"/>
                  <c:param name="email" value="${n.email}"/>
                </c:url>
                <c:url var="delUrl" value="/admin">
                  <c:param name="action" value="newsletters-delete"/>
                  <c:param name="email" value="${n.email}"/>
                </c:url>
                <a href="${editUrl}"><fmt:message key="common.edit"/></a> |
                <a href="${delUrl}" onclick="return confirm('<fmt:message key="admin.nl.confirmDelete"><fmt:param value="${n.email}"/></fmt:message>');">
                  <fmt:message key="common.delete"/>
                </a>
              </td>
            </tr>
          </c:forEach>
        </c:otherwise>
      </c:choose>
      </tbody>
    </table>
  </section>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
