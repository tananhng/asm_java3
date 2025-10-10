<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../layout/header.jsp" %>

<div class="layout-admin">
  <%@ include file="../layout/sidebar.jsp" %>

  <section class="page">
    <h2>
      <c:choose>
        <c:when test="${empty newsletterEditing}">Thêm Newsletter</c:when>
        <c:otherwise>Sửa Newsletter — ${newsletterEditing.email}</c:otherwise>
      </c:choose>
    </h2>

    <form action="<c:url value='/admin-newsletters'/>" method="post" style="display:grid; gap:12px; max-width:600px">
      <input type="hidden" name="action" value="${empty newsletterEditing ? 'create' : 'update'}"/>

      <div>
        <label for="email">Email</label>
        <input id="email" name="email" type="email"
               value="${empty newsletterEditing ? '' : newsletterEditing.email}"
               ${empty newsletterEditing ? 'required' : 'readonly'} />
      </div>

      <div>
        <label>
          <input type="checkbox" name="enabled" ${empty newsletterEditing ? 'checked' : (newsletterEditing.enabled ? 'checked' : '')}/>
          Hiệu lực
        </label>
      </div>

      <div style="display:flex; gap:10px">
        <button class="btn" type="submit">${empty newsletterEditing ? 'Tạo mới' : 'Cập nhật'}</button>
        <a class="btn" href="<c:url value='/admin-newsletters'><c:param name='action' value='list'/></c:url>" style="background:#6b7280">Huỷ</a>
      </div>
    </form>
  </section>
</div>

<%@ include file="../layout/footer.jsp" %>
