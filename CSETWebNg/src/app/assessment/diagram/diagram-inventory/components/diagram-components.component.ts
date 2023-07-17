////////////////////////////////
//
//   Copyright 2023 Battelle Energy Alliance, LLC
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
import { Component, OnInit, Output, EventEmitter } from '@angular/core';
import { DiagramService } from '../../../../services/diagram.service';
import { Sort } from "@angular/material/sort";
import { Comparer } from '../../../../helpers/comparer';

@Component({
  selector: 'app-diagram-components',
  templateUrl: './diagram-components.component.html',
  styleUrls: ['./diagram-components.component.scss']
})
export class DiagramComponentsComponent implements OnInit {

  diagramComponentList: any[] = [];

  @Output()
  componentsChange = new EventEmitter<any>();

  comparer: Comparer = new Comparer();
  assetTypes: any;
  sal: any;
  criticality: any;

  /**
   * A flattened list of all the component symbols CSET supports
   */
  symbols: any[];

  /**
   *
   */
  constructor(
    public diagramSvc: DiagramService
  ) { }

  /**
   *
   */
  ngOnInit() {
    this.getComponents();
    this.getSymbols();
  }

  /**
   *
   */
  getComponents() {
    this.diagramSvc.getDiagramComponents().subscribe((x: any) => {
      this.diagramComponentList = x;
      console.log(this.diagramComponentList)
      this.componentsChange.emit(this.diagramComponentList);
    });
  }

  /**
   * Gets the full list of symbols so that we 
   * can build SELECT controls for Asset Type.
   */
  getSymbols() {
    this.diagramSvc.getSymbols().subscribe((g: any) => {
      this.symbols = [];
      g.forEach(gg => {
        gg.symbols.forEach(s => {
          this.symbols.push(s);
        });
      });

      this.symbols.sort((a, b) => a.symbol_Name.localeCompare(b.symbol_Name));
    });
  }

  /**
   * 
   */
  changeAssetType(evt: any, guid: string) {
    let componentGuid = guid;
    let newType = evt.target.value;
    this.diagramSvc.updateAssetType(componentGuid, newType).subscribe();
  }

  /**
   * 
   */
  sortData(sort: Sort) {
    if (!sort.active || sort.direction === "") {
      return;
    }

    this.diagramComponentList.sort((a, b) => {
      const isAsc = sort.direction === "asc";
      switch (sort.active) {
        case "label":
          return this.comparer.compare(a.label, b.label, isAsc);
        case "hasUniqueQuestions":
          return this.comparer.compareBool(a.hasUniqueQuestions, b.hasUniqueQuestions, isAsc);
        case "sal":
          return this.comparer.compare(a.sal, b.sal, isAsc);
        case "criticality":
          return this.comparer.compare(a.criticality, b.criticality, isAsc);
        case "layer":
          return this.comparer.compare(a.layerName, b.layerName, isAsc);
        case "ipAddress":
          return this.comparer.compare(a.ipAddress, b.ipAddress, isAsc);
        case "assetType":
          return this.comparer.compare(a.assetType, b.assetType, isAsc);
        case "zone":
          return this.comparer.compare(a.zoneLabel, b.zoneLabel, isAsc);
        case "description":
          return this.comparer.compare(a.description, b.description, isAsc);
        case "hostName":
          return this.comparer.compare(a.hostName, b.hostName, isAsc);
        case "visible":
          return this.comparer.compareBool(a.visible, b.visible, isAsc);
        default:
          return 0;
      }
    });
  }
}
