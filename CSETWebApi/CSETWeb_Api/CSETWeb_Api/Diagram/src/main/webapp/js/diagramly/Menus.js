/**
 * Copyright (c) 2006-2017, JGraph Ltd
 * Copyright (c) 2006-2017, Gaudenz Alder
 */
(function()
{
	// Adds scrollbars for menus that exceed the page height
	var mxPopupMenuShowMenu = mxPopupMenu.prototype.showMenu;
	mxPopupMenu.prototype.showMenu = function()
	{
		mxPopupMenuShowMenu.apply(this, arguments);
		
		this.div.style.overflowY = 'auto';
		this.div.style.overflowX = 'hidden';
		var h0 = Math.max(document.body.clientHeight, document.documentElement.clientHeight);
		this.div.style.maxHeight = (h0 - 10) + 'px';
	};
	
	Menus.prototype.createHelpLink = function(href)
	{
		var link = document.createElement('span');
		link.setAttribute('title', mxResources.get('help'));
		link.style.cssText = 'color:blue;text-decoration:underline;margin-left:8px;cursor:help;';
		
		var icon = document.createElement('img');
		mxUtils.setOpacity(icon, 50);
		icon.style.height = '16px';
		icon.style.width = '16px';
		icon.setAttribute('border', '0');
		icon.setAttribute('valign', 'bottom');
		icon.setAttribute('src', Editor.helpImage);
		link.appendChild(icon);
		
		mxEvent.addGestureListeners(link, mxUtils.bind(this, function(evt)
		{
			if (this.editorUi.menubar != null)
			{
				this.editorUi.menubar.hideMenu();
			}
			
			this.editorUi.openLink(href);
			mxEvent.consume(evt);
		}));
		
		return link;
	};

	Menus.prototype.addLinkToItem = function(item, href)
	{
		if (item != null)
		{
			item.firstChild.nextSibling.appendChild(this.createHelpLink(href));
		}
	};

	var menusInit = Menus.prototype.init;
	Menus.prototype.init = function()
	{
		menusInit.apply(this, arguments);
		var editorUi = this.editorUi;
		var graph = editorUi.editor.graph;
		var isGraphEnabled = mxUtils.bind(graph, graph.isEnabled);
		var googleEnabled = ((urlParams['embed'] != '1' && urlParams['gapi'] != '0') ||
				(urlParams['embed'] == '1' && urlParams['gapi'] == '1')) && mxClient.IS_SVG &&
				isLocalStorage && (document.documentMode == null || document.documentMode >= 10);
		var dropboxEnabled = ((urlParams['embed'] != '1' && urlParams['db'] != '0') || (urlParams['embed'] == '1' && urlParams['db'] == '1')) &&
			mxClient.IS_SVG && (document.documentMode == null || document.documentMode > 9);
		var oneDriveEnabled = (window.location.hostname == 'www.draw.io' || window.location.hostname == 'test.draw.io' ||
				window.location.hostname == 'drive.draw.io' || window.location.hostname == 'legacy.draw.io') &&
				(((urlParams['embed'] != '1' && urlParams['od'] != '0') || (urlParams['embed'] == '1' &&
				urlParams['od'] == '1')) && !navigator.userAgent.match(/(iPad|iPhone|iPod)/g) &&
				(navigator.userAgent.indexOf('MSIE') < 0 || document.documentMode >= 10));
		var trelloEnabled = ((urlParams['embed'] != '1' && urlParams['tr'] != '0') || (urlParams['embed'] == '1' && urlParams['tr'] == '1')) &&
			mxClient.IS_SVG && (document.documentMode == null || document.documentMode > 9);

		if (!mxClient.IS_SVG && !editorUi.isOffline())
		{
			var img = new Image();
			img.src = IMAGE_PATH + '/help.png';
		}
		
		editorUi.actions.addAction('new...', function()
		{
			var compact = editorUi.isOffline();
			var dlg = new NewDialog(editorUi, compact);

			editorUi.showDialog(dlg.container, (compact) ? 350 : 620, (compact) ? 70 : 440, true, true, function(cancel)
			{
				if (cancel && editorUi.getCurrentFile() == null)
				{
					editorUi.showSplash();
				}
			});
			
			dlg.init();
		});

		editorUi.actions.put('exportSvg', new Action(mxResources.get('formatSvg') + '...', function()
		{
			editorUi.showExportDialog(mxResources.get('formatSvg'), true, mxResources.get('export'),
				'https://support.draw.io/display/DO/Exporting+Files',
				mxUtils.bind(this, function(scale, transparentBackground, ignoreSelection, addShadow,
					editable, embedImages, border, cropImage, currentPage, linkTarget)
				{
					var val = parseInt(scale);
					
					if (!isNaN(val) && val > 0)
					{
					   	editorUi.exportSvg(val / 100, transparentBackground, ignoreSelection, addShadow,
					   		editable, embedImages, border, !cropImage, currentPage, linkTarget);
					}
				}), true, null, 'svg');
		}));
		
		editorUi.actions.put('insertTemplate', new Action(mxResources.get('template') + '...', function()
		{
			var dlg = new NewDialog(editorUi, null, false, function(xml)
			{
				editorUi.hideDialog();
				
				if (xml != null)
				{
					var insertPoint = editorUi.editor.graph.getFreeInsertPoint();
					graph.setSelectionCells(editorUi.importXml(xml,
						Math.max(insertPoint.x, 20),
						Math.max(insertPoint.y, 20), true));
					graph.scrollCellToVisible(graph.getSelectionCell());
				}
			}, null, null, null, null, null, null, null, null, null, null,
				false, mxResources.get('insert'));

			editorUi.showDialog(dlg.container, 620, 440, true, true);
		})).isEnabled = isGraphEnabled;
		
		editorUi.actions.put('exportXml', new Action(mxResources.get('formatXml') + '...', function()
		{
			var div = document.createElement('div');
			div.style.whiteSpace = 'nowrap';
			var noPages = editorUi.pages == null || editorUi.pages.length <= 1;
			
			var hd = document.createElement('h3');
			mxUtils.write(hd, mxResources.get('formatXml'));
			hd.style.cssText = 'width:100%;text-align:center;margin-top:0px;margin-bottom:4px';
			div.appendChild(hd);
			
			var selection = editorUi.addCheckbox(div, mxResources.get('selectionOnly'),
				false, graph.isSelectionEmpty());
			var pages = editorUi.addCheckbox(div, mxResources.get((noPages) ? 'compressed' : 'allPages'), true);
			pages.style.marginBottom = '16px';
			
			mxEvent.addListener(selection, 'change', function()
			{
				if (selection.checked)
				{
					pages.setAttribute('disabled', 'disabled');
				}
				else
				{
					pages.removeAttribute('disabled');
				}
			});
			
			var dlg = new CustomDialog(editorUi, div, mxUtils.bind(this, function()
			{
				editorUi.downloadFile('xml', (noPages) ? !pages.checked : null, null,
					!selection.checked, (!noPages) ? !pages.checked : null);
			}), null, mxResources.get('export'));
			
			editorUi.showDialog(dlg.container, 300, 146, true, true);
		}));
		
		editorUi.actions.put('exportUrl', new Action(mxResources.get('url') + '...', function()
		{
			editorUi.showPublishLinkDialog(mxResources.get('url'), true, null, null,
				function(linkTarget, linkColor, allPages, lightbox, editLink, layers)
			{
				var dlg = new EmbedDialog(editorUi, editorUi.createLink(linkTarget,
					linkColor, allPages, lightbox, editLink, layers, null, true));
				editorUi.showDialog(dlg.container, 440, 240, true, true);
				dlg.init();
			});
		}));
		
		editorUi.actions.put('exportHtml', new Action(mxResources.get('formatHtmlEmbedded') + '...', function()
		{
			if (editorUi.spinner.spin(document.body, mxResources.get('loading')))
			{
				editorUi.getPublicUrl(editorUi.getCurrentFile(), function(url)
				{
					editorUi.spinner.stop();
					
					editorUi.showHtmlDialog(mxResources.get('export'), null, url, function(publicUrl, zoomEnabled,
						initialZoom, linkTarget, linkColor, fit, allPages, layers, lightbox, editLink)
					{
						editorUi.createHtml(publicUrl, zoomEnabled, initialZoom, linkTarget, linkColor,
							fit, allPages, layers, lightbox, editLink, mxUtils.bind(this, function(html, scriptTag)
							{
								var basename = editorUi.getBaseFilename(allPages);
								var result = '<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=5,IE=9" ><![endif]-->\n' +
									'<!DOCTYPE html>\n<html>\n<head>\n<title>' + mxUtils.htmlEntities(basename) + '</title>\n' +
									'<meta charset="utf-8"/>\n</head>\n<body>' + html + '\n' + scriptTag + '\n</body>\n</html>';
								editorUi.saveData(basename + '.html', 'html', result, 'text/html');
							}));
					});
				});
			}
		}));
		
		editorUi.actions.put('exportPdf', new Action(mxResources.get('formatPdf') + '...', function()
		{
			if (editorUi.isOffline() || editorUi.printPdfExport)
			{
				// Export PDF action for chrome OS (same as print with different dialog title)
				editorUi.showDialog(new PrintDialog(editorUi, mxResources.get('formatPdf')).container, 360,
						(editorUi.pages != null && editorUi.pages.length > 1) ?
						420 : 360, true, true);
			}
			else
			{
				var noPages = editorUi.pages == null || editorUi.pages.length <= 1;
				var div = document.createElement('div');
				div.style.whiteSpace = 'nowrap';
				
				var hd = document.createElement('h3');
				mxUtils.write(hd, mxResources.get('formatPdf'));
				hd.style.cssText = 'width:100%;text-align:center;margin-top:0px;margin-bottom:4px';
				div.appendChild(hd);
				
				var cropEnableFn = function()
				{
					if (allPages != this && this.checked)
					{
						crop.removeAttribute('disabled');
					}
					else
					{
						crop.setAttribute('disabled', 'disabled');
						crop.checked = false;
					}
				};
				
				var dlgH = 146;
				
				if (editorUi.pdfPageExport && !noPages)
				{
					var allPages = editorUi.addRadiobox(div, 'pages', mxResources.get('allPages'), true);
					var currentPage = editorUi.addRadiobox(div, 'pages', mxResources.get('currentPage', null, 'Current Page'), false);
					var selection = editorUi.addRadiobox(div, 'pages', mxResources.get('selectionOnly'), false, graph.isSelectionEmpty());
					var crop = editorUi.addCheckbox(div, mxResources.get('crop'), false, true);
					
					mxEvent.addListener(allPages, 'change', cropEnableFn);
					mxEvent.addListener(currentPage, 'change', cropEnableFn);
					mxEvent.addListener(selection, 'change', cropEnableFn);
					dlgH = 205;
				}
				else
				{
					var selection = editorUi.addCheckbox(div, mxResources.get('selectionOnly'),
							false, graph.isSelectionEmpty());
					var crop = editorUi.addCheckbox(div, mxResources.get('crop'),
							!graph.pageVisible || !editorUi.pdfPageExport,
							!editorUi.pdfPageExport);
					
					// Crop is only enabled if selection only is selected
					if (!editorUi.pdfPageExport)
					{
						mxEvent.addListener(selection, 'change', cropEnableFn);	
					}
				}
				
				var dlg = new CustomDialog(editorUi, div, mxUtils.bind(this, function()
				{
					editorUi.downloadFile('pdf', null, null, !selection.checked, noPages? true : !allPages.checked, !crop.checked);
				}), null, mxResources.get('export'));
				editorUi.showDialog(dlg.container, 300, dlgH, true, true);
			}
		}));
		
		editorUi.actions.addAction('open...', function()
		{
			editorUi.pickFile();
		});
		
		editorUi.actions.addAction('close', function()
		{
			var currentFile = editorUi.getCurrentFile();
			
			function fn()
			{
				editorUi.fileLoaded(null);
			};
			
			if (currentFile != null && currentFile.isModified())
			{
				editorUi.confirm(mxResources.get('allChangesLost'), null, fn,
					mxResources.get('cancel'), mxResources.get('discardChanges'));
			}
			else
			{
				fn();
			}
		});
		
		editorUi.actions.addAction('editShape...', mxUtils.bind(this, function()
		{
			var cells = graph.getSelectionCells();
			
			if (graph.getSelectionCount() == 1)
			{
				var cell = graph.getSelectionCell();
				var state = graph.view.getState(cell);
				
				if (state != null && state.shape != null && state.shape.stencil != null)
				{
			    	var dlg = new EditShapeDialog(editorUi, cell, mxResources.get('editShape') + ':', 630, 400);
					editorUi.showDialog(dlg.container, 640, 480, true, false);
					dlg.init();
				}
			}
		}));
		
		editorUi.actions.addAction('revisionHistory...', function()
		{
			if (!editorUi.isRevisionHistorySupported())
			{
				editorUi.showError(mxResources.get('error'), mxResources.get('notAvailable'), mxResources.get('ok'));
			}
			else if (editorUi.spinner.spin(document.body, mxResources.get('loading')))
			{
				editorUi.getRevisions(mxUtils.bind(this, function(revs, restoreFn)
				{
					editorUi.spinner.stop();
					var dlg = new RevisionDialog(editorUi, revs, restoreFn);
					editorUi.showDialog(dlg.container, 640, 480, true, true);
					dlg.init();
				}), mxUtils.bind(this, function(err)
				{
					editorUi.handleError(err);
				}));
			}
		});
		
		editorUi.actions.addAction('createRevision', function()
		{
			editorUi.actions.get('save').funct();
		}, null, null, Editor.ctrlKey + '+S');
		
		var action = editorUi.actions.addAction('synchronize', function()
		{
			editorUi.synchronizeCurrentFile(DrawioFile.SYNC == 'none');
		}, null, null, 'Alt+Shift+S');
		
		// Changes the label if synchronization is disabled
		if (DrawioFile.SYNC == 'none')
		{
			action.label = mxResources.get('refresh');
		}

		editorUi.actions.addAction('upload...', function()
		{
			var file = editorUi.getCurrentFile();
			
			if (file != null)
			{
				// Data is pulled from global variable after tab loads
				// LATER: Change to use message passing to deal with potential cross-domain
				window.drawdata = editorUi.getFileData();
				var filename = (file.getTitle() != null) ? file.getTitle() : editorUi.defaultFilename;
				editorUi.openLink(window.location.protocol + '//' + window.location.host + '/?create=drawdata&' +
						((editorUi.mode == App.MODE_DROPBOX) ? 'mode=dropbox&' : '') +
						'title=' + encodeURIComponent(filename), null, true);
			}
		});

		if (typeof(MathJax) !== 'undefined')
		{
			var action = editorUi.actions.addAction('mathematicalTypesetting', function()
			{
				var change = new ChangePageSetup(editorUi);
				change.ignoreColor = true;
				change.ignoreImage = true;
				change.mathEnabled = !editorUi.isMathEnabled();
				
				graph.model.execute(change);
			});
			
			action.setToggleAction(true);
			action.setSelectedCallback(function() { return editorUi.isMathEnabled(); });
			action.isEnabled = isGraphEnabled;
		}
		
		if (isLocalStorage || mxClient.IS_CHROMEAPP)
		{
			var action = editorUi.actions.addAction('showStartScreen', function()
			{
				mxSettings.setShowStartScreen(!mxSettings.getShowStartScreen());
				mxSettings.save();
			});
			
			action.setToggleAction(true);
			action.setSelectedCallback(function() { return mxSettings.getShowStartScreen(); });
		}

		var autosaveAction = editorUi.actions.addAction('autosave', function()
		{
			editorUi.editor.setAutosave(!editorUi.editor.autosave);
		});
		
		autosaveAction.setToggleAction(true);
		autosaveAction.setSelectedCallback(function()
		{
			return autosaveAction.isEnabled() && editorUi.editor.autosave;
		});

		editorUi.actions.addAction('editGeometry...', function()
		{
			var cells = graph.getSelectionCells();
			var vertices = [];
			
			for (var i = 0; i < cells.length; i++)
			{
				if (graph.getModel().isVertex(cells[i]))
				{
					vertices.push(cells[i]);
				}
			}
			
			if (vertices.length > 0)
			{
				var dlg = new EditGeometryDialog(editorUi, vertices);
				editorUi.showDialog(dlg.container, 200, 250, true, true);
				dlg.init();
			}
		}, null, null, Editor.ctrlKey + '+Shift+M');

		var copiedStyles = ['rounded', 'shadow', 'dashed', 'dashPattern', 'fontFamily', 'fontSize', 'fontColor', 'fontStyle',
			 				'align', 'verticalAlign', 'strokeColor', 'strokeWidth', 'fillColor', 'gradientColor', 'swimlaneFillColor',
		                    'textOpacity', 'gradientDirection', 'glass', 'labelBackgroundColor', 'labelBorderColor', 'opacity',
		                    'spacing', 'spacingTop', 'spacingLeft', 'spacingBottom', 'spacingRight', 'endFill', 'endArrow',
		                    'endSize', 'targetPerimeterSpacing', 'startFill', 'startArrow', 'startSize', 'sourcePerimeterSpacing',
		                    'arcSize'];
		
		editorUi.actions.addAction('copyStyle', function()
		{
			var state = graph.view.getState(graph.getSelectionCell());
			
			if (graph.isEnabled() && state != null)
			{
				editorUi.copiedStyle = mxUtils.clone(state.style);
				
				// Handles special case for value "none"
				var cellStyle = graph.getModel().getStyle(state.cell);
				var tokens = (cellStyle != null) ? cellStyle.split(';') : [];
				
				for (var j = 0; j < tokens.length; j++)
				{
					var tmp = tokens[j];
			 		var pos = tmp.indexOf('=');
			 					 		
			 		if (pos >= 0)
			 		{
			 			var key = tmp.substring(0, pos);
			 			var value = tmp.substring(pos + 1);
			 			
			 			if (editorUi.copiedStyle[key] == null && value == 'none')
			 			{
			 				editorUi.copiedStyle[key] = 'none';
			 			}
			 		}
				}
			}
		}, null, null, Editor.ctrlKey + '+Shift+C');

		editorUi.actions.addAction('pasteStyle', function()
		{
			if (graph.isEnabled() && !graph.isSelectionEmpty() && editorUi.copiedStyle != null)
			{
				graph.getModel().beginUpdate();
				
				try
				{
					var cells = graph.getSelectionCells();
					
					for (var i = 0; i < cells.length; i++)
					{
						var state = graph.view.getState(cells[i]);
						
						for (var j = 0; j < copiedStyles.length; j++)
						{
							var key = copiedStyles[j];
							var value = editorUi.copiedStyle[key];
							
							if (state.style[key] != value)
							{
								graph.setCellStyles(key, value, [cells[i]]);
							}
						}
					}
				}
				finally
				{
					graph.getModel().endUpdate();
				}
			}
		}, null, null, Editor.ctrlKey + '+Shift+V');
		
		editorUi.actions.put('pageBackgroundImage', new Action(mxResources.get('backgroundImage') + '...', function()
		{
			if (!editorUi.isOffline())
			{
				var apply = function(image)
				{
					editorUi.setBackgroundImage(image);
				};
	
				var dlg = new BackgroundImageDialog(editorUi, apply);
				editorUi.showDialog(dlg.container, 320, 170, true, true);
				dlg.init();
			}
		}));
		
		editorUi.actions.put('exportPng', new Action(mxResources.get('formatPng') + '...', function()
		{
			if (editorUi.isExportToCanvas())
			{
				editorUi.showExportDialog(mxResources.get('image'), false, mxResources.get('export'),
					'https://support.draw.io/display/DO/Exporting+Files',
					mxUtils.bind(this, function(scale, transparentBackground, ignoreSelection,
						addShadow, editable, embedImages, border, cropImage, currentPage)
					{
						var val = parseInt(scale);
						
						if (!isNaN(val) && val > 0)
						{
						   	editorUi.exportImage(val / 100, transparentBackground, ignoreSelection,
						   		addShadow, editable, border, !cropImage, currentPage);
						}
					}), true, true, 'png');
			}
			else if (!editorUi.isOffline() && (!mxClient.IS_IOS || !navigator.standalone))
			{
				editorUi.showRemoteExportDialog(mxResources.get('export'), null, mxUtils.bind(this, function(ignoreSelection, editable, transparent)
				{
					editorUi.downloadFile((editable) ? 'xmlpng' : 'png', null, null, ignoreSelection, null, null, transparent);
				}));
			}
		}));
		
		editorUi.actions.put('exportJpg', new Action(mxResources.get('formatJpg') + '...', function()
		{
			if (editorUi.isExportToCanvas())
			{
				editorUi.showExportDialog(mxResources.get('image'), false, mxResources.get('export'),
					'https://support.draw.io/display/DO/Exporting+Files',
					mxUtils.bind(this, function(scale, transparentBackground, ignoreSelection,
						addShadow, editable, embedImages, border, cropImage, currentPage)
					{
						var val = parseInt(scale);
						
						if (!isNaN(val) && val > 0)
						{
							editorUi.exportImage(val / 100, false, ignoreSelection,
							   	addShadow, false, border, !cropImage, false, 'jpeg');
						}
					}), true, false, 'jpeg');
			}
			else if (!editorUi.isOffline() && (!mxClient.IS_IOS || !navigator.standalone))
			{
				editorUi.showRemoteExportDialog(mxResources.get('export'), null, mxUtils.bind(this, function(ignoreSelection, editable)
				{
					editorUi.downloadFile('jpeg', null, null, ignoreSelection);
				}), true);
			}
		}));
		
		action = editorUi.actions.put('shadowVisible', new Action(mxResources.get('shadow'), function()
		{
			graph.setShadowVisible(!graph.shadowVisible);
		}));
		action.setToggleAction(true);
		action.setSelectedCallback(function() { return graph.shadowVisible; });

		var showingAbout = false;
		
		editorUi.actions.put('about', new Action(mxResources.get('aboutDrawio') + '...', function()
		{
			if (!showingAbout)
			{
				editorUi.showDialog(new AboutDialog(editorUi).container, 220, 300, true, true, function()
				{
					showingAbout = false;
				});
				
				showingAbout = true;
			}
			
		}, null, null, 'F1'));
		
		editorUi.actions.addAction('userManual...', function()
		{
			editorUi.openLink('https://support.draw.io/display/DO/Draw.io+Online+User+Manual');
		});

		editorUi.actions.addAction('support...', function()
		{
			editorUi.openLink('https://about.draw.io/support/');
		});

		editorUi.actions.addAction('exportOptionsDisabled...', function()
		{
			editorUi.handleError({message: mxResources.get('exportOptionsDisabledDetails')},
				mxResources.get('exportOptionsDisabled'));
		});

		editorUi.actions.addAction('keyboardShortcuts...', function()
		{
			if (mxClient.IS_CHROMEAPP || EditorUi.isElectronApp)
			{
				editorUi.openLink('https://www.draw.io/shortcuts.svg');
			}
			else if (mxClient.IS_SVG)
			{
				editorUi.openLink('shortcuts.svg');
			}
			else
			{
				editorUi.openLink('https://www.draw.io/?lightbox=1#Uhttps%3A%2F%2Fwww.draw.io%2Fshortcuts.svg');
			}
		});

		editorUi.actions.addAction('feedback...', function()
		{
			var dlg = new FeedbackDialog(editorUi);
			editorUi.showDialog(dlg.container, 610, 360, true, true);
			dlg.init();
		});

		editorUi.actions.addAction('quickStart...', function()
		{
			editorUi.openLink('https://www.youtube.com/watch?v=Z0D96ZikMkc');
		});
		
		action = editorUi.actions.addAction('tags...', mxUtils.bind(this, function()
		{
			if (this.tagsWindow == null)
			{
				this.tagsWindow = new TagsWindow(editorUi, document.body.offsetWidth - 380, 230, 300, 120);
				this.tagsWindow.window.addListener('show', function()
				{
					editorUi.fireEvent(new mxEventObject('tags'));
				});
				this.tagsWindow.window.addListener('hide', function()
				{
					editorUi.fireEvent(new mxEventObject('tags'));
				});
				this.tagsWindow.window.setVisible(true);
				editorUi.fireEvent(new mxEventObject('tags'));
			}
			else
			{
				this.tagsWindow.window.setVisible(!this.tagsWindow.window.isVisible());
			}
		}));
		action.setToggleAction(true);
		action.setSelectedCallback(mxUtils.bind(this, function() { return this.tagsWindow != null && this.tagsWindow.window.isVisible(); }));
		
		action = editorUi.actions.addAction('find...', mxUtils.bind(this, function()
		{
			if (this.findWindow == null)
			{
				this.findWindow = new FindWindow(editorUi, document.body.offsetWidth - 300, 110, 240, 140);
				this.findWindow.window.addListener('show', function()
				{
					editorUi.fireEvent(new mxEventObject('find'));
				});
				this.findWindow.window.addListener('hide', function()
				{
					editorUi.fireEvent(new mxEventObject('find'));
				});
				this.findWindow.window.setVisible(true);
				editorUi.fireEvent(new mxEventObject('find'));
			}
			else
			{
				this.findWindow.window.setVisible(!this.findWindow.window.isVisible());
			}
		}));
		action.setToggleAction(true);
		action.setSelectedCallback(mxUtils.bind(this, function() { return this.findWindow != null && this.findWindow.window.isVisible(); }));
		
		editorUi.actions.put('exportVsdx', new Action(mxResources.get('formatVsdx') + ' (beta)...', function()
		{
			editorUi.exportVisio();
		}));
		
		// Adds language menu to options only if localStorage is available for
		// storing the choice. We do not want to use cookies for older browsers.
		// Note that the URL param lang=XX is available for setting the language
		// in older browsers. URL param has precedence over the saved setting.
		if (mxClient.IS_CHROMEAPP || (isLocalStorage && urlParams['offline'] != '1'))
		{
			this.put('language', new Menu(mxUtils.bind(this, function(menu, parent)
			{
				var addLangItem = mxUtils.bind(this, function (id)
				{
					var lang = (id == '') ? mxResources.get('automatic') : mxLanguageMap[id];
					var item = null;
					
					if (lang != '')
					{
						item = menu.addItem(lang, null, mxUtils.bind(this, function()
						{
							mxSettings.setLanguage(id);
							mxSettings.save();
							
							// Shows dialog in new language
							mxClient.language = id;
							mxResources.loadDefaultBundle = false;
							mxResources.add(RESOURCE_BASE);
							
							editorUi.alert(mxResources.get('restartForChangeRequired'));
						}), parent);
						
						if (id == mxLanguage || (id == '' && mxLanguage == null))
						{
							menu.addCheckmark(item, Editor.checkmarkImage);
						}
					}
					
					return item;
				});
				
				var item = addLangItem('');
				menu.addSeparator(parent);

				// LATER: Sort menu by language name
				for(var langId in mxLanguageMap) 
				{
					addLangItem(langId);
				}
			})));

			// Extends the menubar with the language menu
			var menusCreateMenuBar = Menus.prototype.createMenubar;
			Menus.prototype.createMenubar = function(container)
			{
				var menubar = menusCreateMenuBar.apply(this, arguments);
				
				if (menubar != null)
				{
					var langMenu = this.get('language');
					
					if (langMenu != null)
					{
						var elt = menubar.addMenu('', langMenu.funct);
						elt.setAttribute('title', mxResources.get('language'));
						elt.style.width = '16px';
						elt.style.paddingTop = '2px';
						elt.style.paddingLeft = '4px';
						elt.style.zIndex = '1';
						elt.style.position = 'absolute';
						elt.style.display = 'block';
						elt.style.cursor = 'pointer';
						elt.style.right = '17px';
						
						if (uiTheme == 'atlas')
						{
							elt.style.top = '6px';
							elt.style.right = '15px';
						}
						else if (uiTheme == 'min')
						{
							elt.style.top = '2px';
						}
						else
						{
							elt.style.top = '0px';
						}
						
						if (!mxClient.IS_VML)
						{
							var icon = document.createElement('div');
							icon.style.backgroundImage = 'url(' + Editor.globeImage + ')';
							icon.style.backgroundPosition = 'center center';
							icon.style.backgroundRepeat = 'no-repeat';
							icon.style.backgroundSize = '19px 19px';
							icon.style.position = 'absolute';
							icon.style.height = '19px';
							icon.style.width = '19px';
							icon.style.marginTop = '2px';
							icon.style.zIndex = '1';
							elt.appendChild(icon);
							mxUtils.setOpacity(elt, 40);
							
							if (uiTheme == 'atlas' || uiTheme == 'dark')
							{
								elt.style.opacity = '0.85';
								elt.style.filter = 'invert(100%)';
							}
						}
						else
						{
							elt.innerHTML = '<div class="geIcon geSprite geSprite-globe"/>';
						}
						
						document.body.appendChild(elt);
					}
				}

				return menubar;
			};
		}
		
		editorUi.customLayoutConfig = [{'layout': 'mxHierarchicalLayout',
			'config':
			{'orientation': 'west',
			'intraCellSpacing': 30,
			'interRankCellSpacing': 100,
			'interHierarchySpacing': 60,
			'parallelEdgeSpacing': 10}}];
		
		// Adds action
		editorUi.actions.addAction('runLayout', function()
		{
	    	var dlg = new TextareaDialog(editorUi, 'Run Layouts:',
	    		JSON.stringify(editorUi.customLayoutConfig, null, 2),
	    		function(newValue)
			{
				if (newValue.length > 0)
				{
					try
					{
						var layoutList = JSON.parse(newValue);
						editorUi.executeLayoutList(layoutList)
						editorUi.customLayoutConfig = layoutList;
					}
					catch (e)
					{
						editorUi.handleError(e);
						console.error(e);
					}
				}
			});
	    	
	    	dlg.textarea.style.width = '600px';
	    	dlg.textarea.style.height = '380px';
			editorUi.showDialog(dlg.container, 620, 460, true, true);
			dlg.init();
		});
		
		var layoutMenu = this.get('layout');
		var layoutMenuFunct = layoutMenu.funct;
		
		layoutMenu.funct = function(menu, parent)
		{
			layoutMenuFunct.apply(this, arguments);
			
			menu.addSeparator(parent);
			editorUi.menus.addMenuItem(menu, 'runLayout', parent, null, null, mxResources.get('apply') + '...');
		};
		
		this.put('help', new Menu(mxUtils.bind(this, function(menu, parent)
		{
			if (!mxClient.IS_CHROMEAPP && editorUi.isOffline())
			{
				this.addMenuItems(menu, ['about'], parent);
			}
			else
			{
				// No translation for menu item since help is english only
				var item = menu.addItem('Search:', null, null, parent, null, null, false);
				item.style.backgroundColor = (uiTheme == 'dark') ? '#505759' : 'whiteSmoke';
				item.style.cursor = 'default';
				
				var input = document.createElement('input');
				input.setAttribute('type', 'text');
				input.setAttribute('size', '25');
				input.style.marginLeft = '8px';

				mxEvent.addListener(input, 'keydown', mxUtils.bind(this, function(e)
				{
					var term = mxUtils.trim(input.value);
					
					if (e.keyCode == 13 && term.length > 0)
					{
						this.editorUi.openLink('https://desk.draw.io/support/search/solutions?term=' +
							encodeURIComponent(term));
						input.value = '';
						EditorUi.logEvent({category: 'SEARCH-HELP', action: 'search', label: term});
						
						if (this.editorUi.menubar != null)
						{
							window.setTimeout(mxUtils.bind(this, function()
							{
								this.editorUi.menubar.hideMenu();
							}), 0);
						}
					}
	                else if (e.keyCode == 27)
	                {
	                    input.value = '';
	                }
				}));
				
				item.firstChild.nextSibling.appendChild(input);
				
				mxEvent.addGestureListeners(input, function(evt)
				{
					if (document.activeElement != input)
					{
						input.focus();
					}
					
					mxEvent.consume(evt);
				}, function(evt)
				{
					mxEvent.consume(evt);
				}, function(evt)
				{
					mxEvent.consume(evt);
				});
				
				window.setTimeout(function()
				{
					input.focus();
				}, 0);
				
				this.addMenuItems(menu, ['-', 'quickStart', 'userManual', 'keyboardShortcuts', '-'], parent);
				
				if (!mxClient.IS_CHROMEAPP)
				{
					this.addMenuItems(menu, ['feedback'], parent);
				}

				this.addMenuItems(menu, ['support', '-'], parent);
				
				if (!EditorUi.isElectronApp && !navigator.standalone && urlParams['embed'] != '1')
				{
					this.addMenuItems(menu, ['downloadDesktop'], parent);
				}
				
				if (!navigator.standalone && urlParams['embed'] != '1')
				{
					this.addMenuItems(menu, ['useOffline'], parent);
				}
				
				this.addMenuItems(menu, ['-', 'about'], parent);
			}
			
			if (urlParams['test'] == '1')
			{
				menu.addSeparator(parent);
				this.addSubmenu('testDevelop', menu, parent);
			}
			
			if (urlParams['ruler'] == '1')
			{
				mxResources.parse('rulerInch=Ruler unit: Inches');

				editorUi.actions.addAction('rulerInch', mxUtils.bind(this, function()
				{
					editorUi.vRuler.setUnit(mxRuler.prototype.INCHES);
					editorUi.hRuler.setUnit(mxRuler.prototype.INCHES);
					editorUi.vRuler.drawRuler(true);
					editorUi.hRuler.drawRuler(true);
				}));

				mxResources.parse('rulerCM=Ruler unit: CMs');

				editorUi.actions.addAction('rulerCM', mxUtils.bind(this, function()
				{
					editorUi.vRuler.setUnit(mxRuler.prototype.CENTIMETER);
					editorUi.hRuler.setUnit(mxRuler.prototype.CENTIMETER);
					editorUi.vRuler.drawRuler(true);
					editorUi.hRuler.drawRuler(true);
				}));

				mxResources.parse('rulerPixel=Ruler unit: Pixels');

				editorUi.actions.addAction('rulerPixel', mxUtils.bind(this, function()
				{
					editorUi.vRuler.setUnit(mxRuler.prototype.PIXELS);
					editorUi.hRuler.setUnit(mxRuler.prototype.PIXELS);
					editorUi.vRuler.drawRuler(true);
					editorUi.hRuler.drawRuler(true);
				}));

				this.addMenuItems(menu, ['-', 'rulerInch', 'rulerCM', 'rulerPixel'], parent);
			}
		})));
		
		// Only visible in test mode
		if (urlParams['test'] == '1')
		{
			mxResources.parse('testDevelop=Develop');
			mxResources.parse('showBoundingBox=Show bounding box');
			mxResources.parse('createSidebarEntry=Create Sidebar Entry');
			mxResources.parse('testCheckFile=Check File');
			mxResources.parse('testDiff=Diff');
			mxResources.parse('testInspect=Inspect');
			mxResources.parse('testShowConsole=Show Console');
			mxResources.parse('testXmlImageExport=XML Image Export');
			mxResources.parse('testDownloadRtModel=Export RT model');
			mxResources.parse('testImportRtModel=Import RT model');

			editorUi.actions.addAction('createSidebarEntry', mxUtils.bind(this, function()
			{
				if (!graph.isSelectionEmpty())
				{
					editorUi.showTextDialog('Create Sidebar Entry', 'sb.createVertexTemplateFromData(\'' +
						Graph.compress(mxUtils.getXml(graph.encodeCells(graph.getSelectionCells()))) +
						'\', width, height, \'Title\');');
				}
			}));
	
			editorUi.actions.addAction('showBoundingBox', mxUtils.bind(this, function()
			{
				var b = graph.getGraphBounds();
				var tr = graph.view.translate;
				var s = graph.view.scale;
				graph.insertVertex(graph.getDefaultParent(), null, '',
					b.x / s - tr.x, b.y / s - tr.y, b.width / s, b.height / s,
					'fillColor=none;strokeColor=red;');
			}));
	
			editorUi.actions.addAction('testCheckFile', mxUtils.bind(this, function()
			{
				var xml = (editorUi.pages != null && editorUi.getCurrentFile() != null) ?
					editorUi.getCurrentFile().getAnonymizedXmlForPages(editorUi.pages) : '';

		    	var dlg = new TextareaDialog(editorUi, 'Paste Data:', xml,
		    		function(newValue)
				{
					if (newValue.length > 0)
					{
						try
						{
							if (newValue.charAt(0) != '<')
							{
								newValue = Graph.decompress(newValue);
								mxLog.debug('See console for uncompressed XML');
								console.log('xml', newValue);
							}
							
							var doc = mxUtils.parseXml(newValue);
							var pages = editorUi.getPagesForNode(doc.documentElement, 'mxGraphModel');
							
							if (pages != null && pages.length > 0)
							{
								try
								{
									var checksum = editorUi.getHashValueForPages(pages);
									mxLog.debug('Checksum: ', checksum);
								}
								catch (e)
								{
									mxLog.debug('Error: ', e.message);
								}
							}
							else
							{
								mxLog.debug('No pages found for checksum');
							}

							// Checks for duplicates
							function checkModel(node)
							{
								var pageId = node.parentNode.id;
								var all = node.childNodes;
								var allIds = {};
								var childs = {};
								var root = null;
								var dups = {};
								
								for (var i = 0; i < all.length; i++)
								{
									var el = all[i];
									
									if (el.id != null && el.id.length > 0)
									{
										if (allIds[el.id] == null)
										{
											allIds[el.id] = el.id;
											var pid = el.getAttribute('parent');
											
											if (pid == null)
											{
												if (root != null)
												{
													mxLog.debug(pageId + ': Multiple roots: ' + el.id);
												}
												else
												{
													root = el.id;
												}
											}
											else
											{
												if (childs[pid] == null)
												{
													childs[pid] = [];
												}
												
												childs[pid].push(el.id);
											}
										}
										else
										{
											dups[el.id] = el.id;
										}
									}
								}
								
								if (Object.keys(dups).length > 0)
								{
									var log = pageId + ': ' + Object.keys(dups).length + ' Duplicates: ' + Object.keys(dups).join(', ');
									mxLog.debug(log + ' (see console)');
								}
								else
								{
									mxLog.debug(pageId + ': Checked');
								}
								
								// Checks tree for cycles
								var visited = {};
								
								function visit(id)
								{
									if (visited[id] == null)
									{
										visited[id] = true;
										
										if (childs[id] != null)
										{
											while (childs[id].length > 0)
											{
												var temp = childs[id].pop();
												visit(temp);
											}
											
											delete childs[id];
										}
									}
									else
									{
										mxLog.debug(pageId + ': Visited: ' + id);
									}
								};
								
								if (root == null)
								{
									mxLog.debug(pageId + ': No root');
								}
								else
								{
									visit(root);
									
									if (Object.keys(visited).length != Object.keys(allIds).length)
									{
										mxLog.debug(pageId + ': Invalid tree: (see console)');
										console.log(pageId + ': Invalid tree', childs);
									}
								}
							};
							
							var roots = doc.getElementsByTagName('root');
							
							for (var i = 0; i < roots.length; i++)
							{
								checkModel(roots[i]);
							}
							
							mxLog.show();
						}
						catch (e)
						{
							editorUi.handleError(e);
							console.error(e);
						}
					}
				});
		    	
		    	dlg.textarea.style.width = '600px';
		    	dlg.textarea.style.height = '380px';
				editorUi.showDialog(dlg.container, 620, 460, true, true);
				dlg.init();
			}));
	
			editorUi.actions.addAction('testDiff', mxUtils.bind(this, function()
			{
				if (editorUi.pages != null)
				{
			    	var dlg = new TextareaDialog(editorUi, 'Paste Data:', '',
			    		function(newValue)
					{
						if (newValue.length > 0)
						{
							try
							{
								console.log(JSON.stringify(editorUi.diffPages(editorUi.pages,
									editorUi.getPagesForNode(mxUtils.parseXml(newValue).
									documentElement)), null, 2));
	
							}
							catch (e)
							{
								editorUi.handleError(e);
								console.error(e);
							}
						}
					});
			    	
			    	dlg.textarea.style.width = '600px';
			    	dlg.textarea.style.height = '380px';
					editorUi.showDialog(dlg.container, 620, 460, true, true);
					dlg.init();
				}
				else
				{
					editorUi.alert('No pages');
				}
			}));
	
			editorUi.actions.addAction('testInspect', mxUtils.bind(this, function()
			{
				console.log(editorUi, graph.getModel());
			}));
			
			editorUi.actions.addAction('testXmlImageExport', mxUtils.bind(this, function()
			{
				var bg = '#ffffff';
				var scale = 1;
				var b = 1;
				
				var imgExport = new mxImageExport();
				var bounds = graph.getGraphBounds();
				var vs = graph.view.scale;
				
	        	// New image export
				var xmlDoc = mxUtils.createXmlDocument();
				var root = xmlDoc.createElement('output');
				xmlDoc.appendChild(root);
				
			    // Renders graph. Offset will be multiplied with state's scale when painting state.
				var xmlCanvas = new mxXmlCanvas2D(root);
				xmlCanvas.translate(Math.floor((b / scale - bounds.x) / vs), Math.floor((b / scale - bounds.y) / vs));
				xmlCanvas.scale(scale / vs);
				
				var stateCounter = 0;
				
				var canvasSave = xmlCanvas.save;
				xmlCanvas.save = function()
				{
					stateCounter++;
					canvasSave.apply(this, arguments);
				};
				
				var canvasRestore = xmlCanvas.restore;
				xmlCanvas.restore = function()
				{
					stateCounter--;
					canvasRestore.apply(this, arguments);
				};
				
				var exportDrawShape = imgExport.drawShape;
				imgExport.drawShape = function(state)
				{
					mxLog.debug('entering shape', state, stateCounter);
					exportDrawShape.apply(this, arguments);
					mxLog.debug('leaving shape', state, stateCounter);
				};
				
			    imgExport.drawState(graph.getView().getState(graph.model.root), xmlCanvas);
			    
				// Puts request data together
				var w = Math.ceil(bounds.width * scale / vs + 2 * b);
				var h = Math.ceil(bounds.height * scale / vs + 2 * b);
				
				mxLog.show();
				mxLog.debug(mxUtils.getXml(root));
				mxLog.debug('stateCounter', stateCounter);
			}));
			
			editorUi.actions.addAction('testDownloadRtModel...', mxUtils.bind(this, function()
			{
				if (editorUi.drive == null)
				{
					editorUi.handleError({message: mxResources.get('serviceUnavailableOrBlocked')});
				}
				else
				{
					editorUi.drive.execute(mxUtils.bind(this, function()
					{
						var fileId =prompt('File ID', '');
						
						if (fileId != null && fileId.length > 0 &&
							editorUi.spinner.spin(document.body, mxResources.get('export')))
						{
							// LATER: Download full model dump with history
							var req = new mxXmlRequest('https://www.googleapis.com/drive/v2/files/' +
									fileId + '/realtime?supportsTeamDrives=true', null, 'GET');
	
							// Adds auth token
							req.setRequestHeaders = function(request)
							{
								mxXmlRequest.prototype.setRequestHeaders.apply(this, arguments);
								var token = gapi.auth.getToken().access_token;
								request.setRequestHeader('authorization', 'Bearer ' + token);	
							};
							
							req.send(function(req)
							{
								editorUi.spinner.stop();
								
								if (req.getStatus() >= 200 && req.getStatus() <= 299)
								{
									editorUi.saveLocalFile(req.getText(), 'json-' + fileId +'.txt', 'text/plain');
								}
								else
								{
									editorUi.handleError({message: mxResources.get('fileNotFound')},
										mxResources.get('errorLoadingFile'));
								}
							});
						}
					}));
				}
			}));
	
			editorUi.actions.addAction('testShowConsole', function()
			{
				if (!mxLog.isVisible())
				{
					mxLog.show();
				}
				else
				{
					mxLog.window.fit();
				}
				
				mxLog.window.div.style.zIndex = mxPopupMenu.prototype.zIndex - 1;
			});
			
			this.put('testDevelop', new Menu(mxUtils.bind(this, function(menu, parent)
			{
				this.addMenuItems(menu, ['createSidebarEntry', 'showBoundingBox', '-',
					'testCheckFile', 'testDiff', '-', 'testInspect', '-',
					'testXmlImageExport', '-', 'testDownloadRtModel'], parent);

				menu.addItem(mxResources.get('testImportRtModel') + '...', null, function()
				{
					var input = document.createElement('input');
					input.setAttribute('type', 'file');
					
					mxEvent.addListener(input, 'change', mxUtils.bind(this, function()
					{
						if (input.files != null)
						{
							var reader = new FileReader();
							
							reader.onload = mxUtils.bind(this, function(e)
							{
								try
								{
									editorUi.openLocalFile(mxUtils.getXml(editorUi.drive.convertJsonToXml(
										JSON.parse(e.target.result).data)), input.files[0].name, true);
								}
								catch (err)
								{
									editorUi.handleError(err, mxResources.get('errorLoadingFile'));
								}
							});
							
							reader.readAsText(input.files[0]);
						}
					}));
			
					input.click();
				}, parent);
		
				this.addMenuItems(menu, ['-', 'testShowConsole'], parent);
			})));
		}

		editorUi.actions.addAction('shapes...', function()
		{
			if (mxClient.IS_CHROMEAPP || !editorUi.isOffline())
			{
				editorUi.showDialog(new MoreShapesDialog(editorUi, true).container, 640, (isLocalStorage) ?
						((mxClient.IS_IOS) ? 480 : 460) : 440, true, true);
			}
			else
			{
				editorUi.showDialog(new MoreShapesDialog(editorUi, false).container, 360, (isLocalStorage) ?
						((mxClient.IS_IOS) ? 300 : 280) : 260, true, true);
			}
		});

		editorUi.actions.addAction('createShape...', function()
		{
			var file = editorUi.getCurrentFile();
			
			if (graph.isEnabled())
			{
				var cell = new mxCell('', new mxGeometry(0, 0, 120, 120), editorUi.defaultCustomShapeStyle);
				cell.vertex = true;
				
			    	var dlg = new EditShapeDialog(editorUi, cell, mxResources.get('editShape') + ':', 630, 400);
					editorUi.showDialog(dlg.container, 640, 480, true, false);
					dlg.init();
			}
		});
		
		editorUi.actions.put('embedHtml', new Action(mxResources.get('html') + '...', function()
		{
			if (editorUi.spinner.spin(document.body, mxResources.get('loading')))
			{
				editorUi.getPublicUrl(editorUi.getCurrentFile(), function(url)
				{
					editorUi.spinner.stop();
					
					editorUi.showHtmlDialog(mxResources.get('create'), 'https://desk.draw.io/support/solutions/articles/16000042542',
						url, function(publicUrl, zoomEnabled, initialZoom, linkTarget, linkColor, fit, allPages, layers, lightbox, editLink)
					{
						editorUi.createHtml(publicUrl, zoomEnabled, initialZoom, linkTarget, linkColor,
							fit, allPages, layers, lightbox, editLink, mxUtils.bind(this, function(html, scriptTag)
							{
								var dlg = new EmbedDialog(editorUi, html + '\n' + scriptTag, null, null, function()
								{
									var wnd = window.open();
									var doc = wnd.document;
									
									if (doc != null)
									{
										if (document.compatMode === 'CSS1Compat')
										{
											doc.writeln('<!DOCTYPE html>');
										}
										
										doc.writeln('<html>');
										doc.writeln('<head><title>' + encodeURIComponent(mxResources.get('preview')) +
											'</title><meta charset="utf-8"></head>');
										doc.writeln('<body>');
										doc.writeln(html);
										
										var direct = mxClient.IS_IE || mxClient.IS_EDGE || document.documentMode != null;
										
										if (direct)
										{
											doc.writeln(scriptTag);
										}
										
										doc.writeln('</body>');
										doc.writeln('</html>');
										doc.close();
										
										// Adds script tag after closing page and delay to fix timing issues
										if (!direct)
										{
											var info = wnd.document.createElement('div');
											info.marginLeft = '26px';
											info.marginTop = '26px';
											mxUtils.write(info, mxResources.get('updatingDocument'));
	
											var img = wnd.document.createElement('img');
											img.setAttribute('src', window.location.protocol + '//' + window.location.hostname +
												'/' + IMAGE_PATH + '/spin.gif');
											img.style.marginLeft = '6px';
											info.appendChild(img);
											
											wnd.document.body.insertBefore(info, wnd.document.body.firstChild);
											
											window.setTimeout(function()
											{
												var script = document.createElement('script');
												script.type = 'text/javascript';
												script.src = /<script.*?src="(.*?)"/.exec(scriptTag)[1];
												doc.body.appendChild(script);
												
												info.parentNode.removeChild(info);
											}, 20);
										}
									}
									else
									{
										editorUi.handleError({message: mxResources.get('errorUpdatingPreview')});
									}
								});
								editorUi.showDialog(dlg.container, 440, 240, true, true);
								dlg.init();
							}));
					});
				});
			}
		}));
		
		editorUi.actions.put('liveImage', new Action('Live image...', function()
		{
			var current = editorUi.getCurrentFile();
			
			if (current != null && editorUi.spinner.spin(document.body, mxResources.get('loading')))
			{
				editorUi.getPublicUrl(editorUi.getCurrentFile(), function(url)
				{
					editorUi.spinner.stop();
					
					if (url != null)
					{
						var dlg = new EmbedDialog(editorUi, '<img src="' + ((current.constructor != DriveFile) ?
							url : 'https://drive.google.com/uc?id=' + current.getId()) + '"/>');
						editorUi.showDialog(dlg.container, 440, 240, true, true);
						dlg.init();
					}
					else
					{
						editorUi.handleError({message: mxResources.get('invalidPublicUrl')});
					}
				});
			}
		}));
		
		editorUi.actions.put('embedImage', new Action(mxResources.get('image') + '...', function()
		{
			editorUi.showEmbedImageDialog(function(fit, shadow, retina, lightbox, editLink, layers)
			{
				if (editorUi.spinner.spin(document.body, mxResources.get('loading')))
				{
					editorUi.createEmbedImage(fit, shadow, retina, lightbox, editLink, layers, function(result)
					{
						editorUi.spinner.stop();
						var dlg = new EmbedDialog(editorUi, result);
						editorUi.showDialog(dlg.container, 440, 240, true, true);
						dlg.init();
					}, function(err)
					{
						editorUi.spinner.stop();
						editorUi.handleError(err);
					});
				}
			}, mxResources.get('image'), mxResources.get('retina'), editorUi.isExportToCanvas());
		}));

		editorUi.actions.put('embedSvg', new Action(mxResources.get('formatSvg') + '...', function()
		{
			editorUi.showEmbedImageDialog(function(fit, shadow, image, lightbox, editLink, layers)
			{
				if (editorUi.spinner.spin(document.body, mxResources.get('loading')))
				{
					editorUi.createEmbedSvg(fit, shadow, image, lightbox, editLink, layers, function(result)
					{
						editorUi.spinner.stop();
						
						var dlg = new EmbedDialog(editorUi, result);
						editorUi.showDialog(dlg.container, 440, 240, true, true);
						dlg.init();
					}, function(err)
					{
						editorUi.spinner.stop();
						editorUi.handleError(err);
					});
				}
			}, mxResources.get('formatSvg'), mxResources.get('image'),
				true, 'https://desk.draw.io/support/solutions/articles/16000042548');
		}));
		
		editorUi.actions.put('embedIframe', new Action(mxResources.get('iframe') + '...', function()
		{
			var bounds = graph.getGraphBounds();
			
			editorUi.showPublishLinkDialog(mxResources.get('iframe'), null, '100%',
				(Math.ceil((bounds.y + bounds.height - graph.view.translate.y) / graph.view.scale) + 2),
				function(linkTarget, linkColor, allPages, lightbox, editLink, layers, width, height)
			{
				if (editorUi.spinner.spin(document.body, mxResources.get('loading')))
				{
					editorUi.getPublicUrl(editorUi.getCurrentFile(), function(url)
					{
						editorUi.spinner.stop();
						
						var dlg = new EmbedDialog(editorUi, '<iframe frameborder="0" style="width:' + width +
							';height:' + height + ';" src="' + editorUi.createLink(linkTarget, linkColor,
							allPages, lightbox, editLink, layers, url) + '"></iframe>');
						editorUi.showDialog(dlg.container, 440, 240, true, true);
						dlg.init();
					});
				}
			}, true);
		}));
		
		editorUi.actions.put('publishLink', new Action(mxResources.get('link') + '...', function()
		{
			editorUi.showPublishLinkDialog(null, null, null, null,
				function(linkTarget, linkColor, allPages, lightbox, editLink, layers)
			{
				if (editorUi.spinner.spin(document.body, mxResources.get('loading')))
				{
					editorUi.getPublicUrl(editorUi.getCurrentFile(), function(url)
					{
						editorUi.spinner.stop();
						var dlg = new EmbedDialog(editorUi, editorUi.createLink(linkTarget,
							linkColor, allPages, lightbox, editLink, layers, url));
						editorUi.showDialog(dlg.container, 440, 240, true, true);
						dlg.init();
					});
				}
			});
		}));

		editorUi.actions.addAction('googleDocs...', function()
		{
			editorUi.openLink('http://docsaddon.draw.io');
		});

		editorUi.actions.addAction('googleSlides...', function()
		{
			editorUi.openLink('https://slidesaddon.draw.io');
		});

		editorUi.actions.addAction('googleSites...', function()
		{
			if (editorUi.spinner.spin(document.body, mxResources.get('loading')))
			{
				editorUi.getPublicUrl(editorUi.getCurrentFile(), function(url)
				{
					editorUi.spinner.stop();
					var dlg = new GoogleSitesDialog(editorUi, url);
					editorUi.showDialog(dlg.container, 420, 256, true, true);
					dlg.init();
				});
			}
		});

		// Adds plugins menu item only if localStorage is available for storing the plugins
		if (isLocalStorage || mxClient.IS_CHROMEAPP)
		{
			var action = editorUi.actions.addAction('scratchpad', function()
			{
				editorUi.toggleScratchpad();
			});
			
			action.setToggleAction(true);
			action.setSelectedCallback(function() { return editorUi.scratchpad != null; });

			editorUi.actions.addAction('plugins...', function()
			{
				editorUi.showDialog(new PluginsDialog(editorUi).container, 360, 170, true, false);
			});
		}
		
		var action = editorUi.actions.addAction('search', function()
		{
			var visible = editorUi.sidebar.isEntryVisible('search');
			editorUi.sidebar.showPalette('search', !visible);
			
			if (isLocalStorage)
			{
				mxSettings.settings.search = !visible;
				mxSettings.save();
			}
		});
		
		action.setToggleAction(true);
		action.setSelectedCallback(function() { return editorUi.sidebar.isEntryVisible('search'); });
		
		if (urlParams['embed'] == '1')
		{
			editorUi.actions.get('save').funct = function(exit)
			{
				if (graph.isEditing())
				{
					graph.stopEditing();
				}
				
				var data = (urlParams['pages'] != '0' || (editorUi.pages != null && editorUi.pages.length > 1)) ?
					editorUi.getFileData(true) : mxUtils.getXml(editorUi.editor.getGraphXml());
				
				if (urlParams['proto'] == 'json')
				{
					var msg = editorUi.createLoadMessage('save');
					msg.xml = data;
					
					if (exit)
					{
						msg.exit = true;
					}
					
					data = JSON.stringify(msg);
				}
				
				var parent = window.opener || window.parent;
				parent.postMessage(data, '*');
				
				if (urlParams['modified'] != '0' && urlParams['keepmodified'] != '1')
				{
					editorUi.editor.modified = false;
					editorUi.editor.setStatus('');
				}
				
				//Add support to saving files if embedded mode is running with files
				var file = editorUi.getCurrentFile();
				
				if (file != null)
				{
					editorUi.saveFile();
				}
			};
	
			editorUi.actions.addAction('saveAndExit', function()
			{
				editorUi.actions.get('save').funct(true);
			});
			
			editorUi.actions.addAction('exit', function()
			{
				var fn = function()
				{
					editorUi.editor.modified = false;
					var msg = (urlParams['proto'] == 'json') ? JSON.stringify({event: 'exit',
						modified: editorUi.editor.modified}) : '';
					var parent = window.opener || window.parent;
					parent.postMessage(msg, '*');
				}
				
				if (!editorUi.editor.modified)
				{
					fn();
				}
				else
				{
					editorUi.confirm(mxResources.get('allChangesLost'), null, fn,
						mxResources.get('cancel'), mxResources.get('discardChanges'));
				}
			});
		}
		
		this.put('exportAs', new Menu(mxUtils.bind(this, function(menu, parent)
		{
			if (editorUi.isExportToCanvas())
			{
				this.addMenuItems(menu, ['exportPng'], parent);
				
				if (editorUi.jpgSupported)
				{
					this.addMenuItems(menu, ['exportJpg'], parent);
				}
			}
			
			// Disabled for standalone mode in iOS because new tab cannot be closed
			else if (!editorUi.isOffline() && (!mxClient.IS_IOS || !navigator.standalone))
			{
				this.addMenuItems(menu, ['exportPng', 'exportJpg'], parent);
			}
			
			this.addMenuItems(menu, ['exportSvg', '-'], parent);
			
			// Redirects export to PDF to print in Chrome App
			if (editorUi.isOffline() || editorUi.printPdfExport)
			{
				this.addMenuItems(menu, ['exportPdf'], parent);
			}
			// Disabled for standalone mode in iOS because new tab cannot be closed
			else if (!editorUi.isOffline() && (!mxClient.IS_IOS || !navigator.standalone))
			{
				this.addMenuItems(menu, ['exportPdf'], parent);
			}

			if (!mxClient.IS_IE && (typeof(VsdxExport) !== 'undefined' || !editorUi.isOffline()))
			{
				this.addMenuItems(menu, ['exportVsdx'], parent);
			}

			this.addMenuItems(menu, ['-', 'exportHtml', 'exportXml', 'exportUrl'], parent);

			if (!editorUi.isOffline())
			{
				menu.addSeparator(parent);
				this.addMenuItem(menu, 'export', parent).firstChild.nextSibling.innerHTML = mxResources.get('advanced') + '...';
			}
		})));

		this.put('importFrom', new Menu(mxUtils.bind(this, function(menu, parent)
		{
			var doImportFile = mxUtils.bind(this, function(data, mime, filename)
			{
				// Gets insert location
				var view = graph.view;
				var bds = graph.getGraphBounds();
				var x = graph.snap(Math.ceil(Math.max(0, bds.x / view.scale - view.translate.x) + 4 * graph.gridSize));
				var y = graph.snap(Math.ceil(Math.max(0, (bds.y + bds.height) / view.scale - view.translate.y) + 4 * graph.gridSize));

				if (data.substring(0, 11) == 'data:image/')
				{
					editorUi.loadImage(data, mxUtils.bind(this, function(img)
	    			{
			    		var resizeImages = true;
			    		
			    		var doInsert = mxUtils.bind(this, function()
			    		{
		    				editorUi.resizeImage(img, data, mxUtils.bind(this, function(data2, w2, h2)
	    	    			{
	    		    			var s = (resizeImages) ? Math.min(1, Math.min(editorUi.maxImageSize / w2, editorUi.maxImageSize / h2)) : 1;
	
    							editorUi.importFile(data, mime, x, y, Math.round(w2 * s), Math.round(h2 * s), filename, function(cells)
    							{
    								editorUi.spinner.stop();
    								graph.setSelectionCells(cells);
    								graph.scrollCellToVisible(graph.getSelectionCell());
    							});
	    	    			}), resizeImages);
			    		});
			    		
			    		if (data.length > editorUi.resampleThreshold)
			    		{
			    			editorUi.confirmImageResize(function(doResize)
	    					{
	    						resizeImages = doResize;
	    						doInsert();
	    					});
			    		}
			    		else
		    			{
			    			doInsert();
		    			}
	    			}), mxUtils.bind(this, function()
	    			{
	    				editorUi.handleError({message: mxResources.get('cannotOpenFile')});
	    			}));
				}
				else
				{
					editorUi.importFile(data, mime, x, y, 0, 0, filename, function(cells)
					{
						editorUi.spinner.stop();
						graph.setSelectionCells(cells);
						graph.scrollCellToVisible(graph.getSelectionCell());
					});
				}
			});
			
			var getMimeType = mxUtils.bind(this, function(filename)
			{
				var mime = 'text/xml';
				
				if (/\.png$/i.test(filename))
				{
					mime = 'image/png';
				}
				else if (/\.jpe?g$/i.test(filename))
				{
					mime = 'image/jpg';
				}
				else if (/\.gif$/i.test(filename))
				{
					mime = 'image/gif';
				}
				
				return mime;
			});
			
			function pickFileFromService(service)
			{
				// Drive requires special arguments for libraries and bypassing realtime
				service.pickFile(function(id)
				{
					if (editorUi.spinner.spin(document.body, mxResources.get('loading')))
					{
						// NOTE The third argument in getFile says denyConvert to match
						// the existing signature in the original DriveClient which has
						// as slightly different semantic, but works the same way.
						service.getFile(id, function(file)
						{
							var mime = (file.getData().substring(0, 11) == 'data:image/') ? getMimeType(file.getTitle()) : 'text/xml';
							
							// Imports SVG as images
							if (/\.svg$/i.test(file.getTitle()) && !editorUi.editor.isDataSvg(file.getData()))
							{
								file.setData(editorUi.createSvgDataUri(file.getData()));
								mime = 'image/svg+xml';
							}
							
							doImportFile(file.getData(), mime, file.getTitle());
						},
						function(resp)
						{
							editorUi.handleError(resp, (resp != null) ? mxResources.get('errorLoadingFile') : null);
						}, service == editorUi.drive);
					}
				}, true);
			};
		    /*
			if (typeof(google) != 'undefined' && typeof(google.picker) != 'undefined')
			{
				if (editorUi.drive != null)
				{
					// Requires special arguments for libraries and realtime
					menu.addItem(mxResources.get('googleDrive') + '...', null, function()
					{
						pickFileFromService(editorUi.drive);
					}, parent);
				}
				else if (googleEnabled && typeof window.DriveClient === 'function')
				{
					menu.addItem(mxResources.get('googleDrive') + ' (' + mxResources.get('loading') + '...)', null, function()
					{
						// do nothing
					}, parent, null, false);
				}
			}

			if (editorUi.oneDrive != null)
			{
				menu.addItem(mxResources.get('oneDrive') + '...', null, function()
				{
					pickFileFromService(editorUi.oneDrive);
				}, parent);
			}
			else if (oneDriveEnabled && typeof window.OneDriveClient === 'function')
			{
				menu.addItem(mxResources.get('oneDrive') + ' (' + mxResources.get('loading') + '...)', null, function()
				{
					// do nothing
				}, parent, null, false);
			}

			if (editorUi.dropbox != null)
			{
				menu.addItem(mxResources.get('dropbox') + '...', null, function()
				{
					pickFileFromService(editorUi.dropbox);
				}, parent);
			}
			else if (dropboxEnabled && typeof window.DropboxClient === 'function')
			{
				menu.addItem(mxResources.get('dropbox') + ' (' + mxResources.get('loading') + '...)', null, function()
				{
					// do nothing
				}, parent, null, false);
			}
			
			if (editorUi.gitHub != null)
			{
				menu.addItem(mxResources.get('github') + '...', null, function()
				{
					pickFileFromService(editorUi.gitHub);
				}, parent);
			}

			if (editorUi.trello != null)
			{
				menu.addItem(mxResources.get('trello') + '...', null, function()
				{
					pickFileFromService(editorUi.trello);
				}, parent);
			}
			else if (trelloEnabled && typeof window.TrelloClient === 'function')
			{
				menu.addItem(mxResources.get('trello') + ' (' + mxResources.get('loading') + '...)', null, function()
				{
					// do nothing
				}, parent, null, false);
			}
			
			menu.addSeparator(parent);

			if (isLocalStorage && urlParams['browser'] != '0')
			{
				menu.addItem(mxResources.get('browser') + '...', null, function()
				{
					editorUi.importLocalFile(false);
				}, parent);
			}
            */
			menu.addItem(mxResources.get('device') + '...', null, function()
			{
				editorUi.importLocalFile(true);
			}, parent);
            /*
			if (!editorUi.isOffline())
			{
				menu.addSeparator(parent);
				
				menu.addItem(mxResources.get('url') + '...', null, function()
				{
					var dlg = new FilenameDialog(editorUi, '', mxResources.get('import'), function(fileUrl)
					{
						if (fileUrl != null && fileUrl.length > 0 && editorUi.spinner.spin(document.body, mxResources.get('loading')))
						{
							var mime = (/(\.png)($|\?)/i.test(fileUrl)) ? 'image/png' : 'text/xml';
							
							// Uses proxy to avoid CORS issues
							editorUi.loadUrl(PROXY_URL + '?url=' + encodeURIComponent(fileUrl), function(data)
							{
								doImportFile(data, mime, fileUrl);
							},
							function ()
							{
								editorUi.spinner.stop();
								editorUi.handleError(null, mxResources.get('errorLoadingFile'));
							}, mime == 'image/png');
						}
					}, mxResources.get('url'));
					editorUi.showDialog(dlg.container, 300, 80, true, true);
					dlg.init();
				}, parent);
			}*/
		}))).isEnabled = isGraphEnabled;

		this.put('theme', new Menu(mxUtils.bind(this, function(menu, parent)
		{
			var theme = mxSettings.getUi();

			var item = menu.addItem(mxResources.get('automatic'), null, function()
			{
				mxSettings.setUi('');
				mxSettings.save();
				editorUi.alert(mxResources.get('restartForChangeRequired'));
			}, parent);
			
			if (theme != 'kennedy' && theme != 'atlas' &&
				theme != 'dark' && theme != 'min')
			{
				menu.addCheckmark(item, Editor.checkmarkImage);
			}

			menu.addSeparator(parent);
			
			item = menu.addItem(mxResources.get('kennedy'), null, function()
			{
				mxSettings.setUi('kennedy');
				mxSettings.save();
				editorUi.alert(mxResources.get('restartForChangeRequired'));
			}, parent);

			if (theme == 'kennedy')
			{
				menu.addCheckmark(item, Editor.checkmarkImage);
			}

			item = menu.addItem(mxResources.get('minimal'), null, function()
			{
				mxSettings.setUi('min');
				mxSettings.save();
				editorUi.alert(mxResources.get('restartForChangeRequired'));
			}, parent);
			
			if (theme == 'min')
			{
				menu.addCheckmark(item, Editor.checkmarkImage);
			}
			
			item = menu.addItem(mxResources.get('atlas'), null, function()
			{
				mxSettings.setUi('atlas');
				mxSettings.save();
				editorUi.alert(mxResources.get('restartForChangeRequired'));
			}, parent);
			
			if (theme == 'atlas')
			{
				menu.addCheckmark(item, Editor.checkmarkImage);
			}
			
			item = menu.addItem(mxResources.get('dark'), null, function()
			{
				mxSettings.setUi('dark');
				mxSettings.save();
				editorUi.alert(mxResources.get('restartForChangeRequired'));
			}, parent);
			
			if (theme == 'dark')
			{
				menu.addCheckmark(item, Editor.checkmarkImage);
			}
		})));

		var renameAction = this.editorUi.actions.addAction('rename...', mxUtils.bind(this, function()
		{
			var file = this.editorUi.getCurrentFile();
			
			if (file != null)
			{
				var filename = (file.getTitle() != null) ? file.getTitle() : this.editorUi.defaultFilename;
				
				var dlg = new FilenameDialog(this.editorUi, filename, mxResources.get('rename'), mxUtils.bind(this, function(title)
				{
					if (title != null && title.length > 0 && file != null && title != file.getTitle() &&
						this.editorUi.spinner.spin(document.body, mxResources.get('renaming')))
					{
						// Delete old file, save new file in dropbox if autosize is enabled
						file.rename(title, mxUtils.bind(this, function(resp)
						{
							this.editorUi.spinner.stop();
						}),
						mxUtils.bind(this, function(resp)
						{
							this.editorUi.handleError(resp, (resp != null) ? mxResources.get('errorRenamingFile') : null);
						}));
					}
				}), (file.constructor == DriveFile || file.constructor == StorageFile) ?
					mxResources.get('diagramName') : null, function(name)
				{
					if (name != null && name.length > 0)
					{
						return true;
					}
					
					editorUi.showError(mxResources.get('error'), mxResources.get('invalidName'), mxResources.get('ok'));
					
					return false;
				}, null, null, null, null, editorUi.editor.fileExtensions);
				this.editorUi.showDialog(dlg.container, 340, 90, true, true);
				dlg.init();
			}
		}));
		
		renameAction.isEnabled = function()
		{
			return this.enabled && isGraphEnabled.apply(this, arguments);
		}
		
		renameAction.visible = urlParams['embed'] != '1';
		
		editorUi.actions.addAction('makeCopy...', mxUtils.bind(this, function()
		{
			var file = editorUi.getCurrentFile();
			
			if (file != null)
			{
				var title = editorUi.getCopyFilename(file);

				if (file.constructor == DriveFile)
				{
					var dlg = new CreateDialog(editorUi, title, mxUtils.bind(this, function(newTitle, mode)
					{
						// Mode is "download" if Create button is pressed, means use Google Drive
						if (mode == 'download')
						{
							mode = App.MODE_GOOGLE;
						}
						
						if (newTitle != null && newTitle.length > 0)
						{
							if (mode == App.MODE_GOOGLE)
							{
								if (editorUi.spinner.spin(document.body, mxResources.get('saving')))
								{
									// Saveas does not update the file descriptor in Google Drive
									file.saveAs(newTitle, mxUtils.bind(this, function(resp)
									{
										// Replaces file descriptor in-place and saves
										file.desc = resp;
										
										// Makes sure the latest XML is in the file
										file.save(false, mxUtils.bind(this, function()
										{
											editorUi.spinner.stop();
											file.setModified(false);
											file.addAllSavedStatus();
										}), mxUtils.bind(this, function(resp)
										{
											editorUi.handleError(resp);
										}));
									}), mxUtils.bind(this, function(resp)
									{
										editorUi.handleError(resp);
									}));
								}
							}
							else
							{
								editorUi.createFile(newTitle, editorUi.getFileData(true), null, mode);
							}
						}
					}), mxUtils.bind(this, function()
					{
						editorUi.hideDialog();
					}), mxResources.get('makeCopy'), mxResources.get('create'), null,
						null, null, null, true, null, null, null, null,
						editorUi.editor.fileExtensions);
					editorUi.showDialog(dlg.container, 420, 380, true, true);
					dlg.init();
				}
				else
				{
					// Creates a copy with no predefined storage
					editorUi.editor.editAsNew(this.editorUi.getFileData(true), title);
				}
			}
		}));
		
		editorUi.actions.addAction('moveToFolder...', mxUtils.bind(this, function()
		{
			var file = editorUi.getCurrentFile();
			
			if (file.getMode() == App.MODE_GOOGLE || file.getMode() == App.MODE_ONEDRIVE)
			{
				var isInRoot = false;
				
				if (file.getMode() == App.MODE_GOOGLE && file.desc.parents != null)
				{
					for (var i = 0; i < file.desc.parents.length; i++)
					{
						if (file.desc.parents[i].isRoot)
						{
							isInRoot = true;
							break;
						}
					}
				}
				
				editorUi.pickFolder(file.getMode(), mxUtils.bind(this, function(folderId)
				{
	            	if (editorUi.spinner.spin(document.body, mxResources.get('moving')))
	            	{
	            	    file.move(folderId, mxUtils.bind(this, function(resp)
	            		{
	            	    	editorUi.spinner.stop();
	        			}), mxUtils.bind(this, function(resp)
	        			{
	        				editorUi.handleError(resp);
	        			}));
	            	}
				}), null, true, isInRoot);
			}
		}));
		
		this.put('publish', new Menu(mxUtils.bind(this, function(menu, parent)
		{
			this.addMenuItems(menu, ['publishLink'], parent);
		})));

		editorUi.actions.put('useOffline', new Action(mxResources.get('useOffline') + '...', function()
		{
			editorUi.openLink('https://app.draw.io/')
		}));
		
		editorUi.actions.put('downloadDesktop', new Action(mxResources.get('downloadDesktop') + '...', function()
		{
			editorUi.openLink('https://get.draw.io/')
		}));

		this.editorUi.actions.addAction('share...', mxUtils.bind(this, function()
		{
			try
			{
				var file = editorUi.getCurrentFile();
				
				if (file != null)
				{
					editorUi.drive.showPermissions(file.getId());
				}
			}
			catch (e)
			{
				editorUi.handleError(e);
			}
		}));

		this.put('embed', new Menu(mxUtils.bind(this, function(menu, parent)
		{
			var file = editorUi.getCurrentFile();
			
			if (file != null && (file.getMode() == App.MODE_GOOGLE ||
				file.getMode() == App.MODE_GITHUB) && /(\.png)$/i.test(file.getTitle()))
			{
				this.addMenuItems(menu, ['liveImage', '-'], parent);
			}
			
			this.addMenuItems(menu, ['embedImage', 'embedSvg', '-', 'embedHtml'], parent);
			
			if (!navigator.standalone && !editorUi.isOffline())
			{
				this.addMenuItems(menu, ['embedIframe'], parent);
			}

			if (urlParams['embed'] != '1' && !editorUi.isOffline())
			{
				this.addMenuItems(menu, ['-', 'googleDocs', 'googleSlides'], parent);
			}
		})));

		var addInsertItem = function(menu, parent, title, method)
		{
			if (method != 'plantUml' || (EditorUi.enablePlantUml && !editorUi.isOffline()))
			{
				menu.addItem(title, null, mxUtils.bind(this, function()
				{
					if (method == 'fromText' || method == 'formatSql' || method == 'plantUml')
					{
						var dlg = new ParseDialog(editorUi, title, method);
						editorUi.showDialog(dlg.container, 620, 420, true, false);
						editorUi.dialog.container.style.overflow = 'auto';
						dlg.init();
					}
					else
					{
						var dlg = new CreateGraphDialog(editorUi, title, method);
						editorUi.showDialog(dlg.container, 620, 420, true, false);
						// Executed after dialog is added to dom
						dlg.init();
					}
				}), parent, null, isGraphEnabled());
			}
		};
		
		var insertVertex = function(value, w, h, style)
		{
			var pt = (graph.isMouseInsertPoint()) ? graph.getInsertPoint() : graph.getFreeInsertPoint();
			var cell = new mxCell(value, new mxGeometry(pt.x, pt.y, w, h), style);
			cell.vertex = true;
		
    		graph.getModel().beginUpdate();
    		try
    	    {
    			cell = graph.addCell(cell);
    	    	graph.fireEvent(new mxEventObject('cellsInserted', 'cells', [cell]));
    	    }
    		finally
    		{
    			graph.getModel().endUpdate();
    		}
		
    		graph.scrollCellToVisible(cell);
    		graph.setSelectionCell(cell);
    		graph.container.focus();

    		if (graph.editAfterInsert)
    		{
    	        graph.startEditing(cell);
    		}
    		
	    	return cell;
		};
		
		editorUi.actions.put('exportSvg', new Action(mxResources.get('formatSvg') + '...', function()
		{
			editorUi.showExportDialog(mxResources.get('formatSvg'), true, mxResources.get('export'),
				'https://support.draw.io/display/DO/Exporting+Files',
				mxUtils.bind(this, function(scale, transparentBackground, ignoreSelection, addShadow,
					editable, embedImages, border, cropImage, currentPage, linkTarget)
				{
					var val = parseInt(scale);
					
					if (!isNaN(val) && val > 0)
					{
					   	editorUi.exportSvg(val / 100, transparentBackground, ignoreSelection, addShadow,
					   		editable, embedImages, border, !cropImage, currentPage, linkTarget);
					}
				}), true, null, 'svg');
		}));
		
		editorUi.actions.put('insertText', new Action(mxResources.get('text'), function()
		{
			if (graph.isEnabled() && !graph.isCellLocked(graph.getDefaultParent()))
			{
    			graph.startEditingAtCell(insertVertex('Text', 40, 20, 'text;html=1;resizable=0;autosize=1;' +
    				'align=center;verticalAlign=middle;points=[];fillColor=none;strokeColor=none;rounded=0;'));
			}
		}), null, null, Editor.ctrlKey + '+Shift+X').isEnabled = isGraphEnabled;
		
		editorUi.actions.put('insertRectangle', new Action(mxResources.get('rectangle'), function()
		{
			if (graph.isEnabled() && !graph.isCellLocked(graph.getDefaultParent()))
			{
    	    	insertVertex('', 120, 60, 'whiteSpace=wrap;html=1;');
			}
		}), null, null, Editor.ctrlKey + '+K').isEnabled = isGraphEnabled;

		editorUi.actions.put('insertEllipse', new Action(mxResources.get('ellipse'), function()
		{
			if (graph.isEnabled() && !graph.isCellLocked(graph.getDefaultParent()))
			{
    	    	insertVertex('', 80, 80, 'ellipse;whiteSpace=wrap;html=1;');
			}
		}), null, null, Editor.ctrlKey + '+Shift+K').isEnabled = isGraphEnabled;
		
		editorUi.actions.put('insertRhombus', new Action(mxResources.get('rhombus'), function()
		{
			if (graph.isEnabled() && !graph.isCellLocked(graph.getDefaultParent()))
			{
    	    	insertVertex('', 80, 80, 'rhombus;whiteSpace=wrap;html=1;');
			}
		})).isEnabled = isGraphEnabled;
		
		var addInsertMenuItems = mxUtils.bind(this, function(menu, parent, methods)
		{
			for (var i = 0; i < methods.length; i++)
			{
				if (methods[i] == '-')
				{
					menu.addSeparator(parent);
				}
				else
				{
					addInsertItem(menu, parent, mxResources.get(methods[i]) + '...', methods[i]);
				}
			}
		});

		this.put('insert', new Menu(mxUtils.bind(this, function(menu, parent)
		{
			this.addMenuItems(menu, ['insertRectangle', 'insertEllipse', 'insertRhombus', '-',
				'insertText', 'insertLink', '-', 'insertImage'], parent);

			if (editorUi.insertTemplateEnabled && !editorUi.isOffline())
			{
				this.addMenuItems(menu, ['insertTemplate', '-'], parent);
			}
			
			this.addSubmenu('insertLayout', menu, parent, mxResources.get('layout'));
			menu.addSeparator(parent);
			addInsertMenuItems(menu, parent, ['fromText', 'plantUml', '-', 'formatSql']);
			menu.addItem(mxResources.get('csv') + '...', null, function()
			{
				editorUi.showImportCsvDialog();
			}, parent, null, isGraphEnabled());
		})));

		this.put('insertLayout', new Menu(mxUtils.bind(this, function(menu, parent)
		{
			addInsertMenuItems(menu, parent, ['horizontalFlow', 'verticalFlow', '-', 'horizontalTree',
				'verticalTree', 'radialTree', '-', 'organic', 'circle']);
		})));

		this.put('openRecent', new Menu(function(menu, parent)
		{
			var recent = editorUi.getRecent();

			if (recent != null)
			{
				for (var i = 0; i < recent.length; i++)
				{
					(function(entry)
					{
						var modeKey = entry.mode;
						
						// Google and oneDrive use different keys
						if (modeKey == App.MODE_GOOGLE)
						{
							modeKey = 'googleDrive';
						}
						else if (modeKey == App.MODE_ONEDRIVE)
						{
							modeKey = 'oneDrive';
						}
						
						menu.addItem(entry.title + ' (' + mxResources.get(modeKey) + ')', null, function()
						{
							editorUi.loadFile(entry.id);
						}, parent);
					})(recent[i]);
				}

				menu.addSeparator(parent);
			}

			menu.addItem(mxResources.get('reset'), null, function()
			{
				editorUi.resetRecent();
			}, parent);
		}));
		
		this.put('openFrom', new Menu(function(menu, parent)
		{
			if (editorUi.drive != null)
			{
				menu.addItem(mxResources.get('googleDrive') + '...', null, function()
				{
					editorUi.pickFile(App.MODE_GOOGLE);
				}, parent);
			}
			else if (googleEnabled && typeof window.DriveClient === 'function')
			{
				menu.addItem(mxResources.get('googleDrive') + ' (' + mxResources.get('loading') + '...)', null, function()
				{
					// do nothing
				}, parent, null, false);
			}
			
			if (editorUi.oneDrive != null)
			{
				menu.addItem(mxResources.get('oneDrive') + '...', null, function()
				{
					editorUi.pickFile(App.MODE_ONEDRIVE);
				}, parent);
			}
			else if (oneDriveEnabled && typeof window.OneDriveClient === 'function')
			{
				menu.addItem(mxResources.get('oneDrive') + ' (' + mxResources.get('loading') + '...)', null, function()
				{
					// do nothing
				}, parent, null, false);
			}
			
			if (editorUi.dropbox != null)
			{
				menu.addItem(mxResources.get('dropbox') + '...', null, function()
				{
					editorUi.pickFile(App.MODE_DROPBOX);
				}, parent);
			}
			else if (dropboxEnabled && typeof window.DropboxClient === 'function')
			{
				menu.addItem(mxResources.get('dropbox') + ' (' + mxResources.get('loading') + '...)', null, function()
				{
					// do nothing
				}, parent, null, false);
			}

			if (editorUi.gitHub != null)
			{
				menu.addItem(mxResources.get('github') + '...', null, function()
				{
					editorUi.pickFile(App.MODE_GITHUB);
				}, parent);
			}

			if (editorUi.trello != null)
			{
				menu.addItem(mxResources.get('trello') + '...', null, function()
				{
					editorUi.pickFile(App.MODE_TRELLO);
				}, parent);
			}
			else if (trelloEnabled && typeof window.TrelloClient === 'function')
			{
				menu.addItem(mxResources.get('trello') + ' (' + mxResources.get('loading') + '...)', null, function()
				{
					// do nothing
				}, parent, null, false);
			}
			
			menu.addSeparator(parent);

			if (isLocalStorage && urlParams['browser'] != '0')
			{
				menu.addItem(mxResources.get('browser') + '...', null, function()
				{
					editorUi.pickFile(App.MODE_BROWSER);
				}, parent);
			}
			
			//if (!mxClient.IS_IOS)
			{
				menu.addItem(mxResources.get('device') + '...', null, function()
				{
					editorUi.pickFile(App.MODE_DEVICE);
				}, parent);
			}

			if (!editorUi.isOffline())
			{
				menu.addSeparator(parent);
				
				menu.addItem(mxResources.get('url') + '...', null, function()
				{
					var dlg = new FilenameDialog(editorUi, '', mxResources.get('open'), function(fileUrl)
					{
						if (fileUrl != null && fileUrl.length > 0)
						{
							if (editorUi.getCurrentFile() == null)
							{
								window.location.hash = '#U' + encodeURIComponent(fileUrl);
							}
							else
							{
								window.openWindow(((mxClient.IS_CHROMEAPP) ?
									'https://www.draw.io/' : 'https://' + location.host + '/') +
									window.location.search + '#U' + encodeURIComponent(fileUrl));
							}
						}
					}, mxResources.get('url'));
					editorUi.showDialog(dlg.container, 300, 80, true, true);
					dlg.init();
				}, parent);
			}
		}));
		
		if (Editor.enableCustomLibraries)
		{
			this.put('newLibrary', new Menu(function(menu, parent)
			{
				if (typeof(google) != 'undefined' && typeof(google.picker) != 'undefined')
				{
					if (editorUi.drive != null)
					{
						menu.addItem(mxResources.get('googleDrive') + '...', null, function()
						{
							editorUi.showLibraryDialog(null, null, null, null, App.MODE_GOOGLE);
						}, parent);
					}
					else if (googleEnabled && typeof window.DriveClient === 'function')
					{
						menu.addItem(mxResources.get('googleDrive') + ' (' + mxResources.get('loading') + '...)', null, function()
						{
							// do nothing
						}, parent, null, false);
					}
				}

				if (editorUi.oneDrive != null)
				{
					menu.addItem(mxResources.get('oneDrive') + '...', null, function()
					{
						editorUi.showLibraryDialog(null, null, null, null, App.MODE_ONEDRIVE);
					}, parent);
				}
				else if (oneDriveEnabled && typeof window.OneDriveClient === 'function')
				{
					menu.addItem(mxResources.get('oneDrive') + ' (' + mxResources.get('loading') + '...)', null, function()
					{
						// do nothing
					}, parent, null, false);
				}

				if (editorUi.dropbox != null)
				{
					menu.addItem(mxResources.get('dropbox') + '...', null, function()
					{
						editorUi.showLibraryDialog(null, null, null, null, App.MODE_DROPBOX);
					}, parent);
				}
				else if (dropboxEnabled && typeof window.DropboxClient === 'function')
				{
					menu.addItem(mxResources.get('dropbox') + ' (' + mxResources.get('loading') + '...)', null, function()
					{
						// do nothing
					}, parent, null, false);
				}
				
				if (editorUi.gitHub != null)
				{
					menu.addItem(mxResources.get('github') + '...', null, function()
					{
						editorUi.showLibraryDialog(null, null, null, null, App.MODE_GITHUB);
					}, parent);
				}
				
				if (editorUi.trello != null)
				{
					menu.addItem(mxResources.get('trello') + '...', null, function()
					{
						editorUi.showLibraryDialog(null, null, null, null, App.MODE_TRELLO);
					}, parent);
				}
				else if (trelloEnabled && typeof window.TrelloClient === 'function')
				{
					menu.addItem(mxResources.get('trello') + ' (' + mxResources.get('loading') + '...)', null, function()
					{
						// do nothing
					}, parent, null, false);
				}
				
				menu.addSeparator(parent);
	
				if (isLocalStorage && urlParams['browser'] != '0')
				{
					menu.addItem(mxResources.get('browser') + '...', null, function()
					{
						editorUi.showLibraryDialog(null, null, null, null, App.MODE_BROWSER);
					}, parent);
				}
				
				//if (!mxClient.IS_IOS)
				{
					menu.addItem(mxResources.get('device') + '...', null, function()
					{
						editorUi.showLibraryDialog(null, null, null, null, App.MODE_DEVICE);
					}, parent);
				}
			}));
	
			this.put('openLibraryFrom', new Menu(function(menu, parent)
			{
				if (typeof(google) != 'undefined' && typeof(google.picker) != 'undefined')
				{
					if (editorUi.drive != null)
					{
						menu.addItem(mxResources.get('googleDrive') + '...', null, function()
						{
							editorUi.pickLibrary(App.MODE_GOOGLE);
						}, parent);
					}
					else if (googleEnabled && typeof window.DriveClient === 'function')
					{
						menu.addItem(mxResources.get('googleDrive') + ' (' + mxResources.get('loading') + '...)', null, function()
						{
							// do nothing
						}, parent, null, false);
					}
				}

				if (editorUi.oneDrive != null)
				{
					menu.addItem(mxResources.get('oneDrive') + '...', null, function()
					{
						editorUi.pickLibrary(App.MODE_ONEDRIVE);
					}, parent);
				}
				else if (oneDriveEnabled && typeof window.OneDriveClient === 'function')
				{
					menu.addItem(mxResources.get('oneDrive') + ' (' + mxResources.get('loading') + '...)', null, function()
					{
						// do nothing
					}, parent, null, false);
				}

				if (editorUi.dropbox != null)
				{
					menu.addItem(mxResources.get('dropbox') + '...', null, function()
					{
						editorUi.pickLibrary(App.MODE_DROPBOX);
					}, parent);
				}
				else if (dropboxEnabled && typeof window.DropboxClient === 'function')
				{
					menu.addItem(mxResources.get('dropbox') + ' (' + mxResources.get('loading') + '...)', null, function()
					{
						// do nothing
					}, parent, null, false);
				}
				
				if (editorUi.gitHub != null)
				{
					menu.addItem(mxResources.get('github') + '...', null, function()
					{
						editorUi.pickLibrary(App.MODE_GITHUB);
					}, parent);
				}
				
				if (editorUi.trello != null)
				{
					menu.addItem(mxResources.get('trello') + '...', null, function()
					{
						editorUi.pickLibrary(App.MODE_TRELLO);
					}, parent);
				}
				else if (trelloEnabled && typeof window.TrelloClient === 'function')
				{
					menu.addItem(mxResources.get('trello') + ' (' + mxResources.get('loading') + '...)', null, function()
					{
						// do nothing
					}, parent, null, false);
				}
				
				menu.addSeparator(parent);
	
				if (isLocalStorage && urlParams['browser'] != '0')
				{
					menu.addItem(mxResources.get('browser') + '...', null, function()
					{
						editorUi.pickLibrary(App.MODE_BROWSER);
					}, parent);
				}
				
				//if (!mxClient.IS_IOS)
				{
					menu.addItem(mxResources.get('device') + '...', null, function()
					{
						editorUi.pickLibrary(App.MODE_DEVICE);
					}, parent);
				}
	
				if (!editorUi.isOffline())
				{
					menu.addSeparator(parent);
					
					menu.addItem(mxResources.get('url') + '...', null, function()
					{
						var dlg = new FilenameDialog(editorUi, '', mxResources.get('open'), function(fileUrl)
						{
							if (fileUrl != null && fileUrl.length > 0 && editorUi.spinner.spin(document.body, mxResources.get('loading')))
							{
								var realUrl = fileUrl;
								
								if (!editorUi.editor.isCorsEnabledForUrl(fileUrl))
								{
									realUrl = PROXY_URL + '?url=' + encodeURIComponent(fileUrl);
								}
								
								// Uses proxy to avoid CORS issues
								mxUtils.get(realUrl, function(req)
								{
									if (req.getStatus() >= 200 && req.getStatus() <= 299)
									{
										editorUi.spinner.stop();
										
										try
										{
											editorUi.loadLibrary(new UrlLibrary(this, req.getText(), fileUrl));
										}
										catch (e)
										{
											editorUi.handleError(e, mxResources.get('errorLoadingFile'));
										}
									}
									else
									{
										editorUi.spinner.stop();
										editorUi.handleError(null, mxResources.get('errorLoadingFile'));
									}
								}, function()
								{
									editorUi.spinner.stop();
									editorUi.handleError(null, mxResources.get('errorLoadingFile'));
								});
							}
						}, mxResources.get('url'));
						editorUi.showDialog(dlg.container, 300, 80, true, true);
						dlg.init();
					}, parent);
				}
				
				if (urlParams['confLib'] == '1')
				{
					menu.addSeparator(parent);
					
					menu.addItem(mxResources.get('confluenceCloud') + '...', null, function()
					{
						editorUi.showRemotelyStoredLibrary(mxResources.get('libraries'));
					}, parent);
				}
			}));
		}
			
		// Overrides edit menu to add find and editGeometry
		this.put('edit', new Menu(mxUtils.bind(this, function(menu, parent)
		{
			this.addMenuItems(menu, ['undo', 'redo', '-', 'cut', 'copy', 'paste', 'delete', '-', 'duplicate', '-',
									 'find', '-', 'editData', 'editTooltip', '-', 'editStyle', 'editGeometry', '-',
			                         'edit', '-', 'editLink', 'openLink', '-',
			                         'selectVertices', 'selectEdges', 'selectAll', 'selectNone', '-', 'lockUnlock']);
		})));

		var action = editorUi.actions.addAction('comments', mxUtils.bind(this, function()
		{
			if (this.commentsWindow == null)
			{
				// LATER: Check outline window for initial placement
				this.commentsWindow = new CommentsWindow(editorUi, document.body.offsetWidth - 380, 120, 300, 350);
				//TODO Are these events needed?
				this.commentsWindow.window.addListener('show', function()
				{
					editorUi.fireEvent(new mxEventObject('comments'));
				});
				this.commentsWindow.window.addListener('hide', function()
				{
					editorUi.fireEvent(new mxEventObject('comments'));
				});
				this.commentsWindow.window.setVisible(true);
				editorUi.fireEvent(new mxEventObject('comments'));
			}
			else
			{
				this.commentsWindow.window.setVisible(!this.commentsWindow.window.isVisible());
				this.commentsWindow.refreshCommentsTime();
			}
		}));
		action.setToggleAction(true);
		action.setSelectedCallback(mxUtils.bind(this, function() { return this.commentsWindow != null && this.commentsWindow.window.isVisible(); }));

		// Destroys comments window to force update or disable if not supported
		editorUi.editor.addListener('fileLoaded', mxUtils.bind(this, function()
		{
			if (this.commentsWindow != null)
			{
				this.commentsWindow.destroy();
				this.commentsWindow = null;
			}
		}));
		
		// Extends toolbar dropdown to add comments
		var viewPanelsMenu = this.get('viewPanels');
		var viewPanelsFunct = viewPanelsMenu.funct;
		
		viewPanelsMenu.funct = function(menu, parent)
		{
			viewPanelsFunct.apply(this, arguments);
			
			if (editorUi.commentsSupported())
			{
				editorUi.menus.addMenuItems(menu, ['comments'], parent);
			}
		};

		// Overrides view menu to add search and scratchpad
		this.put('view', new Menu(mxUtils.bind(this, function(menu, parent)
		{
			this.addMenuItems(menu, ((this.editorUi.format != null) ? ['formatPanel'] : []).
				concat(['outline', 'layers']).concat((editorUi.commentsSupported()) ?
				['comments', '-'] : ['-']));
			
			this.addMenuItems(menu, ['-', 'search'], parent);
			
			if (isLocalStorage || mxClient.IS_CHROMEAPP)
			{
				var item = this.addMenuItem(menu, 'scratchpad', parent);
				
				if (!editorUi.isOffline() || mxClient.IS_CHROMEAPP || EditorUi.isElectronApp)
				{
					this.addLinkToItem(item, 'https://desk.draw.io/support/solutions/articles/16000042367');
				}
			}
			
			this.addMenuItems(menu, ['shapes', '-', 'pageView', 'pageScale', '-',
			                         'scrollbars', 'tooltips', '-',
			                         'grid', 'guides'], parent);
			
			if (mxClient.IS_SVG && (document.documentMode == null || document.documentMode > 9))
			{
				this.addMenuItem(menu, 'shadowVisible', parent);
			}
			
			this.addMenuItems(menu, ['-', 'connectionArrows', 'connectionPoints', '-',
			                         'resetView', 'zoomIn', 'zoomOut'], parent);
		})));
		
		this.put('extras', new Menu(mxUtils.bind(this, function(menu, parent)
		{
			if (urlParams['embed'] != '1')
			{
				this.addSubmenu('theme', menu, parent);
				menu.addSeparator(parent);
			}
			
			this.addMenuItems(menu, ['copyConnect', 'collapseExpand', '-'], parent);

			if (typeof(MathJax) !== 'undefined')
			{
				var item = this.addMenuItem(menu, 'mathematicalTypesetting', parent);
				
				if (!editorUi.isOffline() || mxClient.IS_CHROMEAPP || EditorUi.isElectronApp)
				{
					this.addLinkToItem(item, 'https://desk.draw.io/support/solutions/articles/16000032875');
				}
			}
			
			if (urlParams['embed'] != '1')
			{
				this.addMenuItems(menu, ['autosave'], parent);
			}

			this.addMenuItems(menu, ['-', 'createShape', 'editDiagram'], parent);

			menu.addSeparator(parent);
			
			if (urlParams['embed'] != '1' && (isLocalStorage || mxClient.IS_CHROMEAPP))
			{
				this.addMenuItems(menu, ['showStartScreen'], parent);
			}

			if (!editorUi.isOfflineApp() && isLocalStorage)
			{
				this.addMenuItem(menu, 'plugins', parent);
			}

			menu.addSeparator(parent);
			this.addMenuItem(menu, 'tags', parent);
			
			// Adds trailing separator in case new plugin entries are added
			menu.addSeparator(parent);
			
			if (urlParams['newTempDlg'] == '1')
			{
				editorUi.actions.addAction('templates', function()
				{
					var tempDlg = new TemplatesDialog();
					editorUi.showDialog(tempDlg.container, tempDlg.width, tempDlg.height, true, false, null, false, true);
					tempDlg.init(editorUi, function(xml){console.log(xml)}, null,
							null, null, "user", function(callback, username)
					{
						setTimeout(function(){
							username? callback([
								{url: '123', title: 'Test 1Test 1Test 1Test 1Test 1Test 1Test 11Test 1Test 11Test 1Test 1dgdsgdfg fdg dfgdfg dfg dfg'},
								{url: '123', title: 'Test 2', imgUrl: 'https://www.google.com.eg/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png'},
								{url: '123', title: 'Test 3', changedBy: 'Ashraf Teleb', lastModifiedOn: 'Yesterday'},
								{url: '123', title: 'Test 4'},
								{url: '123', title: 'Test 5'},
								{url: '123', title: 'Test 6'}
							]) : callback([
								{url: '123', title: 'Test 4', imgUrl: 'https://images.pexels.com/photos/459225/pexels-photo-459225.jpeg'},
								{url: '123', title: 'Test 5'},
								{url: '123', title: 'Test 6'},
								{url: '123', title: 'Test 1Test 1Test 1Test 1Test 1Test 1Test 11Test 1Test 11Test 1Test 1dgdsgdfg fdg dfgdfg dfg dfg'},
								{url: '123', title: 'Test 2', imgUrl: 'https://www.google.com.eg/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png'},
								{url: '123', title: 'Test 3', changedBy: 'Ashraf Teleb', lastModifiedOn: 'Yesterday'}
							]);
							console.log(username);
						}, 1000);
					}, function(str, callback, username)
					{
						setTimeout(function(){
							callback(username? [
								{url: '123', title: str +'Test 1Test 1Test 1Test 1Test 1Test 1Test 1'},
								{url: '123', title: str +'Test 2'},
								{url: '123', title: str +'Test 3'},
								{url: '123', title: str +'Test 4'},
								{url: '123', title: str +'Test 5'},
								{url: '123', title: str +'Test 6'}
							]: [
								{url: '123', title: str +'Test 5'},
								{url: '123', title: str +'Test 6'},
								{url: '123', title: str +'Test 1Test 1Test 1Test 1Test 1Test 1Test 1'},
								{url: '123', title: str +'Test 2'},
								{url: '123', title: str +'Test 3'},
								{url: '123', title: str +'Test 4'}
							]);
						}, 2000);						
					}, null);
				});
				this.addMenuItem(menu, 'templates', parent);
			}
		})));

		this.put('file', new Menu(mxUtils.bind(this, function(menu, parent)
		{
			if (urlParams['embed'] == '1')
			{
				this.addSubmenu('importFrom', menu, parent);
				this.addSubmenu('exportAs', menu, parent);
				this.addSubmenu('embed', menu, parent);

				if (urlParams['libraries'] == '1')
				{
					this.addMenuItems(menu, ['-'], parent);
					this.addSubmenu('newLibrary', menu, parent);
					this.addSubmenu('openLibraryFrom', menu, parent);
				}
				
				if (editorUi.isRevisionHistorySupported())
				{
					this.addMenuItems(menu, ['-', 'revisionHistory'], parent);
				}
				
				this.addMenuItems(menu, ['-', 'pageSetup', 'print', '-', 'rename', 'save'], parent);
				
				if (urlParams['saveAndExit'] == '1')
				{
					this.addMenuItems(menu, ['saveAndExit'], parent);
				}
				
				this.addMenuItems(menu, ['exit'], parent);
			}
			else
			{
				var file = this.editorUi.getCurrentFile();
				
				if (file != null && file.constructor == DriveFile)
				{
					if (file.isRestricted())
					{
						this.addMenuItems(menu, ['exportOptionsDisabled'], parent);
					}
					
					this.addMenuItems(menu, ['save', '-', 'share'], parent);
					
					var item = this.addMenuItem(menu, 'synchronize', parent);
					
					if (!editorUi.isOffline() || mxClient.IS_CHROMEAPP || EditorUi.isElectronApp)
					{
						this.addLinkToItem(item, 'https://desk.draw.io/support/solutions/articles/16000087947');
					}
					
					menu.addSeparator(parent);
				}
				else
				{
					this.addMenuItems(menu, ['new'], parent);
				}
				
				//this.addSubmenu('openFrom', menu, parent);

				if (isLocalStorage)
				{
					//this.addSubmenu('openRecent', menu, parent);
				}
				
				if (file != null && file.constructor == DriveFile)
				{
					this.addMenuItems(menu, ['new', '-', 'rename', 'makeCopy', 'moveToFolder'], parent);
				}
				else
				{
					if (!mxClient.IS_CHROMEAPP && !EditorUi.isElectronApp &&
						file != null && file.constructor != LocalFile)
					{	
						menu.addSeparator(parent);
						var item = this.addMenuItem(menu, 'synchronize', parent);
						
						if (!editorUi.isOffline() || mxClient.IS_CHROMEAPP || EditorUi.isElectronApp)
						{
							this.addLinkToItem(item, 'https://desk.draw.io/support/solutions/articles/16000087947');
						}
					}
					
					this.addMenuItems(menu, ['-', 'save', 'saveAs'], parent);
					
					this.addMenuItems(menu, ['-', 'rename'], parent);

					if (editorUi.isOfflineApp())
					{
						if (navigator.onLine && urlParams['stealth'] != '1')
						{
							this.addMenuItems(menu, ['upload'], parent);
						}
					}
					else
					{
						this.addMenuItems(menu, ['makeCopy'], parent);
						
						if (file != null && file.constructor == OneDriveFile)
						{
							this.addMenuItems(menu, ['moveToFolder'], parent);
						}
					}
				}
				
				menu.addSeparator(parent);
				this.addSubmenu('importFrom', menu, parent);
				this.addSubmenu('exportAs', menu, parent);
				menu.addSeparator(parent);
				//this.addSubmenu('embed', menu, parent);
				//this.addSubmenu('publish', menu, parent);
				//menu.addSeparator(parent);
				//this.addSubmenu('newLibrary', menu, parent);
				//this.addSubmenu('openLibraryFrom', menu, parent);
				
				if (editorUi.isRevisionHistorySupported())
				{
					this.addMenuItems(menu, ['-', 'revisionHistory'], parent);
				}
				
				this.addMenuItems(menu, ['-', 'pageSetup'], parent);
				
				// Cannot use print in standalone mode on iOS as we cannot open new windows
				if (!mxClient.IS_IOS || !navigator.standalone)
				{
					this.addMenuItems(menu, ['print'], parent);
				}
				
				this.addMenuItems(menu, ['-', 'close']);
			}
		})));
	};
})();
