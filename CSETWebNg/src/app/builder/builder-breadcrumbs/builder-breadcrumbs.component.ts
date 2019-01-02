////////////////////////////////
//
//   Copyright 2018 Battelle Energy Alliance, LLC
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
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-builder-breadcrumbs',
  templateUrl: './builder-breadcrumbs.component.html'
})
export class BuilderBreadcrumbsComponent implements OnInit {

  json: IDataNode;
  currentPage: IDataNode;

  constructor(private router: Router) { }

  ngOnInit() {
    this.initializeStructure();
  }

  displayCrumbs() {

    // find the current entry in the structure
    if (this.router.url === this.json.navPath) {
      return "Home";
    }

    // console.log(this.router.url);


    // recurse parent to parent
    const dddd = this.findNode(this.router.url, this.json);
    // console.log(dddd);

    if (!dddd) {
      return "Home?";
    }
  }

  findNode(path, currentNode) {
    let i = 0;
    let currentChild: IDataNode = null;
    let result: any = null;

    const urlTree = this.router.parseUrl(path);

    // console.log('parsed URL:');
    // console.log(this.router.parseUrl(path));


    if (path === currentNode.navPath) {
      return currentNode;
    } else if (urlTree.root.segments[0] === currentNode.navPath) {
      return currentNode;
    } else {

      for (i = 0; i < currentNode.children.length; i += 1) {
        currentChild = currentNode.children[i];

        // Search in the current child
        result = this.findNode(path, currentChild);

        // Return the result if the node has been found
        if (result !== false) {
          return result;
        }
      }

      // The node has not been found and we have no more options
      return false;
    }
  }


  /**
   * Builds the nav structure.
   */
  initializeStructure() {
    this.json = {
      "displayName": "Home",
      "navPath": "/set-builder",
      "children": [
        {
          "displayName": "Set Detail",
          "navPath": "/custom-set",
          "children": [
            {
              "displayName": "Question List",
              "navPath": "questionList",
              "children": [
                {
                  "displayName": "Question",
                  "navPath": "",
                  "children": []
                }
              ]
            },
            {
              "displayName": "Requirement List",
              "navPath": "",
              "children": [
                {
                  "displayName": "Requirement Detail",
                  "navPath": "",
                  "children": []
                }
              ]
            }
          ]
        }
      ]
    };
  }
}


interface IDataNode {
  displayName: string;
  navPath: string;
  children: Array<IDataNode>;
}
