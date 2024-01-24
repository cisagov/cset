////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { Component, AfterContentInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { SetBuilderService } from '../../services/set-builder.service';
import { Title } from '@angular/platform-browser';
import { ConfigService } from '../../services/config.service';

@Component({
  selector: 'app-builder-breadcrumbs',
  templateUrl: './builder-breadcrumbs.component.html'
})
export class BuilderBreadcrumbsComponent implements AfterContentInit {

  breadcrumbs: IBreadcrumb[] = [];
  activatedRoute: ActivatedRoute;


  constructor(
    public router: Router,
    private ar: ActivatedRoute,
    private setBuilderSvc: SetBuilderService,
    private configSvc: ConfigService,
    private titleSvc: Title
  ) {
    this.activatedRoute = ar;
  }

  ngAfterContentInit() {
    // Because this component is only used in the Module Builder, set the browser title here.
    this.titleSvc.setTitle('Module Builder - ' + this.configSvc.behaviors.defaultTitle);

    if (!this.setBuilderSvc.navXml) {
      // read XML and populate my local document
      this.setBuilderSvc.readBreadcrumbXml().subscribe((x: any) => {
        const oParser = new DOMParser();
        this.setBuilderSvc.navXml = oParser.parseFromString(x, 'application/xml');
        this.displayCrumbs();
      });
    } else {
      this.displayCrumbs();
    }
  }

  /**
   * Renders the breadcrumb trail based on the current route.
   */
  displayCrumbs() {
    // get the id parameter in the route (if it exists)
    const params = this.activatedRoute.snapshot.params.id;

    // now get the path without params (assuming that params are the last segment)
    const justPath = this.activatedRoute.snapshot.url;
    if (justPath[justPath.length - 1].path === params) {
      justPath.pop();
    }
    const justPathString = justPath.join('');

    // Find the target page we just landed on, set it current and set any parm.
    let targetPage = this.findPage(justPathString);
    if (targetPage !== null) {
      this.resetCurrentPage();
      (<Element>targetPage).setAttribute('current', 'true');

      if (!!params) {
        (<Element>targetPage).setAttribute('parm', params);
      }
    }

    // If we can't find the specified page, just render a Home link as a safety
    if (!targetPage) {
      const bHome: IBreadcrumb = { displayName: 'Home', navPath: '/set-list', parms: '' };
      this.breadcrumbs.push(bHome);

      const bHere: IBreadcrumb = { displayName: '', navPath: '', parms: '' };
      this.breadcrumbs.push(bHere);
      return;
    }

    // walk up the tree, building a stack
    const stack = [];
    while (!!targetPage && targetPage.nodeName === 'Page') {
      stack.push(<Element>targetPage);
      targetPage = targetPage.parentNode;
    }

    // pull off the stack, building a nav list
    let crumb: IBreadcrumb = null;
    while (stack.length > 0) {
      const bbb: Element = stack.pop();
      crumb = { displayName: bbb.getAttribute('displayname'), navPath: bbb.getAttribute('navpath'), parms: null };
      if (!!bbb.getAttribute('parm')) {
        crumb.parms = bbb.getAttribute('parm');
      }
      this.breadcrumbs.push(crumb);
    }
  }

  /**
   * Turn off all 'current' attributes
   */
  resetCurrentPage() {
    const result = this.setBuilderSvc.navXml
      .evaluate('/Top//Page[@current="true"]',
        this.setBuilderSvc.navXml, null,
        XPathResult.ANY_TYPE, null);

    const e = result.iterateNext();
    if (!!e) {
      (<Element>e).setAttribute('current', 'false');
    }
  }

  /**
   * See if the target page exists in multiple places in the tree
   * If so, find the one that is a child of the 'current' page
   */
  findPage(curPage: string) {

    let xPath = '/Top//Page[@navpath="' + curPage + '"]';
    let result = this.setBuilderSvc.navXml
      .evaluate(xPath,
        this.setBuilderSvc.navXml, null,
        XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);

    // if there's a single occurrence of the page, return it.
    if (result.snapshotLength === 1) {
      return result.snapshotItem(0);
    }

    // find the version of the target page that is a child of the 'current' page
    xPath = '/Top//Page[@current="true"]//Page[@navpath="' + curPage + '"]';
    result = this.setBuilderSvc.navXml
      .evaluate(xPath,
        this.setBuilderSvc.navXml, null,
        XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
    if (result.snapshotLength > 0) {
      return result.snapshotItem(0);
    }

    // find the version of the target page that is a parent of the 'current' page
    xPath = '/Top//Page[@navpath="' + curPage + '" and .//Page/@current="true"]';
    result = this.setBuilderSvc.navXml
      .evaluate(xPath,
        this.setBuilderSvc.navXml, null,
        XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
    if (result.snapshotLength > 0) {
      return result.snapshotItem(0);
    }

    return null;
  }

  /**
   * Build a navigation object based on the path and any parms
   */
  navToCrumb(crumb: IBreadcrumb) {
    const ppp = ['/', crumb.navPath];
    if (!!crumb.parms && crumb.parms.length > 0) {
      ppp.push(crumb.parms);
    }
    this.router.navigate(ppp);
  }
}

/**
 *
 */
interface IBreadcrumb {
  displayName: string;
  navPath: string;
  parms: string;
}
