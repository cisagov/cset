import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Sort } from '@angular/material/sort';
import { Product, Vendor } from '../diagram-components.component';

@Component({
  selector: 'app-alerts-and-advisories',
  templateUrl: './alerts-and-advisories.component.html',
  styleUrls: ['./alerts-and-advisories.component.scss']
})
export class AlertsAndAdvisoriesComponent implements OnInit {

  product: Product;
  vendor: Vendor;

  constructor(
    private dialog: MatDialogRef<AlertsAndAdvisoriesComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any
  ) { this.product = data.product; this.vendor = data.vendor; console.log(this.product.vulnerabilities) }

  ngOnInit(): void { }

  close() {
    return this.dialog.close();
  }

  sortData(sort: Sort) {
    if (!sort.active || sort.direction === "") {
      return;
    }

    //TODO: Implement column sorting
  }

  getCveScoreColor(score: number) {
    if (score >= 7) {
      return '#DC3545'; // red
    }

    if (score >= 4 && score < 7) {
      return '#FFC107'; // yellow
    }

    if (score < 4) {
      return '#28A745'; // green
    }
  }

  getCveScoreLevel(score: number) {
    if (score >= 7) {
      return `${score} HIGH`
    }

    if (score >= 4 && score < 7) {
      return `${score} MEDIUM`;
    }

    if (score < 4) {
      return `${score} LOW`;
    }
  }

  getCveUrl(cve: string) {
    return 'https://nvd.nist.gov/vuln/detail/' + cve;
  }
}
