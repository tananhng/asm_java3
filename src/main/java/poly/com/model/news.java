package poly.com.model;

import java.io.Serializable;
import java.util.Date;
import java.util.Objects;

public class news implements Serializable {
    private static final long serialVersionUID = 1L;

    // ====== Columns (NEWS) ======
    private String  id;           // PK (VARCHAR). Nếu DB để IDENTITY thì đổi sang Integer/Long.
    private String  title;        // Tiêu đề
    private String  content;      // Nội dung (HTML/text)
    private String  image;        // Ảnh/Video path
    private Date    postedDate;   // Ngày đăng
    private Integer viewCount = 0;
    private Boolean home     = false;
    private String  idAuthor;     // Mã tác giả
    private String  categoryId;   // Mã loại

    // ====== Field phụ từ JOIN (không map vào DB trực tiếp) ======
    private String  categoryName;

    public news() {}

    public news(String id, String title, String content, String image,
                Date postedDate, Integer viewCount, Boolean home,
                String idAuthor, String categoryId) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.image = image;
        this.postedDate = postedDate;
        this.viewCount = viewCount;
        this.home = home;
        this.idAuthor = idAuthor;
        this.categoryId = categoryId;
    }

    // ====== Getters/Setters ======
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public Date getPostedDate() { return postedDate; }
    public void setPostedDate(Date postedDate) { this.postedDate = postedDate; }

    public Integer getViewCount() { return viewCount; }
    public void setViewCount(Integer viewCount) { this.viewCount = viewCount; }

    public Boolean getHome() { return home; }
    public void setHome(Boolean home) { this.home = home; }

    public String getIdAuthor() { return idAuthor; }
    public void setIdAuthor(String idAuthor) { this.idAuthor = idAuthor; }

    public String getCategoryId() { return categoryId; }
    public void setCategoryId(String categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    // ====== Object contract ======
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof news n)) return false;
        return Objects.equals(id, n.id);
    }
    @Override
    public int hashCode() { return Objects.hash(id); }

    @Override
    public String toString() {
        return "news{" +
            "id='" + id + '\'' +
            ", title='" + title + '\'' +
            ", content(len)=" + (content == null ? 0 : content.length()) +
            ", image='" + image + '\'' +
            ", postedDate=" + postedDate +
            ", viewCount=" + viewCount +
            ", home=" + home +
            ", idAuthor='" + idAuthor + '\'' +
            ", categoryId='" + categoryId + '\'' +
            ", categoryName='" + categoryName + '\'' +
            '}';
    }
}
