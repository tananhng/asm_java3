<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="layout-admin">
  <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

  <section class="page">
    <h2>Quản lý Người dùng</h2>

    <!-- Thông báo -->
    <c:if test="${not empty message}">
      <div class="alert" style="margin:10px 0; padding:10px; border:1px solid #e5e7eb; background:#fef3c7">
        ${message}
      </div>
    </c:if>

    <!-- Nút thêm -> sang trang user-form -->
    <p>
      <c:url var="addUrl" value="/admin">
        <c:param name="action" value="users-edit"/>
      </c:url>
      <a class="btn" href="${addUrl}">+ Thêm người dùng</a>
    </p>

    <!-- Bảng danh sách -->
    <table class="table">
      <thead>
      <tr>
        <th>Mã</th>
        <th>Họ và tên</th>
        <th>Email</th>
        <th>Điện thoại</th>
        <th>Ngày sinh</th>
        <th>Giới tính</th>
        <th>Vai trò</th>
        <th>Thao tác</th>
      </tr>
      </thead>
      <tbody>
      <c:choose>
        <c:when test="${empty usersList}">
          <tr><td colspan="8"><em>Chưa có người dùng.</em></td></tr>
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
                  <c:when test="${u.gender == true}">Nam</c:when>
                  <c:when test="${u.gender == false}">Nữ</c:when>
                  <c:otherwise>—</c:otherwise>
                </c:choose>
              </td>
              <td><c:if test="${u.role}">Quản trị</c:if><c:if test="${not u.role}">Phóng viên</c:if></td>
              <td>
                <c:url var="editRowUrl" value="/admin">
                  <c:param name="action" value="users-edit"/>
                  <c:param name="id" value="${u.id}"/>
                </c:url>
                <c:url var="delUrl" value="/admin">
                  <c:param name="action" value="users-delete"/>
                  <c:param name="id" value="${u.id}"/>
                </c:url>
                <a href="${editRowUrl}">Sửa</a> |
                <a href="${delUrl}" onclick="return confirm('Xoá người dùng ${u.id}?');">Xoá</a>
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
