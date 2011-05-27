package vocrep.service;

import org.w3c.dom.Document;


public interface ICacheAPI {
	public void CacheDocument(Document document);
	public Document GetSchemeCache();
}
