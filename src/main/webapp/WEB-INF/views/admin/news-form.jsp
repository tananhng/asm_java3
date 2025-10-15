<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<c:set var="isEdit"   value="${not empty newsEditing}" />
<c:set var="n"        value="${isEdit ? newsEditing : null}" />
<c:set var="isAdmin"  value="${sessionScope.user != null and sessionScope.user.role}" />
<c:set var="cats"     value="${requestScope.categoriesList}" />
<c:set var="usersAll" value="${requestScope.usersList}" />

<div class="layout-admin">
  <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />
  <section class="page">
    <h2>${isEdit ? 'Sửa' : 'Thêm'} Tin tức</h2>

    <c:if test="${not empty message}">
      <div class="alert" style="margin:.5rem 0 1rem; padding:.75rem 1rem; border:1px solid #fee2e2; background:#fef2f2; color:#991b1b; border-radius:8px;">
        ${message}
      </div>
    </c:if>

    <form class="pure-form" action="<c:url value='/admin'/>" method="post" enctype="multipart/form-data"
          style="display:grid; gap:12px; max-width:780px">
      <input type="hidden" name="action" value="${isEdit ? 'update' : 'create'}"/>

      <c:if test="${isEdit}">
        <label for="id">Id</label>
        <input id="id" name="id" type="text" value="${n.id}" readonly />
      </c:if>

      <label for="title">Tiêu đề</label>
      <input id="title" name="title" type="text" required
             value="${isEdit ? n.title : ''}" placeholder="Tiêu đề bản tin" />

      <label for="content">Nội dung</label>
      <textarea id="content" name="content" rows="8" placeholder="HTML hoặc văn bản thuần...">${isEdit ? n.content : ''}</textarea>

      <c:if test="${isEdit and not empty n.image}">
        <div>
          <small>Ảnh hiện tại:</small><br/>
          <img src="${pageContext.request.contextPath}/${n.image}" alt="${n.title}"
               style="max-width:240px; height:auto; border:1px solid #eee; border-radius:8px;"/>
        </div>
      </c:if>

      <label for="image">Hình ảnh/Video (upload mới, tùy chọn)</label>
      <input id="image" name="image" type="file" accept="image/*,video/*" />

      <label for="postedDate">Ngày đăng</label>
      <c:set var="postedValue" value=""/>
      <c:if test="${isEdit and not empty n.postedDate}">
        <fmt:formatDate var="postedValue" value="${n.postedDate}" pattern="yyyy-MM-dd"/>
      </c:if>
      <input id="postedDate" name="postedDate" type="date" value="${postedValue}" />

      <label for="idAuthor">Tác giả</label>
      <c:choose>
        <c:when test="${isAdmin}">
          <input id="idAuthor" name="idAuthor" type="text"
                 value="${isEdit ? n.idAuthor : ''}" placeholder="Mã phóng viên (vd: user1)" list="authorsList"/>
          <c:if test="${not empty usersAll}">
            <datalist id="authorsList">
              <c:forEach var="u" items="${usersAll}">
                <option value="${u.id}">${u.fullname}</option>
              </c:forEach>
            </datalist>
          </c:if>
          <small style="opacity:.7">Bỏ trống sẽ tự gán bạn là tác giả.</small>
        </c:when>
        <c:otherwise>
          <input type="text" value="${sessionScope.user.id}" readonly />
          <input type="hidden" name="idAuthor" value="${sessionScope.user.id}" />
          <small style="opacity:.7">Bạn là tác giả bài viết.</small>
        </c:otherwise>
      </c:choose>

      <label for="viewCount">Lượt xem</label>
      <input id="viewCount" name="viewCount" type="number" min="0"
             value="${isEdit ? (n.viewCount != null ? n.viewCount : 0) : 0}" />

      <label for="categoryId">Loại tin</label>
      <c:choose>
        <c:when test="${not empty cats}">
          <select id="categoryId" name="categoryId" required>
            <option value="" disabled <c:if test="${not isEdit}">selected</c:if> >-- Chọn loại tin --</option>
            <c:forEach var="c" items="${cats}">
              <option value="${c.id}"
                <c:if test="${isEdit and c.id == n.categoryId}">selected</c:if>>
                ${c.name} (${c.id})
              </option>
            </c:forEach>
          </select>
        </c:when>
        <c:otherwise>
          <input id="categoryId" name="categoryId" type="text" required
                 value="${isEdit ? n.categoryId : ''}" placeholder="VD: cong-nghe / the-thao / thoi-su ..." />
        </c:otherwise>
      </c:choose>

      <label>
        <input type="checkbox" name="home" <c:if test="${isEdit and n.home}">checked="checked"</c:if> />
        Trang nhất (hiển thị trên trang chủ)
      </label>

      <div class="form-actions" style="margin-top:8px; display:flex; gap:10px">
        <button type="submit" class="btn">${isEdit ? 'Cập nhật' : 'Thêm mới'}</button>
        <a class="btn" href="<c:url value='/admin'><c:param name='action' value='list'/></c:url>">Quay lại</a>
      </div>
    </form>
  </section>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
