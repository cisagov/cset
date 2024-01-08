import { Component, ViewChild, ElementRef } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';
import { AuthenticationService } from '../../../../services/authentication.service';
import { ConfigService } from '../../../../services/config.service';
import { AssessmentDetail } from '../../../../models/assessment-info.model';
import { Demographic } from '../../../../models/assessment-info.model';

import pdfMake from 'pdfmake/build/pdfmake';
import pdfFonts from 'pdfmake/build/vfs_fonts';
import { DemographicService } from '../../../../services/demographic.service';
import { ActivatedRoute } from '@angular/router';
pdfMake.vfs = pdfFonts.pdfMake.vfs;

@Component({
  selector: 'app-key-report',
  templateUrl: './key-report.component.html',
  styleUrls: ['./key-report.component.scss']
})
export class KeyReportComponent {
  assessment: AssessmentDetail = {};
  demographicData: Demographic = {};
  contactCount: number;

  @ViewChild('pdfTable') pdfTable: ElementRef;
  constructor(
    public auth: AuthenticationService,
    public assessSvc: AssessmentService,
    public configSvc: ConfigService,
    private demoSvc: DemographicService,
    private route: ActivatedRoute
  ) { }

  ngOnInit(): void {
    this.contactCount = 1;
    this.generatePdf();
  }

