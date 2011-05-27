<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="yes" />
	

	<xsl:param name="level" />
	<xsl:variable name="results" select="/root/results/result" />
	<xsl:variable name="freesearch" select="/search/concepts/result" />
	<xsl:variable name="schemes" select="/search/groups" />
	<xsl:variable name="filterschemesroot" select="/root/schemes"/>
	<xsl:variable name="filterschemessearch" select="/search/schemes"/>
		
	<!--  <xsl:variable name="lalignment" select="/root/lalignment" /> -->
	<!-- <xsl:variable name="ralignment" select="/root/ralignment" /> -->
	<xsl:param name="letter" />
	<xsl:param name="query" />
	<xsl:param name="match" />
	<xsl:param name="label" />
	<xsl:param name="lang" />
	<xsl:param name="group" />
	<xsl:param name="nextlevel" />
	<xsl:param name="highlight" />

	<xsl:template match="/">	
	<html>
<head>

<title>Catch Plus Vocabulary Repository</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<link href="/assets/css/screen.css" rel="stylesheet" type="text/css" media="screen"/>
<script src="http://jqueryjs.googlecode.com/files/jquery-1.3.2.js"></script>
<!--  <script src="http://code.jquery.com/jquery-1.4.2.min.js"></script>  -->
<script type="text/javascript" src="/assets/js/jquery.history.js"></script>
<script	type="text/javascript" src="/assets/js/finder.js"></script>
<script	type="text/javascript" src="/assets/js/vocrep.js"></script>
</head>
<body>
<div id="page">
<div id="header">
<h1><img src="/assets/img/vocrep_logo.gif"
	alt="Catch Plus Vocabulairebank"/></h1>
<div class="clear"><span> </span></div>
</div>

<div id="searcher">
	<div class="panel-nav">
		<ul>
			<li><a href="/search.do" id="freesearch">Zoeken</a></li>
			<li><a href="/index.html">Browse</a></li>					
		</ul>
	</div>
	<div id="freesearch-form" class="basic">
	<xsl:if test="$lang != '' or $label != '' or $match != '' or $group != ''">
		<xsl:attribute name="class">advanced</xsl:attribute>
	</xsl:if>					
			<form class="searchForm" action="search.do" method="get">
				<div class="searchTerms">
					<input id="freesearch-input" type="text" value="{$query}" name="query" />
					<input type="submit" id="freesearch-searchBtn" value="zoeken" />
					
					<a href="#" class="search-mode-advanced">Uitgebreid zoeken</a>
					<a href="#" class="search-mode-simpel">Simpel zoeken</a>
				</div>

				<div class="freesearch-advanced">
						<select class="advanced-option" id="freesearch-taal" name="taal">
							<option value="">Alle talen</option>
							<option value="nl">
							<xsl:if test="$lang='nl'">
							<xsl:attribute name="selected">true</xsl:attribute>
							</xsl:if>
							Nederlands</option>
							<option value="en">
							<xsl:if test="$lang='en'">
							<xsl:attribute name="selected">true</xsl:attribute>
							</xsl:if>Engels</option>
							<option value="fr">
							<xsl:if test="$lang='fr'">
							<xsl:attribute name="selected">true</xsl:attribute>
							</xsl:if>Frans</option>
							<option value="de">
							<xsl:if test="$lang='de'">
							<xsl:attribute name="selected">true</xsl:attribute>
							</xsl:if>Duits</option>
						</select>
									
						<select class="advanced-option" id="freesearch-group" name="group">
							<option value="">Alle scheme groepen</option>
								<xsl:apply-templates select="$schemes/group/result" mode="mainGroup">
									<xsl:sort select="info/label"/>
								</xsl:apply-templates>
						</select>	
						
						<!-- 
						<label for="freesearch-matchkind">reguliere expressie</label>
						<input type="checkbox"  name="match" id="freesearch-matchkind" value="regex" >
							<xsl:if test="$match='regex'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						 -->
						   
						<select class="advanced-option" id="freesearch-matchkind" name="match">
							<option value="">Standaard zoeken</option>
							<option value="regex">
							<xsl:if test="$match='regex'">
							<xsl:attribute name="selected">true</xsl:attribute>
							</xsl:if>Zoeken met reguliere expressie</option>
						</select>									
						
						
						<!-- 
						<label for="freesearch-label">doorzoek ook alternatieve labels</label>
						<input type="checkbox" name="label" id="freesearch-label" value="altLabel" >
							<xsl:if test="$label='altLabel'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						-->
						 		
						
						<select class="advanced-option" id="freesearch-label" name="label">
							<option value="">Alle labels</option>
							<option value="prefLabel">
							<xsl:if test="$label='prefLabel'">
							<xsl:attribute name="selected">true</xsl:attribute>
							</xsl:if>voorkeursterm</option>
							<option value="altLabel">
							<xsl:if test="$label='altLabel'">
							<xsl:attribute name="selected">true</xsl:attribute>
							</xsl:if>niet voorkeursterm</option>
						</select>
					 	
									
				</div>
			</form>
			<div class="searchResults">
				<xsl:apply-templates select="search/concepts/result"
					mode="freesearch" />
			</div>					
				</div>
