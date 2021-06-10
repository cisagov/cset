/*js/drexplain/drexplain.data-manager.js*/
DR_EXPLAIN.namespace( 'DR_EXPLAIN.dataManager' );

DR_EXPLAIN.dataManager = (function() {
    var data_resize = DR_EXPLAIN.data_resize;
    var data_search = DR_EXPLAIN.data_search;
    var data_menu = DR_EXPLAIN.data_menu;

    var drex_node_names = data_menu.DREX_NODE_NAMES;
    var drex_node_links = data_menu.DREX_NODE_LINKS;
    var drex_node_child_start = data_menu.DREX_NODE_CHILD_START;
    var drex_node_child_end = data_menu.DREX_NODE_CHILD_END;

    var drex_node_parent = new Array();
    var drex_node_deep = new Array();

    var drex = {};


    function drex_node(ndx)
    {
      this.node_index = ndx;
      this.title = drex_node_names[this.node_index];
      this.link = drex_node_links[this.node_index];
      this.deep = drex_node_deep[this.node_index];

      this.children = function(){
        var result = new Array();
        for (var i = drex_node_child_start[this.node_index]; i < drex_node_child_end[this.node_index]; i++)
          result.push(new drex_node(i));
        return result;
      };
      this.childrenCount = function(){
        if (drex_node_child_start[this.node_index] >= drex_node_child_end[this.node_index])
          return 0;
        return drex_node_child_end[this.node_index] - drex_node_child_start[this.node_index];
      };
      this.parent = function(){
        if (drex_node_parent[this.node_index] == -1)
            return null;
        return new drex_node(drex_node_parent[this.node_index]);
      };
      this.isActive = function(){
        if (!drex.active_node)
            return false;
        return (this.node_index == drex.active_node.node_index);
      };
    };

    var initMenu = function() {

        drex_node_parent[0] = -1;
        drex_node_deep[0] = 0;
        for (var i in drex_node_names)
        {
          for (var j = drex_node_child_start[i]; j < drex_node_child_end[i]; j++)
          {
            drex_node_parent[j] = i;
            drex_node_deep[j] = drex_node_deep[i] + 1;
          }
        }

        drex = new Object();
        drex.nodes_count = drex_node_names.length;

        drex.root_node = function()
        {
          return new drex_node(0);
        };

        drex.active_node = null;
        for (var i in drex_node_links)
        {
          if (drex_node_links[i] == getPageFilename())
            drex.active_node = new drex_node(i);
        }


        function drex_resultContainer(){
           this.result = "";
        }
    };


    function drex_keyword(ndx)
    {
      this.keyword_index = ndx;
      this.title = drex_keyword_names[this.keyword_index];
      this.deep = drex_keyword_deep[this.keyword_index];

      this.children = function(){
        var result = new Array();
        for (var i = drex_keyword_child_start[this.keyword_index]; i < drex_keyword_child_end[this.keyword_index]; i++)
          result.push(new drex_keyword(i));
        return result;
      };
      this.childrenSorted = function(){
        var result = this.children();
        result.sort(function(a,b){
          if (a.title.toLowerCase() < b.title.toLowerCase())
            return -1;
          if (a.title.toLowerCase() > b.title.toLowerCase())
            return 1;
          return 0;
        });
        return result;
      };
      this.childrenCount = function(){
        if (drex_keyword_child_start[this.keyword_index] >= drex_keyword_child_end[this.keyword_index])
          return 0;
        return drex_keyword_child_start[this.keyword_index] - drex_keyword_child_end[this.keyword_index];
      }
      this.parent = function(){
        if (drex_keyword_parent[this.keyword_index] == -1)
            return null;
        return new drex_keyword(drex_keyword_parent[this.keyword_index]);
      };
      this.nodes = function(){
        var result = new Array();
        for (var i = drex_keyword_nodes_start[this.keyword_index]; i < drex_keyword_nodes_end[this.keyword_index]; i++)
          result.push(new drex_node(drex_keyword_nodes[i]));
        return result;
      };
      this.isActive = function(){
        return this.keyword_index != 0;
      };
    };




    var data_index = DR_EXPLAIN.data_index;

    var drex_node_keywords = data_index.DREX_NODE_KEYWORDS;
    var drex_node_keywords_start = data_index.DREX_NODE_KEYWORDS_START;
    var drex_node_keywords_end = data_index.DREX_NODE_KEYWORDS_END;

    var drex_keyword_names = data_index.DREX_KEYWORD_NAMES;
    var drex_keyword_child_start = data_index.DREX_KEYWORD_CHILD_START;
    var drex_keyword_child_end = data_index.DREX_KEYWORD_CHILD_END;

    var drex_keyword_parent = new Array();
    var drex_keyword_deep = new Array();

    var drex_keyword_nodes = new Array(drex_node_keywords.length);
    var drex_keyword_nodes_start = new Array(drex_keyword_names.length);
    var drex_keyword_nodes_end = new Array(drex_keyword_names.length);



    var initIndex = function() {

        //keyword tree structure
        drex_keyword_parent[0] = -1;
        drex_keyword_deep[0] = 0;
        for (var i in drex_keyword_names)
        {
          for (var j = drex_keyword_child_start[i]; j < drex_keyword_child_end[i]; j++)
          {
            drex_keyword_parent[j] = i;
            drex_keyword_deep[j] = drex_keyword_deep[i] + 1;
          }
        }

        drex.keywords_count = drex_keyword_names.length;


        //making drex_keyword_nodes from drex_node_keywords
        var temp_drex_keyword_write_pos = new Array(drex.keywords_count + 1);

        for (var i = 0; i < temp_drex_keyword_write_pos.length; i++)
          temp_drex_keyword_write_pos[i] = 0;
        for (var i in drex_node_keywords)
          ++temp_drex_keyword_write_pos[drex_node_keywords[i] + 1];
        for (var i = 1; i < temp_drex_keyword_write_pos.length; i++)
          temp_drex_keyword_write_pos[i] += temp_drex_keyword_write_pos[i-1];

        for (var i = 0; i < drex.keywords_count; i++)
          drex_keyword_nodes_start[i] = temp_drex_keyword_write_pos[i];

        for (var i = 0; i < drex.nodes_count; i++)
          for (var j = drex_node_keywords_start[i]; j < drex_node_keywords_end[i]; j++)
          {
            var kw = drex_node_keywords[j];
            drex_keyword_nodes[temp_drex_keyword_write_pos[kw]] = i;
            ++temp_drex_keyword_write_pos[kw];
          }
        for (var i = 0; i < drex.keywords_count; i++)
            drex_keyword_nodes_end[i] = temp_drex_keyword_write_pos[i];


        drex_node.prototype.keywords = function(){
            var result = new Array();
            for (var i = drex_node_keywords_start[this.node_index]; i < drex_node_keywords_end[this.node_index]; i++)
              result.push(new drex_keyword(drex_node_keywords[i]));
            return result;
        };

        //interface
        drex.root_keyword = function()
        {
          return new drex_keyword(0);
        };
    };


    var getPageFilename = function() {
        if ( window[ 'drex_file_name' ] !== undefined ) {
            return window.drex_file_name;
        }
        else {
            return null;
        }
    };


    var API = {
        init: function() {
            initMenu();
            initIndex();
        },

        fitHeightToWindow: function() {
            return data_resize.DREXPLAIN_FIT_HEIGHT_TO_WINDOW === 1;
        },

        getStartingMenuWidth: function() {
            return parseInt(data_resize.DREX_INITIAL_MENU_WIDTH);
        },

        getSearchTextNoResults: function() {
            return data_search.DREXPLAIN_NOT_FOUND;
        },

        getSearchTextInPreviewMode: function() {
            return data_search.DREXPLAIN_PREVIEW_MODE_SEARCH_IS_DISABLED_NOTICE;
        },

        getErrorInLocalSearch: function() {
            return data_search.DREXPLAIN_ERROR_LOCAL_SEARCH;
        },

        getErrorInRemoteSearch: function(code) {
            return data_search.DREXPLAIN_ERROR_REMOTE_SEARCH.replace('{0}', code.toString());
        },

        getSearchTextEmptyString: function() {
            return data_search.DREXPLAIN_EMPTY_STRING;
        },

        getSearchTextInProgress: function() {
            return data_search.DREXPLAIN_IN_PROGRESS;
        },


        getPageFilename: function() {
            return getPageFilename();
        },


        //drex.nodes_count
        getNodesCount: function() {
            return drex.nodes_count;
        },

        //drex.root_node()
        getRootNode: function() {
            return drex.root_node();
        },

        //drex.root_node()
        getRootNodesArray: function() {
            if (!data_menu.DREX_HAS_ROOT_NODE)
                return drex.root_node().children();
            return [drex.root_node()];
        },

        //drex.active_node
        getSelectedNode: function() {
            return drex.active_node;
        },

        //!drex.active_node
        isSelectedNodeExists: function() {
            if ( !drex.active_node ) {
                return false;
            }
            else {
                return true;
            }
        },

        //function drex_node(ndx)
        createNodeClassByIndex: function( nodeIndex ) {
            return new drex_node( nodeIndex );
        },

        // DrexObjectsManager.menu.createNodeClassByIndex( i ) ).deep <= 0 ? 1 : 0;
        getNodeDeepByIndex: function( nodeIndex ) {
            return drex_node_deep[ nodeIndex ];
        },

        getIndexByNode: function( node ) {
            return node.node_index;
        },

        getDrex: function() {
            return drex;
        },

        getDrexNode: function( ndx ) {
            return drex_node( ndx );
        },

        getDrexMenuType: function() {
            return data_menu.DREX_MENU_TYPE;
        }
    };

    return API;

})();


/*js/drexplain/drexplain.dom.js*/
DR_EXPLAIN.namespace( 'DR_EXPLAIN.dom' );

/**
 * @returns {DomCached}
 */
DR_EXPLAIN.dom = {
    PAGE_CONTENT_HEADER__HIDDEN_CLASS: "m-pageContent__withoutHeader",
    PAGE_CONTENT_FOOTER__HIDDEN_CLASS: "m-pageContent__withoutFooter",
    PAGE_CONTENT_LEFT__HIDDEN_CLASS: "m-pageContent__withoutRight",
    PAGE_CONTENT_RIGHT__HIDDEN_CLASS: "m-pageContent__withoutLeft",

    WORK_ZONE_SIDE_NAV__HIDDEN_CLASS: "m-workZone__withoutSideNav",

    TAB_WRAPPER_ITEM__SELECTED_CLASS: "m-tabs__wrapperItem__selected",
    TAB_SELECTOR_ITEM__SELECTED_CLASS: "m-tabs__selectorItem__selected",

    FRAME_ENABLED_CLASS: "m-pageView__state__frame",

    _isIeLessThan9: null,
    _isIe: null,

    init: function() {
        this.$html = $( "html" );
        this.$body = $( "body" );

        this.$pageLayout = $("#pageLayout");

        this.$internal_wrapper = $( "#internal_wrapper" );
        this.$pageContent = $( "#pageContent" );
        this.$pageContentHeader = $( "#pageContentHeader" );
        this.$pageContentFooter = $( "#pageContentFooter" );
        this.$pageContentArticleSide = $( "#pageContentArticleSide" );
        this.$pageContentLeft = $( "#pageContentLeft" );
        this.$pageContentRight = $( "#pageContentRight" );

        this.$tabWrapperItems = $( "#tabWrapperItems" );

        this.$article = $( "#article" );
        this.$articleHeader = $( "#article__header" );
        this.$articlePreWrapper = this.$article.children( ".b-article__preWrapper" );
        this.$articleWrapper = this.$article.find( ".b-article__wrapper" );
        this.$articleInnerWrapper = this.$article.find( ".b-article__innerWrapper" );
        this.$articleGeneratorCopyright = this.$article.find( ".b-article__generatorCopyright" );

        this.$headerSide__nav = $("#headerSide__nav");
        this.$headerSide__nav__breadCrumbs = $("#headerSide__nav__breadCrumbs");
        this.$headerSide__buttons = $("#headerSide__buttons");

        this.$splitter = $( "#splitter" );
        this.$workZone = $( "#workZone" );
        this.$workZoneSideNav = $( "#workZone_nav" );
        this.$workZoneSideNavContent = $( "#workZone_nav_content" );
        this.$workZoneSideArticle = $( "#workZone_article" );
        this.$workZoneSideArticleOverlay = $('#workZone_article__overlay');

        this.$presentSideNavButton = $('#presentSideNavButton');
        this.$dismissSideNavButton = $('#dismissSideNavButton');

        this.$workZoneSideArticleContent = $( "#workZone_article__content" );

        this.$tabsWrapperItems = $( "#tabsWrapperItems" );


        this.tabs = {};

        this.tabs.menu = {};
        this.tabs.menu.$selectorItem = $( "#tabSelector_menu" );
        this.tabs.menu.$wrapperItem = $( "#tabWrapper_menu" );
        this.tabs.menu.$wrapperItemInner = this.tabs.menu.$wrapperItem.children( ".b-tabs__wrapperItemInner" );
        this.tabs.menu.$tree = this.tabs.menu.$wrapperItemInner.children( ".b-tree" );

        this.tabs.index = {};
        this.tabs.index.$selectorItem = $( "#tabSelector_index" );
        this.tabs.index.$wrapperItem = $( "#tabWrapper_index" );
        this.tabs.index.$wrapperItemInner = this.tabs.index.$wrapperItem.children( ".b-tabs__wrapperItemInner" );
        this.tabs.index.$tree = this.tabs.index.$wrapperItemInner.children( ".b-tree" );


        this.tabs.search = {};
        this.tabs.search.$selectorItem = $( "#tabSelector_search" );
        this.tabs.search.$wrapperItem = $( "#tabWrapper_search" );
        this.tabs.search.$wrapperItemInner = this.tabs.search.$wrapperItem.children( ".b-tabs__wrapperItemInner" );
        this.tabs.search.$tree = this.tabs.search.$wrapperItemInner.children( ".b-tree" );



            // todo: remove or refactor

                this.$tabWrapperItemArr = this.tabs.menu.$wrapperItem.add( this.tabs.index.$wrapperItem ).add( this.tabs.search.$wrapperItem );
                this.$tabWrapperItemInnerArr = this.tabs.menu.$wrapperItemInner.add( this.tabs.index.$wrapperItemInner ).add( this.tabs.search.$wrapperItemInner );
                this.$treeArr = this.$tabWrapperItemInnerArr.find( ".b-tree" );
                this.$tabWrapperMenu = this.tabs.menu.$wrapperItem;

                // remove:
                this.$tabWrapperIndex = this.tabs.index.$wrapperItem;
                this.$tabWrapperSearch = this.tabs.search.$wrapperItem;

                this.$tabSelectorMenu = this.tabs.menu.$selectorItem;
                this.$tabSelectorIndex = this.tabs.index.$selectorItem;
                this.$tabSelectorSearch = this.tabs.search.$selectorItem;
            //


        this.$tabSearchFormWrapper = $( "#tabs_searchFormWrapper" );

        this.$tabSearchSubmit = $( "#tabs_searchSubmit" );
        this.$tabSearchInput = $( "#tabs_searchInput" );
        this.$tabSearchInputLabel = $( "#tabs_searchInput_label" );

        this.$workZoneSearchSubmit = $( "#workZone_searchSubmit" );
        this.$workZoneSearchInput = $( "#workZone_searchInput" );
        this.$workZoneSearchInputLabel = $( "#workZone_searchInput_label" );


        this.$keywordContextMenu = $( "#keywordContextMenu" );

        this.$searchProgress = $( "#searchProgress" );
        this.$hasVerticalScrollbar = {};
        this.$hasHorizontalScrollbar = {};


/*      this.$tabItemWrapperInnerArr = $( ".b-tabs__wrapperItemInner" );
        this.$treeArr = $( ".b-tabs__wrapperItemInner .b-tree" );*/
    },

    isIe: function() {
        if ( this._isIe === null ) {
            if ( this.$html.hasClass( "ie" ) ) {
                this._isIe = true;
            }
            else {
                this._isIe = false;
            }
        }

        return this._isIeLessThan9;
    },

    isIeLessThan9: function() {
        if ( this._isIeLessThan9 === null ) {
            if ( this.$html.hasClass( "ie6" ) || this.$html.hasClass( "ie7" ) || this.$html.hasClass( "ie8" )) {
                this._isIeLessThan9 = true;
            }
            else {
                this._isIeLessThan9 = false;
            }
        }

        return this._isIeLessThan9;
    },

    setPageLayoutType: function(layoutType) {
        var currLayoutType = this.getPageLayoutType();
        if (layoutType !== currLayoutType) {
            this.$pageLayout.attr('data-layout', layoutType);

            newClass = 'b-pageLayout__' + layoutType;
            allClasses = ['b-pageLayout__xs', 'b-pageLayout__sm', 'b-pageLayout__md', 'b-pageLayout__lg'];
            this.$pageLayout
                .removeClass(_.without(allClasses, newClass).join(' '))
                .addClass(newClass);

            $(document).trigger('pageLayoutChange', layoutType);
        }
    },

    getPageLayoutType: function() {
        return this.$pageLayout.attr('data-layout');
    },

    _getBrowserWindowWidth: function() {
        /* AT
            jQuery's .width() doesn't include vertical scrollbar width
            This is not a bug. According to jQuery docs, width() method returns
            viewport width.
            To deliver better mobile experience we need to detect browser window
            width correctly. So we are using window.innerWidth. It is not
            supported in IE<9, so we are using other values as a fallback.

            Note that this method will return the same result as .width()
            for IE<9. It is a known downside, and it won't be fixed.
        */
        return window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
    },

    updatePageLayoutType: function() {
        var browserWindowWidth = this._getBrowserWindowWidth();
        if (browserWindowWidth < 768) {
            this.setPageLayoutType('xs');
        } else if (browserWindowWidth < 992) {
            this.setPageLayoutType('sm');
        } else if (browserWindowWidth < 1200) {
            this.setPageLayoutType('md');
        } else {
            this.setPageLayoutType('lg');
        }
    },

    getVisibleTab: function() {
        if ( this.isTabVisible( this.tabs.menu ) ) {
            return this.tabs.menu;
        }
        else if ( this.isTabVisible( this.tabs.index ) ) {
            return this.tabs.index;
        }
        else if ( this.isTabVisible( this.tabs.search ) ) {
            return this.tabs.search;
        }
        else {
            return null;
        }
    },

    getVisibleItemWrapperInner: function() {
        var visibleTab = this.getVisibleTab();
        if ( visibleTab !== null ) {
            return visibleTab.$wrapperItemInner;
        }
        else {
            return null;
        }
    },

    isTabVisible: function( tab ) {
        if (_.contains(['xs'], this.getPageLayoutType()) && !this.$workZoneSideNav.hasClass('topmost')) {
            return false;
        }
        return tab.$wrapperItem.hasClass(this.TAB_WRAPPER_ITEM__SELECTED_CLASS);
    },

    isKeywordContextMenuVisible: function() {
        if ( this.$keywordContextMenu.hasClass( "m-tree__contextMenu__visible" ) ) {
            return true;
        }
        else {
            return false;
        }
    },

    getCssNumericValue: function( $elem, cssProp ) {
        return parseInt( $elem.css( cssProp ), 10 );
    },

    isPageHeaderVisible: function() {
        return !(this.$pageContent.hasClass(this.PAGE_CONTENT_HEADER__HIDDEN_CLASS) ||
                 _.contains(['xs'], this.getPageLayoutType()));
    },

    isPageFooterVisible: function() {
        return !(this.$pageContent.hasClass(this.PAGE_CONTENT_FOOTER__HIDDEN_CLASS) ||
                 _.contains(['xs'], this.getPageLayoutType()));
    },

    isPageLeftVisible: function() {
        return !(this.$pageContent.hasClass(this.PAGE_CONTENT_LEFT__HIDDEN_CLASS) ||
                 _.contains(['xs'], this.getPageLayoutType()));
    },

    isPageRightVisible: function() {
        return !(this.$pageContent.hasClass(this.PAGE_CONTENT_RIGHT__HIDDEN_CLASS) ||
                 _.contains(['xs'], this.getPageLayoutType()));
    },

    isRtl: function() {
        return this.$html.attr('dir') === 'rtl';
    }
};


