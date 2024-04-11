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
import { Component, OnInit, ViewChild } from "@angular/core";
import { ActivatedRoute, Router } from "@angular/router";
import { AssessmentService } from "../../services/assessment.service";
import { NavTreeService } from "../../services/navigation/nav-tree.service";
import { NavigationService } from "../../services/navigation/navigation.service";

@Component({
  selector: "app-prepare",
  templateUrl: "./prepare.component.html",
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class PrepareComponent implements OnInit {

  @ViewChild('topScrollAnchor') topScroll;

  constructor(
    private assessSvc: AssessmentService,

    private navSvc: NavigationService,
    public navTreeSvc: NavTreeService,
    private router: Router,
    private route: ActivatedRoute
  ) {
    if (this.assessSvc.assessment == null) {
      this.assessSvc.getAssessmentDetail().subscribe(
        (data: any) => {
          this.assessSvc.assessment = data;
        });
    }
    this.assessSvc.currentTab = 'prepare';
  }

  /**
   * If the nav tree is not yet populated, build it.
   */
  ngOnInit() {
    this.navSvc.disableNext
      .asObservable()
      .subscribe(
        (tgt: boolean) => {
          this.navSvc.buildTree();
        }
      );
    if (this.navTreeSvc.tocControl.dataNodes == null) {
      setTimeout(() => {
        this.navSvc.buildTree();
      }, 1000);
    }
  }

  /**
  * Scrolls newly-displayed prepare pages at the top.
  */
  onNavigate(event) {
    this.topScroll?.nativeElement.scrollIntoView();
  }
}