</div>
	</div>
	</body>
	</html>
	</xsl:template>

<xsl:template match="result[not(statusCode)]" mode="mainGroup">
	<option class="mainGroup" value="[GROUP]"> <!--  the value [GROUP] is used in the js to handle this special case -->
		<xsl:value-of select="info/label"/>
	</option> 
	<xsl:apply-templates select="$schemes/group[result/info/label=current()/info/label]/schemes/result/result" mode="schemegroup">
		<xsl:sort select="info/label"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="result[not(statusCode)]" mode="schemegroup">
	<option value="{uri}" class="groupScheme">
	<xsl:if test="$group=current()/uri">
	<xsl:attribute name="selected">true</xsl:attribute>
	</xsl:if>
	<xsl:value-of select="info/label"/>
	</option> 
</xsl:template>

	<xsl:template match="/root">
		<xsl:apply-templates select="results/result" />
	</xsl:template>

	<xsl:template match="result" mode="freesearch">
		<xsl:choose>
			<xsl:when test="statusCode != 200">
				<h2>Deze query kan niet uitgevoerd worden!</h2>
				<p>
				Als u de optie 'reguliere expressie' aanvinkt moet de query voldoen aan de <a href="http://www.regular-expressions.info/reference.html">syntax regels voor reguliere expressies</a>.
				</p>
			</xsl:when>
			<xsl:when test="$freesearch/result and $level > 2">
				<xsl:apply-templates select="$results" mode="leaf" />
			</xsl:when>
			<xsl:when test="$freesearch/result">
				<h2>
					<xsl:value-of select="$freesearch/resultSize" />
					concepten voor "<xsl:value-of select="$query" />" gevonden
				</h2>
				
				<!-- TODO: gebruik de filterschemes -->
				
				
				<xsl:apply-templates select="$freesearch/result"
					mode="freesearch-resultlist">
					<xsl:sort select="label|info/label" />
				</xsl:apply-templates>

			</xsl:when>
			<xsl:otherwise>
				<p class="no-results">
					Geen concepten gevonden. 
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template match="result" mode="freesearch-resultlist">
		<xsl:variable name="group" select="$schemes/group[schemes/result/result/uri = current()/info/inScheme[1]]/result/info/label"/>
		
		<xsl:if test="not($filterschemessearch//*[text() = $group])">
			<h3>
				<xsl:value-of select="label" />
				<xsl:apply-templates select="info/inScheme[1]"
					mode="findGroup" />
			</h3>
			<table class="resultTable">
				<tr>
					<th class="ident">Identifier</th>
					<th class="voorkeur">Labels</th>
					<th class="talen">Talen</th>
					<th>Gevonden in</th>
					<th class="concept">&#160;</th>
				</tr>
				<xsl:apply-templates select="info/inScheme" mode="identifier" />
			</table>
		</xsl:if>
	</xsl:template>

	<xsl:template match="inScheme" mode="identifier">
		<tr>
			<td>
				<xsl:value-of select="../../uri" />
			</td>
			<td>
				<xsl:for-each select="../prefLabel/value|../altLabel/value" >
					<div><xsl:value-of select="current()" /></div>
				</xsl:for-each>
			</td>
			<td>
				<xsl:apply-templates select="../prefLabel/lang|../altLabel/lang"
					mode="translate" />
			</td>
			<td>
				<xsl:apply-templates select="." mode="findScheme" />
			</td>
			<td>
				<a>
					<xsl:attribute name="href">
				<xsl:apply-templates select="."
						mode="convertToBrowseConceptUrl" />		
			</xsl:attribute>
					Browse concept
				</a>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="inScheme" mode="findScheme">
		<a>
			<xsl:attribute name="href">
			<xsl:apply-templates select="."
				mode="convertToBrowseSchemeUrl" />		
		</xsl:attribute>
			<xsl:value-of
				select="$schemes/group/schemes/result/result[uri=current()]/info/label" />
		</a>

	</xsl:template>

	<xsl:template match="inScheme" mode="findGroup">
		<xsl:text> (</xsl:text>
		<a>
			<xsl:attribute name="href">
			<xsl:apply-templates select="."
				mode="convertToBrowseGroupUrl" />		
		</xsl:attribute>
			<xsl:value-of
				select="$schemes/group[schemes/result/result/uri=current()]/result/info/label" />
		</a>
		<xsl:text>)</xsl:text>
	</xsl:template>

	<xsl:template match="inScheme" mode="convertToBrowseGroupUrl">
		<xsl:text>/index.html#/repo.do?level=0|/repo.do?level=1&amp;uri=</xsl:text>
		<xsl:value-of select="$schemes/group[schemes/result/result/uri=current()]/result/uri"/>
	</xsl:template>
	
	<xsl:template match="inScheme" mode="convertToBrowseSchemeUrl">
		<xsl:text>/index.html#/repo.do?level=0|/repo.do?level=1&amp;uri=</xsl:text>
		<xsl:value-of select="$schemes/group[schemes/result/result/uri=current()]/result/uri"/>
		<xsl:text>|/repo.do?level=2&amp;uri=</xsl:text>
		<xsl:value-of select="."/>
		<xsl:text>&amp;letter=</xsl:text>
		<xsl:value-of select="substring-before(../../label,' ')"/>
	</xsl:template>
	
	<xsl:template match="inScheme" mode="convertToBrowseConceptUrl">
		<xsl:text>/index.html#/repo.do?level=0|/repo.do?level=1&amp;uri=</xsl:text>
		<xsl:value-of select="$schemes/group[schemes/result/result/uri=current()]/result/uri"/>
		<xsl:text>|/repo.do?level=2&amp;uri=</xsl:text>
		<xsl:value-of select="."/>	
		<xsl:text>&amp;letter=</xsl:text>
		<xsl:value-of select="substring-before(../../label,' ')"/>
		<xsl:text>|/repo.do?level=3&amp;uri=</xsl:text>
		<xsl:value-of select="../../uri"/>	
	</xsl:template>
	
	<xsl:template match="lang" mode="translate">
	<div>
		<xsl:choose>
			<xsl:when test=".='nl'">Nederlands</xsl:when>
			<xsl:when test=".='en'">Engels</xsl:when>
			<xsl:when test=".='fr'">Frans</xsl:when>
			<xsl:otherwise>
			<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</div>
	</xsl:template>
	
	<!--  TODO: is this used? otherwise remove this template -->
	<xsl:template match="result">
		<xsl:choose>
			<xsl:when test="statusCode != 200">
				<p>
					Fout!
				</p>
			</xsl:when>
			<xsl:when test="$results/result and $level > 2">
				<xsl:apply-templates select="$results" mode="leaf" />
			</xsl:when>
			<xsl:when test="$results/result and 4 > $level">
				<xsl:choose>
					<xsl:when test="$letter = '' and $level = 2">
						<h3>Top concepten</h3>
					</xsl:when>
					<xsl:when test="$letter and $level = 2">
						<h3>Gezocht concepten</h3>
					</xsl:when>
				</xsl:choose>
				<ul>				
					<xsl:apply-templates select="$results/result[uri = $filterschemesroot/scheme or $level]" mode="branch">
						<xsl:sort select="label|info/label"/>
					</xsl:apply-templates>
				</ul>
				
			</xsl:when>
			<xsl:otherwise>
				<p class="no-results">
					Geen verder concepten bekend. Gekozen concept of vocabulaire details weergeven beneden. 
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="result" mode="branch">	
		<xsl:variable name="infolabel" select="info/label" />
		<xsl:if test="info/label and not($filterschemesroot//*[text() = $infolabel]) or label">			
			<li>
			  <a href="{uri}" rel="fragment" target="column-{$nextlevel}">
			  <xsl:if test="quri=$highlight">
			  	<xsl:attribute name="class">selected</xsl:attribute>
			  		<xsl:if test="$level=2">	
			  		<xsl:attribute name="id"><xsl:value-of select="concat('this-',position(),'',$level)"/></xsl:attribute>
			  		</xsl:if>
			  </xsl:if>
				<xsl:choose>			
				  <xsl:when test="info/label and not($filterschemesroot//*[text() = $infolabel])">			  
					<xsl:value-of select="info/label" />
				  </xsl:when>
				  <xsl:otherwise>
					<xsl:value-of select="label" />
				  </xsl:otherwise>
				</xsl:choose>
			  </a> 
			  <!--  kan zijn dat het gehighlight item onderin zit. Die moeten we bovenaan zetten -->
			  <xsl:if test="quri=$highlight and $level=2">
				  <script>
				  	VocRep.ScrollToTop("<xsl:value-of select="concat('this-',position(),'',$level)"/>");  
				  </script>
			  </xsl:if>
			</li>
		</xsl:if>
	</xsl:template>
  
	<xsl:template match="result[not(relation)]" mode="leaf">
		<xsl:choose>
			<xsl:when test="result[relation = 'skos:broader']">
				<div class="bnr broader">
					<h3>SKOS bredere</h3> 
					<ul>
						<xsl:apply-templates select="result[relation = 'skos:broader']" mode="leaf" />
					</ul>
				</div>
			</xsl:when>
			<xsl:otherwise> 
				<p class="no-results">
					Geen bredere bekend.
				</p>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="result[relation = 'skos:narrower']">
				<div class="bnr narrower">
					<h3>SKOS nauwere</h3> 
					<ul>					
						<xsl:apply-templates select="result[relation = 'skos:narrower']" mode="leaf" />
					</ul>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<p class="no-results">
					Geen nauwere bekend.
				</p>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="result[relation = 'skos:related']">
				<div class="bnr related">
					<h3>SKOS gerelateerde</h3>   
					<ul>
						<xsl:apply-templates select="result[relation = 'skos:related']" mode="leaf" />
					</ul>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<p class="no-results">
					Geen gerelateerde bekend.
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="result[relation]" mode="leaf">	
		<li>
			<a href="{uri2}" rel="fragment" class="" target="column-{$nextlevel}">
			<xsl:if test="uri2=$highlight">
		  	<xsl:attribute name="class">selected</xsl:attribute>
		  </xsl:if> 
				<xsl:value-of select="info2/label" />
			</a> 
		</li>
	</xsl:template>

</xsl:stylesheet>