DR_EXPLAIN.namespace( 'DR_EXPLAIN.wordSplitter' );
DR_EXPLAIN.wordSplitter = (function() {


    function rangesToArray(ranges, rangesObj)
    {
        var rangeElements = ranges.split(/[-,]/);
        if (rangeElements.length % 2 != 0)
        {
            alert("Error #398, please report it to help@drexplain.com");
            return;
        }
        for (var i = 0; i < rangeElements.length; i += 2)
        {
            var startEl = parseInt(rangeElements[i]);
            var endEl = parseInt(rangeElements[i + 1]);
            rangesObj.addRange(startEl, endEl);
        }
        rangesObj.filled = true;
    }
    var Ranges = function() {
        this.filled = false;
        this.starts = new Array();
        this.ends = new Array();
        this.contains
    };
    Ranges.prototype.addRange = function(start, end)
    {
        this.starts.push(start);
        this.ends.push(end);
        if (this.starts.length != this.ends.length)
            alert("starts.length != ends.length!");
    };
    Ranges.prototype.checkContains = function(val)
    {
        if (!this.filled)
            return false;
        var it = this.upperBound(val);
        if (it == 0)
            return false;
        --it;
        var nBegin = this.starts[it];
        var nEnd = this.ends[it]
        if (nBegin <= val && val < nEnd)
            return true;
        return false;
    };
    Ranges.prototype.upperBound = function(val)
    {
        var lo = 0, hi = this.starts.length - 1;
        while (lo < hi) {
            var mid = ((hi + lo + 1)/2)>>0; /*integer division*/
                if (this.starts[mid] <= val)
                    lo = mid;
                else
                    hi = mid - 1;
        }
        if (this.starts[lo] <= val)
         return lo + 1;
        return this.starts.length;
    };
    var stPunctuation = new Ranges();
    function isPunctuationSymbol(codePoint)
    {
        if (!stPunctuation.filled)
        {
            rangesToArray( 
                "33-36,37-43,44-48,58-60,63-65,91-94,123-124,125-126,161-162,167-168,171-172,182-184,187-188,191-192,894-895,903-904,1370-1376,1417-1419,1470-1471," +
                "1472-1473,1475-1476,1478-1479,1523-1525,1545-1547,1548-1550,1563-1564,1566-1568,1642-1646,1748-1749,1792-1806,2039-2042,2096-2111,2142-2143,2404-2406," +
                "2416-2417,2800-2801,3572-3573,3663-3664,3674-3676,3844-3859,3860-3861,3898-3902,3973-3974,4048-4053,4057-4059,4170-4176,4347-4348,4960-4969,5120-5121," +
                "5741-5743,5787-5789,5867-5870,5941-5943,6100-6103,6104-6107,6144-6155,6468-6470,6686-6688,6816-6823,6824-6830,7002-7009,7164-7168,7227-7232,7294-7296," +
                "7360-7368,7379-7380,8208-8232,8240-8260,8261-8274,8275-8287,8317-8319,8333-8335,8968-8972,9001-9003,10088-10102,10181-10183,10214-10224,10627-10649," +
                "10712-10716,10748-10750,11513-11517,11518-11520,11632-11633,11776-11823,11824-11843,12289-12292,12296-12306,12308-12320,12336-12337,12349-12350," +
                "12448-12449,12539-12540,42238-42240,42509-42512,42611-42612,42622-42623,42738-42744,43124-43128,43214-43216,43256-43259,43260-43261,43310-43312," +
                "43359-43360,43457-43470,43486-43488,43612-43616,43742-43744,43760-43762,44011-44012,64830-64832,65040-65050,65072-65107,65108-65122,65123-65124," +
                "65128-65129,65130-65132,65281-65284,65285-65291,65292-65296,65306-65308,65311-65313,65339-65342,65343-65344,65371-65372,65373-65374,65375-65382," +
                "65792-65795,66463-66464,66512-66513,66927-66928,67671-67672,67871-67872,67903-67904,68176-68185,68223-68224,68336-68343,68409-68416,68505-68509," +
                "69703-69710,69819-69821,69822-69826,69952-69956,70004-70006,70085-70090,70093-70094,70107-70108,70109-70112,70200-70206,70313-70314,70854-70855," +
                "71105-71128,71233-71236,71484-71487,74864-74869,92782-92784,92917-92918,92983-92988,92996-92997,113823-113824,121479-121484",
                stPunctuation
            );
        }
        if (stPunctuation.checkContains(codePoint))
            return true;
        return false;
    }
    var stWordSymbols = new Ranges();
    function isWordSymbol(codePoint)
    {
        if (!stWordSymbols.filled)
        {
            rangesToArray( 
                "33-36,37-43,44-60,63-94,95-96,97-124,125-126,161-162,167-168,170-172,178-180,181-184,185-215,216-247,248-706,710-722,736-741,748-749,750-751,768-885," +
                "886-888,890-896,902-907,908-909,910-930,931-1014,1015-1154,1155-1328,1329-1367,1369-1376,1377-1416,1417-1419,1425-1480,1488-1515,1520-1525,1545-1547," +
                "1548-1550,1552-1564,1566-1757,1759-1769,1770-1789,1791-1806,1808-1867,1869-1970,1984-2038,2039-2043,2048-2094,2096-2111,2112-2140,2142-2143,2208-2229," +
                "2275-2436,2437-2445,2447-2449,2451-2473,2474-2481,2482-2483,2486-2490,2492-2501,2503-2505,2507-2511,2519-2520,2524-2526,2527-2532,2534-2546,2548-2554," +
                "2561-2564,2565-2571,2575-2577,2579-2601,2602-2609,2610-2612,2613-2615,2616-2618,2620-2621,2622-2627,2631-2633,2635-2638,2641-2642,2649-2653,2654-2655," +
                "2662-2678,2689-2692,2693-2702,2703-2706,2707-2729,2730-2737,2738-2740,2741-2746,2748-2758,2759-2762,2763-2766,2768-2769,2784-2788,2790-2801,2809-2810," +
                "2817-2820,2821-2829,2831-2833,2835-2857,2858-2865,2866-2868,2869-2874,2876-2885,2887-2889,2891-2894,2902-2904,2908-2910,2911-2916,2918-2928,2929-2936," +
                "2946-2948,2949-2955,2958-2961,2962-2966,2969-2971,2972-2973,2974-2976,2979-2981,2984-2987,2990-3002,3006-3011,3014-3017,3018-3022,3024-3025,3031-3032," +
                "3046-3059,3072-3076,3077-3085,3086-3089,3090-3113,3114-3130,3133-3141,3142-3145,3146-3150,3157-3159,3160-3163,3168-3172,3174-3184,3192-3199,3201-3204," +
                "3205-3213,3214-3217,3218-3241,3242-3252,3253-3258,3260-3269,3270-3273,3274-3278,3285-3287,3294-3295,3296-3300,3302-3312,3313-3315,3329-3332,3333-3341," +
                "3342-3345,3346-3387,3389-3397,3398-3401,3402-3407,3415-3416,3423-3428,3430-3446,3450-3456,3458-3460,3461-3479,3482-3506,3507-3516,3517-3518,3520-3527," +
                "3530-3531,3535-3541,3542-3543,3544-3552,3558-3568,3570-3573,3585-3643,3648-3676,3713-3715,3716-3717,3719-3721,3722-3723,3725-3726,3732-3736,3737-3744," +
                "3745-3748,3749-3750,3751-3752,3754-3756,3757-3770,3771-3774,3776-3781,3782-3783,3784-3790,3792-3802,3804-3808,3840-3841,3844-3859,3860-3861,3864-3866," +
                "3872-3892,3893-3894,3895-3896,3897-3912,3913-3949,3953-3992,3993-4029,4038-4039,4048-4053,4057-4059,4096-4254,4256-4294,4295-4296,4301-4302,4304-4681," +
                "4682-4686,4688-4695,4696-4697,4698-4702,4704-4745,4746-4750,4752-4785,4786-4790,4792-4799,4800-4801,4802-4806,4808-4823,4824-4881,4882-4886,4888-4955," +
                "4957-4989,4992-5008,5024-5110,5112-5118,5120-5760,5761-5789,5792-5881,5888-5901,5902-5909,5920-5943,5952-5972,5984-5997,5998-6001,6002-6004,6016-6107," +
                "6108-6110,6112-6122,6128-6138,6144-6158,6160-6170,6176-6264,6272-6315,6320-6390,6400-6431,6432-6444,6448-6460,6468-6510,6512-6517,6528-6572,6576-6602," +
                "6608-6619,6656-6684,6686-6751,6752-6781,6783-6794,6800-6810,6816-6830,6832-6847,6912-6988,6992-7009,7019-7028,7040-7156,7164-7224,7227-7242,7245-7296," +
                "7360-7368,7376-7415,7416-7418,7424-7670,7676-7958,7960-7966,7968-8006,8008-8014,8016-8024,8025-8026,8027-8028,8029-8030,8031-8062,8064-8117,8118-8125," +
                "8126-8127,8130-8133,8134-8141,8144-8148,8150-8156,8160-8173,8178-8181,8182-8189,8208-8232,8240-8260,8261-8274,8275-8287,8304-8306,8308-8314,8317-8330," +
                "8333-8335,8336-8349,8400-8433,8450-8451,8455-8456,8458-8468,8469-8470,8473-8478,8484-8485,8486-8487,8488-8489,8490-8494,8495-8506,8508-8512,8517-8522," +
                "8526-8527,8528-8586,8968-8972,9001-9003,9312-9472,10088-10132,10181-10183,10214-10224,10627-10649,10712-10716,10748-10750,11264-11311,11312-11359," +
                "11360-11493,11499-11508,11513-11558,11559-11560,11565-11566,11568-11624,11631-11633,11647-11671,11680-11687,11688-11695,11696-11703,11704-11711," +
                "11712-11719,11720-11727,11728-11735,11736-11743,11744-11843,12289-12292,12293-12306,12308-12320,12321-12342,12344-12350,12353-12439,12441-12443," +
                "12445-12544,12549-12590,12593-12687,12690-12694,12704-12731,12784-12800,12832-12842,12872-12880,12881-12896,12928-12938,12977-12992,13312-19894," +
                "19968-40918,40960-42125,42192-42540,42560-42744,42775-42784,42786-42889,42891-42926,42928-42936,42999-43048,43056-43062,43072-43128,43136-43205," +
                "43214-43226,43232-43262,43264-43348,43359-43389,43392-43470,43471-43482,43486-43519,43520-43575,43584-43598,43600-43610,43612-43639,43642-43715," +
                "43739-43767,43777-43783,43785-43791,43793-43799,43808-43815,43816-43823,43824-43867,43868-43878,43888-44014,44016-44026,44032-55204,55216-55239," +
                "55243-55292,63744-64110,64112-64218,64256-64263,64275-64280,64285-64297,64298-64311,64312-64317,64318-64319,64320-64322,64323-64325,64326-64434," +
                "64467-64832,64848-64912,64914-64968,65008-65020,65024-65050,65056-65107,65108-65122,65123-65124,65128-65129,65130-65132,65136-65141,65142-65277," +
                "65281-65284,65285-65291,65292-65308,65311-65342,65343-65344,65345-65372,65373-65374,65375-65471,65474-65480,65482-65488,65490-65496,65498-65501," +
                "65536-65548,65549-65575,65576-65595,65596-65598,65599-65614,65616-65630,65664-65787,65792-65795,65799-65844,65856-65913,65930-65932,66045-66046," +
                "66176-66205,66208-66257,66272-66300,66304-66340,66352-66379,66384-66427,66432-66462,66463-66500,66504-66518,66560-66718,66720-66730,66816-66856," +
                "66864-66916,66927-66928,67072-67383,67392-67414,67424-67432,67584-67590,67592-67593,67594-67638,67639-67641,67644-67645,67647-67670,67671-67703," +
                "67705-67743,67751-67760,67808-67827,67828-67830,67835-67868,67871-67898,67903-67904,67968-68024,68028-68048,68050-68100,68101-68103,68108-68116," +
                "68117-68120,68121-68148,68152-68155,68159-68168,68176-68185,68192-68256,68288-68296,68297-68327,68331-68343,68352-68406,68409-68438,68440-68467," +
                "68472-68498,68505-68509,68521-68528,68608-68681,68736-68787,68800-68851,68858-68864,69216-69247,69632-69710,69714-69744,69759-69821,69822-69826," +
                "69840-69865,69872-69882,69888-69941,69942-69956,69968-70007,70016-70094,70096-70112,70113-70133,70144-70162,70163-70206,70272-70279,70280-70281," +
                "70282-70286,70287-70302,70303-70314,70320-70379,70384-70394,70400-70404,70405-70413,70415-70417,70419-70441,70442-70449,70450-70452,70453-70458," +
                "70460-70469,70471-70473,70475-70478,70480-70481,70487-70488,70493-70500,70502-70509,70512-70517,70784-70856,70864-70874,71040-71094,71096-71134," +
                "71168-71237,71248-71258,71296-71352,71360-71370,71424-71450,71453-71468,71472-71487,71840-71923,71935-71936,72384-72441,73728-74650,74752-74863," +
                "74864-74869,74880-75076,77824-78895,82944-83527,92160-92729,92736-92767,92768-92778,92782-92784,92880-92910,92912-92918,92928-92988,92992-92997," +
                "93008-93018,93019-93026,93027-93048,93053-93072,93952-94021,94032-94079,94095-94112,110592-110594,113664-113771,113776-113789,113792-113801," +
                "113808-113818,113821-113824,119141-119146,119149-119155,119163-119171,119173-119180,119210-119214,119362-119365,119648-119666,119808-119893," +
                "119894-119965,119966-119968,119970-119971,119973-119975,119977-119981,119982-119994,119995-119996,119997-120004,120005-120070,120071-120075," +
                "120077-120085,120086-120093,120094-120122,120123-120127,120128-120133,120134-120135,120138-120145,120146-120486,120488-120513,120514-120539," +
                "120540-120571,120572-120597,120598-120629,120630-120655,120656-120687,120688-120713,120714-120745,120746-120771,120772-120780,120782-120832," +
                "121344-121399,121403-121453,121461-121462,121476-121477,121479-121484,121499-121504,121505-121520,124928-125125,125127-125143,126464-126468," +
                "126469-126496,126497-126499,126500-126501,126503-126504,126505-126515,126516-126520,126521-126522,126523-126524,126530-126531,126535-126536," +
                "126537-126538,126539-126540,126541-126544,126545-126547,126548-126549,126551-126552,126553-126554,126555-126556,126557-126558,126559-126560," +
                "126561-126563,126564-126565,126567-126571,126572-126579,126580-126584,126585-126589,126590-126591,126592-126602,126603-126620,126625-126628," +
                "126629-126634,126635-126652,127232-127245,131072-173783,173824-177973,177984-178206,178208-183970,194560-195102,917760-918000",
                stWordSymbols
            );
        }
        if (stWordSymbols.checkContains(codePoint))
            return true;
        return false;
    }
    function toCodePoints(str)
    {
        var chars = [];
        for (var lengthProcessed = 0; lengthProcessed < str.length;)
        {
         var ch = str.codePointAt(lengthProcessed);
         chars.push(ch);
         if (ch > 0xffff)
          lengthProcessed += 2;
         else
          ++lengthProcessed;
        }
        return chars;
    }
    function fromCodePoints(chars)
    {
     return String.fromCodePoint.apply(null, chars);
    }
    function splitString(str)
    {
        var chars = toCodePoints(str);
        var result = new Array();
        var word = new Array();
        for (var i = 0; i <= chars.length; ++i)
        {
            if (i != chars.length && isWordSymbol(chars[i]) && !isPunctuationSymbol(chars[i]))
            {
                word.push(chars[i]);
            }
            else
            {
                if (word.length != 0)
                {
                    result.push(fromCodePoints(word));
                    word = new Array();
                }
            }
        }
        return result;
    }
    var API = {
        splitString: function(str) {
            return splitString(str);
        }
    };

    return API;
})();

