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
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Sal } from '../../../../models/sal.model';
import { SalService } from '../../../../services/sal.service';

@Component({
  selector: 'app-sal-simple',
  templateUrl: './sal-simple.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})

export class SalSimpleComponent implements OnInit {
  rlevels = ['Low', 'Moderate', 'High', 'Very High'];
  isValidFormSubmitted = false;

  constructor(private route: ActivatedRoute, public salsSvc: SalService) { }

  ngOnInit() {
    // retrieve the existing sal_selection for this assessment
    this.salsSvc.getSalSelection().subscribe(
      (data: Sal) => {
        this.salsSvc.selectedSAL = data;
      },
      error => {
        console.log('Error Getting all standards: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error Getting all standards: ' + (<Error>error).stack);
      });
  }

  saveLevel(level: string, ltype: string) {
    this.salsSvc.selectedSAL.methodology = 'Simple';
    switch (ltype) {
      case 'C': {
        this.salsSvc.selectedSAL.cLevel = level;
        this.salsSvc.selectedSAL.selectedSALOverride = false;
        break;
      }
      case 'I': {
        this.salsSvc.selectedSAL.iLevel = level;
        this.salsSvc.selectedSAL.selectedSALOverride = false;
        break;
      }
      case 'A': {
        this.salsSvc.selectedSAL.aLevel = level;
        this.salsSvc.selectedSAL.selectedSALOverride = false;
        break;
      }
      default: {
        this.salsSvc.selectedSAL.selectedSALOverride = true;
        this.salsSvc.selectedSAL.selected_Sal_Level = level;
        break;
      }
    }

    this.salsSvc.updateStandardSelection(this.salsSvc.selectedSAL).subscribe(
      (data: Sal) => {
        this.salsSvc.selectedSAL = data;
      },
      error => {
        console.log('Error setting sal level: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error setting sal level: ' + (<Error>error).stack);
      });
  }
}
