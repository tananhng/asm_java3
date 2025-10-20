package poly.com.utils;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.*;

public class Utf8Control extends ResourceBundle.Control {
  @Override
  public ResourceBundle newBundle(String baseName, Locale locale, String format,
      ClassLoader loader, boolean reload) throws IllegalAccessException, InstantiationException, IOException {
    String bundleName = toBundleName(baseName, locale);
    String resourceName = toResourceName(bundleName, "properties");
    try (InputStream is = loader.getResourceAsStream(resourceName)) {
      if (is == null) return null;
      try (Reader reader = new InputStreamReader(is, StandardCharsets.UTF_8)) {
        return new PropertyResourceBundle(reader);
      }
    }
  }
}
