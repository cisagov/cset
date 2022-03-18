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
import { Component, OnInit } from '@angular/core';
import { AssessmentService } from './../../../../services/assessment.service';
import { DemographicService } from './../../../../services/demographic.service';
import { CsiServiceComposition } from './../../../../models/csi.model';

@Component({
  selector: 'app-csi-service-composition',
  templateUrl: './csi-service-composition.component.html'
})
export class CsiServiceCompositionComponent implements OnInit {

  serviceComposition: CsiServiceComposition = {};

  constructor(private demoSvc: DemographicService, private assessSvc: AssessmentService) { }

  ngOnInit(): void {
    // this.demoSvc.getAllCsiStaffCounts().subscribe(
    //   (data: CsiStaffCount[]) => {
    //       this.staffCountsList = this.filterStaffCounts(data);
    //       this.cyberStaffCountsList = this.filterCyberStaffCounts(data);
    //   },
    //   error => {
    //       console.log('Error Getting all CSI staff count options: ' + (<Error>error).name + (<Error>error).message);
    // });

    if (this.assessSvc.id()) {
      this.getCsiServiceComposition();
    }
  }

  update() {
    this.demoSvc.updateCsiServiceComposition(this.serviceComposition);
  }

  getCsiServiceComposition() {
    this.demoSvc.getCsiServiceComposition().subscribe(
        (data: CsiServiceComposition) => {
          this.serviceComposition = data;
        },
        error => console.log('CIST CSI service composition load Error: ' + (<Error>error).message)
    );
  }

}
