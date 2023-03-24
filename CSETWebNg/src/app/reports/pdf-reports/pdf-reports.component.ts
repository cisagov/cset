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
import html2canvas from 'html2canvas';

@Component({
    selector: 'app-pdf-reports',
    templateUrl: './pdf-reports.component.html',
    styleUrls: ['../reports.scss']
  })

export class PdfReportsComponent implements OnInit, AfterViewChecked {
  // Input Data
  @Input() assessmentInfo;
  @Input() donutData;
  @Input() tableData;

  // Child Data - grabbing HTML of the template for use in the HTML to pdfmake package
  @ViewChild('Cover') divCover: ElementRef
  @ViewChild('One') divOne: ElementRef;
  @ViewChild('Two') divTwo: ElementRef;
  @ViewChild('Three') divThree: ElementRef;
  @ViewChild('Four') divFour: ElementRef;
  @ViewChild('Five') divFive: ElementRef;
  @ViewChild('Six') divSix: ElementRef;
  @ViewChild('Seven') divSeven: ElementRef;

  // Pdf variables
  coverImage: any = null;
  sectionOne: any = null;
  sectionTwo: any = null;
  sectionThree: any = null;
  sectionFour: any = null;
  sectionFive: any = null;
  sectionSix: any = null;
  sectionSeven: any = null;
  document: any = null;
  reportGeneratedDate: Date;

  // Style Variables
  normalSpacing = 12;
  smallSpacing = 6;
  largeSpacing = 24;
  extraLargeSpacing = 36;


  constructor(
    public reportSvc: ReportService,
    private http: HttpClient,
  ) { }

