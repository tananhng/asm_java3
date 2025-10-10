<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../layout/header.jsp" %>

<div class="layout-admin">
  <%@ include file="../layout/sidebar.jsp" %>

  <section class="page">
    <h2>Quản lý Loại tin</h2>

    <c:if test="${not empty message}">
      <div class="alert" style="margin:10px 0; padding:10px; border:1px solid #e5e7eb; background:#fef3c7">
        ${message}
      </div>
    </c:if>

    <p>
      <c:url var="addUrl" value="/admin-categories"><c:param name="action" value="edit"/></c:url>
      <a class="btn" href="${addUrl}">+ Thêm loại tin</a>
    </p>

    <table class="table">
      <thead>
        <tr>
          <th>Mã</th>
          <th>Tên loại</th>
          <th>Thao tác</th>
        </tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${empty categoriesList}">
            <tr><td colspan="3"><em>Chưa có loại tin.</em></td></tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="c" items="${categoriesList}">
              <tr>
                <td>${c.id}</td>
                <td>${c.name}</td>
                <td>
                  <c:url var="editUrl" value="/admin-categories">
                    <c:param name="action" value="edit"/>
                    <c:param name="id" value="${c.id}"/>
                  </c:url>
                  <c:url var="delUrl" value="/admin-categories">
                    <c:param name="action" value="delete"/>
                    <c:param name="id" value="${c.id}"/>
                  </c:url>
                  <a href="${editUrl}">Sửa</a> |
                  <a href="${delUrl}" onclick="return confirm('Xoá loại ${c.id}?');">Xoá</a>
                </td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </section>
</div>

<%@ include file="../layout/footer.jsp" %>
