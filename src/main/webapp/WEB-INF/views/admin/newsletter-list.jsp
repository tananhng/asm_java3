<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="layout-admin">
  <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

  <section class="page">
    <h2>Quản lý Newsletter</h2>

    <c:if test="${not empty message}">
      <div class="alert" style="margin:10px 0; padding:10px; border:1px solid #e5e7eb; background:#fef3c7">
        ${message}
      </div>
    </c:if>

    <p>
      <c:url var="addUrl" value="/admin">
        <c:param name="action" value="newsletters-edit"/>
      </c:url>
      <a class="btn" href="${addUrl}">+ Thêm email</a>
    </p>

    <table class="table">
      <thead>
      <tr>
        <th>Email</th>
        <th>Trạng thái</th>
        <th>Thao tác</th>
      </tr>
      </thead>
      <tbody>
      <c:choose>
        <c:when test="${empty subs}">
          <tr><td colspan="3"><em>Chưa có đăng ký nào.</em></td></tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="n" items="${subs}">
            <tr>
              <td>${n.email}</td>
              <td>
                <c:choose>
                  <c:when test="${n.enabled}">Đang hiệu lực</c:when>
                  <c:otherwise>Tạm tắt</c:otherwise>
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
                <a href="${editUrl}">Sửa</a> |
                <a href="${delUrl}" onclick="return confirm('Xoá email ${n.email}?');">Xoá</a>
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
