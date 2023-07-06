import { Component, ViewChild, ElementRef } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';
import { AuthenticationService } from '../../../../services/authentication.service';
import { ConfigService } from '../../../../services/config.service';
import { AssessmentDetail } from '../../../../models/assessment-info.model';
  
import pdfMake from 'pdfmake/build/pdfmake';
import pdfFonts from 'pdfmake/build/vfs_fonts';
pdfMake.vfs = pdfFonts.pdfMake.vfs;
import htmlToPdfmake from 'html-to-pdfmake';

@Component({
  selector: 'app-key-report',
  templateUrl: './key-report.component.html',
  styleUrls: ['./key-report.component.scss']
})
export class KeyReportComponent {
  assessment: AssessmentDetail = {};
  @ViewChild('pdfTable') pdfTable: ElementRef;
  constructor(
    public auth: AuthenticationService,
    public assessSvc: AssessmentService,
    public configSvc: ConfigService,
   
   
  ) { }

  ngOnInit(): void {
    // console.log(this.pdfTable); 
    console.log(this.assessSvc.id())
    // if (this.assessSvc.id()) {
    //   this.assessSvc.loadAssessment(this.assessSvc.id())
    //   this.assessment = this.assessSvc.assessment;
    // }
    this.generatePdf()
  }
  ngAfterViewInit(): void {
    console.log(this.pdfTable);  // Now it should print ElementRef instance
    this.generatePdf();  // Now it should not throw error
  }

  // generatePdf() {
  //   let normalSpacing = 12;
  //   let smallSpacing = 6;
  //   let largeSpacing = 24;
  //   let extraLargeSpacing = 36;
    
  //   let pdfMake = require('pdfmake/build/pdfmake.js');
  //   let pdfFonts = require('pdfmake/build/vfs_fonts.js');
  //   let htmlToPdfmake = require('html-to-pdfmake');
  //   pdfMake.vfs = pdfFonts.pdfMake.vfs;
  //   const pdfTable = this.pdfTable.nativeElement;
   
  //   var html = htmlToPdfmake(pdfTable.innerHTML);
     
  //   const documentDefinition = { content: html };
  //   pdfMake.createPdf(documentDefinition).open(); 
  // }
//   generatePdf() {
//     let pdfMake = require('pdfmake/build/pdfmake.js');
//     let pdfFonts = require('pdfmake/build/vfs_fonts.js');
//     pdfMake.vfs = pdfFonts.pdfMake.vfs;
//     const authKey = this.auth.accessKey(); // Update this line as per your need
    
//     const documentDefinition = {
//         content: [
//             { text: `Anonymous Key Sheet for: ${authKey}`, style: 'header' },
//             { text: 'Please provide this sheet for your TSA contact. So that your assessment can be associated with your organization', style: 'subheader' },
//             { text: `KEY : ${authKey}`, style: 'key' },
//             { text: 'Assessment Name : __________________________________', style: 'label' },
//             { text: 'Assessment Date : __________________________________', style: 'label' },
//             { text: 'Organization Name : __________________________________', style: 'label' },
//             { text: 'Facility Name : __________________________________', style: 'label' },
//             { text: 'City or Site Name: __________________________________', style: 'label' },
//             { text: 'State/Province/Region : __________________________________', style: 'label' },
//             {
//                 style: 'tableExample',
//                 table: {
//                     widths: ['*', '*', '*', '*', '*'],
//                     body: [
//                         ['First Name', 'Last Name', 'Title', 'Organization', 'Cell Phone'],
//                         [' ', ' ', ' ', ' ', ' '],
//                         [' ', ' ', ' ', ' ', ' '],
//                         [' ', ' ', ' ', ' ', ' '],
//                         [' ', ' ', ' ', ' ', ' ']
//                     ]
//                 },
//                 layout: 'lightHorizontalLines'
//             },
//         ],
//         styles: {
//             header: {
//                 fontSize: 18,
//                 bold: true,
//                 margin: [0, 0, 0, 10]
//             },
//             subheader: {
//                 fontSize: 14,
//                 bold: true,
//                 margin: [0, 10, 0, 5]
//             },
//             key: {
//                 fontSize: 16,
//                 bold: true,
//                 margin: [0, 20, 0, 5]
//             },
//             label: {
//                 fontSize: 12,
//                 margin: [0, 10, 0, 5]
//             },
//             tableExample: {
//                 margin: [0, 5, 0, 15]
//             },
//             tableHeader: {
//                 bold: true,
//                 fontSize: 13,
//                 color: 'black'
//             }
//         }
//     };
    
//     pdfMake.createPdf(documentDefinition).open(); 
// }
generatePdf() {
  let pdfMake = require('pdfmake/build/pdfmake.js');
  let pdfFonts = require('pdfmake/build/vfs_fonts.js');
  pdfMake.vfs = pdfFonts.pdfMake.vfs;
  const authKey = this.auth.accessKey(); // Update this line as per your need
  
  const documentDefinition = {
      content: [
        { text: `Anonymous Key Sheet for: ${authKey}`, style: 'header4', margin: [0, 0, 0, 20] },
            { text: 'Please provide this sheet for your TSA contact. So that your assessment can be associated with your organization', style: 'subheader' },
            { text: `KEY : ${authKey}`, style: 'key' ,margin: [0, 10, 10, 0]},
            { text: 'Assessment Name : __________________________________', style: 'labelKey', margin: [0, 10, 10, 0]  },
            { text: 'Assessment Date : __________________________________', style: 'label', margin: [0, 10, 10, 0]  },
            { text: 'Organization Name : __________________________________', style: 'label', margin: [0, 10, 10, 0]  },
            { text: 'Facility Name : __________________________________', style: 'label', margin: [0, 10, 10, 0]  },
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
  
  pdfMake.createPdf(documentDefinition).open(); 
}

}
