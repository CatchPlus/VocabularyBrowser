package vocrep.service;

import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Element;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

@Service
public class CacheAPI implements ICacheAPI {

	@Autowired
	private CacheManager cacheManager;
	private String CacheKey = "VocRepCache";
	private String SchemesKey = "schemes";	

	public void CacheDocument(Document document) {
		Cache newCache = cacheManager.getCache(CacheKey);
		Element scheme = new Element(SchemesKey, document);
		newCache.put(scheme);
	}

	public Document GetSchemeCache() {
		Cache cache = cacheManager.getCache(CacheKey);
		if (cache == null)
			return null;

		Element element = cache.get(SchemesKey);
		if (element != null) {
			Object value = element.getObjectValue();
			return (Document) value;
		}
		return null;
	}
}