/*js/drexplain/drexplain.search-engine.js*/
DR_EXPLAIN.namespace( 'DR_EXPLAIN.searchEngine' );
DR_EXPLAIN.searchEngine = (function() {
    function isRemoteSearch()
    {
        return window.location.protocol === 'https:' || window.location.protocol === 'http:';
    }
    /**
    * Append a tag to the properties of an object for each item in an array
    *
    * @param {Object} tags
    *         The object whose property values will be modified
    * @param {Array} items
    *         The list of property names to set on the object
    * @param {String} tag
    *         The value to append to each property value in the object
    */
    function setTag(tags, items, tag) {
        for (var i = 0; i < items.length; i++) {
            var item = items[i];

            if (tags.hasOwnProperty(item)) {
                tags[item] += tag;
            } else {
                tags[item] = tag;
            }
        }
    }

    /**
    * Return a filtered list of property names for the specified object.
    * Each property value that causes the specified match function to
    * return true will be returned in the resulting array
    *
    * @param {Object} tags
    *         The object whose property names will be filtered
    * @param {Function} matchFunction
    *         A function that takes a single parameter, returning true or
    *         false based on the value of that parameter. "filter" will pass
    *         in each property name of the "tags" object to determine if it
    *         should be included in the resulting array
    * @return {Array} Returns an array of property names whose values
    *         were accepted by the matchFunction
    */
    function filter(tags, matchFunction) {
        var result = [];

        for (var p in tags) {
            if (matchFunction(tags[p])) {
                result.push(p);
            }
        }

        return result;
    }

    /**
    * Find the intersection of two sets
    *
    * @param {Array} setA
    * @param {Array} setB
    * @return {Array} Returns the result of this set operation
    */
    function intersect(setA, setB) {
        var tags = {};

        setTag(tags, setA, "A");
        setTag(tags, setB, "B");

        return filter(tags, function(value) { return value == "AB" });
    }

    /**
    * Find the difference of two sets
    *
    * @param {Array} setA
    * @param {Array} setB
    * @return {Array} Returns the result of this set operation
    */
    function difference(setA, setB) {
        var tags = {};

        setTag(tags, setA, "A");
        setTag(tags, setB, "B");

        return filter(tags, function(value) { return value != "AB" });
    }

    /**
    * Remove all members of setA from setB
    *
    * @param {Array} setA
    * @param {Array} setB
    * @return {Array} Returns the result of this operation
    */
    function remove(setA, setB) {
        var tags = {};

        setTag(tags, setA, "A");
        setTag(tags, setB, "B");

        return filter(tags, function(value) { return value == "B" });
    }
    function unite(setA, setB)
    {
        var tags = {};

        setTag(tags, setA, "A");
        setTag(tags, setB, "B");
        return filter(tags, function(value) { return true;});
    }
    /**
     * @author 1
     */
    /*
    var strFoundNothing = "Nothing was found";
    var strSearchStringIsEmpty = "Please, enter a string for search!";
    var strSearchInProgress = "Searching...";
    */

    var IndexOfFiles = new Array();
    var StringsForSearch = new Array();
    var StringPairArray = new Array();
    var SearchResults=new Array();
    var iStringToSearch=0;
    var HTTP = {};

    HTTP.newRequest = function()
    {
        var xmlhttp=false;
        /* running locally on IE5.5, IE6, IE7 */                                              
        if(location.protocol=="file:"){
            if(!xmlhttp)try{ xmlhttp=new ActiveXObject("MSXML2.XMLHTTP"); }catch(e){xmlhttp=false;}
            if(!xmlhttp)try{ xmlhttp=new ActiveXObject("Microsoft.XMLHTTP"); }catch(e){xmlhttp=false;}
        }                                                                                
        /* IE7, Firefox, Safari, Opera...  */
        if(!xmlhttp)try{ xmlhttp=new XMLHttpRequest(); }catch(e){xmlhttp=false;}
        /* IE6 */
        if(typeof ActiveXObject != "undefined"){
            if(!xmlhttp)try{ xmlhttp=new ActiveXObject("MSXML2.XMLHTTP"); }catch(e){xmlhttp=false;}
            if(!xmlhttp)try{ xmlhttp=new ActiveXObject("Microsoft.XMLHTTP"); }catch(e){xmlhttp=false;}
        }
        /* IceBrowser */
        if(!xmlhttp)try{ xmlhttp=createRequest(); }catch(e){xmlhttp=false;}

        if (!xmlhttp)
        {
            throw new Error("Failed to initialize XMLHttpRequest");
        }
        return xmlhttp;
    };


    var request = HTTP.newRequest();

    function ID()
    {
        if (!SearchResults.length) getSearchResultOutput();
        var sID = dirname() + "/de_search/ids.json";
        request.open("GET", sID, true);
        request.onreadystatechange = function()
        {
            if (request.readyState == 4)
            if (request.status == 200 || request.status == 0)
            {
                var arrFileId;
                try
                {
                    arrFileId = JSON.parse(request.responseText);
                }
                catch(e)
                {
                    //Something is wrong, abort search
                    SearchResults = new Array();
                    SearchResults[0] = new Array();
                    SearchResults[0][0] = "Error!";
                    SearchResults[0][1] = "mailto:help@drexplain.com";
                    getSearchResultOutput();
                    return;
                }

                var id;
                for (var i = 0; i < SearchResults.length; i++)
                {
                    id = SearchResults[i];
                    SearchResults[i] = new Array();
                    SearchResults[i][0] = arrFileId[id][0];
                    SearchResults[i][1] = arrFileId[id][1];
                }
                getSearchResultOutput();
            }
        }
        request.send(null);

    }

    function getSearchResultOutput()
    {
        $( document ).trigger( "searchComplete" );
    }

    function SearchInFile()
    {
        if (request.readyState != 4) return;
        if (request.status != 200 && request.status != 0)  return;

        var arrFileStrings;
        try
        {
            arrFileStrings = JSON.parse(request.responseText);
        }
        catch(e)
        {
            return;
        }

        var stToSearch      = StringPairArray[iStringToSearch][0];

        var isFirstIteration = true;
        var wasFound        = false;
        var curResults = new Array();
        for (var i = 0; i < arrFileStrings.length; i++)
        {
            if (arrFileStrings[i].s.indexOf(stToSearch) == 0)
            {
                curResults = unite(curResults, arrFileStrings[i].p);
                wasFound = true;
            }
        }
        if (iStringToSearch == 0) //this is first result - adding all curResults to SearchResults
            SearchResults = SearchResults.concat(curResults);
        else
            SearchResults = intersect(SearchResults, curResults);
        // If there are no results after a certain iteration then there's no sense to AND-search anymore
        if (!SearchResults.length) return getSearchResultOutput();
        iStringToSearch++;
        SearchForNextString();
    }



    function SearchForNextString()
    {
        if (iStringToSearch >= StringsForSearch.length) return ID();
        var sURL = dirname() + "/de_search/"+StringPairArray[iStringToSearch][1];
        request.open("GET", sURL, true);
        request.onreadystatechange = SearchInFile;
        request.send(null);
    }
    function strcmp ( str1, str2 ) {
        // Binary safe string comparison
        //
        // version: 909.322
        // discuss at: http://phpjs.org/functions/strcmp
        // +   original by: Waldo Malqui Silva
        // +      input by: Steve Hilder
        // +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
        // +    revised by: gorthaur
        // *     example 1: strcmp( 'waldo', 'owald' );
        // *     returns 1: 1
        // *     example 2: strcmp( 'owald', 'waldo' );
        // *     returns 2: -1
        return ( ( str1 == str2 ) ? 0 : ( ( str1 > str2 ) ? 1 : -1 ) );
    }
    function AttachFilesToStrings()
    {
        for (var i = 0; i < StringsForSearch.length; i++)
        {
            var st = StringsForSearch[i].toUpperCase();
            var st1 = st.substr(0,1);
            var j = 0;
            var bFound = -1;
            while (j < IndexOfFiles.length && bFound == -1)
            {
                switch (strcmp(st1, IndexOfFiles[j].first.substr(0,1)))
                {
                    case 0: bFound = true; break;
                    case -1: bFound = false; break;
                    case 1: ++j;
                }
            }
            if (bFound == -1 || bFound == false)
            {
                getSearchResultOutput();
                return;
            }
            //We have found words beginning with first letter of st
            bFound = false;
            switch (strcmp(st, IndexOfFiles[j].first))
            {
                case -1:
                {
                    if (IndexOfFiles[j].first.indexOf(st) == 0) //st = 'skin', IndexOfFiles[j].first = 'skinner'
                        bFound = true;
                    break;
                }
                case 0:
                {
                    bFound = true;
                    break;
                }
                case 1: //st = 'skinner', IndexOfFiles[j].first = 'skin'
                {
                    switch (strcmp(st, IndexOfFiles[j].last))
                    {
                        case -1:
                        case 0:
                        {
                            bFound = true;
                            break;
                        }
                        case 1:
                        {
                            if (st.indexOf(IndexOfFiles[j].last) == 0) //st = 'skinner', IndexOfFiles[j].last = 'skin'
                                bFound = true;
                            break;
                        }
                    }
                }
            }
            if (!bFound)
            {
                getSearchResultOutput();
                return;
            }

            //Replace strings for search with pairs (string,index file)
            StringPairArray[i] = new Array();
            StringPairArray[i][0]=st;
            StringPairArray[i][1]=IndexOfFiles[j].fileName;
        }
        SearchResults=new Array();
        iStringToSearch=0;
        SearchForNextString();
    }

    //Downloads prefixes.json
    //Fills IndexOfFiles array
    function GetIndex()
    {
        SearchResults=new Array();
        NextStringToSearch=0; //?
        var sURL = dirname() + "/de_search/prefixes.json";
        request.open("GET", sURL);
        request.onreadystatechange = function() {
            if (request.readyState === 4)
            {
                if (request.status === 200 || request.status === 0 && request.responseText !== '')
                {
                    try
                    {
                        IndexOfFiles = JSON.parse(request.responseText);
                    }
                    catch(e)
                    {
                        $(document).trigger("searchError");
                        if (isRemoteSearch())
                            DR_EXPLAIN.searchManager.showRemoteSearchError(-34);
                        else
                            DR_EXPLAIN.searchManager.showLocalSearchError();
                        return;
                    }
                    AttachFilesToStrings();
                }
                else
                {
                    $(document).trigger("searchError");
                    if (isRemoteSearch())
                        DR_EXPLAIN.searchManager.showRemoteSearchError(request.status);
                    else
                        DR_EXPLAIN.searchManager.showLocalSearchError();
                }
            }
        };
        request.send(null);
    }

    function dirname()
    {
        var retValue = window.location.href;
        retValue = retValue.substring(0, retValue.lastIndexOf('/'));
        return retValue;
    }

    function reverse(str) {
        if(!str) return str;
        return str.charAt(str.length-1) + reverse(str.substring(0,str.length-1));
    }

    function trimLeft(str) {
        for (var i=0; str.charAt(i) == ' '; i++);
        return str.substring(i, str.length);
    }

    function trimRight(str) {
        return reverse(trimLeft(reverse(str)));
    }

    function trim(str) {
        return trimRight(trimLeft(str));
    }

    function isEmpty(sToCheck) {
        var sTest;
        sTest = trim(sToCheck)
        if (sTest == null || sTest == "") {
            return true;
        }
        return false;
    }

    function searchmain(str)
    {
        $( document ).trigger( "searchBegin" );
        SearchResults=new Array();
        iStringToSearch=0;

        //Split the string into words
        var strs = DR_EXPLAIN.wordSplitter.splitString(str);
        StringsForSearch = new Array();
        for (var i = 0; i < strs.length; ++i)
            if (!isEmpty(strs[i]))
                StringsForSearch.push(strs[i]);
        //Download index.txt asynchronously and fill array of indexes
        GetIndex();

        return 1;
    }

    function max(a,b){
        return a>b?a:b;
    }
    function min(a,b){
        return a<b?a:b;
    }



    var API = {
        trim: function( str ) {
            return trim( str );
        },

        doSearch: function( str ) {
            return searchmain( str );
        },

        getSearchResults: function() {
            return SearchResults;
        }
    };

    return API;


})();


