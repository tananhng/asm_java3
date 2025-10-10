<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../layout/header.jsp" %>

<div class="layout-admin">
  <%@ include file="../layout/sidebar.jsp" %>

  <section class="page">
    <h2>
      <c:choose>
        <c:when test="${empty categoryEditing}">Thêm Loại tin</c:when>
        <c:otherwise>Sửa Loại tin — ${categoryEditing.id}</c:otherwise>
      </c:choose>
    </h2>

    <c:if test="${not empty message}">
      <div class="alert" style="margin:10px 0; padding:10px; border:1px solid #e5e7eb; background:#fef3c7">
        ${message}
      </div>
    </c:if>

    <form action="<c:url value='/admin-categories'/>" method="post" style="display:grid; gap:12px; max-width:600px">
      <input type="hidden" name="action" value="${empty categoryEditing ? 'create' : 'update'}"/>

      <c:choose>
        <c:when test="${empty categoryEditing}">
          <div>
            <label for="id">Mã loại (Id)</label>
            <input id="id" name="id" type="text" required />
          </div>
        </c:when>
        <c:otherwise>
          <input type="hidden" name="id" value="${categoryEditing.id}"/>
          <div>
            <label>Mã loại</label>
            <input type="text" value="${categoryEditing.id}" readonly/>
          </div>
        </c:otherwise>
      </c:choose>

      <div>
        <label for="name">Tên loại</label>
        <input id="name" name="name" type="text" required value="${empty categoryEditing ? '' : categoryEditing.name}" />
      </div>

      <div style="display:flex; gap:10px">
        <button class="btn" type="submit">${empty categoryEditing ? 'Tạo mới' : 'Cập nhật'}</button>
        <a class="btn" href="<c:url value='/admin-categories'><c:param name='action' value='list'/></c:url>" style="background:#6b7280">Huỷ</a>
      </div>
    </form>
  </section>
</div>

<%@ include file="../layout/footer.jsp" %>
