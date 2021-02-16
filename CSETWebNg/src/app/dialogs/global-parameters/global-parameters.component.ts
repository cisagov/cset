////////////////////////////////
//
//   Copyright 2021 Battelle Energy Alliance, LLC
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
import { Component, OnInit, Inject, AfterViewInit, ViewChildren } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { QuestionsService } from '../../services/questions.service';
import { DefaultParameter } from '../../models/questions.model';

@Component({
  selector: 'app-global-parameters',
  templateUrl: './global-parameters.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: {class: 'd-flex flex-column flex-11a'}
})
export class GlobalParametersComponent implements OnInit {

  defaults: DefaultParameter[];

  @ViewChildren('editValue') editControls: any[];

  constructor(private questionsSvc: QuestionsService,
    public dialogRef: MatDialogRef<GlobalParametersComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any) { }

  ngOnInit() {
    // query the questionsSvc for all default parameters
    this.questionsSvc.getDefaultParametersForAssessment().subscribe((parms: any[]) => {
      this.defaults = [];
      parms.forEach(element => {
        this.defaults.push({
          ParameterName: element.Token,
          ParameterValue: element.Substitution,
          ParameterOrigValue: null,
          ParameterId: element.Id,
          EditMode: false
        });
      });
    });
  }

  edit(p: DefaultParameter) {
    if (!p) { return; }

    p.ParameterOrigValue = p.ParameterValue;

    p.EditMode = true;
    this.defaults.filter(d => d.ParameterId !== p.ParameterId).forEach(d => d.EditMode = false);

    // set focus to the input field for this parameter
    this.editControls.forEach(i => {
      const input = i.nativeElement;
      if (input.id === 'edit-' + p.ParameterId) {
        setTimeout(() => {
          input.focus();
          input.setSelectionRange(0, input.value.length);
        }, 100);
      }
    });
  }

  save(p: DefaultParameter) {
    if (!p) { return; }

    // if the text is unchanged, blank it out so it will be deleted from the database
    if (p.ParameterValue === p.ParameterName) {
      p.ParameterValue = '';
    }

    // push change to API
    this.questionsSvc.storeAssessmentParameter(p).subscribe((result: any) => {
      p.ParameterValue = result.Substitution;
    });

    p.EditMode = false;
  }

  close() {
    this.dialogRef.close();
  }

  handleEnter(e: Event) {
  }
}
