<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<c:url var="homeUrl"       value="/users"><c:param name="view" value="list"/></c:url>
<c:url var="dashUrl"       value="/admin"><c:param name="action" value="dashboard"/></c:url>
<c:url var="newsListUrl"   value="/admin"><c:param name="action" value="list"/></c:url>
<c:url var="editNewsUrl"   value="/admin"><c:param name="action" value="edit"/></c:url>
<c:url var="catsUrl"       value="/admin"><c:param name="action" value="categories"/></c:url>
<c:url var="usersUrl"      value="/admin"><c:param name="action" value="users"/></c:url>
<c:url var="subsUrl"       value="/admin"><c:param name="action" value="newsletters"/></c:url>

<div class="layout-admin">
  <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

  <section class="page">
    <h2>Bảng điều khiển</h2>

    <c:if test="${not empty message}">
      <div class="alert" style="margin:10px 0; padding:10px; border:1px solid #e5e7eb; background:#fef3c7">
        ${message}
      </div>
    </c:if>

    <!-- Cards thống kê -->
    <div class="cards" style="margin-top:12px">
      <article class="card"><div style="padding:16px">
        <div style="opacity:.7">Tổng bài viết</div>
        <div style="font-size:28px; font-weight:700">${countNews != null ? countNews : 0}</div>
      </div></article>

      <article class="card"><div style="padding:16px">
        <div style="opacity:.7">Loại tin</div>
        <div style="font-size:28px; font-weight:700">${countCategories != null ? countCategories : 0}</div>
      </div></article>

      <article class="card"><div style="padding:16px">
        <div style="opacity:.7">Người dùng</div>
        <div style="font-size:28px; font-weight:700">${countUsers != null ? countUsers : 0}</div>
      </div></article>

      <article class="card"><div style="padding:16px">
        <div style="opacity:.7">Subscribers</div>
        <div style="font-size:28px; font-weight:700">${countSubs != null ? countSubs : 0}</div>
      </div></article>
    </div>

    <!-- Hành động nhanh -->
    <div class="cards" style="margin-top:16px">
      <article class="card">
        <div style="padding:16px">
          <h3 style="margin:0 0 8px">Hành động nhanh</h3>
          <p style="margin:0 0 10px; opacity:.8">Các thao tác thường dùng</p>

          <p style="margin:0 0 8px"><a class="btn" href="${editNewsUrl}">+ Thêm bản tin</a></p>
          <p style="margin:0 0 8px"><a class="btn" href="${newsListUrl}">Quản lý tin tức</a></p>
          <p style="margin:0 0 8px"><a class="btn" href="${catsUrl}">Quản lý loại tin</a></p>
          <p style="margin:0"><a class="btn" href="${subsUrl}">Quản lý newsletter</a></p>
        </div>
      </article>
    </div>

    <!-- Bài viết mới -->
    <section style="margin-top:22px">
      <h3>Bài viết mới</h3>
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
            <c:when test="${empty latestNews}">
              <tr><td colspan="7"><em>Chưa có dữ liệu.</em></td></tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="n" items="${latestNews}">
                <tr>
                  <td>${n.id}</td>
                  <td style="max-width:420px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap">${n.title}</td>
                  <td>${empty n.categoryName ? n.categoryId : n.categoryName}</td>
                  <td><c:if test="${n.home}">✓</c:if></td>
                  <td>${n.viewCount != null ? n.viewCount : 0}</td>
                  <td>
                    <c:choose>
                      <c:when test="${not empty n.postedDate}">
                        <fmt:formatDate value="${n.postedDate}" pattern="dd/MM/yyyy HH:mm"/>
                      </c:when>
                      <c:otherwise>—</c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <a href="<c:url value='/admin'><c:param name='action' value='edit'/><c:param name='id' value='${n.id}'/></c:url>">Sửa</a>
                    |
                    <a href="<c:url value='/users'><c:param name='view' value='detail'/><c:param name='id' value='${n.id}'/></c:url>" target="_blank">Xem</a>
                  </td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </section>
  </section>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