/*js/drexplain/drexplain.search-manager.js*/
DR_EXPLAIN.namespace( 'DR_EXPLAIN.searchManager' );
DR_EXPLAIN.searchManager = (function(){
    var _class = {
        elementsArr: null,
        isFirstSearch: true,
        dom: null,
        highlightManager: null,
        dataManager: null,
        urlEncoder: null,
        searchEngine: null,
        wordSplitter: null,


        init: function() {
            this.doSetDom();
            this.doSetHighlightManager();
            this.doSetDataManager();
            this.doSetNavTreeSearch();
            this.doSetUrlEncoder();
            this.doSetSearchEngine();
            this.doSetSearchInProgressText();
            this.doSetWordSplitter();
        },

        doSetSearchInProgressText: function() {
            this.dom.$searchProgress.prop( "alt", this.dataManager.getSearchTextInProgress() );
        },

        doSetHighlightManager: function() {
            this.highlightManager = DR_EXPLAIN.highlightManager;
        },

        doSetDataManager: function() {
            this.dataManager = DR_EXPLAIN.dataManager;
        },

        doSearchIfQueryStringNotEmpty: function() {
            this.doSetQueryStringByUrlEncoder();
            if ( this.elementsArr[ 0 ].$input.prop( "value" ) !== '' ) {
                this.elementsArr[ 0 ].$submit.trigger( "click" );
            }
        },

        runCustomButtons: function() {
            var searchInWorkZone = new CustomButton( this.dom.$workZoneSearchSubmit );
            searchInWorkZone.run();

            var searchInTab = new CustomButton( this.dom.$tabSearchSubmit );
            searchInTab.run();
        },

        runInputPlaceholders: function() {
            var searchInTabPlaceholder = new InputPlaceholder( this.dom.$tabSearchInput, this.dom.$tabSearchInputLabel, true );
            searchInTabPlaceholder.run();

            var searchInWorkZonePlaceholder = new InputPlaceholder( this.dom.$workZoneSearchInput, this.dom.$workZoneSearchInputLabel, true );
            searchInWorkZonePlaceholder.run();
        },

        runInputSync: function() {
            var that = this;

            var $inputArr = this.dom.$tabSearchInput.add( this.dom.$workZoneSearchInput );
            var inputSync = new InputSync( $inputArr );
            inputSync.run();

            this.dom.$workZoneSearchSubmit.on( "click",function() {
                that.dom.$tabSelectorSearch.click();
            });
        },

        doSetNavTreeSearch: function() {
            this.navTreeSearch = DR_EXPLAIN.navTree_Search;
        },

        doSetDom: function() {
            this.dom = DR_EXPLAIN.dom;
            this.elementsArr = [
                                { $input: this.dom.$tabSearchInput, $submit: this.dom.$tabSearchSubmit },
                                { $input: this.dom.$workZoneSearchInput, $submit: this.dom.$workZoneSearchSubmit }
                            ];
        },

        doSetUrlEncoder: function() {
            var that = this;

            this.urlEncoder = DR_EXPLAIN.urlEncoder;
            this.urlEncoder.addSaveFunc(
                    function() {
                        if ( that.isSearchTabSelected() ) {
                            return that.getSearchQuery();
                        }
                        else {
                            return "";
                        }

                    },
                    this.urlEncoder.KEY_NAME__SEARCH_QUERY
                );
        },

        doSetSearchEngine: function() {
            this.searchEngine = DR_EXPLAIN.searchEngine;
        },

        doSetWordSplitter: function() {
            this.wordSplitter = DR_EXPLAIN.wordSplitter;
        },


        setUrlEncoder: function( urlEncoder, urlEncoderKeyName ) {
            this.urlEncoder = urlEncoder;
            this.urlEncoderKey = urlEncoderKeyName;
        },

        doSetQueryStringByUrlEncoder: function() {
            if( this.urlEncoder !== null ) {
                var queryString = this.urlEncoder.getValueByKey( this.urlEncoder.KEY_NAME__SEARCH_QUERY );
                if ( queryString !== null ) {
                    for ( var index = 0; index < this.elementsArr.length; index += 1 ) {
                        this.elementsArr[ index ].$input.prop( "value", queryString );
                        this.elementsArr[ index ].$input.trigger( "keypressSync" );
                    }
                }
            }
        },

        doBindEvents: function() {
            for ( var index = 0; index < this.elementsArr.length; index += 1 ) {
                this.bindEventToElement( this.elementsArr[ index ] );
            }

            var that = this;

            $( document ).on( "searchComplete.search", function() {
                that.searchComplete();
                that.hideSearchProgress();
            });

            $( document ).on( "searchBegin.search", function() {
                that.showSearchProgress();
            });

            $( document ).on( "searchError.search", function() {
                that.hideSearchProgress();
            });
        },

        hideSearchProgress: function() {
            if ( this.dom.$searchProgress.is( ":visible" ) ) {
                this.dom.$searchProgress.fadeOut( 333 );
            }
            else {
                this.dom.$searchProgress.css( "display", "none" );
            }

        },

        showSearchProgress: function() {
            $( "#searchProgress" ).fadeIn( 333 );
        },

        bindEventToElement: function( elem ) {
            var that = this;
            elem.$submit.closest( "form" ).on( "submit", function( e ){
                elem.$input.blur();
                that.dom.$tabSelectorSearch.click();
                that.onClick( elem );
                return false;
            });
        },

        onClick: function( elem ) {
            var s = this.searchEngine.trim(document.getElementById( elem.$input.prop( "id" ) ).value).replace(/\r/g,'').replace(/\n/g,'').replace(/\t/g,' ').replace(/\u00A0/g,'');
            s = s.replace(/[,;]/g, ' ');
            this.performSearch(s);
        },

        performSearch: function( s ) {
            var queryArray = this.wordSplitter.splitString(s);
            var output = '';
            if (queryArray.length == 0 || queryArray[0] == '')
                this.showSearchTextEmptyString();
            else
                this.searchEngine.doSearch(s);
        },

        searchComplete: function() {
            this.highlightManager.hide();
            var searchResultsArr = this.searchEngine.getSearchResults();
            if ( searchResultsArr.length > 0 ) {
                this.navTreeSearch.setNewContentBySearchResults( searchResultsArr );
                this.navTreeSearch.show();
                $( document ).trigger( "searchCompleteBuildTree" );


                var searchQuery = this.getSearchQuery();
                var searchQueryArr = this.wordSplitter.splitString(searchQuery);
                this.highlightManager.show( searchQueryArr );

                if ( this.isFirstSearch && this.isSearchTabSelectedOnStart() ) {
                    if ( this.isFirstSearch ) {
                        $( document ).trigger( "firstSearchCompleteWithSelectedSearchTab" );
                        this.isFirstSearch = false;
                    }

                }
            }
            else {
                var $msg = $( '<div class="b-tree__searchResultText">' + this.dataManager.getSearchTextNoResults() + '</div>' );
                this.dom.tabs.search.$tree.html( $msg );
                $( document ).trigger( "searchCompleteBuildTree" );
            }
        },

        showSearchTextEmptyString: function() {
            this.highlightManager.hide();
            var $msg = $( '<div class="b-tree__searchResultText">' + this.dataManager.getSearchTextEmptyString() + '</div>' );
            this.dom.tabs.search.$tree.html( $msg );
            $( document ).trigger( "searchCompleteBuildTree" );
        },

        showLocalSearchError: function() {
            this.highlightManager.hide();
            var $msg = $( '<div class="b-tree__searchResultText">' + this.dataManager.getErrorInLocalSearch() + '</div>' );
            this.dom.tabs.search.$tree.html( $msg );
            $( document ).trigger( "searchCompleteBuildTree" );
        },

        showRemoteSearchError: function(code) {
            this.highlightManager.hide();
            var $msg = $( '<div class="b-tree__searchResultText">' + this.dataManager.getErrorInRemoteSearch(code) + '</div>' );
            this.dom.tabs.search.$tree.html( $msg );
            $( document ).trigger( "searchCompleteBuildTree" );
        },

        isSearchTabSelected: function() {
            var $navTree_search = this.dom.tabs.search.$wrapperItem;
            if ( $navTree_search.hasClass( "m-tabs__wrapperItem__selected" ) ) {
                return true;
            }
            else {
                return false;
            }
        },

        isSearchTabSelectedOnStart: function() {
            var $navTree_search = this.dom.tabs.search.$wrapperItem;
            if ( $navTree_search.index() === parseInt( this.urlEncoder.getValueByKey( this.urlEncoder.KEY_NAME__TAB_INDEX ) ) ) {
                return true;
            }
            else {
                return false;
            }
        },

        getSearchQuery: function() {
            if ( this.elementsArr[ 0 ] !== undefined ) {
                return this.elementsArr[ 0 ].$input.prop( "value" );
            }
            else {
                return null;
            }
        },

        isSearchQueryNotEmpty: function() {
            var query = this.getSearchQuery();
            if ( query !== null ) {
                if ( query !== '' ) {
                    return true;
                }
            }
            return false;
        }
    };

    var API = {
        init: function() {
            _class.init();
        },

        runCustomButtons: function() {
            _class.runCustomButtons();
        },

        runInputSync: function() {
            _class.runInputSync();
        },

        runInputPlaceholders: function() {
            _class.runInputPlaceholders();
        },

        doBindEvents: function() {
            _class.doBindEvents();
        },

        doSearchIfQueryStringNotEmpty: function() {
            _class.doSearchIfQueryStringNotEmpty();
        },

        showLocalSearchError: function() {
            _class.showLocalSearchError();
        },

        showRemoteSearchError: function(code) {
            _class.showRemoteSearchError(code);
        }
    };

    return API;
})();


/*js/drexplain/drexplain.highlight-manager.js*/
DR_EXPLAIN.namespace( 'DR_EXPLAIN.highlightManager' );
DR_EXPLAIN.highlightManager = (function(){

    var _class = {
        dom: null,
        $content: null,

        init: function() {
            this.doSetDom();
        },

        doSetDom: function() {
            this.dom = DR_EXPLAIN.dom;
            this.$content = this.dom.$articleInnerWrapper;
        },

        show: function( wordsArr ) {
            this.hide();
            var tempArr = new Array();
            for ( var index = 0; index < wordsArr.length; index += 1 )
                tempArr.push(wordsArr[index]);
            tempArr.sort(function(a, b){
                a = a.toUpperCase();
                b = b.toUpperCase();
                if (a < b) return -1;
                if (a > b) return 1;
                return 0;
            }).reverse();
            for ( var index = 0; index < tempArr.length; index += 1 ) {
                this.$content.highlight( tempArr[ index ] );
            }
            this.hideFromCopyright();
        },

        hide: function() {
            this.$content.removeHighlight();
        },

        hideFromCopyright: function() {
            this.dom.$articleGeneratorCopyright.removeHighlight();
        }
    };

    var API = {
        init: function() {
            _class.init();
        },
        show: function( wordsArr ) {
            _class.show( wordsArr );
        },
        hide: function() {
            _class.hide();
        }
    };

    return API;
})();


/*js/drexplain/drexplain.tab-controller.js*/
DR_EXPLAIN.namespace( 'DR_EXPLAIN.tabController' );

DR_EXPLAIN.tabController = (function(){
    var _class = {
        DREX_SHOW_MENU: 1,
        DREX_SHOW_SEARCH: 1,
        DREX_SHOW_INDEX: 1,
        DREXPLAIN_MAKE_TAB_COUNT: 3,

        tabArr: [],
        urlEncoder: null,
        dom: null,

        init: function() {

            this.doSetDom();
            this.doSetUrlEncoder();
            this.doAddTabs();
        },

        addTab: function( $tabSelector, $tabWrapper, $tabWrapperInner ) {
            this.tabArr.push({
                $selector: $tabSelector,
                $wrapper: $tabWrapper,
                $wrapperInner: $tabWrapperInner,
                scrollTop: 0
            });
        },

        doSetDom: function() {
            this.dom = DR_EXPLAIN.dom;
        },

        doAddTabs: function() {
            if (this.DREX_SHOW_MENU)
                this.addTab( this.dom.tabs.menu.$selectorItem , this.dom.tabs.menu.$wrapperItem, this.dom.tabs.menu.$wrapperItemInner );
            if (this.DREX_SHOW_INDEX)
                this.addTab( this.dom.tabs.index.$selectorItem , this.dom.tabs.index.$wrapperItem, this.dom.tabs.index.$wrapperItemInner );
            if (this.DREX_SHOW_SEARCH)
                this.addTab( this.dom.tabs.search.$selectorItem , this.dom.tabs.search.$wrapperItem, this.dom.tabs.search.$wrapperItemInner );
        },

        doSetUrlEncoder: function() {
            var that  = this;
            this.urlEncoder = DR_EXPLAIN.urlEncoder;


            this.urlEncoder.addSaveFunc(
                    function() {
                        return that.getSelectedTabIndex();
                    },
                    that.urlEncoder.KEY_NAME__TAB_INDEX
                );

            this.urlEncoder.addSaveFunc(
                    function() {
                        return that.getVisibleTabScrollTop();
                    },
                    that.urlEncoder.KEY_NAME__MENU_SCROLL_TOP
            );
        },

        getVisibleTabScrollTop: function() {
            var selectedTab = this.getSelectedTab();
            if (!selectedTab)
                return 0;
            var $wrapperItemInner = selectedTab.$wrapperInner;
            var scrollTop = 0;
            if ( $wrapperItemInner !== null ) {
                scrollTop = $wrapperItemInner.scrollTop();
            }

            return scrollTop;
        },

        doSetScrollTopByUrlEncoder: function() {
            if( this.urlEncoder !== null ) {
                var scrollTop = this.urlEncoder.getValueByKey( this.urlEncoder.KEY_NAME__MENU_SCROLL_TOP );
                if ( scrollTop !== null ) {
                    var selectedTab = this.getSelectedTab();
                    if (!selectedTab)
                        return;
                    var $visibleWrapperItemInner = selectedTab.$wrapperInner;
                    $visibleWrapperItemInner.scrollTop( scrollTop ).trigger( "scroll" );
                }
                else {
                    var $selectedTreeElem = this.dom.tabs.menu.$tree.find( ".m-tree__itemContent__selected" );
                    if ( $selectedTreeElem.length > 0 ) {
                        var selectedTreeElemTop = ( $selectedTreeElem.offset() ).top - ( this.dom.$tabWrapperItems.offset() ).top - $selectedTreeElem.height() / 2;
                        this.dom.tabs.menu.$wrapperItemInner.scrollTop( selectedTreeElemTop  ).trigger( "scroll" );
                    }
                }
            }
        },

        doSetTabIndexByUrlEncoder: function() {
            if( this.urlEncoder !== null ) {
                var tabIndex = this.urlEncoder.getValueByKey( this.urlEncoder.KEY_NAME__TAB_INDEX );
                if ( tabIndex !== null ) {
                    if ( this.tabArr[ tabIndex ] !== undefined ) {
                        this.toggleTabState( this.tabArr[ tabIndex ].$selector );
                    }
                }
            }
        },

        doBindEvents: function() {
            for ( var index = 0; index < this.tabArr.length; index += 1 ) {
                this.doBindEventToggleState( index );
                this.doBindScrollTopSaver( index );
            }

            this.doBindEventHover();
            var that = this;
            $( document ).on( "navResize",function() {
                that.doSetScrollPositionToSelectedTab();
            });
            $( document ).on( "firstSearchCompleteWithSelectedSearchTab",function() {
                that.doSetScrollTopByUrlEncoder();
            });
        },

        doBindEventToggleState: function( index ) {
            var that = this;

            this.tabArr[ index ].$selector.click(function(){
                if ( !$( this ).hasClass( "m-tabs__selectorItem__selected" ) ) {
                    that.toggleTabState( $( this ) );
                    $( window ).resize();
                }
            });
        },

        doBindScrollTopSaver: function( index ) {
            var that = this;

            this.tabArr[ index ].$wrapperInner.on( "scroll", function() {
                that.tabArr[ index ].scrollTop = $( this ).scrollTop();
            });
        },

        doBindEventHover: function() {
            if (this.tabArr.length == 0)
                return;

            var $selectorItems = this.tabArr[ 0 ].$selector.parent();

            $selectorItems.on( "mouseenter", ".b-tabs__selectorItem", function(){
                if ( $( this ).hasClass( "m-tabs__selectorItem__selected") )
                    return false;
                $( this ).addClass( "m-tabs__selectorItem__hovered" );
            });

            $selectorItems.on( "mouseleave", ".b-tabs__selectorItem", function(){
                if ( $( this ).hasClass( "m-tabs__selectorItem__selected") )
                    return false;
                $( this ).removeClass( "m-tabs__selectorItem__hovered" );
            });
        },

        toggleTabState: function( $selectedTabSelector ) {
            for ( var index = 0; index < this.tabArr.length; index += 1 ) {
                var $currTabSelector = this.tabArr[ index ].$selector;
                if ( $currTabSelector.prop( "id" ) === $selectedTabSelector.prop( "id" ) ) {
                    this.showTabByIndex( index );
                }
                else {
                    this.hideTabByIndex( index );
                }
            }

            $( document ).trigger( "newTabSelected.tabs" );
        },

        showTabByIndex: function( index ) {
            if (index == -1)
                return;
            var $tabSelector = this.tabArr[ index ].$selector;
            var $tabWrapper = this.tabArr[ index ].$wrapper;
            var $tabWrapperInner = this.tabArr[ index ].$wrapperInner;
            var scrollTop = this.tabArr[ index ].scrollTop;

            //console.log( 'show tab: %s %s', $tabSelector.prop( "id" ), $tabWrapper.prop( "id" ) );

            $tabSelector.
                addClass( "m-tabs__selectorItem__selected" ).
                removeClass( "m-tabs__selectorItem__hovered" ).
                removeClass( "m-tabs__selectorItem__unselected" );

            $tabWrapper.addClass( "m-tabs__wrapperItem__selected" );
            $tabWrapperInner.scrollTop( scrollTop );
        },

        hideTabByIndex: function( index ) {
            var $tabSelector = this.tabArr[ index ].$selector;
            var $tabWrapper = this.tabArr[ index ].$wrapper;

            //console.log( 'hide tab: %s %s', $tabSelector.prop( "id" ), $tabWrapper.prop( "id" ) );


            $tabSelector.
                removeClass( "m-tabs__selectorItem__selected" ).
                addClass( "m-tabs__selectorItem__unselected" );

            $tabWrapper.removeClass( "m-tabs__wrapperItem__selected" );

        },

        getSelectedTabIndex: function() {
            for ( var index = 0; index < this.tabArr.length; index += 1 ) {
                var $currTabSelector = this.tabArr[ index ].$selector;
                if ( $currTabSelector.hasClass( "m-tabs__selectorItem__selected" ) ) {
                    return index;
                }
            }
            if (this.tabArr.length == 0)
                return -1;
            return 0;
        },

        getSelectedTab: function() {
            var selectedTabIndex = this.getSelectedTabIndex();
            if (selectedTabIndex == -1)
                return null;
            return this.tabArr[ selectedTabIndex ];
        },

        doSetScrollPositionToSelectedTab: function() {
            var selectedTabIndex = this.getSelectedTabIndex();
            this.showTabByIndex( selectedTabIndex );
        }
    };

    var API = {
        init: function() {
            _class.init();
        },

        doBindEvents: function() {
            _class.doBindEvents();
        },

        doSetTabIndexByUrlEncoder: function() {
            _class.doSetTabIndexByUrlEncoder();
        },

        doSetScrollTopByUrlEncoder: function() {
            _class.doSetScrollTopByUrlEncoder();
        },

        tabsCount: function() {
            return _class.DREXPLAIN_MAKE_TAB_COUNT;
        },

        isMenuTabShown: function() {
            return _class.DREX_SHOW_MENU != 0;
        },

        isSearchTabShown: function() {
            return _class.DREX_SHOW_SEARCH != 0;
        },

        isIndexTabShown: function() {
            return _class.DREX_SHOW_INDEX != 0;
        }
    };

    return API;

})();


