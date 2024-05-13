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
import { AfterContentInit, Component, ElementRef, OnInit, ViewChild } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { MaturityService } from '../../services/maturity.service';
import { ACETService } from '../../services/acet.service';
import { DemographicService } from '../../services/demographic.service';
import { MaturityQuestionResponse } from '../../models/questions.model';
import { Demographic } from '../../models/assessment-info.model';
import { ReportService } from '../../services/report.service';
import { saveAs } from "file-saver";

@Component({
  selector: 'edm',
  templateUrl: './edm.component.html',
  styleUrls: ['../reports.scss', 'edm.component.scss']
})
export class EdmComponent implements OnInit, AfterContentInit {

  @ViewChild('edm') el: ElementRef;

  orgName: string;
  displayName = '...';
  currentDate: Date;
  currentTimeZone: string;
  assesmentInfo: any;
  demographicData: Demographic = {};

  print = false;
  preparingForPrint = false;

  /**
   *
   * @param maturitySvc
   */
  constructor(
    private titleService: Title,
    public maturitySvc: MaturityService,
    public acetSvc: ACETService,
    public demoSvc: DemographicService,
    public reportSvc: ReportService
  ) { }

  /**
   *
   */
  ngOnInit(): void {
    this.titleService.setTitle("Report - EDM");
    this.currentTimeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    this.currentTimeZone = this.currentTimeZone.replace("_", " ")
    this.currentDate = new Date();
    this.getAssementData();
    this.getQuestions();
  }

  /**
   *
   */
  ngAfterContentInit() {
    const print = localStorage.getItem('REPORT-EDM');
    localStorage.removeItem('REPORT-EDM');

    if (print?.toLowerCase() == 'true') {
      this.preparingForPrint = true;
      this.launchPrintDialog();
    }
  }

  getReportPdf() {
    //this.reportSvc.getPdf(this.el.nativeElement.innerHTML);
    this.reportSvc.getPdf(this.el.nativeElement.innerHTML, "None").subscribe(data => {
      saveAs(data, "edm.pdf");
    });
  }

  /**
   * Waits until the large domain detail sections have been rendered to
   * the DOM and then prints.  There's also a safety valve in case
   * 20 seconds elapse -- print anyway.
   */
  launchPrintDialog() {
    const intervalMs = 500;
    let elapsedMs = 0;

    const intervalID = setInterval(() => {
      // when all domain detail components are larger than 30kb we will assume the report is ready
      const elementList = document.querySelectorAll('app-edm-domain-detail');
      const domainDetails = Array.from(elementList);
      if (domainDetails.every(dd => dd.innerHTML.length > 30000)) {
        this.preparingForPrint = false;
        clearInterval(intervalID);
        window.print();
      }

      elapsedMs += intervalMs;
      if (elapsedMs > 20000) {
        // we've waited 20 seconds - print what we have loaded
        this.preparingForPrint = false;
        clearInterval(intervalID);
        window.print();
      }
    }, intervalMs);
  }

  /**
   *
   */
  getAssementData() {
    this.maturitySvc.getMaturityDeficiency("EDM").subscribe(
      (r: any) => {
        this.assesmentInfo = r.information;
        this.demoSvc.getDemographic().subscribe(
          (data: Demographic) => {
            this.demographicData = data;
            this.orgName = this.demographicData.organizationName;
            if (this.demographicData.organizationName?.length > 0) {
              this.displayName = this.orgName;
            }
            else if (this.assesmentInfo.facility_Name?.length > 0) {
              this.displayName = this.assesmentInfo.facility_Name;
            } else {
              this.displayName = this.assesmentInfo.assessment_Name;
            }
          },
          error => console.log('Demographic load Error: ' + (<Error>error).message)
        );
      },
      error => console.log('Assesment Information Error: ' + (<Error>error).message)
    );
  }

  /**
   *
   */
  getQuestions() {
    this.maturitySvc.getQuestionsList(true).subscribe((resp: MaturityQuestionResponse) => {

      this.maturitySvc.domains = resp.groupings.filter(x => x.groupingType == 'Domain');

      this.maturitySvc.getReferenceText('EDM').subscribe((resp: any[]) => {
        this.maturitySvc.ofc = resp;
      });
    });
  }

  /**
   *
   * @param abbrev
   */
  findDomain(abbrev: string) {
    if (!this.maturitySvc.domains) {
      return null;
    }

    let domain = this.maturitySvc.domains.find(d => d.abbreviation == abbrev);
    return domain;
  }

  /**
  *
  * @param el
  */
  scroll(eId: string) {
    const element = document.getElementById(eId);
    if (element) {
      element.scrollIntoView({ behavior: 'smooth' });
    }
  }
}
