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
import { Component, OnInit, Output, EventEmitter } from '@angular/core';
import { DiagramService } from '../../../../services/diagram.service';
import { Sort } from "@angular/material/sort";
import { Comparer } from '../../../../helpers/comparer';
import { MatDialog } from '@angular/material/dialog';
import { DiagramVulnerabilitiesDialogComponent } from './diagram-vulnerabilities-dialog/diagram-vulnerabilities-dialog';
import { Vendor, Product } from '../../../../models/diagram-vulnerabilities.model';
import { ConfirmComponent } from '../../../../dialogs/confirm/confirm.component';

@Component({
  selector: 'app-diagram-vulnerabilities',
  templateUrl: './diagram-vulnerabilities.component.html',
  styleUrls: ['./diagram-vulnerabilities.component.scss']
})
export class DiagramVulnerabilitiesComponent implements OnInit {

  diagramComponentList: any[] = [];

  @Output()
  componentsChange = new EventEmitter<any>();

  comparer: Comparer = new Comparer();
  sal: any;
  criticality: any;

  filteredVendorOptions: Vendor[];
  filteredProductOptions: Product[];

  loading: boolean = false;

  /**
   *
   */
  constructor(
    public diagramSvc: DiagramService,
    private dialog: MatDialog,
  ) { }

  /**
   *
   */
  ngOnInit() {
    // Only hit the api if the service does not yet have the vendors array populated.
    if (this.diagramSvc.csafVendors.length === 0) {
      this.diagramSvc.getVulnerabilities().subscribe((vendors: Vendor[]) => {
        this.diagramSvc.csafVendors = vendors;
        this.getComponents();
      });
    } else {
      this.getComponents()
    }
  }

  filterVendors(value: string) {
    let val = "";
    if (typeof value === 'string') {
      val = value;
    }
    const name = val;
    const filterValue = name.toLowerCase();
    this.filteredVendorOptions = this.diagramSvc.csafVendors.filter(option => option.name?.toLowerCase().includes(filterValue));
  }

  filterProducts(value: string, products: Product[]) {
    let val = "";
    if (typeof value === 'string') {
      val = value;
    }
    const name = val;
    const filterValue = name.toLowerCase();
    this.filteredProductOptions = products?.filter(option => option.name?.toLowerCase().includes(filterValue)) ?? [];
  }

  clearVendorFilterOptions() {
    this.filteredVendorOptions = [];
  }

  clearProductFilterOptions() {
    this.filteredProductOptions = [];
  }

  /**
   *
   */
  getComponents() {
    this.diagramSvc.getDiagramComponents().subscribe((x: any) => {
      this.diagramComponentList = x;
      this.diagramComponentList.forEach(component => {
        this.updateComponentVendorAndProduct(component);
      })
      this.componentsChange.emit(this.diagramComponentList);
    });
  }

  saveComponent(component) {
    if (!!component.vendorName && !this.diagramSvc.csafVendors.find(vendor => vendor.name === component.vendorName)) {
      this.addNewVendor(component);
    } else if (!!component.productName && !!component.vendor && !component.vendor.products.find(product => product.name === component.productName)) {
      this.addNewProduct(component);
    } else {
      this.updateComponentVendorAndProduct(component);
    }
    this.diagramSvc.saveComponent(component).subscribe();
  }

  showVulnerabilities(component) {
    this.dialog.open(DiagramVulnerabilitiesDialogComponent, {
      data: { product: component.product, vendor: component.vendor }
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
        case "assetType":
          return this.comparer.compare(a.assetType, b.assetType, isAsc);
        case "vendorName":
          return this.comparer.compare(a.vendorName, b.vendorName, isAsc);
        case "productName":
          return this.comparer.compare(a.productName, b.productName, isAsc);
        case "version":
          return this.comparer.compare(a.versionName, b.versionName, isAsc);
        case "serialNumber":
          return this.comparer.compare(a.serialNumber, b.serialNumber, isAsc);
        case "physicalLocation":
          return this.comparer.compare(a.physicalLocation, b.physicalLocation, isAsc);
        default:
          return 0;
      }
    });
  }

  updateComponentVendorAndProduct(component) {
    component.vendor = this.diagramSvc.csafVendors.find(v => v.name === component.vendorName) ?? null;
    component.product = component.vendor?.products.find(p => p.name === component.productName) ?? null;

    if (!component.product) {
      component.productName = null;
    }

    if (!component.vendor) {
      component.vendorName = null;
    }
  }

  isShowVulnerabilitiesButtonDisabled(component) {
    if (!component.vendor || !component.product) {
      return true;
    }

    if (component.vendor?.products.find(p => p.name === component.productName)?.vulnerabilities.length === 0) {
      return true;
    }

    return false;
  }

  getVendors() {
    return this.diagramSvc.csafVendors;
  }

  addNewVendor(component) {
    if (!component.vendorName) {
      return;
    }

    component.vendor = new Vendor(component.vendorName);
    this.diagramSvc.saveCsafVendor(component.vendor).subscribe((vendor: Vendor) => {
      this.diagramSvc.csafVendors.unshift(vendor);
    });
  }

  addNewProduct(component) {
    if (!component.productName) {
      return;
    }

    const newProduct = new Product(component.productName);
    component.product = newProduct;
    component.vendor.products.unshift(newProduct);
    this.diagramSvc.saveCsafVendor(component.vendor).subscribe((vendor: Vendor) => {
      let index = this.diagramSvc.csafVendors.findIndex(v => v.name === vendor.name);
      this.diagramSvc.csafVendors[index] = vendor;
    });
  }

  deleteVendor(vendorName: string) {
    const dialogRef = this.dialog.open(ConfirmComponent);
    dialogRef.componentInstance.confirmMessage = `Are you sure you want to delete \"${vendorName}\" from the vendor list?`;

    dialogRef.afterClosed().subscribe(deleteConfirmed => {
      if (deleteConfirmed) {
        this.diagramSvc.deleteCsafVendor(vendorName).subscribe(() => {
          let removeIndex = this.diagramSvc.csafVendors.findIndex(vendor => vendor.name === vendorName);
          if (removeIndex > -1) {
            this.diagramSvc.csafVendors.splice(removeIndex, 1);
          }

          this.diagramComponentList.forEach(component => {
            if (component.vendorName === vendorName) {
              component.vendorName = null;
              this.saveComponent(component);
            }
          });
        });
      }
    });
  }

  deleteProduct(vendorName: string, productName: string) {
    const dialogRef = this.dialog.open(ConfirmComponent);
    dialogRef.componentInstance.confirmMessage = `Are you sure you want to delete \"${productName}\" from the product list?`;

    dialogRef.afterClosed().subscribe(deleteConfirmed => {
      if (deleteConfirmed) {
        this.diagramSvc.deleteCsafProduct(vendorName, productName).subscribe(() => {
          let vendorsWithProduct: Vendor[] = this.diagramSvc.csafVendors.filter(vendor => vendor.products.find(product => product.name === productName));
          vendorsWithProduct.forEach(vendor => {
            vendor.products.splice(vendor.products.findIndex(product => product.name === productName), 1);
          });

          this.diagramComponentList.forEach(component => {
            if (component.productName === productName) {
              component.productName = null;
              this.saveComponent(component);
            }
          });
        });
      }
    });
  }
}