/*js/drexplain/drexplain.url-encoder.js*/
DR_EXPLAIN.namespace( 'DR_EXPLAIN.urlEncoder' );
DR_EXPLAIN.urlEncoder = (function(){
    var _class = {

        urlDecoded: null,
        funcArr: [],
        utils: null,
        dom: null,

        init: function() {
            this.utils = DR_EXPLAIN.utils;
            this.dom = DR_EXPLAIN.dom;
        },

        doBindOpenNextPageWithEncodedStringToLinks: function() {
            var that = this;
            this.dom.$pageContent.on( "click", "a.local_link, a.b-breadCrumbs__link, a.b-controlButtons__link, a.b-tree__itemLink", function(e) {
                that.openNextPage( $( this ).prop( "href" ), $( this ).attr("href"), $( this ).prop( "target" ) == "_blank" );
                e.preventDefault();
                return false;
            });
        },
        doBindOpenNextPageWithEncodedStringToLinksInClonedNode: function() {
            var that = this;
            $(".cloned_node").on("click", "a", function(e) {
                that.openNextPage( $( this ).prop( "href" ), $( this ).attr("href"), $( this ).prop( "target" ) == "_blank" );
                e.preventDefault();
                return false;
            });
        },

        doBindOpenNextPageWithEncodedStringToLinksInKeywordContextMenu: function() {
            var that = this;
            this.dom.$keywordContextMenu.on( "click", "a.b-tree__itemLink", function(e) {
                that.openNextPage( $( this ).prop( "href" ), $( this ).attr("href"), $( this ).prop( "target" ) == "_blank" );
                e.preventDefault();
                return false;
            });
        },


        openNextPage: function( nextpage, nextPageHref, atNewPage ) {

            atNewPage = typeof(atNewPage) != 'undefined' ? atNewPage : false;

            var stateParams = this.getEncodedUrl();

            var targetUrl = nextpage;
            if (nextPageHref && nextPageHref.length > 0 && nextPageHref.charAt(0) == '#')
            {
                targetUrl = nextPageHref;
                nextpage = nextPageHref;
            }
            if ( $( "html" ).hasClass( "ie" ) )
                targetUrl = this.utils.escapeXml(nextpage);
            var anch = "";
            var anchPos = -1;
            if ((anchPos = nextpage.indexOf("#")) != -1) {
                targetUrl = nextpage.substr(0, anchPos);
                anch = nextpage.substr(anchPos);
            }
            targetUrl += "?" + stateParams + anch;
            window.open(targetUrl, atNewPage ? "_blank" : "_self");
        },


        doDecodeUrl: function() {
            var map = [];
            var urlParams = {};
                var e,
                    a = /\+/g,  // Regex for replacing addition symbol with a space
                    r = /([^&=]+)=?([^&]*)/g,
                    d = function (s) { return decodeURIComponent(s.replace(a, " ")); },
                    q = window.location.search.substring(1);

                while (e = r.exec(q))
                   urlParams[d(e[1])] = d(e[2]);

            for ( var key in urlParams ) {
                var value = this.decodeString( urlParams[ key ] );
                map[key] = value;
            }

            this.urlDecoded = map;
        },


        getValueByKey: function( key ) {
            if( this.urlDecoded[ key ] !== undefined ) {
                return this.urlDecoded[ key ];
            }
            else {
                return null;
            }
        },


        addSaveFunc: function( func, key ) {
            this.funcArr[ key ] = func;
        },

        getEncodedUrl: function() {
            var result = "";
            for ( var key in this.funcArr ) {
                var currFunc = this.funcArr[ key ];
                var value = currFunc();

                value = this.encodeString( value.toString() );

                if ( value.toString().length > 0 ) {
                    if (result != "") {
                        result += "&";
                    }
                    result += key + "=" + encodeURIComponent(value);
                }
            }
            return result;
        },


        decodeString: function( str ) {
            var bits = this.utils.base64.decode(str, 0, true, true);
            if ( bits === null ) {
                return null;
            }
            var result = this.utils.ar2str(bits);
            result = this.utils.utf8.decode(result);
            return result;
        },

        encodeString: function( str )
        {
            var compressedStr = str;
            var utfEncodedStr = this.utils.utf8.encode(compressedStr);
            var bitArray = this.utils.str2ar(utfEncodedStr);
            return this.utils.base64.encode(bitArray, false, true);
        }
    };

    var API = {
        KEY_NAME__MENU_WIDTH: "mw",
        KEY_NAME__MENU_STATE: "ms",
        KEY_NAME__TAB_INDEX: "st",
        KEY_NAME__MENU_SCROLL_TOP: "sct",
        KEY_NAME__SEARCH_QUERY: "q",

        init: function() {
            _class.init();
        },

        doBindOpenNextPageWithEncodedStringToLinks: function() {
            _class.doBindOpenNextPageWithEncodedStringToLinks();
        },

        doBindOpenNextPageWithEncodedStringToLinksInClonedNode: function() {
            _class.doBindOpenNextPageWithEncodedStringToLinksInClonedNode();
        },

        doBindOpenNextPageWithEncodedStringToLinksInKeywordContextMenu: function() {
            _class.doBindOpenNextPageWithEncodedStringToLinksInKeywordContextMenu();
        },

        doDecodeUrl: function() {
            _class.doDecodeUrl();
        },

        getValueByKey: function( key ) {
            return _class.getValueByKey( key );
        },

        addSaveFunc: function( func, key ) {
            _class.addSaveFunc(func, key);
        }
    };

    return API;
})();


DR_EXPLAIN.namespace('DR_EXPLAIN.mapAreasKeeper');

DR_EXPLAIN.mapAreasKeeper = (function($, Math) {
    var API = {
        recalculate: function() {
            $('map').each(function() {
                var $map = $(this);
                var $img = $('img[usemap="#' + $map.attr('id') + '"]');
                if ($img.length > 0) {
                    var originalWidth = $img.attr('width');
                    var realWidth = $img.width();
                    var horizCoef = realWidth / originalWidth;

                    var originalHeight = $img.attr('height');
                    var realHeight = $img.height();
                    var vertCoef = realHeight / originalHeight;

                    if (isFinite(horizCoef) && isFinite(vertCoef)) {
                        $map.find('area').each(function() {
                            var $area = $(this);

                            var originalCoordLeft = parseInt($area.attr('data-coord-left'), 10);
                            var originalCoordTop = parseInt($area.attr('data-coord-top'), 10);
                            var originalCoordRight = parseInt($area.attr('data-coord-right'), 10);
                            var originalCoordBottom = parseInt($area.attr('data-coord-bottom'), 10);

                            var coordLeft = Math.round(originalCoordLeft * horizCoef);
                            var coordTop = Math.round(originalCoordTop * vertCoef);
                            var coordRight = Math.round(originalCoordRight * horizCoef);
                            var coordBottom = Math.round(originalCoordBottom * vertCoef);

                            var coordsAttr = [coordLeft, coordTop, coordRight, coordBottom].join(',');
                            $area.attr('coords', coordsAttr);
                        });
                    }
                }
            });
        }
    };

    return API;
})($, Math);


/*js/drexplain/drexplain.work-zone-sizer.js*/
DR_EXPLAIN.namespace( 'DR_EXPLAIN.workZoneSizer' );

DR_EXPLAIN.workZoneSizer = (function(){
    var _class = {
        NAV_MIN_WIDTH_DEFAULT: 250,
        ARTICLE_MIN_WIDTH_DEFAULT: 400,
        //IE_SCROLLBAR_SIZE: 24,

        dom: null,
        dataManager: null,
        mapAreasKeeper: null,

        currNavWidth: 0,
        currArticleWidth: 0,
        minNavWidth: null,
        maxNavWidth: null,

        minArticleWidth: null,

        visibleTabLongestTreeItemWidth: null,

        preferredNavWidth: 0,

        timeoutId: null,
        WINDOW_RECALCULATING_DELAY: 100,

        init: function() {
            this.doSetCachedDom();
            this.doSetUrlEncoder();
            this.doSetDataManager();
            this.doSetNavMinWidth();
            this.doSetArticleMinWidth();
            if (!is_touch_device()) {
                this.doSetSplitter();
            }
            this.doSetFrameModeSizer();
            this.doSetFlowModeSizer();
            this.doSetCurrNavWidth();
            this.doSetMapAreasKeeper();
        },

        doSetCachedDom: function() {
            this.dom = DR_EXPLAIN.dom;
        },

        doSetDataManager: function() {
            this.dataManager = DR_EXPLAIN.dataManager;
        },

        doSetMapAreasKeeper: function() {
            this.mapAreasKeeper = DR_EXPLAIN.mapAreasKeeper;
        },

        doSetUrlEncoder: function() {
            var that = this;

            this._urlEncoder = DR_EXPLAIN.urlEncoder;
            this._urlEncoder.addSaveFunc(function(){
                return that.currNavWidth;
            }, that._urlEncoder.KEY_NAME__MENU_WIDTH );
        },

        doSetCurrNavWidth: function() {
            var currNavWidth = null;
            if( this._urlEncoder !== null ) {
                currNavWidth = this._urlEncoder.getValueByKey( this._urlEncoder.KEY_NAME__MENU_WIDTH );
                if ( currNavWidth !== null ) {
                    this.currNavWidth = currNavWidth;
                }
            }

            if ( currNavWidth === null ) {
                var startingMenuWidth = this.dataManager.getStartingMenuWidth();
                if ( $.isNumeric( startingMenuWidth ) ) {
                    this.currNavWidth = startingMenuWidth;
                } else {
                    this.currNavWidth = this.dom.$workZoneSideNav.width();
                }
            }

            this.preferredNavWidth = this.currNavWidth;
        },

        getTabWidth: function(tabId) {
            var curTab = document.getElementById(tabId);
            if (curTab)
                return $('#' + tabId).outerWidth(true);
            return 0;
        },

        doSetNavMinWidth: function() {
            var minWidth = parseInt( this.dom.$workZoneSideNav.css( "minWidth" ), 10 );
            if ( $.isNumeric( minWidth ) && ( minWidth !== 0 ) ) {
                this.minNavWidth = minWidth;
            }
            else {
                this.minNavWidth = this.NAV_MIN_WIDTH_DEFAULT;
            }
            var summaryTabWidth = 0;
            summaryTabWidth += this.getTabWidth("tabSelector_menu");
            summaryTabWidth += this.getTabWidth("tabSelector_index");
            summaryTabWidth += this.getTabWidth("tabSelector_search");
            this.minNavWidth = Math.max(this.minNavWidth, summaryTabWidth + 20);
        },

        doSetArticleMinWidth: function() {
            var minWidth = parseInt( this.dom.$workZoneSideArticle.css( "minWidth" ), 10 );
            if ( $.isNumeric( minWidth ) && ( minWidth !== 0 ) ) {
                this.minArticleWidth = minWidth;
            }
            else {
                this.minArticleWidth = this.ARTICLE_MIN_WIDTH_DEFAULT;
            }
        },

        recalculateNavMaxWidth: function() {
            // AT: we do not need to calculate this if nav is hidden or displayed in side pane
            // AT: if side pane is active, max nav width can be set as window width - 40px
            if (this.isNavTopmost()) {
                this.maxNavWidth = $(window).width() - 40;
                return;
            }

            var userLeftSideWidth = 0;
            var userRightSideWidth = 0;
            var isUserLeftSideExistsAndVisible = ( ( this.dom.$pageContentLeft.length ) > 0 && this.dom.isPageLeftVisible() );
            var isUserRightSideExistsAndVisible = ( ( this.dom.$pageContentRight.length ) > 0 && this.dom.isPageRightVisible() );

            if ( isUserLeftSideExistsAndVisible ) {
                userLeftSideWidth = this.dom.$pageContentLeft.outerWidth( true );
            }

            if ( isUserRightSideExistsAndVisible ) {
                userRightSideWidth = this.dom.$pageContentRight.outerWidth( true );
            }

            var windowWidth = $(window).width();
            var minArticleWidth = this.minArticleWidth;
            if (this.dom.$headerSide__nav.length)
            {
                var headerSide__buttons_width = this.dom.$headerSide__buttons.outerWidth();

                var headerSide__nav_paddings = this.dom.$headerSide__nav.outerWidth() - this.dom.$headerSide__nav.width();
                var maxBreadCrumbWidth = 0;
                this.dom.$headerSide__nav__breadCrumbs.find("li").each(function(index) { maxBreadCrumbWidth = Math.max(maxBreadCrumbWidth, $(this).outerWidth()) });
                var headerSide__nav__breadCrumbs_width = maxBreadCrumbWidth;
                var articlePaddings = this.dom.$article.outerWidth() - this.dom.$article.width();
                var workZoneSideArticlePaddings = this.dom.$workZoneSideArticle.outerWidth() - this.dom.$workZoneSideArticle.width();
                var workZoneSideArticleContentPaddings = this.dom.$workZoneSideArticleContent.outerWidth() - this.dom.$workZoneSideArticleContent.width();
                var workZoneNavPaddings = this.dom.$workZoneSideNav.outerWidth() - this.dom.$workZoneSideNav.width();

                minArticleWidth = Math.max(minArticleWidth, headerSide__buttons_width + headerSide__nav__breadCrumbs_width +headerSide__nav_paddings + articlePaddings + workZoneSideArticlePaddings + workZoneSideArticleContentPaddings + workZoneNavPaddings);
            }

            var maxContentAreaWidth = this.dom.$internal_wrapper.css("width");
            if (!maxContentAreaWidth || maxContentAreaWidth.length < 2)
            {
                maxContentAreaWidth = windowWidth;
            }
            else
            {
                if (maxContentAreaWidth.charAt(maxContentAreaWidth.length - 1) == '%')
                {
                    maxContentAreaWidth = parseInt(maxContentAreaWidth, 10) * windowWidth / 100;
                }
                else
                {
                    maxContentAreaWidth = parseInt(maxContentAreaWidth, 10);
                }
            }
            var maxWidth = maxContentAreaWidth - minArticleWidth - userLeftSideWidth - userRightSideWidth;

            if ( maxWidth < this.NAV_MIN_WIDTH_DEFAULT ) {
                maxWidth = this.NAV_MIN_WIDTH_DEFAULT;
            }

            this.maxNavWidth = maxWidth;
            //console.log( [windowWidth,minArticleWidth,userLeftSideWidth,userRightSideWidth, maxWidth, this.minArticleWidth ] );
        },

        isNavEnabled: function() {
            return !this.dom.$workZone.hasClass('m-workZone__withoutSideNav');
        },

        isNavTopmost: function() {
            return this.dom.$workZoneSideNav.hasClass('topmost');
        },

        showNavTopmost: function() {
            this.currArticleWidth = this.dom.$workZoneSideArticle.width();

            this.dom.$workZoneSideNav.addClass('topmost').show();
            this.dom.$workZoneSideArticle.addClass('overlayed');
            this.dom.$body.addClass('no-horizontal-scroll');

            $(document).trigger('sideNavTopmostPresent');

            var that = this;
            this.dom.$workZoneSideArticleOverlay.on('click', function(e) {
                e.preventDefault();
                that.hideNavTopmost();
            });

            this.dom.$dismissSideNavButton.on('click', function(e) {
                e.preventDefault();
                that.hideNavTopmost();
            });
        },

        hideNavTopmost: function() {
            this.dom.$workZoneSideNav.removeClass('topmost').hide();
            this.dom.$workZoneSideArticle.removeClass('overlayed').width('100%');
            this.dom.$body.removeClass('no-horizontal-scroll');

            $(document).trigger('sideNavTopmostDismiss');

            this.dom.$workZoneSideArticleOverlay.off('click');
            this.dom.$dismissSideNavButton.off('click');
        },

        getDesirableNavWidth: function() {
            return _.min([
                _.max([
                    this.dataManager.getStartingMenuWidth(),
                    this.visibleTabLongestTreeItemWidth + 22,
                    this.minNavWidth,
                    this.currNavWidth
                ]),
                this.maxNavWidth
            ]);
        },

        recalculateAll: function() {
            this.dom.updatePageLayoutType();
            this.recalculateNavMaxWidth();
            this.recalculateVisibleTabLongestTreeItemWidth();

            if (this.dom.$workZoneSideNav.is(':visible')) {
                this.dom.$hasHorizontalScrollbar = {};
                this.dom.$hasVerticalScrollbar = {};
                if (this.isNavTopmost()) {
                    var desirableWidth = this.getDesirableNavWidth();
                    this.setNewNavWidth(desirableWidth);
                } else {
                    this.setNewNavWidth(this.preferredNavWidth);
                }
            }

            if (this.isNavTopmost()) {
                this.dom.$workZoneSideArticle.width(this.currArticleWidth);
            } else {
                this.frameModeSizer.recalculateIfEnabled();
            }

            this.flowModeSizer.recalculateIfEnabled();
            this.mapAreasKeeper.recalculate();
        },

        ensureModeSizer: function() {
            if (this.dataManager.fitHeightToWindow() && !is_touch_device() && this.dom.getPageLayoutType() != 'xs') {
                this.flowModeSizer.disableRecalculatingEvents();
                this.frameModeSizer.enableRecalculatingEvents();
            } else {
                this.frameModeSizer.disableRecalculatingEvents();
                this.flowModeSizer.enableRecalculatingEvents();
            }
        },

        doBindEvents: function() {
            this.doBindEventsSizer();

            if (!is_touch_device()) {
                this.splitter.doBindEvents();
            }

            this.ensureModeSizer();

            var that = this;
            if (this.dom.$presentSideNavButton.length > 0) {
                this.dom.$presentSideNavButton.on('click', function (e) {
                    e.preventDefault();
                    that.showNavTopmost();
                });
            }

            $(document).on("pageLayoutChange", function(e, layoutType) {
                if (_.contains(['sm', 'md', 'lg'], layoutType)) {
                    if (that.isNavTopmost()) {
                        that.hideNavTopmost();
                    }

                    if (that.isNavEnabled()) {
                        that.dom.$workZoneSideNav.show();
                    }
                } else if (layoutType === 'xs') {
                    that.dom.$workZoneSideNav.hide();
                }
                that.ensureModeSizer();
                that.recalculateAll();
            });
        },

        doBindEventsSizer: function() {
            var that = this;

            $( document ).on( "newTabSelected.tabs", function(){
                that.recalculateAll();
            });

            $( document ).on( "nodeVisibleChanged", function(){
                that.recalculateAll();
            });

            $( document ).on( "searchCompleteBuildTree", function(){
                that.recalculateAll();
            });

            $(document).on('sideNavTopmostPresent', function() {
                that.recalculateAll();
            })

            $(document).on('sideNavTopmostDismiss', function() {
                that.recalculateAll();
            })

            $( window ).resize(function() {
                clearTimeout( that.timeoutId );
                that.timeoutId = setTimeout( function() {
                    that.recalculateAll();
                }, that.WINDOW_RECALCULATING_DELAY );
            });

        },

        doSetSplitter: function() {
            var that = this;

            this.splitter = DR_EXPLAIN.workZoneSizer_Splitter;
            this.splitter.setOnMouseMoveCallback(function( newWidth ) {
                that.changeWorkZoneSizeOnMouseMove( newWidth );
                that.preferredNavWidth = newWidth;
                that.recalculateAll();
            });
            this.splitter.setOnMouseUpCallback(function() {
                that.recalculateAll();
            });
            this.splitter.init();
        },

        doSetFrameModeSizer: function() {
            this.frameModeSizer = DR_EXPLAIN.workZoneSizer_FrameMode;
            this.frameModeSizer.init();
        },

        doSetFlowModeSizer: function() {
            this.flowModeSizer = DR_EXPLAIN.workZoneSizer_FlowMode;
            this.flowModeSizer.init();
        },

        changeWorkZoneSizeOnMouseMove: function( newWidth ) {
            this.setNewNavWidth( newWidth );
        },

        setNewNavWidth: function( newNavWidth ) {
            var finalNewNavWidth = this.getFinalNewNavWidth( newNavWidth );

            var longestTreeItemWidthWithPaddings = this.visibleTabLongestTreeItemWidth;
            var selectedTab = this.dom.getVisibleTab();
            var tabId = null;
            if (selectedTab)
                tabId = selectedTab.$wrapperItem.prop("id");
            //console.log("setNewNavWidth: this.dom.$hasVerticalScrollbar[" + tabId + "] = " + this.dom.$hasVerticalScrollbar[tabId]);

            if ( this.dom.$hasVerticalScrollbar[tabId] )
                longestTreeItemWidthWithPaddings += $.getScrollbarWidth() * 1;
            var dx = finalNewNavWidth - this.dom.$workZoneSideNav.width();

            var finalTreeWidth = 0;
            if (selectedTab)
            {
                //console.log("setNewNavWidth: " + tabId);
                var $wrapperItem = selectedTab.$wrapperItem;

                finalTreeWidth += $wrapperItem.width();
            }
            finalTreeWidth += dx;
            this.dom.$hasHorizontalScrollbar[tabId] = finalTreeWidth < longestTreeItemWidthWithPaddings;
            //console.log("setNewNavWidth: this.dom.$hasHorizontalScrollbar[" + tabId + "] = " + this.dom.$hasHorizontalScrollbar[tabId]);
            if ( !this.dom.$hasHorizontalScrollbar[tabId] ) {
                this.dom.$treeArr.css( "width", "auto" );
            }
            else {
                this.dom.$treeArr.css({
                    width: this.visibleTabLongestTreeItemWidth + "px"
                });
            }

            this.dom.$workZoneSideNav.css( "width", finalNewNavWidth + "px" );
            this.currNavWidth = finalNewNavWidth;
        },

        getFinalNewNavWidth: function( newNavWidth ) {
            var finalNewNavWidth = newNavWidth;

            if ( newNavWidth > this.maxNavWidth ) {
                finalNewNavWidth = this.maxNavWidth;
            } else if (newNavWidth < this.minNavWidth ) {
                finalNewNavWidth = this.minNavWidth;
            }

            return finalNewNavWidth;
        },

        recalculateVisibleTabLongestTreeItemWidth: function() {
            var $visibleTab = this.dom.getVisibleItemWrapperInner();
            if ($visibleTab) {
                var $tree = $visibleTab.children( "div" );
                var $treeTable = $tree.children( "table" );

                $treeTable.css( "width", "auto" );
                var treeTableWidth = $treeTable.width();
                $treeTable.css( "width", "100%" );
                if (treeTableWidth !== null) {
                    this.visibleTabLongestTreeItemWidth = treeTableWidth;
                } else {
                    this.visibleTabLongestTreeItemWidth = 0;
                }
            } else {
                this.visibleTabLongestTreeItemWidth = 0;
            }
        }
    };

    var API = {
        init: function() {
            _class.init();
        },

        recalculateAll: function() {
            _class.recalculateAll();
        },

        doBindEvents: function() {
            _class.doBindEvents();
        }
    };

    return API;
})();


