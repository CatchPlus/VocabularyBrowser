var Finder = {
  _prevPath: [],
  
  HashChangeHandler: function(hash, ColumnLoadedHandler) {
    var path = hash.split('|');

    // make old/new paths equal in length
    Finder._prevPath.splice(path.length);
    while (Finder._prevPath.length < path.length) {
      Finder._prevPath.push("");
    }

    // Put some selectors in variables so they're easier to reuse
    var frozenpanel = '#panel1 > .panel-main > .block1'; // Contains step 0
    var outerscrollingpanel = '#panel1 > .panel-main > .block2';
    var outerscrollingpanelwidth = $(outerscrollingpanel).outerWidth();
    var innerscrollingpanel = '#panel1 > .panel-main > .block2 > .inside'; // Contains steps 1 - whatever
    var innerscrollingpanelwidth = path.length * 200 - 200;
    // Dynamically increase the width of the scrolling container
    //onderstaand ding is volgens mij niet eens meer nodig
    //$(innerscrollingpanel).css("width", innerscrollingpanelwidth + "px");
    // Scroll to the right to expose new content
    //if (innerscrollingpanelwidth > outerscrollingpanelwidth) {
    $(outerscrollingpanel).animate({ scrollLeft: innerscrollingpanelwidth - outerscrollingpanelwidth + 'px' }, 500);
    //}
    // Identify the current step (should be the last step that the user clicked on)
    $('.step:last').addClass(' current');
    $('.step:last').siblings('.step').removeClass(' current');

    // Add new steps
    for (var step = 0; step < path.length; step++) {
      var url = path[step];
      var stephtml = $('<div class="step" id="step' + step + '"></div>');
      var column = $('#step' + step);
      if (!column.length) {
        if (step == 0) {
          $(frozenpanel).append(stephtml);
          // Gratuitous animation, maybe use concept to slide steps in
          // stephtml.hide().appendTo($(frozenpanel)).fadeIn(100);
        }
        else if (step > 0) {
          $(innerscrollingpanel).append(stephtml);
          // Gratuitous animation, maybe use concept to slide steps in
          // stephtml.hide().appendTo($(innerscrollingpanel)).fadeIn(100); 
          // Inserts step dynamically after step 1... doesn't quite work...
          //if (step == 2) {
          //$('#step1').after('<div id="concept-filter"><p>Zoeken</p><p><input id="concept-filter-input" type="text" /></p></div>');
          //}
        }
        column = $('#step' + step);
      }

      if (Finder._prevPath[step] != url) {
        var tryNext = (step + 1 < path.length) ? (step + 1) : 0;
        var paramValue = "";
        if (tryNext > 0)
          paramValue = Finder.isolateUri(path[tryNext]);


        if (ColumnLoadedHandler)
          column.load(url, ColumnLoadedHandler );
        else
          column.load(url);

        Finder._prevPath[step] = url;
      }
    }

    //if (callback)
    //      callback();
  },

  isolateUri: function(url) {
    //isolate the uriParam
    var uriParam = url.split("&uri=");
    var paramValue = "";

    if (uriParam.length == 2) {
      if (uriParam[1].indexOf("&") > -1)
        paramValue = uriParam[1].split('&')[0];
      else
        paramValue = uriParam[1];
    }

    return paramValue;
  },

  Load: function(url, level) {
    var path = location.hash.substring(1).split('|');

    path.splice(level, path.length - level);
    path.push(url);

    $.history.load(path.join('|'));
  },

  LoadPath: function(path) {
    $.history.load(path.join('|'));
  }
}
