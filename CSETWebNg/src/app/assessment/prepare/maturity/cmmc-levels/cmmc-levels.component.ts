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
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { MaturityService } from '../../../../services/maturity.service';
import { MaturityLevel } from '../../../../models/maturity.model';


@Component({
  selector: 'app-cmmc-levels',
  templateUrl: './cmmc-levels.component.html'
})
export class CmmcLevelsComponent implements OnInit {

  availableLevels: MaturityLevel[];
  selectedLevel: MaturityLevel = { label: "zero", level: 0 };

  constructor(
    public assessSvc: AssessmentService,
    public maturitySvc: MaturityService,
    public navSvc: NavigationService
  ) { }


  /**
   * 
   */
  ngOnInit() {
    if (this.assessSvc.assessment == null) {
      this.assessSvc.getAssessmentDetail().subscribe((data: any) => {
        this.assessSvc.assessment = data;
        this.selectedLevel.level = this.assessSvc.assessment.maturityModel.maturityTargetLevel;
        this.availableLevels = this.assessSvc.assessment.maturityModel.levels;
      });
    } else {
      this.selectedLevel.level = this.assessSvc.assessment.maturityModel.maturityTargetLevel;
      this.availableLevels = this.assessSvc.assessment.maturityModel.levels;
    }
  }

  /**
   * 
   * @param newLevel 
   */
  saveLevel(newLevel) {
    this.availableLevels.forEach(l => {
      if (l.level === newLevel) {
        this.selectedLevel = l;
      }
    });

    this.maturitySvc.saveLevel(this.selectedLevel.level).subscribe(() => {
      // refresh Prepare section of the sidenav
      this.navSvc.buildTree();
      return;
    });
  }

}
