<%@ tag language="java" pageEncoding="UTF-8" description="browser" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="voc" %>

<div id="browser">
		<div class="panel" id="panel1">
			<div class="panel-nav">
				<ul>
				<li>
						<a href="/search.do" id="freesearch">Zoeken</a>
					</li>
					<li>
						<a href="/index.html">Browse</a>
					</li>					
				</ul>
				<div align="right">
					<c:choose>
						<c:when test="${loggedon}">
							<p>you are logged on</p>
						</c:when>
						<c:otherwise>
							<form action="/login.do" method="post">
								<p>
									<input type="password" id="password" name="password"></input>
									<input type="submit" id="passsubmitbutton" value="login" />
								</p>
							</form>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
			<div class="panel-main">
				<div class="block1">
				</div>
				<div class="block2">
					<div class="inside">
						<div id="concept-filter">
							<p>Zoeken op</p>
							<p>
								<input id="concept-filter-input" type="text" />
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="clear">
				<span>&#160;</span>
			</div>
		</div>
		<div class="panel" id="panel2">
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