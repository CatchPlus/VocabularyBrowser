package vocrep.service;

import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;

import org.apache.commons.lang.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class CatchAPI implements ICatchAPI{
	
	@Value(value="#{appProperties.resultsLimit}")
	private int limit = 200;
	
	@Value(value="#{appProperties.catchApiUrl}")
	private String catchApi;	
	
	
	public URL getFreeSearchUri(String query, String matchkind, String label, String lang) throws MalformedURLException, UnsupportedEncodingException{
		query = URLEncoder.encode(query,"UTF-8");
		String searchUrl = "/find/concept?format=xml&query=" + query + "&limit="+limit+"&info=skos_concept";
		if(matchkind != "")
			searchUrl += "&match_kind="+ matchkind;
		if(label != "")
			searchUrl += "&match_property=skos:"+ label;
		
		if(lang != "")
			searchUrl += "&match_language="+ lang;
		
		return new URL(catchApi + searchUrl);		 
	}
	
	public URL getSearchConceptsUri(String query, String matchkind, String label, String lang, String cs) throws MalformedURLException, UnsupportedEncodingException{
		query = URLEncoder.encode(query,"UTF-8");
		String searchUrl = "/find/concept?format=xml&limit="+limit+"&sort=match_property&info=skos_concept&query=" + query;
		
		if(matchkind != "")
			searchUrl += "&match_kind="+ matchkind;
		if(label != "")
			searchUrl += "&match_property=skos:"+ label;
		
		if(lang != "")
			searchUrl += "&match_language="+ lang;
		
		if(cs != "")
			searchUrl += "&cs="+ URLEncoder.encode(cs,"UTF-8");

		return new URL(catchApi + searchUrl);		 
	}
	
    public URL getAllConceptschemeGroups() throws MalformedURLException{ 
        return new URL(catchApi + "/find/conceptschemegroup?q42=1&limit="+limit+"&format=xml&info=csg_label");
    }
    
	public URL getAllConceptschemes(String uri) throws MalformedURLException {
		return new URL(catchApi+ "/find/conceptscheme?q42=2&limit="+limit+"&format=xml&info=cs_label&csg="+StringEscapeUtils.escapeJavaScript(uri));
	}
	
	public URL getConcepts(String uri, String prefix)throws MalformedURLException {
      if (prefix!= null && prefix.length() > 0)
    	  return new URL(catchApi + "/find/concept?q42=3&format=xml&limit="+limit+"&format=xml&sort=match_label&match_property=skos:prefLabel&match_property=skos:altLabel&cs="+uri+"&match_kind=regex&query=^"+prefix);
      else	      
    	  return new URL(catchApi + "/find/concept?q42=3&format=xml&limit="+limit+"&format=xml&sort=match_label&match_property=skos:prefLabel&top_concept_of="+uri);
	}
	
	public URL getConceptRelations(String uri) throws MalformedURLException {		
		return new URL(catchApi + "/find/relation?q42=4&filter=no_oaei&format=xml&limit=20&info2=c_label&type2=skos:Concept&label_lang=nl,en,fr,de,*&relation=skos_relation&uri1="+uri);
	}
	
	public URL findConceptInScheme(String uri) throws MalformedURLException {
		return new URL(catchApi + "/find/relation?q42=6&format=xml&info2=cs_label&type2=skos:ConceptScheme&label_lang=nl,en,fr,de,*&relation=skos:inScheme&filter=no_oaei&uri1="+uri);
	}
	
	public URL findCSGbyCS(String uri) throws MalformedURLException {
		return new URL(catchApi + "/find/conceptscheme?format=xml&info=csg&uri=" + uri);
	}
	
	public URL getConceptDetails(String uri) throws MalformedURLException {		
		return new URL(catchApi + "/find/concept?q42=5&format=xml&info=skos_concept&uri="+uri);
	}	
	
	public URL getLhsAlignment(String uri) throws MalformedURLException {		
		return new URL(catchApi + "/find/alignment?q42=5&format=xml&info=a_label&label_lang=nl,*&info=align:onto1&info=align:onto2&onto1="+uri);
	}
	
	public URL getRhsAlignment(String uri) throws MalformedURLException {		
		return new URL(catchApi + "/find/alignment?q42=5&format=xml&info=a_label&label_lang=nl,*&info=align:onto1&info=align:onto2&onto2="+uri);
	}
}
