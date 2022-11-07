import { Component, OnInit } from '@angular/core';
import { MatDialogRef } from '@angular/material/dialog';
import { Sort } from '@angular/material/sort';

@Component({
  selector: 'app-alerts-and-advisories',
  templateUrl: './alerts-and-advisories.component.html',
  styleUrls: ['./alerts-and-advisories.component.scss']
})
export class AlertsAndAdvisoriesComponent implements OnInit {

  constructor(private dialog: MatDialogRef<AlertsAndAdvisoriesComponent>) { }

  ngOnInit(): void {
  }

  close() {
    return this.dialog.close();
  }

  sortData(sort: Sort) {
    if (!sort.active || sort.direction === "") {
      return;
    }

    //TODO: Implement column sorting
  }
}
