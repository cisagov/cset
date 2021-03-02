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
import { Component, OnInit } from '@angular/core';
import { SetBuilderService } from '../../services/set-builder.service';
import { SetDetail } from '../../models/set-builder.model';
import { Router } from '@angular/router';
import {MatDialog, MatDialogModule} from '@angular/material/dialog';
import { ModuleAddCloneComponent } from '../module-add-clone/module-add-clone.component';

@Component({
  selector: 'app-set-detail',
  templateUrl: './set-detail.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class CustomSetComponent implements OnInit {

  setDetail: SetDetail = {};

  submitted = false;

  constructor(public setBuilderSvc: SetBuilderService,
    private router: Router,
    public dialog: MatDialog) { }

  ngOnInit() {
    const setName = sessionStorage.getItem('setName');
    this.setBuilderSvc.getSetDetail(setName).subscribe((response) => {
      this.setDetail = response;
      sessionStorage.setItem('setName', this.setDetail.SetName);
    });
  }

  update(e: Event) {
    this.setBuilderSvc.updateSetDetails(this.setDetail).subscribe();
  }

  /**
   * Ideally this should ensure that the Description exists, but 
   */
  isSetReady() {
    if (!this.setDetail) {
      return false;
    }
    if (!this.setDetail.SetName) {
      return false;
    }
    if (!this.setDetail.FullName || this.setDetail.FullName.length === 0
      || !this.setDetail.ShortName || this.setDetail.ShortName.length === 0
      || !this.setDetail.Description || this.setDetail.Description.length === 0) {
      return false;
    }
    return true;
  }

  navReqList() {
    // validate
    this.submitted = true;
    if (!this.isSetReady()) {
      return;
    }

    this.setBuilderSvc.navReqList();
  }

  navQuestionList() {
    // validate
    this.submitted = true;
    if (!this.isSetReady()) {
      return;
    }

    this.setBuilderSvc.navQuestionList();
  }

  showSetClone(){
    let dialogRef = this.dialog.open(ModuleAddCloneComponent, {
      data: {setName:this.setDetail.SetName},
      maxHeight: '1000px',
      position: {top:'25px'}
    });
  }
}
