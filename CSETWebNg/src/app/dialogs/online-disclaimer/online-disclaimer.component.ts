import { Component, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
  selector: 'app-online-disclaimer',
  templateUrl: './online-disclaimer.component.html'
})
export class OnlineDisclaimerComponent {

  constructor(private dialog: MatDialogRef<OnlineDisclaimerComponent>, @Inject(MAT_DIALOG_DATA) public data: any) { }

  close() {
    this.dialog.close();
  }
}