  generatePdf() {
    let pdfMake = require('pdfmake/build/pdfmake.js');
    let pdfFonts = require('pdfmake/build/vfs_fonts.js');
    pdfMake.vfs = pdfFonts.pdfMake.vfs;
    const authKey = this.auth.accessKey();

    const isConfigChainEqual = this.arraysEqual(
      this.configSvc.config.currentConfigChain,
      ['TSA', 'TSAonline']
    );
    // Get the 'Assessment Name', 'Assessment Date' and 'Facility Name' based on the 'currentConfigChain'
    const assessmentName = isConfigChainEqual
      ? '_________________________'
      : this.assessment.assessmentName;

    const assessmentDate = isConfigChainEqual
      ? '_________________________'
      : this.assessment.assessmentDate.split('T')[0];

    const facilityName =
      isConfigChainEqual || this.assessment.facilityName == null
        ? '_________________________'
        : this.assessment.facilityName;

    let content = [];
    for (let i = 0; i < this.contactCount; i++) {
      let pageContent = [
        {
          text: `Anonymous Key Sheet for: ${authKey}`,
          style: 'header4',
          margin: [0, 0, 0, 20]
        },
        {
          text: 'Please print out, complete, and provide this form to your TSA contact.',
          style: 'subheader'
        },
        { text: `KEY : ${authKey}`, style: 'key', margin: [0, 10, 10, 10] },
        {
          columns: [
            {
              width: '16%',
              text: `Assessment Name :`,
              style: 'labelKey',
              margin: [0, 0, 0, 0]
            },
            {
              width: '30%',
              text: `${assessmentName}`,
              style: 'label',
              margin: [0, 0, 0, 0]
            },
            {
              width: '16%',
              text: `Assessment Date :`,
              style: 'labelKey',
              margin: [0, 0, 0, 0]
            },
            {
              width: '30%',
              text: `${assessmentDate}`,
              style: 'label',
              margin: [0, 0, 0, 0]
            }
          ]
        },
        {
          text: `Assessment Owner :    _________________________`,
          style: 'label',
          margin: [0, 10, 10, 10]
        },
        {
          columns: [
            {
              width: '16%',
              text: `First Name :`,
              style: 'labelKey',
              margin: [0, 10, 10, 5]
            },
            {
              width: '30%',
              text: `_________________________`,
              style: 'label',
              margin: [0, 10, 10, 0]
            },
            {
              width: '16%',
              text: `Last Name :`,
              style: 'labelKey',
              margin: [0, 10, 10, 5]
            },
            {
              width: '30%',
              text: `_________________________`,
              style: 'label',
              margin: [0, 10, 10, 0]
            }
          ]
        },
        {
          columns: [
            {
              width: '16%',
              text: `Title/Role :`,
              style: 'labelKey',
              margin: [0, 10, 10, 5]
            },
            {
              width: '30%',
              text: `_________________________`,
              style: 'label',
              margin: [0, 10, 10, 0]
            },
            {
              width: '16%',
              text: `Email :`,
              style: 'labelKey',
              margin: [0, 10, 10, 5]
            },
            {
              width: '30%',
              text: `_________________________`,
              style: 'label',
              margin: [0, 10, 10, 0]
            }
          ]
        },
        {
          columns: [
            {
              width: '16%',
              text: `Cell Phone :`,
              style: 'labelKey',
              margin: [0, 10, 10, 5]
            },
            {
              width: '30%',
              text: `_________________________`,
              style: 'label',
              margin: [0, 10, 10, 0]
            },
            {
              width: '16%',
              text: `Office Phone :`,
              style: 'labelKey',
              margin: [0, 10, 10, 5]
            },
            {
              width: '30%',
              text: `_________________________`,
              style: 'label',
              margin: [0, 10, 10, 0]
            }
          ]
        },
        {
          columns: [
            {
              width: '50%',
              margin: [0, 10, 10, 0],
              text: [
                {
                  text: '[ ] ',
                  fontSize: 10,
                  margin: [20, 20, 20, 20]
                },
                'Primary Point of Contact'
              ]
            },
            {
              width: '50%',
              margin: [0, 10, 10, 0],
              text: [
                {
                  text: '[ ] ',
                  fontSize: 10,
                  margin: [20, 20, 20, 20]
                },
                'Participated in Site Visit'
              ]
            }
          ]
        },
        {
          columns: [
            {
              width: '16%',
              text: `Organization Name :`,
              style: 'labelKey',
              margin: [0, 10, 10, 0]
            },
            {
              width: '30%',
              text: `_________________________`,
              style: 'label',
              margin: [10, 10, 10, 10]
            },
            {
              width: '16%',
              text: `Facility Name :`,
              style: 'labelKey',
              margin: [0, 10, 10, 0]
            },
            {
              width: '30%',
              text: `_________________________`,
              style: 'label',
              margin: [0, 10, 10, 0]
            }
          ]
        },
        {
          columns: [
            {
              width: '16%',
              text: `City or Site Name :`,
              style: 'labelKey',
              margin: [0, 10, 10, 0]
            },
            {
              width: '30%',
              text: `_________________________`,
              style: 'label',
              margin: [0, 10, 10, 0]
            },
            {
              width: '16%',
              text: `State/Province/Region :`,
              style: 'labelKey',
              margin: [0, 10, 10, 0]
            },
            {
              width: '32%',
              text: `_________________________`,
              style: 'label',
              margin: [0, 10, 10, 0]
            }
          ]
        },
        {
          columns: [
            {
              width: '16%',
              text: `Sector :`,
              style: 'labelKey',
              margin: [0, 10, 0, 0]
            },
            {
              width: '30%',
              text: `_________________________`,
              style: 'label',
              margin: [0, 10, 10, 0]
            },
            {
              width: '16%',
              text: `Industry :`,
              style: 'labelKey',
              margin: [0, 10, 10, 0]
            },
            {
              width: '30%',
              text: `_________________________`,
              style: 'label',
              margin: [0, 10, 10, 0]
            }
          ]
        },
        {
          text: `Organization Type : _________________________`,
          style: 'label',
          margin: [0, 10, 10, 10]
        },
        { text: `Roles :`, style: 'label', margin: [0, 10, 2, 10] },
        {
          columns: [
            {
              width: '50%',
              margin: [0, 10, 10, 0],
              text: [
                {
                  text: '[ ] ',
                  fontSize: 10,
                  margin: [20, 20, 20, 20]
                },
                'User'
              ]
            },
            {
              width: '50%',
              margin: [0, 10, 10, 0],
              text: [
                {
                  text: '[ ] ',
                  fontSize: 10,
                  margin: [20, 20, 20, 20]
                },
                'Administrator'
              ]
            }
          ]
        },
        {
          text: '',
          pageBreak: i !== this.contactCount - 1 ? 'after' : undefined
        }
      ];
      content = content.concat(pageContent);
    }
    const documentDefinition = {
      content: [
        {
          text: `Anonymous Key Sheet for: ${authKey}`,
          style: 'header4',
          margin: [0, 0, 0, 20]
        },
        {
          text: 'Please print out, complete, and provide this form to your TSA contact.',
          style: 'subheader'
        },
        { text: `KEY : ${authKey}`, style: 'key', margin: [0, 10, 10, 10] },
        {
          columns: [
            {
              width: '50%',
              text: `Assessment Name :______________________________`,
              style: 'labelKey',
              margin: [0, 0, 0, 0]
            },
            // {
            //     width: '30%',
            //     text: `${assessmentName}`,
            //     style: 'label',
            //     margin: [0, 0, 0, 0]
            // },
            {
              width: '50%',
              text: `Assessment Date :______________________________`,
              style: 'labelKey',
              margin: [0, 0, 0, 0]
            }
            // {
            //     width: '30%',
            //     text: `${assessmentDate}`,
            //     style: 'label',
            //     margin: [0, 0, 0, 0]
            // }
          ]
        },
        {
          columns: [
            {
              width: '50%',
              text: `Sector :______________________________`,
              style: 'labelKey',
              margin: [0, 10, 0, 0]
            },
            // {
            //     width: '30%',
            //     text: `__________________`,
            //     style: 'label',
            //     margin: [0,10, 10, 0]
            // },
            {
              width: '50%',
              text: `Industry :______________________________`,
              style: 'labelKey',
              margin: [0, 10, 10, 0]
            }
            // {
            //     width: '30%',
            //     text: `_____________________`,
            //     style: 'label',
            //     margin: [0,10, 10, 0]
            // }
          ]
        },
        { text: `Assessment Owner :`, style: 'label', margin: [0, 10, 10, 10] },

        {
          columns: [
            {
              width: '50%',
              margin: [0, 10, 10, 0],
              text: [
                {
                  text: '[ ] ',
                  fontSize: 10,
                  margin: [20, 20, 20, 20]
                },
                'Primary Point of Contact'
              ]
            },
            {
              width: '50%',
              margin: [0, 10, 10, 0],
              text: [
                {
                  text: '[ ] ',
                  fontSize: 10,
                  margin: [20, 20, 20, 20]
                },
                'Participated in Site Visit'
              ]
            }
          ]
        },

        { text: `Roles :`, style: 'label', margin: [0, 20, 0, 0] },
        {
          columns: [
            {
              width: '50%',
              margin: [0, 10, 10, 0],
              text: [
                {
                  text: '[ ] ',
                  fontSize: 10,
                  margin: [20, 20, 20, 20]
                },
                'User'
              ]
            },
            {
              width: '50%',
              margin: [0, 10, 10, 0],
              text: [
                {
                  text: '[ ] ',
                  fontSize: 10,
                  margin: [20, 20, 20, 20]
                },
                'Administrator'
              ]
            }
          ]
        },
        {
          style: 'tableExample',
          table: {
            widths: ['*', '*', '*', '*', '*', '*', '*', '*', '*', '*'],
            body: [
              [
                'First Name',
                'Last Name',
                'Title/Role',
                'Organization Name',
                'Cell Phone',
                'Office Phone',
                'Organization Type',
                'Facility Name',
                'City',
                'State'
              ],
              [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
              [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
              [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
              [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
              [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
              [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
              [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
            ]
          },
          layout: {
            hLineWidth: function (i, node) {
              return i === 0 || i === node.table.body.length ? 1 : 1;
            },
            vLineWidth: function (i, node) {
              return i === 0 || i === node.table.widths.length ? 1 : 1;
            },
            hLineColor: function (i, node) {
              return i === 0 || i === node.table.body.length
                ? 'black'
                : 'black';
            },
            vLineColor: function (i, node) {
              return i === 0 || i === node.table.widths.length
                ? 'black'
                : 'black';
            }
          },
          margin: [0, 20, 0, 0]
        }
      ],
      // content: content,
      styles: {
        header4: {
          fontSize: 16,
          bold: true
        }
      },
      pageSize: 'A4',
      pageOrientation: 'landscape'
    };

    pdfMake.createPdf(documentDefinition).open({}, window);
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
