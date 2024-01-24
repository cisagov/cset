import { ConfigService } from './../../services/config.service';
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
import { EnableFeatureService } from './../../services/enable-feature.service';
import { Component, OnInit } from '@angular/core';
import { MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-enable-protected',
  templateUrl: './enable-protected.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})

export class EnableProtectedComponent implements OnInit {

  modulesList: EnabledModule[];
  message: any;
  enableFeatureButtonClick: boolean = false;
  cisaWorkflowEnabled: boolean = false;
  cisaWorkflowStatusLoaded: boolean = false;

  constructor(private dialog: MatDialogRef<EnableProtectedComponent>,
    private featureSvc: EnableFeatureService,
    private configSvc: ConfigService) { }

  /**
   *
   */
  ngOnInit() {
    this.featureSvc.getEnabledFeatures().subscribe(enabledModules => {
      this.modulesList = enabledModules;
    });

    this.configSvc.getCisaAssessorWorkflow().subscribe((cisaWorkflowEnabled: boolean) => {
      this.configSvc.cisaAssessorWorkflow = cisaWorkflowEnabled;
      this.cisaWorkflowEnabled = cisaWorkflowEnabled;
      this.cisaWorkflowStatusLoaded = true;
    });
  }

  /**
   *
   */
  anyModulesLocked() {
    return (this.modulesList && this.modulesList.some(m => !m.unlocked));
  }

  /**
   *
   */
  allModulesUnlocked() {
    return (this.modulesList && this.modulesList.length > 0 && this.modulesList.every(m => m.unlocked));
  }

  showCisaAssessorWorkflowSwitch() {
    return this.configSvc.behaviors.showCisaAssessorWorkflowSwitch;
  }

  /**
   *
   */
  enableModules() {
    this.featureSvc.enableModules().subscribe(m => {
      this.featureSvc.sendEvent(true);

      this.message = m;
      this.featureSvc.getEnabledFeatures().subscribe(enabledModules => this.modulesList = enabledModules);

      this.enableFeatureButtonClick = true;
    });
  }

  toggleCisaAssessorWorkflow() {
    this.cisaWorkflowEnabled = !this.cisaWorkflowEnabled;
  }

  /**
   *
   */
  close() {
    return this.dialog.close({ enableFeatureButtonClicked: this.enableFeatureButtonClick, cisaWorkflowEnabled: this.cisaWorkflowEnabled });
  }
}

export interface EnabledModule {
  shortName: string;
  fullName: string;
  unlocked: boolean;
}
