<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="layout-admin">
  <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

  <section class="page">
    <h2>
      <c:choose>
        <c:when test="${empty newsletterEditing}">Thêm Email</c:when>
        <c:otherwise>Sửa Newsletter — ${newsletterEditing.email}</c:otherwise>
      </c:choose>
    </h2>

    <c:if test="${not empty message}">
      <div class="alert" style="margin:10px 0; padding:10px; border:1px solid #e5e7eb; background:#fef3c7">
        ${message}
      </div>
    </c:if>

    <!-- LƯU Ý: action trỏ về /admin + action= newslettters-create/update -->
    <form action="<c:url value='/admin'/>" method="post" style="display:grid; gap:12px; max-width:600px">
      <input type="hidden" name="action" value="${empty newsletterEditing ? 'newsletters-create' : 'newsletters-update'}"/>

      <div>
        <label for="email">Email</label>
        <input id="email" name="email" type="email"
               value="${empty newsletterEditing ? '' : newsletterEditing.email}"
               ${empty newsletterEditing ? 'required' : 'readonly'} />
      </div>

      <div>
        <label>
          <input type="checkbox" name="enabled"
                 <c:if test="${empty newsletterEditing or newsletterEditing.enabled}">checked</c:if> />
          Hiệu lực
        </label>
      </div>

      <div style="display:flex; gap:10px">
        <button class="btn" type="submit">${empty newsletterEditing ? 'Tạo mới' : 'Cập nhật'}</button>
        <a class="btn" href="<c:url value='/admin'><c:param name='action' value='newsletters'/></c:url>" style="background:#6b7280">Huỷ</a>
      </div>
    </form>
  </section>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
