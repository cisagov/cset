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
import { CsiService } from '../../../../services/cis-csi.service';
import { CsiDefiningSystem } from './../../../../models/csi.model';
import { AssessmentService } from './../../../../services/assessment.service';
import { CsiServiceComposition } from './../../../../models/csi.model';
import { ConfigService } from './../../../../services/config.service';

@Component({
  selector: 'app-csi-service-composition',
  templateUrl: './csi-service-composition.component.html',
  styleUrls: ['./csi-service-composition.component.scss']
})
export class CsiServiceCompositionComponent implements OnInit {
  serviceComposition: CsiServiceComposition = {};
  definingSystemsList: CsiDefiningSystem[] = [];

  constructor(private csiSvc: CsiService, private assessSvc: AssessmentService, private configSvc: ConfigService) { }

  ngOnInit(): void {
    this.csiSvc.getAllCsiDefiningSystems().subscribe(
      (data: CsiDefiningSystem[]) => {
        this.definingSystemsList = data;
      },
      (error) => {
        console.log('Error getting all CSI defining systems options: ' + (<Error>error).name + (<Error>error).message);
      }
    );

    if (this.assessSvc.id()) {
      this.getCsiServiceComposition();
    }
  }

  // One of the primary defining system checkboxes was clicked; set or remove the primaryDefiningSystem
  primaryDefiningSystemCheckboxChanged(checked: boolean, definingSystem: CsiDefiningSystem) {
    if (checked) {
      this.serviceComposition.primaryDefiningSystem = definingSystem.defining_System_Id;
    } else {
      this.serviceComposition.primaryDefiningSystem = null;

      // Clear other description input if other system is not selected as primary or secondary
      if (
        definingSystem.defining_System_Id === 10 &&
        !this.serviceComposition.secondaryDefiningSystems?.includes(definingSystem.defining_System_Id)
      ) {
        this.serviceComposition.otherDefiningSystemDescription = null;
      }
    }
  }

  // one of the secondary defining systems checkboxes was clicked; set or remove the secondaryDefiningSystem from the list
  secondaryDefiningSystemCheckboxChanged(checked: boolean, definingSystem: CsiDefiningSystem) {
    if (checked) {
      this.serviceComposition.secondaryDefiningSystems.push(definingSystem.defining_System_Id);
    } else {
      this.serviceComposition.secondaryDefiningSystems.splice(
        this.serviceComposition.secondaryDefiningSystems.findIndex((x) => x === definingSystem.defining_System_Id),
        1
      );

      // Clear other description input if other system is not selected as primary or secondary
      if (
        definingSystem.defining_System_Id === 10 &&
        !(this.serviceComposition.primaryDefiningSystem === definingSystem.defining_System_Id)
      ) {
        this.serviceComposition.otherDefiningSystemDescription = null;
      }
    }
  }

  // setting checked values for primary defining system when page loads
  isPrimaryDefiningSystemChecked(definingSystem: CsiDefiningSystem) {
    return this.serviceComposition.primaryDefiningSystem == definingSystem.defining_System_Id;
  }

  // setting checked values for secondary defining system when page loads
  isSecondaryDefiningSystemChecked(definingSystem: CsiDefiningSystem) {
    return this.serviceComposition.secondaryDefiningSystems?.includes(definingSystem.defining_System_Id);
  }

  // check if a primary defining system checkbox should be disabled
  isPrimaryDefiningSystemDisabled(definingSystem: CsiDefiningSystem) {
    return (
      (this.serviceComposition.primaryDefiningSystem &&
        this.serviceComposition.primaryDefiningSystem !== definingSystem.defining_System_Id) ||
      this.serviceComposition.secondaryDefiningSystems?.includes(definingSystem.defining_System_Id)
    );
  }

  // check if a secondary defining system checkbox should be disabled
  isSecondaryDefiningSystemDisabled(definingSystem: CsiDefiningSystem) {
    return (
      this.serviceComposition.primaryDefiningSystem &&
      this.serviceComposition.primaryDefiningSystem === definingSystem.defining_System_Id
    );

  }

  // check if the other defining system description should be disabled
  isOtherDefiningSystemDescriptionDisabled(definingSystem: CsiDefiningSystem) {
    return (
      this.serviceComposition.primaryDefiningSystem != definingSystem.defining_System_Id &&
      !this.serviceComposition.secondaryDefiningSystems?.includes(definingSystem.defining_System_Id)
    );
  }

  update() {
    this.csiSvc.updateCsiServiceComposition(this.serviceComposition);
  }

  getCsiServiceComposition() {
    this.csiSvc.getCsiServiceComposition().subscribe(
      (data: CsiServiceComposition) => {
        this.serviceComposition = data;
      },
      (error) => console.log('CIS CSI service composition load Error: ' + (<Error>error).message)
    );
  }

  showCriticalServiceIdentifyingInfo() {
    return this.configSvc.behaviors.showCriticalService;
  }

  showErrors() {
    return this.configSvc.installationMode === 'IOD';
  }
}
