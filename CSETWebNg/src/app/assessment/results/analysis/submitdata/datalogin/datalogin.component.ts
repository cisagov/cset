import { Component, OnInit } from '@angular/core';
import { MatDialogRef } from '@angular/material';

@Component({
  selector: 'app-datalogin',
  templateUrl: './datalogin.component.html',
  styleUrls: ['./datalogin.component.scss'],
  host: {class: 'd-flex flex-column flex-11a'}
})
export class DataloginComponent implements OnInit {

  constructor(private dialog: MatDialogRef<DataloginComponent>) { }

  ngOnInit() {
  }

  close() {
    return this.dialog.close();
  }
}
