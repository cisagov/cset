import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Sort } from '@angular/material/sort';
import { Product, Vendor } from '../diagram-components.component';

interface cveWarning {
  level: string;
  color: string;
}

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
  ) { this.product = data.product; this.vendor = data.vendor;  }

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

  getCveWarning(score: number): cveWarning {

    if (score >= 9) {
      return { level: 'CRITICAL', color: '#000000' }; // black
    }

    if (score >= 7 && score < 9) {
      return { level: 'HIGH', color: '#d9534f' }; // red
    }

    if (score >= 4 && score < 7) {
      return { level: 'MEDIUM', color: '#ec971f' }; // yellowish orange
    }

    if (score < 4) {
      return { level: 'LOW', color: '#53aa33' }; // green
    }
  }

  getCveUrl(cve: string) {
    return 'https://nvd.nist.gov/vuln/detail/' + cve;
  }
}
