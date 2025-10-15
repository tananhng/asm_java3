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

    <!-- nút thêm -> sang trang form -->
    <p>
      <c:url var="addUrl" value="/admin"><c:param name="action" value="news-edit"/></c:url>
      <a class="btn" href="${addUrl}">+ Thêm bản tin</a>
    </p>

    <!-- Bảng danh sách -->
    <table class="table">
      <thead>
      <tr>
        <th>Id</th>
        <th>Tiêu đề</th>
        <th>Tác giả</th>
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
          <tr><td colspan="8"><em>Chưa có bản tin nào.</em></td></tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="n" items="${newsList}">
            <tr>
              <td>${n.id}</td>
              <td style="max-width:420px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap">${n.title}</td>
              <td>${n.idAuthor}</td>
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
  </section>
</div>

<%@ include file="/WEB-INF/views/layout/footer.jsp" %>
