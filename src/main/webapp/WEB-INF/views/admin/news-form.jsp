<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<c:set var="isEdit" value="${not empty newsEditing}" />
<c:set var="n" value="${isEdit ? newsEditing : null}" />

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

      <label for="id">Id</label>
      <input id="id" name="id" type="text"
             value="${isEdit ? n.id : ''}"
             ${isEdit ? 'readonly' : 'required'}
             placeholder="VD: N001" />

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

      <label for="idAuthor">Tác giả (mã phóng viên)</label>
      <input id="idAuthor" name="idAuthor" type="text"
             value="${isEdit ? n.idAuthor : ''}" placeholder="VD: PV001" />

      <label for="viewCount">Lượt xem</label>
      <input id="viewCount" name="viewCount" type="number" min="0"
             value="${isEdit ? (n.viewCount != null ? n.viewCount : 0) : 0}" />

      <label for="categoryId">Mã loại tin</label>
      <input id="categoryId" name="categoryId" type="text" required
             value="${isEdit ? n.categoryId : ''}" placeholder="VD: cong-nghe / the-thao / thoi-su ..." />

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
