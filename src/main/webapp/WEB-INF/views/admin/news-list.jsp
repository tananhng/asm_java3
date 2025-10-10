<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<div class="layout-admin">
  <%@ include file="/WEB-INF/views/layout/sidebar.jsp" %>

  <section class="page">
    <h2>Quản lý Tin tức</h2>

    <c:if test="${not empty message}">
      <div class="alert" style="margin:10px 0; padding:10px; border:1px solid #e5e7eb; background:#fef3c7">
        ${message}
      </div>
    </c:if>

    <c:if test="${not isAdmin}">
      <p style="margin:6px 0 14px; font-size:13px; opacity:.8">
        *Bạn đang xem <strong>bài viết của riêng bạn</strong>.
      </p>
    </c:if>

    <!-- nút thêm -->
    <p>
      <c:url var="addUrl" value="/admin"><c:param name="action" value="edit"/></c:url>
      <a class="btn" href="${addUrl}">+ Thêm bản tin</a>
    </p>

    <!-- Bảng danh sách -->
    <table class="table">
      <thead>
      <tr>
        <th>Id</th>
        <th>Tiêu đề</th>
        <th>Loại</th>
        <th>Home</th>
        <th>Lượt xem</th>
        <th>Ngày đăng</th>
        <th>Thao tác</th>
      </tr>
      </thead>
      <tbody>
      <c:choose>
        <c:when test="${empty newsList}">
          <tr><td colspan="7"><em>Chưa có bản tin nào.</em></td></tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="n" items="${newsList}">
            <tr>
              <td>${n.id}</td>
              <td style="max-width:420px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap">${n.title}</td>
              <td>${empty n.categoryName ? n.categoryId : n.categoryName}</td>
              <td><c:if test="${n.home}">✓</c:if></td>
              <td>${n.viewCount != null ? n.viewCount : 0}</td>
              <td>
                <c:choose>
                  <c:when test="${not empty n.postedDate}">
                    <fmt:formatDate value="${n.postedDate}" pattern="dd/MM/yyyy HH:mm" />
                  </c:when>
                  <c:otherwise>—</c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:url var="editRowUrl" value="/admin">
                  <c:param name="action" value="edit"/>
                  <c:param name="id" value="${n.id}"/>
                </c:url>
                <c:url var="delUrl" value="/admin">
                  <c:param name="action" value="delete"/>
                  <c:param name="id" value="${n.id}"/>
                </c:url>
                <c:url var="viewUrl" value="/users">
                  <c:param name="view" value="detail"/>
                  <c:param name="id" value="${n.id}"/>
                </c:url>
                <a href="${editRowUrl}">Sửa</a> |
                <a href="${delUrl}" onclick="return confirm('Xoá bản tin ${n.id}?');">Xoá</a> |
                <a href="${viewUrl}" target="_blank">Xem</a>
              </td>
            </tr>
          </c:forEach>
        </c:otherwise>
      </c:choose>
      </tbody>
    </table>

    <!-- FORM TẠO/SỬA -->
    <c:set var="editing" value="${requestScope.newsEditing}" />
    <section style="margin-top:24px">
      <h3>
        <c:choose>
          <c:when test="${empty editing}">Thêm bản tin</c:when>
          <c:otherwise>Sửa bản tin #${editing.id}</c:otherwise>
        </c:choose>
      </h3>

      <form action="<c:url value='/admin'/>" method="post" enctype="multipart/form-data"
            style="display:grid; gap:10px; max-width:800px">
        <input type="hidden" name="action" value="${empty editing ? 'create' : 'update'}"/>

        <div>
          <label for="id">Mã tin (Id)</label>
          <input id="id" name="id" type="text"
                 value="${empty editing ? '' : editing.id}"
                 <c:if test="${empty editing}">required="required"</c:if>
                 <c:if test="${not empty editing}">readonly="readonly"</c:if> />
        </div>

        <div>
          <label for="title">Tiêu đề</label>
          <input id="title" name="title" type="text" required
                 value="${empty editing ? '' : editing.title}" style="width:100%"/>
        </div>

        <div>
          <label for="content">Nội dung</label>
          <textarea id="content" name="content" rows="6" style="width:100%">${empty editing ? '' : editing.content}</textarea>
        </div>

        <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px">
          <div>
            <label for="categoryId">Loại (CategoryId)</label>
            <input id="categoryId" name="categoryId" type="text" required
                   value="${empty editing ? '' : editing.categoryId}" />
          </div>
          <div>
            <label for="viewCount">Lượt xem</label>
            <input id="viewCount" name="viewCount" type="number" min="0"
                   value="${empty editing ? 0 : (editing.viewCount != null ? editing.viewCount : 0)}" />
          </div>
        </div>

        <div>
          <label>
            <input type="checkbox" name="home"
              <c:if test="${not empty editing and editing.home}">checked="checked"</c:if> />
            Trang nhất
          </label>
        </div>

        <div>
          <label for="image">Ảnh đại diện (upload mới)</label>
          <input id="image" name="image" type="file" accept="image/*"/>
          <c:if test="${not empty editing and not empty editing.image}">
            <div style="margin-top:8px">
              <small>Hiện tại:</small><br/>
              <img src="${pageContext.request.contextPath}/${editing.image}" alt=""
                   style="max-width:220px; height:auto; border:1px solid #eee; border-radius:8px"/>
            </div>
          </c:if>
        </div>

        <div style="margin-top:8px; display:flex; gap:10px">
          <button class="btn" type="submit">${empty editing ? 'Tạo mới' : 'Cập nhật'}</button>
          <a class="btn" href="<c:url value='/admin'><c:param name='action' value='list'/></c:url>"
             style="background:#6b7280">Huỷ</a>
        </div>
      </form>
    </section>
  </section>
</div>

<%@ include file="/WEB-INF/views/layout/footer.jsp" %>
