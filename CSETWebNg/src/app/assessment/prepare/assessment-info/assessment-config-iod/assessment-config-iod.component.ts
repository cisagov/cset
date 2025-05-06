import { Component, OnInit } from '@angular/core';
import { AssessmentContactsResponse, AssessmentDetail } from '../../../../models/assessment-info.model';
import { DemographicsIod } from '../../../../models/demographics-iod.model';
import { User } from '../../../../models/user.model';
import { AssessmentService } from '../../../../services/assessment.service';
import { ConfigService } from '../../../../services/config.service';
import { DemographicIodService } from '../../../../services/demographic-iod.service';
import { DemographicService } from '../../../../services/demographic.service';
import { Upgrades } from '../../../../models/assessment-info.model';

@Component({
  selector: 'app-assessment-config-iod',
  templateUrl: './assessment-config-iod.component.html',
  styleUrls: ['./assessment-config-iod.component.scss'],
  standalone: false
})
export class AssessmentConfigIodComponent implements OnInit {
  iodDemographics: DemographicsIod = {};
  demographics: any = {};
  contacts: User[];
  assessment: AssessmentDetail = {};
  IsPCII: boolean = false;
  showUpgrade: boolean = false;
  targetModel: string = '';
  assessorAssessment: boolean;
  globalassessor: boolean;


  constructor(
    private assessSvc: AssessmentService,
    private demoSvc: DemographicService,
    private iodDemoSvc: DemographicIodService,
    private configSvc: ConfigService
  ) { }

  ngOnInit() {
    this.demoSvc.getDemographic().subscribe((data: any) => {
      this.demographics = data;
    });

    this.iodDemoSvc.getDemographics().subscribe((data: any) => {
      this.iodDemographics = data;
      this.refreshContacts();
    });

    this.getAssessmentDetail();

    if (this.configSvc.showAssessmentUpgrade() == true) {
      this.assessSvc.checkUpgrades().subscribe((data: Upgrades) => {
        if (data) {
          this.showUpgrade = !!data;
          this.assessSvc.galleryItemGuid = data.target;
          this.assessSvc.convertToModel = data.name;
        }
      })
    }
    this.configSvc.getCisaAssessorWorkflow().subscribe((resp: boolean) => this.globalassessor = resp);
    this.assessSvc.getAssessorSetting();
    this.assessorAssessment = this.assessSvc.assessmentAssessorMode;
  }

  /**
   * Called every time this page is loaded.
   */
  getAssessmentDetail() {
    this.assessment = this.assessSvc.assessment;
    this.IsPCII = this.assessment.is_PCII;



    this.assessSvc.isBrandNew = false;
    // Null out a 'low date' so that we display a blank
    const assessDate: Date = new Date(this.assessment.assessmentDate);
    if (assessDate.getFullYear() <= 1900) {
      this.assessment.assessmentDate = null;
    }
  }

  /**
   *
   */
  update(e) {
    // default Assessment Name if it is left empty
    if (this.assessment) {
      if (this.assessment.assessmentName.trim().length === 0) {
        this.assessment.assessmentName = '(Untitled Assessment)';
      }
    }
    this.assessSvc.updateAssessmentDetails(this.assessment);
  }

  changeIsPCII(val: boolean) {
    if (this.assessment) {
      this.IsPCII = val;
      this.assessment.is_PCII = val;

      if (!this.assessment.is_PCII) {
        this.assessment.pciiNumber = null;
      }

      this.configSvc.cisaAssessorWorkflow = true;
      this.assessSvc.updateAssessmentDetails(this.assessment);
    }
  }

  isCisaAssessorMode() {
    // IOD means your in CISA Asssessor mode
    return this.configSvc.installationMode == "IOD";
  }

  updateDemographics() {
    this.demoSvc.updateDemographic(this.demographics);
  }

  updateDemographicsIod() {
    this.iodDemoSvc.updateDemographic(this.iodDemographics);
  }

  refreshContacts() {
    if (this.assessSvc.id()) {
      this.assessSvc.getAssessmentContacts().then((data: AssessmentContactsResponse) => {
        this.contacts = data.contactList;
      });
    }
  }

  showCityName() {
    return this.configSvc.behaviors.showCityName;
  }

  showStateName() {
    return this.configSvc.behaviors.showStateName;
  }

  showFacilitator() {
    return this.configSvc.behaviors.showFacilitatorDropDown;
  }

  updateAssessorMode() {
    this.assessorAssessment = !this.assessorAssessment;
    this.assessSvc.setAssessorSetting(this.assessorAssessment).subscribe(() => { });;
  }
}
