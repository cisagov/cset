import { Component, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
  
@Component({
  selector: 'charter-mismatch',
  templateUrl: 'charter-mismatch.component.html',
})
export class CharterMismatchComponent {
  
  constructor(
    public dialogRef: MatDialogRef<CharterMismatchComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any) { }
  
  confirmWarning(): void {
    this.dialogRef.close();
  }
  
}