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
	<xsl:param name="loggedon" select="false()" />
	<xsl:param name="letter" />
	<xsl:param name="query" />
	<xsl:param name="match" />
	<xsl:param name="label" />
	<xsl:param name="lang" />
	<xsl:param name="nextlevel" />
	<xsl:param name="highlight" />

	<xsl:template match="/root">
		<xsl:apply-templates select="results/result" />
	</xsl:template>

	<xsl:template match="inScheme" mode="identifier">
		<tr>
			<td>
				<xsl:value-of select="../../uri" />
			</td>
			<td>
				<xsl:value-of select="../prefLabel/value|../altLabel/value" />
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
					<!-- on top level, only allow repo's that are white-listed  -->
					<xsl:apply-templates select="$results/result[uri = $filterschemesroot/scheme or $level > 0 or $loggedon]" mode="branch">
						<xsl:sort select="label|info/label"/>
					</xsl:apply-templates>
				</ul>
				<!-- 
				<ul>
				<xsl:if test="number($lalignment/result/resultSize) &gt; 0 or number($ralignment/result/resultSize) &gt; 0">
					<h3>Alignments</h3>
				</xsl:if>
				<xsl:if test="number($lalignment/result/resultSize) &gt; 0">
					<xsl:apply-templates select="$lalignment/result/result" mode="alignment">
						<xsl:sort select="label|info/label"/>
					</xsl:apply-templates>
				</xsl:if>
				<xsl:if test="number($ralignment/result/resultSize) &gt; 0">			
					<xsl:apply-templates select="$ralignment/result/result" mode="alignment">
						<xsl:sort select="label|info/label"/>
					</xsl:apply-templates>
				</xsl:if>
				</ul> -->
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
		<xsl:if test="label or info/label">			
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
						<xsl:apply-templates select="result[relation = 'skos:broader']" mode="leaf">
						<xsl:sort select="info2/label" />
						</xsl:apply-templates>
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
						<xsl:apply-templates select="result[relation = 'skos:narrower']" mode="leaf">
							<xsl:sort select="info2/label" />
						</xsl:apply-templates>
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
						<xsl:apply-templates select="result[relation = 'skos:related']" mode="leaf">
							<xsl:sort select="info2/label" />
						</xsl:apply-templates>
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