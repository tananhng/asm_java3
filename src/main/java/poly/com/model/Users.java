package poly.com.model;

import java.io.Serializable;
import java.util.Date;
import java.util.Objects;

public class Users implements Serializable {
    private static final long serialVersionUID = 1L;

    private String idAuthor;   // alias cho Id (mã đăng nhập)
    private String password;
    private String fullname;
    private Date   birthday;   // java.util.Date 
    private Boolean gender;    // true/false
    private String mobile;
    private String email;
    private Boolean role;      // true = quản trị, false = phóng viên

    public Users() {}

    // ---- ALIAS CHO Id  ----
    public String getId() {
        return idAuthor;
    }
    public void setId(String id) {
        this.idAuthor = id;
    }

    // ---- Getter/Setter  ----
    public String getIdAuthor() {
        return idAuthor;
    }
    public void setIdAuthor(String idAuthor) {
        this.idAuthor = idAuthor;
    }

    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullname() {
        return fullname;
    }
    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public Date getBirthday() {
        return birthday;
    }
    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public Boolean getGender() {
        return gender;
    }
    public void setGender(Boolean gender) {
        this.gender = gender;
    }

    public String getMobile() {
        return mobile;
    }
    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    // Để EL/JSTL đọc boolean thuận tiện, hỗ trợ cả getRole() lẫn isRole()
    public Boolean getRole() {
        return role;
    }
    public boolean isRole() {
        return role != null && role;
    }
    public void setRole(Boolean role) {
        this.role = role;
    }

    @Override
    public String toString() {
        return "Users{" +
                "id=" + idAuthor +
                ", fullname='" + fullname + '\'' +
                ", email='" + email + '\'' +
                ", role=" + role +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Users)) return false;
        Users that = (Users) o;
        return Objects.equals(idAuthor, that.idAuthor);
    }

    @Override
    public int hashCode() {
        return Objects.hash(idAuthor);
    }
}
