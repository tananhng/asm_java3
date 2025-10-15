<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<c:set var="isEdit" value="${not empty userEditing}" />
<c:set var="u"      value="${isEdit ? userEditing : null}" />

<div class="layout-admin">
  <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

  <section class="page">
    <h2>${isEdit ? 'Sửa' : 'Thêm'} Người dùng</h2>

    <c:if test="${not empty message}">
      <div class="alert" style="margin:.5rem 0 1rem; padding:.75rem 1rem; border:1px solid #fee2e2; background:#fef2f2; color:#991b1b; border-radius:8px;">
        ${message}
      </div>
    </c:if>

    <form action="<c:url value='/admin'/>" method="post" style="display:grid; gap:12px; max-width:780px">
      <input type="hidden" name="action" value="${isEdit ? 'users-update' : 'users-create'}"/>

      <!-- Id -->
      <div>
        <label for="id">Mã đăng nhập (Id)</label>
        <input id="id" name="id" type="text"
               value="${isEdit ? u.id : ''}"
               ${isEdit ? 'readonly' : 'required'} />
      </div>

      <!-- Password -->
      <div>
        <label for="password">Mật khẩu</label>
        <input id="password" name="password" type="password"
               placeholder="${isEdit ? 'Để trống nếu không đổi' : ''}"
               ${isEdit ? '' : 'required'} />
      </div>

      <!-- Fullname -->
      <div>
        <label for="fullname">Họ và tên</label>
        <input id="fullname" name="fullname" type="text" required
               value="${isEdit ? u.fullname : ''}" style="width:100%"/>
      </div>

      <!-- Email + Mobile -->
      <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px">
        <div>
          <label for="email">Email</label>
          <input id="email" name="email" type="email" value="${isEdit ? u.email : ''}"/>
        </div>
        <div>
          <label for="mobile">Điện thoại</label>
          <input id="mobile" name="mobile" type="text" value="${isEdit ? u.mobile : ''}"/>
        </div>
      </div>

      <!-- Birthday + Gender -->
      <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px">
        <div>
          <label for="birthday">Ngày sinh</label>
          <c:set var="birthdayValue" value=""/>
          <c:if test="${isEdit and not empty u.birthday}">
            <fmt:formatDate var="birthdayValue" value="${u.birthday}" pattern="yyyy-MM-dd"/>
          </c:if>
          <input id="birthday" name="birthday" type="date" value="${birthdayValue}"/>
        </div>
        <div>
          <label>Giới tính</label>
          <div style="display:flex; gap:12px; align-items:center">
            <label><input type="radio" name="gender" value="true"
              <c:if test="${(isEdit and u.gender == true) or (not isEdit)}">checked="checked"</c:if> /> Nam</label>
            <label><input type="radio" name="gender" value="false"
              <c:if test="${isEdit and u.gender == false}">checked="checked"</c:if> /> Nữ</label>
          </div>
        </div>
      </div>

      <!-- Role -->
      <div>
        <label>
          <input type="checkbox" name="role"
            <c:if test="${isEdit and u.role}">checked="checked"</c:if> />
          Quản trị
        </label>
      </div>

      <!-- Actions -->
      <div class="form-actions" style="margin-top:8px; display:flex; gap:10px">
        <button type="submit" class="btn">${isEdit ? 'Cập nhật' : 'Tạo mới'}</button>
        <a class="btn" href="<c:url value='/admin'><c:param name='action' value='users'/></c:url>">Quay lại</a>
      </div>
    </form>
  </section>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