/*js/drexplain/drexplain.work-zone-sizer.splitter.js*/
DR_EXPLAIN.namespace( 'DR_EXPLAIN.workZoneSizer_Splitter' );

DR_EXPLAIN.workZoneSizer_Splitter = (function(){
    var _class = {
        $splitter: null,
        $resizable: null,
        $body: null,
        splitterOldX: 0,
        timeoutId: null,
        dom: null,
        DELAY: 1,

        onMouseDownCallback: null,
        onMouseMoveCallback: null,
        onMouseUpCallback: null,

        init: function() {
            this.doSetDom();
        },

        doSetDom: function() {
            this.dom = DR_EXPLAIN.dom;
            this.$splitter = this.dom.$splitter;
            this.$resizable = this.dom.$workZoneSideNav;
            this.$body = this.dom.$body;
        },


        doBindEvents: function() {
            var that = this;

            $( this.$splitter ).on( "mousedown.splitter", function( e ){
                that.onMouseDown( e );
            });
        },

        bindMouseEvents: function() {
            var that = this;

            $( document ).on( "mouseup.splitter", function(){
                that.onMouseUp();
            });

            $( document ).on( "mousemove.splitter", function( e ){
                clearTimeout( that.timeoutId );
                that.timeoutId = setTimeout(function(){
                    that.onMouseMove( e );
                }, that.DELAY );
            });
        },

        unbindMouseEvents: function() {
            $( document ).off( ".splitter" );
        },


        onMouseDown: function( e ) {
            this.splitterOldX = e.pageX;
            this._resizableOldWidth = this.$resizable.width();
            this.addCursorIconToBody();
            this.disableSelection();
            this.bindMouseEvents();
        },


        onMouseUp: function() {
            this.removeCursorIconFromBody();
            this.enableSelection();
            this.unbindMouseEvents();
            return this.onMouseUpCallback();
        },

        onMouseMove: function( e ) {
            // IE mouseup check - mouseup happened when mouse was out of window
            if ($.browser.msie && !(document.documentMode >= 9) && !e.button) {
                return this.onMouseUp();
            }

            var delta = e.pageX - this.splitterOldX;
            if (this.dom.isRtl()) {
                delta = -delta;
            }

            var newWidth = this._resizableOldWidth + delta;

            return this.onMouseMoveCallback( newWidth );
        },

        setOnMouseMoveCallback: function( callback ) {
            this.onMouseMoveCallback = callback;
        },

        setOnMouseUpCallback: function( callback ) {
            this.onMouseUpCallback = callback;
        },

        getResizableWidth: function() {
            return parseInt( this.$resizable.css( "width" ), 10 );
        },

        addCursorIconToBody: function() {
            this.$body.css( "cursor", "e-resize" );
        },

        removeCursorIconFromBody: function() {
            this.$body.css( "cursor", "auto" );
        },

        disableSelection: function() {
            this.$body.disableTextSelect();
        },

        enableSelection: function() {
            this.$body.enableTextSelect();
        }
    };

    var API = {
        init: function() {
            _class.init();
        },

        doBindEvents: function() {
            _class.doBindEvents();
        },

        setOnMouseMoveCallback: function( callback ) {
            _class.setOnMouseMoveCallback( callback );
        },

        setOnMouseUpCallback: function( callback ) {
            _class.setOnMouseUpCallback( callback );
        }
    };

    return API;
})();


