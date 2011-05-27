var selectedScheme;
var VocRep = {
	delay : 500,
	currentConceptScheme : null,
	searchValues : {}, // for restoring form input when changing back to advanced search
	
	SetSearchInputField : function(query) {
		if ($('#freesearch-input').val() == "")
			$('#freesearch-input').attr('value', query);
	},

	ScrollToTop : function(id) {
		document.getElementById(id).scrollIntoView(true);
		VocRep.ScrollFix(document.getElementById(id), -50);
	},
	// die domme zoeken op box zit in de weg. Die 50pixels moeten we weer
	// corrigeren
	ScrollFix : function(el, num) {
		var re = /html$/i;
		while (!re.test(el.tagName) && (1 > el.scrollTop))
			el = el.parentNode;
		if (0 < el.scrollTop)
			el.scrollTop += num;
	},

	LoadRepository : function(uri) {
		$('#concept-filter').hide();
		Finder.Load('/repo.do?level=0', 0);
	},

	LoadConceptSchemeGroup : function(uri) {
		$('#concept-filter').hide();
		Finder.Load('/repo.do?level=1&uri=' + uri, 1);
	},

	LoadConceptScheme : function(uri, letter) {
		$('#concept-filter').show();
		selectedScheme = uri;
		Finder.Load("/repo.do?level=2&uri=" + uri + "&letter=" + letter, 2);
	},

	LoadConceptSchemePath : function(csg, cs) {
		$('#concept-filter').show();
		Finder.LoadPath(VocRep.CreatePath( [ csg, cs ]));
	},

	/*
	 * PATH is a list of uri's that *identify* VocRep resources: [uri1, uri2]
	 * the path is mapped to a list of URL that the server can deliver. also,
	 * the root level, which is always constant, is repended.
	 */
	CreatePath : function(path) {
		var result = [ "/repo.do?level=0" ];

		for ( var i = 0; i < path.length; i++)
			result.push("/repo.do?level=" + (i + 1) + "&uri=" + path[i]);

		return result;
	},

	LoadConceptSchemeDelayed : function(uri, query) {
		clearTimeout(VocRep._filterTimout);
		VocRep._filterTimout = setTimeout(function() {
			VocRep.LoadConceptScheme(VocRep.currentConceptScheme, query);
		}, VocRep.delay);
	},	

	LoadConcept : function(uri, targetColumn) {
		Finder.Load('/repo.do?level=' + targetColumn + '&uri=' + uri,
				targetColumn);
	},

	HighlightPath : function(path) {
		return $.map($(".step"), function(step) {
			var id = $(step).attr("id");
			var index = id.substring(id.length - 1);

			return VocRep.HighlightItem(index, path[index]);
		});

	},

	// TODO: remove previously selcted items from the list
	// TODO: don't use a timeout but do it properly
	HighlightItem : function(step, uri) {
		var item = "#step" + (step) + " a[href=" + uri + "]";
		$("#step"+ (step) +" a.selected").removeClass('selected');		
		
					
			$(item).addClass('selected');
		
					
	},

	// converts a raw hash to a list of VocRep uri's
	// the root path, which has no uri, is omitted. this means that the first
	// entry in the result list is a CSG.
	// return a path like: [CSG, CS, C1, C2, ... ]
	Hash2Path : function(hash) {
		var splitted = hash.split('|');
		return $.map(splitted, function(part) {
			return QueryString("uri", part);
		});
	}
};

function LoadMetaData(hash) {
	var path = hash.split('|');
	// if (path.length == 2) {
	// var details_url = path[path.length - 1].replace(/^\/erpo.do\?/,
	// "/csg_details?");
	// $('#details').load(details_url);
	// }
	// else if (path.length == 3) {
	// var details_url = path[path.length - 1].replace(/^\/repo.do\?/,
	// "/cs_details?");
	// $('#details').load(details_url);
	// }
	// else
	if (path.length > 3) {
		var details_url = path[path.length - 1].replace(/^\/repo.do\?/,
				"/c_details.do?")
				+ "&selectedScheme=" + selectedScheme;
		$('#details').load(details_url);
	} else {
		$('#details').html("");
	}
}

