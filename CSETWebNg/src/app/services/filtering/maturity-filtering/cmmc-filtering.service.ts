////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
import { Injectable } from "@angular/core";
import { Question } from "../../../models/questions.model";

/**
 * Maturity filtering for CMMC is basically whether to include questions
 * above the target level or not.  
 */
@Injectable()
export class CmmcFilteringService {

    /**
     * Indicates if the CMMC question should be visible based on current
     * filtering.
     */
    public setQuestionVisibility(q: Question): boolean {
        return true;
    }



     // CMMC filtering is based on target level.  Should we show questions above target level?

      // const targetLevel = this.assessmentSvc.assessment ?
      //   this.assessmentSvc.assessment.MaturityModel?.MaturityTargetLevel :
      //   10;

      // if (filterSvc.showFilters.includes('MT') && q.MaturityLevel <= targetLevel) {
      //   q.Visible = true;
      // }

      // // if the 'show above target' filter is turned off, hide the question
      // // if it is above the target level
      // if (!filterSvc.showFilters.includes('MT+') && q.MaturityLevel > targetLevel) {
      //   q.Visible = false;
      // }

      // If maturity filters are engaged (ACET standard) then they can override what would otherwise be visible
      // if (g.GroupingType == "Domain") {
      //   const filter = this.domainFilters.find(f => f.DomainName == c.DomainName);
      //   if (!!filter && filter.Settings.find(s => s.Level == q.MaturityLevel && s.Value == false)) {
      //     q.Visible = false;
      //   }
      // }
}