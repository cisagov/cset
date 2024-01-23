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
import { SetBuilderService } from '../../../services/set-builder.service';
import { AssessmentService } from '../../../services/assessment.service';

@Component({
  selector: 'app-module-content-launch',
  templateUrl: './module-content-launch.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class ModuleContentLaunchComponent implements OnInit {

  whichType = '';

  standards: any[];
  selectedStandard;

  models: any[];
  selectedModel;

  /**
   * 
   */
  constructor(
    private setBuilderSvc: SetBuilderService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.setBuilderSvc.getAllSetList().subscribe((x: any[]) => {
      this.standards = x.filter(s => s.isDisplayed);
      this.standards.sort((a, b) => {
        if (a.fullName < b.fullName) { return -1; }
        if (a.fullName > b.fullName) { return 1; }
        return 0;
      });
    });

    this.models = AssessmentService.allMaturityModels;
    this.models?.sort((a, b) => {
      if (a.modelTitle < b.modelTitle) { return -1; }
      if (a.modelTitle > b.modelTitle) { return 1; }
      return 0;
    });
  }

  /**
   * 
   */
  selectType(event: any) {
    this.whichType = event.target.id;
  }

  /**
   * 
   */
  launchModelReport() {
    const url = '/index.html?returnPath=report/module-content?mm=' + this.selectedModel;
    window.open(url, '_blank');
  }

  /**
   * 
   */
  launchStandardReport() {
    const url = '/index.html?returnPath=report/module-content?m=' + this.selectedStandard;
    window.open(url, '_blank');
  }

}
