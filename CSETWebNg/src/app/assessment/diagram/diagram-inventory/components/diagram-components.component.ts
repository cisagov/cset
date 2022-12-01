////////////////////////////////
//
//   Copyright 2022 Battelle Energy Alliance, LLC
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
import { MatDialog } from '@angular/material/dialog';
import { AlertsAndAdvisoriesComponent } from './alerts-and-advisories/alerts-and-advisories.component';
import { AlertsAndAdvisoriesService } from '../../../../services/alerts-and-advisories.service';

export interface Vendor {
  name: string;
  products: Product[];
}

export interface Product {
  name: string;
  vulnerabilities: Vulnerability[];
  versions: { name: string; product_Id: string }[]
}

interface Vulnerability {
  cve: string;
  cwe: any;
  notes: any[];
  product_Status: any;
  references: any[];
  remediations: any[];
  scores: any[];
  title: string;
}

@Component({
  selector: 'app-diagram-components',
  templateUrl: './diagram-components.component.html',
  styleUrls: ['./diagram-components.component.scss']
})
export class DiagramComponentsComponent implements OnInit {

  diagramComponentList: any;
  loading: boolean = true;

  @Output()
  componentsChange = new EventEmitter<any>();

  comparer: Comparer = new Comparer();
  displayedColumns = ['tag', 'hasUniqueQuestions', 'sal', 'criticality', 'layerC', 'ipAddress', 'assetType', 'zone', 'subnetName', 'description', 'hostName', 'visibleC'];
  assetTypes: any;
  sal: any;
  criticality: any;
  vendors: Vendor[] = [];

  /**
   *
   */
  constructor(
    public diagramSvc: DiagramService,
    private dialog: MatDialog,
    private alertsAndAdvisoriesSvc: AlertsAndAdvisoriesService
  ) { }

  /**
   *
   */
  ngOnInit() {
    this.diagramSvc.getAllSymbols().subscribe((x: any) => {
      this.assetTypes = x;
    });

    this.alertsAndAdvisoriesSvc.getAlertsAndAdvisories().subscribe((csafs: any[]) => {
      this.processVendorNames(csafs);
      this.processProductNames(csafs);
    })

  }

  /**
   *
   */
  getComponents() {
    this.diagramSvc.getDiagramComponents().subscribe((x: any) => {
      this.diagramComponentList = x;
      this.diagramComponentList.forEach(component => {
        this.updateComponentVendor(component);
      })
      this.componentsChange.emit(this.diagramComponentList);
      this.loading = false;
    });
  }

  saveComponent(component) {
    this.updateComponentVendor(component);
    this.diagramSvc.saveComponent(component).subscribe();
  }

  showAlertsAndAdvisories(component) {
    this.dialog.open(AlertsAndAdvisoriesComponent, {
      data: { product: component.vendor.products.find(p => p.name === component.productName), vendor: component.vendor }
    });
  }

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
        case "vendorName":
          return this.comparer.compareBool(a.vendorName, b.vendorName, isAsc);
        case "productName":
          return this.comparer.compareBool(a.productName, b.productName, isAsc);
        case "version":
          return this.comparer.compareBool(a.versionName, b.versionName, isAsc);
        case "serialNumber":
          return this.comparer.compareBool(a.serialNumber, b.serialNumber, isAsc);
        case "physicalLocation":
          return this.comparer.compareBool(a.physicalLocation, b.physicalLocation, isAsc);
        default:
          return 0;
      }
    });
  }

  // Parse vendor names from CSAF files.
  processVendorNames(csafs) {
    csafs.forEach(advisory => {
      const vendor: Vendor = { name: advisory.product_Tree.branches[0].name, products: [] }
      if (!this.vendors.find(e => e.name === vendor.name)) {
        this.vendors.push(vendor);
      }
    });
  }

  // Parse product names from CSAF files. Products are tied to vendors. CVEs are then tied to products.
  processProductNames(csafs) {
    csafs.forEach(advisory => {
      const product: Product = {
        name: advisory.product_Tree.branches[0].branches[0].name,
        vulnerabilities: advisory.vulnerabilities,
        versions: []
      };

      advisory.product_Tree.branches[0].branches.forEach(branch => {
        product.versions.push({ name: branch.branches[0].name, product_Id: branch.branches[0].product.product_Id})
      })

      const vendor: Vendor = this.vendors.find(v => v.name === advisory.product_Tree.branches[0].name);

      if (vendor && !vendor.products.find(p => p.name === product.name)) {
        vendor.products.push(product);
      }
    });

    this.getComponents();
  }

  updateComponentVendor(component) {
    if (!component.vendorName) {
      return;
    }

    component.vendor = this.vendors.find(v => v.name === component.vendorName);
  }
}
