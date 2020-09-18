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
import { Component, OnInit } from "@angular/core";
import { MatDialog, MatDialogRef } from "@angular/material";
import { Router } from "@angular/router";
import { OkayComponent } from "../../../dialogs/okay/okay.component";
import { QuestionRequirementCounts, StandardsBlock } from "../../../models/standards.model";
import { AssessmentService } from "../../../services/assessment.service";
import { StandardService } from "../../../services/standard.service";
import { CyberStandard } from "./../../../models/standards.model";
import { AwwaStandardComponent } from "./awwa-standard/awwa-standard.component";
import { NavigationService } from "../../../services/navigation.service";

@Component({
  selector: "app-standards",
  templateUrl: "./standards.component.html",
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class StandardsComponent implements OnInit {
  standards: StandardsBlock;
  expandedDesc: boolean[] = [];
  dialogRef: MatDialogRef<OkayComponent>;
  dialogRefAwwa: MatDialogRef<AwwaStandardComponent>;

  constructor(
    private router: Router,
    private assessSvc: AssessmentService,
    private standardSvc: StandardService,
    public navSvc: NavigationService,
    public dialog: MatDialog
  ) { }

  ngOnInit() {
    this.loadStandards();
  }

  /**
   * Retrieves the complete list of standards
   */
  loadStandards() {
    this.standardSvc.getStandardsList().subscribe(
      (data: StandardsBlock) => {
        this.standards = data;

        // default all items to 'closed'
        this.standards.Categories.forEach(cat => {
          cat.Standards.forEach(std => {
            this.expandedDesc[std.Code] = false;
            if (std.Code === "NCSF_V1") {
              this.standardSvc.frameworkSelected = std.Selected;
              this.setFrameworkNavigation();
            }
          });
        });
      },
      error => {
        console.log(
          "Error getting all standards: " +
          (<Error>error).name +
          (<Error>error).message
        );
        console.log("Error getting all standards: " + (<Error>error).stack);
      }
    );
  }

  showLegalese(standard) {
    let msg: string;
    let ingaa: CyberStandard;
    let nei: CyberStandard;
    let framework: CyberStandard;

    this.standards.Categories.forEach(cat => {
      cat.Standards.forEach(std => {
        if (std.Code === "INGAA") {
          ingaa = std;
        }
        if (std.Code === "NEI_0809") {
          nei = std;
        }
        if (std.Code === "NCSF_V1") {
          framework = std;
        }
      });
    });

    let showIt = false;


    if (standard.Code === "INGAA") {
      // INGAA
      msg =
        "The standard/questionnaire that you have selected has been voluntarily provided by the Interstate Natural Gas Association" +
        " of America (INGAA) and is provided for your use.  This assessment/questionnaire is offered as a convenience to CSET® users and" +
        " implies no Department of Homeland Security (DHS) endorsement of this standard/questionnaire.  DHS and INGAA provide this" +
        " standard/questionnaire as is, with no warranties.  Both DHS and INGAA disclaim any liability associated with your use of " +
        " this standard/questionnaire.";
      showIt = ingaa.Selected;
    } else if (standard.Code === "NEI_0809") {
      msg =
        "The standard/questionnaire that you have selected has  " +
        "been voluntarily provided by Nuclear Energy Institute (NEI) and is provided for your use.  " +
        "This assessment/questionnaire is offered as a convenience to CSET® users and implies no Department of " +
        "Homeland Security (DHS) endorsement of this standard/questionnaire.  DHS and NEI provide this standard/questionnaire" +
        " as is, with no warranties.  Both DHS and NEI disclaim any liability associated with your use of this standard/questionnaire.";
      showIt = nei.Selected;
    } else if (standard.Code === "NCSF_V1") {
      msg =
        "CSET Profiles (.csetp) are being deprecated in favor of a new questions editor in which you can create questions " +
        "or utilize any existing questions contained with in CSET®.  Previously profiles were limited to the NIST " +
        "Framework for Improving Critical Infrastructure Cybersecurity.";
      showIt = framework.Selected;
    } else if (standard.Code === "AWWA") {
    } else {
      return true;
    }

    let rval = true;


    // show a legalese verbiage "OK" dialog 
    if (showIt) {

      this.dialogRef = this.dialog.open(OkayComponent, { data: { messageText: msg } });
      this.dialogRef.componentInstance.hasHeader = true;

      this.dialogRef.afterClosed().subscribe(result => {
        if (result) {
          rval = true;
        } else {
          rval = false;
        }
        this.dialogRef = null;
      });
    }

    // show a more complex dialog (AWWA)
    if (standard.Code === "AWWA" && standard.Selected) {
      this.dialogRefAwwa = this.dialog.open(AwwaStandardComponent, { data: { messageText: msg } });

      this.dialogRefAwwa.afterClosed().subscribe(result => {
        if (result) {
          rval = true;
        } else {
          rval = false;
        }
        this.dialogRefAwwa = null;
      });
    }

    return rval;
  }

  /**
   * Builds a list of selected standards and post it to the server.
   */
  submit(standard, event: Event) {
    standard.Selected = (event.srcElement as HTMLInputElement).checked;
    const selectedStandards: string[] = [];
    if (!this.showLegalese(standard)) {
      return;
    }

    if (standard.Code === "NCSF_V1") {
      this.standardSvc.frameworkSelected = standard.Selected;
      this.setFrameworkNavigation();
    }

    if (standard.Code === "ACET_V1") {
      this.navSvc.setACETSelected(standard.Selected);
    }

    this.standards.Categories.forEach(cat => {
      cat.Standards.forEach(std => {
        if (std.Selected) {
          selectedStandards.push(std.Code);
        }
      });
    });

    this.standardSvc
      .postSelections(selectedStandards)
      .subscribe((counts: QuestionRequirementCounts) => {
        this.standards.QuestionCount = counts.QuestionCount;
        this.standards.RequirementCount = counts.RequirementCount;
      });

    this.setFrameworkNavigation();
  }

  setFrameworkNavigation() {
    // RKW - this.navSvc.setFrameworkSelected(this.standardSvc.frameworkSelected);
  }

  /**
   * Toggles the open/closed style of the description div.
   */
  toggleExpansion(std) {
    this.expandedDesc[std] = !this.expandedDesc[std];
  }

  /**
   * Posts an empty list of selected standards.  The API will set the default
   * standards for a basic assessment.
   */
  doBasicAssessment() {
    this.standardSvc.postDefaultSelection().subscribe(() => {
      this.router.navigate(["/assessment", this.assessSvc.id(), "questions"]);
    });
  }
}
