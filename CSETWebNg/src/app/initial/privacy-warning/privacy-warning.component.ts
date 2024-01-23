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
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ConfigService } from '../../services/config.service';
import { LayoutService } from '../../services/layout.service';

@Component({
  selector: 'app-privacy-warning',
  templateUrl: './privacy-warning.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class PrivacyWarningComponent implements OnInit {
  BannerText: string;
  CFTEXT: string = "Data collected here is NOT subject to disclosure under Section 286.011 F.S. (Open Meetings) or Chapter 119 F.S. (Public Records), also known as the “Sunshine” law. This data is exempt under Section 282.318(6), F.S. – Portions of risk assessments and other reports of a state agency’s cybersecurity program are confidential and exempt if disclosure would facilitate unauthorized access to or unauthorized modification, disclosure or destruction of data or information as described in the exemption. Disclosure is authorized as provided in the exemption.";
  DOETEXT: string = "This is a Department of Energy (DOE) computer system. DOE computer systems are provided for the processing of official U.S. Government information only.  All data contained within DOE computer systems is owned by DOE and may be audited, intercepted,  recorded, read, copied, or captured in any manner and disclosed in any manner by authorized personnel.  THERE IS NO RIGHT OF PRIVACY IN THIS SYSTEM. System personnel may disclose any potential evidence of   crime found on DOE computer systems to appropriate authorities.  USE OF THIS SYSTEM BY ANY USER, AUTHORIZED OR UNAUTHORIZED, CONSTITUTES CONSENT TO THIS AUDITING,  INTERCEPTION, RECORDING, READING, COPYING, CAPTURING, and DISCLOSURE OF COMPUTER ACTIVITY.";

  /**
   * 
   */
  constructor(
    private router: Router,
    public layoutSvc: LayoutService,
    private configSvc: ConfigService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {

    switch (this.configSvc.galleryLayout) {
      case "CF":
        this.BannerText = this.CFTEXT;
        break;
      default:
        this.BannerText = this.DOETEXT;
    }
  }

  /**
   * 
   */
  accept() {
    sessionStorage.setItem('hasUserAgreedToPrivacyWarning', 'true');
    this.router.navigate(['/home/login'], { queryParamsHandling: "preserve" });
  }

  /**
   * 
   */
  decline() {
    this.router.navigate(['/home/privacy-warning-reject']);
  }

}
