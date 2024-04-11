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
import { ConfigService } from '../../services/config.service';

@Component({
  selector: 'app-logo-for-reports',
  templateUrl: './logo-for-reports.component.html'
})
export class LogoForReportsComponent implements OnInit {
  sourceImage = '';
  LogoAlt = '';
  heightStyle = '7rem';

  showRaster = true;
  showVector = false;

  constructor(
    public configSvc: ConfigService
  ) { }

  ngOnInit(): void {
    if (this.configSvc.installationMode == 'TSA') {
      this.sourceImage = 'assets/images/TSA/tsa_insignia_rgbtransparent.png';
      this.LogoAlt = "TSA Logo";
    }
    else if (this.configSvc.installationMode == 'ACET') {
      this.sourceImage = 'assets/images/ACET/ACET_shield_only.png';
      this.LogoAlt = "ACET Logo";
    }
    else if (this.configSvc.installationMode == 'RENEW') {
      // hide the PNG and show the SVG
      this.showVector = true;
      this.showRaster = false;
    }
    else {
      this.sourceImage = 'assets/images/CISA_Logo_183px.png';
      this.LogoAlt = "CISA Logo";
    }

    if (this.sourceImage.length > 0) {
      this.showRaster = true;
      this.showVector = false;
    }
  }

}
