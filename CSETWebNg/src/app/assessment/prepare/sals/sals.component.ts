////////////////////////////////
//
//   Copyright 2019 Battelle Energy Alliance, LLC
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
import { Component, OnInit, AfterViewInit } from '@angular/core';
import { SalService } from '../../../services/sal.service';
import { Sal } from '../../../models/sal.model';
import { AssessmentService } from '../../../services/assessment.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-sals',
  templateUrl: './sals.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class SalsComponent implements OnInit {

  SelectedSal = 'Simple';

  Sal_Levels: Sal;


  constructor(public salsSvc: SalService, private router: Router, private assessSvc: AssessmentService) {
  }

  ngOnInit() {
    this.salsSvc.SelectedSAL = new Sal();
    this.salsSvc.getSalSelection().subscribe(
      (data: Sal) => {
        this.salsSvc.SelectedSAL = data;
        this.Sal_Levels = data;
        if (data.Last_Sal_Determination_Type.toLowerCase() === 'simple') {
          data.Last_Sal_Determination_Type = 'Simple';
        }
        if (!data.Last_Sal_Determination_Type) {
          data.Last_Sal_Determination_Type = 'Simple';
        }

        this.SelectedSal = data.Last_Sal_Determination_Type;
      },
      error => {
        console.log('Error Getting all standards: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error Getting all standards: ' + (<Error>error).stack);
      });
  }

  continue() { }

  changeState(newType: string) {
    this.SelectedSal = newType;
    this.salsSvc.saveSALType(newType).subscribe(
      () => {
      },
      error => {
        console.log('Error posting change: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error posting change: ' + (<Error>error).stack);
      });
  }

  /**
   * Navigate to the previous page
   */
  navBack() {
    this.router.navigate(['/assessment', this.assessSvc.id(), 'prepare', 'info']);
  }

  /**
     * Navigate to the next page
     */
  navNext() {
    this.router.navigate(['/assessment', this.assessSvc.id(), 'prepare', 'standards']);
  }
}