$(document)
		.ready(function() {
			
			// we give the history manager a function to execute when the hash changes
			$.history.init(function(hash) {
				var path = VocRep.Hash2Path(hash);
				
				Finder.HashChangeHandler(hash, function() {
					VocRep.HighlightPath(path );
				});
				LoadMetaData(hash);
			});

			// concept filter
			$('#freesearch-searchBtn').live("click", function(evt) {
				VocRep.LoadFreeSearchDelayed()
			});

			// concept filter
			$('#concept-filter-input').live(
					"keyup",
					function(evt) {
						var target = $(evt.target);
						var query = target.val();

						VocRep.LoadConceptSchemeDelayed(
								VocRep.currentConceptScheme, query)
					});

			//  store the form values temporarily, clear the form and switch to simple mode
			$("a[class = 'search-mode-simpel']").live(
					"click",
					function(evt) {
						
						var form = $('#freesearch-form form');
						VocRep.searchValues = form.serializeArray();
						
						
						$.each($("select",form), function(index, input) {
								$(input).val("");
						});
						
						$('#freesearch-form').removeClass('advanced')
								.addClass('basic');
						return false;
					});

			// restore the form values and switch to advanced
			$("a[class = 'search-mode-advanced']").live(
					"click",
					function(evt) {
						var form = $('#freesearch-form form');
						
						$.each(VocRep.searchValues, function(index,stored) {
							var selector = "select[name='" + stored.name + "']";
							var input = $( selector, form );
							if (input.length)
								input.val(stored.value);
						});
						
						$('#freesearch-form').removeClass(' basic')
								.addClass('advanced');
						return false;
					});

			$('#freesearch-group')
					.live(
							"change",
							function(evt) {
								if ($(this).val() == "[GROUP]"
										&& $(this).attr("selectedIndex") > 0)
									alert("Zoeken op groepen wordt op dit moment nog niet ondersteund.");
							});

			$("a[rel = 'fragmentb4']").live("click", function(evt) {
				var currentLink = $(evt.target).attr('href');
				var firstStep = $("#step1");
				firstStep.find("a[href = '" + currentLink + "']").click();
				return false;
			});

			$("a[rel = 'fragments']").live(
					"click",
					function(evt) {
						var currentLink = $(evt.target).attr('href');
						var lastStep = "#step"
								+ $("div.inside").find("div.step").length;
						var lastColumn = $(lastStep);
						lastColumn.find("a[href = '" + currentLink + "']")
								.click();
						return false;
					});

			// 'fix' links
			$("a[rel = 'fragment']").live(
					"click",
					function(evt) {
						var a = $(evt.target);
						var href = a.attr('href');
						var uri = href.replace(/^.*#/, '');
						var target = a.attr('target');

						var level = 1 * target.replace('column-', '')
								|| Finder._prevPath.length;
						var rel = a.attr('rel');

						// TODO: Rewrite this so it's bookmarkable...
						// a.addClass('selected');
						//a.parent('li').siblings('li').children(
							///	"a[rel = 'fragment']").removeClass(
								//'selected');

						// remove all columns right of the column containing
						// the clicked link
						$(".step:has(a[target = '" + target + "'])")
								.nextAll('.step').remove();

						/* navigate */
						switch (level) {
						case 0:
							VocRep.LoadRepository(uri);
							break;
						case 1:
							// reset alle kolommen
							$("#step1").nextAll().remove();
							VocRep.LoadConceptSchemeGroup(uri);
							break;
						case 2:
							VocRep.currentConceptScheme = uri;
							VocRep.LoadConceptScheme(uri, "");
							$('#concept-filter-input').val(''); // reset
																// filter
							break;
						default:
							VocRep.LoadConcept(uri, level);
							break;
						}

						return false;
					});

			// TODO: should we make this generic for any kind of path
			// instead of just for CS's?

			/*
			 * a CS was clicked but because is was an 'alignment' the CS
			 * belongs to a CSG different from the one where currently in
			 * this means the whole path needs to be be constructed from the
			 * root.
			 * 
			 * what needs to be done: 1. ask the server in which CSG this CS
			 * belongs 2. highlight de CSG in the first column with all
			 * CSG's 3. load the CSG contents (all CS's belonging to the
			 * CSG) 4. highlight the matching CS in column 2 5. load the CS
			 * contents (top concepts and a keyword filter)
			 * 
			 */
			$("a[rel = 'cs_path']").live("click", function(evt) {
				var a = $(evt.target);
				var href = a.attr('href');

				var cs = href;
				var url = '/csg.json?uri=' + cs;
				$.getJSON(url, null, function(data) {
					VocRep.LoadConceptSchemePath(data.csg, cs);
				});

				return false;
			});
		});

function QueryString(key, qs) {
	qs = qs || window.location.search;
	hu = qs.substring(1);
	gy = hu.split("&");
	for (i = 0; i < gy.length; i++) {
		ft = gy[i].split("=");
		if (ft[0] == key) {
			return ft[1];
		}
	}
}