/*js/drexplain/drexplain.work-zone-sizer.frame-mode.js*/
DR_EXPLAIN.namespace( 'DR_EXPLAIN.workZoneSizer_FrameMode' );
DR_EXPLAIN.workZoneSizer_FrameMode = (function(){
    var _class = {
        dom: null,
        timeoutId: null,
        isRecalculatingEventsEnabled: false,
        recalculateDomNodes: [],
        RESIZE_TIME_INTERVAL: 50,

        init: function() {
            this.doSetDom();
        },

        doSetDom: function( ) {
            this.dom = DR_EXPLAIN.dom;
        },

        doBindEvents: function() {
            this.doBindKeywordContextEvents();
        },

        doBindKeywordContextEvents: function() {
            var that = this;
            this.dom.$keywordContextMenu.on( "show.contextMenu", function(e, $elemInTree ) {
                that.dom.$keywordContextMenu_elemInTree = $elemInTree;
                that.recalculate();
            });

            this.dom.tabs.index.$wrapperItemInner.on( "scroll.contextMenu", function() {
                that.recalculateIndexContextMenu();
            });
        },

        addDomNodeToRecalculate: function( $dom, newValue ) {
            this.recalculateDomNodes.push({
                $dom: $dom,
                value: newValue
            });
        },

        enableRecalculatingEvents: function() {
            this.isRecalculatingEventsEnabled = true;
            this.dom.$html.addClass( this.dom.FRAME_ENABLED_CLASS );
            this.doBindEvents();
        },

        disableRecalculatingEvents: function() {
            this.isRecalculatingEventsEnabled = false;
            $( window ).off( ".contextMenu" );

            this.dom.$html.removeClass( this.dom.FRAME_ENABLED_CLASS );

            this.dom.$workZone.css( "height", "auto" );
            this.dom.$article.css( "height", "auto" );
            this.dom.$articleWrapper.css( "height", "auto" );
            this.dom.$articlePreWrapper.css( "height", "auto" );
            this.dom.$articleInnerWrapper.css( "height", "auto" );
            this.dom.$tabWrapperItemInnerArr.css({ height: "auto", overflow: "auto" });
            this.dom.$treeArr.css( "height", "auto" );
            this.dom.$keywordContextMenu.css( "height", "auto" );
        },

        toggleRecalculatingEvents: function() {
            if ( this.isRecalculatingEventsEnabled ) {
                this.disableRecalculatingEvents();
            }
            else {
                this.enableRecalculatingEvents();
            }
        },

        recalculateIfEnabled: function() {
            if ( this.isRecalculatingEventsEnabled ) {
                this.recalculate();
            }
        },

        recalculate: function() {


            if ( !this.isRecalculatingEventsEnabled ) {
                return false;
            }

            this.recalculateWorkZone();
            this.recalculateArticle();
            this.recalculateNav();
            this.recalculateIndexContextMenu();

            for ( var index = 0; index < this.recalculateDomNodes.length; index += 1 ) {
                var node = this.recalculateDomNodes[ index ];
                if ( typeof( node.value ) === "object" ) {
                    node.$dom.css( node.value );
                }
                else {
                    node.$dom.css( "height", node.value + "px" );
                }
            }

            this.recalculateDomNodes = [];

            //console.log( this.getHeaderHeight() );
        },

        recalculateIndexContextMenu: function() {
            if ( this.dom.$keywordContextMenu_elemInTree === undefined ) {
                return false;
            }
            var $contextMenu = this.dom.$keywordContextMenu;
            if ( !this.dom.isKeywordContextMenuVisible() ) {
                return false;
            }

            $contextMenu.css({ height: "auto", overflow: "visible" });
            var $workZone = this.dom.getVisibleItemWrapperInner();

            var $elemInTree = this.dom.$keywordContextMenu_elemInTree;
            var elemInTreePos = $elemInTree.offset();
            var elemInTreeHeight = $elemInTree.height();
            var elemInTreePosTop = elemInTreePos.top;

            var workZonePos = $workZone.offset();
            var workZoneHeight = $workZone.height();

            var contextMenuHeight = $contextMenu.height();

            if ( ( elemInTreePosTop < workZonePos.top ) || ( elemInTreePosTop > workZonePos.top + workZoneHeight ) ) {
                 this.dom.$keywordContextMenu_elemInTree.trigger( "click" );
                 return false;
                //elemInTreePosTop = workZonePos.top;
    /*          elemInTreePosTop = workZonePos.top;
                elemInTreePosTop = workZonePos.top + workZoneHeight;*/
            }
            else {
                //$contextMenu.show();
            }

            var topSpaceHeight = elemInTreePosTop - workZonePos.top;
            var bottomSpaceHeight = workZoneHeight - topSpaceHeight - elemInTreeHeight;



            var contextMenuNewTop = 0;

            var contextMenuNewLeft = elemInTreePos.left;
            var contextMenuNewRight = $(window).width() - (elemInTreePos.left + $elemInTree.outerWidth());

            var contextMenuNewWidth = "auto";
            var contextMenuNewHeight = "auto";
            var contextMenuNewOverflow = "hidden";

            var isContextMenuBiggerThenBottomSpace = ( contextMenuHeight > bottomSpaceHeight );
            var isContextMenuBiggerThenTopSpace = ( contextMenuHeight > topSpaceHeight );
            var isBottomSpaceBiggerThenTopSpace = ( bottomSpaceHeight > topSpaceHeight );
            var isContextMenuHeightInContainer = ( !isContextMenuBiggerThenBottomSpace && !isContextMenuBiggerThenTopSpace );



            if ( !isContextMenuBiggerThenBottomSpace ) {
                contextMenuNewTop = elemInTreePosTop + elemInTreeHeight;
            }
            else if ( !isContextMenuBiggerThenTopSpace )  {
                contextMenuNewTop = elemInTreePosTop - contextMenuHeight;
            }
            else {
                if ( isBottomSpaceBiggerThenTopSpace ) {
                    contextMenuNewHeight = bottomSpaceHeight;
                    contextMenuNewTop = elemInTreePosTop + elemInTreeHeight;
                }
                else {
                    contextMenuNewHeight = topSpaceHeight;
                    contextMenuNewTop = elemInTreePosTop - contextMenuNewHeight;
                }
                contextMenuNewOverflow = "scroll";
            }


            if ( contextMenuNewHeight !== "auto" ) {
                contextMenuNewHeight += "px";
            }

            var styleOptions = {
                top: contextMenuNewTop  + "px",
                height: contextMenuNewHeight,
                overflow: contextMenuNewOverflow
            };

            if (this.dom.isRtl()) {
                styleOptions.right = contextMenuNewRight + "px";
                styleOptions.padding = "0 0 0 20px";
            } else {
                styleOptions.left = contextMenuNewLeft + "px";
                styleOptions.padding = "0 20px 0 0";
            }

            $contextMenu.css(styleOptions);
    /*
            this.addDomNodeToRecalculate( $contextMenu, {
                top: contextMenuNewTop  + "px",
                left: contextMenuNewLeft + "px",
                height: contextMenuNewHeight,
                overflow: contextMenuNewOverflow,
                padding: contextMenuPadding
            });*/

        },


        recalculateWorkZone: function() {
            var newWorkZoneHeight = $( window ).height() - this.getHeaderHeight() - this.getFooterHeight();
            //this.dom.$workZone.css( "height", newWorkZoneHeight + "px" );
            this.addDomNodeToRecalculate( this.dom.$workZone, newWorkZoneHeight );
        },

        recalculateArticle: function() {
            var newArticleHeight = $( window ).height()
                - ( this.dom.$article.offset() ).top
                - this.dom.getCssNumericValue( this.dom.$workZoneSideArticleContent, "paddingBottom" )
                - this.dom.getCssNumericValue( this.dom.$article, "paddingBottom" )
                - this.dom.getCssNumericValue( this.dom.$article, "paddingTop" )
                - this.getFooterHeight()
                ;

            var newArticleInnerWrapperHeight = $( window ).height()
                - ( this.dom.$articleWrapper.offset() ).top
                - this.dom.getCssNumericValue( this.dom.$articleWrapper, "paddingTop" )
                //- this.dom.getCssNumericValue( this.dom.$articleWrapper, "marginTop" )
                - this.dom.getCssNumericValue( this.dom.$articleWrapper, "paddingBottom" )
                - this.dom.getCssNumericValue( this.dom.$article, "paddingBottom" )
                - this.dom.getCssNumericValue( this.dom.$workZoneSideArticleContent, "paddingBottom" )
                - this.getFooterHeight()
                - 0
                ;

            var newArticleWrapperHeight = newArticleHeight
                - this.dom.$articleHeader.outerHeight( true )
                - this.dom.getCssNumericValue( this.dom.$articleWrapper, "borderTopWidth" )
                - this.dom.getCssNumericValue( this.dom.$articleWrapper, "borderBottomWidth" )
            ;
            newArticleInnerWrapperHeight = newArticleHeight
                + this.dom.getCssNumericValue( this.dom.$articleInnerWrapper, "paddingBottom" )
                ;


    /*      this.dom.$article.css( "height", newArticleHeight + "px" );
            this.dom.$articlePreWrapper.css( "height", newArticleHeight + "px" );
            this.dom.$articleWrapper.css( "height", newArticleWrapperHeight + "px" );*/

            this.addDomNodeToRecalculate( this.dom.$article, newArticleHeight );
            this.addDomNodeToRecalculate( this.dom.$articlePreWrapper, newArticleHeight );
            this.addDomNodeToRecalculate( this.dom.$articleWrapper, newArticleWrapperHeight );

            //console.log( 'article newArticleHeight', newArticleHeight, 'newArticleInnerWrapperHeight', newArticleInnerWrapperHeight );
        },

        recalculateNav: function() {
            var that = this;

            this.recalculateMenuNav();
            this.recalculateIndexNav();
            this.recalculateSearchNav();

            $( document ).trigger( "navResize" );
        },

        recalculateMenuNav: function() {
            this.recalculateNavWithTreeOnly( this.dom.tabs.menu );
        },

        recalculateIndexNav: function() {
            this.recalculateNavWithTreeOnly( this.dom.tabs.index );
        },

        recalculateSearchNav: function() {
            this.recalculateNavWithTreeAndSearchInput( this.dom.tabs.search );
        },

        recalculateNavWithTreeOnly: function( tab ) {
            var workZoneHeight = this.dom.$workZone.height();

            var navOuterPaddingTop = ( this.dom.$tabWrapperItems.offset() ).top;
            var navOuterPaddingBottom = this.dom.getCssNumericValue( this.dom.$workZoneSideNavContent, "paddingBottom" ) + this.getFooterHeight();

            var navInnerPaddingTop = this.dom.getCssNumericValue( tab.$wrapperItem, "paddingTop" );
            var navInnerPaddingBottom = this.dom.getCssNumericValue( tab.$wrapperItem, "paddingBottom" );

            tab.$tree.css( "height", "auto" );
            var realTreeHeight = tab.$tree.height();

            var newTotalNavHeight = $( window ).height()
                - navInnerPaddingTop
                - navInnerPaddingBottom
                - navOuterPaddingBottom
                - navOuterPaddingTop;

            var newNavHeightWithoutHorizontalScrollbar = newTotalNavHeight;
            var tabId = tab.$wrapperItem.prop("id");
            if ( this.dom.$hasHorizontalScrollbar[tabId] )
                newNavHeightWithoutHorizontalScrollbar -= $.getScrollbarWidth() * 1;

            //console.log("recalculateNavWithTreeOnly(" + tabId + "): (realTreeHeight > newNavHeightWithoutHorizontalScrollbar) <=> " + realTreeHeight + " > " + newNavHeightWithoutHorizontalScrollbar);
            this.dom.$hasVerticalScrollbar[tabId] = realTreeHeight > newNavHeightWithoutHorizontalScrollbar;
            //console.log("recalculateNavWithTreeOnly: this.dom.$hasVerticalScrollbar[" + tabId + "] = " + this.dom.$hasVerticalScrollbar[tabId]);
            //console.log("recalculateNavWithTreeOnly: this.dom.$hasHorizontalScrollbar[" + tabId + "] = " + this.dom.$hasHorizontalScrollbar[tabId]);

            if ( !this.dom.$hasVerticalScrollbar[tabId] ) {
                var SCROLL_COMPENSATION = 0;
                if ( this.dom.isIeLessThan9() ) {
                    SCROLL_COMPENSATION += 2;
                }
                //tab.$tree.css( "height", newTotalNavHeight - SCROLL_COMPENSATION + "px" );
                this.addDomNodeToRecalculate( tab.$tree, newNavHeightWithoutHorizontalScrollbar - SCROLL_COMPENSATION );
            }
            else {
                //tab.$wrapperItemInner.css( "overflow", "auto" );
                this.addDomNodeToRecalculate( tab.$wrapperItemInner, { overflow: "auto" });
            }

            //tab.$wrapperItemInner.css( "height", newTotalNavHeight + "px" );
            this.addDomNodeToRecalculate( tab.$wrapperItemInner, newTotalNavHeight );
        },

        recalculateNavWithTreeAndSearchInput: function( tab ) {
            if ( !this.dom.isTabVisible( tab ) ) {
                return false;
            }
            var workZoneHeight = this.dom.$workZone.height();

            var navOuterPaddingTop = ( this.dom.$tabWrapperItems.offset() ).top;
            var navOuterPaddingBottom = this.dom.getCssNumericValue( this.dom.$workZoneSideNavContent, "paddingBottom" ) + this.getFooterHeight();

            var navInnerPaddingTop = this.dom.getCssNumericValue( tab.$wrapperItem, "paddingTop" ) + this.dom.$tabSearchFormWrapper.height() + this.dom.getCssNumericValue( this.dom.$tabSearchFormWrapper, "marginBottom" );
            var navInnerPaddingBottom = this.dom.getCssNumericValue( tab.$wrapperItem, "paddingBottom" );

            tab.$tree.css( "height", "auto" );
            var realTreeHeight = tab.$tree.height();

            var newTotalNavHeight = $( window ).height() - navInnerPaddingTop - navInnerPaddingBottom - navOuterPaddingBottom - navOuterPaddingTop;

            var newNavHeightWithoutHorizontalScrollbar = newTotalNavHeight;
            var tabId = tab.$wrapperItem.prop("id");
            if ( this.dom.$hasHorizontalScrollbar[tabId] )
                newNavHeightWithoutHorizontalScrollbar -= $.getScrollbarWidth() * 1;
            this.dom.$hasVerticalScrollbar[tabId] = realTreeHeight > newNavHeightWithoutHorizontalScrollbar;

            if ( !this.dom.$hasVerticalScrollbar[tabId] ) {
                var SCROLL_COMPENSATION = 0;
                if ( this.dom.isIeLessThan9() ) {
                    SCROLL_COMPENSATION += 2;
                }
                //tab.$tree.css( "height", newTotalNavHeight - SCROLL_COMPENSATION + "px" );
                this.addDomNodeToRecalculate( tab.$tree, newNavHeightWithoutHorizontalScrollbar - SCROLL_COMPENSATION );
            }
            else {
                //tab.$wrapperItemInner.css( "overflow", "auto" );
                this.addDomNodeToRecalculate( tab.$wrapperItemInner, { overflow: "auto" });
            }

            //tab.$wrapperItemInner.css( "height", newTotalNavHeight + "px" );
            this.addDomNodeToRecalculate( tab.$wrapperItemInner, newTotalNavHeight );
        },

        getHeaderHeight: function() {
            if ( this.dom.isPageHeaderVisible() ) {
                return this.dom.$pageContentHeader.height();
            }
            else {
                return 0;
            }
        },

        getFooterHeight: function() {
            if ( this.dom.isPageFooterVisible() ) {
                return this.dom.$pageContentFooter.height();
            }
            else {
                return 0;
            }
        }
    };

    var API = {
        init: function() {
            _class.init();
        },

        enableRecalculatingEvents: function() {
            _class.enableRecalculatingEvents();
        },

        disableRecalculatingEvents: function() {
            _class.disableRecalculatingEvents();
        },

        recalculateIfEnabled: function() {
            _class.recalculateIfEnabled();
        },

        toggleRecalculatingEvents: function() {
            _class.toggleRecalculatingEvents();
        }
    };

    return API;
})();


/*js/drexplain/drexplain.work-zone-sizer.flow-mode.js*/
DR_EXPLAIN.namespace( 'DR_EXPLAIN.workZoneSizer_FlowMode' );
DR_EXPLAIN.workZoneSizer_FlowMode = (function(){
    var _class = {
        dom: null,
        isRecalculatingEventsEnabled: false,

        init: function() {
            this.doSetDom();
        },

        doSetDom: function( ) {
            this.dom = DR_EXPLAIN.dom;
        },

        enableRecalculatingEvents: function() {
            this.isRecalculatingEventsEnabled = true;
        },

        disableRecalculatingEvents: function() {
            this.isRecalculatingEventsEnabled = false;
        },

        recalculateIfEnabled: function() {
            if ( this.isRecalculatingEventsEnabled ) {
                this.recalculate();
            }
        },

        recalculate: function() {
            var article = $("#article");
            var articleOffset = article.offset();
            var articleOuterHeight = article.outerHeight(true);

            var bTabs = $(".b-tabs");
            var bTabsOffset = bTabs.offset();
            var bTabsCurrentLowestPoint = bTabsOffset.top + bTabs.outerHeight(true);

            var articleLowestPointMustBe = bTabsCurrentLowestPoint;
            var articleCurrentLowestPoint = articleOffset.top + articleOuterHeight;
            var articleWrapper = $(".b-article__wrapper");
            var articleMustBeResizedBy = articleLowestPointMustBe - articleCurrentLowestPoint;

            var articleWrapperHeight = articleWrapper.height();
            articleWrapper.css("min-height", Math.max(articleWrapperHeight + articleMustBeResizedBy, 0));
        }
    };

    var API = {
        init: function() {
            _class.init();
        },

        enableRecalculatingEvents: function() {
            _class.enableRecalculatingEvents();
        },

        disableRecalculatingEvents: function() {
            _class.disableRecalculatingEvents();
        },

        recalculateIfEnabled: function() {
            _class.recalculateIfEnabled();
        }
    };

    return API;
})();


