import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { DiagramService } from '../../../../../services/diagram.service';

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
    this.currentComponent.vendorName = this.currentComponent.vendor?.name ?? null;
    this.dialog.close();
  }

  save() {
    if (this.isAddingVendor) {
      this.currentComponent.vendorName = this.newName;
    }

    if (this.isAddingProduct) {
      this.currentComponent.productName = this.newName;
    }

    this.dialog.close();
  }

  isNewNameValid() {
    if (!this.newName) {
      return false;
    }

    if (this.isAddingVendor && !!this.diagramSvc.csafVendors.find(v => v.name.toLowerCase() === this.newName.toLowerCase())) {
      return false;
    }

    return true;
  }
}
