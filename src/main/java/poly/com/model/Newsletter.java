// poly/com/model/Newsletter.java
package poly.com.model;
import java.io.Serializable;

public class Newsletter implements Serializable {
    private String email;
    private Boolean enabled;
    // getters/setters
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public Boolean getEnabled() { return enabled; }
    public void setEnabled(Boolean enabled) { this.enabled = enabled; }
}
