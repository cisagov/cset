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
import { Component, OnInit, Input, ElementRef, AfterViewInit, ViewChild, AfterViewChecked } from '@angular/core';
import { pdfMake } from 'pdfmake/build/pdfmake';
import { pdfFonts } from 'pdfmake/build/vfs_fonts';
import { htmlToPdfmake } from 'html-to-pdfmake';
import { ReportService } from '../../services/report.service';
import { result } from 'lodash';
import { HttpClient } from '@angular/common/http';

@Component({
    selector: 'app-pdf-reports',
    templateUrl: './pdf-reports.component.html',
    styleUrls: ['../reports.scss']
  })

export class PdfReportsComponent implements OnInit, AfterViewChecked {
  @Input() assessmentInfo;
  @Input() donutData;
  @Input() tableData;

  @ViewChild('Cover') divCover: ElementRef
  @ViewChild('One') divOne: ElementRef;
  @ViewChild('Two') divTwo: ElementRef;
  @ViewChild('Three') divThree: ElementRef;
  @ViewChild('Four') divFour: ElementRef;
  @ViewChild('Five') divFive: ElementRef;
  @ViewChild('Six') divSix: ElementRef;
  @ViewChild('Seven') divSeven: ElementRef;
   
  coverImage: any = null;
  sectionOne: any = null;
  sectionTwo: any = null;
  sectionThree: any = null;
  sectionFour: any = null;
  sectionFive: any = null;
  sectionSix: any = null;
  sectionSeven: any = null;

  document: any = null;

  constructor(
    public reportSvc: ReportService,
    private http: HttpClient,
  ) { }

  ngOnInit(): void {
    // Cover Sheet Image
    this.getBase64('assets/images/C2M2/C2M2-Report-Cover-Sheet.png');
  }

  ngAfterViewChecked(): void {
    this.sectionOne = this.divOne.nativeElement.innerHTML;
    this.sectionTwo = this.divTwo.nativeElement.innerHTML;
    this.sectionThree = this.divThree.nativeElement.innerHTML;
    this.sectionFour = this.divFour.nativeElement.innerHTML;
    this.sectionFive = this.divFive.nativeElement.innerHTML;
    this.sectionSix = this.divSix.nativeElement.innerHTML;
    this.sectionSeven = this.divSeven.nativeElement.innerHTML;
  }

  generatePdf() {
    let pdfMake = require('pdfmake/build/pdfmake.js');
    let pdfFonts = require('pdfmake/build/vfs_fonts.js');
    let htmlToPdfmake = require('html-to-pdfmake');
    pdfMake.vfs = pdfFonts.pdfMake.vfs;

    let html = htmlToPdfmake(
      this.coverImage + this.sectionOne + this.sectionTwo + 
      this.sectionThree + this.sectionFour + this.sectionFive + 
      this.sectionSix + this.sectionSeven, 
      {
        defaultStyles: {
          h1: {
            color: '#0A5278',
            marginTop: 24,
            marginBottom: 12,
          },
          h2: {
            color: '#0A5278',
            marginTop: 12,
            marginBottom: 8,
          },
          h3: {
            color: '#0A5278',
            marginTop: 12,
            marginBottom: 8,
          },
          h4: {
            color: '#0A5278',
            marginTop: 12,
            marginBottom: 8,
          },
          h5: {
            color: '#0A5278',
            marginTop: 12,
            marginBottom: 8,
          },
          h6: {
            color: '#0A5278',
            marginTop: 12,
            marginBottom: 8,
          }
        }
      }
    );

    this.document = {
      content: [
        html,
      ],
      
      styles: {
        testMIL: {
          color: 'purple',
          width: 4
        }
      },

      pageBreakBefore: function(currentNode) {
        return currentNode.style && currentNode.style.indexOf('pagebreak-before') > -1;
      }
    };

    pdfMake.createPdf(this.document).open();
  }

  getBase64(path: string) {
    // Grab Cover Image Base 64
    this.http.get(path, { responseType: 'blob' })
    .subscribe(blob => {
      const reader = new FileReader();
      const binaryString = reader.readAsDataURL(blob);
      reader.onload = (event: any) => {
        this.coverImage = "<img width='700' src='" + event.target.result + "'>";
      };
      reader.onerror = (event: any) => {
        console.log("File could not be read: " + event.target.error.code);
      };
    });
  }

}