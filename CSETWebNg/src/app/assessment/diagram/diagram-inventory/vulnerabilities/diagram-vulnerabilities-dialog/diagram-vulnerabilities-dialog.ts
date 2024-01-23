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
import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Sort } from '@angular/material/sort';
import { Product, Vendor, Vulnerability } from '../../../../../models/diagram-vulnerabilities.model';
import { Comparer } from '../../../../../helpers/comparer';

interface cveWarning {
  level: string;
  color: string;
}

@Component({
  selector: 'app-diagram-vulnerabilities-dialog',
  templateUrl: './diagram-vulnerabilities-dialog.component.html',
  styleUrls: ['./diagram-vulnerabilities-dialog.component.scss']
})
export class DiagramVulnerabilitiesDialogComponent implements OnInit {

  product: Product;
  vendor: Vendor;

  comparer: Comparer = new Comparer();

  constructor(
    private dialog: MatDialogRef<DiagramVulnerabilitiesDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any
  ) { this.product = data.product; this.vendor = data.vendor; }

  ngOnInit(): void { }

  close() {
    this.dialog.close();
  }

  sortData(sort: Sort) {
    if (!sort.active || sort.direction === "") {
      return;
    }

    //TODO: Implement column sorting for commented out columns
    this.product.vulnerabilities.sort((a: Vulnerability, b: Vulnerability) => {
      const isAsc = sort.direction === "asc";
      switch (sort.active) {
        case "cve":
          return this.comparer.compare(a.cve, b.cve, isAsc);
        case "score":
          return this.comparer.compare(a.scores[0].cvss_V3.baseScore, b.scores[0].cvss_V3.baseScore, isAsc);
        case "version":
          return this.comparer.compare(this.product.affectedVersions, this.product.affectedVersions, isAsc);
        case "linkDetails":
          return this.comparer.compare(this.getCveUrl(a.cve), this.getCveUrl(b.cve), isAsc);
        case "linkWebsite":
          return this.comparer.compare(this.getVendorUrl(a.remediations), this.getVendorUrl(b.remediations), isAsc);
        default:
          return 0;
      }
    });
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

  getVendorUrl(remediations: any[]) {
    return remediations.find(r => !r.url.includes('cisa.gov') && !r.url.includes('nist.gov'))?.url;
  }

  getFirstOrgUrl(vulnerability) {
    return vulnerability.references.find(r => r.summary.includes('first.org')).url
  }
}
