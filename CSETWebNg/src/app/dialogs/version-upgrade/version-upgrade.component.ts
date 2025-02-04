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
import { Component, Inject, Input, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { AssessmentService } from '../../services/assessment.service';
import { NavigationService } from '../../services/navigation/navigation.service';
import { AuthenticationService } from '../../services/authentication.service';
import { DemographicService } from '../../services/demographic.service';
import { DemographicIodService } from '../../services/demographic-iod.service';
import { DemographicsIod } from '../../models/demographics-iod.model';
import { AssessmentContactsResponse, AssessmentDetail, Demographic } from '../../models/assessment-info.model';
import { User } from '../../models/user.model';
import { GalleryService } from '../../services/gallery.service';
import { ConfigService } from '../../services/config.service';
import { MaturityService } from '../../services/maturity.service';

interface GalleryItem {
  gallery_Item_Guid: string;
  icon_File_Name_Small: string | null;
  icon_File_Name_Large: string | null;
  configuration_Setup: string;
  configuration_Setup_Client: string | null;
  description: string;
  title: string;
  parent_Id: number;
  is_Visible: boolean;
  custom_Set_Name: string | null;
}
@Component({
  selector: 'app-version-upgrade',
  templateUrl: './version-upgrade.component.html',
  host: { class: 'd-flex flex-column flex-11a w-100 h-100' }
})
export class VersionUpgradeComponent {

  galleryItem: GalleryItem;
  contacts: User[];
  demographicData: Demographic = {};
  demoExtData: DemographicsIod = {};
  assessment: AssessmentDetail = {
    assessmentName: ''
  };
  selectedLevel: number;
  originalId: number;
  dataToSend: string = 'Hello from Dialog Component';
  loading = false;

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    private dialog: MatDialogRef<VersionUpgradeComponent>,
    public assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public authSvc: AuthenticationService,
    public demoSvc: DemographicService,
    public demoExtSvc: DemographicIodService,
    public gallerySvc: GalleryService,
    public configSvc: ConfigService,
    public maturitySvc: MaturityService,
    public dialogRef: MatDialogRef<VersionUpgradeComponent>
  ) {
    dialogRef.disableClose = true;
  }


  close() {
    return this.dialog.close();
  }

  // Convert draft versions of assessments to final versions 
  async upgrade() {
    this.loading = true;
    this.sendMessage();
    // Get details from original assessment
    let draftDetails = this.assessSvc.assessment
    this.demoSvc.getDemographic().subscribe((data: any) => {
      this.demographicData = data;
    })
    this.assessment = draftDetails;
    this.originalId = this.assessment.id
    this.selectedLevel = this.assessSvc.assessment.maturityModel.maturityTargetLevel
    // Get gallery item to create and begin new target assessment 
    try {
      this.gallerySvc.getGalleryItems(this.configSvc.galleryLayout).subscribe(
        async (resp: any) => {
          rows: for (const row of resp.rows) {
            items: for (const item of row.galleryItems) {
              try {
                const configSetup = JSON.parse(item.configuration_Setup);
                if (configSetup.Model && configSetup.Model.ModelName == this.data.targetModelName) {
                  this.galleryItem = item;
                  break rows;
                }
              } catch (error) {
                console.error("Error parsing configuration_Setup:", error);
              }
            }
          }
          // Get id for newly created assessment
          const newId = await this.assessSvc.newAssessmentGallery(this.galleryItem);
          this.assessment.id = newId
          // Update new assessment with values 
          this.assessSvc.assessment = this.assessment
          this.demoSvc.updateDemographic(this.demographicData);
          this.assessSvc.updateAssessmentDetails(this.assessment);
          this.assessSvc.refreshAssessment();
          this.updateLevel();
          // Fill answers into new assessment from original and then navigate to the new assesment 
          this.assessSvc.convertAssesment(this.originalId, this.data.targetModelName).subscribe((data: any) => {
            this.navSvc.beginAssessment(newId)
            this.loading = false;
            this.close();
          })
        })

    } catch (error) {
      console.error("Error converting assessment:", error);
    }
  }

  sendMessage() {
    this.data.callback();
  }

  updateLevel() {
    this.maturitySvc.saveLevel(this.selectedLevel).subscribe(() => {
      this.navSvc.buildTree();
      return;
    });
  }


}
