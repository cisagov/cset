////////////////////////////////
//
//   Copyright 2023 Battelle Energy Alliance, LLC
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
import { Injectable } from '@angular/core';
import { AssessmentService } from '../assessment.service';
import { ConfigService } from '../config.service';

/**
 * Analyzes assessment
 */
@Injectable({
  providedIn: 'root'
})
export class PageVisibilityService {

  constructor(
    private assessSvc: AssessmentService,
    private configSvc: ConfigService
  ) { }

  /**
   * Indicates if you can "land on" the page.
   * Parent nodes can't be landed on
   * because they aren't displayable pages.  They function
   * as collapsible nodes in the nav tree.
   */
  canLandOn(page: HTMLElement): boolean {
    // pages without a path can't be landed on/navigated to
    if (!page.hasAttribute('path')) {
      return false;
    }

    return true;
  }

  /**
   * Evaluates conditions where a page should be hidden and
   * ignored in the TOC and next/back workflow.
   */
  showPage(page: HTMLElement): boolean {
    // look for a condition on the current page or its nearest parent
    let nnnn = page.closest('[condition]');
    let conditionAttrib = nnnn?.attributes['condition']?.value.trim();

    // if the assessment wants to hide the page
    const pageId = page.attributes['id']?.value;
    if (!!pageId && this.assessSvc.assessment?.hiddenScreens?.includes(pageId.toLowerCase())) {
      return false;
    }

    // if no conditions are specified, show the page
    if (!conditionAttrib || conditionAttrib.length === 0) {
      return true;
    }


    // Conditions are separated by spaces and a condition cannot contain
    // any internal spaces.  For the page to show, all conditions must be true.
    // Start with true and if any fail, result is false.
    let show = true;
    let conditions = conditionAttrib.toUpperCase().split(' ');
    conditions.forEach(c => {

      // if 'HIDE' is present, this trumps everything else
      if (c == 'HIDE') {
        show = false;
      }


      // "Source" checks the assessment's 'workflow' value (the skin it was born in)
      if (c.startsWith('SOURCE:') || c.startsWith('SOURCE-ANY(')) {
        show = show && this.sourceAny(c);;
      }

      if (c.startsWith('SOURCE-NOT:') || c.startsWith('SOURCE-NONE(')) {
        show = show && !this.sourceAny(c);
      }



      // Installation Mode / current skin
      if (c.startsWith('INSTALL-MODE:') || c.startsWith('INSTALL-MODE-ANY(')) {
        show = show && this.skinAny(c);
      }

      if (c.startsWith('INSTALL-MODE-NOT:') || c.startsWith('INSTALL-MODE-NONE(')) {
        show = show && !this.skinAny(c);
      }



      // OPTION is which features are included in the assessment: maturity, standard or diagram
      if (c.startsWith('OPTION:') || c.startsWith('OPTION-ANY(')) {
        show = show && this.optionAny(c);
      }



      // ORIGIN
      if (c.startsWith('ORIGIN:') || c.startsWith('ORIGIN-ANY(')) {
        show = show && this.originAny(c);
      }

      if (c.startsWith('ORIGIN-NOT:') || c.startsWith('ORIGIN-NONE(')) {
        show = show && !this.originAny(c);
      }



      // look for the specified maturity model
      if (c.startsWith('MATURITY:') || c.startsWith('MATURITY-ANY(')) {
        show = show && this.maturityAny(c);
      }

      if (c.startsWith('MATURITY-NOT:') || c.startsWith('MATURITY-NONE(')) {
        show = show && !this.maturityAny(c);
      }

      if (c.startsWith('STANDARD-NOT:') || c.startsWith('STANDARD-NONE(')) {
        show = show && !this.standardAny(c);
      }

      // Look for a maturity target level greater than X
      if (c.startsWith('TARGET-LEVEL-GT:')) {
        let target = c.substring(c.indexOf(':') + 1);
        show = show && this.assessSvc.assessment.maturityModel.maturityTargetLevel > Number.parseInt(target);
      }

      if (c == ('SHOW-FEEDBACK')) {
        show = show && this.configSvc.behaviors.showFeedback;
      }

      if (c == 'SHOW-EXEC-SUMMARY') {
        show = show && this.showExecSummaryPage();
      }

    });

    return show;
  }


  /**
   * Returns true if any of the specified installation modes
   * matches the currently-running installation mode (skin).
   */
  skinAny(rule: string): boolean {
    let targets = this.getTargets(rule);

    // if 'CSET' is specified in the rule, also look for an empty installation mode,
    // which also indicates "vanilla CSET".
    if (targets.find(x => x == 'CSET')) {
      targets.push('');
    }

    let has = false;
    targets.forEach((t: string) => {
      has = has || (this.configSvc.installationMode == t);
    });

    return has;
  }

  /**
   * "Source" is a synomym for the original skin that the assessment
   * was created under.  It is stored in the "Workflow" column of the
   * INFORMATION database table.
   */
  sourceAny(rule: string): boolean {
    let targets = this.getTargets(rule);
    let has = false;
    targets.forEach((t: string) => {
      has = has || (this.assessSvc.assessment?.workflow == t);
    });
    return has;
  }

  /**
   * Returns true if any of the specified sources/features
   * are currently selected for the assessment.
   */
  optionAny(rule: string): boolean {
    let targets = this.getTargets(rule);
    let has = false;
    targets.forEach((t: string) => {
      switch (t.toUpperCase()) {
        case 'MATURITY':
          has = has || this.assessSvc.assessment?.useMaturity;
          break;
        case 'STANDARD':
          has = has || this.assessSvc.assessment?.useStandard;
          break;
        case 'DIAGRAM':
          has = has || this.assessSvc.assessment?.useDiagram;
          break;
      }
    });
    return has;
  }

  /**
   * Returns true if the assessment's "origin" matches the specified value.
   */
  originAny(rule: string): boolean {
    let targets = this.getTargets(rule);
    let has = false;
    targets.forEach((t: string) => {
      has = has ||
      (this.assessSvc.assessment?.origin == t.trim())
    });
    return has;
  }

  /**
   *
   * @param rule
   * @returns
   */
  maturityAny(rule: string): boolean {
    let targets = this.getTargets(rule);
    let has = false;
    targets.forEach((t: string) => {
      has = has ||
      (this.assessSvc.assessment?.useMaturity && this.assessSvc.usesMaturityModel(t.trim()))
    });
    return has;
  }

    /**
   *
   * @param rule
   * @returns
   */
  standardAny(rule: string): boolean {
    let targets = this.getTargets(rule);
    let has = false;
    targets.forEach((t: string) => {
      has = has ||
      (this.assessSvc.assessment?.useStandard && this.assessSvc.usesStandard(t.trim()));
    });
    return has;
  }

  /**
   * Parses the value(s) following the first colon or open paren
   * and returns a list of them.
   * @param c
   */
  getTargets(c: string): string[] {
    let pC = c.indexOf(':');
    if (pC >= 0) {
      return [c.substring(c.indexOf(':') + 1)];
    }

    let p1 = c.indexOf('(');
    let p2 = c.indexOf(')');
    let targetText = c.substring(p1 + 1, p2);
    var targets = targetText.split(',');
    return targets;
  }

  /**
   * Indicates when the Executive Summary page should be included in the navigation.
   */
  showExecSummaryPage(): boolean {
    let assessment = this.assessSvc.assessment;
    return assessment?.useDiagram || assessment?.useStandard;
  }
}
