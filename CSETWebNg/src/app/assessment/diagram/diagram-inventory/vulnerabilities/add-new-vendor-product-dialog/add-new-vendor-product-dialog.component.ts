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
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { DiagramService } from '../../../../../services/diagram.service';
import { Vendor, Product } from './../../../../../models/diagram-vulnerabilities.model';

@Component({
  selector: 'app-add-new-vendor-product-dialog',
  templateUrl: './add-new-vendor-product-dialog.component.html',
  styleUrls: ['./add-new-vendor-product-dialog.component.scss']
})
export class AddNewVendorProductDialogComponent implements OnInit {

  isAddingVendor: boolean;
  isAddingProduct: boolean;
  currentComponent: any;
  newName: string;

  constructor(
    private diagramSvc: DiagramService,
    private dialog: MatDialogRef<AddNewVendorProductDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any
    ) {
      this.isAddingVendor = data.isAddingVendor ?? false;
      this.isAddingProduct = data.isAddingProduct ?? false;
      this.currentComponent = data.currentComponent;
    }

  ngOnInit(): void {
  }

  cancel() {
    if (this.isAddingVendor) {
      this.currentComponent.vendorName =  this.currentComponent.vendor?.name ?? null;
    }

    if (this.isAddingProduct) {
      this.currentComponent.productName = this.currentComponent.product?.name ?? null;
    }

    this.dialog.close(false);
  }

  save() {
    if (this.isAddingVendor) {
      this.currentComponent.vendorName = this.newName;
      this.currentComponent.vendor = new Vendor(this.newName);
    }

    if (this.isAddingProduct) {
      this.currentComponent.productName = this.newName;
      const newProduct = new Product(this.newName);
      this.currentComponent.product = newProduct;
      this.currentComponent.vendor.products.unshift(newProduct);
    }

    this.dialog.close(true);
  }

  isNewNameValid() {
    if (!this.newName) {
      return false;
    }

    if (this.isAddingVendor && this.diagramSvc.csafVendors.some(v => v.name.toLowerCase() === this.newName.toLowerCase())) {
      return false;
    }

    if (this.isAddingProduct && this.currentComponent.vendor.products.some(p => p.name.toLowerCase() === this.newName.toLowerCase())) {
      return false;
    }

    return true;
  }
}
