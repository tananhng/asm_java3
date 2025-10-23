<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="layout-admin">
  <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

  <section class="page">
    <h2><fmt:message key="admin.users.title"/></h2>

    <c:if test="${not empty message}">
      <div class="alert" style="margin:10px 0; padding:10px; border:1px solid #e5e7eb; background:#fef3c7">
        ${message}
      </div>
    </c:if>

    <p>
      <c:url var="addUrl" value="/admin"><c:param name="action" value="users-edit"/></c:url>
      <a class="btn" href="${addUrl}">+ <fmt:message key="admin.users.add"/></a>
    </p>

    <table class="table">
      <thead>
      <tr>
        <th><fmt:message key="admin.users.id"/></th>
        <th><fmt:message key="admin.users.fullname"/></th>
        <th><fmt:message key="admin.users.email"/></th>
        <th><fmt:message key="admin.users.mobile"/></th>
        <th><fmt:message key="admin.users.birthday"/></th>
        <th><fmt:message key="admin.users.gender"/></th>
        <th><fmt:message key="admin.users.role"/></th>
        <th><fmt:message key="admin.table.actions"/></th>
      </tr>
      </thead>
      <tbody>
      <c:choose>
        <c:when test="${empty usersList}">
          <tr><td colspan="8"><em><fmt:message key="admin.users.empty"/></em></td></tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="u" items="${usersList}">
            <tr>
              <td>${u.id}</td>
              <td>${u.fullname}</td>
              <td>${u.email}</td>
              <td>${u.mobile}</td>
              <td>
                <c:choose>
                  <c:when test="${not empty u.birthday}">
                    <fmt:formatDate value="${u.birthday}" pattern="dd/MM/yyyy"/>
                  </c:when>
                  <c:otherwise>—</c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:choose>
                  <c:when test="${u.gender == true}"><fmt:message key="gender.male"/></c:when>
                  <c:when test="${u.gender == false}"><fmt:message key="gender.female"/></c:when>
                  <c:otherwise>—</c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:if test="${u.role}"><fmt:message key="admin.users.role.admin"/></c:if>
                <c:if test="${not u.role}"><fmt:message key="admin.users.role.reporter"/></c:if>
              </td>
              <td>
                <c:url var="editRowUrl" value="/admin">
                  <c:param name="action" value="users-edit"/>
                  <c:param name="id" value="${u.id}"/>
                </c:url>
                <c:url var="delUrl" value="/admin">
                  <c:param name="action" value="users-delete"/>
                  <c:param name="id" value="${u.id}"/>
                </c:url>
                <a href="${editRowUrl}"><fmt:message key="common.edit"/></a> |
                <a href="${delUrl}" onclick="return confirm('<fmt:message key="admin.users.confirmDelete"><fmt:param value="${u.id}"/></fmt:message>');">
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
