////////////////////////////////
//
//   Copyright 2018 Battelle Energy Alliance, LLC
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
import { NistSalModel, NistQuestionsAnswers, NistModel, SALLevelNIST, SALLevelNISTC } from './nist-sal.models';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { MatDialog, MatDialogRef } from '@angular/material';
import { SalService } from '../../../../services/sal.service';
import { ConfigService } from '../../../../services/config.service';
import { Sal } from '../../../../models/sal.model';
import { ConfirmComponent } from '../../../../dialogs/confirm/confirm.component';

@Component({
  selector: 'app-sal-nist',
  templateUrl: './sal-nist.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: {class: 'd-flex flex-column flex-11a'}
})
export class SalNistComponent implements OnInit {

  // Sal_Levels: Sal;
  topModel: NistModel;
  dialogRef: MatDialogRef<ConfirmComponent>;


  constructor(private route: ActivatedRoute,
    public salsSvc: SalService,
    public configSvc: ConfigService,
    public dialog: MatDialog) { }

  ngOnInit() {
    // retrieve the existing sal_selection for this assessment
    this.salsSvc.getSalSelection().subscribe(
      (data: Sal) => {
        // this.Sal_Levels = data;
        this.salsSvc.SelectedSAL = data;
      },
      error => {
        console.log('Error Getting all standards: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error Getting all standards: ' + (<Error>error).stack);
      });
    this.salsSvc.getInformationTypes().subscribe(
      (data: NistModel) => {
        this.topModel = data;
      },
      error => {
        console.log('Error Getting all standards: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error Getting all standards: ' + (<Error>error).stack);
      });
  }

  saveLevel(level: string, ltype: string) {
    // this.Sal_Levels.Last_Sal_Determination_Type = 'NIST';
    this.salsSvc.SelectedSAL.Last_Sal_Determination_Type = 'NIST';
    switch (ltype) {
      case 'C': {
        // this.Sal_Levels.SelectedSALOverride = false;
        // this.Sal_Levels.CLevel = level;

        this.salsSvc.SelectedSAL.SelectedSALOverride = false;
        this.salsSvc.SelectedSAL.CLevel = level;
        break;
      }
      case 'I': {
        // this.Sal_Levels.SelectedSALOverride = false;
        // this.Sal_Levels.ILevel = level;

        this.salsSvc.SelectedSAL.SelectedSALOverride = false;
        this.salsSvc.SelectedSAL.ILevel = level;
        break;
      }
      case 'A': {
        // this.Sal_Levels.SelectedSALOverride = false;
        // this.Sal_Levels.ALevel = level;

        this.salsSvc.SelectedSAL.SelectedSALOverride = false;
        this.salsSvc.SelectedSAL.ALevel = level;
        break;
      }
      default: {
        this.salsSvc.SelectedSAL.SelectedSALOverride = true;
        this.salsSvc.SelectedSAL.Selected_Sal_Level = level;
        break;
      }
    }

    this.salsSvc.updateStandardSelection(this.salsSvc.SelectedSAL).subscribe(
      (data: Sal) => {
        // this.Sal_Levels = data;
        this.salsSvc.SelectedSAL = data;
      },
      error => {
        console.log('Error setting sal level: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error setting sal level: ' + (<Error>error).stack);
      });
  }

  changeSpecialFactor(model: NistSalModel, ciaType: string) {
    const cToFullType = { 'C': 'Confidentiality', 'I': 'Integrity', 'A': 'Availability' };

    // confirm that they want to overwrite the special factor text
    this.dialogRef = this.dialog.open(ConfirmComponent, { disableClose: false });
    this.dialogRef.componentInstance.confirmMessage =
      'This will overwrite the current '
      + cToFullType[ciaType]
      + ' special factor text.  Do you want to continue?';

    this.dialogRef.afterClosed().subscribe(result => {
      if (result) {
        // overwrite the text
        this.overwriteSpecialFactorText(model, ciaType);
      }
      this.dialogRef = null;
    });
  }

  /**
   * Replaces the designated special factor text with a default value.
   * @param model
   * @param ciaType
   */
  overwriteSpecialFactorText(model, ciaType) {
    // then pull the special factor off the question and push it to the text box.
    // then that should hopefully initiate a change and cause the special factor to post and save
    switch (ciaType) {
      case 'C':
        this.topModel.specialFactors.Confidentiality_Special_Factor = model.Confidentiality_Special_Factor;
        break;
      case 'I':
        this.topModel.specialFactors.Integrity_Special_Factor = model.Integrity_Special_Factor;
        break;
      case 'A':
        this.topModel.specialFactors.Availability_Special_Factor = model.Availability_Special_Factor;
        break;
    }
    this.specialFactor();
  }

  specialFactor() {
    // NOTE" this is crappy because I am setting the
    // SALValue to 0 so I can ignore it.

    this.topModel.specialFactors.Confidentiality_Value = {
      SALName: this.salsSvc.SelectedSAL.CLevel,
      SALValue: 0
    };

    this.topModel.specialFactors.Integrity_Value = {
      SALName: this.salsSvc.SelectedSAL.ILevel,
      SALValue: 0
    };
    this.topModel.specialFactors.Availability_Value = {
      SALName: this.salsSvc.SelectedSAL.ALevel,
      SALValue: 0
    };
    this.salsSvc.updateNistSpecialFactors(this.topModel.specialFactors)
      .subscribe(response => {
        this.salsSvc.SelectedSAL = response;
      });
  }

  /**
   * Persists a yes/no answer to a question.
   * @param answer
   * @param newValue
   */
  saveQuestionChanged(answer: NistQuestionsAnswers, newValue: string) {
    answer.Question_Answer = newValue;
    this.salsSvc.updateNistDataQuestions(answer)
      .subscribe(response => {
        this.salsSvc.SelectedSAL = response;
      });
  }


  checkBoxChanged(e, selectedSal: NistSalModel) {
    if (e.target.checked) {
      if (this.topModel.selectedInfoTypes) {
        this.topModel.selectedInfoTypes.concat(selectedSal);
      }
    } else {
      if (this.topModel.selectedInfoTypes) {
        const index: number = this.topModel.selectedInfoTypes.indexOf(selectedSal);
        if (index !== -1) {
          this.topModel.selectedInfoTypes.splice(index);
        }
      }
    }
    selectedSal.Selected = e.target.checked;
    this.salsSvc.updateSal(selectedSal)
      .subscribe(response => {
        this.salsSvc.SelectedSAL = response;
      });
  }

  /**
   * Returns the svg imagepath to render the gauge
   * that corresponds to the specified level.
   * @param level
   */
  getImagePath(level: string): string {
    const lev = this.salsSvc.levels.find(l => l.value === level);
    if (lev != null) {
      return lev.imagepath;
    }
    return '';
  }
}
