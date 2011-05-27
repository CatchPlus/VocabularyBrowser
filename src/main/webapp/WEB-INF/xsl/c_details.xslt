<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:skos="http://www.w3.org/2004/02/skos/core#">

	<xsl:output method="html" indent="yes" />
	<xsl:param name="uri" />
	<xsl:variable name="lalignment" select="/root/lalignment" />
	<xsl:variable name="ralignment" select="/root/ralignment" />

	<!-- CONCEPT DETAILS -->
	<xsl:template match="root">	
		<xsl:if test="../statusCode != '200'">
			<p>
				Fout!:
				<xsl:value-of select="../statusCode" />
			</p>
		</xsl:if>

		<h1>
			Concept:
			<xsl:value-of select="labels/result/result/info/prefLabel/value" />
		</h1>
		<div class="block1">
			<!-- Concept IDENTIFIER -->
			<div class="identifier">
				<h2>
					Identifier
				</h2>
				<p>
					<xsl:value-of select="labels/result/result/uri" />
				</p>
			</div>
			<!-- Concept LABELS -->
			<xsl:apply-templates select="labels/result/result"
				mode="labels" />
			<!-- TODO: Add editorial labels, definitions and other stuff... -->
			<!-- Concept NOTES -->
			<xsl:if test="labels/result/result/info/scopeNote/value">
				<div class="notes">
					<h2>Notities</h2>
					<p>
						<xsl:value-of select="labels/result/result/info/scopeNote/value" />
					</p>
				</div>
			</xsl:if>
			<!-- Concept FOUND IN -->
			<xsl:apply-templates select="scheme/result" mode="inScheme" />
		</div>
		<!-- Concept RELATIONSHIPS -->
		<div class="block2">
			<xsl:apply-templates select="relations/result" mode="relations" />
			
			<div class="bnr alignments">				
				<xsl:if test="number($lalignment/result/resultSize) &gt; 0 or number($ralignment/result/resultSize) &gt; 0">
					<h2>Alignments</h2>
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
			</div>
		</div>		
		<!-- CLEARING DIV, DO NOT DELETE! -->
		<div class="clear">
			<span>&#160;</span>
		</div>
	</xsl:template>
	
	<xsl:template match="result" mode="alignment">	
		<!--  <p><a href="javascript:VocRep.LoadConceptScheme('{info/onto1}','');"><xsl:value-of select="info/label" /></a></p> -->
		<p><a href="{info/onto1}" target="2" rel="cs_path"><xsl:value-of select="info/label" /></a></p>
	</xsl:template>

	<!-- Concept LABELS -->
	<xsl:template match="result" mode="labels">
		<!--
			Concept labels PREFERRED: Preferred labels in all languages (when
			present)
		-->

		<div class="labels" id="pref-labels">
			<h2>Voorkeurstermen</h2>
			<xsl:if test="not(info/prefLabel)">
				<p>Geen bekend.</p>
			</xsl:if>
			<xsl:if test="info/prefLabel">
				<table>
					<xsl:apply-templates select="." mode="prefLabel">
						<xsl:with-param name="lang" select="'nl'" />
						<xsl:with-param name="title" select="'Nederlands'" />
					</xsl:apply-templates>
					<xsl:apply-templates select="." mode="prefLabel">
						<xsl:with-param name="lang" select="'de'" />
						<xsl:with-param name="title" select="'Deutch'" />
					</xsl:apply-templates>
					<xsl:apply-templates select="." mode="prefLabel">
						<xsl:with-param name="lang" select="'en'" />
						<xsl:with-param name="title" select="'English'" />
					</xsl:apply-templates>
					<xsl:apply-templates select="." mode="prefLabel">
						<xsl:with-param name="lang" select="'fr'" />
						<xsl:with-param name="title" select="'Francais'" />
					</xsl:apply-templates>
					<xsl:apply-templates select="." mode="prefLabel">
						<xsl:with-param name="lang" select="'x-notation'" />
						<xsl:with-param name="title" select="'x-notation'" />
					</xsl:apply-templates>
				</table>
			</xsl:if>
		</div>
		<!--
			Concept labels ALTERNATIVE: Alternative labels in all languages (when
			present)
		-->
		<div class="labels" id="alt-labels">
			<h2>Niet-voorkeurstermen</h2>
			<xsl:if test="not(info/altLabel)">
				<p>Geen bekend.</p>
			</xsl:if>
			<xsl:if test="info/altLabel">
				<table>
					<xsl:apply-templates select="." mode="altLabel">
						<xsl:with-param name="lang" select="'nl'" />
						<xsl:with-param name="title" select="'Nederlands'" />
					</xsl:apply-templates>
					<xsl:apply-templates select="." mode="altLabel">
						<xsl:with-param name="lang" select="'de'" />
						<xsl:with-param name="title" select="'Deutch'" />
					</xsl:apply-templates>
					<xsl:apply-templates select="." mode="altLabel">
						<xsl:with-param name="lang" select="'en'" />
						<xsl:with-param name="title" select="'English'" />
					</xsl:apply-templates>
					<xsl:apply-templates select="." mode="altLabel">
						<xsl:with-param name="lang" select="'fr'" />
						<xsl:with-param name="title" select="'Francais'" />
					</xsl:apply-templates>
					<xsl:apply-templates select="." mode="prefLabel">
						<xsl:with-param name="lang" select="'x-notation'" />
						<xsl:with-param name="title" select="'x-notation'" />
					</xsl:apply-templates>
				</table>
			</xsl:if>
		</div>
	</xsl:template>

	<!-- Concept labels PREFERRED (TABLE ROWS) -->
	<xsl:template match="result" mode="prefLabel">
		<xsl:param name="lang" />
		<xsl:param name="title" />
		<xsl:if test="info/prefLabel[lang = $lang]">
			<tr>
				<th>
					<h3>
						<xsl:value-of select="$title" />
					</h3>
				</th>
				<td>
					<ul>
						<xsl:apply-templates select="info/prefLabel[lang = $lang]"
							mode="prefLabel" />
					</ul>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	<!-- Concept labels ALTERNATIVE (TABLE ROWS) -->
	<xsl:template match="result" mode="altLabel">
		<xsl:param name="lang" />
		<xsl:param name="title" />
		<xsl:if test="info/altLabel[lang = $lang]">
			<tr>
				<th>
					<h3>
						<xsl:value-of select="$title" />
					</h3>
				</th>
				<td>
					<ul>
						<xsl:apply-templates select="info/altLabel[lang = $lang]"
							mode="altLabel" />
					</ul>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>

	<!-- Concept labels PREFERRED (LIST ITEMS) -->
	<xsl:template match="prefLabel" mode="prefLabel">
		<li>
			<xsl:value-of select="value" />
		</li>
	</xsl:template>
	<!-- Concept labels ALTERNATIVE (LIST ITEMS) -->
	<xsl:template match="altLabel" mode="altLabel">
		<li>
			<xsl:value-of select="value" />
		</li>
	</xsl:template>

	<!-- Concept RELATIONSHIPS -->
	<xsl:template match="result" mode="relations">
		<!-- TODO: Write this more elegantly -->
		<div class="bnr broader">
			<h2>SKOS bredere</h2>
			<xsl:choose>
				<xsl:when test="result[relation = 'skos:broader']">
					<ul>
						<xsl:apply-templates select="result[relation = 'skos:broader']" mode="relation" >
							<xsl:sort select="info2/label"/>
					    </xsl:apply-templates>
					</ul>
				</xsl:when>
				<xsl:otherwise>
					<p class="no-results">
						Geen bekend. 
					</p>
				</xsl:otherwise>
			</xsl:choose>
		</div>
		<div class="bnr narrower">
			<h2>SKOS nauwere</h2>
			<xsl:choose>
				<xsl:when test="result[relation = 'skos:narrower']">
					<ul>
						<xsl:apply-templates select="result[relation = 'skos:narrower']"
							mode="relation" >
							<xsl:sort select="info2/label"/>
					    </xsl:apply-templates>
					</ul>
				</xsl:when>
				<xsl:otherwise>
					<p class="no-results">
						Geen bekend. 
					</p>
				</xsl:otherwise>
			</xsl:choose>
		</div>
		<div class="bnr related">
			<h2>SKOS gerelateerde</h2>
			<xsl:choose>
				<xsl:when test="result[relation = 'skos:related']">
					<ul>
						<xsl:apply-templates select="result[relation = 'skos:related']"
							mode="relation" >
							<xsl:sort select="info2/label"/>
					    </xsl:apply-templates>
					</ul>
				</xsl:when>
				<xsl:otherwise>
					<p class="no-results">
						Geen bekend. 
					</p>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="result" mode="relation">	
		<li>
			<a href="{uri2}" rel="fragments">
				<xsl:value-of select="info2/label" />
			</a>
		</li>
	</xsl:template>

	<!-- Concept FOUND IN (Concept scheme groups) -->
	<xsl:template match="result[statusCode = 200]" mode="inScheme">
		<h2>Gevonden in</h2>
		<ul>
			<xsl:apply-templates select="result" mode="inScheme" />
		</ul>
	</xsl:template>

	<!-- Concept found in ERROR -->
	<xsl:template match="result/statusCode" priority="-1"
		mode="inScheme">
		<p>Fout!</p>
	</xsl:template>

	<!-- Concept found in LIST -->
	<xsl:template match="result" mode="inScheme">
		<li>		
			<a href="{uri2}" rel="cs_path" target="2">
				<xsl:value-of select="info2/label" />
			</a>
		</li>
	</xsl:template>

</xsl:stylesheet>