  ngOnInit(): void {
    this.reportGeneratedDate = new Date();
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

    let reportCover = htmlToPdfmake(this.coverImage);
    let reportBody = htmlToPdfmake(
      this.sectionOne + this.sectionTwo + this.sectionThree + 
      this.sectionFour + this.sectionFive + this.sectionSix + this.sectionSeven, 
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
        reportCover,
        reportBody,
      ],
      styles: {
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


  generatePdfTwo() {
    let normalSpacing = 12;
    let smallSpacing = 6;
    let largeSpacing = 24;
    let extraLargeSpacing = 36;
    
    let pdfMake = require('pdfmake/build/pdfmake.js');
    let pdfFonts = require('pdfmake/build/vfs_fonts.js');
    let htmlToPdfmake = require('html-to-pdfmake');
    pdfMake.vfs = pdfFonts.pdfMake.vfs;

    let reportCover = htmlToPdfmake(this.coverImage);

    
    this.document = {
      content: [
        // Cover Image Here
        reportCover,
        { text: '', pageBreak: 'after' },
        
        // Notification Page
        { text: 'Notification', style: 'header', marginBottom: largeSpacing },
        { text: 'This report is provided “as is” for informational purposes only. The Department of Energy (DOE) does not provide any warranties of any kind regarding any information contained within. In no event shall the United States Government or its contractors or subcontractors be liable for any damages, including, but not limited to, direct, indirect, special, or consequential damages and including damages based on any negligence of the United States Government or its contractors or subcontractors, arising out of, resulting from, or in any way connected with this report, whether or not based upon warranty, contract, tort, or otherwise, whether or not injury was sustained from, or arose out of the results of, or reliance upon the report.', marginBottom: normalSpacing},
        { text: 'DOE does not endorse any commercial product or service, including the subject of the analysis in this report. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation, or favoring by the agencies.', marginBottom: normalSpacing},
        { text: 'The display of the DOE official seal or other visual identities on this report shall not be interpreted to provide the recipient organization authorization to use the official seal, insignia, or other visual identities of the Department. The DOE seal, insignia, or other visual identities shall not be used in any manner to imply endorsement of any commercial product or activity by DOE or the United States Government. Use of the DOE seal without proper authorization violates federal law (e.g., 18 U.S.C. §§ 506, 701, 1017), and is against DOE policies governing usage of its seal.', marginBottom: normalSpacing},
        { text: '', pageBreak: 'after' },
        
        // Section 1: Introduction
        { text: '1. Introduction', style: 'header', marginBottom: largeSpacing },
        { text: 'The Cybersecurity Capability Maturity Model (C2M2) can help organizations of all sectors, types, and sizes to evaluate and make improvements to their cybersecurity programs and strengthen their operational resilience. This report presents the results of a C2M2 self-evaluation. The results included in this report may be used to measure and improve an existing cybersecurity program. It also may serve as an input for other activities, such as informing cybersecurity risk managers about the controls in place to mitigate cybersecurity risks within an organization.', marginBottom: normalSpacing },
        { text: 'The results presented in this report are based on participant responses describing the degree to which C2M2 practices are implemented. This report may include sensitive information and should be protected accordingly.', marginBottom: extraLargeSpacing },
        { text: 'Assessment Information: ', marginBottom: largeSpacing },
        { text: 'ASSESSMENT NAME:' },
        { text: this.assessmentInfo?.assessment_Name, marginBottom: largeSpacing },
        { text: 'SELF-EVALUATION DATE:' },
        { text: this.assessmentInfo?.assessment_Date, marginBottom: largeSpacing },
        { text: 'ASSESSOR NAME:' },
        { text: this.assessmentInfo?.assessor_Name, marginBottom: largeSpacing },
        { text: 'This report was generated by CSET® on ' + this.reportGeneratedDate , italics: true }, 
        { text: '', pageBreak: 'after' },
        
        // Section 2: Model Architecture
        { text: '2. Model Architecture', style: 'header', marginBottom: largeSpacing },
        { text: 'The model is organized into 10 domains. Each domain is a logical grouping of cybersecurity practices. The practices within a domain are grouped by objective - target achievements that support the domain. Within each objective, the practices are ordered by maturity indicator levels (MILs).', marginBottom: normalSpacing },
        { text: 'The following section include additional information about the domains and the MILs.' },
        { text: '', pageBreak: 'after' },
        
        // Section 2.1: Domains, Objectives, and Practices
        { text: '2.1 Domains, Objectives, and Practices', style: 'header', marginBottom: largeSpacing },
        { text: 'The C2M2 includes 356 cybersecurity practices, which are grouped into 10 domains. These practices represent the activities an organization can perform to establish and mature capability in the domain. For example, the Asset, Change, and Configuration Management domain is a group of practices that an organization can perform to establish and mature asset management, change management, and configuration management capabilities.', marginBottom: normalSpacing },
        { text: 'The practices within each domain are organized into objectives, which represent achievements that support the domain. For example, the Asset, Change, and Configuration Management domain comprises five objectives:', marginBottom: normalSpacing },
        { text: '',
            ol: [
                'Manage IT and OT Asset Inventory',
                'Manage Information Asset Inventory',
                'Manage IT and OT Asset Configurations',
                'Manage Changes to IT and OT Assets',
                'Management Activities for the ASSET domain',
            ],
            marginBottom: normalSpacing
        },
        { text: 'Each of the objectives in a domain comprises a set of practices, which are ordered by MIL. Figure 1 sumarizes the elements of each domain.', marginBottom: largeSpacing },
        { svg: '<svg width="535" viewBox="0 150 895 444"><title id="MIL_DefinitionTitle">Model Architecture</title><desc id="MIL_DefinitionDesc">Figure 1: Model and Domain Elements. A graphic representation of the Model, Domain and Objective hierarchy and associated Maturity Indicator Levels. Model contains 10 domains. Each domain contains Approach Objectives, one or more, unique to each domain. Approach Objectives are supported by a progression of practices that are unique to the domain. Each domain contains a Management Objective and this is similar in each domain. Each Management Objective is supported by a progression of practices that are similar in each domain and describe institutionalization activities.</desc><path fill="none" stroke="#737373" stroke-width="4" d="M366 440v99a16 16 0 0016 16h32 M366 440v32a16 16 0 0016 16h32 M190 105v300a16 16 0 0016 16h32 M366 172v166a16 16 0 0016 16h32 M366 172v99a16 16 0 0016 16h32 M366 172v32a16 16 0 0016 16h32 M190 105v32a16 16 0 0016 16h32 M64 38v32a16 16 0 0016 16h32"></path><g fill="#FFF" font-weight="bold" text-anchor="middle"><g transform="translate(64 25)"><rect x="-64" y="-25" width="128" height="38" fill="#292929" rx="4"></rect><text>Model</text></g><g transform="translate(190 92)"><rect x="-78" y="-25" width="156" height="38" fill="#4d4d4d" rx="4"></rect><text>Domain</text></g><g transform="translate(366 159)"><rect id="a" x="-128" y="-25" width="256" height="38" fill="#666666" rx="4"></rect><text>Approach Objectives</text></g><g transform="translate(522 226)"><rect id="b" x="-108" y="-25" width="216" height="38" fill="#8c8c8c" rx="4"></rect><text>Practices at MIL1</text></g><g transform="translate(522 293)"><use href="#b"></use><text>Practices at MIL2</text></g><g transform="translate(522 360)"><use href="#b"></use><text>Practices at MIL3</text></g><g transform="translate(366 427)"><use href="#a"></use><text>Management Objectives</text></g><g transform="translate(522 494)"><use href="#b"></use><text>Practices at MIL2</text></g><g transform="translate(522 561)"><use href="#b"></use><text>Practices at MIL3</text></g></g><g fill="currentColor"><text x="294" y="89">Model contains 10 domains</text><text transform="translate(518 149)">(one or more per domain)<tspan x="0" dy="19">Unique to each domain</tspan></text><text transform="translate(654 264)">Approach objectives are<tspan x="0" dy="19">supported by a progression of</tspan><tspan x="0" dy="19">practices that are unique to</tspan><tspan x="0" dy="19">the domain</tspan></text><text transform="translate(518 417)">(one per domain)<tspan x="0" dy="19">Similar in each domain</tspan></text><text transform="translate(654 489)">Each management objective<tspan x="0" dy="19">is supported by a progression</tspan><tspan x="0" dy="19">of practices that are similar in</tspan><tspan x="0" dy="19">each domain and describe</tspan><tspan x="0" dy="19">institutionalization activities</tspan></text></g></svg>' },
        { text: 'Figure 1: Model and Domain Elements', style: 'caption', marginTop: -85, pageBreak: 'after' },
        { text: 'For each domain, this report provides a purpose statement, which is a high-level summary of the intent of the domain. Further guidance for each of the domains, such as introductory discussions and example scenarios is provided in the C2M2 V2.1 model document.', marginBottom: normalSpacing },
        { text: 'The purpose statement for each of the 10 domains follows in the order in which the domains appear in the model and in this report. Next to each of the domain names, a short name is provided that is used throughout the model.', marginBottom: largeSpacing },
        
        { text: 'Domain: Asset, Change, and Configuration Management (ASSET)', style: 'subHeader', marginBottom: smallSpacing },
        { text: 'Manage the organization\'s IT and OT assets, including both hardware and software, and information assets commensurate with the risk to critical infrastructure and organizational objectives.', marginBottom: largeSpacing },
        { text: 'Domain: Threat and Vulnerability Management (THREAT)', style: 'subHeader', marginBottom: smallSpacing },
        { text: 'Establish and maintain plans, procedures, and technologies to detect, identify, analyze, manage, and respond to cybersecurity threats and vulnerabilities, commensurate with the risk to the organization\'s infrastructure (such as critical, IT, and operational) and organizational objectives.', marginBottom: largeSpacing },
        { text: 'Domain: Risk Management (RISK)', style: 'subHeader', marginBottom: smallSpacing },
        { text: 'Establish, operate, and maintain an enterprise cyber risk management program to identify, analyze, and respond to cyber risk the organization is subject to, including its business units, subsidiaries, related interconnected infrastructure, and stakeholders.', marginBottom: largeSpacing },
        { text: 'Domain: Identify and Access Management (ACCESS)', style: 'subHeader', marginBottom: smallSpacing },
        { text: 'Create and manage identities for entities that may be granted logical or physical access to the organization\'s assets. Control access to the organization\'s assets, commensurate with the risk to critical infrastructure and organizational objectives.', marginBottom: largeSpacing },
        { text: 'Domain: Situational Awareness (SITUATION)', style: 'subHeader', marginBottom: smallSpacing },
        { text: 'Establish and maintain activities and technologies to collect, monitor, analyze, alarm, report, and use operational, security, and threat information, including status and summary information from the other model domains, to establish situational awareness for both the organization\'s operational state and cybersecurity state.', marginBottom: largeSpacing },
        { text: 'Domain: Event and Incident Response, Continuity of Operations (RESPONSE)', style: 'subHeader', marginBottom: smallSpacing },
        { text: 'Establish and maintain plans, procedures, and technologies to detect, analyze, mitigate, respond to, and recover from cybersecurity events and incidents and to sustain operations during cybersecurity incidents, commensurate with the risk to critical infrastructure and organizational objectives', marginBottom: largeSpacing },
        { text: 'Domain: Third-Party Risk Management (THIRD-PARTIES)', style: 'subHeader', marginBottom: smallSpacing },
        { text: 'Establish and maintain controls to manage the cyber risks arising from suppliers and other third parties, commensurate with the risk to critical infrastructure and organizational objectives.', marginBottom: largeSpacing },
        { text: 'Domain: Workforce Management (WORKFORCE)', style: 'subHeader', marginBottom: smallSpacing },
        { text: 'Establish and maintain plans, procedures, technologies, and controls to create a culture of cybersecurity and to ensure the ongoing suitability and competence of personnel, commensurate with the risk to critical infrastructure and organizational objectives.', marginBottom: largeSpacing },
        { text: 'Domain: Cybersecurity Architecture (ARCHITECTURE)', style: 'subHeader', marginBottom: smallSpacing },
        { text: 'Establish and maintain the structure and behavior of the organization\'s cybersecurity architecture, including controls, processes, technologies, and other elements, commensurate with the risk to critical infrastructure and organizational objectives.', marginBottom: largeSpacing },
        { text: 'Domain: Cybersecurity Program Management (PROGRAM)', style: 'subHeader', marginBottom: smallSpacing },
        { text: 'Establish and maintain an enterprise cybersecurity program that provides governance, strategic planning, and sponsorship for the organization\'s cybersecurity activities in a manner that aligns cybersecurity objectives with both the organization\'s strategic objectives and the risk to critical infrastructure', marginBottom: largeSpacing },
        { text: 'For a more in-depth discussion of the C2M2 domains, refer to the C2M2 V2.1 model document available here: https://energy.gov/C2M2.', pageBreak: 'after' },
        
        // 2.2 Maturity Indicator Levels'
        { text: '2.2 Maturity Indicator Levels', style: 'header', marginBottom: largeSpacing },
        { text: 'The model defines four maturity indicator levels (MILs), MIL0 through MIL3, which apply independently to each domain in the mode. The MILs define a dual progression of maturity: an approach progression and a management progression.', marginBottom: normalSpacing },
        { text: 'Four aspects of the MILs are important for understanding and applying the model: ',
            ul: [
                'The maturity indicator levels apply independently to each domain. As a result, an organization using the model may be operating at different MIL ratings in different domains. For example, an organization could be operating at MIL1 in one domain, MIL2 in another domain, and MIL3 in a third domain',
                'The MILs—MIL0 through MIL3—are cumulative within each domain. To earn a MIL in a given domain, an organization must perform all of the practices in that level and its predecessor level. For example, an organization must perform all of the domain practices in MIL1 and MIL2 to achieve MIL2 in the domain. Similarly, the organization must perform all practices in MIL1, MIL2, and MIL3 to achieve MIL3.',
                'Establishing a target MIL for each domain is an effective strategy for using the model to guide cybersecurity program improvement. Organizations should become familiar with the practices in the model prior to determining target MILs. Then, they can focus gap analysis activities and improvement efforts on achieving those target levels.',
                'Practice performance and MIL achievement need to align with business objectives and the organization\'s cybersecurity program strategy. Striving to achieve the highest MIL in all domains may not be optimal. Companies should evaluate the costs of achieving a specifc MIL versus its potential benefts. However, the model was designed so that all companies, regardless of size, should be able to achieve MIL1 across all domains.',
            ],
            marginBottom: normalSpacing
        },
        { text: 'For a more in-depth discussion of the C2M2 domains, refer to the C2M2 V2.1 model document available here: https://energy.gov/C2M2.', pageBreak: 'after' },
        
        //Section 2.3 Maturity Indicator Level Scoring
        { text: '2.3 Maturity Indicator Level Scoring', style: 'header', marginBottom: largeSpacing },
        { text: 'MIL achievement scores are derived from responses entered into the C2M2 Self-Evaluation Tool. Responses are chosen from a four-point scale: Fully Implemented (FI), Largely Implemented (LI), Partially Implemented (PI), and Not Implemented (NI). A MIL is achieved when all practices in that MIL and all preceding MILs receive responses of Fully Implemented or Largely Implemented. A MIL is not achieved if any practices in that MIL or a preceding MIL have received a response of Partially Implemented or Not Implemented. ', marginBottom: normalSpacing },
        { text: 'In other words, achieving a MIL in a domain requires the following: ',
            ol: [
                'Responses of Fully Implemented or Largely Implemented for all practices in that MIL',
                'Responses of Fully Implemented or Largely Implemented for all practices in the preceding MILs in that domain',
            ],
            marginBottom: normalSpacing
        },
        { text: 'For example, to achieve MIL1 in a domain with four MIL1 practices, all four MIL1 practices have responses of Fully Implemented or Largely Implemented. To achieve MIL2 in that same domain, all MIL1 and MIL2 practices must have responses of Fully Implemented or Largely Implemented.', marginBottom: normalSpacing },
        { text: 'Descriptions for self-evaluation response options are shown in the following table.', marginBottom: normalSpacing },
        { table: {
            headerRows: 1,
            widths: [ '*', 'auto' ],
            body: [
                [ { text: 'Response', bold: true, alignment: 'center' }, { text: 'Implementation Description', bold: true, alignment: 'center' }],
                ['Fully Implemented (FI)', 'Complete'],
                ['Largely Implemented (LI)', 'Complete, but with a recognized opportunity for improvement'],
                ['Partially Implemented (PI)', 'Incomplete; there are multiple opportunities for improvement'],
                ['Not Implemented (NI)', 'Absent; the practice is not performed by the organization'],
                ],
            },
            marginBottom: smallSpacing 
        },
        { text: 'Table 1: Description of Self-Evaluation Response Options', style: 'caption', pageBreak: 'after' }  
    ],

    styles: 
    {
      header: {
        fontSize: 28,
        bold: true,
        color: '#0A5278'
      },
      subHeader: {
        fontSize: 16,
        color: '#0A5278'
      },
      caption: {
        fontSize: 12,
        color: '#0A5278',
        alignment: 'center'
      },
      defaultStyle: {
        fontSize: 12,
      }
    },
  };
  
    pdfMake.createPdf(this.document).open();
  }

}