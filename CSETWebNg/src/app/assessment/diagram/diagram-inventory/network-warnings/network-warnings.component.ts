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
import { Component, OnInit } from '@angular/core';
import { DiagramService } from '../../../../services/diagram.service';
import { Sort } from "@angular/material/sort";
import { Comparer } from '../../../../helpers/comparer';

@Component({
  selector: 'networkwarnings',
  templateUrl: './network-warnings.component.html',
  styleUrls: ['./network-warnings.component.scss']
})
export class NetworkWarningsComponent implements OnInit {
  warnings = [];
  displayedColumns = ['Id', 'WarningText'];
  comparer: Comparer = new Comparer();

  /**
   *
   * @param diagramSvc
   */
  constructor(public diagramSvc: DiagramService) { }

  ngOnInit() {
    this.getWarnings();
  }

  getWarnings() {
    this.diagramSvc.getDiagramWarnings().subscribe((x: any) => {
      this.warnings = x;
    });
  }

  sortData(sort: Sort) {

    if (!sort.active || sort.direction === "") {
      return;
    }

    this.warnings.sort((a, b) => {
      const isAsc = sort.direction === "asc";
      switch (sort.active) {
        case "id":
          return this.comparer.compare(a.id, b.id, isAsc);
        case "message":
          return this.comparer.compare(a.warningText, b.warningText, isAsc);
        default:
          return 0;
      }
    });
  }
}
