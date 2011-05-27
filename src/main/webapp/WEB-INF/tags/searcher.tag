<%@ tag language="java" pageEncoding="UTF-8" description="searcher" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="voc" %>

<div id="searcher">
		<div class="panel" id="panel1">
			<div class="panel-nav">
				<ul>
				<li>
						<a href="/freesearch.html" id="freesearch">Zoeken</a>
					</li>
					<li>
						<a href="/index.html">Browse</a>
					</li>					
				</ul>
			</div>
			<div id="search-panel" class="panel-main basic">
				<div class="block1">
				</div>
				<div class="block2 searchBlok">
					<div class="inside">						
					</div>
				</div>
			</div>
			<div class="clear">
				<span>&#160;</span>
			</div>
		</div>
		<div class="panel" id="panel2" style="display:none;">
			<div class="panel-nav">
				<ul>
					<li>
						<a href="#">Details</a>
					</li>
				</ul>
			</div>
			<div class="panel-main" id="details">
			</div>
			<div class="clear">
				<span>&#160;</span>
			</div>
		</div>
</div>