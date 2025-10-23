<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<c:set var="isEdit" value="${not empty userEditing}" />
<c:set var="u"      value="${isEdit ? userEditing : null}" />

<%-- Lấy sẵn chuỗi placeholder để dùng trong EL --%>
<fmt:message key="admin.users.password.leaveBlank" var="leaveBlank"/>

<div class="layout-admin">
  <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

  <section class="page">
    <h2>
      <c:choose>
        <c:when test="${isEdit}"><fmt:message key="admin.users.form.edit"/></c:when>
        <c:otherwise><fmt:message key="admin.users.form.add"/></c:otherwise>
      </c:choose>
    </h2>

    <c:if test="${not empty message}">
      <div class="alert" style="margin:.5rem 0 1rem; padding:.75rem 1rem; border:1px solid #fee2e2; background:#fef2f2; color:#991b1b; border-radius:8px;">
        ${message}
      </div>
    </c:if>

    <form action="<c:url value='/admin'/>" method="post" style="display:grid; gap:12px; max-width:780px">
      <input type="hidden" name="action" value="${isEdit ? 'users-update' : 'users-create'}"/>

      <!-- Id -->
      <div>
        <label for="id"><fmt:message key="admin.users.id"/></label>
        <input id="id" name="id" type="text"
               value="${isEdit ? u.id : ''}"
               ${isEdit ? 'readonly' : 'required'} />
      </div>

      <!-- Password -->
      <div>
        <label for="password"><fmt:message key="admin.users.password"/></label>
        <input id="password" name="password" type="password"
               placeholder="${isEdit ? leaveBlank : ''}"
               ${isEdit ? '' : 'required'} />
      </div>

      <!-- Fullname -->
      <div>
        <label for="fullname"><fmt:message key="admin.users.fullname"/></label>
        <input id="fullname" name="fullname" type="text" required
               value="${isEdit ? u.fullname : ''}" style="width:100%"/>
      </div>

      <!-- Email + Mobile -->
      <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px">
        <div>
          <label for="email"><fmt:message key="admin.users.email"/></label>
          <input id="email" name="email" type="email" value="${isEdit ? u.email : ''}"/>
        </div>
        <div>
          <label for="mobile"><fmt:message key="admin.users.mobile"/></label>
          <input id="mobile" name="mobile" type="text" value="${isEdit ? u.mobile : ''}"/>
        </div>
      </div>

      <!-- Birthday + Gender -->
      <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px">
        <div>
          <label for="birthday"><fmt:message key="admin.users.birthday"/></label>
          <c:set var="birthdayValue" value=""/>
          <c:if test="${isEdit and not empty u.birthday}">
            <fmt:formatDate var="birthdayValue" value="${u.birthday}" pattern="yyyy-MM-dd"/>
          </c:if>
          <input id="birthday" name="birthday" type="date" value="${birthdayValue}"/>
        </div>
        <div>
          <label><fmt:message key="admin.users.gender"/></label>
          <div style="display:flex; gap:12px; align-items:center">
            <label><input type="radio" name="gender" value="true"
              <c:if test="${(isEdit and u.gender == true) or (not isEdit)}">checked="checked"</c:if> />
              <fmt:message key="gender.male"/>
            </label>
            <label><input type="radio" name="gender" value="false"
              <c:if test="${isEdit and u.gender == false}">checked="checked"</c:if> />
              <fmt:message key="gender.female"/>
            </label>
          </div>
        </div>
      </div>

      <!-- Role -->
      <div>
        <label>
          <input type="checkbox" name="role"
            <c:if test="${isEdit and u.role}">checked="checked"</c:if> />
          <fmt:message key="admin.users.role.admin"/>
        </label>
      </div>

      <!-- Actions -->
      <div class="form-actions" style="margin-top:8px; display:flex; gap:10px">
        <button type="submit" class="btn">
          <c:choose>
            <c:when test="${isEdit}"><fmt:message key="common.update"/></c:when>
            <c:otherwise><fmt:message key="common.create"/></c:otherwise>
          </c:choose>
        </button>
        <a class="btn" href="<c:url value='/admin'><c:param name='action' value='users'/></c:url>">
          <fmt:message key="common.back"/>
        </a>
      </div>
    </form>
  </section>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
