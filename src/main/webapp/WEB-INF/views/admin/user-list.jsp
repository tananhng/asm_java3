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

    <!-- Nút thêm -->
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

    <!-- FORM TẠO/SỬA (tuỳ chọn, nếu bạn đã làm action users-edit/users-create/users-update trong ServletAdmin) -->
    <c:set var="editing" value="${requestScope.userEditing}" />
    <section style="margin-top:24px">
      <h3>
        <c:choose>
          <c:when test="${empty editing}">Thêm người dùng</c:when>
          <c:otherwise>Sửa người dùng #${editing.id}</c:otherwise>
        </c:choose>
      </h3>

      <form action="<c:url value='/admin'/>" method="post" style="display:grid; gap:10px; max-width:800px">
        <input type="hidden" name="action" value="${empty editing ? 'users-create' : 'users-update'}"/>

        <div>
          <label for="id">Mã đăng nhập (Id)</label>
          <input id="id" name="id" type="text"
                 value="${empty editing ? '' : editing.id}"
                 ${empty editing ? 'required' : 'readonly'} />
        </div>

        <div>
          <label for="password">Mật khẩu</label>
          <input id="password" name="password" type="password"
                 placeholder="${empty editing ? '' : 'Để trống nếu không đổi'}"
                 ${empty editing ? 'required' : ''}/>
        </div>

        <div>
          <label for="fullname">Họ và tên</label>
          <input id="fullname" name="fullname" type="text" required
                 value="${empty editing ? '' : editing.fullname}" style="width:100%"/>
        </div>

        <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px">
          <div>
            <label for="email">Email</label>
            <input id="email" name="email" type="email" value="${empty editing ? '' : editing.email}"/>
          </div>
          <div>
            <label for="mobile">Điện thoại</label>
            <input id="mobile" name="mobile" type="text" value="${empty editing ? '' : editing.mobile}"/>
          </div>
        </div>

        <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px">
          <div>
            <label for="birthday">Ngày sinh</label>
            <c:if test="${not empty editing and not empty editing.birthday}">
              <fmt:formatDate var="birthdayValue" value="${editing.birthday}" pattern="yyyy-MM-dd"/>
            </c:if>
            <input id="birthday" name="birthday" type="date" value="${birthdayValue}"/>
          </div>
          <div>
            <label>Giới tính</label>
            <div style="display:flex; gap:12px; align-items:center">
              <label><input type="radio" name="gender" value="true"
                <c:if test="${empty editing or editing.gender == true}">checked="checked"</c:if> /> Nam</label>
              <label><input type="radio" name="gender" value="false"
                <c:if test="${not empty editing and editing.gender == false}">checked="checked"</c:if> /> Nữ</label>
            </div>
          </div>
        </div>

        <div>
          <label>
            <input type="checkbox" name="role"
              <c:if test="${not empty editing and editing.role}">checked="checked"</c:if> />
            Quản trị
          </label>
        </div>

        <div style="margin-top:8px; display:flex; gap:10px">
          <button class="btn" type="submit">${empty editing ? 'Tạo mới' : 'Cập nhật'}</button>
          <a class="btn" href="<c:url value='/admin'><c:param name='action' value='users'/></c:url>" style="background:#6b7280">Huỷ</a>
        </div>
      </form>
    </section>
  </section>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
