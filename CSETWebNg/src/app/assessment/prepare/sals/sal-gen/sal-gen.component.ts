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
import { GeneralSalDescriptionsWeights } from '../../../../models/sal.model';
import { AssessmentService } from '../../../../services/assessment.service';
import { Sal } from '../../../../models/sal.model';
import { SalService } from '../../../../services/sal.service';
import { TranslocoService } from '@ngneat/transloco';



@Component({
  selector: 'app-sal-gen',
  templateUrl: './sal-gen.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class SalGenComponent implements OnInit {

  sliders: GenSalPairs[];

  /**
   * 
   */
  constructor(
    private assessSvc: AssessmentService,
    private route: ActivatedRoute,
    public salsSvc: SalService,
    public tSvc: TranslocoService
  ) { }

  /**
   * 
   */
  ngOnInit() {
    this.salsSvc.getGenSalDescriptions().subscribe(
      (data: GenSalPairs[]) => {
        this.sliders = data;

        this.sliders.forEach(s => {
          s.onSite.options = {
            floor: s.onSite.min,
            ceil: s.onSite.max,
            showTicks: true,
            showTicksValues: false,
            showSelectionBar: true,
            getLegend: (v: number) => {
              return s.onSite.values[v];
            }
          };

          // translate display text
          s.onSite.sal_Description = this.tSvc.translate('titles.sal.gen sal.' + s.onSite.postfix.toLowerCase() + ' desc');
          s.onSite.postfix = this.tSvc.translate('titles.sal.gen sal.' + s.onSite.postfix.toLowerCase());
          s.onSite.prefix = this.tSvc.translate('titles.sal.gen sal.' + s.onSite.prefix.toLowerCase());
          let onsiteNone = s.onSite.values.findIndex(x => x.trim() == 'None');
          if (onsiteNone >= 0) {
            s.onSite.values[onsiteNone] = this.tSvc.translate('titles.sal.gen sal.none');
          }

          s.offSite.options = {
            floor: s.offSite.min,
            ceil: s.offSite.max,
            showTicks: true,
            showTicksValues: false,
            showSelectionBar: true,
            getLegend: (v: number) => {
              return s.offSite.values[v];
            }
          };

          // translate display text
          s.offSite.sal_Description = this.tSvc.translate('titles.sal.gen sal.' + s.offSite.postfix.toLowerCase() + ' desc');
          s.offSite.postfix = this.tSvc.translate('titles.sal.gen sal.' + s.offSite.postfix.toLowerCase());
          s.offSite.prefix = this.tSvc.translate('titles.sal.gen sal.' + s.offSite.prefix.toLowerCase());
          let offsiteNone = s.offSite.values.findIndex(x => x.trim() == 'None');
          if (offsiteNone >= 0) {
            s.offSite.values[offsiteNone] = this.tSvc.translate('titles.sal.gen sal.none');
          }

        });

      },
      error => {
        console.log('Error getting gen sal descriptions: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error gen sal descriptions: ' + (<Error>error).stack);
      });

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

  /**
   * 
   */
  valueChange(event, slidername) {
    const Slider_Value = event;
    this.salsSvc.getSaveGenSal((this.assessSvc.id()), Slider_Value, slidername).subscribe(
      (data: string) => {
        this.salsSvc.selectedSAL.selected_Sal_Level = data;
      },
      error => {
        console.log('Error saving gensal: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error saving gensal: ' + (<Error>error).stack);
      });
  }

  /**
   * 
   */
  saveLevel(level: string) {
    this.salsSvc.selectedSAL.selectedSALOverride = true;
    this.salsSvc.selectedSAL.selected_Sal_Level = level;

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


export interface GenSalPairs {
  onSite: GeneralSalDescriptionsWeights;
  offSite: GeneralSalDescriptionsWeights;
}
