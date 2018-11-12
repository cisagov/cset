////////////////////////////////
//
//   Copyright 2018 Battelle Energy Alliance, LLC
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
  // tslint:disable-next-line:use-host-property-decorator
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
        this.salsSvc.SelectedSAL = data;
      },
      error => {
        console.log('Error Getting all standards: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error Getting all standards: ' + (<Error>error).stack);
      });
  }

  saveLevel(level: string, ltype: string) {
    this.salsSvc.SelectedSAL.Last_Sal_Determination_Type = 'Simple';
    switch (ltype) {
      case 'C': {
        this.salsSvc.SelectedSAL.CLevel = level;
        this.salsSvc.SelectedSAL.SelectedSALOverride = false;
        break;
      }
      case 'I': {
        this.salsSvc.SelectedSAL.ILevel = level;
        this.salsSvc.SelectedSAL.SelectedSALOverride = false;
        break;
      }
      case 'A': {
        this.salsSvc.SelectedSAL.ALevel = level;
        this.salsSvc.SelectedSAL.SelectedSALOverride = false;
        break;
      }
      default: {
        this.salsSvc.SelectedSAL.SelectedSALOverride = true;
        this.salsSvc.SelectedSAL.Selected_Sal_Level = level;
        break;
      }
    }

    // this.Sal_Levels.Sort_Set_Name = form.controls['Sort_Set_Name'].value;
    this.salsSvc.updateStandardSelection(this.salsSvc.SelectedSAL).subscribe(
      (data: Sal) => {
        this.salsSvc.SelectedSAL = data;
      },
      error => {
        console.log('Error setting sal level: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error setting sal level: ' + (<Error>error).stack);
      });
  }
}
