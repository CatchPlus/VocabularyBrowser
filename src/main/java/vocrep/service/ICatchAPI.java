package vocrep.service;

import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;


public interface ICatchAPI {
	
	/**
	 * Get all the concept scheme groups
	 * @return URL - all concept scheme groups
	 * @throws MalformedURLException
	 */
	public URL getAllConceptschemeGroups() throws MalformedURLException;
	
	/**
	 * Get all the concept schemes
	 * @param uri
	 * @return URL - all concept schemes
	 * @throws MalformedURLException
	 */
	public URL getAllConceptschemes(String uri) throws MalformedURLException;
	
	/**
	 * Get the concepts
	 * @param uri
	 * @param prefix
	 * @return URL - the concepts
	 * @throws MalformedURLException
	 */
	public URL getConcepts(String uri, String prefix) throws MalformedURLException;
	
	/**
	 * Get the concept relations
	 * @param uri
	 * @return URl - the concept relations
	 * @throws MalformedURLException
	 */
	public URL getConceptRelations(String uri) throws MalformedURLException;
	
	/**
	 * Get the concept details
	 * @param uri
	 * @return URL - the concepts details
	 * @throws MalformedURLException
	 */
	public URL getConceptDetails(String uri) throws MalformedURLException;
	
	/**
	 * Get the concepts for a scheme
	 * @param uri
	 * @return URL - the concepts for a scheme
	 * @throws MalformedURLException
	 */
	public URL findConceptInScheme(String uri) throws MalformedURLException;
	
	/**
	 * Get the ConceptSchemeGroup for a SchemeGroup
	 * @param uri
	 * @return URL - the CSG for a scheme, if any
	 * @throws MalformedURLException
	 */
	public URL findCSGbyCS(String uri) throws MalformedURLException;
	/**
	 * Get the left alingnment
	 * @param uri
	 * @return URL - the left alingment
	 * @throws MalformedURLException
	 */
	public URL getLhsAlignment(String uri) throws MalformedURLException;
	
	/**
	 * Get the right alignment
	 * @param uri
	 * @return URL - the right alignment
	 * @throws MalformedURLException
	 */
	public URL getRhsAlignment(String uri) throws MalformedURLException;
	
	/**
	 * Execute a free search
	 * @param query
	 * @param match
	 * @param label
	 * @param lang
	 * @return URL - free search
	 * @throws MalformedURLException
	 * @throws UnsupportedEncodingException 
	 */
	public URL getFreeSearchUri(String query, String match, String label, String lang) throws MalformedURLException, UnsupportedEncodingException;
	
	/**
	 * Get the concepts
	 * @param query
	 * @param match
	 * @param label
	 * @param lang
	 * @param cs
	 * @return URL - concepts
	 * @throws MalformedURLException
	 * @throws UnsupportedEncodingException
	 */
	public URL getSearchConceptsUri(String query, String match, String label, String lang, String cs) throws MalformedURLException, UnsupportedEncodingException;	
}
