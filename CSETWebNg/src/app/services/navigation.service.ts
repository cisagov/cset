////////////////////////////////
//
//   Copyright 2019 Battelle Energy Alliance, LLC
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
import { NestedTreeControl } from "@angular/cdk/tree";
import { EventEmitter, Injectable, Output } from "@angular/core";
import { MatTreeNestedDataSource } from "@angular/material";
import { of as observableOf } from "rxjs";

export interface NavTree {
  children?: NavTree[];
  label?: string;
  value?: any;
  DatePublished?: string;
  HeadingTitle?: string;
  HeadingText?: string;
  DocId?: string;
  elementType?: string;
}

@Injectable({
  providedIn: "root"
})
export class NavigationService {
  @Output()
  itemSelected = new EventEmitter<any>();
  dataSource: MatTreeNestedDataSource<NavTree> = new MatTreeNestedDataSource<NavTree>();
  treeControl: NestedTreeControl<NavTree> = new NestedTreeControl<NavTree>(x => observableOf(x.children));
  disableCollapse: boolean;
  private magic: string;
  activeResultsView: string;

  constructor() {}

  getMagic() {
    this.magic = (Math.random() * 1e5).toFixed(0);
    return this.magic;
  }

  setTree(data: NavTree[], magic: string, collapsible = false) {
    if (this.magic === magic) {
      this.treeControl = new NestedTreeControl<NavTree>((node: NavTree) => {
        return observableOf(node.children);
      });
      this.dataSource = new MatTreeNestedDataSource<NavTree>();
      this.dataSource.data = data;
      this.disableCollapse = !collapsible;
    }
  }

  hasNestedChild(_: number, node: NavTree) {
    return node.children.length > 0;
  }

  selectItem(value: string) {
    this.itemSelected.emit(value);
  }

  /**
   * Recurses the tree to find the specified value.
   * @param tree
   * @param value
   */
  isPathInTree(tree: NavTree[], path: string): boolean {
    for (let index = 0; index < tree.length; index++) {
      const t = tree[index];

      if (t.value === path) {
        return true;
      }

      if (this.isPathInTree(t.children, path)) {
        return true;
      }
    }
    return false;
  }
}