/*js/drexplain/nav-tree/drexplain.nav-tree.menu.js*/
DR_EXPLAIN.namespace( 'DR_EXPLAIN.navTree_Menu' );
DR_EXPLAIN.navTree_Menu = (function(){
    var _class = {
    $navTree: null,
    urlEncoder: null,
    dom: null,
    navTreeView: null,
    navArr: null,
    nodeVisibleStatusArr: [],



    init: function() {
        this.doSetDom();
        this.doSetUtils();
        this.doSetUrlEncoder();
        this.doSetDataManager();
        this.doSetNodeVisibleStatusArrByUrlEncoder();

        this.navArr = this.populateTable( this.dataManager.getRootNodesArray(), true);
        var navTreeItemsCollection = this.getNavCollection( this.navArr, null );
        this.navTreeView = navTreeView = new NavTree__View({ collection: navTreeItemsCollection, $navTree: this.$navTree });

        var flatCollection = new NavTree__ItemsNodes_Collection( this.navTreeView.models );
        flatCollection.on(
            "change:isVisible",
            this.onNodeVisibleChange,
            this
        );
    },

    renderNode: function(containerElement, node, model, depth)
    {
        var li = containerElement.appendChild(document.createElement("li"));
        li.className = "b-tree_item";
        var div = li.appendChild(document.createElement("div"));
        div.className = "b-tree__itemContent";
        if (node.isSelected)
            div.className += " m-tree__itemContent__selected";
        div.title = node.title;

        var emptySpacerCount = depth;
        if (node.childs != null)
            --emptySpacerCount;
        for (var i = 0; i < emptySpacerCount; ++i)
            div.appendChild(document.createElement("span")).className = "b-tree__spacer";
              
        if (node.childs != null)
        {
            var bVisible = model.get("isVisible");
            //Create expander
            var spacer = div.appendChild(document.createElement("span"));
            spacer.className = "b-tree__spacer";
            var expanderSpan = spacer.appendChild(document.createElement("span"));
            expanderSpan.className = bVisible ? "b-tree__i_expander_doClose" : "b-tree__i_expander_doOpen";
            
            var expanderImg = expanderSpan.appendChild(document.createElement("span"));
            expanderImg.className = bVisible ? "expander_img b-tree__i_expander_doClose_inner" : "expander_img b-tree__i_expander_doOpen_inner";
            
            //Add folder icon
            spacer = div.appendChild(document.createElement("span"));
            spacer.className = "b-tree__spacer";
            var folderSpan = spacer.appendChild(document.createElement("span"));
            folderSpan.className = bVisible ? "b-tree__i_folder_opened" : "b-tree__i_folder_closed";
            var folderSpanInner = folderSpan.appendChild(document.createElement("span"));
            folderSpanInner.className = bVisible ? "b-tree__i_folder_opened_inner" : "b-tree__i_folder_closed_inner";
            
            //Create ul for inner elements
            var ul = li.appendChild(document.createElement("ul"));
            ul.className = "b-tree__items";
            for (var i = 0; i < node.childs.length; ++i)
                this.renderNode(ul, node.childs[i], model.attributes.childs.models[i], depth + 1);
            node.toggleClasses = function() {
                $(expanderSpan).toggleClass( "b-tree__i_expander_doClose b-tree__i_expander_doOpen" );
                $(expanderImg).toggleClass( "b-tree__i_expander_doClose_inner b-tree__i_expander_doOpen_inner" );

                $(folderSpan).toggleClass( "b-tree__i_folder_opened b-tree__i_folder_closed" );
                $(folderSpanInner).toggleClass( "b-tree__i_folder_opened_inner b-tree__i_folder_closed_inner" );
            };
            node.showExpander = function(e) {
                $(ul).show();
                node.toggleClasses();
                model.set({ "isVisible": 1 });
                $(expanderSpan).unbind("click");
                $(expanderSpan).click(function(e) {
                    node.hideExpander();
                });
            };
            node.hideExpander = function(e) {
                $(ul).hide();
                node.toggleClasses();
                model.set({ "isVisible": 0 });
                $(expanderSpan).unbind("click");
                $(expanderSpan).click(function(e) {
                    node.showExpander();
                });
            };

            $(expanderSpan).click(function(e) {
                if (bVisible)
                    node.hideExpander();
                else
                    node.showExpander();
            });
            if (!bVisible)
            {
                ul.style.display = "none";
                model.set({ "isVisible": 0 });
            }
        }
        else
        {
            //Add article icon
            var spacer = div.appendChild(document.createElement("span"));
            spacer.className = "b-tree__spacer";
            var articleSpan = spacer.appendChild(document.createElement("span"));
            articleSpan.className = "b-tree__i_article";
            var articleInnerSpan = articleSpan.appendChild(document.createElement("span"));
            articleInnerSpan.className = "b-tree__i_article_inner";
        }        
        var itemTextSpan = div.appendChild(document.createElement("span"));
        
        if (node.isSelected)
        {
            itemTextSpan.className = "b-tree__itemText m-tree__itemText__selected";
            itemTextSpan.appendChild(document.createTextNode(node.title));
        }
        else
        {
            itemTextSpan.className = "b-tree__itemText";
            var link = itemTextSpan.appendChild(document.createElement("a"));
            link.className = "b-tree__itemLink";
            link.href = node.link;
            link.appendChild(document.createTextNode(node.title));
        }
    },

    show: function() {
        var $navTree = this.navTreeView.$navTree.find( ".b-tree" );
        $navTree.empty();
        var table = document.createElement("table");
        table.className = "b-tree__layout";
        table.cellSpacing = 0;
        var tr = document.createElement("tr");
        var td = document.createElement("td");
        td.className = "b-tree__layoutSide";

        var ul = document.createElement("ul");
        ul.className = "b-tree__items";
        if (this.navArr !== null)
        {
            for (var i = 0; i < this.navArr.length; ++i)
                this.renderNode(ul, this.navArr[i], this.navTreeView.collection.models[i], 1);
        }

        td.appendChild(ul);
        tr.appendChild(td);
        table.appendChild(tr);
        $navTree[0].appendChild(table);
    },

    doSetDom: function() {
        this.dom = DR_EXPLAIN.dom;
        this.$navTree = this.dom.tabs.menu.$wrapperItem;
    },

    doSetDataManager: function() {
        this.dataManager = DR_EXPLAIN.dataManager;
    },

    doSetUtils: function() {
        this.utils = DR_EXPLAIN.utils;
    },

    doSetUrlEncoder: function() {
        var that = this;

        this.urlEncoder = DR_EXPLAIN.urlEncoder;
        this.urlEncoder.addSaveFunc(
            function() {
                return that.getCurrVisibleStatusArrAsString();
            },
            that.urlEncoder.KEY_NAME__MENU_STATE
        );
    },

    getDefaultNodeVisibleStatusArr: function() {
        var result = new Array( this.dataManager.getNodesCount() );
        if (this.dataManager.getDrexMenuType() == 3 || this.dataManager.getDrexMenuType() == 1)
        {
            for (var i = 0; i < this.dataManager.getDrex().nodes_count; i++)
                result[i] = 1;
        }
        else
        {
            var deep_border = (this.dataManager.getRootNodesArray().length <= 1 ? 1 : 0);
            for (var i = 0; i < this.dataManager.getDrex().nodes_count; i++) {
                result[i] = ( this.dataManager.getNodeDeepByIndex( i ) <= deep_border ? 1 : 0 );
            }

        }
        return result;
    },

    getCurrVisibleStatusArrAsString: function() {
        var menuMinimized = this.getDefaultNodeVisibleStatusArr();
        var VarTOpnd = this.nodeVisibleStatusArr;

        for (var i = 0; i < VarTOpnd.length; i++)
            menuMinimized[i] ^= VarTOpnd[i];

        var bits = new Array();
        for (var i = 0; i < menuMinimized.length; i++)
            bits.push(menuMinimized[i]);


        var bytes = this.utils.bitsToByte(bits, 7);
        bits = new Array();
        for (var i = 0; i < bytes.length; i++)
            if (bytes[i] == 0)
                bits.push(0);
            else
                bits.push(1);


        var result = this.utils.bitsToByte(bits, 7);

        for (var i = 0; i < bytes.length; i++)
            if (bytes[i] != 0)
                result.push(bytes[i]);


        var str = "";
        for (var i = 0; i < result.length; ++i) {
            str += String.fromCharCode(result[i]);
        }

        var menuStateString = str;

        if (menuStateString != "") {
            return menuStateString;
        }
        else {
            return null;
        }
    },

    doSetNodeVisibleStatusArrByUrlEncoder: function() {
        var t = this.urlEncoder.getValueByKey( this.urlEncoder.KEY_NAME__MENU_STATE );
        var VarTOpnd = this.getDefaultNodeVisibleStatusArr();
        if (t !== null )
        {
            var bytes = t;
            bytes = this.utils.str2ar(bytes);
            var bits = this.utils.byteToBits(bytes, 7);

            var prefixLen = this.utils.encodingPrefixLen(VarTOpnd.length, 7);
            var readPos = prefixLen;
            var result = new Array();
            for (var i = 0; i < prefixLen * 8; i++)
                if (bits[i] == 0)
                    result.push(0);
                else
                    result.push(bytes[readPos++]);

            var MyBB = this.utils.byteToBits(result, 7);
            for (var i = 0; i < VarTOpnd.length; ++i)
                VarTOpnd[i] ^= MyBB[i];
        }

        this.nodeVisibleStatusArr = VarTOpnd;
        this.validateOpenState();
    },


    onNodeVisibleChange: function( model, newValue ) {
        this.nodeVisibleStatusArr[ model.get( "nodeIndex" ) ] = newValue;
        if (!DR_EXPLAIN.disableTriggers)
          $( document ).trigger( "nodeVisibleChanged" );

    },

    validateOpenState: function()
    {
        var VarTOpnd = this.nodeVisibleStatusArr;

        var rootNodeIndex = this.dataManager.getIndexByNode( this.dataManager.getRootNode() );
        VarTOpnd[ rootNodeIndex ] = 1;
        if ( !this.dataManager.isSelectedNodeExists() ) {
            return;
        }


        var currentNode = this.dataManager.getSelectedNode().parent();
        while (currentNode)
        {
            VarTOpnd[currentNode.node_index] = 1;
            currentNode = currentNode.parent();
        }

        //console.log( 'validateOpenState:', VarTOpnd );
    },

    populateTable: function( nodeArr, isVisible ) {

        if ( nodeArr.length === 0 ) {
            return null;
        }

        var itemArr = [];

        for ( var index = 0; index < nodeArr.length; index += 1 ) {
            var node = nodeArr[ index ];
            var isOpened = this.nodeVisibleStatusArr[ node.node_index ];
            var isNodeVisible = !!(isVisible && isOpened);

            itemArr.push({
                'title': node.title,
                'link': node.link,
                'nodeIndex': node.node_index,
                'childs': this.populateTable( node.children(), isNodeVisible ),
                'isVisible': isNodeVisible,
                'isSelected': ( node.link === this.dataManager.getPageFilename() )
            });
        }
        return itemArr;
    },

    getNavCollection: function( navArr, parentModel ) {
        if ( navArr === null ) {
            return null;
        }

        var that = this;
        var collection = new NavTree__ItemsNodes_Collection( navArr );
        _.each( collection.models, function( model, index ){
            model.set({
                childs: that.getNavCollection( model.get( "childs" ), model ),
                parent: parentModel
            });
        });
        return collection;
    }
    };

    var API = {
        init: function() {
            _class.init();
        },

        show: function() {
            _class.show();
        }
    };

    return API;
})();


/*js/drexplain/nav-tree/drexplain.nav-tree.index.js*/
DR_EXPLAIN.namespace( 'DR_EXPLAIN.navTree_Index' );
DR_EXPLAIN.navTree_Index = (function(){

    var _class = {
        $navTree: null,
        navTreeView: null,

        init: function() {
            this.doSetDom();
            this.doSetDataManager();

            var navArr = this.populateTable( [this.dataManager.getDrex().root_keyword()] );
            var navTreeItemsCollection = this.getNavCollection( navArr, null );
            this.navTreeView = new NavTree__Keywords_View({ collection: navTreeItemsCollection, $navTree: this.$navTree });
        },

        show: function() {
            this.navTreeView.render();
        },

        doSetDom: function() {
            this.dom = DR_EXPLAIN.dom;
            this.$navTree = this.dom.tabs.index.$wrapperItem;
        },

        doSetDataManager: function() {
            this.dataManager = DR_EXPLAIN.dataManager;
        },

        populateTable: function( keywordArr ) {

            if ( keywordArr.length === 0 ) {
                return null;
            }

            var itemArr = [];

            for ( var index = 0; index < keywordArr.length; index += 1 ) {
                var keyword = keywordArr[ index ];

                if (keyword.isActive())
                {
                    itemArr.push({
                        'title': keyword.title,
                        'keywordIndex': keyword.keyword_index,
                        'childs': this.populateTable( keyword.childrenSorted() ),
                        'links': this.getLinks( keyword )
                    });
                }
                else {
                    var childrenArr = this.populateTable( keyword.childrenSorted() );
                    if (childrenArr !== null)
                        itemArr = itemArr.concat(childrenArr);
                }
            }
            return itemArr;
        },

        getLinks: function( keyword ) {
            var links = keyword.nodes();
            var itemArr = [];
            for (var i = 0; i < links.length; i++) {
                itemArr.push({
                    title: links[i].title,
                    link: links[i].link,
                    nodeIndex: links[i].node_index
                });
            }

            return itemArr;

        },

        getNavCollection: function( navArr, parentModel ) {
            if ( navArr === null ) {
                return null;
            }

            var that = this;
            var collection = new NavTree__ItemsKeywords_Collection( navArr );
            _.each( collection.models, function( model, index ){
                model.set({
                    childs: that.getNavCollection( model.get( "childs" ), model ),
                    links: new NavTree__ItemsNodes_Collection( model.get( "links" ) ),
                    parent: parentModel
                });
            });
            return collection;
        }
    };

    var API = {
        init: function() {
            _class.init();
        },

        show: function() {
            _class.show();
        }
    };

    return API;
})();


/*js/drexplain/nav-tree/drexplain.nav-tree.search.js*/
DR_EXPLAIN.namespace( 'DR_EXPLAIN.navTree_Search' );
DR_EXPLAIN.navTree_Search = (function(){
    var _class = {
        $navTree: null,
        navTreeView: null,


        init: function( ) {
            this.doSetDom();
            this.doSetDataManager();
        },

        setNewContentBySearchResults: function( searchResultsArr ) {
            var navArr = this.getNavArr( searchResultsArr );
            var navTreeItemsCollection = this.getNavCollection( navArr, null );
            var navTreeView = new NavTree__Search_View({ collection: navTreeItemsCollection, $navTree: this.$navTree });
            this.navTreeView = navTreeView;
        },

        show: function() {
            this.navTreeView.render();
        },

        doSetDom: function() {
            this.dom = DR_EXPLAIN.dom;
            this.$navTree = this.dom.tabs.search.$wrapperItem;
        },

        doSetDataManager: function() {
            this.dataManager = DR_EXPLAIN.dataManager;
        },

        getNavCollection: function( navArr, parentModel ) {
            if ( navArr === null ) {
                return null;
            }

            var that = this;
            var collection = new NavTree__ItemsNodes_Collection( navArr );
            _.each( collection.models, function( model, index ){
                model.set({
                    childs: that.getNavCollection( model.get( "childs" ), model ),
                    parent: parentModel
                });
            });
            return collection;
        },

        getNavArr: function( searchResultsArr ) {

            var itemArr = [];

            for ( var index = 0; index < searchResultsArr.length; index++ ) {
                var currNode = searchResultsArr[ index ];
                itemArr.push({
                    'title':  currNode[ 0 ],
                    'link':  currNode[ 1 ],
                    'childs': null,
                    'isSelected': (  currNode[ 1 ] === this.dataManager.getPageFilename() )
                });
            }
            return itemArr;
        }
    };

    var API = {
        init: function() {
            _class.init();
        },

        setNewContentBySearchResults: function( searchResultsArr ) {
            _class.setNewContentBySearchResults( searchResultsArr );
        },

        show: function() {
            _class.show();
        }
    };

    return API;
})();


/*js/app.js*/
function initTabs() {
	var app = DR_EXPLAIN;

    if (app.tabController.tabsCount() == 0)
        return;

    app.navTree_Menu.init();
    app.navTree_Index.init();
    app.navTree_Search.init();

    if (app.tabController.isMenuTabShown())
        app.navTree_Menu.show();
    if (app.tabController.isIndexTabShown())
        app.navTree_Index.show();
}

function onDocumentReady(app) {
    DR_EXPLAIN.disableTriggers = true;
    app.dataManager.init();

    if (app.dataManager.fitHeightToWindow()) {
        $("#pageContentMiddle").removeClass("hidden");
        $("#pageContentFooter").removeClass("hidden");

        if (!is_touch_device()) {
            $("iframe").each(function() {
                $(this).prop("real_src", $(this).prop("src"));
                $(this).prop("src", "about:blank");
            });
        }
    }

    app.dom.init();

    if (app.dataManager.getDrexMenuType() === 1) {
        app.dom.tabs.menu.$wrapperItem.find('.b-tree').addClass('b-tree__withoutControls');
    }

    if (is_touch_device()) {
        app.dom.$workZone.addClass('m-workZone__withoutSplitter');
    }

    app.dom.updatePageLayoutType();

    app.urlEncoder.init();
    app.urlEncoder.doDecodeUrl();

    if (app.dataManager.fitHeightToWindow()) {
        initTabs();
    }

    app.urlEncoder.doBindOpenNextPageWithEncodedStringToLinks();

    app.highlightManager.init();

    app.searchManager.init();
    app.searchManager.runCustomButtons();
    app.searchManager.runInputSync();
    app.searchManager.runInputPlaceholders();

    app.tabController.init();
    app.tabController.doBindEvents();
    app.tabController.doSetTabIndexByUrlEncoder();

    app.workZoneSizer.init();
    app.workZoneSizer.recalculateAll();

    if (!app.dataManager.fitHeightToWindow()) {
        initTabs();
    } else {
        var $hc = $("#hiddenContent");
        $hc.detach();
        $hc.removeClass("hiddenContent");
        $hc.appendTo("#description_on_page_placeholder");
        $("iframe").each(function() {
            $(this).prop("src", $(this).prop("real_src"));
        });
    }
    
    DR_EXPLAIN.disableTriggers = false;

    app.searchManager.doBindEvents();
    app.searchManager.doSearchIfQueryStringNotEmpty();

    app.workZoneSizer.doBindEvents();
    app.workZoneSizer.recalculateAll();

    app.tabController.doSetScrollTopByUrlEncoder();

    if (window.location.hash !== "#")
        window.location.hash = window.location.hash;
}

$(document).ready(function() {
    onDocumentReady(DR_EXPLAIN);
});


/*! https://mths.be/fromcodepoint v0.2.1 by @mathias */
if (!String.fromCodePoint) {
	(function() {
		var defineProperty = (function() {
			// IE 8 only supports `Object.defineProperty` on DOM elements
			try {
				var object = {};
				var fDefineProperty = Object.defineProperty;
				var result = fDefineProperty(object, object, object) && fDefineProperty;
			} catch(error) {}
			return result;
		}());
		var stringFromCharCode = String.fromCharCode;
		var floor = Math.floor;
		var fromCodePoint = function(_) {
			var MAX_SIZE = 0x4000;
			var codeUnits = [];
			var highSurrogate;
			var lowSurrogate;
			var index = -1;
			var length = arguments.length;
			if (!length) {
				return '';
			}
			var result = '';
			while (++index < length) {
				var codePoint = Number(arguments[index]);
				if (
					!isFinite(codePoint) || // `NaN`, `+Infinity`, or `-Infinity`
					codePoint < 0 || // not a valid Unicode code point
					codePoint > 0x10FFFF || // not a valid Unicode code point
					floor(codePoint) != codePoint // not an integer
				) {
					throw RangeError('Invalid code point: ' + codePoint);
				}
				if (codePoint <= 0xFFFF) { // BMP code point
					codeUnits.push(codePoint);
				} else { // Astral code point; split in surrogate halves
					// https://mathiasbynens.be/notes/javascript-encoding#surrogate-formulae
					codePoint -= 0x10000;
					highSurrogate = (codePoint >> 10) + 0xD800;
					lowSurrogate = (codePoint % 0x400) + 0xDC00;
					codeUnits.push(highSurrogate, lowSurrogate);
				}
				if (index + 1 == length || codeUnits.length > MAX_SIZE) {
					result += stringFromCharCode.apply(null, codeUnits);
					codeUnits.length = 0;
				}
			}
			return result;
		};
		if (defineProperty) {
			defineProperty(String, 'fromCodePoint', {
				'value': fromCodePoint,
				'configurable': true,
				'writable': true
			});
		} else {
			String.fromCodePoint = fromCodePoint;
		}
	}());
}


/*! https://mths.be/codepointat v0.2.0 by @mathias */
if (!String.prototype.codePointAt) {
	(function() {
		'use strict'; // needed to support `apply`/`call` with `undefined`/`null`
		var defineProperty = (function() {
			// IE 8 only supports `Object.defineProperty` on DOM elements
			try {
				var object = {};
				var fDefineProperty = Object.defineProperty;
				var result = fDefineProperty(object, object, object) && fDefineProperty;
			} catch(error) {}
			return result;
		}());
		var codePointAt = function(position) {
			if (this == null) {
				throw TypeError();
			}
			var string = String(this);
			var size = string.length;
			// `ToInteger`
			var index = position ? Number(position) : 0;
			if (index != index) { // better `isNaN`
				index = 0;
			}
			// Account for out-of-bounds indices:
			if (index < 0 || index >= size) {
				return undefined;
			}
			// Get the first code unit
			var first = string.charCodeAt(index);
			var second;
			if ( // check if it’s the start of a surrogate pair
				first >= 0xD800 && first <= 0xDBFF && // high surrogate
				size > index + 1 // there is a next code unit
			) {
				second = string.charCodeAt(index + 1);
				if (second >= 0xDC00 && second <= 0xDFFF) { // low surrogate
					// https://mathiasbynens.be/notes/javascript-encoding#surrogate-formulae
					return (first - 0xD800) * 0x400 + second - 0xDC00 + 0x10000;
				}
			}
			return first;
		};
		if (defineProperty) {
			defineProperty(String.prototype, 'codePointAt', {
				'value': codePointAt,
				'configurable': true,
				'writable': true
			});
		} else {
			String.prototype.codePointAt = codePointAt;
		}
	}());
}

