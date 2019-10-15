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
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { GeneralSalDescriptionsWeights } from '../../../../models/sal.model';
import { AssessmentService } from '../../../../services/assessment.service';
import { Sal } from '../../../../models/sal.model';
import { SalService } from '../../../../services/sal.service';

@Component({
  selector: 'app-sal-gen',
  templateUrl: './sal-gen.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: {class: 'd-flex flex-column flex-11a'}
})
export class SalGenComponent implements OnInit {

  sliders: GenSalPairs[];
  constructor(private assessSvc: AssessmentService, private route: ActivatedRoute, public salsSvc: SalService) {
  }

  ngOnInit() {
    this.salsSvc.getGenSalDescriptions().subscribe(
      (data: GenSalPairs[]) => {
        this.sliders = data;
      },
      error => {
        console.log('Error Getting gensal descriptions: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error gensal descriptions: ' + (<Error>error).stack);
      });

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

  myOnFinish(event, slidername) {
    const Slider_Value = event.from;
    this.salsSvc.getSaveGenSal((this.assessSvc.id()), Slider_Value, slidername).subscribe(
      (data: string) => {
        this.salsSvc.SelectedSAL.Selected_Sal_Level = data;
      },
      error => {
        console.log('Error saving gensal: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error saving gensal: ' + (<Error>error).stack);
      });
  }
  myOnChange(event, slidername) {
    const k = 0;//lgtm [js/unused-local-variable]
  }

  saveLevel(level: string) {
    this.salsSvc.SelectedSAL.SelectedSALOverride = true;
    this.salsSvc.SelectedSAL.Selected_Sal_Level = level;

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


export interface GenSalPairs {
  OnSite: GeneralSalDescriptionsWeights;
  OffSite: GeneralSalDescriptionsWeights;
}
