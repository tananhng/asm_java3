<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<c:set var="isEdit"   value="${not empty newsEditing}" />
<c:set var="n"        value="${isEdit ? newsEditing : null}" />
<c:set var="isAdmin"  value="${requestScope.isAdmin}" />
<c:set var="cats"     value="${requestScope.categoriesList}" />
<c:set var="usersAll" value="${requestScope.usersList}" />

<div class="layout-admin">
  <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

  <section class="page">
    <h2>
      <c:choose>
        <c:when test="${isEdit}">
          <fmt:message key="admin.news.form.edit"/>
        </c:when>
        <c:otherwise>
          <fmt:message key="admin.news.form.add"/>
        </c:otherwise>
      </c:choose>
    </h2>

    <c:if test="${not empty message}">
      <div class="alert" style="margin:.5rem 0 1rem; padding:.75rem 1rem; border:1px solid #fee2e2; background:#fef2f2; color:#991b1b; border-radius:8px;">
        ${message}
      </div>
    </c:if>

    <form class="pure-form" action="<c:url value='/admin'/>" method="post" enctype="multipart/form-data"
          style="display:grid; gap:12px; max-width:780px">
      <input type="hidden" name="action" value="${isEdit ? 'update' : 'create'}"/>

      <c:if test="${isEdit}">
        <label for="id"><fmt:message key="admin.table.id"/></label>
        <input id="id" name="id" type="text" value="${n.id}" readonly />
      </c:if>

      <label for="title"><fmt:message key="admin.news.form.title"/></label>
      <input id="title" name="title" type="text" required
             value="${isEdit ? n.title : ''}" placeholder="<fmt:message key='admin.news.form.title.ph'/>" />

      <label for="content"><fmt:message key="admin.news.form.content"/></label>
      <textarea id="content" name="content" rows="8" placeholder="<fmt:message key='admin.news.form.content.ph'/>">${isEdit ? n.content : ''}</textarea>

      <c:if test="${isEdit and not empty n.image}">
        <div>
          <small><fmt:message key="admin.news.form.currentImage"/></small><br/>
          <img src="${pageContext.request.contextPath}/${n.image}" alt="${n.title}"
               style="max-width:240px; height:auto; border:1px solid #eee; border-radius:8px;"/>
        </div>
      </c:if>

      <label for="image"><fmt:message key="admin.news.form.upload"/></label>
      <input id="image" name="image" type="file" accept="image/*,video/*" />

      <label for="postedDate"><fmt:message key="admin.table.date"/></label>
      <c:set var="postedValue" value=""/>
      <c:if test="${isEdit and not empty n.postedDate}">
        <fmt:formatDate var="postedValue" value="${n.postedDate}" pattern="yyyy-MM-dd"/>
      </c:if>
      <input id="postedDate" name="postedDate" type="date" value="${postedValue}" />

      <label for="idAuthor"><fmt:message key="admin.news.form.author"/></label>
      <c:choose>
        <c:when test="${isAdmin}">
          <input id="idAuthor" name="idAuthor" type="text"
                 value="${isEdit ? n.idAuthor : ''}" placeholder="<fmt:message key='admin.news.form.author.ph'/>" list="authorsList"/>
          <c:if test="${not empty usersAll}">
            <datalist id="authorsList">
              <c:forEach var="u" items="${usersAll}">
                <option value="${u.id}">${u.fullname}</option>
              </c:forEach>
            </datalist>
          </c:if>
          <small style="opacity:.7"><fmt:message key="admin.news.form.author.hint"/></small>
        </c:when>
        <c:otherwise>
          <input type="text" value="${sessionScope.user.id}" readonly />
          <input type="hidden" name="idAuthor" value="${sessionScope.user.id}" />
          <small style="opacity:.7"><fmt:message key="admin.news.form.author.self"/></small>
        </c:otherwise>
      </c:choose>

      <label for="viewCount"><fmt:message key="admin.table.views"/></label>
      <input id="viewCount" name="viewCount" type="number" min="0"
             value="${isEdit ? (n.viewCount != null ? n.viewCount : 0) : 0}" />

      <label for="categoryId"><fmt:message key="admin.table.category"/></label>
      <c:choose>
        <c:when test="${not empty cats}">
          <select id="categoryId" name="categoryId" required>
            <option value="" disabled <c:if test="${not isEdit}">selected</c:if> >-- <fmt:message key="admin.news.form.category.choose"/> --</option>
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
                 value="${isEdit ? n.categoryId : ''}" placeholder="<fmt:message key='admin.news.form.category.ph'/>" />
        </c:otherwise>
      </c:choose>

      <label>
        <input type="checkbox" name="home" <c:if test="${isEdit and n.home}">checked="checked"</c:if> />
        <fmt:message key="admin.news.form.home"/>
      </label>

      <div class="form-actions" style="margin-top:8px; display:flex; gap:10px">
        <button type="submit" class="btn">
          <c:choose>
            <c:when test="${isEdit}"><fmt:message key="common.update"/></c:when>
            <c:otherwise><fmt:message key="common.create"/></c:otherwise>
          </c:choose>
        </button>
        <a class="btn" href="<c:url value='/admin'><c:param name='action' value='list'/></c:url>">
          <fmt:message key="common.back"/>
        </a>
      </div>
    </form>
  </section>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
