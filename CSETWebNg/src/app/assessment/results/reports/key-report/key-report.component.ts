import { Component, ViewChild, ElementRef } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';
import { AuthenticationService } from '../../../../services/authentication.service';
import { ConfigService } from '../../../../services/config.service';
import { AssessmentDetail } from '../../../../models/assessment-info.model';
import { Demographic } from '../../../../models/assessment-info.model';

import pdfMake from 'pdfmake/build/pdfmake';
import pdfFonts from 'pdfmake/build/vfs_fonts';
pdfMake.vfs = pdfFonts.pdfMake.vfs;
import htmlToPdfmake from 'html-to-pdfmake';
import { DemographicService } from '../../../../services/demographic.service';
import { Console } from 'console';

@Component({
  selector: 'app-key-report',
  templateUrl: './key-report.component.html',
  styleUrls: ['./key-report.component.scss']
})
export class KeyReportComponent {
  assessment: AssessmentDetail = {};
  demographicData: Demographic = {};

  @ViewChild('pdfTable') pdfTable: ElementRef;
  constructor(
    public auth: AuthenticationService,
    public assessSvc: AssessmentService,
    public configSvc: ConfigService,
    private demoSvc: DemographicService
   
   
  ) { }

  ngOnInit(): void {
    if (this.assessSvc.id()) {
      this.assessSvc.loadAssessment(this.assessSvc.id())
      this.assessment = this.assessSvc.assessment;
    
      this.demoSvc.getDemographic().subscribe(
        (data: Demographic) => {
            this.demographicData = data;
         
          })
    }
   
    this.generatePdf()
  }
  ngAfterViewInit(): void {
    this.generatePdf();  // Now it should not throw error
  }

generatePdf() {
  let pdfMake = require('pdfmake/build/pdfmake.js');
  let pdfFonts = require('pdfmake/build/vfs_fonts.js');
  pdfMake.vfs = pdfFonts.pdfMake.vfs;
  const authKey = this.auth.accessKey(); // Update this line as per your need
  
  const isConfigChainEqual = this.arraysEqual(this.configSvc.config.currentConfigChain, ["TSA","TSAonline"]);
// Get the 'Assessment Name', 'Assessment Date' and 'Facility Name' based on the 'currentConfigChain'
const assessmentName = isConfigChainEqual 
  ? "__________________________________"
  : this.assessment.assessmentName;

const assessmentDate = isConfigChainEqual
  ? "__________________________________"
  : this.assessment.assessmentDate.split("T")[0];

const facilityName = isConfigChainEqual || this.assessment.facilityName == null
  ? "__________________________________"
  : this.assessment.facilityName;
  const documentDefinition = {
      content: [
        { text: `Anonymous Key Sheet for: ${authKey}`, style: 'header4', margin: [0, 0, 0, 20] },
            { text: 'Please provide this sheet for your TSA contact. So that your assessment can be associated with your organization', style: 'subheader' },
            { text: `KEY : ${authKey}`, style: 'key' ,margin: [0, 10, 10, 0]},
            { text: `Assessment Name : ${assessmentName}`, style: 'labelKey', margin: [0, 10, 10, 0]  },
            { text: `Assessment Date : ${assessmentDate}`, style: 'label', margin: [0, 10, 10, 0]  },
            { text: `Organization Name : ${assessmentDate}`, style: 'label', margin: [0, 10, 10, 0]  },
            { text: `Facility Name : ${facilityName}`, style: 'label', margin: [0, 10, 10, 0]  },
            { text: 'City or Site Name: __________________________________', style: 'label', margin: [0, 10, 10, 0]  },
            { text: 'State/Province/Region : __________________________________', style: 'label', margin: [0, 10, 10, 0]  },
          {
              style: 'tableExample',
              table: {
                  widths: ['*', '*', '*', '*', '*'],
                  body: [
                      ['First Name', 'Last Name', 'Title', 'Organization', 'Cell Phone'],
                      [' ', ' ', ' ', ' ', ' '],
                      [' ', ' ', ' ', ' ', ' '],
                      [' ', ' ', ' ', ' ', ' '],
                      [' ', ' ', ' ', ' ', ' ']
                  ]
              },
              layout: {
                  hLineWidth: function(i, node) {
                      return (i === 0 || i === node.table.body.length) ? 1 : 1;
                  },
                  vLineWidth: function(i, node) {
                      return (i === 0 || i === node.table.widths.length) ? 1 : 1;
                  },
                  hLineColor: function(i, node) {
                      return (i === 0 || i === node.table.body.length) ? 'black' : 'black';
                  },
                  vLineColor: function(i, node) {
                      return (i === 0 || i === node.table.widths.length) ? 'black' : 'black';
                  }
              },
              margin: [0, 20, 0, 0] ,
            
          },
      ],
      styles: {
        header4: {
            fontSize: 16,
            bold: true
        },
      
    }
  };
  let url = '/index.html?returnPath=report/key-report' ;
  localStorage.setItem('REPORT-KEY-REPORT' , print.toString());
  pdfMake.createPdf(documentDefinition).open(); 
}
// Helper function to check if two arrays are equal
  arraysEqual(a, b) {
  if (a === b) return true;
  if (a == null || b == null) return false;
  if (a.length !== b.length) return false;

  // If you don't care about the order of the elements inside
  // the array, you should sort both arrays here.

  for (let i = 0; i < a.length; ++i) {
    if (a[i] !== b[i]) return false;
  }
  return true;
}

}
